import 'dart:async';
import 'package:hololine_client/hololine_client.dart';

/// Defines the contract for a remote data source that handles workspace
/// actions.
///
/// This abstraction is responsible for all communication with the backend
/// regarding workspace and its activities. Implementing classes should utilize
/// the [Client] from the `hololine_client` to execute these network requests.
abstract class WorkspaceRemoteDataSource {
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
  FutureOr<Workspace> createWorkspace(String workspaceName, String description);

  /// Creates a new child workspace (sub-workspace) nested under an existing
  /// parent.
  ///
  /// Links the new workspace to the parent identified by [parentWorkspaceId].
  /// The [workspaceName] sets the title, and the [description] provides
  /// additional details.
  ///
  /// Returns the newly created [Workspace] object configured as a child.
  /// Throws an exception if the parent does not exist or if the request fails.
  FutureOr<Workspace> createChildWorkspace(
    String workspaceName,
    int parentWorkspaceId,
    String description,
  );

  // ===========================================================================
  // READ OPERATIONS
  // ===========================================================================

  /// Returns an aggregated dashboard view for a specific workspace.
  ///
  /// Fetches comprehensive dashboard data using the workspace's [publicId].
  /// The resulting [WorkspaceDashboardData] typically includes a snapshot of
  /// member information, recent activities, and a catalog overview.
  FutureOr<WorkspaceDashboardData> getDashboardData(String publicId);

  /// Retrieves full details for a single workspace.
  ///
  /// Looks up the workspace matching the unique [publicId] and returns its
  /// complete [Workspace] model.
  /// Throws an exception if no workspace is found matching the given ID.
  FutureOr<Workspace> getWorkspaceDetails(String publicId);

  /// Retrieves a list of all child workspaces belonging to a specific parent.
  ///
  /// Finds all workspaces nested directly under the workspace identified by
  /// [parentWorkspaceId].
  /// Returns an empty list if no child workspaces exist.
  FutureOr<List<Workspace>> getChildWorkspaces(int parentWorkspaceId);

  // ===========================================================================
  // UPDATE / ARCHIVE / DELETE
  // ===========================================================================

  /// Updates the basic properties of an existing workspace.
  ///
  /// Modifies the workspace identified by [workspaceId]. Only the provided
  /// non-null fields ([name] or [description]) will be updated on the server.
  /// Returns the updated [Workspace] object reflecting the changes.
  FutureOr<Workspace> updateWorkspaceDetails(
    int workspaceId,
    String? name,
    String? description,
  );

  /// Archives an active workspace.
  ///
  /// Moves the workspace identified by [workspaceId] into an archived state,
  /// typically hiding it from main views without permanently deleting the data.
  /// Returns the updated [Workspace] object reflecting its new archived status.
  FutureOr<Workspace> archiveWorkspace(int workspaceId);

  /// Restores a previously archived workspace.
  ///
  /// Re-activates the workspace identified by [workspaceId], returning it
  /// to normal operation.
  /// Returns the updated [Workspace] object reflecting its restored status.
  FutureOr<Workspace> restoreWorkspace(int workspaceId);

  /// Transfers ownership of the workspace to another member.
  ///
  /// Reassigns the primary ownership of the workspace identified by
  /// [workspaceId] to the user identified by [newOwnerId].
  /// Returns `true` if the transfer is successful, otherwise `false`.
  FutureOr<bool> transferOwnership(int workspaceId, int newOwnerId);

  /// Marks a workspace for deletion after a grace period.
  ///
  /// Initiates a soft-delete process for the workspace identified by
  /// [workspaceId].
  /// The workspace is usually retained for a set period before permanent removal,
  /// allowing for potential recovery.
  /// Returns the updated [Workspace] reflecting its pending deletion state.
  FutureOr<Workspace> initiateDeleteWorkspace(int workspaceId);
}
