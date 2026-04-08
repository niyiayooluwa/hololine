import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/modules/catalog/repositories/inventory_repo.dart';
import 'package:hololine_server/src/modules/inventory/usecase/inventory_service.dart';
import 'package:hololine_server/src/modules/workspace/repositories/member_repo.dart';
import 'package:hololine_server/src/utils/endpoint_helper.dart';
import 'package:hololine_server/src/utils/exceptions.dart';
import 'package:serverpod/server.dart';

/// Serverpod endpoint providing API access to inventory and stock levels.
class InventoryEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  final InventoryRepo _inventoryRepo = InventoryRepo();
  final MemberRepo _memberRepo = MemberRepo();

  late final InventoryService _inventoryService = InventoryService(
    _inventoryRepo,
    _memberRepo,
  );

  /// Returns a list of all inventory records for the given [workspaceId],
  /// joined with their corresponding catalog data.
  Future<List<Inventory>> listInventory(
    Session session, {
    required int workspaceId,
    bool includeDiscontinued = false,
  }) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) throw AuthenticationException('Not authenticated');

    return runWithLogger(session, 'listInventory', () async {
      return await _inventoryService.listInventory(
        session,
        workspaceId: workspaceId,
        actorId: userId,
        includeDiscontinued: includeDiscontinued,
      );
    });
  }

  /// Returns inventory items that are at or below their low stock threshold.
  Future<List<Inventory>> getLowStockItems(
    Session session, {
    required int workspaceId,
  }) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) throw AuthenticationException('Not authenticated');

    return runWithLogger(session, 'getLowStockItems', () async {
      return await _inventoryService.getLowStockItems(
        session,
        workspaceId: workspaceId,
        actorId: userId,
      );
    });
  }

  /// Updates the [lowStockThreshold] for a specific catalog product.
  Future<void> updateThreshold(
    Session session, {
    required int workspaceId,
    required int catalogId,
    double? threshold,
  }) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) throw AuthenticationException('Not authenticated');

    return runWithLogger(session, 'updateThreshold', () async {
      await _inventoryService.updateThreshold(
        session,
        workspaceId: workspaceId,
        catalogId: catalogId,
        threshold: threshold,
        actorId: userId,
      );
    });
  }
}
