import 'package:flutter/material.dart';
import 'package:hololine_flutter/core/application/providers.dart';
import 'package:hololine_flutter/routing/router_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

Future<void> main() async {
  // Ensures that the Flutter binding is initialized before any Flutter specific
  // code is executed. This is necessary because we are performing async
  // operations before calling runApp().
  WidgetsFlutterBinding.ensureInitialized();

  // Create a ProviderContainer to access providers outside of the widget tree.
  // This is the recommended approach for performing initialization tasks
  // that depend on providers before the app starts.
  final container = ProviderContainer();

  // Initialize the session manager. This will check for any persisted user
  // session from previous runs of the app.
  await container.read(sessionProvider).initialize();

  // Run the app, wrapping the root widget in an UncontrolledProviderScope.
  // This makes the providers from our container available to the entire app.
  runApp(UncontrolledProviderScope(
    container: container,
    child: const MyApp(),
  ));
}

/// Root widget of the application.
///
/// As a [ConsumerWidget], it can listen to providers. It sets up the
/// [MaterialApp.router] and configures the app's theme, routing, and title.
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return ShadApp.router(
      title: 'Hololine',
      theme: ShadThemeData(colorScheme: const ShadOrangeColorScheme.light()),
      darkTheme: ShadThemeData(colorScheme: const ShadOrangeColorScheme.dark()),
      //theme: AppTheme.lightTheme as ShadThemeData,
      //darkTheme: AppTheme.darkTheme as ShadThemeData,
      themeMode: ThemeMode.system,
      //debugShowCheckedModeBanner: true,
      routerConfig: router,
    );
  }
}
