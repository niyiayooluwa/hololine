import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hololine_flutter/ui/core/widgets/buttons/buttons.dart';
import 'package:hololine_flutter/ui/core/widgets/textfields/hl_textfield.dart';

class LoginScreen extends HookWidget {
  const LoginScreen({super.key});

  static const double desktopBreakpoint = formMinWIdth + imageMinWIdth + 20;
  static const double formMinWIdth = 350;
  static const double imageMinWIdth = 400;

  @override
  Widget build(BuildContext context) {
    final isVisible = useState(true);
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        // Get the current avaialable width
        final screenWidth = constraints.maxWidth;

        // Check if the screen is wide enough for split layout
        if (screenWidth >= desktopBreakpoint) {
          return _buildDesktopLayout(
            context,
            emailController,
            passwordController,
            isVisible.value,
          );
        } else {
          return _buildMobileLayout(
            context,
            emailController,
            passwordController,
            isVisible.value,
          );
        }
      }),
    );
  }

  Widget _buildDesktopLayout(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
    bool isVisible,
  ) {
    final theme = Theme.of(context);
    return Row(children: <Widget>[
      Expanded(
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: imageMinWIdth),
          child: Container(
            color: theme.colorScheme.primary,
            child: const Center(
              child: Text('Side A; Image'),
            ),
          ),
        ),
      ),
      ConstrainedBox(
        constraints: BoxConstraints(minWidth: formMinWIdth),
        child: Container(
          width: 700,
          color: theme.colorScheme.secondary,
          child:
              _buildLoginForm(emailController, passwordController, isVisible),
        ),
      )
    ]);
  }

  Widget _buildMobileLayout(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
    bool isVisible,
  ) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 400.0,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _buildLoginForm(
              emailController,
              passwordController,
              isVisible,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(
    TextEditingController emailController,
    TextEditingController passwordController,
    bool isVisible,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
      child: Column(children: [
        // Top text section
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Welcome back!'),
            const Text('Login to your account'),
            const Text('Enter your email and password to sign in.'),
          ],
        ),

        // Form
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            HoloTextField(
              label: 'Email',
              leading: Icon(Icons.email_outlined, size: 16),
              controller: emailController,
              hint: 'Enter your email',
            ),
            const SizedBox(height: 16),
            HoloTextField(
              label: 'Password',
              leading: Icon(Icons.password, size: 16),
              controller: passwordController,
              hint: 'Enter your password',
              obscure: isVisible,
              trailing: isVisible
                  ? const Icon(Icons.visibility_off_outlined, size: 16)
                  : const Icon(Icons.visibility_outlined, size: 16),
              onTrailingTap: () {
                isVisible = !isVisible;
              },
            ),
          ],
        ),

        //Button
        Column(
          children: [
            const SizedBox(height: 24),
            HoloButton(
              label: "Login",
              //loading: true,
            )
          ],
        )
      ]),
    );
  }
}
