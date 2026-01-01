import 'package:dart_either/dart_either.dart';
import 'package:hololine_flutter/domain/failures/failures.dart';
import 'package:hololine_flutter/module/auth/data/repository/auth_repository_impl.dart';
import 'package:hololine_flutter/module/auth/domain/repository/auth_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResetPasswordUsecase {
  final AuthRepository _authRepository;

  ResetPasswordUsecase(this._authRepository);

  Future<Either<Failure, bool>> call(String verificationCode, String password) async {
    if (verificationCode.isEmpty) {
      return Left(InvalidStateFailure('Verification code cannot be empty.'));
    }

    if (password.length < 8) {
      return Left(InvalidStateFailure('Password must be at least 8 characters long.'));
    }

    return await _authRepository.resetPassword(verificationCode, password);
  }
}

final resetPasswordUsecaseProvider = Provider<ResetPasswordUsecase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return ResetPasswordUsecase(authRepository);
});