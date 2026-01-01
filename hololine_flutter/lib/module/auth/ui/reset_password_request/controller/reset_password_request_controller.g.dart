// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset_password_request_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ResetPasswordRequestController)
const resetPasswordRequestControllerProvider =
    ResetPasswordRequestControllerProvider._();

final class ResetPasswordRequestControllerProvider
    extends $AsyncNotifierProvider<ResetPasswordRequestController, bool> {
  const ResetPasswordRequestControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'resetPasswordRequestControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$resetPasswordRequestControllerHash();

  @$internal
  @override
  ResetPasswordRequestController create() => ResetPasswordRequestController();
}

String _$resetPasswordRequestControllerHash() =>
    r'a31def7add7048a301d92e1eff0350ba883c1e97';

abstract class _$ResetPasswordRequestController extends $AsyncNotifier<bool> {
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
