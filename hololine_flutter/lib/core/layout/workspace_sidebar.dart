import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class WorkspaceSidebar extends HookWidget {
  final bool isMobile;
  const WorkspaceSidebar({super.key, this.isMobile = false});

  Color getWorkspaceColor(String id, ColorScheme cs) {
    if (id.isEmpty) return cs.primary;
    final colors = [
      cs.primary,
      cs.secondary,
      cs.tertiary,
      cs.error,
      cs.primaryContainer,
      cs.secondaryContainer,
      cs.tertiaryContainer,
      cs.errorContainer,
    ];
    final index = id.codeUnits.reduce((a, b) => a + b) % colors.length;
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final String currentPath = GoRouterState.of(context).uri.path;
    
    final pathSegments = GoRouterState.of(context).uri.pathSegments;
    final publicId = pathSegments.length > 1 && pathSegments[0] == 'workspace' ? pathSegments[1] : 'acme';

    final isCollapsed = useState(false);
    final double width = isCollapsed.value ? 80.0 : 240.0;
    
    const workspaceName = "Acme Corp";

    // Dynamic contrast constraints driven solely by Theme.of(), completely removing 'isDark' unreliability:
    // 1. Sidebar is always strictly darker than the Content Area:
    final Color sidebarBg = Color.lerp(colorScheme.surface, Colors.black, 0.03)!;
    
    // 2. Card darkens in Light Mode (pulls toward Black onSurface) and lightens in Dark Mode (pulls toward White onSurface)!
    final Color cardBg = Color.lerp(sidebarBg, colorScheme.onSurface, 0.08)!;

    return Container( // Removed AnimatedContainer to instantly snap and prevent RenderFlex overflow during transition
      width: width,
      decoration: BoxDecoration(color: sidebarBg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            height: 80,
            padding: EdgeInsets.symmetric(horizontal: isCollapsed.value ? 0 : 24),
            child: Row(
              mainAxisAlignment: isCollapsed.value ? MainAxisAlignment.center : MainAxisAlignment.spaceBetween,
              children: [
                if (!isCollapsed.value) ...[
                  Text(
                    'HOLOLINE',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                    ),
                  ),
                ] else ...[
                  Text(
                    'H',
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
                if (isMobile)
                  IconButton(
                    icon: Icon(LucideIcons.x, color: colorScheme.onSurface, size: 24),
                    onPressed: () => Navigator.pop(context),
                  )
                else if (!isCollapsed.value)
                  IconButton(
                    // ignore: deprecated_member_use
                    icon: Icon(LucideIcons.chevronLeft, color: colorScheme.onSurface.withOpacity(0.55), size: 20),
                    onPressed: () => isCollapsed.value = true,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
          ),
          
          if (isCollapsed.value)
             Center(
               child: IconButton(
                  // ignore: deprecated_member_use
                  icon: Icon(LucideIcons.chevronRight, color: colorScheme.onSurface.withOpacity(0.55), size: 20),
                  onPressed: () => isCollapsed.value = false,
               ),
             ),

          const SizedBox(height: 16),

          // Main Nav
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _SidebarItem(
                  icon: LucideIcons.layoutDashboard,
                  label: 'Dashboard',
                  isActive: currentPath.endsWith('dashboard'),
                  isCollapsed: isCollapsed.value,
                  onPressed: () => context.go('/workspace/$publicId/dashboard'),
                ),
                _SidebarItem(
                  icon: LucideIcons.layoutGrid,
                  label: 'Catalog',
                  isActive: currentPath.endsWith('catalog'),
                  isCollapsed: isCollapsed.value,
                  onPressed: () => context.go('/workspace/$publicId/catalog'),
                ),
                _SidebarItem(
                  icon: LucideIcons.bookOpen,
                  label: 'Ledger',
                  isActive: currentPath.endsWith('ledger'),
                  isCollapsed: isCollapsed.value,
                  onPressed: () => context.go('/workspace/$publicId/ledger'),
                ),
                _SidebarItem(
                  icon: LucideIcons.folder,
                  label: 'Reports',
                  isActive: currentPath.endsWith('reports'),
                  isCollapsed: isCollapsed.value,
                  onPressed: () => context.go('/workspace/$publicId/reports'),
                ),

                const SizedBox(height: 32),

                _SidebarItem(
                  icon: LucideIcons.users,
                  label: 'Members',
                  isActive: currentPath.endsWith('members'),
                  isCollapsed: isCollapsed.value,
                  onPressed: () => context.go('/workspace/$publicId/members'),
                ),
              ],
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _SidebarItem(
              icon: LucideIcons.settings,
              label: 'Settings',
              isActive: currentPath.endsWith('settings'),
              isCollapsed: isCollapsed.value,
              onPressed: () => context.go('/workspace/$publicId/settings'),
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: InkWell(
              onTap: () => context.go('/workspacelist'),
              borderRadius: BorderRadius.circular(8),
              child: ShadTooltip(
                builder: (context) => const Text('Switch Workspace'),
                child: Container(
                  padding: EdgeInsets.all(isCollapsed.value ? 8 : 10),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: isCollapsed.value ? MainAxisAlignment.center : MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: getWorkspaceColor(publicId, Theme.of(context).colorScheme),
                        foregroundColor: Colors.white,
                        child: Text(
                          workspaceName[0].toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      if (!isCollapsed.value) ...[
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                workspaceName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.onSurface,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                "12 members",
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  // ignore: deprecated_member_use
                                  color: colorScheme.onSurface.withOpacity(0.55),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // ignore: deprecated_member_use
                        Icon(Icons.unfold_more, size: 20, color: colorScheme.onSurface.withOpacity(0.55)),
                      ]
                    ],
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

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isCollapsed;
  final VoidCallback onPressed;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.isCollapsed,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // Active shift right mechanism. Reduced to 10.0 for subtlety
    final shiftAmount = isActive && !isCollapsed ? 10.0 : 0.0;
    
    // Increased visibility for visually impaired
    // ignore: deprecated_member_use
    final itemColor = isActive ? colorScheme.onSurface : colorScheme.onSurface.withOpacity(0.65);
    final itemWeight = isActive ? FontWeight.w700 : FontWeight.w500;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Padding( // Removed AnimatedPadding to prevent reflow jank on collapse
          padding: EdgeInsets.fromLTRB(shiftAmount + 12, 12, 12, 12),
          child: Row(
            mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: itemColor),
              if (!isCollapsed) ...[
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: itemWeight,
                    color: itemColor,
                    fontSize: 14,
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
