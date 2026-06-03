import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/modules/workspace/repositories/repositories.dart';
import 'package:hololine_server/src/modules/workspace/usecase/services.dart';
import 'package:hololine_server/src/utils/authenticated_endpoint.dart';
import 'package:serverpod/serverpod.dart';

/// Endpoint for managing workspace members and their roles.
class WorkspaceMemberEndpoint extends AuthenticatedEndpoint {
  final WorkspaceRepo _coreWorkspaceRepo = WorkspaceRepo();
  final MemberRepo _memberRepo = MemberRepo();

  late final MemberService _memberService = MemberService(
    _memberRepo,
    _coreWorkspaceRepo,
  );

  /// Returns a list of all workspaces the authenticated user belongs to.
  Future<List<WorkspaceSummary>> getMyWorkspaces(Session session) async {
    return runAuthenticated(session, 'getMyWorkspaces', (userId) async {
      return await _memberService.getMyWorkspaces(session, userId);
    });
  }

  /// Updates the role of a member within a workspace.
  Future<WorkspaceMember> updateMemberRole(
    Session session, {
    required int memberId,
    required int workspaceId,
    required WorkspaceRole role,
  }) async {
    return runAuthenticated(session, 'updateMemberRole', (userId) async {
      return await _memberService.updateMemberRole(
        session,
        memberId: memberId,
        workspaceId: workspaceId,
        role: role,
        actorId: userId,
      );
    });
  }

  /// Removes a member from a workspace.
  Future<WorkspaceMember> removeMember(
    Session session, {
    required int memberId,
    required int workspaceId,
  }) async {
    return runAuthenticated(session, 'removeMember', (userId) async {
      return await _memberService.removeMember(
        session,
        memberId: memberId,
        workspaceId: workspaceId,
        actorId: userId,
      );
    });
  }

  /// Allows the authenticated user to leave a workspace.
  Future<WorkspaceMember> leaveWorkspace(
    Session session, {
    required int workspaceId,
  }) async {
    return runAuthenticated(session, 'leaveWorkspace', (userId) async {
      return await _memberService.leaveWorkspace(session, workspaceId, userId);
    });
  }
}
