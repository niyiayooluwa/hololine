// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(workspaceDetail)
const workspaceDetailProvider = WorkspaceDetailFamily._();

final class WorkspaceDetailProvider
    extends
        $FunctionalProvider<
          AsyncValue<Workspace>,
          Workspace,
          FutureOr<Workspace>
        >
    with $FutureModifier<Workspace>, $FutureProvider<Workspace> {
  const WorkspaceDetailProvider._({
    required WorkspaceDetailFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'workspaceDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$workspaceDetailHash();

  @override
  String toString() {
    return r'workspaceDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Workspace> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Workspace> create(Ref ref) {
    final argument = this.argument as String;
    return workspaceDetail(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkspaceDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$workspaceDetailHash() => r'58784c85a9faa771bcc28ccec7dfb727e2a6d308';

final class WorkspaceDetailFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Workspace>, String> {
  const WorkspaceDetailFamily._()
    : super(
        retry: null,
        name: r'workspaceDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WorkspaceDetailProvider call(String publicId) =>
      WorkspaceDetailProvider._(argument: publicId, from: this);

  @override
  String toString() => r'workspaceDetailProvider';
}
