import 'dart:async';

import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/core/errors/failures.dart';
import 'package:hololine_flutter/feature/workspace/data/repository/workspace_repository.dart';
import 'package:hololine_flutter/feature/workspace/data/repository/workspace_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'create_workspace_controller.g.dart';

@riverpod
class CreateWorkspaceController extends _$CreateWorkspaceController {
  @override
  FutureOr<Workspace?> build() => null;

  WorkspaceRepository get _workspaceRepo => ref.read(workspaceRepositoryProvider);

  Future<void> create(String name, String description) async {
    state = const AsyncLoading();

    if (name.trim().isEmpty) {
      state = AsyncError(
        ServerFailure('Workspace name cannot be empty'),
        StackTrace.current,
      );
      return;
    }

    final result = await _workspaceRepo.createWorkspace(name, description);

    state = result.fold(
      ifLeft: (failure) => AsyncError(failure, StackTrace.current),
      ifRight: (workspace) => AsyncData(workspace),
    );
  }
}
