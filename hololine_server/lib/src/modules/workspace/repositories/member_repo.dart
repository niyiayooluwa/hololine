import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/utils/exceptions.dart';
import 'package:serverpod/server.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

class MemberRepo {
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
      throw NotFoundException('User not found');
    }

    return await findMemberByWorkspaceId(session, userInfo.id!, workspaceId);
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
      throw NotFoundException('Member not found');
    }

    if (member.workspaceId != workspaceId) {
      throw PermissionDeniedException(
          'Member does not belong to the specified workspace');
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
        throw InvalidStateException(
          'Cannot change role: workspace must have at least one active owner',
        );
      }
    }

    member.role = role;
    await WorkspaceMember.db.updateRow(session, member);
  }

  Future<bool> transferOwnership(
    Session session,
    int workspaceId,
    int actorId,
    int newOwnerId,
  ) async {
    try {
      await session.db.transaction((transaction) async {
        await updateMemberRole(
          session,
          newOwnerId,
          WorkspaceRole.owner,
          workspaceId,
        );
        await updateMemberRole(
          session,
          actorId,
          WorkspaceRole.admin,
          workspaceId,
        );
      });

      return true;
    } catch (e) {
      return false;
    }
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
      throw NotFoundException('Member not found');
    }

    if (member.workspaceId != workspaceId) {
      throw PermissionDeniedException(
          'Member does not belong to the specified workspace');
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
        throw InvalidStateException(
          'Cannot deactivate: workspace must have at least one active owner',
        );
      }
    }

    member.isActive = false;
    await WorkspaceMember.db.updateRow(session, member);
  }
}
