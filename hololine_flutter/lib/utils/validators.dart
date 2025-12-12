// lib/utils/validators.dart

/// Validates an email address.
///
/// Returns an error message if invalid, otherwise null.
String? validateEmail(String email) {
  if (email.isEmpty) {
    return 'Email is required';
  }
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(email)) {
    return 'Invalid email format';
  }
  return null;
}

/// Validates a Nigerian phone number.
///
/// Returns an error message if invalid, otherwise null.
String? validatePhoneNumber(String phoneNumber) {
  if (phoneNumber.isEmpty) {
    return 'Phone number is required';
  }
  if (!phoneNumber.startsWith('0')) {
    return 'Phone number must start with 0';
  }
  if (phoneNumber.length != 11) {
    return 'Phone number must be 11 digits long';
  }
  return null;
}
/// Validates a password.
///
/// Returns an error message if invalid, otherwise null.
String? validatePassword(String password) {
  if (password.isEmpty) {
    return 'Password is required';
  }
  if (password.length < 8) {
    return 'Password must be at least 8 characters long.';
  }
  if (!password.contains(RegExp(r'[A-Z]'))) {
    return 'Password must contain at least one uppercase letter.';
  }
  if (!password.contains(RegExp(r'[0-9]'))) {
    return 'Password must contain at least one number.';
  }
  if (!password.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'))) {
    return 'Password must contain at least one special character.';
  }
  return null;
}

/// Validates a name field.
///
/// Returns an error message if invalid, otherwise null.
String? validateName(String name) {
  if (name.isEmpty) {
    return 'Name is required';
  }
  if (name.length < 2) {
    return 'Name must be at least 2 characters';
  }
  return null;
}

