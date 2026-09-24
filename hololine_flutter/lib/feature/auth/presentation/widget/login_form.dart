import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
      next.when(
        data: (response) {
          if (response != null && response.success) {
            context.go('/');
          }
        },
        error: (e, _) {
          if (e is Failure) {
            showErrorToast(context, e);
          }
        },
        loading: () {},
      );
    });
    final formState = useLoginForm();

    final formKey = formState.formKey;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Header(showLogo: showLogo),
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
                placeholder: const Text('johndoe@somemail.com'),
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
                placeholder: const Text('••••••••••••••••••••••'),
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
              _RemeberMeRow(formState.rememberMe),

              SizedBox(height: 24),

              // SIGN IN BUTTON
              Consumer(
                builder: (context, ref, child) {
                  final vm = ref.watch(loginControllerProvider);
                  final isLoading = vm.isLoading;

                  return ShadButton(
                    width: double.infinity,
                    enabled: formState.isFormValid.value && !isLoading,
                    onPressed: formState.isFormValid.value && !isLoading
                        ? () async {
                            if (formKey.currentState!.validate()) {
                              final email = formState.emailController.text
                                  .trim();
                              final password = formState.passwordController.text
                                  .trim();

                              await ref
                                  .read(loginControllerProvider.notifier)
                                  .login(email, password);
                            }
                          }
                        : null,
                    leading: isLoading
                        ? SizedBox.square(
                            dimension: 16,
                            child: SpinKitRipple(
                              color: ShadTheme.of(
                                context,
                              ).colorScheme.secondary,
                            ),
                          )
                        : null,
                    child: const Text("Sign In"),
                  );
                },
              ),
            ],
          ),
        ),

        SizedBox(height: 24),

        // SIGN UP LINK
        const _SignupLink(),
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
}

class _RemeberMeRow extends StatelessWidget {
  const _RemeberMeRow(this.rememberMe);

  final ValueNotifier<bool> rememberMe;

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    // TABLET & DESKTOP: Side by side
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          //mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: 20,
              child: Checkbox(
                value: rememberMe.value,
                onChanged: (value) => rememberMe.value = value ?? false,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: 4),
            Text('Remember me', style: theme.textTheme.small),
          ],
        ),
        GestureDetector(
          onTap: () {
            context.go('/auth/forgot-password');
          },
          child: Text(
            'Forgot Password?',
            style: theme.textTheme.small.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}

// SIGN UP LINK
class _SignupLink extends StatelessWidget {
  const _SignupLink();

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text("Not a member yet? ", style: theme.textTheme.muted),
          GestureDetector(
            onTap: () {
              context.go('/auth/signup');
            },
            child: Text(
              'Register now!',
              style: theme.textTheme.small.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
