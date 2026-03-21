import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hololine_flutter/module/auth/ui/login/widget/login_screen.dart';
import 'package:hololine_flutter/module/auth/ui/reset_password/widget/reset_password_screen.dart';
import 'package:hololine_flutter/module/auth/ui/reset_password_request/widget/reset_password_request_screen.dart';
import 'package:hololine_flutter/module/auth/ui/signup/widget/register_screen.dart';
import 'package:hololine_flutter/module/auth/ui/verification/widget/verification_screen.dart';
import 'package:hololine_flutter/module/workspace/ui/workspacelist/widgets/workspace_list_screen.dart';
import 'package:hololine_flutter/preview.dart';
import 'package:hololine_flutter/shared_ui/index.dart'; // Keep for showcase if needed later
import 'package:hooks_riverpod/hooks_riverpod.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    //initialLocation: '/preview',
    initialLocation: '/auth/login',
    //initialLocation: '/workspacelist',
    routes: [
      GoRoute(
        path: '/preview',
        builder: (context, state) => const PreviewScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const ComponentShowcase(),
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
        builder: (context, state) => VerificationScreen(
          email: state.extra as String,
        ),
      ),
      GoRoute(
        path: '/auth/forgot-password',
        builder: (context, state) => const ResetPasswordRequestScreen(),
      ),
      GoRoute(
        path: '/auth/reset-password/verify',
        builder: (context, state) => ResetPasswordScreen(
          email: state.extra as String,
        ),
      ),
      GoRoute(
        path: '/workspace/:publicId',
        builder: (context, state) {
          final publicId = state.pathParameters['publicId'];
          return Scaffold(
            appBar: AppBar(title: Text('Workspace $publicId')),
            body: Center(child: Text('Workspace $publicId Details')),
          );
        },
      ),
      GoRoute(
        path: '/workspacelist',
        builder: (context, state) => const WorkspaceListScreen(),
      ),
    ],
  );
});
