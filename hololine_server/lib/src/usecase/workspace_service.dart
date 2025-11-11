import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/services/email_service.dart';
import 'package:hololine_server/src/utils/permissions.dart';
import 'package:hololine_server/src/utils/token_generator.dart';
import 'package:serverpod/serverpod.dart';
import 'package:hololine_server/src/repositories/workspace_repository.dart';

/// Service class for managing workspace operations including creation,
/// member management, and invitations.
class WorkspaceService {
  final WorkspaceRepo _workspaceRepository = WorkspaceRepo();

  /// Creates a new standalone workspace with the given [name] and [description].
  ///
  /// The [userId] becomes the owner of the newly created workspace.
  /// Standalone workspaces have no parent workspace.
  ///
  /// Returns the created [Workspace] with its assigned ID and initial owner.
  ///
  /// Throws an [Exception] if a workspace with the same name already exists
  /// for this owner.
  Future<Workspace> createStandalone(
    Session session,
    String name,
    int userId,
    String description,
  ) async {
    var newWorkspace = Workspace(
      name: name,
      description: description,
      createdAt: DateTime.now().toUtc(),
    );

    return await _workspaceRepository.create(
      session,
      newWorkspace,
      userId,
    );
  }

  /// Creates a new child workspace under the specified [parentWorkspaceId].
  ///
  /// The [userId] must be an active admin or owner of the parent workspace.
  /// Child workspaces inherit permissions from their parent and cannot
  /// themselves become parents.
  ///
  /// Returns the created child [Workspace].
  ///
  /// Throws an [Exception] if the user lacks permissions, the parent workspace
  /// doesn't exist, or the parent is itself a child workspace.
  Future<Workspace> createChild(
    Session session,
    String name,
    int userId,
    int parentWorkspaceId,
    String description,
  ) async {
    var member = await _workspaceRepository.findMemberByWorkspaceId(
      session,
      userId,
      parentWorkspaceId,
    );

    if (member == null) {
      throw Exception('User is not a member of the parent workspace');
    }

    if (!member.isActive) {
      throw Exception('Permission denied. Your membership is inactive');
    }

    var hasPermission = member.role == WorkspaceRole.owner ||
        member.role == WorkspaceRole.admin;

    if (!hasPermission) {
      throw Exception('Permission denied. Insufficient role');
    }

    var parentWorkspace = await _workspaceRepository.findWorkspaceById(
      session,
      parentWorkspaceId,
    );

    if (parentWorkspace == null) {
      throw Exception('Parent workspace not found');
    }

    if (parentWorkspace.parentId != null) {
      throw Exception('A child workspace cannot become a parent');
    }

    var newChildWorkspace = Workspace(
      name: name,
      description: description,
      parentId: parentWorkspaceId,
      createdAt: DateTime.now().toUtc(),
    );

    return await _workspaceRepository.create(
      session,
      newChildWorkspace,
      userId,
    );
  }

  /// Updates the [role] of a workspace member identified by [memberId].
  ///
  /// The [actorId] must have sufficient permissions to change roles according
  /// to the [RolePolicy]. Owners cannot change their own role, and there must
  /// always be at least one active owner in the workspace.
  ///
  /// Throws an [Exception] if the actor or target member is not found,
  /// lacks permissions, or if the operation would leave the workspace
  /// without an owner.
  Future<void> updateMemberRole(
    Session session, {
    required int memberId,
    required int workspaceId,
    required WorkspaceRole role,
    required int actorId,
  }) async {
    var actor = await _workspaceRepository.findMemberByWorkspaceId(
        session, actorId, workspaceId);
    var member = await _workspaceRepository.findMemberByWorkspaceId(
        session, memberId, workspaceId);

    if (actor == null) {
      throw Exception('Actor is not a member of the workspace');
    }

    if (!actor.isActive) {
      throw Exception('Permission denied. Your membership is inactive');
    }

    if (member == null) {
      throw Exception('Target member not found in the workspace');
    }

    if (!member.isActive) {
      throw Exception('Cannot update role of an inactive member');
    }

    if (actorId == memberId && actor.role == WorkspaceRole.owner) {
      throw Exception('Owners cannot change their own role');
    }

    if (!RolePolicy.canUpdateRole(
      actor: actor.role,
      target: member.role,
      newRole: role,
    )) {
      throw Exception('Permission denied. Insufficient privileges');
    }

    await _workspaceRepository.updateMemberRole(
      session,
      memberId,
      role,
      workspaceId,
    );
  }

