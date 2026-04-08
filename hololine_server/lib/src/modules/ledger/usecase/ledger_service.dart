import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/utils/exceptions.dart';
import 'package:hololine_server/src/utils/permissions.dart';
import 'package:serverpod/server.dart';
import '../../catalog/repositories/catalog_repo.dart';
import '../../catalog/repositories/inventory_repo.dart';
import '../../workspace/repositories/member_repo.dart';
import '../repositories/ledger_repo.dart';
import '../repositories/ledger_line_item_repo.dart';

/// Service that encapsulates all business logic for ledger and transaction
/// management.
///
/// This class is the authoritative source of truth for:
/// - Role-based access control on ledger operations.
/// - Validation of transaction inputs (line items, currencies, stock levels).
/// - Fully atomic transaction creation — catalog and inventory records are
///   mutated together or not at all.
///
/// All raw database access is delegated to the repository layer.
/// This service must never call [Model.db.*] directly.
class LedgerService {
  final LedgerRepo _ledgerRepository;
  final LedgerLineItemRepo _lineItemRepository;
  final CatalogRepo _catalogRepository;
  final InventoryRepo _inventoryRepository;
  final MemberRepo _memberRepository;

  LedgerService(
    this._ledgerRepository,
    this._lineItemRepository,
    this._catalogRepository,
    this._inventoryRepository,
    this._memberRepository,
  );

  /// Asserts that [actorId] is an active member of [workspaceId] and satisfies
  /// [permissionCheck] against their role.
  ///
  /// Throws [PermissionDeniedException] if:
  /// - The actor is not a member of the workspace.
  /// - The actor's membership is inactive.
  /// - The actor's role fails the [permissionCheck].
  Future<WorkspaceMember> _assertMemberPermissions(
    Session session,
    int actorId,
    int workspaceId,
    bool Function(WorkspaceRole) permissionCheck,
  ) async {
    final member = await _memberRepository.findMemberByWorkspaceId(
      session,
      actorId,
      workspaceId,
    );

    if (member == null || !member.isActive) {
      throw PermissionDeniedException('User is not an active member of this workspace.');
    }

    if (!permissionCheck(member.role)) {
      throw PermissionDeniedException('Insufficient privileges for this action.');
    }

    return member;
  }

