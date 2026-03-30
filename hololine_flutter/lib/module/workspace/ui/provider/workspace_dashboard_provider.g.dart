// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_dashboard_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(workspaceDashboard)
const workspaceDashboardProvider = WorkspaceDashboardFamily._();

final class WorkspaceDashboardProvider
    extends
        $FunctionalProvider<
          AsyncValue<WorkspaceDashboardData>,
          WorkspaceDashboardData,
          FutureOr<WorkspaceDashboardData>
        >
    with
        $FutureModifier<WorkspaceDashboardData>,
        $FutureProvider<WorkspaceDashboardData> {
  const WorkspaceDashboardProvider._({
    required WorkspaceDashboardFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'workspaceDashboardProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$workspaceDashboardHash();

  @override
  String toString() {
    return r'workspaceDashboardProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<WorkspaceDashboardData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WorkspaceDashboardData> create(Ref ref) {
    final argument = this.argument as String;
    return workspaceDashboard(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkspaceDashboardProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$workspaceDashboardHash() =>
    r'4f10afd329a5ceb6fd9451d46e96f5bbf14f9d58';

final class WorkspaceDashboardFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<WorkspaceDashboardData>, String> {
  const WorkspaceDashboardFamily._()
    : super(
        retry: null,
        name: r'workspaceDashboardProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WorkspaceDashboardProvider call(String publicId) =>
      WorkspaceDashboardProvider._(argument: publicId, from: this);

  @override
  String toString() => r'workspaceDashboardProvider';
}
