import 'dart:async';
import 'package:hololine_flutter/core/errors/failures.dart';
import 'package:hololine_flutter/feature/auth/data/repository/auth_repository.dart';
import 'package:hololine_flutter/feature/auth/data/repository/auth_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reset_password_controller.g.dart';

@riverpod
class ResetPasswordController extends _$ResetPasswordController {
  @override
  FutureOr<bool> build() => false;

  AuthRepository get auth => ref.read(authRepositoryProvider);

  Future<void> resetPassword(String code, String password) async {
    // Set state to loading
    state = const AsyncLoading();

    if (code.isEmpty) {
      state = AsyncError(
        InvalidStateFailure('Verification code cannot be empty.'),
        StackTrace.current,
      );
      return;
    }

    if (password.length < 8) {
      state = AsyncError(
        InvalidStateFailure('Password must be at least 8 characters long.'),
        StackTrace.current,
      );
      return;
    }

    // execute the usecase
    final result = await auth.resetPassword(code, password);

    // Handle response
    state = result.fold(
      ifLeft: (failure) => AsyncError(failure, StackTrace.current),
      ifRight: (response) {
        if (response) {
          return AsyncData(true);
        }
        return AsyncError(
          AuthFailure('Invalid email or password'),
          StackTrace.current,
        );
      }
    );
  }
}