  /// Creates a fully atomic ledger transaction.
  ///
  /// This is the most critical method in the sprint. Every step runs inside a
  /// single `session.db.transaction()`. If any step throws, the entire
  /// transaction is rolled back and nothing is written to the database.
  ///
  /// ### Processing Order
  ///
  /// 1. **RBAC**: Validates [actorId] can edit the ledger ([RolePolicy.canEditLedger]).
  /// 2. **Input validation**: Ensures [lineItems] is non-empty and all quantities > 0.
  /// 3. **Catalog validation**: Verifies every `catalogId` in [lineItems] exists
  ///    in [workspaceId]. Throws [NotFoundException] if any are missing.
  /// 4. **Currency check**: All catalog entries must share the same currency.
  ///    Throws [CurrencyMismatchException] if they differ.
  /// 5. **Row locking** (inside transaction): For `sale`, `adjustment`, and
  ///    `writeOff`, each inventory row is acquired with `SELECT ... FOR UPDATE`
  ///    to prevent race conditions with concurrent requests.
  /// 6. **Stock check**: For `sale` and `writeOff`, verifies
  ///    `availableQty >= quantity` per line item.
  ///    Throws [InsufficientStockException] including the product name on failure.
  /// 7. **Ledger insert**: Creates the [Ledger] header record (with `totalAmount = 0`
  ///    as a placeholder — updated in step 9).
  /// 8. **Line item insert**: For each item, builds a snapshot of the catalog state
  ///    at this moment (`catalogName`, `catalogSku`, `unitPrice`, `unit`, `currency`).
  ///    Calculates `subtotal = unitPrice * quantity` (in kobo). Sets `position`
  ///    to the item's index in [lineItems].
  /// 9. **Total update**: Sums all subtotals and writes to [Ledger.totalAmount].
  /// 10. **Inventory mutations**: Updates each [Inventory] record based on
  ///     [transactionType]:
  ///     - `sale` / `writeOff`: decreases `currentQty` and `availableQty`.
  ///     - `purchase` / `refund`: increases `currentQty` and `availableQty`.
  ///     - `adjustment`: sets `currentQty` and `availableQty` to the new absolute value.
  ///     Then recalculates `totalValue = currentQty * catalog.price` (in kobo).
  /// 11. **Commit**: All the above steps succeed together. Any exception triggers
  ///     a full rollback.
  ///
  /// Returns the committed [Ledger] record.
  ///
  /// Throws:
  /// - [PermissionDeniedException] — insufficient role.
  /// - [InvalidStateException] — empty line items or quantity <= 0.
  /// - [NotFoundException] — a `catalogId` or inventory record is missing.
  /// - [CurrencyMismatchException] — line items span more than one currency.
  /// - [InsufficientStockException] — `availableQty` < requested `quantity`.
  Future<Ledger> createTransaction(
    Session session, {
    required int workspaceId,
    required int actorId,
    required List<LedgerLineItem> lineItems,
    required TransactionType transactionType,
    required PaymentStatus paymentStatus,
    required DateTime transactionAt,
    String? referenceNumber,
    String? notes,
    String? counterpartyName,
  }) async {
    // 1. RBAC: Members and above can record transactions.
    final actor = await _assertMemberPermissions(
      session,
      actorId,
      workspaceId,
      RolePolicy.canEditLedger,
    );

    // 2. Guard: must have at least one line item with a positive quantity.
    if (lineItems.isEmpty) {
      throw InvalidStateException('A transaction must have at least one line item.');
    }
    for (final item in lineItems) {
      if (item.quantity <= 0) {
        throw InvalidStateException('Quantity must be greater than 0 for all line items.');
      }
    }

    // Fetch actor's display name for audit fields on the inventory records.
    final userInfo = await _catalogRepository.getUserInfo(session, actorId);
    final actorName = userInfo?.userName ?? actor.userInfoId.toString();

    final catalogIds = lineItems.map((item) => item.catalogId).toList();

    // 3. Validate all catalogIds exist within this workspace.
    final catalogs = await _catalogRepository.findByIds(session, catalogIds, workspaceId);
    final catalogMap = {for (final c in catalogs) c.id!: c};

    for (final item in lineItems) {
      if (!catalogMap.containsKey(item.catalogId)) {
        throw NotFoundException(
          'Product with id ${item.catalogId} was not found in this workspace.',
        );
      }
    }

    // 4. All line items must share the same currency. Mixed-currency transactions
    //    are not supported — the caller must split them into separate requests.
    final currencies = catalogMap.values.map((c) => c.currency).toSet();
    if (currencies.length > 1) {
      throw CurrencyMismatchException(
        message: 'All line items must share the same currency. '
            'Split mixed-currency transactions into separate requests.',
        expected: currencies.first,
        found: currencies.skip(1).first,
      );
    }

    final now = DateTime.now();

    // 5–11. Everything below runs inside a single atomic transaction.
    return await session.db.transaction<Ledger>((transaction) async {
      // --- 5. Acquire inventory rows ---
      // For types that modify stock (sale, adjustment, writeOff), lock rows
      // using SELECT FOR UPDATE to serialize concurrent requests. purchase and
      // refund do not need locking because they only increase stock.
      final requiresLock = transactionType == TransactionType.sale ||
          transactionType == TransactionType.adjustment ||
          transactionType == TransactionType.writeOff;

      final inventoryMap = <int, Inventory>{};

      for (final catalogId in catalogIds) {
        if (requiresLock) {
          final inv = await _inventoryRepository.findByCatalogIdForUpdate(
            session,
            catalogId,
            workspaceId,
            transaction,
          );
          if (inv == null) {
            throw NotFoundException(
              'Inventory record not found for product id $catalogId.',
            );
          }
          inventoryMap[catalogId] = inv;
        } else {
          // purchase / refund: no lock needed.
          final inv = await _inventoryRepository.findByCatalogId(session, catalogId);
          if (inv == null) {
            throw NotFoundException(
              'Inventory record not found for product id $catalogId.',
            );
          }
          inventoryMap[catalogId] = inv;
        }
      }

      // --- 6. Stock check for sale and writeOff ---
      // Checked AFTER locking to avoid TOCTOU race conditions.
      if (transactionType == TransactionType.sale ||
          transactionType == TransactionType.writeOff) {
        for (final item in lineItems) {
          final inv = inventoryMap[item.catalogId]!;
          if (inv.availableQty < item.quantity) {
            final catalog = catalogMap[item.catalogId]!;
            throw InsufficientStockException(
              message: 'Insufficient stock for "${catalog.name}". '
                  'Requested: ${item.quantity}, Available: ${inv.availableQty}.',
              catalogId: item.catalogId,
              requested: item.quantity,
              available: inv.availableQty,
            );
          }
        }
      }

      // --- 7. Insert the Ledger header ---
      // totalAmount is written as 0 initially and updated after subtotals are
      // computed in step 9. Both writes happen in the same transaction.
      final ledgerRecord = Ledger(
        workspaceId: workspaceId,
        referenceNumber: referenceNumber,
        transactionType: transactionType,
        paymentStatus: paymentStatus,
        totalAmount: 0,
        notes: notes,
        transactionAt: transactionAt,
        createdByName: actorName,
        createdById: actorId,
        counterpartyName: counterpartyName,
        createdAt: now,
        lastModifiedAt: now,
      );

      final insertedLedger = await _ledgerRepository.insertWithTransaction(
        session,
        ledgerRecord,
        transaction,
      );

      // --- 8. Build and insert LedgerLineItems ---
      // All catalog fields (name, sku, unitPrice, unit, currency) are snapshotted
      // from the catalog record at this exact moment. Future catalog edits will
      // NOT affect this historical record.
      var totalAmount = 0;
      final lineItemsToInsert = <LedgerLineItem>[];

      for (var i = 0; i < lineItems.length; i++) {
        final item = lineItems[i];
        final catalog = catalogMap[item.catalogId]!;

        final unitPrice = catalog.price; // Already in kobo.
        final subtotal = (unitPrice * item.quantity).round(); // kobo
        totalAmount += subtotal;

        lineItemsToInsert.add(LedgerLineItem(
          workspaceId: workspaceId,
          ledgerId: insertedLedger.id!,
          catalogId: item.catalogId,
          catalogName: catalog.name,     // Snapshot
          catalogSku: catalog.sku,       // Snapshot
          unitPrice: unitPrice,          // Snapshot
          quantity: item.quantity,
          unit: catalog.unit,            // Snapshot
          currency: catalog.currency,    // Snapshot
          subtotal: subtotal,
          position: i,                   // Preserves caller's ordering
          createdAt: now,
        ));
      }

      await _lineItemRepository.insertManyWithTransaction(
        session,
        lineItemsToInsert,
        transaction,
      );

      // --- 9. Write the computed totalAmount back to the Ledger header ---
      final finalLedger = insertedLedger.copyWith(totalAmount: totalAmount);
      await _ledgerRepository.updateWithTransaction(session, finalLedger, transaction);

      // --- 10. Mutate each inventory record ---
      for (final item in lineItems) {
        final inv = inventoryMap[item.catalogId]!;
        final catalog = catalogMap[item.catalogId]!;

        Inventory updatedInv;

        switch (transactionType) {
          case TransactionType.sale:
            // Reduces both currentQty and availableQty. Records who deducted.
            updatedInv = inv.copyWith(
              currentQty: inv.currentQty - item.quantity,
              availableQty: inv.availableQty - item.quantity,
              lastDeductedAt: now,
              lastDeductedByName: actorName,
              lastDeductedById: actorId,
              lastModifiedAt: now,
            );

          case TransactionType.purchase:
            // Increases both currentQty and availableQty. Records who restocked.
            updatedInv = inv.copyWith(
              currentQty: inv.currentQty + item.quantity,
              availableQty: inv.availableQty + item.quantity,
              lastRestockedAt: now,
              lastRestockedByName: actorName,
              lastRestockedById: actorId,
              lastModifiedAt: now,
            );

          case TransactionType.refund:
            // Treats returned goods as a restock — increases both qty fields.
            updatedInv = inv.copyWith(
              currentQty: inv.currentQty + item.quantity,
              availableQty: inv.availableQty + item.quantity,
              lastRestockedAt: now,
              lastRestockedByName: actorName,
              lastRestockedById: actorId,
              lastModifiedAt: now,
            );

          case TransactionType.adjustment:
            // Sets both qty fields to the new absolute value specified in
            // [item.quantity]. This is an override, not a delta.
            updatedInv = inv.copyWith(
              currentQty: item.quantity,
              availableQty: item.quantity,
              lastModifiedAt: now,
            );

          case TransactionType.writeOff:
            // Decreases both currentQty and availableQty. Records who deducted.
            // Inventory was already verified to have sufficient stock in step 6.
            updatedInv = inv.copyWith(
              currentQty: inv.currentQty - item.quantity,
              availableQty: inv.availableQty - item.quantity,
              lastDeductedAt: now,
              lastDeductedByName: actorName,
              lastDeductedById: actorId,
              lastModifiedAt: now,
            );
        }

        // Recalculate totalValue using the CURRENT catalog price (not the
        // snapshotted unitPrice). This reflects the present monetary value of
        // physical stock, which floats with price changes by design.
        final newTotalValue = (updatedInv.currentQty * catalog.price).round();
        updatedInv = updatedInv.copyWith(totalValue: newTotalValue);

        await _inventoryRepository.update(session, updatedInv, transaction: transaction);
      }

      // 11. All steps succeeded — transaction commits and returns the ledger.
      return finalLedger;
    });
  }

