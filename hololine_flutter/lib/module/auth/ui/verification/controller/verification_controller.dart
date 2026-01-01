import 'dart:async';
import 'package:hololine_flutter/module/auth/domain/usecase/verify_otp_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';

part 'verification_controller.g.dart';

@riverpod
class VerificationController extends _$VerificationController {
  @override
  FutureOr<UserInfo?> build() => null;

  VerificationUsecase get verificationUseCase =>
      ref.read(verificationUsecaseProvider);

  Future<void> verifyOtp(String email, String otp) async {
    // Set state to loading
    state = const AsyncLoading();

    // execute the usecase
    final result = await verificationUseCase.call(email, otp);

    // Handle response
    state = result.fold(
      ifLeft: (failure) => AsyncError(failure, StackTrace.current),
      ifRight: (response) {
        if (response == null) {
          return AsyncError('Verification failed', StackTrace.current);
        }
        return AsyncData(response);
      },
    );
  }
}
