import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/repositories/workspace_repository.dart';
import 'package:serverpod/serverpod.dart';

/// [WorkspaceCleanupJob] is responsible for performing hard deletes on workspaces
/// that have been soft deleted and their grace period has expired.
class CleanupEndpoint extends Endpoint {
  static final WorkspaceRepo _workspaceRepository = WorkspaceRepo();

  /// [checkAndPerformHardDeletes] is the main method that checks for workspaces
  /// that are pending deletion and performs the hard delete if their
  /// `pendingDeletionUntil` timestamp is in the past.
  Future<void> checkAndPerformHardDeletes(Session session) async {
    // Log the start of the hard delete check.
    session.log(
      'WorkspaceCleanupJob: Starting hard delete check',
      level: LogLevel.info,
    );

    try {
      // First, fetch all workspaces that are marked for deletion.
      // This query retrieves workspaces where the `pendingDeletionUntil` field is not null,
      // indicating they are in the soft-deleted state.
      final workspacesPendingDelete = await Workspace.db.find(
        session,
        where: (w) => w.pendingDeletionUntil.notEquals(null),
      );

      // Then, filter this list in-memory to find workspaces where the deletion date has passed.
      // This uses the current UTC time to compare against the `pendingDeletionUntil` timestamp.
      final now = DateTime.now().toUtc();
      final workspacesToHardDelete = workspacesPendingDelete
          .where((w) => w.pendingDeletionUntil!.isBefore(now))
          .toList(); // Convert the filtered Iterable to a List.

      if (workspacesToHardDelete.isEmpty) {
        session.log(
          'WorkspaceCleanupJob: No workspaces to delete',
          level: LogLevel.info,
        );
        return;
      }

      int deletedCount = 0;
      // Iterate through the workspaces that are ready for hard deletion.
      // For each workspace, call the `hardDeleteWorkspace` method to permanently delete it.
      for (var workspace in workspacesToHardDelete) {
        session.log(
          'WorkspaceCleanupJob: Deleting workspace ID: ${workspace.id}',
          level: LogLevel.info,
        );
        await _workspaceRepository.hardDeleteWorkspace(session, workspace.id!);
        deletedCount++;
      }

      // Log the successful deletion of workspaces.
      session.log(
        'WorkspaceCleanupJob: Successfully deleted $deletedCount workspace(s)',
        level: LogLevel.info,
      );
    } catch (e, stackTrace) {
      // Log any errors that occur during the hard delete process.
      session.log(
        'WorkspaceCleanupJob: Failed to perform hard deletes',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
