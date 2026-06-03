import 'package:serverpod/serverpod.dart';
import 'endpoint_helper.dart';
import 'exceptions.dart';

/// An abstract base class for Serverpod endpoints that require authentication.
abstract class AuthenticatedEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;
}

/// Executes [operation] after verifying the session is authenticated.
///
/// Extracts the [userId] from the session and passes it to the [operation]
/// callback. The whole process is wrapped in [runWithLogger] using the
/// provided [methodName].
///
/// This is a top-level function to avoid Serverpod's endpoint analyzer
/// attempting to expose it as an RPC endpoint.
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