  /// Removes a member from the workspace by deactivating their membership.
  ///
  /// The [actorId] must have permission to manage members and cannot remove
  /// themselves from the workspace.
  ///
  /// Throws an [Exception] if the actor lacks permissions, the target member
  /// is not found, or if the actor attempts to remove themselves.
  Future<void> removeMember(
    Session session, {
    required int memberId,
    required int workspaceId,
    required int actorId,
  }) async {
    var actor = await _workspaceRepository.findMemberByWorkspaceId(
        session, actorId, workspaceId);
    var member = await _workspaceRepository.findMemberByWorkspaceId(
        session, memberId, workspaceId);

    if (actor == null) {
      throw Exception('Actor is not a member of the workspace');
    }

    if (!actor.isActive) {
      throw Exception('Permission denied. Your membership is inactive');
    }

    if (member == null) {
      throw Exception('Target member not found in the workspace');
    }

    if (actorId == memberId) {
      throw Exception('You cannot remove yourself from the workspace');
    }

    if (!RolePolicy.canManageMembers(actor.role)) {
      throw Exception('Permission denied. Insufficient privileges');
    }

    await _workspaceRepository.deactivateMember(session, memberId, workspaceId);
  }

  /// Invites a user to join the workspace by sending an email invitation.
  ///
  /// The [email] receives an invitation with a unique token that expires
  /// after 7 days. If an existing invitation for this email exists and has
  /// expired, it will be deleted and a new one created.
  ///
  /// The [actorId] must have permission to manage members in the workspace.
  ///
  /// Throws an [Exception] if the workspace is not found, the actor lacks
  /// permissions, the user is already a member, a valid invitation already
  /// exists, or if email delivery fails.
  Future<void> inviteMember(
    Session session,
    String email,
    int workspaceId,
    WorkspaceRole role,
    int actorId,
  ) async {
    var workspace = await _workspaceRepository.findWorkspaceById(
      session,
      workspaceId,
    );

    if (workspace == null) {
      throw Exception('Workspace not found');
    }

    final workspaceName = workspace.name;

    // Verify Permissions
    final actor = await _workspaceRepository.findMemberByWorkspaceId(
      session,
      actorId,
      workspaceId,
    );

    if (actor == null) {
      throw Exception(
          'Action not allowed. You are not a member of this workspace.');
    }

    if (!actor.isActive) {
      throw Exception('Permission denied. Your membership is inactive.');
    }

    if (!RolePolicy.canManageMembers(actor.role)) {
      throw Exception('Permission denied. Insufficient privileges');
    }

    // Check if the user is already a member of the workspace.
    try {
      final existingMember = await _workspaceRepository.findMemberByEmail(
        session,
        email,
        workspaceId,
      );

      if (existingMember != null) {
        throw Exception('This user is already a member of the workspace.');
      }
    } on Exception catch (e) {
      // The repo throws 'User not found' if the email doesn't exist in UserInfo.
      // We can ignore this and proceed with the invitation, as the user can sign up.
      if (e.toString() != 'Exception: User not found') {
        rethrow; // Re-throw other unexpected exceptions.
      }
    }

    // Check for an existing, unaccepted invitation for this email.
    final existingInvitation = await WorkspaceInvitation.db.findFirstRow(
        session,
        where: (invitation) =>
            invitation.inviteeEmail.equals(email) &
            invitation.workspaceId.equals(workspaceId));

    if (existingInvitation != null) {
      final expiryDate = existingInvitation.expiresAt;
      final currentTime = DateTime.now().toUtc();
      final bool isExpired = currentTime.isAfter(expiryDate);

      if (isExpired) {
        await _workspaceRepository.deleteInvitation(
            session, existingInvitation.token);
      } else {
        throw Exception(
            'An invitation has already been sent to this email address.');
      }
    }

    // Generate unique token
    String token;
    int attempts = 0;
    bool isUnique;

    do {
      token = generateCustomToken();
      final existing = await WorkspaceInvitation.db.findFirstRow(
        session,
        where: (invitation) => invitation.token.equals(token),
      );
      isUnique = existing == null;
      attempts++;
    } while (!isUnique && attempts < 10);

    if (!isUnique) {
      throw Exception(
          'Failed to generate a unique invitation token after 10 attempts.');
    }

    final sendEmail = await EmailHandler(session).sendInvitation(
      email,
      token,
      workspaceName,
      role,
    );

    if (!sendEmail) {
      throw Exception('Failed to send invitation email.');
    }

    // Create and store the invitation
    final invitation = WorkspaceInvitation(
      workspaceId: workspaceId,
      inviteeEmail: email,
      inviterId: actorId,
      role: role,
      token: token,
      expiresAt: DateTime.now().toUtc().add(const Duration(minutes: 15)),
    );

    await _workspaceRepository.createInvitation(session, invitation);
  }

