import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hololine_flutter/core/errors/failures.dart';
import 'package:hololine_flutter/feature/auth/provider/notifier/reset_password_request_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ResetPasswordRequestForm extends HookConsumerWidget {
  const ResetPasswordRequestForm({super.key, this.showLogo = true});
  final bool showLogo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final controller = ref.read(
      resetPasswordRequestControllerProvider.notifier,
    );
    final state = ref.watch(resetPasswordRequestControllerProvider);

    ref.listen<AsyncValue<bool?>>(resetPasswordRequestControllerProvider, (
      previous,
      next,
    ) {
      next.when(
        data: (response) {
          if (response == true) {
            context.go(
              '/auth/reset-password/verify',
              extra: emailController.text.trim(),
            );
          } else {
            ShadToaster.of(context).show(
              const ShadToast(
                title: Text('Reset Failed'),
                description: Text('Unable to process reset password request.'),
              ),
            );
          }
        },
        error: (error, stackTrace) {
          String message;
          if (error is Failure) {
            message = error.message;
          } else {
            message = error.toString();
          }

          ShadToaster.of(context).show(
            ShadToast.destructive(
              title: const Text('Request Failed'),
              description: Text(message),
            ),
          );
        },
        loading: () {},
      );
    });

    final formKey = GlobalKey<ShadFormState>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(context, showLogo: showLogo),
        const SizedBox(height: 36),

        ShadForm(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                  if (!RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  ).hasMatch(v)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // RESET PASSWORD BUTTON
              SizedBox(
                width: double.infinity,
                child: ValueListenableBuilder(
                  valueListenable: emailController,
                  builder: (context, value, child) {
                    return ShadButton(
                      enabled: !state.isLoading,
                      onPressed: !state.isLoading
                          ? () async {
                              if (formKey.currentState!.validate()) {
                                final email = emailController.text.trim();
                                await controller.resetPasswordRequest(email);
                              }
                            }
                          : null,
                      leading: state.isLoading
                          ? SizedBox.square(
                              dimension: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: ShadTheme.of(
                                  context,
                                ).colorScheme.primaryForeground,
                              ),
                            )
                          : null,
                      child: const Text("Reset Password"),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              Center(
                child: ShadButton.ghost(
                  onPressed: () {
                    context.go('/auth/login');
                  },
                  leading: const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(LucideIcons.arrowLeft, size: 16),
                  ),
                  child: const Text("Return to Login Page"),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context, {required bool showLogo}) {
    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLogo) ...[
          SvgPicture.asset(
            'assets/svgs/logos/Osaka-colored.svg',
            height: 40,
            fit: BoxFit.contain,
            alignment: Alignment.centerLeft,
          ),
          const SizedBox(height: 24),
        ],
        const SizedBox(height: 32),

        Text(
          'Forgot your password?',
          style: theme.textTheme.h2.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),

        Text(
          "Please enter the email linked with your account and we’ll send you a One-Time Password(OTP).",
          style: theme.textTheme.muted.copyWith(fontSize: 14, height: 1.5),
        ),
      ],
    );
  }
}
