// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DashboardController)
const dashboardControllerProvider = DashboardControllerProvider._();

final class DashboardControllerProvider extends $AsyncNotifierProvider<
    DashboardController, List<WorkspaceSummary>> {
  const DashboardControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dashboardControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$dashboardControllerHash();

  @$internal
  @override
  DashboardController create() => DashboardController();
}

String _$dashboardControllerHash() =>
    r'a04e101167700e520004653be14dc6ff98d62dff';

abstract class _$DashboardController
    extends $AsyncNotifier<List<WorkspaceSummary>> {
  FutureOr<List<WorkspaceSummary>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref
        as $Ref<AsyncValue<List<WorkspaceSummary>>, List<WorkspaceSummary>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<WorkspaceSummary>>, List<WorkspaceSummary>>,
        AsyncValue<List<WorkspaceSummary>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
