import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:hololine_flutter/core/errors/failures.dart';
import 'package:hololine_flutter/core/utils/toast_helper.dart';
import 'package:hololine_flutter/feature/auth/provider/notifier/signup_controller.dart';
import 'package:hololine_flutter/feature/auth/provider/state/register_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RegisterForm extends HookConsumerWidget {
  const RegisterForm({super.key, this.showLogo = true});

  final bool showLogo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = useRegisterForm();
    final formKey = formState.formKey;

    ref.listen(signupControllerProvider, (_, next) {
      next.whenOrNull(
        data: (isSuccessful) {
          if (isSuccessful == true) {
            showSuccessToast(
              context,
              title: 'Signup Successful. ',
              message: 'Please verify your email to continue.',
            );
            final email = formState.emailController.text.trim();
            context.go('/auth/verification', extra: email);
          }
        },
        error: (e, _) {
          if (e is Failure) {
            showErrorToast(context, e);
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
        const SizedBox(height: 36),

        ShadForm(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ShadInputFormField(
                      id: 'first_name',
                      controller: formState.firstNameController,
                      label: const Text('First Name'),
                      placeholder: const Text('John'),
                      keyboardType: TextInputType.name,
                      validator: (v) {
                        if (v.isEmpty) return 'Please enter your first name';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ShadInputFormField(
                      id: 'last_name',
                      controller: formState.lastNameController,
                      label: const Text('Last Name'),
                      placeholder: const Text('Williams'),
                      keyboardType: TextInputType.name,
                      validator: (v) {
                        if (v.isEmpty) return 'Please enter your last name';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // EMAIL FIELD
              ShadInputFormField(
                id: 'email',
                label: const Text('Email'),
                controller: formState.emailController,
                placeholder: const Text('john.doe@example.com'),
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
              const SizedBox(height: 16),

              // PASSWORD FIELD
              ShadInputFormField(
                id: 'password',
                label: const Text('Password'),
                controller: formState.passwordController,
                placeholder: const Text('Enter your password'),
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
              ),
              const SizedBox(height: 16),

              // CONFIRM PASSWORD FIELD
              ShadInputFormField(
                id: 'confirm_password',
                label: const Text('Confirm Password'),
                controller: formState.confirmPasswordController,
                placeholder: const Text('Re-enter your password'),
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
                    onPressed: () => formState.isConfirmPasswordVisible.value =
                        !formState.isConfirmPasswordVisible.value,
                  ),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != formState.passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // SIGN UP BUTTON
              Consumer(
                builder: (context, ref, child) {
                  final vm = ref.watch(signupControllerProvider);
                  final isLoading = vm.isLoading;
                  final theme = ShadTheme.of(context);

                  return ShadButton(
                    enabled: formState.isFormValid.value && !isLoading,
                    width: double.infinity,
                    leading: isLoading
                        ? SizedBox.square(
                            dimension: 16,
                            child: SpinKitRipple(
                              color: theme.colorScheme.secondary,
                            ),
                          )
                        : null,
                    onPressed: formState.isFormValid.value && !isLoading
                        ? () async {
                            if (formKey.currentState!.validate()) {
                              final firstName = formState
                                  .firstNameController
                                  .text
                                  .trim();
                              final lastName = formState.lastNameController.text
                                  .trim();
                              final userName = '$firstName $lastName';
                              final email = formState.emailController.text
                                  .trim();
                              final password = formState.passwordController.text
                                  .trim();

                              await ref
                                  .read(signupControllerProvider.notifier)
                                  .signup(userName, email, password);
                            }
                          }
                        : null,
                    child: const Text("Sign up"),
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // SIGN UP LINK
        const _SignInLink(),
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
          'Create an Account!',
          style: theme.textTheme.h2.copyWith(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 6),

        Text(
          "Let’s get started! It only takes a minute to join.",
          style: theme.textTheme.muted.copyWith(fontSize: 14, height: 1.5),
        ),
      ],
    );
  }
}

class _SignInLink extends StatelessWidget {
  const _SignInLink();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text("Already have an account? ", style: theme.textTheme.bodyMedium),
          GestureDetector(
            onTap: () {
              context.go('/auth/login');
            },
            child: const Text(
              'Log in here',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
