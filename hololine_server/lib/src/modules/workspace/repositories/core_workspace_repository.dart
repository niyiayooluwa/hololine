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

  Future<Workspace?> findWorkspaceByPublicId(
    Session session,
    String publicId,
  ) async {
    return Workspace.db.findFirstRow(
      session,
      where: (workspace) => workspace.publicId.equals(publicId),
      include: Workspace.include(
        members: WorkspaceMember.includeList(),
      ),
    );
  }

  Future<List<Workspace>> findChildWorkspaces(
    Session session,
    int parentId,
  ) async {
    return Workspace.db.find(
      session,
      where: (workspace) => workspace.parentId.equals(parentId),
    );
  }

  Future<Workspace> update(Session session, Workspace workspace) async {
    return Workspace.db.updateRow(
      session,
      workspace
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

  /// Permanently deletes a workspace and all of its related entities.
  Future<void> hardDeleteWorkspace(Session session, int workspaceId) async {
    await session.db.transaction((transaction) async {
      // 1. Unlink child workspaces
      final children = await Workspace.db.find(
        session,
        where: (w) => w.parentId.equals(workspaceId),
        transaction: transaction,
      );
      for (var child in children) {
        child.parentId = null;
        await Workspace.db.updateRow(
          session,
          child,
          transaction: transaction,
        );
      }

      // 2. Delete invitations
      await WorkspaceInvitation.db.deleteWhere(
        session,
        where: (invitation) => invitation.workspaceId.equals(workspaceId),
        transaction: transaction,
      );

      // 3. Delete members
      await WorkspaceMember.db.deleteWhere(
        session,
        where: (member) => member.workspaceId.equals(workspaceId),
        transaction: transaction,
      );

      // 4. Delete the workspace itself
      final workspace = await Workspace.db.findById(
        session,
        workspaceId,
        transaction: transaction,
      );
      if (workspace != null) {
        await Workspace.db.deleteRow(
          session,
          workspace,
          transaction: transaction,
        );
      }
    });
  }
}
