import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/utils/exceptions.dart';
import 'package:hololine_server/src/utils/permissions.dart';
import 'package:serverpod/serverpod.dart';

import '../repositories/repositories.dart';

/// Service class for managing workspace operations including creation,
/// member management, and invitations.
class WorkspaceService {
  final WorkspaceRepo _workspaceRepository;
  final MemberRepo _memberRepository;

  WorkspaceService(this._memberRepository, this._workspaceRepository);

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

  /// Creates a new standalone workspace with the given [name] and [description].
  ///
  /// The [userId] becomes the owner of the newly created workspace.
  /// Standalone workspaces have no parent workspace.
  ///
  /// Returns the created [Workspace] with its assigned ID and initial owner.
  Future<Workspace> createStandalone(
    Session session,
    String name,
    int userId,
    String description,
  ) async {
    final newWorkspace = Workspace(
      publicId: const Uuid().v4(),
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
  /// The actor must satisfy the [RolePolicy.canCreateChild] requirement in the parent workspace.
  /// Child workspaces inherit permissions from their parent and cannot themselves become parents.
  ///
  /// Returns the created child [Workspace].
  ///
  /// Throws:
  /// - [NotFoundException] if the parent workspace doesn't exist.
  /// - [InvalidStateException] if the parent is itself a child workspace.
  Future<Workspace> createChild(
    Session session,
    String name,
    int userId,
    int parentWorkspaceId,
    String description,
  ) async {
    await _enforceAccess(
      session,
      workspaceId: parentWorkspaceId,
      actorId: userId,
      policy: RolePolicy.canCreateChild,
    );

    final parentWorkspace = await _workspaceRepository.findWorkspaceById(
      session,
      parentWorkspaceId,
    );

    if (parentWorkspace == null) {
      throw NotFoundException('Parent workspace not found');
    }

    if (parentWorkspace.parentId != null) {
      throw InvalidStateException('A child workspace cannot become a parent');
    }

    final newChildWorkspace = Workspace(
      publicId: const Uuid().v4(),
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

  /// Returns information about a workspace by its public UUID.
  /// 
  /// The actor must be an active member of the workspace (satisfying [RolePolicy.canViewDetails]).
  /// Mutability is NOT checked here, allowing users to view details of archived workspaces.
  ///
  /// Returns the workspace if found.
  /// 
  /// Throws [Exception] if the workspace cannot be located by its public ID.
  Future<Workspace> getWorkspaceDetails(
    Session session,
    String publicId,
    int actorId,
  ) async {
    final workspace = await _workspaceRepository.findWorkspaceByPublicId(
      session,
      publicId,
    );

    if (workspace == null) {
      throw Exception('Failed to fetch workspace details');
    }

    await _enforceAccess(
      session,
      workspaceId: workspace.id!,
      actorId: actorId,
      policy: RolePolicy.canViewDetails,
      checkMutability: false, // Allowed to view details of archived/deleted workspaces
    );

    return workspace;
  }

  /// Returns immediate children of a parent workspace.
  /// Used for navigating nested folder structures.
  ///
  /// The actor must satisfy the [RolePolicy.canViewExists] requirement.
  Future<List<Workspace>> getChildWorkspaces(
    Session session,
    int parentWorkspaceId,
    int actorId,
  ) async {
    await _enforceAccess(
      session,
      workspaceId: parentWorkspaceId,
      actorId: actorId,
      policy: RolePolicy.canViewExists,
    );

    return await _workspaceRepository.findChildWorkspaces(
      session, 
      parentWorkspaceId,
    );
  }

  /// Updates the details (name, description) of a workspace.
  ///
  /// The actor must satisfy the [RolePolicy.canUpdateWorkspace] requirement.
  ///
  /// Returns the newly updated [Workspace] object direct from the database.
  Future<Workspace> updateWorkspaceDetails(
    Session session,
    int workspaceId,
    String? name,
    String? description,
    int actorId,
  ) async {
    await _enforceAccess(
      session,
      workspaceId: workspaceId,
      actorId: actorId,
      policy: RolePolicy.canUpdateWorkspace,
    );

    // Re-fetch to ensure we are updating the latest state
    final workspace = await _workspaceRepository.findWorkspaceById(session, workspaceId);
    
    workspace!.name = name ?? workspace.name;
    workspace.description = description ?? workspace.description;

    await _workspaceRepository.update(session, workspace);

    // Fetch-After-Write to return accurate DB state
    final updatedWorkspace = await _workspaceRepository.findWorkspaceById(
      session, 
      workspaceId,
    );

    if (updatedWorkspace == null) throw Exception('Failed to retrieve updated workspace');

    return updatedWorkspace;
  }

  /// Archives a workspace, removing it from active operational views.
  ///
  /// The actor must satisfy the [RolePolicy.canArchiveWorkspace] requirement.
  ///
  /// Returns the newly archived [Workspace] object.
  Future<Workspace> archiveWorkspace(
    Session session,
    int workspaceId,
    int actorId,
  ) async {
    await _enforceAccess(
      session,
      workspaceId: workspaceId,
      actorId: actorId,
      policy: RolePolicy.canArchiveWorkspace,
    );

    final workspace = await _workspaceRepository.findWorkspaceById(session, workspaceId);
    if (workspace == null) {
      throw NotFoundException('Workspace not found');
    }

    workspace.archivedAt = DateTime.now().toUtc();
    return await _workspaceRepository.update(session, workspace);
  }

  /// Restores a previously archived workspace to active operational status.
  ///
  /// The actor must satisfy the [RolePolicy.canRestoreWorkspace] requirement.
  /// Note: The mutability check is intentionally bypassed here since the workspace is currently archived.
  ///
  /// Returns the restored [Workspace] object.
  Future<Workspace> restoreWorkspace(
    Session session,
    int workspaceId,
    int actorId,
  ) async {
    final workspace = await _workspaceRepository.findWorkspaceById(
      session,
      workspaceId,
    );

    if (workspace == null) {
      throw NotFoundException('Workspace not found');
    }

    if (workspace.archivedAt == null) {
      throw InvalidStateException('This workspace has not been archived');
    }

    await _enforceAccess(
      session,
      workspaceId: workspaceId,
      actorId: actorId,
      policy: RolePolicy.canRestoreWorkspace,
      checkMutability: false, // Bypassed because it IS archived
    );

    workspace.archivedAt = null;
    return await _workspaceRepository.update(session, workspace);
  }

  /// Transfers full ownership of a workspace to a new active member.
  ///
  /// The actor must satisfy the [RolePolicy.canTransferOwnership] requirement (must be current owner).
  /// The target user ([newOwnerId]) must be an active member of the same workspace.
  ///
  /// Returns the actor's demoted [WorkspaceMember] record.
  ///
  /// Throws:
  /// - [PermissionDeniedException] if the actor attempts to transfer ownership to themselves.
  /// - [NotFoundException] if the target member is not found.
  /// - [InvalidStateException] if the target member is inactive.
  Future<WorkspaceMember> transferOwnership(
    Session session,
    int workspaceId,
    int newOwnerId,
    int actorId,
  ) async {
    if (actorId == newOwnerId) {
      throw PermissionDeniedException('You can not transfer ownership to yourself');
    }

    await _enforceAccess(
      session,
      workspaceId: workspaceId,
      actorId: actorId,
      policy: RolePolicy.canTransferOwnership,
    );

    final newOwner = await _memberRepository.findMemberByWorkspaceId(
      session,
      newOwnerId,
      workspaceId,
    );

    if (newOwner == null) {
      throw NotFoundException('Target member not found in the workspace');
    }

    if (!newOwner.isActive) {
      throw InvalidStateException('Cannot transfer ownership to an inactive member');
    }

    await _memberRepository.transferOwnership(
        session, workspaceId, actorId, newOwnerId);

    final demotedMember = await _memberRepository.findMemberByWorkspaceId(
      session,
      actorId,
      workspaceId,
    );

    if (demotedMember == null) {
      throw Exception('Failed to fetch demoted member record');
    }

    return demotedMember;
  }

  /// Initiates the soft-deletion process for a workspace, starting the deletion timer.
  ///
  /// The actor must satisfy the [RolePolicy.canInitiateDelete] requirement.
  /// The workspace must not already be deleted or pending deletion (handled by the guard gate).
  ///
  /// Returns the soft-deleted [Workspace] object.
  Future<Workspace> initiateDeleteWorkspace(
    Session session,
    int workspaceId,
    int actorId,
  ) async {
    await _enforceAccess(
      session,
      workspaceId: workspaceId,
      actorId: actorId,
      policy: RolePolicy.canInitiateDelete,
    );

    final workspace = await _workspaceRepository.findWorkspaceById(session, workspaceId);
    if (workspace == null) {
      throw NotFoundException('Workspace not found');
    }

    workspace.pendingDeletionUntil =
        DateTime.now().toUtc().add(const Duration(hours: 99));
    return await _workspaceRepository.update(session, workspace);
  }
}