  /// Returns a list of [Ledger] records for [workspaceId], with optional filters.
  ///
  /// Ordered by [Ledger.transactionAt] descending (most recent first).
  /// All filters are optional and composed with AND logic.
  ///
  /// Requires [actorId] to have at least [RolePolicy.canViewDetails] for the
  /// [workspaceId].
  ///
  /// Throws [PermissionDeniedException] if the actor lacks access.
  Future<List<Ledger>> listTransactions(
    Session session, {
    required int workspaceId,
    required int actorId,
    TransactionType? transactionType,
    DateTime? from,
    DateTime? to,
  }) async {
    await _assertMemberPermissions(session, actorId, workspaceId, RolePolicy.canViewDetails);

    return await _ledgerRepository.list(
      session,
      workspaceId,
      transactionType: transactionType,
      from: from,
      to: to,
    );
  }

  /// Returns a single [Ledger] record with its [lineItems] eagerly loaded.
  ///
  /// Line items are ordered by [LedgerLineItem.position] ascending, preserving
  /// the sequence from the original `createTransaction` call.
  ///
  /// Throws:
  /// - [PermissionDeniedException] — actor lacks [RolePolicy.canViewDetails].
  /// - [NotFoundException] — no ledger exists with [ledgerId].
  /// - [UnauthorizedException] — the ledger exists but belongs to a different workspace.
  Future<Ledger> getTransaction(
    Session session, {
    required int ledgerId,
    required int workspaceId,
    required int actorId,
  }) async {
    await _assertMemberPermissions(session, actorId, workspaceId, RolePolicy.canViewDetails);

    final ledger = await _ledgerRepository.findByIdWithLineItems(session, ledgerId);
    if (ledger == null) {
      throw NotFoundException('Transaction not found.');
    }

    // Explicit workspace scope check — prevents cross-workspace data leaks
    // even if the actor is authenticated and their ledgerId was guessed.
    if (ledger.workspaceId != workspaceId) {
      throw UnauthorizedException(
        'This transaction does not belong to your workspace.',
      );
    }

    return ledger;
  }
}
