import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class ResetPasswordRequestState {
  final TextEditingController emailController;
  final ValueNotifier<bool> isFormValid;
  final GlobalKey<ShadFormState> formKey;

  ResetPasswordRequestState({
    required this.emailController,
    required this.isFormValid,
    required this.formKey,
  });
}

ResetPasswordRequestState useResetPasswordRequestState() {
  final emailController = useTextEditingController();
  final isFormValid = useState(false);
  final formKey = useMemoized(() => GlobalKey<ShadFormState>());

  useEffect(() {
    void updateFormValidity() {
      isFormValid.value = emailController.text.trim().isNotEmpty;
    }

    emailController.addListener(updateFormValidity);

    return () {
      emailController.removeListener(updateFormValidity);
    };
  }, [emailController]);

  return ResetPasswordRequestState(
    emailController: emailController,
    isFormValid: isFormValid,
    formKey: formKey,
  );
}
