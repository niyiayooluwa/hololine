import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hololine_flutter/core/errors/failures.dart';
import 'package:hololine_flutter/feature/auth/provider/notifier/verification_controller.dart';
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
    final otpController = useTextEditingController();
    final controller = ref.read(verificationControllerProvider.notifier);
    final state = ref.watch(verificationControllerProvider);

    ref.listen<AsyncValue<UserInfo?>>(verificationControllerProvider, (
      previous,
      next,
    ) {
      next.when(
        data: (user) {
          if (user != null) {
            ShadToaster.of(context).show(
              const ShadToast(
                title: Text('Verification Successful'),
                description: Text('You have been verified successfully.'),
              ),
            );
            context.go('/workspacelist');
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
              title: const Text('Verification Failed'),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // OTP INPUT FIELD
              ShadInputOTPFormField(
                id: 'otp',
                maxLength: 6,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('^[a-zA-Z0-9]+')),
                ],
                onChanged: (v) => otpController.text = v,
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
              SizedBox(
                width: double.infinity,
                child: ValueListenableBuilder(
                  valueListenable: otpController,
                  builder: (context, value, child) {
                    return ShadButton(
                      onPressed: value.text.length == 6 && !state.isLoading
                          ? () async {
                              if (formKey.currentState!.validate()) {
                                final otp = otpController.text.trim();
                                await controller.verifyOtp(email, otp);
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
                      child: const Text("Verify Code"),
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
