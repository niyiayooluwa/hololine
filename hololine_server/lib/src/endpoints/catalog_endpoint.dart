import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/modules/catalog/repositories/catalog_repo.dart';
import 'package:hololine_server/src/modules/catalog/repositories/inventory_repo.dart';
import 'package:hololine_server/src/modules/catalog/usecase/catalog_service.dart';
import 'package:hololine_server/src/modules/workspace/repositories/member_repo.dart';
import 'package:hololine_server/src/utils/authenticated_endpoint.dart';
import 'package:serverpod/server.dart';

class CatalogEndpoint extends AuthenticatedEndpoint {
  final MemberRepo _memberRepo = MemberRepo();
  final CatalogRepo _catalogRepo = CatalogRepo();
  final InventoryRepo _inventoryRepo = InventoryRepo();
  late final CatalogService _catalogService =
      CatalogService(_catalogRepo, _inventoryRepo, _memberRepo);

  Future<Catalog> createProduct(
    Session session, {
    required int workspaceId,
    required Catalog catalogData,
  }) async {
    return runAuthenticated(session, 'createProduct', (userId) async {
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
    return runAuthenticated(session, 'listProducts', (userId) async {
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
    return runAuthenticated(session, 'updateProduct', (userId) async {
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
    return runAuthenticated(session, 'archiveProduct', (userId) async {
      await _catalogService.archiveProduct(
          session, workspaceId, catalogId, userId);
    });
  }
}
