import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class VerificationState {
  final TextEditingController otpController;
  final ValueNotifier<bool> isFormValid;
  final GlobalKey<ShadFormState> formKey;

  VerificationState({
    required this.otpController,
    required this.isFormValid,
    required this.formKey,
  });
}

VerificationState useVerificationState() {
  final otpController = useTextEditingController();
  final isFormValid = useState(false);
  final formKey = useMemoized(() => GlobalKey<ShadFormState>());

  useEffect(() {
    void updateFormValidity() {
      isFormValid.value = otpController.text.length == 6;
    }

    otpController.addListener(updateFormValidity);

    return () {
      otpController.removeListener(updateFormValidity);
    };
  }, [otpController]);

  return VerificationState(
    otpController: otpController,
    isFormValid: isFormValid,
    formKey: formKey,
  );
}
