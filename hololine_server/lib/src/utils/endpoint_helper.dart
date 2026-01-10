import 'package:serverpod/serverpod.dart';

/// A generic wrapper that logs the start, success, and failure of an endpoint.
/// It allows the return type [T] to pass through to the client.
Future<T> runWithLogger<T>(
  Session session,
  String endpointName,
  Future<T> Function() operation,
) async {
  session.log('Endpoint "$endpointName" called.', level: LogLevel.info);
  try {
    final result = await operation();
    
    // Log success (we don't print the whole object to save log space)
    session.log('Endpoint "$endpointName" succeeded.', level: LogLevel.info);
    
    return result;
  } catch (e, stackTrace) {
    session.log(
      '"$endpointName" failed.',
      level: LogLevel.error,
      exception: e,
      stackTrace: stackTrace,
    );
    // Rethrowing is CRITICAL. It lets Serverpod send the error code 
    // to the client instead of a false "success".
    rethrow; 
  }
}