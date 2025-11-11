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
      return await _service.createStandalone(
          session, name, userId, description);
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

  Future<Response> updateMemberRole(
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

      var response = Response(
        success: true,
        message: 'Member role updated',
      );
      return response;
    } catch (e) {
      var response = Response(
        success: false,
        error: 'Failed to update member role: ${e.toString()}',
      );
      return response;
    }
  }

  Future<Response> removeMember(
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

      var response = Response(
        success: true,
        message: 'Member removed',
      );
      return response;
    } catch (e) {
      var response = Response(
        success: false,
        error: 'Failed to remove member: ${e.toString()}',
      );
      return response;
    }
  }

  Future<Response> inviteMember(
    Session session,
    String email,
    int workspaceId,
    WorkspaceRole role,
  ) async {
    var userId = (await session.authenticated)?.userId;

    if (userId == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _service.inviteMember(
        session,
        email,
        workspaceId,
        role,
        userId,
      );

      var response = Response(
        success: true,
        message: 'Member invited',
      );
      return response;
    } catch (e) {
      var response = Response(
        success: false,
        error: 'Failed to invite member: ${e.toString()}',
      );
      return response;
    }
  }

  Future<Response> acceptInvitation(
    Session session,
    String token,
  ) async {
    var userId = (await session.authenticated)?.userId;

    if (userId == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _service.acceptInvitation(session, token);
      return Response(
        success: true,
        message: 'Invitation accepted successfully. Welcome to the workspace!',
      );
    } catch (e) {
      return Response(
        success: false,
        error: 'Failed to accept invitation: ${e.toString()}',
      );
    }
  }
}
