import 'package:hololine_server/src/generated/protocol.dart';
import 'package:serverpod/server.dart';

class ProductRepo {
  /// Counts total products in a workspace.
  Future<int> countByWorkspaceId(Session session, int workspaceId) async {
    return await Product.db.count(
      session,
      where: (t) => t.workspaceId.equals(workspaceId),
    );
  }

  /// Finds the most recently added product in a workspace.
  Future<Product?> findLastByWorkspaceId(Session session, int workspaceId) async {
    return await Product.db.findFirstRow(
      session,
      where: (t) => t.workspaceId.equals(workspaceId),
      orderBy: (t) => t.createdAt,
      orderDescending: true,
    );
  }
}
