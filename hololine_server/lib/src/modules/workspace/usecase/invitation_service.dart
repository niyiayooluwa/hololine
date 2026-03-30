import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/services/email_service.dart';
import 'package:hololine_server/src/utils/exceptions.dart';
import 'package:hololine_server/src/utils/permissions.dart';
import 'package:hololine_server/src/utils/token_generator.dart';
import 'package:serverpod/server.dart';

import '../repositories/repositories.dart';

class InvitationService {
  final WorkspaceRepo _workspaceRepository;
  final MemberRepo _memberRepository;
  final InvitationRepo _invitationRepository;
  final EmailHandler _emailHandler;


  InvitationService(
    this._workspaceRepository,
    this._memberRepository,
    this._invitationRepository,
    this._emailHandler
  );

  Future<Workspace> _assertWorkspaceIsMutable(
    Session session,
    int workspaceId,
  ) async {
    final workspace = await _workspaceRepository.findWorkspaceById(
      session,
      workspaceId,
    );

    if (workspace == null) {
      throw NotFoundException('Workspace not found');
    }

    if (workspace.archivedAt != null) {
      throw InvalidStateException('This workspace has been archived');
    }

    return workspace;
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
  Future<WorkspaceInvitation> inviteMember(
    Session session,
    String email,
    int workspaceId,
    WorkspaceRole role,
    int actorId,
  ) async {
    final workspace = await _assertWorkspaceIsMutable(session, workspaceId);
    
    final workspaceName = workspace.name;

    // Verify Permissions
    final actor = await _memberRepository.findMemberByWorkspaceId(
      session,
      actorId,
      workspaceId,
    );

    if (actor == null) {
      throw PermissionDeniedException(
          'Action not allowed. You are not a member of this workspace.');
    }

    if (!actor.isActive) {
      throw PermissionDeniedException(
          'Permission denied. Your membership is inactive.');
    }

    if (!RolePolicy.canManageMembers(actor.role)) {
      throw PermissionDeniedException(
          'Permission denied. Insufficient privileges');
    }

    // Check if the user is already a member of the workspace.
    WorkspaceMember? existingMember;
    try {
      existingMember = await _memberRepository.findMemberByEmail(
      session,
      email,
      workspaceId,
      );
    } on NotFoundException {
      // Member not found by email — that's fine, continue to invite.
      existingMember = null;
    }

    if (existingMember != null) {
      throw ConflictException(
      'This user is already a member of the workspace.',
      );
    }

    // Check for an existing, unaccepted invitation for this email.
    WorkspaceInvitation? existingInvitation;
    try {
      existingInvitation = await _invitationRepository.checkForExistingInvitation(
      session,
      email,
      workspaceId,
      );
    } on NotFoundException {
      existingInvitation = null;
    }

    if (existingInvitation != null) {
      final expiryDate = existingInvitation.expiresAt;
      final currentTime = DateTime.now().toUtc();
      final bool isExpired = currentTime.isAfter(expiryDate);

      if (isExpired) {
        await _invitationRepository.deleteInvitation(
            session, existingInvitation.token);
      } else {
        throw ConflictException(
            'An invitation has already been sent to this email address.');
      }
    }

    // Generate unique token
    String token;
    int attempts = 0;
    bool isUnique;

    do {
      token = generateCustomToken();
      final existing = await _invitationRepository.checkIfTokenIsUnique(
        session,
        token,
      );
      isUnique = existing == null;
      attempts++;
    } while (!isUnique && attempts < 10);

    if (!isUnique) {
      throw InvalidStateException(
          'Failed to generate a unique invitation token after 10 attempts.');
    }

    final sendEmail = await _emailHandler.sendInvitation(
      email,
      token,
      workspaceName,
      role,
    );

    if (!sendEmail) {
      throw ExternalServiceException('Failed to send invitation email.');
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

    return await _invitationRepository.createInvitation(session, invitation);
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
    String token, {
    int? userId,
  }) async {
    // If userId is not provided, extract it from session authentication
    final actualUserId = userId ?? (await session.authenticated)?.userId;

    // Throw an exception if the user is not authenticated
    if (actualUserId == null) {
      throw AuthenticationException('User not authenticated');
    }

    // Find the user's information using their userID
    final user = await _workspaceRepository.getUserInfo(session, actualUserId);

    // Throw an exception if the user is not found or has no email
    if (user == null || user.email == null) {
      throw NotFoundException('Authenticated user not found or has no email.');
    }
    final userEmail = user.email!;

    // Find the invitation using the provided token
    final invitation = await _invitationRepository.findInvitationByToken(
      session,
      token,
    );

    // Throw an exception if the invitation is not found
    if (invitation == null) {
      throw NotFoundException('Invalid invitation token.');
    }

    await _assertWorkspaceIsMutable(session, invitation.workspaceId);

    // Check if the invitation has expired and delete it if it has
    if (DateTime.now().toUtc().isAfter(invitation.expiresAt)) {
      await _invitationRepository.deleteInvitation(session, token);
      throw InvalidStateException('Invitation has expired.');
    }

    // Throw an exception is the user's email is not the as the invited email
    if (invitation.inviteeEmail != userEmail) {
      throw PermissionDeniedException(
          'This invitation is for a different user.');
    }

    // Check if the user is a member of the workspace already
    final existingMember = await _memberRepository.findMemberByWorkspaceId(
      session,
      actualUserId,
      invitation.workspaceId,
    );

    if (existingMember != null && existingMember.isActive) {
      // If the member is inactive, we can consider reactivating them,
      // but for now, we'll just prevent adding a duplicate.
      await _invitationRepository.deleteInvitation(session, token);
      throw ConflictException('You are already a member of this workspace.');
    }

    // Use a transaction to ensure atomicity
    final newMember = await _invitationRepository.acceptInvitation(
      session,
      invitation,
      actualUserId,
      token,
    );

    return newMember;
  }
}
