import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hololine_flutter/core/application/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WorkspaceTopBar extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final String currentPath = GoRouterState.of(context).uri.path;
    final pageTitle = _getPageTitle(currentPath);

    final user = ref.watch(sessionProvider).signedInUser;
    final userName = user?.userName ?? "User";

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
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    child: Text(
                      userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
