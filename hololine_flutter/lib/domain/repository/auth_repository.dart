import 'package:dart_either/dart_either.dart';
import 'package:hololine_flutter/domain/failures/failures.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthenticationResponse>> login(
    String email,
    String password,
  );

  Future<Either<Failure, bool>> register(
    String userName,
    String email,
    String password,
  );

  Future<Either<Failure, UserInfo?>> verifyWithOtp(String email, String otp);

  Future<Either<Failure, bool>> initiatePasswordReset(String email);

  Future<Either<Failure, bool>> resetPassword(
      String verificationCode, String password);
}
