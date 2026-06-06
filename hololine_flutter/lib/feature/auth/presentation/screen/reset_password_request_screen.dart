import 'package:flutter/material.dart';
import 'package:hololine_flutter/feature/auth/presentation/shared/image_widget.dart';
import 'package:hololine_flutter/feature/auth/presentation/widget/reset_password_request_form.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ResetPasswordRequestScreen extends StatelessWidget {
  const ResetPasswordRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShadResponsiveBuilder(
        builder: (context, breakpoint) {
          final isDesktop = breakpoint >= ShadTheme.of(context).breakpoints.md;

          return isDesktop
              ? const _ResetPasswordRequestDesktopLayout()
              : const _ResetPasswordRequestMobileLayout();
        },
      ),
    );
  }
}

class _ResetPasswordRequestDesktopLayout extends StatelessWidget {
  const _ResetPasswordRequestDesktopLayout();

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
                child: ResetPasswordRequestForm(showLogo: false),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ResetPasswordRequestMobileLayout extends StatelessWidget {
  const _ResetPasswordRequestMobileLayout();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: const SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: ResetPasswordRequestForm(),
          ),
        ),
      ),
    );
  }
}
