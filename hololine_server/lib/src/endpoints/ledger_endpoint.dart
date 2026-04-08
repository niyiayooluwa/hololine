import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/modules/catalog/repositories/catalog_repo.dart';
import 'package:hololine_server/src/modules/catalog/repositories/inventory_repo.dart';
import 'package:hololine_server/src/modules/ledger/repositories/ledger_line_item_repo.dart';
import 'package:hololine_server/src/modules/ledger/repositories/ledger_repo.dart';
import 'package:hololine_server/src/modules/ledger/usecase/ledger_service.dart';
import 'package:hololine_server/src/modules/workspace/repositories/member_repo.dart';
import 'package:hololine_server/src/utils/endpoint_helper.dart';
import 'package:hololine_server/src/utils/exceptions.dart';
import 'package:serverpod/server.dart';

/// Serverpod endpoint that exposes ledger operations to the Flutter client.
///
/// Responsibilities of this layer:
/// - Verify the caller is authenticated via [session.authenticated].
/// - Wrap each handler in [runWithLogger] for structured error logging.
/// - Pass the authenticated [userId] to [LedgerService] as [actorId].
///
/// No business logic, permission checks, or database calls live here.
/// All of that is handled by [LedgerService].
class LedgerEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  final MemberRepo _memberRepo = MemberRepo();
  final CatalogRepo _catalogRepo = CatalogRepo();
  final InventoryRepo _inventoryRepo = InventoryRepo();
  final LedgerRepo _ledgerRepo = LedgerRepo();
  final LedgerLineItemRepo _lineItemRepo = LedgerLineItemRepo();

  late final LedgerService _ledgerService = LedgerService(
    _ledgerRepo,
    _lineItemRepo,
    _catalogRepo,
    _inventoryRepo,
    _memberRepo,
  );

  /// Records a new financial transaction against a workspace.
  ///
  /// This is the most critical write operation — the full payload must be
  /// constructed by the caller before calling this method. The server takes
  /// the [lineItems] list and processes it atomically.
  ///
  /// [lineItems] must be pre-populated with [LedgerLineItem.catalogId] and
  /// [LedgerLineItem.quantity]. All other snapshot fields (name, price, etc.)
  /// are captured server-side from the catalog at the time of the transaction.
  ///
  /// [transactionAt] is the business timestamp of the transaction (when it
  /// occurred in the real world), not the server creation time.
  ///
  /// Returns the created [Ledger] on success.
  Future<Ledger> createTransaction(
    Session session, {
    required int workspaceId,
    required List<LedgerLineItem> lineItems,
    required TransactionType transactionType,
    required PaymentStatus paymentStatus,
    required DateTime transactionAt,
    String? referenceNumber,
    String? notes,
    String? counterpartyName,
  }) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) throw AuthenticationException('Not authenticated');

    return runWithLogger(session, 'createTransaction', () async {
      return await _ledgerService.createTransaction(
        session,
        workspaceId: workspaceId,
        actorId: userId,
        lineItems: lineItems,
        transactionType: transactionType,
        paymentStatus: paymentStatus,
        transactionAt: transactionAt,
        referenceNumber: referenceNumber,
        notes: notes,
        counterpartyName: counterpartyName,
      );
    });
  }

  /// Returns a filtered list of [Ledger] records for [workspaceId].
  ///
  /// All filters are optional. Results are sorted by [Ledger.transactionAt]
  /// descending. [workspaceId] is always applied as a mandatory scope.
  Future<List<Ledger>> listTransactions(
    Session session, {
    required int workspaceId,
    TransactionType? transactionType,
    DateTime? from,
    DateTime? to,
  }) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) throw AuthenticationException('Not authenticated');

    return runWithLogger(session, 'listTransactions', () async {
      return await _ledgerService.listTransactions(
        session,
        workspaceId: workspaceId,
        actorId: userId,
        transactionType: transactionType,
        from: from,
        to: to,
      );
    });
  }

  /// Returns a single [Ledger] together with its eagerly loaded [lineItems].
  ///
  /// Line items are ordered by [LedgerLineItem.position] ascending.
  /// Throws [UnauthorizedException] if [ledgerId] does not belong to [workspaceId].
  Future<Ledger> getTransaction(
    Session session, {
    required int ledgerId,
    required int workspaceId,
  }) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) throw AuthenticationException('Not authenticated');

    return runWithLogger(session, 'getTransaction', () async {
      return await _ledgerService.getTransaction(
        session,
        ledgerId: ledgerId,
        workspaceId: workspaceId,
        actorId: userId,
      );
    });
  }
}
