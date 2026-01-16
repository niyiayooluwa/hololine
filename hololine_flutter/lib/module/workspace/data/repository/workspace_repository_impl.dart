import 'package:dart_either/dart_either.dart';
import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/domain/failures/exception_handler.dart';
import 'package:hololine_flutter/domain/failures/failures.dart';
import 'package:hololine_flutter/module/workspace/data/remote/workspace_remote_data_source.dart';
import 'package:hololine_flutter/module/workspace/data/remote/workspace_remote_data_source_impl.dart';
import 'package:hololine_flutter/module/workspace/domain/repository/workspace_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WorkspaceRepositoryImpl implements WorkspaceRepository {
  final WorkspaceRemoteDataSource remoteDataSource;

  WorkspaceRepositoryImpl({required this.remoteDataSource});

  // ===========================================================================
  // CREATION
  // ===========================================================================

  @override
  Future<Either<Failure, Workspace>> createStandaloneWorkspace(
    String name,
    String description,
  ) async {
    try {
      final response = await remoteDataSource.createStandaloneWorkspace(
        name,
        description,
      );
      return Right(response);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Workspace>> createChildWorkspace(
    String name,
    String description,
    int parentId,
  ) async {
    try {
      final response = await remoteDataSource.createChildWorkspace(
        name,
        description,
        parentId,
      );
      return Right(response);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  // ===========================================================================
  // READ OPERATIONS
  // ===========================================================================

  @override
  Future<Either<Failure, Workspace>> getWorkspaceDetails(
    int workspaceId,
  ) async {
    try {
      final response = await remoteDataSource.getWorkspaceDetails(workspaceId);
      return Right(response);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<Workspace>>> getMyWorkspaces() async {
    try {
      final response = await remoteDataSource.getMyWorkspaces();
      return Right(response);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, List<Workspace>>> getChildWorkspaces(
    int parentWorkspaceId,
  ) async {
    try {
      final response = await remoteDataSource.getChildWorkspaces(
        parentWorkspaceId,
      );
      return Right(response);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  // ===========================================================================
  // MEMBER MANAGEMENT
  // ===========================================================================

  @override
  Future<Either<Failure, WorkspaceMember>> updateMemberRole(
    int memberId,
    int workspaceId,
    WorkspaceRole role,
  ) async {
    try {
      final response = await remoteDataSource.updateMemberRole(
        memberId,
        workspaceId,
        role,
      );
      return Right(response);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, WorkspaceMember>> removeMember(
    int memberId,
    int workspaceId,
  ) async {
    try {
      final response = await remoteDataSource.removeMember(
        memberId,
        workspaceId,
      );
      return Right(response);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, WorkspaceMember>> leaveWorkspace(
    int workspaceId,
  ) async {
    try {
      final response = await remoteDataSource.leaveWorkspace(workspaceId);
      return Right(response);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  // ===========================================================================
  // INVITATIONS
  // ===========================================================================

  @override
  Future<Either<Failure, WorkspaceInvitation>> inviteMember(
    String email,
    int workspaceId,
    WorkspaceRole role,
  ) async {
    try {
      final response = await remoteDataSource.inviteMember(
        email,
        workspaceId,
        role,
      );
      return Right(response);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, WorkspaceMember>> acceptInvitation(
    String invitationCode,
  ) async {
    try {
      final response = await remoteDataSource.acceptInvitation(invitationCode);
      return Right(response);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  // ===========================================================================
  // UPDATE / ARCHIVE / DELETE
  // ===========================================================================

  @override
  Future<Either<Failure, Workspace>> updateWorkspaceDetails(
    int workspaceId,
    String? name,
    String? description,
  ) async {
    try {
      final response = await remoteDataSource.updateWorkspaceDetails(
        workspaceId,
        name,
        description,
      );
      return Right(response);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Workspace>> archiveWorkspace(int workspaceId) async {
    try {
      final response = await remoteDataSource.archiveWorkspace(workspaceId);
      return Right(response);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Workspace>> restoreWorkspace(int workspaceId) async {
    try {
      final response = await remoteDataSource.restoreWorkspace(workspaceId);
      return Right(response);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> transferOwnership(
    int workspaceId,
    int newOwnerId,
  ) async {
    try {
      final response = await remoteDataSource.transferOwnership(
        workspaceId,
        newOwnerId,
      );
      return Right(response);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, Workspace>> initiateDeleteWorkspace(
    int workspaceId,
  ) async {
    try {
      final response = await remoteDataSource.initiateDeleteWorkspace(
        workspaceId,
      );
      return Right(response);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }
}

// ===========================================================================
// PROVIDER
// ===========================================================================

final workspaceRepositoryProvider = Provider<WorkspaceRepository>((ref) {
  // Ensure you have created the workspaceRemoteDataSourceProvider
  // in your data source impl file!
  final remoteDataSource = ref.watch(workspaceRemoteDataSourceProvider);
  return WorkspaceRepositoryImpl(remoteDataSource: remoteDataSource);
});
