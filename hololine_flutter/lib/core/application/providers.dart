import 'package:flutter/foundation.dart';
import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/core/constants/api_constants.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

/// Provider for the Serverpod client.
/// It initializes the connection to your server and sets up session management.
final clientProvider = Provider<Client>((ref) {
  // The server URL is different depending on the platform and build mode.
  const productionUrl = ApiConstants.baseUrl;
  late final String serverUrl;

  if (kReleaseMode) {
    // In release mode, we always use the production server.
    serverUrl = productionUrl;
  } else {
    // In debug mode, we use different URLs for different platforms.
    if (defaultTargetPlatform == TargetPlatform.android) {
      serverUrl = 'http://10.0.2.2:8080/'; // Android emulator
    } else {
      serverUrl = 'http://localhost:8080/'; // iOS, web, desktop
    }
  }
  // Sets up a singleton client object that can be used to talk to the server from
  // anywhere in our app.
  final client = Client(
    serverUrl,
    authenticationKeyManager: FlutterAuthenticationKeyManager(),
  )..connectivityMonitor = FlutterConnectivityMonitor();

  return client;
});

final sessionProvider = Provider<SessionManager>((ref) {
  final client = ref.watch(clientProvider);

  final sessionManager = SessionManager(
    caller: client.modules.auth,
  );
  return sessionManager;
});
