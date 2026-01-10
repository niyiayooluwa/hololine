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
    final newWorkspace = Workspace(
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
    final member = await _memberRepository.findMemberByWorkspaceId(
      session,
      userId,
      parentWorkspaceId,
    );

    if (member == null) {
      throw PermissionDeniedException(
          'User is not a member of the parent workspace');
    }

    if (!member.isActive) {
      throw PermissionDeniedException(
          'Permission denied. Your membership is inactive');
    }

    final hasPermission = member.role == WorkspaceRole.owner ||
        member.role == WorkspaceRole.admin;

    if (!hasPermission) {
      throw PermissionDeniedException('Permission denied. Insufficient role');
    }

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

  /// Returns information about a workspace
  /// 
  /// The [workspaceId] must be a valid workspace identifier. This method
  /// performs a simple lookup by primary key.
  ///
  /// Returns the workspace if found, or `null` if no workspace exists
  /// with the given identifier.
  /// 
  /// Throws an [Exception] if:
  /// - The actor is not a member of the repository
  /// - The db call fails to return a valid response i.e null
  Future<Workspace> getWorkspaceDetails(
    Session session,
    int workspaceId,
    int actorId,
  ) async {
    final actor = await _memberRepository.findMemberByWorkspaceId(
      session,
      actorId,
      workspaceId,
    );

    if (actor == null) {
      throw PermissionDeniedException(
          'You are not a member of this repository');
    }

    if (actor.isActive == false) {
      throw PermissionDeniedException(
          'You are not a member of this repository');
    }

    final workspace = await _workspaceRepository.findWorkspaceById(
      session,
      workspaceId,
    );

    if (workspace == null) {
      throw Exception('Failed to fetch workspace details');
    }

    return workspace;
  }

  /// Returns immediate children of a parent workspace.
  /// Used for navigating nested folder structures.
  ///
  /// The [actorId] must have read access to the [parentWorkspaceId] to see its children.
  Future<List<Workspace>> getChildWorkspaces(
    Session session,
    int parentWorkspaceId,
    int actorId,
  ) async {
    await _assertWorkspaceIsMutable(session, parentWorkspaceId);

    final actor = await _memberRepository.findMemberByWorkspaceId(
      session,
      actorId,
      parentWorkspaceId,
    );

    if (actor == null) {
      throw PermissionDeniedException('You are not a member of the parent workspace');
    }

    if (!actor.isActive) {
      throw PermissionDeniedException('Your membership is inactive');
    }

    return await _workspaceRepository.findChildWorkspaces(
      session, 
      parentWorkspaceId,
    );
  }

  /// Updates the details (name, description) of a workspace.
  ///
  /// The [actorId] must be an active member with sufficient privileges 
  /// (usually Owner or Admin) defined by [RolePolicy].
  Future<Workspace> updateWorkspaceDetails(
    Session session,
    int workspaceId,
    String? name,
    String? description,
    int actorId,
  ) async {
    var workspace = await _assertWorkspaceIsMutable(session, workspaceId);

    final actor = await _memberRepository.findMemberByWorkspaceId(
      session,
      actorId,
      workspaceId,
    );

    if (actor == null) {
      throw PermissionDeniedException('You are not a member of this workspace');
    }

    if (!actor.isActive) {
      throw PermissionDeniedException('Your membership is inactive');
    }

    if (!RolePolicy.canUpdateWorkspace(actor.role)) {
      throw PermissionDeniedException(
          'Permission denied. Insufficient privileges to update details.');
    }

    workspace.name = name ?? workspace.name;
    workspace.description = description ?? workspace.description;

    await _workspaceRepository.update(session, workspace);
    
    // Fetch-After-Write (To be safe)
    // Although 'workspace' variable is updated locally, fetching ensures 
    // we return exactly what's in the DB (including any auto-generated timestamps if applicable)
    final updatedWorkspace = await _workspaceRepository.findWorkspaceById(
      session, 
      workspaceId,
    );
    
    if (updatedWorkspace == null) throw Exception('Failed to retrieve updated workspace');

    return updatedWorkspace;
  }

  /*/// Updates the logo URL/Path for a workspace.
  ///
  /// The [actorId] must have the same privileges required for updating details.
  Future<Workspace> updateWorkspaceLogo(
    Session session,
    int workspaceId,
    String logoPath,
    int actorId,
  ) async {
    // 1. Basic Mutability Check
    var workspace = await _assertWorkspaceIsMutable(session, workspaceId);

    // 2. Permission Check
    final actor = await _memberRepository.findMemberByWorkspaceId(
      session,
      actorId,
      workspaceId,
    );

    if (actor == null) {
      throw PermissionDeniedException('You are not a member of this workspace');
    }

    if (!actor.isActive) {
      throw PermissionDeniedException('Your membership is inactive');
    }

    if (!RolePolicy.canUpdateWorkspace(actor.role)) {
      throw PermissionDeniedException(
          'Permission denied. Insufficient privileges to change logo.');
    }

    // 3. Update Logo
    workspace.logoUrl = logoPath;

    // 4. Save
    await _workspaceRepository.update(session, workspace);

    // 5. Return updated object
    return workspace;
  }*/


  /// Archives a workspace after verifying the actor's permissions.
  ///
  /// This service-layer method ensures that the user attempting to archive the
  /// workspace (the [actorId]) is a member of the workspace and has the
  /// necessary role permissions to perform the action, as defined by the
  /// [RolePolicy].
  ///
  /// - [session]: The database session.
  /// - [workspaceId]: The ID of the workspace to be archived.
  /// - [actorId]: The ID of the user performing the archive action.
  ///
  /// Throws an [Exception] if:
  /// - The actor is not a member of the workspace.
  /// - The actor does not have sufficient privileges to archive the workspace.
  Future<Workspace> archiveWorkspace(
    Session session,
    int workspaceId,
    int actorId,
  ) async {
    await _assertWorkspaceIsMutable(session, workspaceId);

    final actor = await _memberRepository.findMemberByWorkspaceId(
      session,
      actorId,
      workspaceId,
    );

    if (actor == null) {
      throw PermissionDeniedException('You are not a member of the workspace');
    }

    if (!RolePolicy.canArchiveWorkspace(actor.role)) {
      throw PermissionDeniedException(
          'Permission denied. Insufficient privileges');
    }

    final success =
        await _workspaceRepository.archiveWorkspace(session, workspaceId);

    if (!success) {
      throw Exception(
          'Failed to archive workspace: database transaction failed');
    }

    final archivedWorkspace = await _workspaceRepository.findWorkspaceById(
      session,
      workspaceId,
    );

    if (archivedWorkspace == null) {
      throw NotFoundException('Failed to fetch archived workspace details');
    }

    return archivedWorkspace;
  }

  /// Restores an archived workspace after verifying the actor's permissions.
  ///
  /// This service-layer method ensures that the workspace exists and is archived,
  /// and that the user attempting to restore it (the [actorId]) is a member
  /// with the necessary role permissions, as defined by the [RolePolicy].
  ///
  /// - [session]: The database session.
  /// - [workspaceId]: The ID of the workspace to be restored.
  /// - [actorId]: The ID of the user performing the restore action.
  ///
  /// Throws an [Exception] if:
  /// - The workspace is not found.
  /// - The workspace is not currently archived.
  /// - The actor is not a member of the workspace.
  /// - The actor does not have sufficient privileges to restore the workspace.
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

    final actor = await _memberRepository.findMemberByWorkspaceId(
      session,
      actorId,
      workspaceId,
    );

    if (actor == null) {
      throw PermissionDeniedException('You are not a member of the workspace');
    }

    if (!RolePolicy.canRestoreWorkspace(actor.role)) {
      throw PermissionDeniedException(
          'Permission denied. Insufficient privileges');
    }

    final success =
        await _workspaceRepository.restoreWorkspace(session, workspaceId);

    if (!success) {
      throw Exception(
          'Failed to restore workspace: database transaction failed');
    }
    
    final restoredWorkspace = await _workspaceRepository.findWorkspaceById(
      session,
      workspaceId,
    );

    if (restoredWorkspace == null) {
      throw NotFoundException('Failed to fetch restored workspace details');
    }

    return restoredWorkspace;
  }

  /// Transfers ownership of a workspace from the current owner to another member.
  ///
  /// The [actorId] must be the current owner of the workspace. The [newOwnerId]
  /// must be an active member of the same workspace.
  ///
  /// Throws an [Exception] if the actor is not the owner, if the new owner
  /// is not a valid member, or if the owner attempts to transfer ownership
  /// to themselves.
  Future<bool> transferOwnership(
    Session session,
    int workspaceId,
    int newOwnerId,
    int actorId,
  ) async {
    await _assertWorkspaceIsMutable(session, workspaceId);

    final actor = await _memberRepository.findMemberByWorkspaceId(
      session,
      actorId,
      workspaceId,
    );

    final member = await _memberRepository.findMemberByWorkspaceId(
      session,
      newOwnerId,
      workspaceId,
    );

    if (actor == null) {
      throw PermissionDeniedException('You are not a member of the workspace');
    }

    if (member == null) {
      throw NotFoundException('Target member not found in the workspace');
    }

    if (!actor.isActive) {
      throw PermissionDeniedException(
          'Permission denied. Your membership is inactive');
    }

    if (!member.isActive) {
      throw InvalidStateException('Cannot update role of an inactive member');
    }

    if (!RolePolicy.canTransferOwnership(actor.role)) {
      throw PermissionDeniedException(
          'Permission denied. You do not own this workspace');
    }

    if (actorId == newOwnerId) {
      throw PermissionDeniedException('You can not modify your own role');
    }

    final success = await _memberRepository.transferOwnership(
        session, workspaceId, actorId, newOwnerId);

    if (!success) {
      throw Exception(
          'Failed to transfer ownership: database transaction failed');
    }

    return success;
  }

  /// Initiates the deletion process for a workspace.
  ///
  /// This method performs several validation checks before marking a workspace
  /// for deletion:
  /// - Verifies the workspace exists and is mutable
  /// - Confirms the actor is an active member of the workspace
  /// - Ensures the actor has sufficient privileges to delete workspaces
  /// - Checks the workspace is not already deleted or pending deletion
  ///
  /// Once all validations pass, the workspace is soft-deleted and a deletion
  /// timer is initiated.
  ///
  /// Parameters:
  ///   - [session]: The database session for executing transactions
  ///   - [workspaceId]: The ID of the workspace to delete
  ///   - [actorId]: The ID of the member initiating the deletion
  ///
  /// Throws:
  ///   - [PermissionDeniedException]: If the actor is not a workspace member,
  ///     their membership is inactive, or they lack deletion privileges
  ///   - [InvalidStateException]: If the workspace is already deleted or
  ///     pending deletion
  ///   - [Exception]: If the database transaction fails during soft deletion
  Future<Workspace> initiateDeleteWorkspace(
    Session session,
    int workspaceId,
    int actorId,
  ) async {
    final workspace = await _assertWorkspaceIsMutable(session, workspaceId);

    final actor = await _memberRepository.findMemberByWorkspaceId(
      session,
      actorId,
      workspaceId,
    );

    if (actor == null) {
      throw PermissionDeniedException('You are not a member of the workspace');
    }

    if (!actor.isActive) {
      throw PermissionDeniedException(
          'Permission denied. Your membership is inactive');
    }

    if (!RolePolicy.canInitiateDelete(actor.role)) {
      throw PermissionDeniedException(
          'Permission denied. Insufficient privileges');
    }

    if (workspace.deletedAt != null) {
      throw InvalidStateException('Workspace has already been deleted');
    }

    if (workspace.pendingDeletionUntil != null) {
      throw InvalidStateException('Workspace is already pending deletion');
    }

    final success =
        await _workspaceRepository.softDeleteWorkspace(session, workspaceId);

    if (!success) {
      throw Exception(
          'Failed to initiate workspace deletion: database transaction failed');
    }

    final deletedWorkspace = await _workspaceRepository.findWorkspaceById(
      session,
      workspaceId,
    );

    if (deletedWorkspace == null) {
      throw NotFoundException('Failed to fetch deleted workspace details');
    }

    return deletedWorkspace;
  }
}
