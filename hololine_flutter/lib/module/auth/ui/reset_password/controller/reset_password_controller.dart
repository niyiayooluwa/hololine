import 'dart:async';
import 'package:hololine_flutter/module/auth/domain/usecase/reset_password_usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reset_password_controller.g.dart';

@riverpod
class ResetPasswordController extends _$ResetPasswordController {
  @override
  FutureOr<bool> build() => false;

  ResetPasswordUsecase get resetPasswordUseCase =>
      ref.read(resetPasswordUsecaseProvider);

  Future<void> resetPassword(String code, String password) async {
    // Set state to loading
    state = const AsyncLoading();

    // execute the usecase
    final result = await resetPasswordUseCase.call(code, password);

    // Handle response
    state = result.fold(
      ifLeft: (failure) => AsyncError(failure, StackTrace.current),
      ifRight: (response) => AsyncData(response),
    );
  }
}
