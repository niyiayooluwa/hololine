// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_workspace_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CreateWorkspaceController)
const createWorkspaceControllerProvider = CreateWorkspaceControllerProvider._();

final class CreateWorkspaceControllerProvider
    extends $AsyncNotifierProvider<CreateWorkspaceController, Workspace?> {
  const CreateWorkspaceControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createWorkspaceControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createWorkspaceControllerHash();

  @$internal
  @override
  CreateWorkspaceController create() => CreateWorkspaceController();
}

String _$createWorkspaceControllerHash() =>
    r'5f1319ae9e1483ad5849ba146575fe77d966c831';

abstract class _$CreateWorkspaceController extends $AsyncNotifier<Workspace?> {
  FutureOr<Workspace?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<Workspace?>, Workspace?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Workspace?>, Workspace?>,
              AsyncValue<Workspace?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
