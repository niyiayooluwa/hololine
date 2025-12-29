import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hololine_flutter/module/auth/ui/verification/controller/verification_controller.dart';
import 'package:hololine_flutter/shared_ui/core/breakpoints.dart';
import 'package:hololine_flutter/shared_ui/core/components.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:serverpod_auth_client/module.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class VerificationScreen extends HookConsumerWidget {
  final String email;
  const VerificationScreen({super.key, required this.email});

  // Breakpoints
  static const double formMaxWidth = 420;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final otpController = useTextEditingController();
    final controller = ref.read(verificationControllerProvider.notifier);
    final state = ref.watch(verificationControllerProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          // Determine device type
          final isMobile = width < Breakpoints.Mobile;
          final isDesktop = width >= Breakpoints.Desktop;

          if (isDesktop) {
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
                        otpController,
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
                otpController,
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
      TextEditingController otpController,
      VerificationController controller,
      AsyncValue<UserInfo?> state,
      {required bool isMobile}) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: formMaxWidth,
      ),
      padding: EdgeInsets.all(isMobile ? 24 : 32),
      child: _buildForm(
        context,
        otpController,
        controller,
        state,
        isMobile: isMobile,
      ),
    );
  }

  // MAIN FORM
  Widget _buildForm(BuildContext context, TextEditingController otpController,
      VerificationController controller, AsyncValue<UserInfo?> state,
      {required bool isMobile}) {
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // HEADER
          _buildHeader(
            context,
            titleFontSize: titleFontSize,
            subtitleFontSize: subtitleFontSize,
          ),

          SizedBox(height: spacingLarge),

          // OTP INPUT FIELD
          ShadInputOTPFormField(
            id: 'otp',
            maxLength: 6,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('^[a-zA-Z0-9]+')),
            ],
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

          // SIGN IN BUTTON
          SizedBox(
            width: double.infinity,
            height: isMobile ? 44 : 48,
            child: ShadButton(
              onPressed: otpController.text.isEmpty
                  ? () {
                      if (formKey.currentState!.validate()) {
                        final otp = otpController.text.trim();
                        controller.verifyOtp(email, otp);
                      }
                    }
                  : null,
              child: const Text("Verify Code"),
            ),
          ),

          SizedBox(height: spacingMedium),

          ShadButton.ghost(
            onPressed: () {
              context.go('/auth/login');
            },
            leading: const Icon(LucideIcons.arrowLeft),
            child: const Text("Return to Login Page"),
          ),
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
        const SizedBox(height: 8),
        Text(
          "Enter Verification Code",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: titleFontSize,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Please enter the code sent to your email.",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            fontSize: subtitleFontSize,
          ),
        ),
      ],
    );
  }
}
