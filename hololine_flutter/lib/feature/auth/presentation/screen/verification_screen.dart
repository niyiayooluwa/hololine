import 'package:flutter/material.dart';
import 'package:hololine_flutter/feature/auth/presentation/shared/image_widget.dart';
import 'package:hololine_flutter/feature/auth/presentation/widget/verification_form.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class VerificationScreen extends HookConsumerWidget {
  final String email;
  const VerificationScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ShadResponsiveBuilder(
        builder: (context, breakpoint) {
          final isDesktop = breakpoint >= ShadTheme.of(context).breakpoints.md;

          return isDesktop
              ? _VerificationDesktopLayout(email: email)
              : _VerificationMobileLayout(email: email);
        },
      ),
    );
  }
}

class _VerificationDesktopLayout extends StatelessWidget {
  final String email;
  const _VerificationDesktopLayout({required this.email});

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
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 64,
                ),
                child: VerificationForm(email: email, showLogo: false),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _VerificationMobileLayout extends StatelessWidget {
  final String email;
  const _VerificationMobileLayout({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: VerificationForm(email: email),
            ),
          ),
        ),
      ),
    );
  }
}
