import 'package:flutter/foundation.dart';

void logger(String message) {
  if (kDebugMode) {
    print('Log: $message');
  }
}
