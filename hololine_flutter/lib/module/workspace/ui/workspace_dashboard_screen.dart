import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/core/application/providers.dart';
import 'package:hololine_flutter/module/workspace/ui/provider/workspace_dashboard_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class WorkspaceDashboardScreen extends ConsumerWidget {
  final String publicId;

  const WorkspaceDashboardScreen({
    super.key,
    required this.publicId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(workspaceDashboardProvider(publicId));
    final sessionManager = ref.watch(sessionProvider);
    final currentUserId = sessionManager.signedInUser?.id;

    return dashboardAsync.when(
      data: (data) {
        // Correctly identify the current user's role in this workspace
        final currentUserMember = data.members.firstWhere(
          (m) => m.member.userInfoId == currentUserId,
          orElse: () => data.members.first, // Fallback (shouldn't happen if authenticated)
        );
        final role = currentUserMember.member.role;

        return _DashboardContent(data: data, currentRole: role);
      },
      loading: () => const Center(child: ShadBadge(child: Text('Loading dashboard...'))),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  final WorkspaceDashboardData data;
  final WorkspaceRole currentRole;

  const _DashboardContent({
    required this.data,
    required this.currentRole,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dashboard',
              style: theme.textTheme.h2,
            ),
            const SizedBox(height: 24),
            StaggeredGrid.count(
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              children: [
                // 1. Hero Card (Span 2x1.2)
                StaggeredGridTile.count(
                  crossAxisCellCount: 2,
                  mainAxisCellCount: 1.2,
                  child: _HeroCard(
                    workspace: data.workspace, 
                    members: data.members,
                    userRole: currentRole,
                  ),
                ),

                // 2. Quick Actions (Span 1x1.2) - Role Gated
                if (currentRole != WorkspaceRole.viewer)
                  StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: 1.2,
                    child: _QuickActionsCard(role: currentRole),
                  ),

                // 3. Members Card (Span 1x2)
                StaggeredGridTile.count(
                  crossAxisCellCount: 1,
                  mainAxisCellCount: 2,
                  child: _MembersCard(members: data.members),
                ),

                // 4. Catalog Snapshot (Span 2x0.8)
                StaggeredGridTile.count(
                  crossAxisCellCount: 2,
                  mainAxisCellCount: 0.8,
                  child: _CatalogSnapshotCard(snapshot: data.catalog),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final Workspace workspace;
  final List<WorkspaceMemberInfo> members;
  final WorkspaceRole userRole;

  const _HeroCard({
    required this.workspace, 
    required this.members,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final owner = members.firstWhere(
      (m) => m.member.role == WorkspaceRole.owner,
      orElse: () => members.first,
    );

    return ShadCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ShadBadge(
                child: Text(userRole.name.toUpperCase()),
              ),
              const Spacer(),
              const Icon(LucideIcons.layoutGrid, size: 20, color: Colors.grey),
            ],
          ),
          const Spacer(),
          Text(
            workspace.name,
            style: theme.textTheme.h1.copyWith(fontSize: 32),
          ),
          if (workspace.description.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              workspace.description,
              style: theme.textTheme.muted,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          const Spacer(),
          Row(
            children: [
              const Icon(LucideIcons.user, size: 16),
              const SizedBox(width: 8),
              Text('Owned by ${owner.userName}'),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionsCard extends StatelessWidget {
  final WorkspaceRole role;

  const _QuickActionsCard({required this.role});

  @override
  Widget build(BuildContext context) {
    final canInvite = role == WorkspaceRole.owner || role == WorkspaceRole.admin;

    return ShadCard(
      title: const Text('Quick Actions'),
      child: Column(
        children: [
          _ActionButton(
            icon: LucideIcons.packagePlus,
            label: 'Add Product',
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _ActionButton(
            icon: LucideIcons.filePlus,
            label: 'Add Record',
            onTap: () {},
          ),
          if (canInvite) ...[
            const SizedBox(height: 12),
            _ActionButton(
              icon: LucideIcons.userPlus,
              label: 'Invite Member',
              onTap: () {},
              isOutline: true,
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isOutline;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isOutline = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutline) {
      return ShadButton.outline(
        width: double.infinity,
        onPressed: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18),
            const SizedBox(width: 8),
            Text(label),
          ],
        ),
      );
    }
    return ShadButton(
      width: double.infinity,
      onPressed: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

class _MembersCard extends StatelessWidget {
  final List<WorkspaceMemberInfo> members;

  const _MembersCard({required this.members});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);

    return ShadCard(
      title: const Text('Members'),
      description: Text('${members.length} active'),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: members.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final member = members[index];
          return Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: theme.colorScheme.muted,
                child: Text(
                  member.userName.isNotEmpty ? member.userName[0].toUpperCase() : '?',
                  style: TextStyle(fontSize: 12, color: theme.colorScheme.foreground),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(member.userName, style: theme.textTheme.small),
                    Text(member.member.role.name, style: theme.textTheme.muted.copyWith(fontSize: 10)),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CatalogSnapshotCard extends StatelessWidget {
  final CatalogSnapshot snapshot;

  const _CatalogSnapshotCard({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final hasProducts = snapshot.totalItems > 0;

    return ShadCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Catalog Summary', style: theme.textTheme.muted),
                const SizedBox(height: 8),
                Text(
                  '${snapshot.totalItems} Products',
                  style: theme.textTheme.h3,
                ),
              ],
            ),
          ),
          Container(
            height: 40,
            width: 1,
            color: theme.colorScheme.border,
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: hasProducts
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('LAST ADDED', style: theme.textTheme.muted.copyWith(fontSize: 10, letterSpacing: 1.2)),
                        const SizedBox(height: 4),
                        Text(snapshot.lastProductName ?? 'Unknown', style: theme.textTheme.p),
                        Text(
                          snapshot.lastProductDate != null 
                              ? DateFormat.yMMMd().format(snapshot.lastProductDate!)
                              : '',
                          style: theme.textTheme.muted,
                        ),
                      ],
                    )
                  : Center(
                      child: Text('No products yet', style: theme.textTheme.muted),
                    ),
            ),
          ),
          ShadButton.ghost(
            onPressed: () {},
            child: const Icon(LucideIcons.arrowRight),
          ),
        ],
      ),
    );
  }
}
