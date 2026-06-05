import 'dart:async';
import 'package:hololine_flutter/core/errors/failures.dart';
import 'package:hololine_flutter/core/utils/logging.dart';
import 'package:hololine_flutter/core/utils/validators.dart';
import 'package:hololine_flutter/feature/auth/data/repository/auth_repository.dart';
import 'package:hololine_flutter/feature/auth/data/repository/auth_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';

part 'verification_controller.g.dart';

@riverpod
class VerificationController extends _$VerificationController {
  @override
  FutureOr<UserInfo?> build() => null;

  AuthRepository get auth => ref.read(authRepositoryProvider);

  Future<void> verifyOtp(String email, String otp) async {
    // Set state to loading
    state = const AsyncLoading();

    final emailError = validateEmail(email);
    if (emailError != null) {
      AsyncError(AuthFailure.invalidEmail(), StackTrace.current);
      return;
    }
    if (otp.isEmpty) {
      AsyncError(
        InvalidStateFailure('OTP cannot be empty'),
        StackTrace.current,
      );
      return;
    }

    // execute the usecase
    final result = await auth.verifyWithOtp(email, otp);

    // Handle response
    state = result.fold(
      ifLeft: (failure) => AsyncError(failure, StackTrace.current),
      ifRight: (response) {
        if (response == null) {
          logger(
            'Login failed',
            level: LogLevel.error,
            stackTrace: StackTrace.current,
          );
          return AsyncError('Verification failed', StackTrace.current);
        }
        return AsyncData(response);
      },
    );
  }
}
