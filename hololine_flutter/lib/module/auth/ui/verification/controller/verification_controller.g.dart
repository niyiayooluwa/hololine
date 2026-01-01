// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verification_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(VerificationController)
const verificationControllerProvider = VerificationControllerProvider._();

final class VerificationControllerProvider
    extends $AsyncNotifierProvider<VerificationController, UserInfo?> {
  const VerificationControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'verificationControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$verificationControllerHash();

  @$internal
  @override
  VerificationController create() => VerificationController();
}

String _$verificationControllerHash() =>
    r'8f216445c93a54622cef1fcacb05892d5e1d663d';

abstract class _$VerificationController extends $AsyncNotifier<UserInfo?> {
  FutureOr<UserInfo?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<UserInfo?>, UserInfo?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<UserInfo?>, UserInfo?>,
        AsyncValue<UserInfo?>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
