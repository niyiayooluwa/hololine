import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/utils/exceptions.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

/// Repository for managing workspace entities and their members.
/// Handles workspace creation, retrieval, and member management operations
/// with proper validation and business rules enforcement.
class WorkspaceRepo {
  Future<UserInfo?> getUserInfo(Session session, int userId) async {
    return await UserInfo.db.findById(session, userId);
  }

  /// Finds a workspace by its [name] and owner user ID.
  ///
  /// The [name] must match exactly and the [userId] must correspond to a user
  /// with an owner role in the workspace. Searches through all workspaces
  /// where the specified user is an owner and the workspace name matches.
  ///
  /// Returns the found workspace with its members included, or `null` if no
  /// matching workspace is found.
  Future<Workspace?> findByNameAndOwner(
    Session session,
    String name,
    int userId,
  ) async {
    return Workspace.db.findFirstRow(
      session,
      where: (workspace) {
        var nameMatch = workspace.name.equals(name);
        var ownerMatch = workspace.members.any((member) =>
            member.userInfoId.equals(userId) &
            member.role.equals(WorkspaceRole.owner));
        return nameMatch & ownerMatch;
      },
      include: Workspace.include(
        members: WorkspaceMember.includeList(),
      ),
    );
  }

  /// Creates a new [workspace] with the specified [ownerId] as its owner.
  ///
  /// The [workspace] must have a unique name within its context. For root
  /// workspaces (where [workspace.parentId] is `null`), the name must be
  /// unique for the owner. For child workspaces, the name must be unique
  /// under the same parent workspace.
  ///
  /// Returns the created workspace with its assigned ID.
  ///
  /// Throws an [Exception] if a workspace with the same name already exists
  /// for the owner or under the specified parent workspace.
  Future<Workspace> create(
    Session session,
    Workspace workspace,
    int ownerId,
  ) async {
    if (workspace.parentId != null) {
      final exists = await doesChildWorkspaceExist(
        session,
        workspace.name,
        workspace.parentId!,
      );
      if (exists) {
        throw ConflictException(
          'A workspace with name "${workspace.name}" already exists under this parent',
        );
      }
    } else {
      final existing =
          await findByNameAndOwner(session, workspace.name, ownerId);
      if (existing != null) {
        throw ConflictException(
          'A workspace with name "${workspace.name}" already exists',
        );
      }
    }

    return await session.db.transaction((transaction) async {
      var insertedWorkspace = await Workspace.db.insertRow(
        session,
        workspace,
        transaction: transaction,
      );

      var newOwner = WorkspaceMember(
          userInfoId: ownerId,
          workspaceId: insertedWorkspace.id!,
          role: WorkspaceRole.owner,
          joinedAt: DateTime.now().toUtc(),
          isActive: true);

      await WorkspaceMember.db.insertRow(
        session,
        newOwner,
        transaction: transaction,
      );

      return insertedWorkspace;
    });
  }

  /// Finds a workspace by its [workspaceId].
  ///
  /// The [workspaceId] must be a valid workspace identifier. This method
  /// performs a simple lookup by primary key.
  ///
  /// Returns the workspace if found, or `null` if no workspace exists
  /// with the given identifier.
  Future<Workspace?> findWorkspaceById(
    Session session,
    int workspaceId,
  ) async {
    return Workspace.db.findById(
      session,
      workspaceId,
    );
  }

  /// Checks if a child workspace with the given [name] exists under [parentId].
  ///
  /// The [name] is checked for exact match under the specified [parentId].
  /// This is used to enforce unique naming within the same parent workspace.
  ///
  /// Returns `true` if a child workspace with the given name exists under
  /// the parent, `false` otherwise.
  Future<bool> doesChildWorkspaceExist(
    Session session,
    String name,
    int parentId,
  ) async {
    var result = await Workspace.db.findFirstRow(
      session,
      where: (workspace) =>
          workspace.name.equals(name) & workspace.parentId.equals(parentId),
    );
    return result != null;
  }

  /// Archives the workspace with the specified [workspaceId].
  ///
  /// Sets the `archivedAt` field to the current time in UTC.
  /// Returns `true` on success, or `false` if the workspace was not found.
  Future<bool> archiveWorkspace(
    Session session,
    int workspaceId,
  ) async {
    var workspace = await findWorkspaceById(session, workspaceId);

    if (workspace == null) {
      return false;
    }

    workspace.archivedAt = DateTime.now().toUtc();
    await Workspace.db.updateRow(session, workspace);

    return true;
  }

  /// Restores an archived workspace by setting its `archivedAt` timestamp to null.
  ///
  /// This makes the workspace active again.
  /// Returns `true` on success, or `false` if the workspace was not found.
  Future<bool> restoreWorkspace(
    Session session,
    int workspaceId,
  ) async {
    var workspace = await findWorkspaceById(
      session,
      workspaceId,
    );

    if (workspace == null) {
      return false;
    }

    workspace.archivedAt = null;
    await Workspace.db.updateRow(session, workspace);
    return true;
  }

  /// Performs a "hard delete" on a workspace by setting its `deletedAt` timestamp.
  ///
  /// This action is intended to be permanent from the application's perspective,
  /// marking the workspace as fully deleted. This is typically called by a cleanup
  /// job after a soft-delete grace period has expired, or when a workspace is
  /// immediately and permanently removed.
  ///
  /// - [session]: The database session.
  /// - [workspaceId]: The ID of the workspace to permanently delete.
  /// Returns `true` if the workspace was found and marked as deleted, `false` otherwise.
  Future<bool> softDeleteWorkspace(
    Session session,
    int workspaceId,
  ) async {
    var workspace = await findWorkspaceById(session, workspaceId);

    if (workspace == null) return false;

    workspace.pendingDeletionUntil =
        DateTime.now().toUtc().add(Duration(hours: 99));
    await Workspace.db.updateRow(session, workspace);
    return true;
  }

  /// Performs a "hard delete" on a workspace by setting its `deletedAt` timestamp.
  ///
  /// This action is intended to be permanent from the application's perspective,
  /// marking the workspace as fully deleted. This is typically called by a cleanup
  /// job after a soft-delete grace period has expired.
  ///
  /// - [session]: The database session.
  /// - [workspaceId]: The ID of the workspace to permanently delete.
  ///
  /// Returns `true` if the workspace was found and marked as deleted, `false` otherwise.
  Future<bool> hardDeleteWorkspace(
    Session session,
    int workspaceId,
  ) async {
    var workspace = await findWorkspaceById(session, workspaceId);

    if (workspace == null) return false;

    workspace.deletedAt = DateTime.now().toUtc();
    await Workspace.db.updateRow(session, workspace);
    return true;
  }
}
