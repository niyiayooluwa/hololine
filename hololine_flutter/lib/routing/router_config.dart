import 'package:go_router/go_router.dart';
import 'package:hololine_flutter/module/auth/ui/login/widget/login_screen.dart';
import 'package:hololine_flutter/module/auth/ui/reset_password/widget/reset_password_screen.dart';
import 'package:hololine_flutter/module/auth/ui/reset_password_request/widget/reset_password_request_screen.dart';
import 'package:hololine_flutter/module/auth/ui/signup/widget/register_screen.dart';
import 'package:hololine_flutter/module/auth/ui/verification/widget/verification_screen.dart';
import 'package:hololine_flutter/shared_ui/index.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/auth/login',
    routes: [
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
        builder: (context, state) => ResetPasswordRequestScreen(),
      ),
      GoRoute(
        path: '/auth/reset-password/verify',
        builder: (context, state) => ResetPasswordScreen(
          email: state.extra as String,
        ),
      ),
    ],
  );
});
