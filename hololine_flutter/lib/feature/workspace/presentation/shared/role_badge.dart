import 'package:flutter/material.dart';
import 'package:hololine_client/hololine_client.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class RoleBadge extends StatelessWidget {
  final WorkspaceRole role;
  const RoleBadge({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return ShadBadge(
      backgroundColor: switch (role) {
        WorkspaceRole.owner => Color(0xFF0F172A),
        WorkspaceRole.admin || WorkspaceRole.superadmin => Color(0xFFEBDFFF),
        WorkspaceRole.member || WorkspaceRole.viewer => Color(0xFFF1F5F9),
      },
      hoverBackgroundColor: switch (role) {
        WorkspaceRole.owner => Color(0xFF0F172A),
        WorkspaceRole.admin || WorkspaceRole.superadmin => Color(0xFFEBDFFF),
        WorkspaceRole.member || WorkspaceRole.viewer => Color(0xFFF1F5F9),
      },
      child: Text(
        role.toString().toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          color: switch (role) {
            WorkspaceRole.owner => Colors.white,
            WorkspaceRole.admin ||
            WorkspaceRole.superadmin => Color(0xFF8B5CF6),
            WorkspaceRole.member || WorkspaceRole.viewer => Color(0XFF475569),
          },
        ),
      ),
    );
  }
}
