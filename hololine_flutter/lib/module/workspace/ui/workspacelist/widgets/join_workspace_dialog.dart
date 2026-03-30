import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hololine_flutter/module/workspace/ui/workspacelist/controller/workspace_list_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class JoinWorkspaceDialog extends HookConsumerWidget {
  const JoinWorkspaceDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<ShadFormState>();

    return ShadDialog(
      title: const Text('Join Workspace'),
      description: const Text(
          "Enter the invitation token you received via email to join an existing workspace."),
      actions: [
        ShadButton.outline(
          child: const Text('Cancel'),
          onPressed: () => context.pop(),
        ),
        ShadButton(
          child: const Text('Join Workspace'),
          onPressed: () async {
            if (formKey.currentState!.saveAndValidate()) {
              final values = formKey.currentState!.value;
              final token = values['token'] as String;

              try {
                await ref
                    .read(workspaceListControllerProvider.notifier)
                    .joinWorkspace(token);
                
                if (context.mounted) {
                  context.pop();
                  ShadToaster.of(context).show(
                    const ShadToast(
                      title: Text('Workspace Joined'),
                      description: Text('Successfully joined the workspace'),
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
                id: 'token',
                label: const Text('Invitation Token'),
                placeholder: const Text('Paste your token here'),
                validator: (v) {
                  if (v.isEmpty) {
                    return 'Invitation token is required';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
