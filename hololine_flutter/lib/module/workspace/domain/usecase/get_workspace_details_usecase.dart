import 'package:dart_either/dart_either.dart';
import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/domain/failures/failures.dart';
import 'package:hololine_flutter/module/workspace/data/repository/workspace_repository_impl.dart';
import 'package:hololine_flutter/module/workspace/domain/repository/workspace_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GetWorkspaceDetailsUseCase {
  final WorkspaceRepository repository;

  GetWorkspaceDetailsUseCase({required this.repository});

  Future<Either<Failure, Workspace>> call(String publicId) async {
    return await repository.getWorkspaceDetails(publicId);
  }
}

final getWorkspaceDetailsUseCaseProvider = Provider<GetWorkspaceDetailsUseCase>((ref) {
  final repository = ref.watch(workspaceRepositoryProvider);
  return GetWorkspaceDetailsUseCase(repository: repository);
});
