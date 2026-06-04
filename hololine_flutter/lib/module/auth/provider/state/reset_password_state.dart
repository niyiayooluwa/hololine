import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ResetPasswordState {
  final TextEditingController codeController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final ValueNotifier<bool> isPasswordVisible;
  final ValueNotifier<bool> isConfirmPasswordVisible;
  final ValueNotifier<int> page;
  final ValueNotifier<bool> isFormValid;

  ResetPasswordState({
    required this.codeController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isPasswordVisible,
    required this.isConfirmPasswordVisible,
    required this.isFormValid,
    required this.page,
  });
}

ResetPasswordState useResetPasswordState() {
  final codeController = useTextEditingController();
  final passwordController = useTextEditingController();
  final confirmPasswordController = useTextEditingController();
  final isPasswordVisible = useState(false);
  final isConfirmPasswordVisible = useState(false);
  final isFormValid = useState(false);
  final page = useState(1);


  useEffect(() {
    void updateFormValidity() {
      isFormValid.value = codeController.text.trim().isNotEmpty &&
          passwordController.text.trim().isNotEmpty &&
          confirmPasswordController.text.trim().isNotEmpty &&
          (passwordController.text == confirmPasswordController.text);
    }

    codeController.addListener(updateFormValidity);
    passwordController.addListener(updateFormValidity);
    confirmPasswordController.addListener(updateFormValidity);

    return () {
      codeController.removeListener(updateFormValidity);
      passwordController.removeListener(updateFormValidity);
      confirmPasswordController.removeListener(updateFormValidity);
    };
  }, [
    codeController,
    passwordController,
    confirmPasswordController,
  ]);

  return ResetPasswordState(
    codeController: codeController,
    passwordController: passwordController,
    confirmPasswordController: confirmPasswordController,
    isPasswordVisible: isPasswordVisible,
    isConfirmPasswordVisible: isConfirmPasswordVisible,
    isFormValid: isFormValid,
    page: page,
  );
}
