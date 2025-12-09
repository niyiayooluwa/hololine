import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hololine_flutter/ui/core/components.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 800;
  static const double desktopBreakpoint = 1200;
  static const double formMaxWidth = 420;
  static const double imageMinWidth = 400;

  @override
  Widget build(BuildContext context) {
    final isPasswordVisible = useState(false);
    final rememberMe = useState(false);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          // Determine device type
          final isMobile = width < mobileBreakpoint;
          final isTablet =
              width >= mobileBreakpoint && width < tabletBreakpoint;
          final isDesktop = width >= desktopBreakpoint;

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
                        emailController,
                        passwordController,
                        isPasswordVisible,
                        rememberMe,
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
                emailController,
                passwordController,
                isPasswordVisible,
                rememberMe,
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
      color: Colors.white,
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
                  color: Colors.white.withOpacity(0.9),
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
      TextEditingController emailController,
      TextEditingController passwordController,
      ValueNotifier<bool> isPasswordVisible,
      ValueNotifier<bool> rememberMe,
      {required bool isMobile}) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: formMaxWidth,
      ),
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      child: _buildForm(
        context,
        emailController,
        passwordController,
        isPasswordVisible,
        rememberMe,
        isMobile: isMobile,
      ),
    );
  }

  // MAIN FORM
  Widget _buildForm(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController,
      ValueNotifier<bool> isPasswordVisible,
      ValueNotifier<bool> rememberMe,
      {required bool isMobile}) {
    final theme = Theme.of(context);

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

        SizedBox(height: isMobile ? 12 : 16),

        // REMEMBER ME & FORGOT PASSWORD ROW
        _buildRememberMeRow(
          context,
          rememberMe,
          isMobile: isMobile,
        ),

        SizedBox(height: spacingLarge),

        // SIGN IN BUTTON
        SizedBox(
          width: double.infinity,
          height: isMobile ? 40 : 44,
          child: HoloButton(
            label: "Sign In",
            onPressed: () {
              // Handle login
              print('Email: ${emailController.text}');
              print('Password: ${passwordController.text}');
              print('Remember me: ${rememberMe.value}');
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
          "Welcome back!",
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.6),
            fontSize: subtitleFontSize,
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
            color: theme.colorScheme.onSurface.withOpacity(0.7),
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
                print('Forgot password clicked');
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
            // Handle forgot password
            print('Forgot password clicked');
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
              // Navigate to sign up
              print('Navigate to sign up');
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
