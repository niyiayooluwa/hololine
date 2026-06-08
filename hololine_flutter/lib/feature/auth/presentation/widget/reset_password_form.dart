import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hololine_flutter/core/errors/failures.dart';
import 'package:hololine_flutter/core/utils/toast_helper.dart';
import 'package:hololine_flutter/feature/auth/provider/notifier/reset_password_controller.dart';
import 'package:hololine_flutter/feature/auth/provider/state/reset_password_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ResetPasswordForm extends HookConsumerWidget {
  const ResetPasswordForm({super.key, this.showLogo = true});
  final bool showLogo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = useResetPasswordForm();
    final formKey = formState.formKey;

    ref.listen<AsyncValue<bool?>>(resetPasswordControllerProvider, (
      previous,
      next,
    ) {
      next.whenOrNull(
        data: (response) {
          if (response == true) {
            showSuccessToast(
              context,
              title: 'Password Reset Successful',
              message: 'You can now log in with your new password.',
            );
            context.go('/auth/login');
          }
        },
        error: (error, _) {
          if (error is Failure) {
            showErrorToast(context, error);
          }
        },
      );
    });

    final page = formState.page.value;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(page: page, showLogo: showLogo),
        const SizedBox(height: 36),

        ShadForm(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (page == 1) ...[
                // OTP INPUT FIELD
                ShadInputOTPFormField(
                  id: 'otp',
                  maxLength: 6,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('^[a-zA-Z0-9]+')),
                  ],
                  onChanged: (v) => formState.codeController.text = v,
                  validator: (v) {
                    if (v.contains(' ')) {
                      return 'Fill the whole OTP code';
                    }
                    return null;
                  },
                  children: const [
                    ShadInputOTPGroup(
                      children: [
                        ShadInputOTPSlot(),
                        ShadInputOTPSlot(),
                        ShadInputOTPSlot(),
                      ],
                    ),
                    Icon(size: 24, LucideIcons.dot),
                    ShadInputOTPGroup(
                      children: [
                        ShadInputOTPSlot(),
                        ShadInputOTPSlot(),
                        ShadInputOTPSlot(),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // VERIFY CODE BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ValueListenableBuilder(
                    valueListenable: formState.codeController,
                    builder: (context, value, child) {
                      return ShadButton(
                        enabled: formState.codeController.text.replaceAll(' ', '').length == 6,
                        onPressed: formState.codeController.text.replaceAll(' ', '').length == 6
                            ? () {
                                if (formKey.currentState!.validate()) {
                                  formState.page.value = 2;
                                }
                              }
                            : null,
                        child: const Text("Verify Code"),
                      );
                    },
                  ),
                ),
              ] else ...[
                ShadInputFormField(
                  id: 'new_password',
                  label: const Text('New Password'),
                  controller: formState.passwordController,
                  obscureText: !formState.isPasswordVisible.value,
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        formState.isPasswordVisible.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 20,
                      ),
                      onPressed: () => formState.isPasswordVisible.value =
                          !formState.isPasswordVisible.value,
                    ),
                  ),
                  validator: (v) {
                    if (v.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                ShadInputFormField(
                  id: 'confirm_password',
                  label: const Text('Confirm Password'),
                  controller: formState.confirmPasswordController,
                  obscureText: !formState.isConfirmPasswordVisible.value,
                  trailing: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        formState.isConfirmPasswordVisible.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        size: 20,
                      ),
                      onPressed: () =>
                          formState.isConfirmPasswordVisible.value =
                              !formState.isConfirmPasswordVisible.value,
                    ),
                  ),
                  validator: (v) {
                    if (v != formState.passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // RESET PASSWORD BUTTON
                Consumer(
                  builder: (context, ref, child) {
                    final state = ref.watch(resetPasswordControllerProvider);
                    final isLoading = state.isLoading;

                    return SizedBox(
                      width: double.infinity,
                      child: ShadButton(
                        enabled: formState.isFormValid.value && !isLoading,
                        onPressed: formState.isFormValid.value && !isLoading
                            ? () async {
                                if (formKey.currentState!.validate()) {
                                  final code = formState.codeController.text
                                      .trim();
                                  final password = formState
                                      .passwordController
                                      .text
                                      .trim();
                                  ref
                                      .read(
                                        resetPasswordControllerProvider
                                            .notifier,
                                      )
                                      .resetPassword(code, password);
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
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                Center(
                  child: ShadButton.ghost(
                    onPressed: () => formState.page.value = 1,
                    leading: const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(LucideIcons.arrowLeft, size: 16),
                    ),
                    child: const Text("Back"),
                  ),
                ),
              ],
              if (page == 1) ...[
                const SizedBox(height: 16),
                const Center(child: _ReturnToLoginLink()),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final int page;
  final bool showLogo;

  const _Header({required this.page, this.showLogo = false});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final isPageOne = page == 1;

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
          const SizedBox(height: 24),
        ],
        const SizedBox(height: 32),

        Text(
          isPageOne ? "Verification" : "Reset Password",
          style: theme.textTheme.h2.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),

        Text(
          isPageOne
              ? "Please enter the code sent to your email."
              : "Enter your new password below.",
          style: theme.textTheme.muted.copyWith(fontSize: 14, height: 1.5),
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
