import 'package:dart_either/dart_either.dart';
import 'package:hololine_flutter/domain/failures/failures.dart';
import 'package:hololine_flutter/module/auth/data/repository/auth_repository_impl.dart';
import 'package:hololine_flutter/module/auth/domain/repository/auth_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResetPasswordUsecase {
  final AuthRepository _authRepository;

  ResetPasswordUsecase(this._authRepository);

  Future<Either<Failure, bool>> call(String email) async {
    if (email.isEmpty) {
      return Left(AuthFailure.invalidEmail());
    }

    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email)) {
      return Left(AuthFailure.invalidEmail());
    }

    return await _authRepository.initiatePasswordReset(email);
  }
}

final resetPasswordUsecaseProvider = Provider<ResetPasswordUsecase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return ResetPasswordUsecase(authRepository);
});
