import 'package:hololine_server/src/generated/protocol.dart';

enum ParentRole {
  parentOwner,
  parentAdmin,
  superadmin,
  parentMember,
  parentViewer
}

class RolePolicy {
  // ========== STANDALONE WORKSPACE PERMISSIONS ==========

  static bool canViewExists(WorkspaceRole role) => true;

  static bool canViewSummary(WorkspaceRole role) => true;

  static bool canViewDetails(WorkspaceRole role) => true;

  static bool canGenerateReports(WorkspaceRole role) =>
      role == WorkspaceRole.owner || role == WorkspaceRole.admin;

  static bool canDownloadReports(WorkspaceRole role) =>
      role == WorkspaceRole.owner || role == WorkspaceRole.admin;

  static bool canManageMembers(WorkspaceRole role) =>
      role == WorkspaceRole.owner || role == WorkspaceRole.admin;

  static bool canGenerateInviteCode(WorkspaceRole role) =>
      role == WorkspaceRole.owner || role == WorkspaceRole.admin;

  static bool canUpdateRole({
    required WorkspaceRole actor,
    required WorkspaceRole target,
    required WorkspaceRole newRole,
  }) {
    // Nobody can promote someone to owner or manage a superadmin in this flow
    if (newRole == WorkspaceRole.owner || target == WorkspaceRole.superadmin) {
      return false;
    }

    switch (actor) {
      case WorkspaceRole.owner:
        // Owner can change anyone except another owner
        return target != WorkspaceRole.owner;
      case WorkspaceRole.superadmin:
        // Admin can only change members and viewers
        return target == WorkspaceRole.member ||
            target == WorkspaceRole.viewer ||
            target == WorkspaceRole.admin;
      case WorkspaceRole.admin:
        // Admin can only change members and viewers
        return target == WorkspaceRole.member || target == WorkspaceRole.viewer;
      default:
        // Other roles cannot update
        return false;
    }
  }

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

  static bool canVetoDeletion(WorkspaceRole role) => false;

  static bool canArchiveWorkspace(WorkspaceRole role) =>
      role == WorkspaceRole.owner;

  static bool canRestoreWorkspace(WorkspaceRole role) =>
      role == WorkspaceRole.owner;

  // ========== CHILD OPERATIONAL WORKSPACE PERMISSIONS ==========

  static bool canViewChildExists(ParentRole role) => true;

  static bool canViewChildSummary(ParentRole role) =>
      role == ParentRole.parentOwner ||
      role == ParentRole.parentAdmin ||
      role == ParentRole.superadmin;

  static bool canViewChildDetails(ParentRole role) => false;

  static bool canGenerateChildReports(ParentRole role) =>
      role == ParentRole.parentOwner ||
      role == ParentRole.parentAdmin ||
      role == ParentRole.superadmin;

  static bool canCreateChild(WorkspaceRole role) =>
      role == WorkspaceRole.owner || role == WorkspaceRole.admin;

  static bool canDownloadChildReports(ParentRole role) =>
      role == ParentRole.parentOwner ||
      role == ParentRole.parentAdmin ||
      role == ParentRole.superadmin;

  static bool canManageChildMembers(ParentRole role) =>
      role == ParentRole.superadmin;

  static bool canPromoteInChild(ParentRole role) => false;

  static bool canEditChildLedger(ParentRole role) => false;

  static bool canApproveChildEdits(ParentRole role) => false;

  static bool canInitiateChildDelete(ParentRole role) => false;

  static bool canVetoChildDeletion(ParentRole role) =>
      role == ParentRole.parentOwner;

  static bool canArchiveChild(ParentRole role) =>
      role == ParentRole.parentOwner;

  static bool canRestoreChild(ParentRole role) =>
      role == ParentRole.parentOwner;

  static bool canOverrideChildOwner(ParentRole role) => false;

  static bool canVetoChildDeletionFromParent(ParentRole role) =>
      role == ParentRole.parentOwner;

  static bool canArchiveChildFromParent(ParentRole role) =>
      role == ParentRole.parentOwner;

  static bool canPromoteToSuperAdmin(ParentRole role) =>
      role == ParentRole.parentOwner;
}
