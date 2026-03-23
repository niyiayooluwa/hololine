import 'package:hololine_server/src/generated/protocol.dart';
import 'package:serverpod/server.dart';
import '../repositories/product_repo.dart';

class CatalogService {
  final ProductRepo _productRepository;

  CatalogService(this._productRepository);

  Future<CatalogSnapshot> getCatalogSnapshot(Session session, int workspaceId) async {
    final total = await _productRepository.countByWorkspaceId(session, workspaceId);
    final lastProduct = await _productRepository.findLastByWorkspaceId(session, workspaceId);

    return CatalogSnapshot(
      totalItems: total,
      lastProductName: lastProduct?.name,
      lastProductDate: lastProduct?.createdAt,
    );
  }
}
