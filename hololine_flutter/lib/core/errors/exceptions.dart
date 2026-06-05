sealed class HololineException implements Exception {
  final String message;
  const HololineException(this.message);
}

class NotFoundException extends HololineException {
  const NotFoundException(super.message);
}

class PermissionDeniedException extends HololineException {
  const PermissionDeniedException(super.message);
}

class InvalidStateException extends HololineException {
  const InvalidStateException(super.message);
}

class ConflictException extends HololineException {
  const ConflictException(super.message);
}

class AuthenticationException extends HololineException {
  const AuthenticationException(super.message);
}

class UnauthorizedException extends HololineException {
  const UnauthorizedException(super.message);
}

class InsufficientStockException extends HololineException {
  const InsufficientStockException(super.message);
}

class DuplicateSkuException extends HololineException {
  const DuplicateSkuException(super.message);
}

class CurrencyMismatchException extends HololineException {
  const CurrencyMismatchException(super.message);
}

class UnknownServerException extends HololineException {
  const UnknownServerException(super.message);
}
