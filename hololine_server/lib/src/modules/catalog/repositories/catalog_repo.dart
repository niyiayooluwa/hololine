import 'package:hololine_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

class CatalogRepo {
  /// Counts total catalog items in a workspace.
  Future<int> countByWorkspaceId(Session session, int workspaceId) async {
    return await Catalog.db.count(
      session,
      where: (t) => t.workspaceId.equals(workspaceId),
    );
  }

  /// Finds the most recently added catalog item in a workspace.
  Future<Catalog?> findLastByWorkspaceId(Session session, int workspaceId) async {
    return await Catalog.db.findFirstRow(
      session,
      where: (t) => t.workspaceId.equals(workspaceId),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Finds a single catalog item by its primary key.
  Future<Catalog?> findById(Session session, int catalogId) async {
    return await Catalog.db.findById(session, catalogId);
  }

  /// Checks if a SKU already exists within a workspace, ignoring a specific catalog ID (for updates).
  Future<bool> isSkuTaken(Session session, String sku, int workspaceId, {int? excludeCatalogId}) async {
    final count = await Catalog.db.count(
      session,
      where: (t) {
        var expr = t.workspaceId.equals(workspaceId) & t.sku.equals(sku);
        if (excludeCatalogId != null) {
          expr = expr & t.id.notEquals(excludeCatalogId);
        }
        return expr;
      },
    );
    return count > 0;
  }

  /// Lists all active catalog items for a workspace, ordered by newest first.
  Future<List<Catalog>> listProducts(Session session, int workspaceId) async {
    return await Catalog.db.find(
      session,
      where: (t) => t.workspaceId.equals(workspaceId) & t.status.notEquals('discontinued'),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }

  /// Inserts a new catalog item within a transaction.
  Future<Catalog> insertWithTransaction(
    Session session,
    Catalog catalog,
    Transaction transaction,
  ) async {
    return await Catalog.db.insertRow(session, catalog, transaction: transaction);
  }

  /// Updates an existing catalog item, optionally within a transaction.
  Future<Catalog> update(Session session, Catalog catalog, {Transaction? transaction}) async {
    return await Catalog.db.updateRow(session, catalog, transaction: transaction);
  }

  /// Fetches the UserInfo for the given userId.
  Future<UserInfo?> getUserInfo(Session session, int userId) async {
    return await UserInfo.db.findById(session, userId);
  }

  /// Fetches multiple catalog records by their IDs within a workspace.
  Future<List<Catalog>> findByIds(
    Session session,
    List<int> catalogIds,
    int workspaceId,
  ) async {
    return await Catalog.db.find(
      session,
      where: (t) =>
          t.workspaceId.equals(workspaceId) &
          t.id.inSet(catalogIds.toSet()),
    );
  }
}
