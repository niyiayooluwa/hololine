class ApiConstants {
  // Dart reads this at compile time from the --dart-define flag.
  // The defaultValue acts as safety net if the variable isn't passed.
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://niyiayooluwa-hololine.hf.space/', 
  );
}