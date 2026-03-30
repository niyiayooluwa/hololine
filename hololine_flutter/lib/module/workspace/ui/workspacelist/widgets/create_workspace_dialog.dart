import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hololine_flutter/module/workspace/ui/workspacelist/controller/workspace_list_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class CreateWorkspaceDialog extends HookConsumerWidget {
  const CreateWorkspaceDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<ShadFormState>();

    return ShadDialog(
      title: const Text('Create Workspace'),
      description: const Text(
          "Set up a new workspace for your team. You'll be the owner of this workspace."),
      actions: [
        ShadButton.outline(
          child: const Text('Cancel'),
          onPressed: () => context.pop(),
        ),
        ShadButton(
          child: const Text('Create'),
          onPressed: () async {
            if (formKey.currentState!.saveAndValidate()) {
              final values = formKey.currentState!.value;
              final name = values['name'] as String;
              final description = values['description'] as String? ?? '';

              try {
                await ref
                    .read(workspaceListControllerProvider.notifier)
                    .createWorkspace(name, description);
                
                if (context.mounted) {
                  context.pop();
                  ShadToaster.of(context).show(
                    ShadToast(
                      title: const Text('Workspace Created'),
                      description: Text('Successfully created "$name"'),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ShadToaster.of(context).show(
                    ShadToast.destructive(
                      title: const Text('Error'),
                      description: Text(e.toString()),
                    ),
                  );
                }
              }
            }
          },
        ),
      ],
      child: Container(
        width: 400,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: ShadForm(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ShadInputFormField(
                id: 'name',
                label: const Text('Workspace Name'),
                placeholder: const Text('e.g. Acme Corp'),
                validator: (v) {
                  if (v.isEmpty) {
                    return 'Workspace name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ShadInputFormField(
                id: 'description',
                label: const Text('Description (Optional)'),
                placeholder: const Text('What is this workspace for?'),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
