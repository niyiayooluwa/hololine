import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hololine_flutter/module/auth/ui/reset_password_request/controller/reset_password_request_controller.dart';
import 'package:hololine_flutter/shared_ui/core/breakpoints.dart';
import 'package:hololine_flutter/shared_ui/core/components.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ResetPasswordRequestScreen extends HookConsumerWidget {
  const ResetPasswordRequestScreen({super.key});

  // Breakpoints
  static const double formMaxWidth = 420;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final controller = ref.read(resetPasswordRequestControllerProvider.notifier);
    final state = ref.watch(resetPasswordRequestControllerProvider);

    ref.listen<AsyncValue<bool?>>(
      resetPasswordRequestControllerProvider,
      (previous, next) {
        next.when(
          data: (response) {
            if (response == true) {
              context.go('/auth/reset-password/verify',
                  extra: emailController.text.trim());
            } else {
              ShadToaster.of(context).show(
                ShadToast(
                  title: const Text('Reset Failed'),
                  description:
                      const Text('Unable to process reset password request.'),
                ),
              );
            }
          },
          error: (error, stackTrace) {
            ShadToaster.of(context).show(
              ShadToast.destructive(
                title: const Text('Verification Failed'),
                description: Text(error.toString()),
              ),
            );
          },
          loading: () {},
        );
      },
    );
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          // Determine device type
          final isMobile = width < Breakpoints.Mobile;
          //final isDesktop = width >= Breakpoints.Desktop;

          /*if (isDesktop) {
            // DESKTOP LAYOUT: Image on left, form on right
            return Row(
              children: [
                // LEFT: Image Panel
                Expanded(
                  flex: 6,
                  child: _buildImagePanel(context),
                ),

                // RIGHT: Form Panel
                Expanded(
                  flex: 4,
                  child: Center(
                    child: SingleChildScrollView(
                      child: _buildFormContainer(
                        context,
                        emailController,
                        controller,
                        state,
                        isMobile: false,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }*/

          // MOBILE & TABLET LAYOUT: Just the form, centered
          return Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 24,
                vertical: 24,
              ),
              child: _buildFormContainer(
                context,
                emailController,
                controller,
                state,
                isMobile: isMobile,
              ),
            ),
          );
        },
      ),
    );
  }

  // IMAGE PANEL (Desktop only)
  /*Widget _buildImagePanel(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withValues(alpha: 0.5),
              theme.colorScheme.secondary.withValues(alpha: 0.5),
              theme.colorScheme.secondary,
            ],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.login_rounded,
              size: 120,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to Holo',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Sign in to access your dashboard and manage your account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }*/

  // FORM CONTAINER (Used in all layouts)
  Widget _buildFormContainer(
      BuildContext context,
      TextEditingController emailController,
      ResetPasswordRequestController controller,
      AsyncValue<bool?> state,
      {required bool isMobile}) {
    return Container(
      decoration: isMobile
          ? null
          : BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
      constraints: BoxConstraints(
        maxWidth: formMaxWidth,
      ),
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      child: _buildForm(
        context,
        emailController,
        controller,
        state,
        isMobile: isMobile,
      ),
    );
  }

  // MAIN FORM
  Widget _buildForm(BuildContext context, TextEditingController emailController,
      ResetPasswordRequestController controller, AsyncValue<bool?> state,
      {required bool isMobile}) {
    // Responsive values
    final titleFontSize = isMobile ? 24.0 : 28.0;
    final subtitleFontSize = isMobile ? 14.0 : 16.0;
    final spacingLarge = isMobile ? 24.0 : 32.0;
    final spacingMedium = isMobile ? 16.0 : 20.0;

    final formKey = GlobalKey<ShadFormState>();

    return ShadForm(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // HEADER
          _buildHeader(
            context,
            titleFontSize: titleFontSize,
            subtitleFontSize: subtitleFontSize,
          ),

          SizedBox(height: spacingLarge),

          // EMAIL INPUT FIELD
          ShadInputFormField(
            id: 'email',
            label: const Text('Email'),
            placeholder: const Text('Enter your email'),
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            validator: (v) {
              if (v.isEmpty) {
                return 'Email is required';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),

          SizedBox(height: spacingLarge),

          // RESET PASSWORD BUTTON
          SizedBox(
            width: double.infinity,
            height: isMobile ? 44 : 48,
            child: ValueListenableBuilder(
              valueListenable: emailController,
              builder: (context, value, child) {
                return ShadButton(
                  onPressed: !state.isLoading
                      ? () async {
                          if (formKey.currentState!.validate()) {
                            final email = emailController.text.trim();
                            await controller.resetPasswordRequest(email);
                          }
                        }
                      : null,
                  child: const Text("Reset Password"),
                );
              },
            ),
          ),

          SizedBox(height: spacingMedium),

          ShadButton.ghost(
            onPressed: () {
              context.go('/auth/login');
            },
            leading: const Icon(LucideIcons.arrowLeft),
            child: const Text("Return to Login Page"),
          ),
        ],
      ),
    );
  }

  // HEADER SECTION
  Widget _buildHeader(
    BuildContext context, {
    required double titleFontSize,
    required double subtitleFontSize,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        Text(
          "Forgot your password?",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: titleFontSize,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Please enter the email linked with your account and we’ll send you a One-Time Password(OTP).",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            fontSize: subtitleFontSize,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
