import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hololine_flutter/core/application/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class WorkspaceShellScreen extends HookWidget {
  final Widget child;

  const WorkspaceShellScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    int currentIndex = 0;
    if (location.endsWith('/ledger')) currentIndex = 1;
    if (location.endsWith('/catalog')) currentIndex = 2;
    if (location.endsWith('/inventory')) currentIndex = 3;
    if (location.endsWith('/analytics')) currentIndex = 4;
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // From HTML body background
      body: Row(
        children: [
          // Nav Rail
          _Sidebar(
            currentIndex: currentIndex,
            onNavigate: (index) {
              final id = GoRouterState.of(context).pathParameters['id'];
              if (id == null) return;

              if (index == 0) context.go('/workspace/$id/dashboard');
              if (index == 1) context.go('/workspace/$id/ledger');
              if (index == 2) context.go('/workspace/$id/catalog');
              if (index == 3) context.go('/workspace/$id/inventory');
              if (index == 4) context.go('/workspace/$id/analytics');
              if (index == 5) context.go('/workspace/$id/ai');
              if (index == 6) context.go('/workspace/$id/members');
              if (index == 7) context.go('/workspace/$id/settings');
            },
          ),
          // Main Content
          Expanded(
            child: Column(
              children: [
                const _TopNavBar(),
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Sidebar extends HookConsumerWidget {
  final int currentIndex;
  final Function(int) onNavigate;

  const _Sidebar({
    required this.currentIndex,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);

    // Get active workspace to read dynamic member count
    final idString = GoRouterState.of(context).pathParameters['id'];
    final workspaceId = int.tryParse(idString ?? '');
    final workspacesAsync = ref.watch(myWorkspacesProvider);
    final activeWorkspace = workspacesAsync.maybeWhen(
      data: (workspaces) => workspaces.where((w) => w.id == workspaceId).firstOrNull,
      orElse: () => null,
    );

    return Container(
      width: 280.0,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: theme.colorScheme.border),
        ),
      ),
      child: Column(
        children: [
          // Top Header (Workspace Selector)
          const _WorkspaceSelector(),

          // Scrollable Navigation Menu
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CORE SECTION
                  const _SectionTitle(title: 'Core'),
                  _NavItem(
                    icon: LucideIcons.layoutDashboard,
                    label: 'Dashboard',
                    isActive: currentIndex == 0,
                    onTap: () => onNavigate(0),
                  ),
                  _NavItem(
                    icon: LucideIcons.bookOpen,
                    label: 'Ledger',
                    isActive: currentIndex == 1,
                    onTap: () => onNavigate(1),
                  ),

                  const SizedBox(height: 16),
                  Divider(height: 1, color: theme.colorScheme.border),
                  const SizedBox(height: 16),

                  // OPERATIONS SECTION
                  const _SectionTitle(title: 'Operations'),
                  _NavItem(
                    icon: LucideIcons.package,
                    label: 'Catalog',
                    isActive: currentIndex == 2,
                    onTap: () => onNavigate(2),
                  ),
                  _NavItem(
                    icon: LucideIcons.boxes,
                    label: 'Inventory',
                    isActive: currentIndex == 3,
                    onTap: () => onNavigate(3),
                  ),

                  const SizedBox(height: 16),
                  Divider(height: 1, color: theme.colorScheme.border),
                  const SizedBox(height: 16),

                  // INSIGHTS SECTION
                  const _SectionTitle(title: 'Insights'),
                  _NavItem(
                    icon: Icons.bar_chart_rounded,
                    label: 'Analytics',
                    isActive: currentIndex == 4,
                    onTap: () => onNavigate(4),
                  ),
                  _NavItem(
                    icon: LucideIcons.sparkles,
                    label: 'AI Reporting',
                    isActive: currentIndex == 5,
                    onTap: () => onNavigate(5),
                  ),

                  const SizedBox(height: 16),
                  Divider(height: 1, color: theme.colorScheme.border),
                  const SizedBox(height: 16),

                  // WORKSPACE SECTION
                  const _SectionTitle(title: 'Workspace'),
                  _NavItem(
                    icon: LucideIcons.users,
                    label: 'Members',
                    isActive: currentIndex == 6,
                    onTap: () => onNavigate(6),
                    badgeCount: activeWorkspace?.memberCount,
                  ),
                  _NavItem(
                    icon: LucideIcons.settings,
                    label: 'Settings',
                    isActive: currentIndex == 7,
                    onTap: () => onNavigate(7),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkspaceSelector extends HookConsumerWidget {
  const _WorkspaceSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final idString = GoRouterState.of(context).pathParameters['id'];
    final workspaceId = int.tryParse(idString ?? '');
    
    final workspacesAsync = ref.watch(myWorkspacesProvider);
    
    // Find the active workspace safely
    final activeWorkspace = workspacesAsync.maybeWhen(
      data: (workspaces) => workspaces.where((w) => w.id == workspaceId).firstOrNull,
      orElse: () => null,
    );

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.colorScheme.border)),
      ),
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              context.go('/workspaces');
            },
            borderRadius: BorderRadius.circular(8),
            hoverColor: theme.colorScheme.muted.withValues(alpha: 0.5),
            splashColor: theme.colorScheme.muted,
            highlightColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.foreground,
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        )
                      ]
                    ),
                    child: Icon(LucideIcons.layers, size: 16, color: theme.colorScheme.background),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          activeWorkspace?.name ?? 'Loading...',
                          style: theme.textTheme.small.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    LucideIcons.chevronsUpDown, 
                    size: 16, 
                    color: theme.colorScheme.mutedForeground,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: ShadTheme.of(context).textTheme.small.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: ShadTheme.of(context).colorScheme.mutedForeground,
        ),
      ),
    );
  }
}

