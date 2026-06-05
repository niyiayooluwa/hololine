import 'package:go_router/go_router.dart';
import 'package:hololine_flutter/components/index.dart'; // Keep for showcase if needed later
import 'package:hololine_flutter/feature/auth/presentation/screen/login_screen.dart';
import 'package:hololine_flutter/feature/auth/presentation/screen/register_screen.dart';
import 'package:hololine_flutter/feature/auth/presentation/screen/reset_password_request_screen.dart';
import 'package:hololine_flutter/feature/auth/presentation/screen/reset_password_screen.dart';
import 'package:hololine_flutter/feature/auth/presentation/screen/verification_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    //initialLocation: '/preview',
    initialLocation: '/auth/login',
    //initialLocation: '/workspacelist',
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
