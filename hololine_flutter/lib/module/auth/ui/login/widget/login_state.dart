import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LoginFormState {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final ValueNotifier<bool> isPasswordVisible;
  final ValueNotifier<bool> rememberMe;
  final ValueNotifier<bool> isFormValid;

  LoginFormState({
    required this.emailController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.rememberMe,
    required this.isFormValid,
  });
}

LoginFormState useLoginForm() {
  final emailController = useTextEditingController();
  final passwordController = useTextEditingController();
  final isPasswordVisible = useState(false);
  final rememberMe = useState(false);
  final isFormValid = useState(false);

  useEffect(() {
    void updateFormValidity() {
      isFormValid.value = 
        emailController.text.trim().isNotEmpty && 
        passwordController.text.trim().isNotEmpty;
    }

    emailController.addListener(updateFormValidity);
    passwordController.addListener(updateFormValidity);

    return () {
      emailController.removeListener(updateFormValidity);
      passwordController.removeListener(updateFormValidity);
    };
  }, [emailController, passwordController]);

  return LoginFormState(
    emailController: emailController,
    passwordController: passwordController,
    isPasswordVisible: isPasswordVisible,
    rememberMe: rememberMe,
    isFormValid: isFormValid,
  );
}