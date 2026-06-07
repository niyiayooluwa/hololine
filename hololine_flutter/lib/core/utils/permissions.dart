import 'package:flutter/widgets.dart';
import 'package:hololine_client/hololine_client.dart';
import 'package:hololine_flutter/core/application/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Client-side role permissions policies that mirror the backend policies.
class RolePolicy {
  // ========== STANDALONE WORKSPACE PERMISSIONS ==========

  static bool canViewExists(WorkspaceRole role) => true;

  static bool canViewSummary(WorkspaceRole role) => true;

  static bool canViewDetails(WorkspaceRole role) => true;

  static bool canTransferOwnership(WorkspaceRole role) =>
      role == WorkspaceRole.owner;

  static bool canUpdateWorkspace(WorkspaceRole role) =>
      role == WorkspaceRole.owner || role == WorkspaceRole.admin;

  static bool canGenerateReports(WorkspaceRole role) =>
      role == WorkspaceRole.owner || role == WorkspaceRole.admin;

  static bool canDownloadReports(WorkspaceRole role) =>
      role == WorkspaceRole.owner || role == WorkspaceRole.admin;

  static bool canManageMembers(WorkspaceRole role) =>
      role == WorkspaceRole.owner || role == WorkspaceRole.admin;

  static bool canGenerateInviteCode(WorkspaceRole role) =>
      role == WorkspaceRole.owner || role == WorkspaceRole.admin;

  static bool canPromoteInWorkspace(WorkspaceRole role) =>
      role == WorkspaceRole.owner;

  static bool canEditLedger(WorkspaceRole role) =>
      role == WorkspaceRole.owner ||
      role == WorkspaceRole.admin ||
      role == WorkspaceRole.member;

  static bool canApproveEdits(WorkspaceRole role) =>
      role == WorkspaceRole.owner || role == WorkspaceRole.admin;

  static bool canInitiateDelete(WorkspaceRole role) =>
      role == WorkspaceRole.owner;

  static bool canArchiveWorkspace(WorkspaceRole role) =>
      role == WorkspaceRole.owner;

  static bool canRestoreWorkspace(WorkspaceRole role) =>
      role == WorkspaceRole.owner;

  // ========== PRODUCT CATALOG PERMISSIONS ==========

  static bool canCreateProduct(WorkspaceRole role) =>
      role == WorkspaceRole.owner || role == WorkspaceRole.admin;

  static bool canEditProduct(WorkspaceRole role) =>
      role == WorkspaceRole.owner || role == WorkspaceRole.admin;

  static bool canViewProducts(WorkspaceRole role) => true;

  // ========== CHILD OPERATIONAL WORKSPACE PERMISSIONS ==========

  static bool canCreateChild(WorkspaceRole role) =>
      role == WorkspaceRole.owner || role == WorkspaceRole.admin;
}

/// A bouncer widget that wraps layout elements to show or hide them
/// based on the active user role policies.
class RoleGate extends ConsumerWidget {
  final Widget child;
  final bool Function(WorkspaceRole role) policy;
  final Widget fallback;

  const RoleGate({
    super.key,
    required this.child,
    required this.policy,
    this.fallback = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(currentWorkspaceRoleProvider);

    if (role == null) {
      return fallback;
    }

    if (policy(role)) {
      return child;
    }

    return fallback;
  }
}
