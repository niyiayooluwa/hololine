import 'package:hololine_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:hololine_server/src/repositories/workspace_repository.dart';

class WorkspaceService {
  final WorkspaceRepo _workspaceRepository = WorkspaceRepo();

  Future<Workspace> createStandalone(
    Session session,
    String name,
    int userId,
    String description
  ) async {
    var existing =
        await _workspaceRepository.findByNameAndOwner(session, name, userId);

    if (existing != null) {
      throw Exception('A worksapce with the name "$name" already exists');
    }

    var newWorksapce = Workspace(
      name: name,
      description: description,
      createdAt: DateTime.now().toUtc(),
    );

    return await _workspaceRepository.create(
      session,
      newWorksapce,
      userId,
    );
  }

  Future<Workspace> createChild(
    Session session,
    String name,
    int userId,
    int parentWorkspaceId,
    String description
  ) async {
    // 1. & 2. Get Authenticated User ID & Check User's Role in Parent Workspace
    var member = await _workspaceRepository.findMemberByWorkspaceId(
      session,
      userId,
      parentWorkspaceId,
    );

    if (member == null) {
      throw Exception('PermissionDeniedException');
    }

    // 3. Authorize Action
    var hasPermission = 
        member.role == WorkspaceRole.owner ||
        member.role == WorkspaceRole.admin;
    if (!hasPermission) {
      throw Exception('Permission Denied. You cannot perform this action.');
    }

    // 4. Validate Parent Workspace Hierarchy
    var parentWorkspace = await _workspaceRepository.findWorkspaceById(
      session,
      parentWorkspaceId,
    );

    if (parentWorkspace?.parentId != null) {
      throw Exception('A child workspace cannot become a parent.');
    }

    // 5. Validate Unique Name
    var exists = await _workspaceRepository.doesChildWorkspaceExist(
      session,
      name,
      parentWorkspaceId,
    );

    if (exists) {
      throw Exception(
          'A workspace with this name already exists in the parent.');
    }

    // 6. Perform Atomic Creation
    var newChildWorkspace = Workspace(
      name: name,
      description: description,
      parentId: parentWorkspaceId,
      createdAt: DateTime.now().toUtc(),
    );

    var createdWorkspace = await _workspaceRepository.create(
      session,
      newChildWorkspace,
      userId,
    );

    // 7. Return the New Workspace
    return createdWorkspace;
  }
}
