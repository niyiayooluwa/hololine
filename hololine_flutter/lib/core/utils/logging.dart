import 'package:flutter/foundation.dart';

enum LogLevel { info, warning, error }

void logger(
  String message, {
  LogLevel level = LogLevel.info,
  Object? error,
  StackTrace? stackTrace,
}) {
  if (!kDebugMode) return;

  final prefix = switch (level) {
    LogLevel.info => '💬 INFO',
    LogLevel.warning => '⚠️  WARN',
    LogLevel.error => '🔴 ERROR',
  };

  if (kDebugMode) {
    print('$prefix: $message');
  }
  if (error != null) {
    if (kDebugMode) {
      print('   ↳ $error');
    }
  }
  if (stackTrace != null) {
    if (kDebugMode) {
      print('   ↳ $stackTrace');
    }
  }
}
