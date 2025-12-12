import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/core/application/providers.dart';
import 'package:hololine_flutter/module/auth/data/remote/auth_remote_data_source.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:serverpod_auth_client/serverpod_auth_client.dart'
    as serverpod_auth;
import 'package:serverpod_auth_client/serverpod_auth_client.dart';

/// Implementation of [AuthRemoteDataSource] that communicates with the
/// Serverpod authentication endpoints.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  /// The Serverpod client used to make API calls.
  final Client _client;

  /// Creates an instance of [AuthRemoteDataSourceImpl].
  ///
  /// Requires a [serverpodClient] to interact with the backend.
  AuthRemoteDataSourceImpl({required Client serverpodClient})
      : _client = serverpodClient;

  /// Authenticates a user with their [email] and [password].
  ///
  /// Returns an [AuthenticationResponse] on success.
  @override
  Future<AuthenticationResponse> login(
    String email,
    String password,
  ) async {
    // Calls the `authenticate` method from the Serverpod auth email module.
    return await _client.modules.auth.email.authenticate(email, password);
  }

  /// Initiates the user registration process.
  ///
  /// Sends a request to create a new account with the given [userName], [email],
  /// and [password]. This typically triggers a verification email.
  /// Returns `true` if the request was sent successfully.
  @override
  Future<bool> register(
    String userName,
    String email,
    String password,
  ) async {
    // Calls the `createAccountRequest` method to start the sign-up flow.
    return await _client.modules.auth.email
        .createAccountRequest(userName, email, password);
  }

  /// Verifies a new user account using an [email] and a one-time password [otp].
  ///
  /// Returns the [serverpod_auth.UserInfo] if the verification is successful,
  /// otherwise returns `null`.
  @override
  Future<serverpod_auth.UserInfo?> verifyWithOtp(
    String email,
    String otp,
  ) async {
    // Calls the `createAccount` method to finalize account creation with the OTP.
    return await _client.modules.auth.email.createAccount(email, otp);
  }

  /// Initiates the password reset process for a given [email].
  ///
  /// Returns `true` if the password reset email was sent successfully.
  @override
  Future<bool> initiatePasswordReset(String email) async {
    // Calls the `initiatePasswordReset` method on the auth module.
    return await _client.modules.auth.email.initiatePasswordReset(email);
  }

  /// Resets the user's password using a [verificationCode] and a [newPassword].
  ///
  /// Returns `true` if the password was reset successfully.
  @override
  Future<bool> resetPassword(
    String verificationCode,
    String password,
  ) async {
    // Calls the `resetPassword` method to set the new password.
    return await _client.modules.auth.email
        .resetPassword(verificationCode, password);
  }
}

/// Provider for the AuthRemoteDataSource.
/// It watches [clientProvider] to get the initialized Serverpod client
/// and injects it into the data source implementation.
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final client = ref.watch(clientProvider);
  return AuthRemoteDataSourceImpl(serverpodClient: client);
});

