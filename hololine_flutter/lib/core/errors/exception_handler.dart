import 'dart:async';
import 'dart:io';

import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/core/errors/exceptions.dart';
import 'package:hololine_flutter/core/errors/failures.dart';

class ExceptionHandler {
  ExceptionHandler._();

  /// Call this in every repository catch block.
  /// Returns a [Failure] — never throws.
  ///
  /// Usage:
  /// ```dart
  /// try {
  ///   return await client.workspace.getWorkspaceDetails(publicId);
  /// } catch (e) {
  ///   throw ExceptionHandler.handle(e);
  /// }
  /// ```
  static Failure handle(Object exception) {
    // ServerpodClientException wraps server-thrown exceptions.
    // Parse it into a typed HololineException first, then map to Failure.
    if (exception is ServerpodClientException) {
      return _failureFromHololineException(_parse(exception));
    }

    // Already a typed HololineException (shouldn't normally happen
    // but handles direct throws in tests or local code).
    if (exception is HololineException) {
      return _failureFromHololineException(exception);
    }

    // Network errors
    if (exception is SocketException) {
      return const NetworkFailure();
    }

    if (exception is TimeoutException) {
      return const NetworkFailure('Request timed out. Please try again.');
    }

    if (exception is FormatException) {
      return const ServerFailure('Received unexpected data from server.');
    }

    // Catch-all network string patterns
    final lower = exception.toString().toLowerCase();
    const networkIndicators = [
      'failed host lookup',
      'socketexception',
      'connection refused',
      'no address associated with hostname',
      'network is unreachable',
      'connection timed out',
      'tls handshake',
      'certificate',
      'failed to fetch',
    ];

    if (networkIndicators.any((s) => lower.contains(s))) {
      return const NetworkFailure();
    }

    return const ServerFailure();
  }

  /// Parses a [ServerpodClientException] into a typed [HololineException].
  /// Your server toString() format is: 'ExceptionClassName: message'
  static HololineException _parse(ServerpodClientException e) {
    final raw = e.message;
    final colonIndex = raw.indexOf(':');

    final className = colonIndex != -1
        ? raw.substring(0, colonIndex).trim()
        : raw.trim();

    final message = colonIndex != -1
        ? raw.substring(colonIndex + 1).trim()
        : raw.trim();

    return switch (className) {
      'NotFoundException' => NotFoundException(message),
      'PermissionDeniedException' => PermissionDeniedException(message),
      'InvalidStateException' => InvalidStateException(message),
      'ConflictException' => ConflictException(message),
      'AuthenticationException' => AuthenticationException(message),
      'UnauthorizedException' => UnauthorizedException(message),
      'InsufficientStockException' => InsufficientStockException(message),
      'DuplicateSkuException' => DuplicateSkuException(message),
      'CurrencyMismatchException' => CurrencyMismatchException(message),
      _ => UnknownServerException(raw),
    };
  }

  /// Maps a typed [HololineException] to a [Failure].
  static Failure _failureFromHololineException(HololineException e) =>
      switch (e) {
        NotFoundException() => NotFoundFailure(e.message),
        PermissionDeniedException() => PermissionDeniedFailure(e.message),
        InvalidStateException() => InvalidStateFailure(e.message),
        ConflictException() => ConflictFailure(e.message),
        AuthenticationException() => AuthFailure(e.message),
        UnauthorizedException() => AuthFailure(e.message),
        InsufficientStockException() => InsufficientStockFailure(e.message),
        DuplicateSkuException() => DuplicateSkuFailure(e.message),
        CurrencyMismatchException() => CurrencyMismatchFailure(e.message),
        UnknownServerException() => ServerFailure(e.message),
      };
}
