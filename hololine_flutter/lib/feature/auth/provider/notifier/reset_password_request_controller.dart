import 'dart:async';
import 'package:hololine_flutter/core/errors/failures.dart';
import 'package:hololine_flutter/core/utils/validators.dart';
import 'package:hololine_flutter/feature/auth/data/repository/auth_repository.dart';
import 'package:hololine_flutter/feature/auth/data/repository/auth_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reset_password_request_controller.g.dart';

@riverpod
class ResetPasswordRequestController extends _$ResetPasswordRequestController {
  @override
  FutureOr<bool> build() => false;

  AuthRepository get auth => ref.read(authRepositoryProvider);

  Future<void> resetPasswordRequest(String email) async {
    // Set state to loading
    state = const AsyncLoading();

    if (email.isEmpty) {
      AsyncError(AuthFailure.invalidEmail(), StackTrace.current);
      return;
    }

    final validateEmaiil = validateEmail(email);
    if (validateEmaiil != null) {
      AsyncError(AuthFailure.invalidEmail(), StackTrace.current);
      return;
    }

    // execute the usecase
    final result = await auth.initiatePasswordReset(email);

    // Handle response
    state = result.fold(
      ifLeft: (failure) => AsyncError(failure, StackTrace.current),
      ifRight: (response) => AsyncData(response),
    );
  }
}
