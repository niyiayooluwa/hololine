import 'package:dart_either/dart_either.dart';
import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/domain/failures/failures.dart';
import 'package:hololine_flutter/module/workspace/data/repository/workspace_repository_impl.dart';
import 'package:hololine_flutter/module/workspace/domain/repository/workspace_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GetMyWorkspacesUseCase {
  final WorkspaceRepository _workspaceRepository;

  GetMyWorkspacesUseCase(this._workspaceRepository);

  Future<Either<Failure, List<Workspace>>> call() async {
    return await _workspaceRepository.getMyWorkspaces();
  }
}

final getMyWorkspacesUseCaseProvider = Provider<GetMyWorkspacesUseCase>((ref) {
  final workspaceRepository = ref.watch(workspaceRepositoryProvider);
  return GetMyWorkspacesUseCase(workspaceRepository);
});
