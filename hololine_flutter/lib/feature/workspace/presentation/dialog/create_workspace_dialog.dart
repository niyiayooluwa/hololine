import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hololine_flutter/core/application/providers.dart';
import 'package:hololine_flutter/feature/workspace/provider/notifier/create_workspace_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

void showCreateWorkspaceDialog(BuildContext context) {
  showShadDialog(
    context: context,
    builder: (context) => const CreateWorkspaceDialog(),
  );
}

class CreateWorkspaceDialog extends HookConsumerWidget {
  const CreateWorkspaceDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final descriptionController = useTextEditingController();
    
    final createWorkspaceState = ref.watch(createWorkspaceControllerProvider);

    ref.listen(createWorkspaceControllerProvider, (previous, next) {
      if (next is AsyncData && next.value != null) {
        // Workspace created successfully
        Navigator.of(context).pop();
        ref.invalidate(myWorkspacesProvider); // Refresh the dashboard list
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workspace created successfully!')),
        );
      } else if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    final isLoading = createWorkspaceState.isLoading;

    return ShadDialog(
      title: const Text('Create Workspace'),
      description: const Text('Enter the details for your new workspace.'),
      actions: [
        ShadButton.outline(
          onPressed: () => Navigator.of(context).pop(),
          enabled: !isLoading,
          child: const Text('Cancel'),
        ),
        ShadButton(
          onPressed: isLoading
              ? null
              : () {
                  ref
                      .read(createWorkspaceControllerProvider.notifier)
                      .create(nameController.text, descriptionController.text);
                },
          child: isLoading
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Create Workspace'),
        ),
      ],
      child: Container(
        width: 400,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Name',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            const SizedBox(height: 8),
            ShadInput(
              controller: nameController,
              placeholder: const Text('e.g. Acme Corporation'),
              enabled: !isLoading,
            ),
            const SizedBox(height: 20),
            const Text(
              'Description',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            ),
            const SizedBox(height: 8),
            ShadInput(
              controller: descriptionController,
              placeholder: const Text('Optional description...'),
              enabled: !isLoading,
            ),
          ],
        ),
      ),
    );
  }
}
