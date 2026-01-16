import 'package:dart_either/dart_either.dart';
import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/domain/failures/failures.dart';

abstract class WorkspaceRepository {
  // ===========================================================================
  // CREATION
  // ===========================================================================

  Future<Either<Failure, Workspace>> createStandaloneWorkspace(
    String name,
    String description,
  );

  Future<Either<Failure, Workspace>> createChildWorkspace(
    String name,
    String description,
    int parentId,
  );

  // ===========================================================================
  // READ OPERATIONS
  // ===========================================================================

  Future<Either<Failure, Workspace>> getWorkspaceDetails(
    int workspaceId,
  );

  Future<Either<Failure, List<Workspace>>> getMyWorkspaces();

  Future<Either<Failure, List<Workspace>>> getChildWorkspaces(
    int parentWorkspaceId,
  );

  // ===========================================================================
  // MEMBER MANAGEMENT
  // ===========================================================================

  Future<Either<Failure, WorkspaceMember>> updateMemberRole(
    int memberId,
    int workspaceId,
    WorkspaceRole role,
  );

  Future<Either<Failure, WorkspaceMember>> removeMember(
    int memberId,
    int workspaceId,
  );

  Future<Either<Failure, WorkspaceMember>> leaveWorkspace(
    int workspaceId,
  );

  // ===========================================================================
  // INVITATIONS
  // ===========================================================================

  Future<Either<Failure, WorkspaceInvitation>> inviteMember(
    String email,
    int workspaceId,
    WorkspaceRole role,
  );

  Future<Either<Failure, WorkspaceMember>> acceptInvitation(
    String invitationCode,
  );

  // ===========================================================================
  // UPDATE / ARCHIVE / DELETE
  // ===========================================================================

  Future<Either<Failure, Workspace>> updateWorkspaceDetails(
    int workspaceId,
    String? name,
    String? description,
  );

  Future<Either<Failure, Workspace>> archiveWorkspace(
    int workspaceId,
  );

  Future<Either<Failure, Workspace>> restoreWorkspace(
    int workspaceId,
  );

  Future<Either<Failure, bool>> transferOwnership(
    int workspaceId,
    int newOwnerId,
  );

  Future<Either<Failure, Workspace>> initiateDeleteWorkspace(
    int workspaceId,
  );
}
