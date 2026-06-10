import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hololine_flutter/core/errors/failures.dart';
import 'package:hololine_flutter/core/utils/toast_helper.dart';
import 'package:hololine_flutter/feature/auth/provider/notifier/reset_password_request_controller.dart';
import 'package:hololine_flutter/feature/auth/provider/state/reset_password_request_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ResetPasswordRequestForm extends HookConsumerWidget {
  const ResetPasswordRequestForm({super.key, this.showLogo = true});
  final bool showLogo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = useResetPasswordRequestState();
    final formKey = formState.formKey;

    ref.listen<AsyncValue<bool?>>(resetPasswordRequestControllerProvider, (
      previous,
      next,
    ) {
      next.whenOrNull(
        data: (response) {
          if (response == true) {
            showSuccessToast(
              context,
              title: 'Request Successful',
              message: 'Check your email for the verification code.',
            );
            context.go(
              '/auth/reset-password/verify',
              extra: formState.emailController.text.trim(),
            );
          }
        },
        error: (error, _) {
          if (error is Failure) {
            showErrorToast(context, error);
          }
        },
      );
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(showLogo: showLogo),
        const SizedBox(height: 24),

        ShadForm(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // EMAIL INPUT FIELD
              ShadInputFormField(
                id: 'email',
                placeholder: const Text('Enter your email'),
                keyboardType: TextInputType.emailAddress,
                controller: formState.emailController,
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
              Consumer(
                builder: (context, ref, child) {
                  final state = ref.watch(
                    resetPasswordRequestControllerProvider,
                  );
                  final isLoading = state.isLoading;

                  return ShadButton(
                    width: double.infinity,
                    enabled: formState.isFormValid.value && !isLoading,
                    onPressed: formState.isFormValid.value && !isLoading
                        ? () async {
                            if (formKey.currentState!.validate()) {
                              final email = formState.emailController.text
                                  .trim();
                              await ref
                                  .read(
                                    resetPasswordRequestControllerProvider
                                        .notifier,
                                  )
                                  .resetPasswordRequest(email);
                            }
                          }
                        : null,
                    leading: isLoading
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

              const SizedBox(height: 16),

              const Center(child: _ReturnToLoginLink()),
            ],
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final bool showLogo;
  const _Header({this.showLogo = false});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (showLogo) ...[
          SvgPicture.asset(
            'assets/svgs/logos/Osaka-colored.svg',
            height: 40,
            fit: BoxFit.contain,
            alignment: Alignment.centerLeft,
          ),
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
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ReturnToLoginLink extends StatelessWidget {
  const _ReturnToLoginLink();

  @override
  Widget build(BuildContext context) {
    return ShadButton.ghost(
      onPressed: () {
        context.go('/auth/login');
      },
      leading: const Padding(
        padding: EdgeInsets.only(right: 8.0),
        child: Icon(LucideIcons.arrowLeft, size: 16),
      ),
      child: const Text("Return to Login Page"),
    );
  }
}
