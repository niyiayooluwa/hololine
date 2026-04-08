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
}
