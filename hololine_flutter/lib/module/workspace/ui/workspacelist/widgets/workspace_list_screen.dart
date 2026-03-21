// ignore_for_file: unused_element, unused_import

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/module/workspace/ui/workspacelist/controller/workspace_list_controller.dart';
import 'package:hololine_flutter/module/workspace/ui/workspacelist/widgets/create_workspace_dialog.dart';
import 'package:hololine_flutter/module/workspace/ui/workspacelist/widgets/join_workspace_dialog.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class WorkspaceListScreen extends HookConsumerWidget {
  const WorkspaceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final shadTheme = ShadTheme.of(context);
    final wState = ref.watch(workspaceListControllerProvider);

    ref.listen(workspaceListControllerProvider, (previous, next) {
      next.whenData((workspaces) {
        if (workspaces.length == 1) {
          context.go('/workspace/${workspaces[0].publicId}');
        }
      });
    });

    return Scaffold(
      // 1. Subtle Background
      backgroundColor: shadTheme.colorScheme.background,
      // 2. Fixed Top Bar (The "Roof")
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: Container(
          decoration: BoxDecoration(
            color: shadTheme.colorScheme.secondary,
            border: Border(
              bottom: BorderSide(
                color: shadTheme.colorScheme.border,
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hololine',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const ShadAvatar(
                    'https://avatars.githubusercontent.com/u/124599?v=4',
                    placeholder: Text("NY"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
    final theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          children: [
            Text(
              'Your Workspaces',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            ...workspaces.map(
              (ws) => _buildWorkspaceCard(context: context, workspace: ws),
            ),
            const SizedBox(height: 24),
            ShadButton.outline(
              width: double.infinity,
              onPressed: () {
                showShadDialog(
                  context: context,
                  builder: (context) => const CreateWorkspaceDialog(),
                );
              },
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
    final shadTheme = ShadTheme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ShadButton.outline(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        backgroundColor: shadTheme
            .cardTheme
            .backgroundColor, // Ensure card stands out from grey bg
        onPressed: () {
          context.go('/workspace/${workspace.publicId}');
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
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
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(24),
          // 3. Grounded Zero State (Card wrapper)
          child: ShadCard(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
            backgroundColor: theme.colorScheme.surface,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                Text(
                  "No workspaces found",
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Create your first workspace to get started or enter a code to join an existing one.",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 48),
                ShadButton(
                  width: double.infinity,
                  onPressed: () {
                    showShadDialog(
                      context: context,
                      builder: (context) => const CreateWorkspaceDialog(),
                    );
                  },
                  child: const Text("Create Workspace"),
                ),
                const SizedBox(height: 12),
                ShadButton.outline(
                  width: double.infinity,
                  onPressed: () {
                    showShadDialog(
                      context: context,
                      builder: (context) => const JoinWorkspaceDialog(),
                    );
                  },
                  child: const Text("Join with Code"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
