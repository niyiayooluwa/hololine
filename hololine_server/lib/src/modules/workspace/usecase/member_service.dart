import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/utils/exceptions.dart';
import 'package:hololine_server/src/utils/permissions.dart';
import 'package:serverpod/server.dart';
import '../repositories/repositories.dart';

/// Manages workspace memberships, role assignments, and member lifecycle.
class MemberService {
  final WorkspaceRepo _workspaceRepository;
  final MemberRepo _memberRepository;

  MemberService(this._memberRepository, this._workspaceRepository);

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
  /// Centralizes all authorization and state validation logic.
  /// Validates that the actor is an active member of the workspace and that
  /// their assigned role satisfies the provided [policy].
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

  /// Returns a list of all workspaces where the [userId] is an active member.
  ///
  /// This excludes any workspaces where the user's membership has been
  /// deactivated (Soft Delete). This endpoint does not require the guard gate 
  /// because it queries across all workspaces rather than acting within a specific one.
  Future<List<WorkspaceSummary>> getMyWorkspaces(
    Session session,
    int userId,
  ) async {
    final workspaces = await _memberRepository.findUserWorkspaces(
      session, 
      userId,
    );
    
    return workspaces;
  }

  /// Updates the [role] of a workspace member identified by [memberId].
  ///
  /// The [actorId] must have sufficient permissions to change roles according
  /// to the [RolePolicy]. Owners cannot change their own role.
  ///
  /// Returns the updated [WorkspaceMember] reflecting the new role.
  /// 
  /// Throws:
  /// - [NotFoundException] if the target member does not exist.
  /// - [InvalidStateException] if the target member is currently inactive.
  /// - [PermissionDeniedException] if the actor lacks privileges or attempts to modify an Owner.
  Future<WorkspaceMember> updateMemberRole(
    Session session, {
    required int memberId,
    required int workspaceId,
    required WorkspaceRole role,
    required int actorId,
  }) async {
    // 1. Fetch Target Member First
    final targetMember = await _memberRepository.findMemberByWorkspaceId(
        session, memberId, workspaceId);
        
    if (targetMember == null) {
      throw NotFoundException('Target member not found in the workspace');
    }

    if (!targetMember.isActive) {
      throw InvalidStateException('Cannot update role of an inactive member');
    }

    // 2. The Guard Gate (Evaluates the complex 3-way RolePolicy automatically)
    final actor = await _enforceAccess(
      session,
      workspaceId: workspaceId,
      actorId: actorId,
      policy: (actorRole) => RolePolicy.canUpdateRole(
        actor: actorRole,
        target: targetMember.role,
        newRole: role,
      ),
    );

    // 3. Specific Business Logic Check
    if (actorId == memberId && actor.role == WorkspaceRole.owner) {
      throw PermissionDeniedException('Owners cannot change their own role');
    }

    // 4. Execute Update
    await _memberRepository.updateMemberRole(
      session,
      memberId,
      role,
      workspaceId,
    );

    // FETCH-AFTER-WRITE: Return the updated member object
    final updatedMember = await _memberRepository.findMemberByWorkspaceId(
        session, memberId, workspaceId);

    if (updatedMember == null) {
       throw NotFoundException('Member data lost after update');
    }
    
    return updatedMember;
  }

  /// Removes a member from the workspace by deactivating their membership.
  ///
  /// The [actorId] must have permission to manage members and cannot remove
  /// themselves from the workspace.
  ///
  /// Returns the deactivated [WorkspaceMember] (useful to verify isActive = false).
  /// 
  /// Throws:
  /// - [PermissionDeniedException] if the actor attempts to remove themselves or lacks privileges.
  /// - [NotFoundException] if the target member is not found.
  Future<WorkspaceMember> removeMember(
    Session session, {
    required int memberId,
    required int workspaceId,
    required int actorId,
  }) async {
    if (actorId == memberId) {
      throw PermissionDeniedException('You cannot remove yourself from the workspace');
    }

    // 1. The Guard Gate
    await _enforceAccess(
      session,
      workspaceId: workspaceId,
      actorId: actorId,
      policy: RolePolicy.canManageMembers,
    );

    // 2. Validate Target
    final targetMember = await _memberRepository.findMemberByWorkspaceId(
        session, memberId, workspaceId);

    if (targetMember == null) {
      throw NotFoundException('Target member not found in the workspace');
    }

    // 3. Execute Deactivation
    await _memberRepository.deactivateMember(session, memberId, workspaceId);

    // FETCH-AFTER-WRITE: Return the deactivated member
    final deactivatedMember = await _memberRepository.findMemberByWorkspaceId(
        session, memberId, workspaceId);
        
    if (deactivatedMember == null) {
       throw NotFoundException('Member data lost after deactivation');
    }

    return deactivatedMember;
  }

  /// Allows a user to voluntarily leave a workspace.
  /// 
  /// Throws [PermissionDeniedException] if the user is the specific OWNER 
  /// of the workspace (Owners must transfer ownership before leaving).
  Future<WorkspaceMember> leaveWorkspace(
    Session session, 
    int workspaceId, 
    int actorId
  ) async {
    // 1. The Guard Gate (Asserts mutability, active membership, etc.)
    final actor = await _enforceAccess(
      session,
      workspaceId: workspaceId,
      actorId: actorId,
      policy: (role) => true, // We allow anyone to attempt to leave...
    );

    // 2. Prevent Owner from leaving (Specific UX Error Message)
    if (actor.role == WorkspaceRole.owner) {
      throw PermissionDeniedException(
        'Owners cannot leave a workspace. Transfer ownership or delete the workspace.'
      );
    }

    // Execute Deactivation
    await _memberRepository.deactivateMember(session, actor.id!, workspaceId);

    // Fetch-after-write: return the ACTOR'S new demoted member record
    final demotedActor = await _memberRepository.findMemberByWorkspaceId(session, actorId, workspaceId);
    return demotedActor!;
  }
}