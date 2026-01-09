import 'package:go_router/go_router.dart';
import 'package:hololine_flutter/module/auth/ui/login/controller/login_controller.dart';
import 'package:hololine_flutter/module/auth/ui/login/widget/login_state.dart';
import 'package:hololine_flutter/shared_ui/core/breakpoints.dart';
import 'package:hololine_flutter/shared_ui/core/components.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:serverpod_auth_client/module.dart';
import 'package:hololine_flutter/domain/failures/failures.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  // Breakpoints
  static const double formMaxWidth = 400;
  static const double imageMinWidth = 400;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = useLoginForm();

    final controller = ref.read(loginControllerProvider.notifier);
    final state = ref.watch(loginControllerProvider);

    ref.listen<AsyncValue<AuthenticationResponse?>>(loginControllerProvider,
        (previous, next) {
      next.when(
          data: (response) {
            if (response != null) {
              ShadToaster.of(context).show(
                const ShadToast(
                  title: Text('Login Successful'),
                  description: Text('You have been logged in successfully.'),
                ),
              );

              context.go('/dashboard');
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
                title: const Text('Login Failed'),
                description: Text(message),
              ),
            );
          },
          loading: () {});
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          // Determine device type
          final isMobile = width < Breakpoints.Mobile;
          //final isDesktop = width >= Breakpoints.Desktop;

          // Show side image only on desktop
          //final showSideImage = isDesktop;

          /*if (showSideImage) {
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
  }
*/

  // FORM CONTAINER (Used in all layouts)
  Widget _buildFormContainer(BuildContext context, LoginFormState formState,
      LoginController controller, AsyncValue<AuthenticationResponse?> state,
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
  Widget _buildForm(BuildContext context, LoginFormState formState,
      LoginController controller, AsyncValue<AuthenticationResponse?> state,
      {required bool isMobile}) {
    // Responsive values
    final titleFontSize = isMobile ? 24.0 : 28.0;
    final subtitleFontSize = isMobile ? 14.0 : 16.0;
    final spacingLarge = isMobile ? 24.0 : 32.0;
    final spacingMedium = isMobile ? 16.0 : 20.0;

    final formKey = formState.formKey;

    return ShadForm(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          _buildHeader(
            context,
            titleFontSize: titleFontSize,
            subtitleFontSize: subtitleFontSize,
          ),

          SizedBox(height: spacingLarge),

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

          SizedBox(height: spacingMedium),

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

          SizedBox(height: isMobile ? 12 : 16),

          // REMEMBER ME & FORGOT PASSWORD ROW
          _buildRememberMeRow(
            context,
            formState.rememberMe,
            isMobile: isMobile,
          ),

          SizedBox(height: spacingLarge),

          // SIGN IN BUTTON
          SizedBox(
            width: double.infinity,
            height: isMobile ? 44 : 48,
            child: ShadButton(
              enabled: formState.isFormValid.value && !state.isLoading,
              onPressed: formState.isFormValid.value && !state.isLoading
                  ? () async {
                      if (formKey.currentState!.validate()) {
                        final email = formState.emailController.text.trim();
                        final password =
                            formState.passwordController.text.trim();

                        await controller.login(email, password);
                      }
                    }
                  : null,
              leading: state.isLoading
                  ? SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color:
                            ShadTheme.of(context).colorScheme.primaryForeground,
                      ),
                    )
                  : null,
              child: const Text("Sign In"),
            ),
          ),

          SizedBox(height: spacingMedium),

          // SIGN UP LINK
          _buildSignUpLink(context),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome back!",
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontSize: subtitleFontSize + 2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Login to your account",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: titleFontSize,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Enter your email and password to sign in.",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            fontSize: subtitleFontSize - 2,
          ),
        ),
      ],
    );
  }

  // REMEMBER ME & FORGOT PASSWORD ROW
  Widget _buildRememberMeRow(
      BuildContext context, ValueNotifier<bool> rememberMe,
      {required bool isMobile}) {
    final theme = Theme.of(context);

    if (isMobile) {
      // MOBILE: Stack vertically if too cramped
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
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
              const SizedBox(width: 8),
              Text(
                'Remember me',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () {
                // Handle forgot password
                context.go('/auth/forgot-password');
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size(0, 36),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Forgot Password?',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      );
    }

    // TABLET & DESKTOP: Side by side
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(width: 8),
            Text(
              'Remember me',
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            context.go('/auth/forgot-password');
          },
          child: Text('Forgot Password?'),
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
          Text(
            "Don't have an account? ",
            style: theme.textTheme.bodyMedium,
          ),
          TextButton(
            onPressed: () {
              context.go('/auth/signup');
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 4),
              minimumSize: Size(0, 36),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Sign Up',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
