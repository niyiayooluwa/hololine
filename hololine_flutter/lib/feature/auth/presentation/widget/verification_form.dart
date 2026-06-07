import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hololine_flutter/core/errors/failures.dart';
import 'package:hololine_flutter/core/utils/toast_helper.dart';
import 'package:hololine_flutter/feature/auth/provider/notifier/verification_controller.dart';
import 'package:hololine_flutter/feature/auth/provider/state/verification_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:serverpod_auth_client/module.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class VerificationForm extends HookConsumerWidget {
  const VerificationForm({
    super.key,
    required this.email,
    this.showLogo = true,
  });
  final String email;
  final bool showLogo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = useVerificationState();
    final formKey = formState.formKey;

    ref.listen<AsyncValue<UserInfo?>>(verificationControllerProvider, (
      previous,
      next,
    ) {
      next.whenOrNull(
        data: (user) {
          if (user != null) {
            showSuccessToast(
              context,
              title: 'Verification Successful',
              message: 'You have been verified successfully.',
            );
            context.go('/gate');
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
        _Header(email: email, showLogo: showLogo),
        const SizedBox(height: 36),

        ShadForm(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // OTP INPUT FIELD
              ShadInputOTPFormField(
                id: 'otp',
                maxLength: 6,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('^[a-zA-Z0-9]+')),
                ],
                onChanged: (v) => formState.otpController.text = v,
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

              // SIGN IN BUTTON
              Consumer(
                builder: (context, ref, child) {
                  final state = ref.watch(verificationControllerProvider);
                  final isLoading = state.isLoading;

                  return ShadButton(
                    width: double.infinity,
                    enabled: formState.isFormValid.value && !isLoading,
                    onPressed: formState.isFormValid.value && !isLoading
                        ? () async {
                            if (formKey.currentState!.validate()) {
                              final otp = formState.otpController.text.trim();
                              await ref.read(verificationControllerProvider.notifier).verifyOtp(email, otp);
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
                    child: const Text("Verify Code"),
                  );
                },
              ),

              const SizedBox(height: 16),

              const Center(
                child: _ReturnToLoginLink(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final String email;
  final bool showLogo;

  const _Header({
    required this.email,
    this.showLogo = false,
  });

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
          const SizedBox(height: 24),
        ],
        const SizedBox(height: 32),

        Text(
          'Enter Verification Code',
          style: theme.textTheme.h2.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),

        Text(
          "Please enter the code sent to $email.",
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
