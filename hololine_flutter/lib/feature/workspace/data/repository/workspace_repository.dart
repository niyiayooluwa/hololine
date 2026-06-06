import 'package:dart_either/dart_either.dart';
import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/core/errors/failures.dart';

/// Defines the contract for a repository that handles workspace-related
/// operations.
///
/// This repository is responsible for coordinating workspace data from remote
/// or local sources and mapping exceptions to [Failure] types.
abstract class WorkspaceRepository {
  // ===========================================================================
  // CREATION
  // ===========================================================================

  /// Creates a new standalone, root-level workspace.
  Future<Either<Failure, Workspace>> createWorkspace(
    String workspaceName,
    String description,
  );

  /// Creates a new child workspace nested under an existing parent.
  Future<Either<Failure, Workspace>> createChildWorkspace(
    String workspaceName,
    int parentWorkspaceId,
    String description,
  );

  // ===========================================================================
  // READ OPERATIONS
  // ===========================================================================

  /// Retrieves an aggregated dashboard view for a specific workspace.
  Future<Either<Failure, WorkspaceDashboardData>> getDashboardData(
    String publicId,
  );

  /// Retrieves full details for a single workspace.
  Future<Either<Failure, Workspace>> getWorkspaceDetails(String publicId);

  /// Retrieves a list of all child workspaces belonging to a specific parent.
  Future<Either<Failure, List<Workspace>>> getChildWorkspaces(
    int parentWorkspaceId,
  );

  // ===========================================================================
  // UPDATE / ARCHIVE / DELETE
  // ===========================================================================

  /// Updates the basic properties of an existing workspace.
  Future<Either<Failure, Workspace>> updateWorkspaceDetails(
    int workspaceId,
    String? name,
    String? description,
  );

  /// Archives an active workspace.
  Future<Either<Failure, Workspace>> archiveWorkspace(int workspaceId);

  /// Restores a previously archived workspace.
  Future<Either<Failure, Workspace>> restoreWorkspace(int workspaceId);

  /// Transfers ownership of the workspace to another member.
  Future<Either<Failure, bool>> transferOwnership(
    int workspaceId,
    int newOwnerId,
  );

  /// Marks a workspace for deletion after a grace period.
  Future<Either<Failure, Workspace>> initiateDeleteWorkspace(int workspaceId);
}
