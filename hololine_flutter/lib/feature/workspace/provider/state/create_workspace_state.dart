import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CreateWorkspaceFormState {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final ValueNotifier<bool> isFormValid;
  final GlobalKey<ShadFormState> formKey;

  CreateWorkspaceFormState({
    required this.nameController,
    required this.descriptionController,
    required this.isFormValid,
    required this.formKey,
  });
}

CreateWorkspaceFormState useCreateWorkspaceForm() {
  final nameController = useTextEditingController();
  final descriptionController = useTextEditingController();
  final isFormValid = useState(false);
  final formKey = useMemoized(() => GlobalKey<ShadFormState>());

  useEffect(() {
    void updateFormValidity() {
      isFormValid.value = nameController.text.trim().isNotEmpty;
    }

    nameController.addListener(updateFormValidity);
    return () => nameController.removeListener(updateFormValidity);
  }, [nameController]);

  return CreateWorkspaceFormState(
    nameController: nameController,
    descriptionController: descriptionController,
    isFormValid: isFormValid,
    formKey: formKey,
  );
}
