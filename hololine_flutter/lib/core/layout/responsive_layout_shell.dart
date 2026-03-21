import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'mobile_scaffold.dart';
import 'desktop_scaffold.dart';

class ResponsiveLayoutShell extends StatelessWidget {
  final Widget child;

  const ResponsiveLayoutShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ShadResponsiveBuilder(
      builder: (context, breakpoint) {
        return switch (breakpoint) {
          ShadBreakpointTN() || ShadBreakpointSM() => MobileScaffold(child: child),
          ShadBreakpointMD() || ShadBreakpointLG() || ShadBreakpointXL() || ShadBreakpointXXL() => DesktopScaffold(child: child),
        };
      },
    );
  }
}
