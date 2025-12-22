// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoginController)
const loginControllerProvider = LoginControllerProvider._();

final class LoginControllerProvider
    extends $AsyncNotifierProvider<LoginController, AuthenticationResponse?> {
  const LoginControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'loginControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$loginControllerHash();

  @$internal
  @override
  LoginController create() => LoginController();
}

String _$loginControllerHash() => r'8ea99b2d61f07b7d0c5dcf57abe6c0b13e73856d';

abstract class _$LoginController
    extends $AsyncNotifier<AuthenticationResponse?> {
  FutureOr<AuthenticationResponse?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref
        as $Ref<AsyncValue<AuthenticationResponse?>, AuthenticationResponse?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<AuthenticationResponse?>,
            AuthenticationResponse?>,
        AsyncValue<AuthenticationResponse?>,
        Object?,
        Object?>;
    element.handleValue(ref, created);
  }
}
