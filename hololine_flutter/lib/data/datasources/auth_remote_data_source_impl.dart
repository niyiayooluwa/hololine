import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/data/datasources/auth_remote_data_source.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart'
    as serverpod_auth;
import 'package:serverpod_auth_client/serverpod_auth_client.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  late final Client serverpodClient;

  AuthRemoteDataSourceImpl({required this.serverpodClient});

  @override
  Future<AuthenticationResponse> login(
    String email,
    String password,
  ) async {
    return await serverpodClient.modules.auth.email
        .authenticate(email, password);
  }

  @override
  Future<bool> register(
    String userName,
    String email,
    String password,
  ) async {
    return await serverpodClient.modules.auth.email
        .createAccountRequest(userName, email, password);
  }

  @override
  Future<serverpod_auth.UserInfo?> verifyWithOtp(
    String email,
    String otp,
  ) async {
    return await serverpodClient.modules.auth.email.createAccount(email, otp);
  }

  @override
  Future<bool> initiatePasswordReset(String email) async {
    return await serverpodClient.modules.auth.email
        .initiatePasswordReset(email);
  }

  @override
  Future<bool> resetPassword(
    String verificationCode,
    String password,
  ) async {
    return await serverpodClient.modules.auth.email
        .resetPassword(verificationCode, password);
  }
}
