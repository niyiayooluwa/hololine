import 'package:dart_either/dart_either.dart';
import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/core/errors/exception_handler.dart';
import 'package:hololine_flutter/core/errors/failures.dart';
import 'package:hololine_flutter/feature/workspace/data/remote/workspace_remote_data_source.dart';
import 'package:hololine_flutter/feature/workspace/data/remote/workspace_remote_data_source_impl.dart';
import 'package:hololine_flutter/feature/workspace/data/repository/workspace_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Implementation of the [WorkspaceRepository] that communicates with a remote
/// data source to handle workspace-related operations.
///
/// This class wraps the data source calls in `try-catch` blocks and uses an
/// [ExceptionHandler] to convert exceptions into domain-specific [Failure]
/// types, returning them in an [Either] wrapper.
class WorkspaceRepositoryImpl implements WorkspaceRepository {
  /// The remote data source for workspace operations.
  final WorkspaceRemoteDataSource remoteDataSource;

  /// Creates an instance of [WorkspaceRepositoryImpl].
  WorkspaceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Workspace>> createWorkspace(
    String workspaceName,
    String description,
  ) async {
    try {
      final response = await remoteDataSource.createWorkspace(
        workspaceName,
        description,
      );
      return Right(response);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Workspace>> createChildWorkspace(
    String workspaceName,
    int parentWorkspaceId,
    String description,
  ) async {
    try {
      final response = await remoteDataSource.createChildWorkspace(
        workspaceName,
        parentWorkspaceId,
        description,
      );
      return Right(response);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, WorkspaceDashboardData>> getDashboardData(
    String publicId,
  ) async {
    try {
      final response = await remoteDataSource.getDashboardData(publicId);
      return Right(response);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Workspace>> getWorkspaceDetails(
    String publicId,
  ) async {
    try {
      final response = await remoteDataSource.getWorkspaceDetails(publicId);
      return Right(response);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
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
      return Left(ExceptionHandler.handle(e));
    }
  }

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
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Workspace>> archiveWorkspace(int workspaceId) async {
    try {
      final response = await remoteDataSource.archiveWorkspace(workspaceId);
      return Right(response);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, Workspace>> restoreWorkspace(int workspaceId) async {
    try {
      final response = await remoteDataSource.restoreWorkspace(workspaceId);
      return Right(response);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
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
      return Left(ExceptionHandler.handle(e));
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
      return Left(ExceptionHandler.handle(e));
    }
  }
}

/// Provider for the [WorkspaceRepository].
/// It watches [workspaceRemoteDataSourceProvider] to get the remote data source
/// and injects it into the repository implementation.
final workspaceRepositoryProvider = Provider<WorkspaceRepository>((ref) {
  final remoteDataSource = ref.watch(workspaceRemoteDataSourceProvider);
  return WorkspaceRepositoryImpl(remoteDataSource: remoteDataSource);
});
