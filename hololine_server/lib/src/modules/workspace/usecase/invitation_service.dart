import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/services/email_service.dart';
import 'package:hololine_server/src/utils/exceptions.dart';
import 'package:hololine_server/src/utils/permissions.dart';
import 'package:hololine_server/src/utils/token_generator.dart';
import 'package:serverpod/server.dart';

import '../repositories/repositories.dart';

/// Manages the creation, validation, and acceptance of workspace invitations.
class InvitationService {
  final WorkspaceRepo _workspaceRepository;
  final MemberRepo _memberRepository;
  final InvitationRepo _invitationRepository;
  final EmailHandler _emailHandler;

  InvitationService(
    this._workspaceRepository,
    this._memberRepository,
    this._invitationRepository,
    this._emailHandler,
  );

  /// Validates that a workspace exists and is currently mutable.
  /// 
  /// A workspace is considered immutable if it has been archived, deleted,
  /// or is pending deletion.
  /// 
  /// Throws:
  /// - [NotFoundException] if the workspace does not exist.
  /// - [InvalidStateException] if the workspace is archived or deleted.
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

    if (workspace.deletedAt != null || workspace.pendingDeletionUntil != null) {
      throw InvalidStateException('This workspace is deleted or pending deletion');
    }

    return workspace;
  }

  /// THE MASTER GUARD GATE
  /// 
  /// Centralizes all authorization and state validation logic for internal actions.
  /// Validates that the [actorId] corresponds to an active member of the workspace
  /// and that their assigned role satisfies the provided [policy].
  /// 
  /// Parameters:
  /// - [checkMutability]: If true, ensures the workspace is not archived or deleted
  ///   before checking permissions. Defaults to true.
  /// 
  /// Returns the validated [Member] object if successful.
  /// 
  /// Throws:
  /// - [PermissionDeniedException] if the user is not a member, is inactive, or lacks the required role.
  Future<WorkspaceMember> _enforceAccess(
    Session session, {
    required int workspaceId,
    required int actorId,
    required bool Function(WorkspaceRole role) policy,
    bool checkMutability = true,
  }) async {
    if (checkMutability) {
      await _assertWorkspaceIsMutable(session, workspaceId);
    }

    final actor = await _memberRepository.findMemberByWorkspaceId(
      session,
      actorId,
      workspaceId,
    );

    if (actor == null) {
      throw PermissionDeniedException('You are not a member of this workspace');
    }

    if (!actor.isActive) {
      throw PermissionDeniedException('Permission denied. Your membership is inactive');
    }

    if (!policy(actor.role)) {
      throw PermissionDeniedException('Permission denied. Insufficient privileges');
    }

    return actor;
  }

  /// Invites a user to join the workspace by sending an email invitation.
  ///
  /// The specified [email] receives an invitation containing a unique token that 
  /// expires after 15 minutes. If an existing invitation for this email exists 
  /// and has expired, it will be automatically deleted and a new one generated.
  ///
  /// The [actorId] must belong to an active member whose role satisfies the 
  /// [RolePolicy.canManageMembers] requirement.
  ///
  /// Throws:
  /// - [PermissionDeniedException] if the actor lacks permissions or is inactive.
  /// - [ConflictException] if the user is already a member, or if a valid, unexpired 
  ///   invitation already exists for this email.
  /// - [InvalidStateException] if a unique token cannot be generated after 10 attempts.
  /// - [ExternalServiceException] if the email delivery handler fails.
  Future<WorkspaceInvitation> inviteMember(
    Session session,
    String email,
    int workspaceId,
    WorkspaceRole role,
    int actorId,
  ) async {
    // 1. The Guard Gate (Absorbs membership, active status, and role checks)
    await _enforceAccess(
      session,
      workspaceId: workspaceId,
      actorId: actorId,
      policy: RolePolicy.canManageMembers,
    );

    // Fetch the workspace purely to get the name for the email payload
    final workspace = await _workspaceRepository.findWorkspaceById(session, workspaceId);
    final workspaceName = workspace!.name;

    // 2. Business Logic: Check if already a member
    WorkspaceMember? existingMember;
    try {
      existingMember = await _memberRepository.findMemberByEmail(
        session,
        email,
        workspaceId,
      );
    } on NotFoundException {
      existingMember = null;
    }

    if (existingMember != null) {
      throw ConflictException('This user is already a member of the workspace.');
    }

    // 3. Business Logic: Check for pending invitations
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
      final isExpired = DateTime.now().toUtc().isAfter(existingInvitation.expiresAt);

      if (isExpired) {
        await _invitationRepository.deleteInvitation(session, existingInvitation.token);
      } else {
        throw ConflictException('An invitation has already been sent to this email address.');
      }
    }

    // 4. Token Generation
    String token;
    int attempts = 0;
    bool isUnique;

    do {
      token = generateCustomToken();
      final existing = await _invitationRepository.checkIfTokenIsUnique(session, token);
      isUnique = existing == null;
      attempts++;
    } while (!isUnique && attempts < 10);

    if (!isUnique) {
      throw InvalidStateException('Failed to generate a unique invitation token after 10 attempts.');
    }

    // 5. Send Email
    final sendEmail = await _emailHandler.sendInvitation(
      email,
      token,
      workspaceName,
      role,
    );

    if (!sendEmail) {
      throw ExternalServiceException('Failed to send invitation email.');
    }

    // 6. Save Invitation
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
  /// The authenticated user's email must strictly match the `inviteeEmail` on the invitation.
  /// This method validates the token, checks for expiration, and ensures the
  /// user is not already an active member before granting them access.
  /// 
  /// Note: The `_enforceAccess` guard gate is intentionally bypassed here because 
  /// the actor is not yet a member of the workspace.
  ///
  /// Throws:
  /// - [AuthenticationException] if the user is not currently authenticated.
  /// - [NotFoundException] if the token is invalid or the user profile has no email.
  /// - [InvalidStateException] if the invitation has expired.
  /// - [PermissionDeniedException] if the authenticated user's email does not match the invitation.
  /// - [ConflictException] if the user is already an active member of the workspace.
  Future<WorkspaceMember> acceptInvitation(
    Session session,
    String token, {
    int? userId,
  }) async {
    final actualUserId = userId ?? (await session.authenticated)?.userId;

    if (actualUserId == null) {
      throw AuthenticationException('User not authenticated');
    }

    final user = await _workspaceRepository.getUserInfo(session, actualUserId);

    if (user == null || user.email == null) {
      throw NotFoundException('Authenticated user not found or has no email.');
    }
    
    final userEmail = user.email!;

    final invitation = await _invitationRepository.findInvitationByToken(
      session,
      token,
    );

    if (invitation == null) {
      throw NotFoundException('Invalid invitation token.');
    }

    // Ensure they aren't trying to join an archived/deleted workspace
    await _assertWorkspaceIsMutable(session, invitation.workspaceId);

    if (DateTime.now().toUtc().isAfter(invitation.expiresAt)) {
      await _invitationRepository.deleteInvitation(session, token);
      throw InvalidStateException('Invitation has expired.');
    }

    if (invitation.inviteeEmail != userEmail) {
      throw PermissionDeniedException('This invitation is for a different user.');
    }

    final existingMember = await _memberRepository.findMemberByWorkspaceId(
      session,
      actualUserId,
      invitation.workspaceId,
    );

    if (existingMember != null && existingMember.isActive) {
      await _invitationRepository.deleteInvitation(session, token);
      throw ConflictException('You are already a member of this workspace.');
    }

    // Process the transaction to add the member and delete the token
    final newMember = await _invitationRepository.acceptInvitation(
      session,
      invitation,
      actualUserId,
      token,
    );

    return newMember;
  }
}