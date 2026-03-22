import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class WorkspaceTopBar extends StatelessWidget {
  final bool isMobile;

  const WorkspaceTopBar({super.key, this.isMobile = false});

  String _getPageTitle(String path) {
    final segments = path.split('/');
    if (segments.isNotEmpty) {
      final last = segments.last;
      if (last.isNotEmpty && last != 'workspace') {
        return last[0].toUpperCase() + last.substring(1);
      }
    }
    return 'Dashboard';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final String currentPath = GoRouterState.of(context).uri.path;
    final pageTitle = _getPageTitle(currentPath);

    return Padding(
      padding: EdgeInsets.fromLTRB(isMobile ? 12 : 32, isMobile ? 12 : 24, isMobile ? 12 : 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isMobile) ...[
                IconButton(
                  icon: Icon(Icons.menu, color: colorScheme.onSurface),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
                const SizedBox(width: 8),
              ],
              Text(
                pageTitle,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.notifications_outlined, color: colorScheme.onSurface, size: 28),
                onPressed: () {},
              ),
              const SizedBox(width: 16),
              const CircleAvatar(
                radius: 18,
                child: Text('NY', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
