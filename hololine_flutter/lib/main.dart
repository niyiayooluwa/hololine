import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/core/constants/api_constants.dart';
import 'package:hololine_flutter/routing/router_config.dart';
import 'package:hololine_flutter/ui/core/ui/theme/theme.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

late SessionManager sessionManager;
late Client client;

Future<void> main() async {
  // Need to call this as we are using Flutter bindings before runApp is called.
  WidgetsFlutterBinding.ensureInitialized();

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
  // anywhere in our app. The client is generated from your server code.
  client = Client(
    serverUrl,
    authenticationKeyManager: FlutterAuthenticationKeyManager(),
  )..connectivityMonitor = FlutterConnectivityMonitor();

  // The session manager keeps track of the signed-in state of the user. You
  // can query it to see if the user is currently signed in and get information
  // about the user.
  sessionManager = SessionManager(
    caller: client.modules.auth,
  );
  await sessionManager.initialize();

  runApp(const ProviderScope(child: MyApp()));
}

/// Root widget of the application.
/// This sets up the theme, routing, and initial screen.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Hololine',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: true,
      routerConfig: router,
    );
  }
}
