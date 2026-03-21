import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class DesktopScaffold extends StatelessWidget {
  final Widget child;

  const DesktopScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final String currentPath = GoRouterState.of(context).uri.path;
    
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Row(
        children: [
          // Sidebar Navigation
          Container(
            width: 250,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(color: theme.colorScheme.border),
              ),
              color: theme.colorScheme.background,
            ),
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Hololine', 
                    style: theme.textTheme.h3.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 32),
                _NavItem(
                  icon: LucideIcons.layoutGrid,
                  label: 'Workspaces',
                  isSelected: currentPath.startsWith('/workspace'),
                  onPressed: () => context.go('/workspacelist'),
                ),
                const SizedBox(height: 8),
                _NavItem(
                  icon: LucideIcons.settings,
                  label: 'Settings',
                  isSelected: currentPath.startsWith('/settings'),
                  onPressed: () {},
                ),
                const Spacer(),
                _NavItem(
                  icon: LucideIcons.logOut,
                  label: 'Log out',
                  isSelected: false,
                  onPressed: () {},
                ),
              ],
            ),
          ),
          // Main Content Pane
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    
    return ShadButton.ghost(
      width: double.infinity,
      onPressed: onPressed,
      backgroundColor: isSelected ? theme.colorScheme.muted : null,
      hoverBackgroundColor: theme.colorScheme.muted.withValues(alpha: 0.5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(
            icon, 
            size: 20, 
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.foreground,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.foreground,
            ),
          ),
        ],
      ),
    );
  }
}
