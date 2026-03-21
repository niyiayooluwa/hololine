// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(WorkspaceListController)
const workspaceListControllerProvider = WorkspaceListControllerProvider._();

final class WorkspaceListControllerProvider
    extends
        $AsyncNotifierProvider<
          WorkspaceListController,
          List<WorkspaceSummary>
        > {
  const WorkspaceListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'workspaceListControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$workspaceListControllerHash();

  @$internal
  @override
  WorkspaceListController create() => WorkspaceListController();
}

String _$workspaceListControllerHash() =>
    r'840619ae90d02f80e95eb91ef41edb8dec31aed4';

abstract class _$WorkspaceListController
    extends $AsyncNotifier<List<WorkspaceSummary>> {
  FutureOr<List<WorkspaceSummary>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<List<WorkspaceSummary>>, List<WorkspaceSummary>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<WorkspaceSummary>>,
                List<WorkspaceSummary>
              >,
              AsyncValue<List<WorkspaceSummary>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
