import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/module/workspace/ui/dashboard/controller/dashboard_controller.dart';
import 'package:hololine_flutter/shared_ui/core/breakpoints.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DashboardScreen extends HookConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the controller state directly
    final dashboardState = ref.watch(dashboardControllerProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Hololine'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: dashboardState.when(
        data: (workspaces) => _buildContent(context, ref, workspaces),
        error: (error, stack) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    List<Workspace> workspaces,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Simple responsive logic
        final width = constraints.maxWidth;
        int crossAxisCount = 2; // Mobile
        if (width > Breakpoints.Tablet) {
          crossAxisCount = 4; // Desktop
        } else if (width > Breakpoints.Mobile) {
          crossAxisCount = 3; // Tablet
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStartNewSection(context, ref),
              const SizedBox(height: 32),
              Text(
                'Recent Workspaces',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              if (workspaces.isEmpty)
                const Text('No workspaces found. Create one above!')
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: workspaces.length,
                  itemBuilder: (context, index) {
                    final workspace = workspaces[index];
                    return _WorkspaceCard(workspace: workspace);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStartNewSection(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Start a new workspace',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _NewWorkspaceCard(
              label: 'Blank',
              icon: Icons.add,
              onTap: () => _showCreateDialog(context, ref),
            ),
            // Add more templates here in the future
          ],
        ),
      ],
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Workspace'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Workspace Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog first to avoid context issues during async
              final name = nameController.text.trim();
              final desc = descController.text.trim();

              if (name.isNotEmpty) {
                await _createWorkspace(context, ref, name, desc);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  Future<void> _createWorkspace(
    BuildContext context,
    WidgetRef ref,
    String name,
    String description,
  ) async {
    try {
      await ref
          .read(dashboardControllerProvider.notifier)
          .createWorkspace(name, description);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workspace created successfully!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create: $e')),
        );
      }
    }
  }
}

class _NewWorkspaceCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _NewWorkspaceCard({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(4),
          child: Container(
            width: 100,
            height: 120,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
              color: Colors.white,
            ),
            child: Center(
              child: Icon(icon, size: 40, color: Theme.of(context).primaryColor),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}

class _WorkspaceCard extends StatelessWidget {
  final Workspace workspace;

  const _WorkspaceCard({required this.workspace});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
       shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(4),
      ),
      color: Colors.white,
      child: InkWell(
        onTap: () {
          // Navigate to workspace details
           context.go('/workspace/${workspace.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                workspace.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                workspace.description ?? 'No description',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
                 maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(Icons.folder, size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Opened recently', // Placeholder for actual date
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                  ),
                  const Icon(Icons.more_vert, size: 16, color: Colors.grey),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}