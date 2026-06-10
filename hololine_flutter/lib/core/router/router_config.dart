import 'package:go_router/go_router.dart'; // Keep for showcase if needed later
import 'package:hololine_flutter/feature/auth/presentation/screen/login_screen.dart';
import 'package:hololine_flutter/feature/auth/presentation/screen/register_screen.dart';
import 'package:hololine_flutter/feature/auth/presentation/screen/reset_password_request_screen.dart';
import 'package:hololine_flutter/feature/auth/presentation/screen/reset_password_screen.dart';
import 'package:hololine_flutter/feature/auth/presentation/screen/verification_screen.dart';
import 'package:hololine_flutter/feature/core_ui/presentation/screen/routing_gate_screen.dart';
import 'package:hololine_flutter/feature/workspace/presentation/screen/workspace_dashboard_screen.dart';
import 'package:hololine_flutter/feature/account/presentation/screen/account_settings_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hololine_flutter/feature/core_ui/presentation/screen/workspace_shell_screen.dart';
import 'package:hololine_flutter/feature/core_ui/presentation/screen/workspace_placeholder_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const RoutingGateScreen(),
      ),
      GoRoute(
        path: '/workspaces',
        builder: (context, state) => const DashboardScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return WorkspaceShellScreen(child: child);
        },
        routes: [
          GoRoute(
            path: '/workspace/:id/dashboard',
            builder: (context, state) =>
                const WorkspacePlaceholderScreen(title: 'Dashboard View'),
          ),
          GoRoute(
            path: '/workspace/:id/ledger',
            builder: (context, state) =>
                const WorkspacePlaceholderScreen(title: 'Ledger View'),
          ),
          GoRoute(
            path: '/workspace/:id/catalog',
            builder: (context, state) =>
                const WorkspacePlaceholderScreen(title: 'Catalog View'),
          ),
          GoRoute(
            path: '/workspace/:id/inventory',
            builder: (context, state) =>
                const WorkspacePlaceholderScreen(title: 'Inventory View'),
          ),
          GoRoute(
            path: '/workspace/:id/analytics',
            builder: (context, state) =>
                const WorkspacePlaceholderScreen(title: 'Analytics View'),
          ),
          GoRoute(
            path: '/workspace/:id/ai',
            builder: (context, state) =>
                const WorkspacePlaceholderScreen(title: 'AI Reporting View'),
          ),
          GoRoute(
            path: '/workspace/:id/members',
            builder: (context, state) =>
                const WorkspacePlaceholderScreen(title: 'Members View'),
          ),
          GoRoute(
            path: '/workspace/:id/settings',
            builder: (context, state) =>
                const WorkspacePlaceholderScreen(title: 'Settings View'),
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) {
          final tab = state.uri.queryParameters['tab'] ?? 'profile';
          return AccountSettingsScreen(activeTab: tab);
        },
      ),
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/auth/verification',
        builder: (context, state) =>
            VerificationScreen(email: state.extra as String),
      ),
      GoRoute(
        path: '/auth/forgot-password',
        builder: (context, state) => const ResetPasswordRequestScreen(),
      ),
      GoRoute(
        path: '/auth/reset-password/verify',
        builder: (context, state) =>
            ResetPasswordScreen(email: state.extra as String),
      ),
    ],
  );
});
