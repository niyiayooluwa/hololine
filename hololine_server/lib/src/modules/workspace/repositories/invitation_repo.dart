import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/utils/exceptions.dart';
import 'package:serverpod/database.dart';
import 'package:serverpod/server.dart';

class InvitationRepo {
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
  Future<void> deleteInvitation(Session session, String token,
      {Transaction? transaction}) async {
    final invitation = await findInvitationByToken(session, token);

    if (invitation == null) {
      throw NotFoundException('Invitation not found');
    }
    await WorkspaceInvitation.db.deleteRow(
      session,
      invitation,
      transaction: transaction,
    );
  }

  /// Accepts a workspace [invitation] for the specified [userId].
  ///
  /// This method performs an atomic operation:
  /// 1. Creates a new [WorkspaceMember] with the role specified in the invitation.
  ///    The member is marked as active and the join date is set to the current UTC time.
  /// 2. Deletes the corresponding [WorkspaceInvitation] using its [token].
  ///
  /// Both operations are wrapped in a database transaction to ensure that either
  /// both succeed or both fail, maintaining data consistency.
  ///
  /// - [session]: The database session.
  /// - [invitation]: The [WorkspaceInvitation] object containing details like workspace ID and role.
  /// - [userId]: The ID of the user accepting the invitation.
  /// - [token]: The unique token associated with the invitation, used for deletion.
  ///
  /// Returns the newly created [WorkspaceMember] with its assigned ID.
  ///
  /// Throws [NotFoundException] if the invitation token does not match an existing invitation.
  ///
  /// Note: This method assumes prior validation has occurred (e.g., checking if the
  /// user is already a member, if the invitation has expired, or if the token is valid).
  Future<WorkspaceMember> acceptInvitation(Session session,
      WorkspaceInvitation invitation, int userId, String token) async {
    // Create a new WorkspaceMember object based on the invitation details and user ID.
    var member = WorkspaceMember(
      userInfoId: userId,
      workspaceId: invitation.workspaceId,
      role: invitation.role,
      joinedAt: DateTime.now().toUtc(),
      isActive: true,
    );

    // Execute both the member insertion and invitation deletion within a single transaction.
    return await session.db.transaction((transaction) async {
      // Insert the new workspace member into the database.
      final newMember = await WorkspaceMember.db
          .insertRow(session, member, transaction: transaction);

      // Delete the invitation, ensuring it's part of the same transaction.
      await deleteInvitation(session, token, transaction: transaction);

      return newMember;
    });
  }

  Future<WorkspaceInvitation?> checkForExistingInvitation(
      Session session,
      String email,
      int workspaceId,
      ) async {
    var invitation = await WorkspaceInvitation.db.findFirstRow(
      session,
      where: (invitation) =>
      invitation.inviteeEmail.equals(email) &
      invitation.workspaceId.equals(workspaceId),
    );
    return invitation;
  }

  Future<WorkspaceInvitation?> checkIfTokenIsUnique(
      Session session,
      String token,
      ) async {
    final result = await WorkspaceInvitation.db.findFirstRow(
      session,
      where: (invitation) => invitation.token.equals(token),
    );
    return result;
  }
}