class _NavItem extends HookWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final int? badgeCount;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final isHovered = useState(false);

    Color getIconColor() {
      if (isActive) return theme.colorScheme.foreground;
      if (isHovered.value) return theme.colorScheme.foreground;
      return theme.colorScheme.mutedForeground;
    }

    Color getTextColor() {
      if (isActive) return theme.colorScheme.foreground;
      if (isHovered.value) return theme.colorScheme.foreground;
      return theme.colorScheme.mutedForeground;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: isActive ? theme.colorScheme.muted : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          onHover: (val) => isHovered.value = val,
          borderRadius: BorderRadius.circular(8),
          hoverColor: theme.colorScheme.muted.withValues(alpha: 0.5),
          splashColor: theme.colorScheme.muted,
          highlightColor: Colors.transparent,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Icon(icon, size: 18, color: getIconColor()),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        label,
                        style: theme.textTheme.small.copyWith(
                          color: getTextColor(),
                          fontSize: 14,
                          fontWeight: isActive
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (badgeCount != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.muted, // slate-100
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 1,
                              offset: Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Text(
                          badgeCount.toString(),
                          style: theme.textTheme.small.copyWith(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF475569), // slate-600
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (isActive)
                Positioned(
                  left:
                      -12, // Pulls it flush with the padding boundary (from HTML spec)
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      width: 3,
                      height: 18,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.foreground,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopNavBar extends HookConsumerWidget {
  const _TopNavBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ShadTheme.of(context);
    final sessionManager = ref.watch(sessionProvider);
    final user = sessionManager.signedInUser;
    
    // Extract first name safely
    final fullName = user?.userName ?? 'User';
    final firstName = fullName.split(' ').first;
    
    final avatarLetter = firstName.isNotEmpty ? firstName[0].toUpperCase() : 'U';

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: theme.colorScheme.border)),
      ),
      child: Row(
        children: [
          const Spacer(),
          // Vertical Divider
          Container(
            height: 24,
            width: 1,
            color: theme.colorScheme.border,
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          // Avatar
          ShadAvatar(
            user?.imageUrl ?? '',
            placeholder: Text(
              avatarLetter,
              style: theme.textTheme.small.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.mutedForeground,
              ),
            ),
            size: const Size(32, 32),
          ),
          const SizedBox(width: 12),
          // First Name
          Text(
            firstName,
            style: theme.textTheme.small.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: theme.colorScheme.foreground,
            ),
          ),
        ],
      ),
    );
  }
}