  /// Accepts a workspace invitation using a unique [token].
  ///
  /// The authenticated user's email must match the one on the invitation.
  /// This method validates the token, checks for expiration, and ensures the
  /// user is not already a member before adding them to the workspace.
  ///
  /// Throws an [Exception] if the token is invalid, the invitation has expired,
  /// the user is not the intended invitee, or if the user is already a member.
  Future<WorkspaceMember> acceptInvitation(
    Session session,
    String token,
  ) async {
    // Ensure the user is authenticated
    final userId =(await session.authenticated)?.userId;

    // Throw an exception if the user is not authenticated
    if (userId == null) {
      throw Exception('User not authenticated');
    }

    // Find the user's information using their userID
    final user = await UserInfo.db.findById(session, userId);

    // Throw an exception if the user is not found or has no email
    if (user == null || user.email == null) {
      throw Exception('Authenticated user not found or has no email.');
    }
    final userEmail = user.email!;

    // Find the invitation using the provided token
    final invitation = await _workspaceRepository.findInvitationByToken(
      session,
      token,
    );
    // Throw an exception if the invitation is not found
    if (invitation == null) {
      throw Exception('Invalid invitation token.');
    }

    // Check if the invitation has expired and delete it if it has
    if (DateTime.now().toUtc().isAfter(invitation.expiresAt)) {
      await _workspaceRepository.deleteInvitation(session, token);
      throw Exception('Invitation has expired.');
    }

    // Throw an exception is the user's email is not the as the invited email
    if (invitation.inviteeEmail != userEmail) {
      throw Exception('This invitation is for a different user.');
    }

    // Check if the user is a member of the workspace already
    final existingMember = await _workspaceRepository.findMemberByWorkspaceId(
      session,
      userId,
      invitation.workspaceId,
    );

    if (existingMember != null && existingMember.isActive) {
      // If the member is inactive, we can consider reactivating them,
      // but for now, we'll just prevent adding a duplicate.
      await _workspaceRepository.deleteInvitation(session, token);
      throw Exception('You are already a member of this workspace.');
    }

    // Use a transaction to ensure atomicity
    final newMember = await session.db.transaction((transaction) async {
      final member = await _workspaceRepository.acceptInvitation(
        session,
        invitation,
        userId,
      );
      await _workspaceRepository.deleteInvitation(session, token);
      return member;
    });

    return newMember;
  }
}
