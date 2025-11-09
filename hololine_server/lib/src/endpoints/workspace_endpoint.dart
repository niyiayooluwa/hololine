
import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/usecase/workspace_service.dart';
import 'package:serverpod/serverpod.dart';

class WorkspaceEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;
  
  final WorkspaceService _service = WorkspaceService();

  Future<Workspace> createStandalone(
      Session session, String name, String description) async {
    var userId = (await session.authenticated)?.userId;

    if (userId == null) {
      throw Exception('User not authenticated');
    }

    try {
      return await _service.createStandalone(session, name, userId, description);
    } catch (e) {
      throw Exception('Failed to create workspace: ${e.toString()}');
    }
  }

  Future<Workspace> createChild(
    Session session,
    String name,
    int parentWorkspaceId,
    String description,
  ) async {
    var userId = (await session.authenticated)?.userId;

    if (userId == null) {
      throw Exception('User not authenticated');
    }

    try {
      return await _service.createChild(
        session,
        name,
        userId,
        parentWorkspaceId,
        description,
      );
    } catch (e) {
      throw Exception('Failed to create child workspace: ${e.toString()}');
    }
  }

  Future<void> updateMemberRole(
    Session session, {
    required int memberId,
    required int workspaceId,
    required WorkspaceRole role,
  }) async {
    var userId = (await session.authenticated)?.userId;

    if (userId == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _service.updateMemberRole(
        session,
        memberId: memberId,
        workspaceId: workspaceId,
        role: role,
        actorId: userId,
      );
    } catch (e) {
      throw Exception('Failed to update member role: ${e.toString()}');
    }
  }

  Future<void> removeMember(
    Session session, {
    required int memberId,
    required int workspaceId,
  }) async {
    var userId = (await session.authenticated)?.userId;

    if (userId == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _service.removeMember(
        session,
        memberId: memberId,
        workspaceId: workspaceId,
        actorId: userId,
      );
    } catch (e) {
      throw Exception('Failed to remove member: ${e.toString()}');
    }
  }
}