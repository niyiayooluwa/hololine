import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/utils/exceptions.dart';
import 'package:hololine_server/src/utils/permissions.dart';
import 'package:serverpod/server.dart';
import '../repositories/catalog_repo.dart';
import '../repositories/inventory_repo.dart';
import '../../workspace/repositories/member_repo.dart';

class CatalogService {
  final CatalogRepo _catalogRepository;
  final InventoryRepo _inventoryRepository;
  final MemberRepo _memberRepository;

  CatalogService(
    this._catalogRepository,
    this._inventoryRepository,
    this._memberRepository,
  );

  /// Validates actor is an active workspace member with sufficient role.
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

  Future<CatalogSnapshot> getCatalogSnapshot(Session session, int workspaceId) async {
    final total = await _catalogRepository.countByWorkspaceId(session, workspaceId);
    final lastCatalog = await _catalogRepository.findLastByWorkspaceId(session, workspaceId);

    return CatalogSnapshot(
      totalItems: total,
      lastProductName: lastCatalog?.name,
      lastProductDate: lastCatalog?.createdAt,
    );
  }

  Future<Catalog> createProduct(
    Session session, {
    required int workspaceId,
    required Catalog catalogData,
    required int actorId,
  }) async {
    // 1. RBAC check
    await _assertMemberPermissions(session, actorId, workspaceId, RolePolicy.canCreateProduct);

    // 2. Fetch actor name via repo
    final userInfo = await _catalogRepository.getUserInfo(session, actorId);
    final actorName = userInfo?.userName ?? 'Unknown User';

    // 3. Validation
    if (catalogData.name.trim().isEmpty) {
      throw InvalidStateException('Product name cannot be empty.');
    }
    if (catalogData.price <= 0) {
      throw InvalidStateException('Product price must be greater than 0.');
    }
    if (catalogData.unit.trim().isEmpty) {
      throw InvalidStateException('Product unit cannot be empty.');
    }

    // 4. SKU uniqueness check
    if (catalogData.sku != null && catalogData.sku!.trim().isNotEmpty) {
      final exists = await _catalogRepository.isSkuTaken(session, catalogData.sku!, workspaceId);
      if (exists) {
        throw DuplicateSkuException(
          message: 'SKU already exists in this workspace.',
          sku: catalogData.sku!,
          workspaceId: workspaceId,
        );
      }
    }

    final now = DateTime.now();

    // 5. Atomic transaction via repos
    return await session.db.transaction<Catalog>((transaction) async {
      final newCatalog = catalogData.copyWith(
        workspaceId: workspaceId,
        addedById: actorId,
        addedByName: actorName,
        createdAt: now,
        lastModifiedAt: now,
        status: 'active',
      );

      final insertedCatalog = await _catalogRepository.insertWithTransaction(
        session,
        newCatalog,
        transaction,
      );

      final initialInventory = Inventory(
        workspaceId: workspaceId,
        catalogId: insertedCatalog.id!,
        currentQty: 0,
        availableQty: 0,
        totalValue: 0,
        createdAt: now,
        lastModifiedAt: now,
      );

      await _inventoryRepository.insert(session, initialInventory, transaction: transaction);

      return insertedCatalog;
    });
  }

  Future<List<Catalog>> listProducts(Session session, int workspaceId, int actorId) async {
    await _assertMemberPermissions(session, actorId, workspaceId, RolePolicy.canViewProducts);

    return await _catalogRepository.listProducts(session, workspaceId);
  }

