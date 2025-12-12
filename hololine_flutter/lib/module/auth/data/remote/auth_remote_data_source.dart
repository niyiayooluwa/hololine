import 'package:serverpod_auth_client/serverpod_auth_client.dart';

/// Defines the contract for a remote data source that handles authentication.
///
/// This abstraction is responsible for all communication with the backend
/// regarding user authentication, registration, and password management.
abstract class AuthRemoteDataSource {
  /// Authenticates a user with the given [email] and [password].
  ///
  /// Returns an [AuthenticationResponse] which contains user information and
  /// a session token upon successful login.
  Future<AuthenticationResponse> login(String email, String password);

  /// Initiates the registration process for a new user.
  ///
  /// Sends the [userName], [email], and [password] to the server to create
  /// an account request. This typically triggers a verification email.
  /// Returns `true` if the request was successfully sent.
  Future<bool> register(
    String userName,
    String email,
    String password,
  );

  /// Verifies a new user's account using their [email] and a one-time [otp].
  /// Returns the [UserInfo] on successful verification, otherwise `null`.
  Future<UserInfo?> verifyWithOtp(String email, String otp);

  /// Initiates the password reset process for the given [email].
  /// Returns `true` if the password reset email was successfully sent.
  Future<bool> initiatePasswordReset(String email);

  /// Resets the user's password using a [verificationCode] and a [newPassword].
  /// Returns `true` if the password was successfully updated.
  Future<bool> resetPassword(String verificationCode, String password);
}
