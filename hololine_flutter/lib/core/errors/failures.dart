sealed class Failure {
  final String message;
  const Failure(this.message);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed.']);
  const AuthFailure.invalidEmail() : super('Please enter a valid email address.');
  const AuthFailure.invalidPassword() : super('Password cannot be empty.');
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

class PermissionDeniedFailure extends Failure {
  const PermissionDeniedFailure(super.message);
}

class ConflictFailure extends Failure {
  const ConflictFailure(super.message);
}

class InvalidStateFailure extends Failure {
  const InvalidStateFailure(super.message);
}

class InsufficientStockFailure extends Failure {
  const InsufficientStockFailure(super.message);
}

class DuplicateSkuFailure extends Failure {
  const DuplicateSkuFailure(super.message);
}

class CurrencyMismatchFailure extends Failure {
  const CurrencyMismatchFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection. Please check your network.']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong on our end.']);
}