  Future<Catalog> updateProduct(
    Session session, {
    required int workspaceId,
    required int catalogId,
    required CatalogUpdateParams catalogUpdates,
    required InventoryUpdateParams inventoryUpdates,
    required int actorId,
  }) async {
    // 1. RBAC check
    await _assertMemberPermissions(session, actorId, workspaceId, RolePolicy.canEditProduct);

    // 2. Fetch original catalog via repo
    final currentCatalog = await _catalogRepository.findById(session, catalogId);
    if (currentCatalog == null || currentCatalog.workspaceId != workspaceId) {
      throw NotFoundException('Product not found.');
    }

    if (currentCatalog.status == 'discontinued') {
      throw InvalidStateException('Cannot update an archived product.');
    }

    // 3. SKU resolution
    var newSku = currentCatalog.sku;
    if (catalogUpdates.clearSku) {
      newSku = null;
    } else if (catalogUpdates.sku != null) {
      if (catalogUpdates.sku!.trim().isEmpty) {
        throw InvalidStateException('SKU cannot be an empty string. Use clearSku to remove it.');
      }
      newSku = catalogUpdates.sku;
    }

    if (newSku != null && newSku != currentCatalog.sku) {
      final isTaken = await _catalogRepository.isSkuTaken(
        session,
        newSku,
        workspaceId,
        excludeCatalogId: catalogId,
      );
      if (isTaken) {
        throw DuplicateSkuException(
          message: 'SKU already exists in this workspace.',
          sku: newSku,
          workspaceId: workspaceId,
        );
      }
    }

    // 4. Field validation
    final newPrice = catalogUpdates.price ?? currentCatalog.price;
    if (newPrice <= 0) throw InvalidStateException('Product price must be greater than 0.');

    final newName = catalogUpdates.name ?? currentCatalog.name;
    if (newName.trim().isEmpty) throw InvalidStateException('Product name cannot be empty.');

    final newUnit = catalogUpdates.unit ?? currentCatalog.unit;
    if (newUnit.trim().isEmpty) throw InvalidStateException('Product unit cannot be empty.');

    final updatedCatalog = currentCatalog.copyWith(
      name: newName,
      type: catalogUpdates.type ?? currentCatalog.type,
      sku: newSku,
      unit: newUnit,
      category: catalogUpdates.category ?? currentCatalog.category,
      weight: catalogUpdates.weight ?? currentCatalog.weight,
      minOrderQty: catalogUpdates.minOrderQty ?? currentCatalog.minOrderQty,
      price: newPrice,
      currency: catalogUpdates.currency ?? currentCatalog.currency,
      lastModifiedAt: DateTime.now(),
    );

    // 5. Atomic transaction via repos
    return await session.db.transaction<Catalog>((transaction) async {
      final savedCatalog = await _catalogRepository.update(
        session,
        updatedCatalog,
        transaction: transaction,
      );

      final priceChanged = currentCatalog.price != updatedCatalog.price;
      final inventoryParamsProvided =
          inventoryUpdates.location != null || inventoryUpdates.lowStockThreshold != null;

      if (priceChanged || inventoryParamsProvided) {
        final currentInventory = await _inventoryRepository.findByCatalogId(session, catalogId);
        if (currentInventory != null) {
          var newTotalValue = currentInventory.totalValue;
          if (priceChanged) {
            newTotalValue = (currentInventory.currentQty * updatedCatalog.price).round();
          }

          final updatedInventory = currentInventory.copyWith(
            location: inventoryUpdates.location ?? currentInventory.location,
            lowStockThreshold: inventoryUpdates.lowStockThreshold ?? currentInventory.lowStockThreshold,
            totalValue: newTotalValue,
            lastModifiedAt: DateTime.now(),
          );

          await _inventoryRepository.update(session, updatedInventory, transaction: transaction);
        }
      }

      return savedCatalog;
    });
  }

  Future<void> archiveProduct(Session session, int workspaceId, int catalogId, int actorId) async {
    // 1. RBAC check
    await _assertMemberPermissions(session, actorId, workspaceId, RolePolicy.canEditProduct);

    // 2. Fetch via repo
    final currentCatalog = await _catalogRepository.findById(session, catalogId);
    if (currentCatalog == null || currentCatalog.workspaceId != workspaceId) {
      throw NotFoundException('Product not found.');
    }

    if (currentCatalog.status == 'discontinued') {
      return; // Idempotent
    }

    final archivedCatalog = currentCatalog.copyWith(
      status: 'discontinued',
      lastModifiedAt: DateTime.now(),
    );

    await _catalogRepository.update(session, archivedCatalog);
  }
}
