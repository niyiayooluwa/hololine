import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:hololine_flutter/module/auth/ui/reset_password/controller/reset_password_controller.dart';
import 'package:hololine_flutter/module/auth/ui/reset_password/widget/reset_password_state.dart';
import 'package:hololine_flutter/shared_ui/core/breakpoints.dart';
import 'package:hololine_flutter/shared_ui/core/components.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ResetPasswordScreen extends HookConsumerWidget {
  final String email;
  const ResetPasswordScreen({super.key, required this.email});

  // Breakpoints
  static const double formMaxWidth = 420;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = useResetPasswordState();
    final controller = ref.read(resetPasswordControllerProvider.notifier);
    final state = ref.watch(resetPasswordControllerProvider);

    ref.listen<AsyncValue<bool?>>(
      resetPasswordControllerProvider,
      (previous, next) {
        next.when(
          data: (response) {
            if (response == true) {
              context.go('/auth/login');
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
                        formState,
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
                formState,
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
    return Padding(
      padding: EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/scott-webb.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Welcome to Holo',
                        style: TextStyle(
                          fontSize: 20,
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
              ),
            ),
          ),
        ),
      ),
    );
  }*/

  // FORM CONTAINER (Used in all layouts)
  Widget _buildFormContainer(BuildContext context, ResetPasswordState formState,
      ResetPasswordController controller, AsyncValue<bool?> state,
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
        formState,
        controller,
        state,
        isMobile: isMobile,
      ),
    );
  }

  // MAIN FORM
  Widget _buildForm(
    BuildContext context,
    ResetPasswordState formState,
    ResetPasswordController controller,
    AsyncValue<bool?> state, {
    required bool isMobile,
  }) {
    // Responsive values
    final titleFontSize = isMobile ? 24.0 : 28.0;
    final subtitleFontSize = isMobile ? 14.0 : 16.0;
    final spacingLarge = isMobile ? 24.0 : 32.0;
    final spacingMedium = isMobile ? 16.0 : 20.0;

    final formKey = GlobalKey<ShadFormState>();
    final page = formState.page.value;

    return ShadForm(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // HEADER
          _buildHeader(
            context,
            page: page,
            titleFontSize: titleFontSize,
            subtitleFontSize: subtitleFontSize,
          ),

          SizedBox(height: spacingLarge),

          if (page == 1) ...[
            // OTP INPUT FIELD
            ShadInputOTPFormField(
              id: 'otp',
              maxLength: 6,
              label: const Text('Verification Code'),
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
            SizedBox(height: spacingLarge),

            // VERIFY CODE BUTTON
            SizedBox(
              width: double.infinity,
              height: isMobile ? 44 : 48,
              child: ValueListenableBuilder(
                valueListenable: formState.codeController,
                builder: (context, value, child) {
                  return ShadButton(
                    enabled: formState.codeController.text.length == 6,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formState.page.value = 2;
                      }
                    },
                    child: const Text("Verify Code"),
                  );
                },
              ),
            ),
          ] else ...[
            ShadInputFormField(
              label: const Text('New Password'),
              controller: formState.passwordController,
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
                if (v.length < 8) {
                  return 'Password must be at least 8 characters';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            ShadInputFormField(
              label: const Text('Confirm Password'),
              controller: formState.confirmPasswordController,
              obscureText: !formState.isConfirmPasswordVisible.value,
              trailing: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  // Reduce the splash/hitbox size
                  constraints: const BoxConstraints(),
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    formState.isConfirmPasswordVisible.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    size: 20, // Explicit size helps alignment
                  ),
                  onPressed: () => formState.isConfirmPasswordVisible.value =
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
            SizedBox(height: spacingLarge),
            // RESET PASSWORD BUTTON
            SizedBox(
              width: double.infinity,
              height: isMobile ? 44 : 48,
              child: ShadButton(
                enabled: formState.isFormValid.value && !state.isLoading,
                onPressed: formState.isFormValid.value && !state.isLoading
                    ? () async {
                        if (formKey.currentState!.validate()) {
                          final code = formState.codeController.text.trim();
                          final password =
                              formState.passwordController.text.trim();
                          controller.resetPassword(code, password);
                        }
                      }
                    : null,
                leading: state.isLoading
                    ? SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: ShadTheme.of(context)
                              .colorScheme
                              .primaryForeground,
                        ),
                      )
                    : null,
                child: const Text("Reset Password"),
              ),
            ),
            SizedBox(height: spacingMedium),
            ShadButton.ghost(
              onPressed: () => formState.page.value = 1,
              leading: const Icon(LucideIcons.arrowLeft),
              child: const Text("Back"),
            ),
          ],
          if (page == 1) ...[
            SizedBox(height: spacingMedium),
            ShadButton.ghost(
              onPressed: () {
                context.go('/auth/login');
              },
              leading: const Icon(LucideIcons.arrowLeft),
              child: const Text("Return to Login Page"),
            ),
          ],
        ],
      ),
    );
  }

  // HEADER SECTION
  Widget _buildHeader(
    BuildContext context, {
    required int page,
    required double titleFontSize,
    required double subtitleFontSize,
  }) {
    final theme = Theme.of(context);
    final isPageOne = page == 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 8),
        Text(
          isPageOne ? "Verification" : "Reset Password",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: titleFontSize,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          isPageOne
              ? "Please enter the code sent to your email."
              : "Enter your new password below.",
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
