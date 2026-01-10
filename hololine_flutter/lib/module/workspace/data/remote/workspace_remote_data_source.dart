import 'package:hololine_client/hololine_client.dart';

abstract class WorkspaceRemoteDataSource {
  // ===========================================================================
  // CREATION
  // ===========================================================================

  Future<Workspace> createStandaloneWorkspace(
    String name,
    String description,
  );

  Future<Workspace> createChildWorkspace(
    String name,
    String description,
    int parentId,
  );

  // ===========================================================================
  // READ OPERATIONS
  // ===========================================================================
  Future<Workspace> getWorkspaceDetails(
    int workspaceId,
  );

  Future<List<Workspace>> getMyWorkspaces();

  Future<List<Workspace>> getChildWorkspaces(
    int parentWorkspaceId,
  );

  // ===========================================================================
  // MEMBER MANAGEMENT
  // ===========================================================================
  Future<WorkspaceMember> updateMemberRole(
    int memberId,
    int workspaceId,
    WorkspaceRole role,
  );

  Future<WorkspaceMember> removeMember(
    int memberId,
    int workspaceId,
  );

  Future<WorkspaceMember> leaveWorkspace(
    int workspaceId,
  );

  // ===========================================================================
  // INVITATIONS
  // ===========================================================================
  Future<WorkspaceInvitation> inviteMember(
    String email,
    int workspaceId,
    WorkspaceRole role,
  );

  Future<WorkspaceMember> acceptInvitation(
    String invitationCode,
  );

  // ===========================================================================
  // UPDATE / ARCHIVE / DELETE
  // ===========================================================================
  Future<Workspace> updateWorkspaceDetails(
    int workspaceId,
    String? name,
    String? description,
  );

  Future<Workspace> archiveWorkspace(
    int workspaceId,
  );

  Future<Workspace> restoreWorkspace(
    int workspaceId,
  );

  Future<bool> transferOwnership(
    int workspaceId,
    int newOwnerId,
  );

  Future<Workspace> initiateDeleteWorkspace(
    int workspaceId,
  );
}
