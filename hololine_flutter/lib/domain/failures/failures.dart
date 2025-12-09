abstract class Failure {}

class ServerFailure extends Failure {
  final String message;
  ServerFailure(this.message);
}

class CacheFailure extends Failure {}

// Add more specific failures
class NotFoundFailure extends ServerFailure {
  NotFoundFailure(super.message);
}

class PermissionDeniedFailure extends ServerFailure {
  PermissionDeniedFailure(super.message);
}

class AuthenticationFailure extends ServerFailure {
  AuthenticationFailure(super.message);
}

class ConflictFailure extends ServerFailure {
  ConflictFailure(super.message);
}

class InvalidStateFailure extends ServerFailure {
  InvalidStateFailure(super.message);
}
