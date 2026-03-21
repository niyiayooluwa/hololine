import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class MobileScaffold extends StatelessWidget {
  final Widget child;

  const MobileScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final String currentPath = GoRouterState.of(context).uri.path;
    
    final int currentIndex = currentPath.startsWith('/workspace') ? 0 : 1;

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: theme.colorScheme.border),
          ),
        ),
        child: BottomNavigationBar(
          backgroundColor: theme.colorScheme.background,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: theme.colorScheme.mutedForeground,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: 0,
          currentIndex: currentIndex,
          onTap: (index) {
            if (index == 0) {
              context.go('/workspacelist');
            } else {
              // context.go('/settings');
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.layoutGrid),
              label: 'Workspaces',
            ),
            BottomNavigationBarItem(
              icon: Icon(LucideIcons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
