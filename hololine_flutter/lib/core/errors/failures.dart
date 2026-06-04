sealed class Failure {
  final String message;

  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

// Add more specific failures
class NotFoundFailure extends ServerFailure {
  const NotFoundFailure(super.message);
}

class PermissionDeniedFailure extends ServerFailure {
  const PermissionDeniedFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);

  factory AuthFailure.weakPassword() =>
      const AuthFailure('Password is too weak.');

  factory AuthFailure.emailInUse() =>
      const AuthFailure('Email is already in use. Try logging in instead.');

  factory AuthFailure.invalidEmail() =>
      const AuthFailure('Invalid email address.');

  factory AuthFailure.userNotFound() => const AuthFailure('User not found.');

  factory AuthFailure.wrongPassword() =>
      const AuthFailure('Incorrect password.');

  factory AuthFailure.invalidCredentials() =>
      const AuthFailure('Email or password is incorrect.');

  factory AuthFailure.accountLocked(String message) => AuthFailure(message);
}

class ConflictFailure extends ServerFailure {
  const ConflictFailure(super.message);
}

class InvalidStateFailure extends ServerFailure {
  const InvalidStateFailure(super.message);
}
