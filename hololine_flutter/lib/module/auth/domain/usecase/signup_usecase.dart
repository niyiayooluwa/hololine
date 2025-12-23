import 'package:dart_either/dart_either.dart';
import 'package:hololine_flutter/domain/failures/failures.dart';
import 'package:hololine_flutter/module/auth/data/repository/auth_repository_impl.dart';
import 'package:hololine_flutter/module/auth/domain/repository/auth_repository.dart';
import 'package:hololine_flutter/utils/validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RegisterUsecase {
  final AuthRepository _authRepository;

  RegisterUsecase(this._authRepository);

  Future<Either<Failure, bool>> call(
    String userName,
    String email,
    String password,
  ) async {
    final emailError = validateEmail(email);
    if (emailError != null) {
      return Left(AuthFailure.invalidEmail());
    }

    if (password.isEmpty) {
      return Left(AuthFailure.wrongPassword());
    }

    return await _authRepository.register(userName, email, password);
  }
}

final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return RegisterUsecase(authRepository);
});
