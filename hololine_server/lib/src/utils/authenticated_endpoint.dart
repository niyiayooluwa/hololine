import 'package:serverpod/serverpod.dart';
import 'endpoint_helper.dart';
import 'exceptions.dart';

/// An abstract base class for Serverpod endpoints that require authentication.
///
/// It provides a [runAuthenticated] helper method that automatically:
/// 1. Verifies the user is authenticated via [session.authenticated].
/// 2. Throws an [AuthenticationException] if not authenticated.
/// 3. Wraps the operation in [runWithLogger] for structured logging.
/// 4. Passes the extracted [userId] to the provided [operation] callback.
abstract class AuthenticatedEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Executes [operation] after verifying the session is authenticated.
  ///
  /// Extracts the [userId] from the session and passes it to the [operation]
  /// callback. The whole process is wrapped in [runWithLogger] using the
  /// provided [methodName].
  Future<T> runAuthenticated<T>(
    Session session,
    String methodName,
    Future<T> Function(int userId) operation,
  ) async {
    final authInfo = await session.authenticated;
    final userId = authInfo?.userId;

    if (userId == null) {
      throw AuthenticationException('User not authenticated');
    }

    return runWithLogger(session, methodName, () async {
      return await operation(userId);
    });
  }
}
