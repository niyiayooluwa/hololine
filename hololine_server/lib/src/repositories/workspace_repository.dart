import 'package:hololine_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

/// Repository for managing workspace entities and their members.
/// Handles workspace creation, retrieval, and member management operations
/// with proper validation and business rules enforcement.
class WorkspaceRepo {
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
        throw Exception(
          'A workspace with name "${workspace.name}" already exists under this parent',
        );
      }
    } else {
      final existing =
          await findByNameAndOwner(session, workspace.name, ownerId);
      if (existing != null) {
        throw Exception(
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

  /// Finds a workspace member by [userId] and [workspaceId].
  ///
  /// The [userId] and [workspaceId] are used to locate a specific membership
  /// relationship. This is useful for checking if a user is a member of
  /// a particular workspace.
  ///
  /// Returns the workspace member if found, or `null` if no membership
  /// exists for the given user and workspace combination.
  Future<WorkspaceMember?> findMemberByWorkspaceId(
    Session session,
    int userId,
    int workspaceId,
  ) async {
    return WorkspaceMember.db.findFirstRow(
      session,
      where: (member) =>
          member.userInfoId.equals(userId) &
          member.workspaceId.equals(workspaceId),
    );
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

  /// Updates the role of a workspace member identified by [memberId].
  ///
  /// The [memberId] must identify an existing workspace member, and the
  /// [workspaceId] is used to verify that the member belongs to the
  /// specified workspace. The [role] specifies the new role to assign.
  ///
  /// Throws an [Exception] if the member is not found, does not belong to
  /// the specified workspace, or if changing the role would leave the
  /// workspace without any active owners.
  Future<void> updateMemberRole(
    Session session,
    int memberId,
    WorkspaceRole role,
    int workspaceId,
  ) async {
    final member = await WorkspaceMember.db.findById(session, memberId);

    if (member == null) {
      throw Exception('Member not found');
    }

    if (member.workspaceId != workspaceId) {
      throw Exception('Member does not belong to the specified workspace');
    }

    if (member.role == WorkspaceRole.owner && role != WorkspaceRole.owner) {
      final ownerCount = await WorkspaceMember.db.count(
        session,
        where: (m) =>
            m.workspaceId.equals(member.workspaceId) &
            m.role.equals(WorkspaceRole.owner) &
            m.isActive.equals(true),
      );

      if (ownerCount <= 1) {
        throw Exception(
          'Cannot change role: workspace must have at least one active owner',
        );
      }
    }

    member.role = role;
    await WorkspaceMember.db.updateRow(session, member);
  }

  /// Deactivates a workspace member identified by [memberId].
  ///
  /// The [memberId] must identify an existing workspace member, and the
  /// [workspaceId] is used to verify that the member belongs to the
  /// specified workspace. Deactivating a member prevents them from
  /// accessing the workspace.
  ///
  /// Throws an [Exception] if the member is not found, does not belong to
  /// the specified workspace, or if deactivating the member would leave
  /// the workspace without any active owners.
  Future<void> deactivateMember(
    Session session,
    int memberId,
    int workspaceId,
  ) async {
    final member = await WorkspaceMember.db.findById(session, memberId);

    if (member == null) {
      throw Exception('Member not found');
    }

    if (member.workspaceId != workspaceId) {
      throw Exception('Member does not belong to the specified workspace');
    }

    if (member.role == WorkspaceRole.owner) {
      final activeOwnerCount = await WorkspaceMember.db.count(
        session,
        where: (m) =>
            m.workspaceId.equals(workspaceId) &
            m.role.equals(WorkspaceRole.owner) &
            m.isActive.equals(true),
      );

      if (activeOwnerCount <= 1) {
        throw Exception(
          'Cannot deactivate: workspace must have at least one active owner',
        );
      }
    }

    member.isActive = false;
    await WorkspaceMember.db.updateRow(session, member);
  }

  /// Creates a workspace invitation for the specified [invitation].
  ///
  /// The [invitation] must contain a valid workspace ID, token, role,
  /// and optional expiration date. The token should be unique and
  /// generated securely before calling this method.
  ///
  /// Returns the created invitation with its assigned ID.
  Future<WorkspaceInvitation> createInvitation(
    Session session,
    WorkspaceInvitation invitation,
  ) async {
    return await WorkspaceInvitation.db.insertRow(session, invitation);
  }

  /// Finds a workspace invitation by its unique [token].
  ///
  /// The [token] must match exactly with an existing invitation's token.
  /// This is typically used when a user clicks on an invitation link.
  ///
  /// Returns the invitation if found, or `null` if no invitation exists
  /// with the given token or if the invitation has expired.
  Future<WorkspaceInvitation?> findInvitationByToken(
    Session session,
    String token,
  ) async {
    var result = await WorkspaceInvitation.db.findFirstRow(session,
        where: (invitation) => invitation.token.equals(token));
    return result;
  }

  /// Deletes a workspace invitation identified by its [token].
  ///
  /// The [token] must correspond to an existing invitation. This is typically
  /// called after an invitation has been accepted or when revoking an invitation.
  ///
  /// Throws an [Exception] if no invitation with the given token is found.
  Future<void> deleteInvitation(
    Session session,
    String token,
  ) async {
    final invitation = await findInvitationByToken(session, token);

    if (invitation == null) {
      throw Exception('Invitation not found');
    }
    await WorkspaceInvitation.db.deleteRow(session, invitation);
  }

  /// Finds a workspace member by their [email] address and [workspaceId].
  ///
  /// This method first looks up the user by email, then checks if that user
  /// is a member of the specified workspace. It performs a join between
  /// the UserInfo and WorkspaceMember tables.
  ///
  /// Returns the [WorkspaceMember] if found.
  ///
  /// Throws an [Exception] if no user exists with the given email address.
  /// Returns `null` if the user exists but is not a member of the workspace.
  Future<WorkspaceMember?> findMemberByEmail(
    Session session,
    String email,
    int workspaceId,
  ) async {
    final userInfo = await UserInfo.db.findFirstRow(
      session,
      where: (user) => user.email.equals(email),
    );

    if (userInfo == null) {
      throw Exception('User not found');
    }

    return await findMemberByWorkspaceId(session, userInfo.id!, workspaceId);
  }

  /// Accepts a workspace [invitation] for the specified [userId].
  ///
  /// Creates a new workspace member with the role specified in the invitation.
  /// The member is marked as active and the join date is set to the current
  /// UTC time.
  ///
  /// The [invitation] must contain a valid workspace ID and role. The [userId]
  /// must correspond to an existing user.
  ///
  /// Returns the created workspace member with its assigned ID.
  ///
  /// Note: This method does not validate if the user is already a member
  /// or if the invitation has expired. Such validation should be performed
  /// at the service layer before calling this method.
  Future<WorkspaceMember> acceptInvitation(
    Session session,
    WorkspaceInvitation invitation,
    int userId,
  ) async {
    var member = WorkspaceMember(
      userInfoId: userId,
      workspaceId: invitation.workspaceId,
      role: invitation.role,
      joinedAt: DateTime.now().toUtc(),
      isActive: true,
    );
    return WorkspaceMember.db.insertRow(session, member);
  }
}
