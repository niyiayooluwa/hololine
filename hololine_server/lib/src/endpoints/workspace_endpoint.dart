import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/usecase/workspace_service.dart';
import 'package:serverpod/serverpod.dart';

class WorkspaceEndpoint extends Endpoint {
  // Protect every method in this group
  @override
  bool get requireLogin => true;
  final WorkspaceService _service = WorkspaceService();

  /// Create a new standalone workspace and makes the caller the owner.
  Future<Workspace> createStandalone(Session session, String name) async {
    var userId = (await session.authenticated)?.userId;

    if (userId == null) {
      throw Exception('USer not authenticated');
    }

    return await _service.createStandalone(session, name, userId);
  }
}
