// --- MAIN SCREEN ---
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/core/application/providers.dart';
import 'package:hololine_flutter/feature/workspace/presentation/dialog/create_workspace_dialog.dart';
import 'package:hololine_flutter/feature/core_ui/presentation/shared/empty_state_widget.dart';
import 'package:hololine_flutter/feature/core_ui/presentation/shared/error_state_widget.dart';
import 'package:hololine_flutter/feature/workspace/presentation/widget/dashboard/workspace_card.dart';
import 'package:hololine_flutter/feature/workspace/presentation/widget/dashboard/workspace_card_skeleton.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class DashboardScreen extends HookConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final workspacesAsync = ref.watch(myWorkspacesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Slate-50
      body: SafeArea(
        child: Column(
          children: [
            const _DashboardNav(),
            Expanded(
              child: workspacesAsync.when(
                data: (workspaces) {
                  if (workspaces.isEmpty) {
                    return _buildEmptyState(context);
                  }
                  return _buildDataState(workspaces);
                },
                error: (error, stack) => Center(
                  child: ErrorStateWidget(
                    message: error.toString(),
                    onRetry: () => ref.invalidate(myWorkspacesProvider),
                  ),
                ),
                loading: () => _buildLoadingState(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Column(
          children: [
            /*const Padding(
              padding: EdgeInsets.fromLTRB(24, 40, 24, 0),
              child: _DashboardHeader(showCreateButton: false),
            ),*/
            Expanded(
              child: Center(
                child: EmptyWatchlistCard(
                  title: "No Workspaces Found",
                  description:
                      "Create your first workspace to start managing your ledgers and catalog.",
                  buttonText: "Create Workspace",
                  onPressed: () => showCreateWorkspaceDialog(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataState(List<WorkspaceSummary> workspaces) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _DashboardHeader(showCreateButton: true),
              const SizedBox(height: 32),
              _WorkspaceGrid(workspaces: workspaces),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _DashboardHeader(showCreateButton: false),
              const SizedBox(height: 32),
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 900
                      ? 3
                      : (constraints.maxWidth > 600 ? 2 : 1);

                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: crossAxisCount,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 24,
                    childAspectRatio: 1.9,
                    children: List.generate(
                      6,
                      (_) => const WorkspaceCardSkeleton(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- NAVIGATION ---
class _DashboardNav extends HookConsumerWidget {
  const _DashboardNav();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final session = ref.watch(sessionProvider);
    final user = session.signedInUser;
    final isHovered = useState(false);

    // Force DiceBear avatar (Serverpod auto-generates default imageUrls that we want to override)
    final avatarUrl =
        'https://api.dicebear.com/10.x/glyphs/png?seed=${Uri.encodeComponent(user?.userName ?? 'User')}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        border: Border(bottom: BorderSide(color: theme.colorScheme.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(
            'assets/svgs/logos/Osaka-black.svg',
            height: 40,
            fit: BoxFit.contain,
            //alignment: Alignment.centerLeft,
          ),
          MouseRegion(
            onEnter: (_) => isHovered.value = true,
            onExit: (_) => isHovered.value = false,
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => context.go('/settings'),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(2), // 2px space
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isHovered.value 
                        ? theme.colorScheme.border 
                        : theme.colorScheme.background,
                    width: 4,
                  ),
                ),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.border, 
                      width: 1,
                    ),
                    image: DecorationImage(
                      image: NetworkImage(avatarUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- HEADER ---
class _DashboardHeader extends StatelessWidget {
  final bool showCreateButton;

  const _DashboardHeader({required this.showCreateButton});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Workspaces", style: ShadTheme.of(context).textTheme.h2),
            const SizedBox(height: 4),
            Text(
              "Select a workspace to manage your ledgers.",
              style: ShadTheme.of(context).textTheme.muted,
            ),
          ],
        ),
        if (showCreateButton)
          ShadButton(
            onPressed: () => showCreateWorkspaceDialog(context),
            child: const Row(
              children: [
                Icon(LucideIcons.plus, size: 16),
                SizedBox(width: 8),
                Text("Create Workspace"),
              ],
            ),
          ),
      ],
    );
  }
}

// --- WORKSPACE GRID ---
class _WorkspaceGrid extends StatelessWidget {
  final List<WorkspaceSummary> workspaces;

  const _WorkspaceGrid({required this.workspaces});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 900
            ? 3
            : (constraints.maxWidth > 600 ? 2 : 1);

        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 16,
          crossAxisSpacing: 24,
          childAspectRatio: 1.9,
          children: workspaces.map((workspace) {
            return WorkspaceCard(
              name: workspace.name,
              description: workspace.description,
              role: workspace.role,
              memberCount: workspace.memberCount,
              onClick: () {
                context.go('/workspace/${workspace.id}/dashboard');
              },
            );
          }).toList(),
        );
      },
    );
  }
}
