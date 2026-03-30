import 'package:dart_either/dart_either.dart';
import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/domain/failures/failures.dart';
import 'package:hololine_flutter/module/workspace/data/repository/workspace_repository_impl.dart';
import 'package:hololine_flutter/module/workspace/domain/repository/workspace_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreateStandaloneWorkspaceUseCase {
  final WorkspaceRepository _workspaceRepository;

  CreateStandaloneWorkspaceUseCase(this._workspaceRepository);

  Future<Either<Failure, Workspace>> call(
    String name,
    String description,
  ) async {
    return await _workspaceRepository.createStandaloneWorkspace(
      name,
      description,
    );
  }
}

final createStandaloneWorkspaceUseCaseProvider =
    Provider<CreateStandaloneWorkspaceUseCase>((ref) {
  final workspaceRepository = ref.watch(workspaceRepositoryProvider);
  return CreateStandaloneWorkspaceUseCase(workspaceRepository);
});
