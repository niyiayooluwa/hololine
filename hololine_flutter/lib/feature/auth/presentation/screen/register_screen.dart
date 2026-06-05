import 'package:hololine_flutter/feature/auth/presentation/shared/image_widget.dart';
import 'package:hololine_flutter/feature/auth/presentation/widget/register_form.dart';
import 'package:hololine_flutter/components/core/components.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SignupScreen extends HookConsumerWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ShadResponsiveBuilder(
        builder: (context, breakpoint) {
          final isDesktop = breakpoint >= ShadTheme.of(context).breakpoints.md;

          return isDesktop
              ? const _SignupDesktopLayout()
              : const _SignupMobileLayout();
        },
      ),
    );
  }
}

class _SignupDesktopLayout extends StatelessWidget {
  const _SignupDesktopLayout();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left panel — image + copy
        const Expanded(flex: 55, child: AuthImagePanel()),

        // Right panel — form
        Expanded(
          flex: 45,
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 48, vertical: 64),
                  child: const RegisterForm(showLogo: false),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SignupMobileLayout extends StatelessWidget {
  const _SignupMobileLayout();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: const RegisterForm(),
            ),
          ),
        ),
      ),
    );
  }
}
