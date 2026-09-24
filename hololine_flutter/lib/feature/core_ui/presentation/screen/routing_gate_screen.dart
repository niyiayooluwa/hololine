import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:hololine_flutter/core/application/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RoutingGateScreen extends HookConsumerWidget {
  const RoutingGateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      Future<void> routeUser() async {
        // Ensure the widget is fully mounted before navigating
        await Future.delayed(Duration.zero);
        if (!context.mounted) return;

        final session = ref.read(sessionProvider);
        if (session.isSignedIn) {
          context.go('/workspaces');
        } else {
          context.go('/auth/login');
        }
      }

      routeUser();
      return null;
    }, []);

    final theme = ShadTheme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Center(
        child: SpinKitRipple(color: theme.colorScheme.primary, size: 80.0),
      ),
    );
  }
}
