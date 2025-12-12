import 'package:dart_either/dart_either.dart';
import 'package:hololine_flutter/module/auth/data/repository/auth_repository_impl.dart';
import 'package:hololine_flutter/domain/failures/failures.dart';
import 'package:hololine_flutter/module/auth/domain/repository/auth_repository.dart';
import 'package:hololine_flutter/utils/validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';

class LoginUsecase {
  final AuthRepository _authRepository;

  LoginUsecase(this._authRepository);

  Future<Either<Failure, AuthenticationResponse>> call(
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

    return await _authRepository.login(email, password);
  }
}

final loginUsecaseProvider = Provider<LoginUsecase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return LoginUsecase(authRepository);
});
