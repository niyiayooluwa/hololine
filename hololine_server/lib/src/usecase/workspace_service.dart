import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/utils/permissions.dart';
import 'package:serverpod/serverpod.dart';
import 'package:hololine_server/src/repositories/workspace_repository.dart';

class WorkspaceService {
  final WorkspaceRepo _workspaceRepository = WorkspaceRepo();

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

    await _workspaceRepository.deactivateMember(
        session, memberId, workspaceId);
  }
}