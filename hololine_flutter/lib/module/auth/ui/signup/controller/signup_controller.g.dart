// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'signup_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SignupController)
const signupControllerProvider = SignupControllerProvider._();

final class SignupControllerProvider
    extends $AsyncNotifierProvider<SignupController, bool> {
  const SignupControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'signupControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$signupControllerHash();

  @$internal
  @override
  SignupController create() => SignupController();
}

String _$signupControllerHash() => r'35a8668d520881e152620081c448fa3a04a24b58';

abstract class _$SignupController extends $AsyncNotifier<bool> {
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
