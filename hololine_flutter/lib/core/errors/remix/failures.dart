abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Something went wrong. Please try again.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Could not load saved data. Please try again.']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = "Oops! Can't connect to the internet. Check your connection and try again."]);
}

class OtherFailure extends Failure {
  const OtherFailure([super.message = 'Something unexpected happened. Please try again.']);
}

class MockLocationFailure extends Failure {
  const MockLocationFailure([super.message = 'Mock location detected. Disable any fake GPS apps and try again.']);
}

class AlreadyMarkedFailure extends Failure {
  const AlreadyMarkedFailure([super.message = 'You have already marked attendance for this session.']);
}

class NotEnrolledFailure extends Failure {
  const NotEnrolledFailure([super.message = 'You are not enrolled in this course.']);
}

class SessionClosedFailure extends Failure {
  const SessionClosedFailure([super.message = 'This session is no longer active.']);
}

class InvalidQRFailure extends Failure {
  const InvalidQRFailure([super.message = 'This QR code has expired. Wait for the next one and try again.']);
}

class InvalidOTPFailure extends Failure {
  const InvalidOTPFailure([super.message = 'Invalid or expired OTP. Request a new one and try again.']);
}

class InvalidInviteCodeFailure extends Failure {
  const InvalidInviteCodeFailure([super.message = 'That invite code is invalid. Double-check it and try again.']);
}

class AlreadyMemberFailure extends Failure {
  const AlreadyMemberFailure([super.message = 'You are already a member of this course.']);
}

class DuplicateFailure extends Failure {
  const DuplicateFailure([super.message = 'This already exists. Please check and try again.']);
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure([super.message = 'Incorrect email or password.']);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Your session has expired. Please log in again.']);
}