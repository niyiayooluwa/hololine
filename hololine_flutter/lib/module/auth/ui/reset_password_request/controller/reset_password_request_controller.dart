import 'dart:async';
import 'package:hololine_flutter/module/auth/domain/usecase/reset_password_request_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reset_password_request_controller.g.dart';

@riverpod
class ResetPasswordRequestController extends _$ResetPasswordRequestController {
  @override
  FutureOr<bool> build() => false;

  ResetPasswordRequestUsecase get resetPasswordUseCase =>
      ref.read(resetPasswordRequestUsecaseProvider);

  Future<void> resetPasswordRequest(String email) async {
    // Set state to loading
    state = const AsyncLoading();

    // execute the usecase
    final result = await resetPasswordUseCase.call(email);

    // Handle response
    state = result.fold(
      ifLeft: (failure) => AsyncError(failure, StackTrace.current),
      ifRight: (response) => AsyncData(response),
    );
  }
}
