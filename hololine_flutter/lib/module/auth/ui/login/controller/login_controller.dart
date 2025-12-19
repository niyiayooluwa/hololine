import 'dart:async';

import 'package:hololine_flutter/module/auth/domain/usecase/login_usecase.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:serverpod_auth_client/module.dart';

class LoginController extends AsyncNotifier<AuthenticationResponse?> {
  @override
  Future<AuthenticationResponse?> build() async {
    return null;
  }

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