/// A base class for all workspace-related exceptions to allow for generic
/// error handling.
class WorkspaceException implements Exception {
  final String message;

  WorkspaceException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

/// Thrown when a user is not authenticated.
class AuthenticationException extends WorkspaceException {
  AuthenticationException(super.message);
}

/// Thrown when a user does not have the required permissions to perform an
/// action.
class PermissionDeniedException extends WorkspaceException {
  PermissionDeniedException(super.message);
}

/// Thrown when a requested resource (e.g., workspace, member, user)
/// cannot be found.
class NotFoundException extends WorkspaceException {
  NotFoundException(super.message);
}

/// Thrown when an action would result in a conflict with the current state,
/// such as creating a resource that already exists.
class ConflictException extends WorkspaceException {
  ConflictException(super.message);
}

/// Thrown when an action cannot be performed due to the invalid state of a
/// resource (e.g., trying to modify an archived workspace).
class InvalidStateException extends WorkspaceException {
  InvalidStateException(super.message);
}

/// Thrown when an external service (e.g., email provider) fails.
class ExternalServiceException extends WorkspaceException {
  ExternalServiceException(super.message);
}

/// Thrown when an operation requires more stock than is available.
class InsufficientStockException extends WorkspaceException {
  final int catalogId;
  final double requested;
  final double available;

  InsufficientStockException({
    required String message,
    required this.catalogId,
    required this.requested,
    required this.available,
  }) : super(message);

  @override
  String toString() => '$runtimeType: $message (Catalog: $catalogId, Requested: $requested, Available: $available)';
}

/// Thrown when a duplicate SKU is detected within a workspace.
class DuplicateSkuException extends WorkspaceException {
  final String sku;
  final int workspaceId;

  DuplicateSkuException({
    required String message,
    required this.sku,
    required this.workspaceId,
  }) : super(message);

  @override
  String toString() => '$runtimeType: $message (SKU: $sku, Workspace: $workspaceId)';
}

/// Thrown when currencies do not match during a transaction.
class CurrencyMismatchException extends WorkspaceException {
  final String expected;
  final String found;

  CurrencyMismatchException({
    required String message,
    required this.expected,
    required this.found,
  }) : super(message);

  @override
  String toString() => '$runtimeType: $message (Expected: $expected, Found: $found)';
}

/// Thrown when a user is not authorized to perform an action.
class UnauthorizedException extends WorkspaceException {
  UnauthorizedException(super.message);
}
