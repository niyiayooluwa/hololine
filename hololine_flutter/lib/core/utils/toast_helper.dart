import 'package:flutter/material.dart';
import 'package:hololine_flutter/core/errors/remix/failures.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

/// Call this anywhere you have a BuildContext and a Failure.
/// Automatically picks the right title and description.
void showErrorToast(BuildContext context, Failure failure) {
  final (title, description) = _toastContent(failure);
  ShadToaster.of(context).show(
    ShadToast.destructive(
      title: Text(title),
      description: Text(description),
    ),
  );
}

void showSuccessToast(BuildContext context, String message) {
  ShadToaster.of(context).show(
    ShadToast(
      title: Text(message),
    ),
  );
}

(String, String) _toastContent(Failure failure) {
  return switch (failure) {
    MockLocationFailure() => (
        'Location Spoofing Detected',
        failure.message,
      ),
    AlreadyMarkedFailure() => (
        'Already Marked',
        failure.message,
      ),
    NotEnrolledFailure() => (
        'Not Enrolled',
        failure.message,
      ),
    SessionClosedFailure() => (
        'Session Closed',
        failure.message,
      ),
    InvalidQRFailure() => (
        'QR Code Expired',
        failure.message,
      ),
    InvalidOTPFailure() => (
        'Invalid OTP',
        failure.message,
      ),
    InvalidInviteCodeFailure() => (
        'Invalid Invite Code',
        failure.message,
      ),
    AlreadyMemberFailure() => (
        'Already a Member',
        failure.message,
      ),
    DuplicateFailure() => (
        'Already Exists',
        failure.message,
      ),
    InvalidCredentialsFailure() => (
        'Login Failed',
        failure.message,
      ),
    UnauthorizedFailure() => (
        'Session Expired',
        failure.message,
      ),
    NetworkFailure() => (
        'No Internet',
        failure.message,
      ),
    _ => (
        'Something went wrong',
        failure.message,
      ),
  };
}