import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hololine_flutter/ui/core/widgets/buttons/buttons.dart';
import 'package:hololine_flutter/ui/core/widgets/textfields/hl_textfield.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  static const double formMinWidth = 405;
  static const double formMaxWidth = 405; // Figma width
  static const double imageMinWidth = 250;
  static const double spacing = 32;

  static double get desktopBreakpoint => formMinWidth + imageMinWidth + spacing;

  @override
  Widget build(BuildContext context) {
    final isVisible = useState(true);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;

          final showImage = width >= desktopBreakpoint;

          if (showImage) {
            return _buildDesktop(
              context,
              emailController,
              passwordController,
              isVisible,
            );
          }

          return _buildMobile(
            context,
            emailController,
            passwordController,
            isVisible,
          );
        },
      ),
    );
  }

  Widget _buildDesktop(
    BuildContext context,
    TextEditingController email,
    TextEditingController pass,
    ValueNotifier<bool> isVisible,
  ) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // IMAGE PANEL
        ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: imageMinWidth,
            maxWidth: 600, // optional, prevents giant stretching
          ),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  //border: Border.all(color: ),
                  borderRadius: BorderRadius.circular(24)
                ),
                child: Center(
                  child: Text("Side A; Image"),
                ),
              ),
            ),
          ),
        ),

        // FORM PANEL
        Expanded(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: formMaxWidth,
              ),
              child: _buildForm(email, pass, isVisible),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobile(
    BuildContext context,
    TextEditingController email,
    TextEditingController pass,
    ValueNotifier<bool> isVisible,
  ) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: formMaxWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildForm(email, pass, isVisible),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(
    TextEditingController email,
    TextEditingController pass,
    ValueNotifier<bool> isVisible,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Welcome back!"),
          const Text("Login to your account"),
          const Text("Enter your email and password to sign in."),
          const SizedBox(height: 24),

          // EMAIL
          HoloTextField(
            label: 'Email',
            leading: const Icon(Icons.email_outlined, size: 16),
            controller: email,
            hint: 'Enter your email',
          ),
          const SizedBox(height: 16),

          // PASSWORD
          HoloTextField(
            label: 'Password',
            leading: const Icon(Icons.lock_outline, size: 16),
            controller: pass,
            hint: 'Enter your password',
            obscure: isVisible.value,
            trailing: Icon(
              isVisible.value ? Icons.visibility_off : Icons.visibility,
              size: 16,
            ),
            onTrailingTap: () => isVisible.value = !isVisible.value,
          ),
          const SizedBox(height: 24),

          // BUTTON
          HoloButton(label: "Login"),
        ],
      ),
    );
  }
}
