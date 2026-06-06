import 'package:flutter/material.dart';
import 'package:hololine_flutter/feature/auth/presentation/shared/image_widget.dart';
import 'package:hololine_flutter/feature/auth/presentation/widget/login_form.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShadResponsiveBuilder(
        builder: (context, breakpoint) {
          final isDesktop = breakpoint >= ShadTheme.of(context).breakpoints.md;

          return isDesktop
              ? const _LoginDesktopLayout()
              : const _LoginMobileLayout();
        },
      ),
    );
  }
}

class _LoginDesktopLayout extends StatelessWidget {
  const _LoginDesktopLayout();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left panel — image + copy
        const Expanded(flex: 55, child: AuthImagePanel()),

        // Right panel — form
        Expanded(
          flex: 45,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              // Restored SingleChildScrollView to prevent vertical overflow
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 64,
                ),
                child: const LoginForm(showLogo: false),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LoginMobileLayout extends StatelessWidget {
  const _LoginMobileLayout();

  @override
  Widget build(BuildContext context) {
    // Removed the nested Scaffold
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: const LoginForm(),
          ),
        ),
      ),
    );
  }
}
