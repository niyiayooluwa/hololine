// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ResetPasswordController)
const resetPasswordControllerProvider = ResetPasswordControllerProvider._();

final class ResetPasswordControllerProvider
    extends $AsyncNotifierProvider<ResetPasswordController, bool> {
  const ResetPasswordControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'resetPasswordControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$resetPasswordControllerHash();

  @$internal
  @override
  ResetPasswordController create() => ResetPasswordController();
}

String _$resetPasswordControllerHash() =>
    r'8ac653faba90cb424d99eb11ad62631a50e86788';

abstract class _$ResetPasswordController extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<bool>, bool>,
        AsyncValue<bool>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
