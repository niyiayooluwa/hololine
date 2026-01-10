import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/utils/exceptions.dart';
import 'package:hololine_server/src/utils/permissions.dart';
import 'package:serverpod/server.dart';
import '../repositories/repositories.dart';

class MemberService {
  final WorkspaceRepo _workspaceRepository;
  final MemberRepo _memberRepository;

  MemberService(this._memberRepository, this._workspaceRepository);

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

  /// Returns a list of all workspaces where the [userId] is an active member.
  ///
  /// This excludes any workspaces where the user's membership has been
  /// deactivated (Soft Delete).
  Future<List<Workspace>> getMyWorkspaces(
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
  /// to the [RolePolicy]. Owners cannot change their own role, and there must
  /// always be at least one active owner in the workspace.
  ///
  /// Returns the updated [WorkspaceMember] reflecting the new role.
  Future<WorkspaceMember> updateMemberRole(
      Session session, {
        required int memberId,
        required int workspaceId,
        required WorkspaceRole role,
        required int actorId,
      }) async {
    await _assertWorkspaceIsMutable(session, workspaceId);

    var actor = await _memberRepository.findMemberByWorkspaceId(
        session, actorId, workspaceId);
    var member = await _memberRepository.findMemberByWorkspaceId(
        session, memberId, workspaceId);

    if (actor == null) {
      throw PermissionDeniedException('Actor is not a member of the workspace');
    }

    if (!actor.isActive) {
      throw PermissionDeniedException(
          'Permission denied. Your membership is inactive');
    }

    if (member == null) {
      throw NotFoundException('Target member not found in the workspace');
    }

    if (!member.isActive) {
      throw InvalidStateException('Cannot update role of an inactive member');
    }

    if (actorId == memberId && actor.role == WorkspaceRole.owner) {
      throw PermissionDeniedException('Owners cannot change their own role');
    }

    if (!RolePolicy.canUpdateRole(
      actor: actor.role,
      target: member.role,
      newRole: role,
    )) {
      throw PermissionDeniedException(
          'Permission denied. Insufficient privileges');
    }

    // Execute Update
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
  Future<WorkspaceMember> removeMember(
      Session session, {
        required int memberId,
        required int workspaceId,
        required int actorId,
      }) async {
    await _assertWorkspaceIsMutable(session, workspaceId);

    var actor = await _memberRepository.findMemberByWorkspaceId(
        session, actorId, workspaceId);
    var member = await _memberRepository.findMemberByWorkspaceId(
        session, memberId, workspaceId);

    if (actor == null) {
      throw PermissionDeniedException('Actor is not a member of the workspace');
    }

    if (!actor.isActive) {
      throw PermissionDeniedException(
          'Permission denied. Your membership is inactive');
    }

    if (member == null) {
      throw NotFoundException('Target member not found in the workspace');
    }

    if (actorId == memberId) {
      throw PermissionDeniedException(
          'You cannot remove yourself from the workspace');
    }

    if (!RolePolicy.canManageMembers(actor.role)) {
      throw PermissionDeniedException(
          'Permission denied. Insufficient privileges');
    }

    // Execute Deactivation
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
    // 1. Find the member record
    final member = await _memberRepository.findMemberByWorkspaceId(
      session, 
      actorId, 
      workspaceId
    );

    if (member == null) {
      throw NotFoundException('You are not a member of this workspace');
    }

    if (!member.isActive) {
      throw InvalidStateException('You are already inactive in this workspace');
    }

    // 2. Prevent Owner from leaving (Business Logic Rule)
    if (member.role == WorkspaceRole.owner) {
      throw PermissionDeniedException(
        'Owners cannot leave a workspace. Transfer ownership or delete the workspace.'
      );
    }

    return await _memberRepository.deactivateMember(session, member.id!, workspaceId);
  }
}
