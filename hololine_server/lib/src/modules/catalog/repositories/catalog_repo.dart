import 'package:hololine_server/src/generated/protocol.dart';
import 'package:serverpod/server.dart';

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
}
