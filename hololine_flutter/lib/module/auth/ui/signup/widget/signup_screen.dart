import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hololine_flutter/module/auth/ui/signup/controller/signup_controller.dart';
import 'package:hololine_flutter/shared_ui/core/breakpoints.dart';
import 'package:hololine_flutter/shared_ui/core/components.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SignupScreen extends HookConsumerWidget {
  const SignupScreen({super.key});

  // Breakpoints
  static const double formMaxWidth = 420;
  static const double imageMinWidth = 400;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPasswordVisible = useState(false);
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final emailController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final passwordController = useTextEditingController();

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
                        firstNameController,
                        lastNameController,
                        emailController,
                        passwordController,
                        confirmPasswordController,
                        isPasswordVisible,
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
                firstNameController,
                lastNameController,
                emailController,
                passwordController,
                confirmPasswordController,
                isPasswordVisible,
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
  Widget _buildFormContainer(
      BuildContext context,
      TextEditingController firstNameController,
      TextEditingController lastNameController,
      TextEditingController emailController,
      TextEditingController passwordController,
      TextEditingController confirmPasswordController,
      ValueNotifier<bool> isPasswordVisible,
      SignupController controller,
      AsyncValue<bool?> state,
      {required bool isMobile}) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: formMaxWidth,
      ),
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      child: _buildForm(
        context,
        firstNameController,
        lastNameController,
        emailController,
        passwordController,
        confirmPasswordController,
        isPasswordVisible,
        controller,
        state,
        isMobile: isMobile,
      ),
    );
  }

  // MAIN FORM
  Widget _buildForm(
      BuildContext context,
      TextEditingController firstNameController,
      TextEditingController lastNameCOntroller,
      TextEditingController emailController,
      TextEditingController passwordController,
      TextEditingController confirmPasswordController,
      ValueNotifier<bool> isPasswordVisible,
      SignupController controller,
      AsyncValue<bool?> state,
      {required bool isMobile}) {
    //final theme = Theme.of(context);

    // Responsive values
    final titleFontSize = isMobile ? 24.0 : 28.0;
    final subtitleFontSize = isMobile ? 14.0 : 16.0;
    final spacingLarge = isMobile ? 24.0 : 32.0;
    final spacingMedium = isMobile ? 16.0 : 20.0;

    return Column(
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
        HoloTextField(
          label: 'First Name',
          leading: const Icon(Icons.email_outlined, size: 20),
          controller: firstNameController,
          hint: 'John',
          keyboardType: TextInputType.emailAddress,
        ),

        SizedBox(height: spacingMedium),

        HoloTextField(
          label: 'Last Name',
          leading: const Icon(Icons.email_outlined, size: 20),
          controller: lastNameCOntroller,
          hint: 'Doe',
          keyboardType: TextInputType.emailAddress,
        ),

        SizedBox(height: spacingMedium),

        HoloTextField(
          label: 'Email',
          leading: const Icon(Icons.email_outlined, size: 20),
          controller: emailController,
          hint: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
        ),

        SizedBox(height: spacingMedium),

        // PASSWORD FIELD
        HoloTextField(
          label: 'Password',
          leading: const Icon(Icons.lock_outline, size: 20),
          controller: passwordController,
          hint: 'Enter your password',
          obscure: !isPasswordVisible.value,
          trailing: IconButton(
            icon: Icon(
              isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
              size: 20,
            ),
            onPressed: () => isPasswordVisible.value = !isPasswordVisible.value,
          ),
        ),

        SizedBox(height: spacingMedium),

        // CONFIRM PASSWORD FIELD
        HoloTextField(
          label: 'Confirm Password',
          leading: const Icon(Icons.lock_outline, size: 20),
          controller: confirmPasswordController,
          hint: 'Re-enter your password',
          obscure: !isPasswordVisible.value,
          trailing: IconButton(
            icon: Icon(
              isPasswordVisible.value ? Icons.visibility : Icons.visibility_off,
              size: 20,
            ),
            onPressed: () => isPasswordVisible.value = !isPasswordVisible.value,
          ),
        ),

        SizedBox(height: spacingLarge),

        // SIGN IN BUTTON
        SizedBox(
          width: double.infinity,
          height: isMobile ? 40 : 44,
          child: HoloButton(
            label: "Create an Account",
            onPressed: () {
              // Handle signup logic
              final firstName = firstNameController.text.trim();
              final lastName = lastNameCOntroller.text.trim();
              final userName = '$firstName $lastName';
              final email = emailController.text.trim();
              final password = passwordController.text.trim();

              //Execute signup
              controller.signup(userName, email, password);
            },
          ),
        ),

        SizedBox(height: spacingMedium),

        // SIGN UP LINK
        _buildSignUpLink(context),
      ],
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
