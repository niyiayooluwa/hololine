import 'package:hololine_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class InventoryRepo {
  /// Inserts a new inventory record, optionally within a transaction.
  Future<Inventory> insert(Session session, Inventory inventory, {Transaction? transaction}) async {
    return await Inventory.db.insertRow(session, inventory, transaction: transaction);
  }

  /// Finds the inventory record for a specific catalog item.
  Future<Inventory?> findByCatalogId(Session session, int catalogId) async {
    return await Inventory.db.findFirstRow(
      session,
      where: (t) => t.catalogId.equals(catalogId),
    );
  }

  /// Updates an existing inventory record, optionally within a transaction.
  Future<Inventory> update(Session session, Inventory inventory, {Transaction? transaction}) async {
    return await Inventory.db.updateRow(session, inventory, transaction: transaction);
  }

  /// Lists inventory for a workspace, joined with catalog data using native include.
  Future<List<Inventory>> listWithCatalog(
    Session session,
    int workspaceId, {
    bool includeDiscontinued = false,
  }) async {
    return await Inventory.db.find(
      session,
      where: (t) {
        var expr = t.workspaceId.equals(workspaceId);
        if (!includeDiscontinued) {
          expr = expr & t.catalog.status.notEquals('discontinued');
        }
        return expr;
      },
      include: Inventory.include(catalog: Catalog.include()),
      orderBy: (t) => t.catalog.name,
    );
  }

  /// Lists inventory items where stock is at or below threshold.
  Future<List<Inventory>> getLowStockWithCatalog(Session session, int workspaceId) async {
    return await Inventory.db.find(
      session,
      where: (t) =>
          t.workspaceId.equals(workspaceId) &
          t.lowStockThreshold.notEquals(null) &
          (t.currentQty <= t.lowStockThreshold),
      include: Inventory.include(catalog: Catalog.include()),
      orderBy: (t) => t.catalog.name,
    );
  }

  /// Fetches multiple inventory records for a set of catalogIds within a workspace.
  Future<List<Inventory>> findByCatalogIds(
    Session session,
    List<int> catalogIds,
    int workspaceId,
  ) async {
    return await Inventory.db.find(
      session,
      where: (t) =>
          t.workspaceId.equals(workspaceId) &
          t.catalogId.inSet(catalogIds.toSet()),
    );
  }

  /// Fetches a single inventory row using a raw FOR UPDATE lock within a transaction.
  /// This prevents race conditions when deducting or modifying stock.
  Future<Inventory?> findByCatalogIdForUpdate(
    Session session,
    int catalogId,
    int workspaceId,
    Transaction transaction,
  ) async {
    final result = await session.db.unsafeQuery(
      'SELECT * FROM inventory WHERE "catalogId" = $catalogId AND "workspaceId" = $workspaceId LIMIT 1 FOR UPDATE',
      transaction: transaction,
    );

    if (result.isEmpty) return null;

    final row = result.first;
    return Inventory(
      id: row[0] as int,
      workspaceId: row[1] as int,
      catalogId: row[2] as int,
      currentQty: (row[3] as num).toDouble(),
      availableQty: (row[4] as num).toDouble(),
      totalValue: row[5] as int,
      location: row[6] as String?,
      lowStockThreshold: row[7] != null ? (row[7] as num).toDouble() : null,
      lastRestockedAt: row[8] as DateTime?,
      lastRestockedByName: row[9] as String?,
      lastRestockedById: row[10] as int?,
      lastDeductedAt: row[11] as DateTime?,
      lastDeductedByName: row[12] as String?,
      lastDeductedById: row[13] as int?,
      createdAt: row[14] as DateTime,
      lastModifiedAt: row[15] as DateTime,
    );
  }
}
