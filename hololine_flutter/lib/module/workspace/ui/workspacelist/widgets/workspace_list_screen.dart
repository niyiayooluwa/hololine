// ignore_for_file: unused_element, unused_import

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/module/workspace/ui/workspacelist/controller/workspace_list_controller.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class WorkspaceListScreen extends HookConsumerWidget {
  const WorkspaceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the controller state directly
    final wState = ref.watch(workspaceListControllerProvider);

    ref.listen(workspaceListControllerProvider, (previous, next) {
      next.whenData((workspaces) {
        if (workspaces.length == 1) {
          context.go('/workspace/${workspaces[0].id}');
        }
      });
    });

    final List<WorkspaceSummary> workspaces = [
      WorkspaceSummary(
        id: 24,
        name: 'Hololine',
        description: 'Description',
        memberCount: 4,
        lastActive: DateTime.now(),
        role: WorkspaceRole.owner,
      ),
      WorkspaceSummary(
        id: 25,
        name: 'Hololine 2',
        description: 'Description',
        memberCount: 4,
        lastActive: DateTime.now(),
        role: WorkspaceRole.admin,
      ),
      WorkspaceSummary(
        id: 26,
        name: 'Hololine',
        description: 'Description',
        memberCount: 4,
        lastActive: DateTime.now(),
        role: WorkspaceRole.member,
      ),
      WorkspaceSummary(
        id: 27,
        name: 'Hololine',
        description: 'Description',
        memberCount: 4,
        lastActive: DateTime.now(),
        role: WorkspaceRole.viewer,
      ),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: wState.when(
        data: (workspaces) {
          if (workspaces.isEmpty) {
            return _buildZeroState(context: context);
          }
          return _buildContent(
            context: context,
            ref: ref,
            workspaces: workspaces,
          );
        },
        error: (error, stack) => _buildError(error: error.toString()),
        loading: () => _buildLoading(),
      ),
    );
  }

  Widget _buildContent({
    required BuildContext context,
    required WidgetRef ref,
    required List<WorkspaceSummary> workspaces,
  }) {
    return Center(
      //Centers everything on the screen
      child: ConstrainedBox(
        // Max width of 600px on the Web, but 100% width on Mobile
        constraints: const BoxConstraints(maxWidth: 600),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Hololine',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const ShadAvatar(
                  'https://github.com/shadcn.png',
                  placeholder: Text("NY"),
                ),
              ],
            ),

            const SizedBox(height: 48),

            // ---SUB-HEADER
            Text(
              'Your Workspaces',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 24),

            ...workspaces.map(
              (ws) => _buildWorkspaceCard(context: context, workspace: ws),
            ),

            const SizedBox(height: 24),

            ShadButton.outline(
              width: double.infinity,
              onPressed: () {},
              child: const Text("+ Create New Workspace"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError({required String error}) {
    return Center(child: Text('Error: $error'));
  }

  Widget _buildLoading() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildWorkspaceCard({
    required BuildContext context,
    required WorkspaceSummary workspace,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ShadButton.outline(
        width:
            double.infinity, //Makes the button fill the 600px container width
        padding: const EdgeInsets.all(16),
        onPressed: () {
          context.go('/workspace/${workspace.id}');
        },
        child: Align(
          // Forces the content to the left side
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              // ICON: Workspace Initial
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    workspace.name[0].toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisSize: .min,
                  children: [
                    Text(
                      workspace.name,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      '${workspace.memberCount} members',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.chevron_right,
                size: 20,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildZeroState({required BuildContext context}) {
    final theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: .center,
            children: [
              // ICON
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.business,
                  size: 64,
                  color: theme.colorScheme.primary,
                ),
              ),

              const SizedBox(height: 32),

              // ---HEADLINE
              Text(
                "No workspaces found",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 12),

              // ---SUBHEADLINE
              Text(
                "Create your first workspace to get started or enter a code to join an existing one.",
                textAlign: .center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),

              const SizedBox(height: 48),

              ShadButton(
                width: double.infinity,
                onPressed: () {},
                child: const Text("Create Workspace"),
              ),

              const SizedBox(height: 12),

              ShadButton.outline(
                width: double.infinity,
                onPressed: () {},
                child: const Text("Join with Code"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
