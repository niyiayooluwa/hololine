import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hololine_flutter/core/errors/failures.dart';
import 'package:hololine_flutter/core/utils/toast_helper.dart';
import 'package:hololine_flutter/feature/auth/provider/notifier/login_controller.dart';
import 'package:hololine_flutter/feature/auth/provider/state/login_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LoginForm extends HookConsumerWidget {
  const LoginForm({super.key, this.showLogo = true});

  final bool showLogo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(loginControllerProvider, (_, next) {
      next.whenOrNull(
        error: (e, _) {
          if (e is Failure) {
            showErrorToast(context, e);
          }
        },
      );
    });
    final formState = useLoginForm();

    final vm = ref.watch(loginControllerProvider);
    final controller = ref.read(loginControllerProvider.notifier);
    final isLoading = vm.isLoading;

    final formKey = formState.formKey;

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
              // EMAIL FIELD
              ShadInputFormField(
                id: 'email',
                controller: formState.emailController,
                label: const Text('Email'),
                placeholder: const Text('Enter your email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              // PASSWORD FIELD
              ShadInputFormField(
                id: 'password',
                controller: formState.passwordController,
                label: const Text('Password'),
                placeholder: const Text('Enter your password'),
                obscureText: !formState.isPasswordVisible.value,
                trailing: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButton(
                    // Reduce the splash/hitbox size
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      formState.isPasswordVisible.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 20, // Explicit size helps alignment
                    ),
                    onPressed: () => formState.isPasswordVisible.value =
                        !formState.isPasswordVisible.value,
                  ),
                ),
                validator: (v) {
                  if (v.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // REMEMBER ME & FORGOT PASSWORD ROW
              _buildRememberMeRow(context, formState.rememberMe),

              SizedBox(height: 24),

              // SIGN IN BUTTON
              SizedBox(
                width: double.infinity,
                child: ShadButton(
                  enabled: formState.isFormValid.value && !isLoading,
                  onPressed: formState.isFormValid.value && !isLoading
                      ? () async {
                          if (formKey.currentState!.validate()) {
                            final email = formState.emailController.text.trim();
                            final password = formState.passwordController.text
                                .trim();

                            await controller.login(email, password);
                          }
                        }
                      : null,
                  leading: vm.isLoading
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
                  child: const Text("Sign In"),
                ),
              ),

              SizedBox(height: 24),

              // SIGN UP LINK
              _buildSignUpLink(context),
            ],
          ),
        ),
      ],
    );
  }
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
        'Welcome back!',
        style: theme.textTheme.h2.copyWith(fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 6),

      Text(
        "Enter your email and password to sign in.",
        style: theme.textTheme.muted.copyWith(fontSize: 14, height: 1.5),
      ),
    ],
  );
}

Widget _buildRememberMeRow(
  BuildContext context,
  ValueNotifier<bool> rememberMe,
) {
  final theme = ShadTheme.of(context);

  // TABLET & DESKTOP: Side by side
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        //mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 24,
            width: 24,
            child: Checkbox(
              value: rememberMe.value,
              onChanged: (value) => rememberMe.value = value ?? false,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 1),
          Text('Remember me', style: theme.textTheme.small),
        ],
      ),
      ShadButton.link(
        onPressed: () {
          context.go('/auth/forgot-password');
        },
        child: const Text('Forgot Password?'),
      ),
    ],
  );
}

// SIGN UP LINK
Widget _buildSignUpLink(BuildContext context) {
  final theme = Theme.of(context);

  return Center(
    child: Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text("Don't have an account? ", style: theme.textTheme.bodyMedium),
        TextButton(
          onPressed: () {
            context.go('/auth/signup');
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            minimumSize: const Size(0, 36),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Sign Up',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}
