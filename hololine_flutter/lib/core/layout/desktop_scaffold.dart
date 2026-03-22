import 'package:flutter/material.dart';
import 'package:hololine_flutter/core/layout/workspace_sidebar.dart';
import 'package:hololine_flutter/core/layout/workspace_top_bar.dart';

class DesktopScaffold extends StatelessWidget {
  final Widget child;

  const DesktopScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: Row(
        children: [
          const WorkspaceSidebar(),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 12, right: 12, bottom: 16, left: 0),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              ),
              child: Column(
                children: [
                  const WorkspaceTopBar(isMobile: false),
                  Expanded(child: child),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
