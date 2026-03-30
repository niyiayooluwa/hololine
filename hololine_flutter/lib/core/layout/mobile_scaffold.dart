import 'package:flutter/material.dart';
import 'package:hololine_flutter/core/layout/workspace_sidebar.dart';
import 'package:hololine_flutter/core/layout/workspace_top_bar.dart';

class MobileScaffold extends StatelessWidget {
  final Widget child;

  const MobileScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final Color layoutBg = Color.lerp(colorScheme.surface, Colors.black, 0.03)!;

    return Scaffold(
      backgroundColor: layoutBg,
      drawer: const Drawer(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: WorkspaceSidebar(isMobile: true),
      ),
      body: SafeArea(
        bottom: false,
        child: Container(
           margin: const EdgeInsets.only(top: 12), // Tweak for mobile margins
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
