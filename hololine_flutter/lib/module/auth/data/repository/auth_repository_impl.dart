import 'package:dart_either/dart_either.dart';
import 'package:hololine_flutter/module/auth/data/remote/auth_remote_data_source.dart';
import 'package:hololine_flutter/module/auth/data/remote/auth_remote_data_source_impl.dart';
import 'package:hololine_flutter/domain/failures/exception_handler.dart';
import 'package:hololine_flutter/domain/failures/failures.dart';
import 'package:hololine_flutter/module/auth/domain/repository/auth_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';

/// Implementation of the [AuthRepository] that communicates with a remote
/// data source to handle authentication-related operations.
///
/// This class wraps the data source calls in `try-catch` blocks and uses an
/// [ExceptionHandler] to convert exceptions into domain-specific [Failure]
/// types, returning them in an [Either] wrapper.
class AuthRepositoryImpl implements AuthRepository {
  /// The remote data source for authentication.
  final AuthRemoteDataSource remoteDataSource;

  /// Creates an instance of [AuthRepositoryImpl].
  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AuthenticationResponse>> login(
    String email,
    String password,
  ) async {
    try {
      // Attempt to log in using the remote data source.
      final response = await remoteDataSource.login(email, password);

      // On success, wrap the response in a `Right`.
      return Right(response);
    } catch (e) {
      // On failure, handle the exception and wrap the resulting `Failure` in a `Left`.
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> register(
    String userName,
    String email,
    String password,
  ) async {
    try {
      // Attempt to register a new user.
      final response =
          await remoteDataSource.register(userName, email, password);
      // On success, return `true` wrapped in a `Right`.
      return Right(response);
    } catch (e) {
      // On failure, handle the exception.
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, UserInfo?>> verifyWithOtp(
    String email,
    String otp,
  ) async {
    try {
      // Attempt to verify the user's account with the provided OTP.
      final response = await remoteDataSource.verifyWithOtp(email, otp);
      // On success, return the `UserInfo` wrapped in a `Right`.
      return Right(response);
    } catch (e) {
      // On failure, handle the exception.
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> initiatePasswordReset(String email) async {
    try {
      // Attempt to initiate the password reset process for the given email.
      final response = await remoteDataSource.initiatePasswordReset(email);
      // On success, return `true` wrapped in a `Right`.
      return Right(response);
    } catch (e) {
      // On failure, handle the exception.
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> resetPassword(
    String verificationCode,
    String password,
  ) async {
    try {
      // Attempt to reset the password using the verification code.
      final response = await remoteDataSource.resetPassword(
        verificationCode,
        password,
      );
      // On success, return `true` wrapped in a `Right`.
      return Right(response);
    } catch (e) {
      // On failure, handle the exception.
      return Left(ExceptionHandler.handleException(e));
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource: remoteDataSource);
});
