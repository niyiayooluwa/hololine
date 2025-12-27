import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class RegisterFormState {
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final ValueNotifier<bool> isPasswordVisible;
  final ValueNotifier<bool> isConfirmPasswordVisible;
  final ValueNotifier<bool> isFormValid;

  RegisterFormState({
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isPasswordVisible,
    required this.isConfirmPasswordVisible,
    required this.isFormValid,
  });
}

RegisterFormState useRegisterForm() {
  final firstNameController = useTextEditingController();
  final lastNameController = useTextEditingController();
  final emailController = useTextEditingController();
  final passwordController = useTextEditingController();
  final confirmPasswordController = useTextEditingController();
  final isPasswordVisible = useState(false);
  final isConfirmPasswordVisible = useState(false);
  final isFormValid = useState(false);

  useEffect(() {
    void updateFormValidity() {
      isFormValid.value = firstNameController.text.trim().isNotEmpty &&
          lastNameController.text.trim().isNotEmpty &&
          emailController.text.trim().isNotEmpty &&
          passwordController.text.trim().isNotEmpty &&
          confirmPasswordController.text.trim().isNotEmpty &&
          (passwordController.text == confirmPasswordController.text);
    }

    firstNameController.addListener(updateFormValidity);
    lastNameController.addListener(updateFormValidity);
    emailController.addListener(updateFormValidity);
    passwordController.addListener(updateFormValidity);
    confirmPasswordController.addListener(updateFormValidity);

    return () {
      firstNameController.removeListener(updateFormValidity);
      lastNameController.removeListener(updateFormValidity);
      emailController.removeListener(updateFormValidity);
      passwordController.removeListener(updateFormValidity);
      confirmPasswordController.removeListener(updateFormValidity);
    };
  }, [
    firstNameController,
    lastNameController,
    emailController,
    passwordController,
    confirmPasswordController,
  ]);

  return RegisterFormState(
    firstNameController: firstNameController,
    lastNameController: lastNameController,
    emailController: emailController,
    passwordController: passwordController,
    confirmPasswordController: confirmPasswordController,
    isPasswordVisible: isPasswordVisible,
    isConfirmPasswordVisible: isConfirmPasswordVisible,
    isFormValid: isFormValid,
  );
}
