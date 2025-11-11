import 'package:serverpod/serverpod.dart';
import 'package:hololine_server/src/generated/protocol.dart';

/// A helper that wraps endpoint operations with consistent logging and error handling.
Future<Response> withLogging(
  Session session,
  String endpointName,
  Future<String> Function() operation,
) async {
  // Log the start of the operation
  session.log('"$endpointName" endpoint called.', level: LogLevel.info);
  try {
    // Execute the actual operation
    final successMessage = await operation();

    // Log the success
    session.log('"$endpointName" succeeded: $successMessage', level: LogLevel.info);
    return Response(
      success: true,
      message: successMessage,
    );
  } catch (e, stackTrace) {
    // Log the error
    session.log(
      '"$endpointName" failed.',
      level: LogLevel.error,
      exception: e,
      stackTrace: stackTrace,
    );
    return Response(
      success: false,
      error: e.toString(),
    );
  }
}
