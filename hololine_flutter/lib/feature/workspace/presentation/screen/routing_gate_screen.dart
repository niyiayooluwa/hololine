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
    final status = useState('Checking authentication...');
    final workspaceCount = useState<int?>(null);
    final isSignedIn = useState(false);
    final isLoading = useState(true);

    // A hook state trigger to re-run the status check when incremented
    final refreshTrigger = useState(0);

    useEffect(() {
      Future<void> checkStatus() async {
        final session = ref.read(sessionProvider);
        isSignedIn.value = session.isSignedIn;

        if (!session.isSignedIn) {
          status.value = 'Not authenticated.';
          isLoading.value = false;
          return;
        }

        try {
          status.value = 'Fetching workspaces...';
          final workspaces = await ref.refresh(myWorkspacesProvider.future);
          workspaceCount.value = workspaces.length;
          status.value = 'Found ${workspaces.length} workspace(s).';
          isLoading.value = false;
        } catch (e) {
          status.value = 'Error: ${e.toString()}';
          isLoading.value = false;
        }
      }

      checkStatus();
      return null;
    }, [refreshTrigger.value]);

    final theme = ShadTheme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading.value) ...[
                SpinKitRipple(color: theme.colorScheme.primary, size: 80.0),
                const SizedBox(height: 24),
              ],
              Text(
                'Routing Gate (Debug Mode)',
                style: theme.textTheme.h3.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                status.value,
                style: theme.textTheme.muted,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Signed In: ${isSignedIn.value} | Workspaces: ${workspaceCount.value ?? "unknown"}',
                style: theme.textTheme.small.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 32),
              if (!isLoading.value) ...[
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    ShadButton(
                      onPressed: () => context.go('/workspaces'),
                      child: const Text('Go to Dashboard (/workspaces)'),
                    ),
                    ShadButton.outline(
                      onPressed: () => context.go('/auth/login'),
                      child: const Text('Go to Login'),
                    ),
                    ShadButton.ghost(
                      onPressed: () {
                        isLoading.value = true;
                        refreshTrigger.value++;
                      },
                      child: const Text('Refresh'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
