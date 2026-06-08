import 'dart:async';

import 'package:hololine_flutter/core/errors/failures.dart';
import 'package:hololine_flutter/core/utils/validators.dart';
import 'package:hololine_flutter/feature/auth/data/repository/auth_repository.dart';
import 'package:hololine_flutter/feature/auth/data/repository/auth_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_client/module.dart';

part 'login_controller.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  FutureOr<AuthenticationResponse?> build() => null;

  AuthRepository get auth => ref.read(authRepositoryProvider);

  Future<void> login(String email, String password) async {
    // Set state to loading
    state = const AsyncLoading();

    final emailError = validateEmail(email);
    if (emailError != null) {
      state = AsyncError(AuthFailure.invalidEmail(), StackTrace.current);
      return;
    }

    if (password.isEmpty) {
      state = AsyncError(AuthFailure.invalidPassword(), StackTrace.current);
      return;
    }

    // execute the usecase
    final result = await auth.login(email, password);

    // Handle response
    state = result.fold(
      ifLeft: (failure) => AsyncError(failure, StackTrace.current),
      ifRight: (response) {
        if (response.success) {
          return AsyncData(response);
        }
        return AsyncError(
          AuthFailure('Invalid email or password'),
          StackTrace.current,
        );
      },
    );
  }
}
