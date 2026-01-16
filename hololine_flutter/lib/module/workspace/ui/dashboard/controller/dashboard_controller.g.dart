// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DashboardController)
const dashboardControllerProvider = DashboardControllerProvider._();

final class DashboardControllerProvider
    extends $AsyncNotifierProvider<DashboardController, List<Workspace>> {
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
    r'1f807885c5ce171792189fcf7c524a97746c5147';

abstract class _$DashboardController extends $AsyncNotifier<List<Workspace>> {
  FutureOr<List<Workspace>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Workspace>>, List<Workspace>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<List<Workspace>>, List<Workspace>>,
        AsyncValue<List<Workspace>>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
