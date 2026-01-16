import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/module/workspace/domain/usecase/create_standalone_workspace_usecase.dart';
import 'package:hololine_flutter/module/workspace/domain/usecase/get_my_workspaces_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dashboard_controller.g.dart';

@riverpod
class DashboardController extends _$DashboardController {
  @override
  Future<List<Workspace>> build() async {
    return _fetchWorkspaces();
  }

  GetMyWorkspacesUseCase get myWorkspacesUseCase =>
      ref.read(getMyWorkspacesUseCaseProvider);

  CreateStandaloneWorkspaceUseCase get createWorkspaceUseCase =>
      ref.read(createStandaloneWorkspaceUseCaseProvider);

  Future<List<Workspace>> _fetchWorkspaces() async {
    state = const AsyncLoading();

    final result = await myWorkspacesUseCase.call();

    return result.fold(
      ifLeft: (failure) => throw Exception(failure.message),
      ifRight: (workspaces) => workspaces,
    );
  }

  Future<void> createWorkspace(String name, String description) async {
    // To show specific loading for creation, we might generally keep the list data
    // but maybe show a global loading indicator or just rely on the new workspace appearing.
    // Let's manually add it to the list on success for immediate feedback,
    // or invalidate to refetch. Invalidate is safer.
    state = const AsyncLoading();

    final result = await createWorkspaceUseCase.call(name, description);

    result.fold(
      ifLeft: (failure) {
        // How to handle error?
        // We can set state to error, but that hides the list.
        // Better to return the error or handle it via a side effect (provider listener).
        // But user asked to "handle everything".
        // LoginController sets state = AsyncError.
        // But LoginController state IS the response. Here state is the LIST.
        // If we set state to error, the list disappears.
        // Instead, we might want to return the result to the UI to show a toast,
        // OR have a separate "one-time-event" stream.
        // For simplicity and matching LoginController pattern (which replaces state),
        // adapting it to a list view is slightly different.
        // I'll stick to invalidating for now, but to handle errors locally in UI
        // the method can return the Either/Future.
        throw Exception(failure.message);
      },
      ifRight: (workspace) {
        // Optimistically add to state
        final previousState = state.maybeWhen(
          data: (data) => data,
          orElse: () => <Workspace>[],
        );
        state = AsyncData([...previousState, workspace]);
      },
    );
  }
}
