import 'package:flutter/material.dart';
import 'package:hololine_flutter/core/layout/workspace_sidebar.dart';
import 'package:hololine_flutter/core/layout/workspace_top_bar.dart';

class MobileScaffold extends StatelessWidget {
  final Widget child;

  const MobileScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      drawer: const Drawer(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: WorkspaceSidebar(),
      ),
      body: SafeArea(
        bottom: false,
        child: Container(
           margin: EdgeInsets.zero, // Full edge-to-edge on mobile viewport
           color: colorScheme.surface,
           child: Column(
             children: [
               const WorkspaceTopBar(isMobile: true),
               Expanded(child: child),
             ],
           ),
        ),
      ),
    );
  }
}
