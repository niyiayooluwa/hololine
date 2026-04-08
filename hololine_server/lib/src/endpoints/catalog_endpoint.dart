import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/modules/catalog/repositories/catalog_repo.dart';
import 'package:hololine_server/src/modules/catalog/repositories/inventory_repo.dart';
import 'package:hololine_server/src/modules/catalog/usecase/catalog_service.dart';
import 'package:hololine_server/src/modules/workspace/repositories/member_repo.dart';
import 'package:hololine_server/src/utils/endpoint_helper.dart';
import 'package:hololine_server/src/utils/exceptions.dart';
import 'package:serverpod/server.dart';

class CatalogEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  final MemberRepo _memberRepo = MemberRepo();
  final CatalogRepo _catalogRepo = CatalogRepo();
  final InventoryRepo _inventoryRepo = InventoryRepo();
  late final CatalogService _catalogService = CatalogService(_catalogRepo, _inventoryRepo, _memberRepo);

  Future<Catalog> createProduct(
    Session session, {
    required int workspaceId,
    required Catalog catalogData,
  }) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) throw AuthenticationException('Not authenticated');

    return runWithLogger(session, 'createProduct', () async {
      return await _catalogService.createProduct(
        session,
        workspaceId: workspaceId,
        catalogData: catalogData,
        actorId: userId,
      );
    });
  }

  Future<List<Catalog>> listProducts(
    Session session, {
    required int workspaceId,
  }) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) throw AuthenticationException('Not authenticated');

    return runWithLogger(session, 'listProducts', () async {
      return await _catalogService.listProducts(session, workspaceId, userId);
    });
  }

  Future<Catalog> updateProduct(
    Session session, {
    required int workspaceId,
    required int catalogId,
    required CatalogUpdateParams catalogUpdates,
    required InventoryUpdateParams inventoryUpdates,
  }) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) throw AuthenticationException('Not authenticated');

    return runWithLogger(session, 'updateProduct', () async {
      return await _catalogService.updateProduct(
        session,
        workspaceId: workspaceId,
        catalogId: catalogId,
        catalogUpdates: catalogUpdates,
        inventoryUpdates: inventoryUpdates,
        actorId: userId,
      );
    });
  }

  Future<void> archiveProduct(
    Session session, {
    required int workspaceId,
    required int catalogId,
  }) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) throw AuthenticationException('Not authenticated');

    return runWithLogger(session, 'archiveProduct', () async {
      await _catalogService.archiveProduct(session, workspaceId, catalogId, userId);
    });
  }
}
