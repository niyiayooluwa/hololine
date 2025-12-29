import 'package:dart_either/dart_either.dart';
import 'package:hololine_flutter/domain/failures/failures.dart';
import 'package:hololine_flutter/module/auth/data/repository/auth_repository_impl.dart';
import 'package:hololine_flutter/module/auth/domain/repository/auth_repository.dart';
import 'package:hololine_flutter/utils/validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:serverpod_auth_client/module.dart';

class VerificationUsecase {
  final AuthRepository _authRepository;

  VerificationUsecase(this._authRepository);

  Future<Either<Failure, UserInfo?>> call(
    String email,
    String otp,
  ) async {
    final emailError = validateEmail(email);
    if (emailError != null) {
      return Left(AuthFailure.invalidEmail());
    } if (otp.isEmpty) {
      return Left(AuthFailure.invalidCredentials());
    }
    return await _authRepository.verifyWithOtp(email, otp);
  }
}

final verificationUsecaseProvider = Provider<VerificationUsecase>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return VerificationUsecase(authRepository);
});