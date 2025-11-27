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

    await _memberRepository.updateMemberRole(
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

    await _memberRepository.deactivateMember(session, memberId, workspaceId);
  }
}