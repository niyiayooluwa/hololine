import 'dart:async';
import 'package:hololine_flutter/domain/failures/failures.dart';

class ExceptionHandler {
  static Failure handleException(dynamic exception) {
    // Get the exception type name as a string
    final exceptionType = exception.runtimeType.toString();
    final message = exception.toString();

    // Match against the exception types thrown from your server
    switch (exceptionType) {
      case 'AuthenticationException':
        return AuthenticationFailure(message);
      case 'NotFoundException':
        return NotFoundFailure(message);
      case 'PermissionDeniedException':
        return PermissionDeniedFailure(message);
      case 'ConflictException':
        return ConflictFailure(message);
      case 'InvalidStateException':
        return InvalidStateFailure(message);
      default:
        // Handle other exception types
        if (exception is FormatException) {
          return ServerFailure('Invalid data format: ${exception.message}');
        }

        if (exception is TimeoutException) {
          return ServerFailure('Request timeout - please try again');
        }

        // Fallback for unknown exceptions
        return ServerFailure(message);
    }
  }
}
