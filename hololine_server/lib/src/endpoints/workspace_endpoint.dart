import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/usecase/workspace_service.dart';
import 'package:serverpod/serverpod.dart';

/// Manages workspace-related operations such as creation, member management,
/// and invitations. All endpoints require user authentication.
class WorkspaceEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  final WorkspaceService _service = WorkspaceService();

  /// Creates a new standalone workspace.
  ///
  /// A standalone workspace does not have a parent. The authenticated user
  /// will become the owner of this new workspace.
  ///
  /// - [name]: The name of the workspace.
  /// - [description]: A description for the workspace.
  ///
  /// Returns the newly created [Workspace].
  /// Throws an [Exception] if the user is not authenticated or if creation fails.
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

  /// Creates a new child workspace under a specified parent.
  ///
  /// The authenticated user must have permissions to create a child workspace
  /// under the given [parentWorkspaceId].
  ///
  /// - [name]: The name of the new child workspace.
  /// - [parentWorkspaceId]: The ID of the parent workspace.
  /// - [description]: A description for the new workspace.
  ///
  /// Returns the newly created child [Workspace].
  /// Throws an [Exception] if the user is not authenticated or if creation fails.
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

  /// Updates the role of a member within a workspace.
  ///
  /// The authenticated user must have the necessary permissions to modify member roles.
  ///
  /// - [memberId]: The ID of the member whose role is to be updated.
  /// - [workspaceId]: The ID of the workspace where the member belongs.
  /// - [role]: The new [WorkspaceRole] to assign to the member.
  ///
  /// Returns a [Response] object indicating success or failure.
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

  /// Removes a member from a workspace.
  ///
  /// The authenticated user must have permissions to remove members from the
  /// specified [workspaceId].
  ///
  /// - [memberId]: The ID of the member to remove.
  /// - [workspaceId]: The ID of the workspace from which to remove the member.
  ///
  /// Returns a [Response] object indicating success or failure.
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

  /// Sends an invitation to a user to join a workspace.
  ///
  /// The authenticated user must have permissions to invite members to the
  /// specified [workspaceId].
  ///
  /// - [email]: The email address of the user to invite.
  /// - [workspaceId]: The ID of the workspace to invite the user to.
  /// - [role]: The [WorkspaceRole] to assign to the user upon joining.
  ///
  /// Returns a [Response] object indicating success or failure.
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

  /// Accepts a workspace invitation using an invitation token.
  ///
  /// The authenticated user will be added to the workspace associated with the
  /// invitation [token].
  ///
  /// - [token]: The unique invitation token.
  ///
  /// Returns a [Response] object indicating success or failure.
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

  /// Archives a workspace, making it inactive.
  ///
  /// The authenticated user must have the necessary permissions to archive the
  /// specified [workspaceId].
  ///
  /// - [workspaceId]: The ID of the workspace to archive.
  ///
  /// Returns a [Response] object indicating success or failure.
  Future<Response> archiveWorkspace(
    Session session,
    int workspaceId,
  ) async {
    var user = (await session.authenticated)?.userId;

    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _service.archiveWorkspace(session, workspaceId, user);
      return Response(
        success: true,
        message: 'Workspace archived successfully',
      );
    } catch (e) {
      return Response(
        success: false,
        error: 'Failed to archive workspace: ${e.toString()}',
      );
    }
  }

  /// Restores an archived workspace.
  ///
  /// The authenticated user must have the necessary permissions to restore the
  /// specified [workspaceId].
  ///
  /// - [workspaceId]: The ID of the workspace to restore.
  ///
  /// Returns a [Response] object indicating success or failure.
  Future<Response> restoreWorkspace(
    Session session,
    int workspaceId,
  ) async {
    var user = (await session.authenticated)?.userId;

    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _service.restoreWorkspace(session, workspaceId, user);
      return Response(
        success: true,
        message: 'Workspace restored successfully',
      );
    } catch (e) {
      return Response(
        success: false,
        error: 'Failed to restore workspace: ${e.toString()}',
      );
    }
  }

  /// Transfers ownership of a workspace to another member.
  ///
  /// The authenticated user must be the current owner of the workspace.
  ///
  /// - [workspaceId]: The ID of the workspace.
  /// - [newOwnerId]: The ID of the member who will become the new owner.
  ///
  /// Returns a [Response] object indicating success or failure.
  /// Throws an [Exception] if the user is not authenticated.
  Future<Response> transferOwnership(
    Session session,
    int workspaceId,
    int newOwnerId,
  ) async {
    var user = (await session.authenticated)?.userId;

    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      await _service.transferOwnership(session, workspaceId, newOwnerId, user);
      return Response(
        success: true,
        message: 'Ownership transferred successfully',
      );
    } catch (e) { 
      return Response(
        success: false,
        error: 'Failed to transfer ownership: ${e.toString()}',
      );
    }
  }
}
