import 'dart:async';

import 'package:hololine_flutter/module/auth/domain/usecase/login_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_client/module.dart';

part 'login_controller.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<AuthenticationResponse?> build() => null;

  LoginUsecase get loginUseCase => ref.read(loginUsecaseProvider);

  Future<void> login(String email, String password) async {
    // Set state to loading
    state = AsyncLoading();

    // execute the usecase
    final result = await loginUseCase.call(email, password);

    // Handle response
    state = result.fold(
      ifLeft: (failure) => AsyncError(failure, StackTrace.current),
      ifRight: (response) => AsyncData(response),
    );
  }
}