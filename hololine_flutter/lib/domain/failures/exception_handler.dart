import 'dart:async';
import 'dart:io';
import 'package:hololine_flutter/domain/failures/failures.dart';

class ExceptionHandler {
  static Failure handleException(dynamic exception) {
    // Get the exception type name as a string
    final exceptionType = exception.runtimeType.toString();
    final message = exception.toString();

    // Match against the exception types thrown from your server
    switch (exceptionType) {
      case 'AuthenticationException':
        return AuthFailure(message);
      case 'NotFoundException':
        return NotFoundFailure(message);
      case 'PermissionDeniedException':
        return PermissionDeniedFailure(message);
      case 'ConflictException':
        return ConflictFailure(message);
      case 'InvalidStateException':
        return InvalidStateFailure(message);
      default:
        // Handle common network and parsing exceptions with user-friendly messages
        if (exception is SocketException) {
          return ServerFailure(
              'No internet connection. Please check your network.');
        }

        if (exception is FormatException) {
          return ServerFailure('Received unexpected data from server.');
        }

        if (exception is TimeoutException) {
          return ServerFailure('Request timed out. Please try again.');
        }

        // Normalize common network-related messages to a clear offline message.
        final lower = message.toLowerCase();

        // Common substrings that indicate network/connectivity problems.
        final networkIndicators = [
          'failed host lookup',
          'socketexception',
          'connection refused',
          'no address associated with hostname',
          'network is unreachable',
          'host lookup',
          'connection timed out',
          'tls',
          'handshake',
          'certificate',
          'failed to fetch',
        ];

        if (exception is SocketException ||
            networkIndicators.any((s) => lower.contains(s)) ||
            ((lower.contains('statuscode') || lower.contains('status code')) &&
                lower.contains('-1'))) {
          return ServerFailure(
              'No internet connection. Please check your network.');
        }

        // Serverpod client may throw a verbose client exception like
        // "Serverpod client exception: unknown server response code ...".
        // Normalize those to a simple user-facing message.
        if (exceptionType.toLowerCase().contains('serverpod') ||
            lower.contains('unknown server response') ||
            lower.contains('serverpod client exception')) {
          return ServerFailure('Hmm.. Something went wrong on our end');
        }

        // Fallback for unknown exceptions: use the friendly generic message.
        return ServerFailure('Hmm.. Something went wrong on our end');
    }
  }
}
