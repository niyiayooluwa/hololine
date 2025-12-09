import 'package:dart_either/dart_either.dart';
import 'package:hololine_flutter/data/datasources/auth_remote_data_source.dart';
import 'package:hololine_flutter/domain/failures/exception_handler.dart';
import 'package:hololine_flutter/domain/failures/failures.dart';
import 'package:hololine_flutter/domain/repository/auth_repository.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  // final LocalDataSource localDataSource; // Optional for caching

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, AuthenticationResponse>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await remoteDataSource.login(email, password);

      return Right(response);
    } catch (e) {
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
      final response =
          await remoteDataSource.register(userName, email, password);
      return Right(response);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, UserInfo?>> verifyWithOtp(
    String email,
    String otp,
  ) async {
    try {
      final response = await remoteDataSource.verifyWithOtp(email, otp);
      return Right(response);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> initiatePasswordReset(String email) async {
    try {
      final response = await remoteDataSource.initiatePasswordReset(email);
      return Right(response);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }

  @override
  Future<Either<Failure, bool>> resetPassword(
    String verificationCode,
    String password,
  ) async {
    try {
      final response = await remoteDataSource.resetPassword(
        verificationCode,
        password,
      );
      return Right(response);
    } catch (e) {
      return Left(ExceptionHandler.handleException(e));
    }
  }
}
