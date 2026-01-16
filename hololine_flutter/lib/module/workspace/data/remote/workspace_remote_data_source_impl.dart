import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/core/application/providers.dart';
import 'package:hololine_flutter/module/workspace/data/remote/workspace_remote_data_source.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WorkspaceRemoteDataSourceImpl implements WorkspaceRemoteDataSource {
  final Client _client;

  /// Creates an instance of [AuthRemoteDataSourceImpl].
  ///
  /// Requires a [serverpodClient] to interact with the backend.
  WorkspaceRemoteDataSourceImpl({required Client serverpodClient})
      : _client = serverpodClient;

  // ===========================================================================
  // CREATION
  // ===========================================================================
  @override
  Future<Workspace> createStandaloneWorkspace(
    String name,
    String description,
  ) async {
    return await _client.workspace.createStandalone(
      name,
      description,
    );
  }

  @override
  Future<Workspace> createChildWorkspace(
    String name,
    String description,
    int parentId,
  ) async {
    return await _client.workspace.createChild(
      name,
      parentId,
      description,
    );
  }

  // ===========================================================================
  // READ OPERATIONS
  // ===========================================================================
  @override
  Future<Workspace> getWorkspaceDetails(
    int workspaceId,
  ) async {
    return await _client.workspace.getWorkspaceDetails(
      workspaceId: workspaceId,
    );
  }

  @override
  Future<List<Workspace>> getMyWorkspaces() async {
    return await _client.workspace.getMyWorkspaces();
  }

  @override
  Future<List<Workspace>> getChildWorkspaces(
    int parentWorkspaceId,
  ) async {
    return await _client.workspace.getChildWorkspaces(
      parentWorkspaceId: parentWorkspaceId,
    );
  }

  // ===========================================================================
  // MEMBER MANAGEMENT
  // ===========================================================================
  @override
  Future<WorkspaceMember> updateMemberRole(
    int memberId,
    int workspaceId,
    WorkspaceRole role,
  ) async {
    return await _client.workspace.updateMemberRole(
      memberId: memberId,
      workspaceId: workspaceId,
      role: role,
    );
  }

  @override
  Future<WorkspaceMember> removeMember(
    int memberId,
    int workspaceId,
  ) async {
    return await _client.workspace.removeMember(
      memberId: memberId,
      workspaceId: workspaceId,
    );
  }

  @override
  Future<WorkspaceMember> leaveWorkspace(
    int workspaceId,
  ) async {
    return await _client.workspace.leaveWorkspace(
      workspaceId: workspaceId,
    );
  }

  // ===========================================================================
  // INVITATIONS
  // ===========================================================================
  @override
  Future<WorkspaceInvitation> inviteMember(
    String email,
    int workspaceId,
    WorkspaceRole role,
  ) async {
    return await _client.workspace.inviteMember(
      email,
      workspaceId,
      role,
    );
  }

  @override
  Future<WorkspaceMember> acceptInvitation(
    String invitationCode,
  ) async {
    return await _client.workspace.acceptInvitation(
      invitationCode,
    );
  }

  // ===========================================================================
  // UPDATE / ARCHIVE / DELETE
  // ===========================================================================
  @override
  Future<Workspace> updateWorkspaceDetails(
    int workspaceId,
    String? name,
    String? description,
  ) async {
    return await _client.workspace.updateWorkspaceDetails(
      workspaceId: workspaceId,
    );
  }

  @override
  Future<Workspace> archiveWorkspace(
    int workspaceId,
  ) async {
    return await _client.workspace.archiveWorkspace(
      workspaceId,
    );
  }

  @override
  Future<Workspace> restoreWorkspace(
    int workspaceId,
  ) async {
    return await _client.workspace.restoreWorkspace(
      workspaceId,
    );
  }

  @override
  Future<bool> transferOwnership(
    int workspaceId,
    int newOwnerId,
  ) async {
    return await _client.workspace.transferOwnership(
      workspaceId,
      newOwnerId,
    );
  }

  @override
  Future<Workspace> initiateDeleteWorkspace(
    int workspaceId,
  ) async {
    return await _client.workspace.initiateDeleteWorkspace(
      workspaceId,
    );
  }
}

final workspaceRemoteDataSourceProvider =
    Provider<WorkspaceRemoteDataSource>((ref) {
  final client = ref.watch(clientProvider);
  return WorkspaceRemoteDataSourceImpl(serverpodClient: client);
});
