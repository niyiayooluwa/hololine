import 'package:serverpod_auth_client/serverpod_auth_client.dart';

abstract class AuthRemoteDataSource {
  Future<AuthenticationResponse> login(String email, String password);
  Future<bool> register(
    String userName,
    String email,
    String password,
  );
  Future<UserInfo?> verifyWithOtp(String email, String otp);
  Future<bool> initiatePasswordReset(String email);
  Future<bool> resetPassword(String verificationCode, String password);
}
