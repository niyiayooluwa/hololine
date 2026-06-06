import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/core/application/providers.dart';
import 'package:hololine_flutter/feature/workspace/data/remote/workspace_remote_data_source.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:async';

/// Implementation of [WorkspaceRemoteDataSource] that communicates with the
/// Serverpod workspace endpoints.
class WorkspaceRemoteDataSourceImpl implements WorkspaceRemoteDataSource {
  final Client _client;

  WorkspaceRemoteDataSourceImpl({required Client serverpodClient})
    : _client = serverpodClient;

  // ===========================================================================
  // CREATION
  // ===========================================================================

  /// Creates a new standalone, root-level workspace.
  ///
  /// Initializes a workspace with the given [workspaceName] and an optional
  /// [description].
  ///
  /// Returns the newly created [Workspace] object containing server-generated
  /// properties (e.g., ID, timestamps).
  /// Throws an exception if the network request fails or validation errors
  /// occur.
  @override
  FutureOr<Workspace> createWorkspace(
    String workspaceName,
    String description,
  ) async {
    return await _client.workspace.createStandalone(workspaceName, description);
  }

  /// Creates a new child workspace (sub-workspace) nested under an existing
  /// parent.
  ///
  /// Links the new workspace to the parent identified by [parentWorkspaceId].
  /// The [workspaceName] sets the title, and the [description] provides
  /// additional details.
  ///
  /// Returns the newly created [Workspace] object configured as a child.
  /// Throws an exception if the parent does not exist or if the request fails.
  @override
  FutureOr<Workspace> createChildWorkspace(
    String workspaceName,
    int parentWorkspaceId,
    String description,
  ) async {
    return await _client.workspace.createChild(
      workspaceName,
      parentWorkspaceId,
      description,
    );
  }

  // ===========================================================================
  // READ OPERATIONS
  // ===========================================================================

  /// Returns an aggregated dashboard view for a specific workspace.
  ///
  /// Fetches comprehensive dashboard data using the workspace's [publicId].
  /// The resulting [WorkspaceDashboardData] typically includes a snapshot of
  /// member information, recent activities, and a catalog overview.
  @override
  FutureOr<WorkspaceDashboardData> getDashboardData(String publicId) async {
    return await _client.workspace.getDashboardData(publicId: publicId);
  }

  /// Retrieves full details for a single workspace.
  ///
  /// Looks up the workspace matching the unique [publicId] and returns its
  /// complete [Workspace] model.
  /// Throws an exception if no workspace is found matching the given ID.
  @override
  FutureOr<Workspace> getWorkspaceDetails(String publicId) async {
    return await _client.workspace.getWorkspaceDetails(publicId: publicId);
  }

  /// Retrieves a list of all child workspaces belonging to a specific parent.
  ///
  /// Finds all workspaces nested directly under the workspace identified by
  /// [parentWorkspaceId].
  /// Returns an empty list if no child workspaces exist.
  @override
  FutureOr<List<Workspace>> getChildWorkspaces(int parentWorkspaceId) async {
    return await _client.workspace.getChildWorkspaces(
      parentWorkspaceId: parentWorkspaceId,
    );
  }

  // ===========================================================================
  // UPDATE / ARCHIVE / DELETE
  // ===========================================================================

  /// Updates the basic properties of an existing workspace.
  ///
  /// Modifies the workspace identified by [workspaceId]. Only the provided
  /// non-null fields ([name] or [description]) will be updated on the server.
  /// Returns the updated [Workspace] object reflecting the changes.
  @override
  FutureOr<Workspace> updateWorkspaceDetails(
    int workspaceId,
    String? name,
    String? description,
  ) async {
    return await _client.workspace.updateWorkspaceDetails(
      workspaceId: workspaceId,
      name: name,
      description: description,
    );
  }

  /// Archives an active workspace.
  ///
  /// Moves the workspace identified by [workspaceId] into an archived state,
  /// typically hiding it from main views without permanently deleting the data.
  /// Returns the updated [Workspace] object reflecting its new archived status.
  @override
  FutureOr<Workspace> archiveWorkspace(int workspaceId) async {
    return await _client.workspace.archiveWorkspace(workspaceId);
  }

  /// Restores a previously archived workspace.
  ///
  /// Re-activates the workspace identified by [workspaceId], returning it
  /// to normal operation.
  /// Returns the updated [Workspace] object reflecting its restored status.
  @override
  FutureOr<Workspace> restoreWorkspace(int workspaceId) async {
    return await _client.workspace.restoreWorkspace(workspaceId);
  }

  /// Transfers ownership of the workspace to another member.
  ///
  /// Reassigns the primary ownership of the workspace identified by
  /// [workspaceId] to the user identified by [newOwnerId].
  /// Returns `true` if the transfer is successful, otherwise `false`.
  @override
  FutureOr<bool> transferOwnership(int workspaceId, int newOwnerId) async {
    return await _client.workspace.transferOwnership(workspaceId, newOwnerId);
  }

  /// Marks a workspace for deletion after a grace period.
  ///
  /// Initiates a soft-delete process for the workspace identified by
  /// [workspaceId].
  /// The workspace is usually retained for a set period before permanent removal,
  /// allowing for potential recovery.
  /// Returns the updated [Workspace] reflecting its pending deletion state.
  @override
  FutureOr<Workspace> initiateDeleteWorkspace(int workspaceId) async {
    return await _client.workspace.initiateDeleteWorkspace(workspaceId);
  }
}

/// Provider for the WorkspaceRemoteDataSource.
/// It watches [clientProvider] to get the initialized Serverpod client
/// and injects it into the data source implementation.
final workspaceRemoteDataSourceProvider =
    Provider<WorkspaceRemoteDataSource>((ref) {
  final client = ref.watch(clientProvider);
  return WorkspaceRemoteDataSourceImpl(serverpodClient: client);
});
