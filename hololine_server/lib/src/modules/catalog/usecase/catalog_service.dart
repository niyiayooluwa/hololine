import 'package:hololine_server/src/generated/protocol.dart';
import 'package:serverpod/server.dart';
import '../repositories/catalog_repo.dart';

class CatalogService {
  final CatalogRepo _catalogRepository;

  CatalogService(this._catalogRepository);

  Future<CatalogSnapshot> getCatalogSnapshot(Session session, int workspaceId) async {
    final total = await _catalogRepository.countByWorkspaceId(session, workspaceId);
    final lastCatalog = await _catalogRepository.findLastByWorkspaceId(session, workspaceId);

    return CatalogSnapshot(
      totalItems: total,
      lastProductName: lastCatalog?.name,
      lastProductDate: lastCatalog?.createdAt,
    );
  }
}
