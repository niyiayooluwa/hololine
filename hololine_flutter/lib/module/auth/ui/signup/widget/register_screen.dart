import 'package:go_router/go_router.dart';
import 'package:hololine_flutter/module/auth/ui/signup/controller/signup_controller.dart';
import 'package:hololine_flutter/module/auth/ui/signup/widget/register_state.dart';
import 'package:hololine_flutter/shared_ui/core/breakpoints.dart';
import 'package:hololine_flutter/shared_ui/core/components.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class SignupScreen extends HookConsumerWidget {
  const SignupScreen({super.key});

  // Breakpoints
  static const double formMaxWidth = 420;
  static const double imageMinWidth = 400;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = useRegisterForm();

    final controller = ref.read(signupControllerProvider.notifier);
    final state = ref.watch(signupControllerProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          // Determine device type
          final isMobile = width < Breakpoints.Mobile;
          //final isTablet =width >= mobileBreakpoint && width < tabletBreakpoint;
          final isDesktop = width >= Breakpoints.Desktop;

          // Show side image only on desktop
          final showSideImage = isDesktop;

          if (showSideImage) {
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
          }

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
  Widget _buildImagePanel(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surface,
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withValues(alpha: 0.5),
              theme.colorScheme.secondary.withValues(alpha: 0.5),
              theme.colorScheme.secondary,
            ],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.login_rounded,
              size: 120,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            Text(
              'Welcome to Holo',
              style: TextStyle(
                fontSize: 32,
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
    );
  }

  // FORM CONTAINER (Used in all layouts)
  Widget _buildFormContainer(BuildContext context, RegisterFormState formstate,
      SignupController controller, AsyncValue<bool?> state,
      {required bool isMobile}) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: formMaxWidth,
      ),
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      child: _buildForm(
        context,
        formstate,
        controller,
        state,
        isMobile: isMobile,
      ),
    );
  }

  // MAIN FORM
  Widget _buildForm(BuildContext context, RegisterFormState formState,
      SignupController controller, AsyncValue<bool?> state,
      {required bool isMobile}) {
    //final theme = Theme.of(context);

    // Responsive values
    final titleFontSize = isMobile ? 24.0 : 28.0;
    final subtitleFontSize = isMobile ? 14.0 : 16.0;
    final spacingLarge = isMobile ? 24.0 : 32.0;
    final spacingMedium = isMobile ? 16.0 : 20.0;

    final formKey = GlobalKey<ShadFormState>();

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

          // FIRST NAME FIELD
          ShadInputFormField(
            id: 'first_name',
            label: const Text('First Name'),
            controller: formState.firstNameController,
            placeholder: const Text('John'),
            keyboardType: TextInputType.emailAddress,
            validator: (v) {
              if (v.isEmpty) {
                return 'Please enter your last name';
              }
              return null;
            },
          ),
          SizedBox(height: spacingMedium),

          // LAST NAME FIELD
          ShadInputFormField(
            id: 'last_name',
            label: const Text('Last Name'),
            controller: formState.lastNameController,
            placeholder: const Text('Doe'),
            keyboardType: TextInputType.name,
            validator: (v) {
              if (v.isEmpty) {
                return 'Please enter your last name';
              }
              return null;
            },
          ),
          SizedBox(height: spacingMedium),

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
          SizedBox(height: spacingMedium),

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
          ),
          SizedBox(height: spacingMedium),

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
          SizedBox(height: spacingLarge),

          // SIGN UP BUTTON
          SizedBox(
            width: double.infinity,
            height: isMobile ? 44 : 48,
            child: ShadButton(
              enabled: formState.isFormValid.value,
              onPressed: formState.isFormValid.value
                  ? () async {
                      if (formKey.currentState!.validate()) {
                        // Handle signup logic
                        final firstName =
                            formState.firstNameController.text.trim();
                        final lastName =
                            formState.lastNameController.text.trim();
                        final userName = '$firstName $lastName';
                        final email = formState.emailController.text.trim();
                        final password =
                            formState.passwordController.text.trim();

                        context.go('/auth/verification', extra: email);

                        await controller.signup(userName, email, password);

                        // On successful signup, navigate to verification screen
                        /*if (state.value == true) {
                          context.go('/auth/verification', extra: email);
                        }*/
                      }
                    }
                  : null,
              child: const Text("Sign up"),
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
          "Hello!",
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontSize: subtitleFontSize + 6,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Create an Account",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: titleFontSize,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Enter your details to create an account.",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            fontSize: subtitleFontSize - 2,
          ),
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
            "Already have an account? ",
            style: theme.textTheme.bodyMedium,
          ),
          TextButton(
            onPressed: () {
              context.go('/auth/login');
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 4),
              minimumSize: Size(0, 36),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Log in here',
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
