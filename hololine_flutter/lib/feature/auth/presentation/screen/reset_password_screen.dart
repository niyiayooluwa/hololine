import 'package:flutter/material.dart';
import 'package:hololine_flutter/feature/auth/presentation/shared/image_widget.dart';
import 'package:hololine_flutter/feature/auth/presentation/widget/reset_password_form.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ResetPasswordScreen extends StatelessWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShadResponsiveBuilder(
        builder: (context, breakpoint) {
          final isDesktop = breakpoint >= ShadTheme.of(context).breakpoints.md;

          return isDesktop
              ? const _ResetPasswordDesktopLayout()
              : const _ResetPasswordMobileLayout();
        },
      ),
    );
  }
}

class _ResetPasswordDesktopLayout extends StatelessWidget {
  const _ResetPasswordDesktopLayout();

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
              child: const SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 48, vertical: 64),
                child: ResetPasswordForm(showLogo: false),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ResetPasswordMobileLayout extends StatelessWidget {
  const _ResetPasswordMobileLayout();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: const SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: ResetPasswordForm(),
          ),
        ),
      ),
    );
  }
}
