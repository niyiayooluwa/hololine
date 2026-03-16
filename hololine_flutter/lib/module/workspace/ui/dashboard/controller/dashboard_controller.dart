import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/module/workspace/domain/usecase/create_standalone_workspace_usecase.dart';
import 'package:hololine_flutter/module/workspace/domain/usecase/get_my_workspaces_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_controller.g.dart';

@riverpod
class DashboardController extends _$DashboardController {
  @override
  Future<List<WorkspaceSummary>> build() async {
    return _fetchWorkspaces();
  }

  GetMyWorkspacesUseCase get _myWorkspacesUseCase =>
      ref.read(getMyWorkspacesUseCaseProvider);

  CreateStandaloneWorkspaceUseCase get _createWorkspaceUseCase =>
      ref.read(createStandaloneWorkspaceUseCaseProvider);

  Future<List<WorkspaceSummary>> _fetchWorkspaces() async {
    final result = await _myWorkspacesUseCase.call();

    return result.fold(
      ifLeft: (failure) => throw Exception(failure.message),
      ifRight: (workspaces) => workspaces,
    );
  }

  Future<void> createWorkspace(String name, String description) async {
    // We don't set state = AsyncLoading() here to avoid nuking the existing list.
    // The UI can handle its own loading state for the creation button.

    final result = await _createWorkspaceUseCase.call(name, description);

    result.fold(
      ifLeft: (failure) => throw Exception(failure.message),
      ifRight: (workspace) {
        // Map the new Workspace to a WorkspaceSummary
        final newSummary = WorkspaceSummary(
          id: workspace.id!,
          name: workspace.name,
          description: workspace.description,
          memberCount: 1, // Creator is the first member
          lastActive: DateTime.now(),
          role: WorkspaceRole.admin, // Default for creator
        );

        // Update state optimistically if we have data
        state.whenData((currentList) {
          state = AsyncData([...currentList, newSummary]);
        });
      },
    );
  }
}
