import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/modules/workspace/repositories/repositories.dart';
import 'package:hololine_server/src/modules/workspace/usecase/services.dart';
import 'package:hololine_server/src/services/email_service.dart';
import 'package:hololine_server/src/utils/endpoint_helper.dart';
import 'package:hololine_server/src/utils/exceptions.dart';
import 'package:serverpod/serverpod.dart';

// TODO: TECH DEBT - Add integration tests for WorkspaceEndpoint. 
// Skipped on 2026-01-10 due to constraints.

class WorkspaceEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  final WorkspaceRepo _coreWorkspaceRepo = WorkspaceRepo();
  final MemberRepo _memberRepo = MemberRepo();
  final InvitationRepo _invitationRepo = InvitationRepo();

  late final WorkspaceService _workspaceService = WorkspaceService(
    _memberRepo,
    _coreWorkspaceRepo,
  );
  late final MemberService _memberService = MemberService(
    _memberRepo,
    _coreWorkspaceRepo,
  );

  // ===========================================================================
  // CREATION
  // ===========================================================================

  Future<Workspace> createStandalone(
      Session session, String name, String description) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) throw AuthenticationException('User not authenticated');

    return runWithLogger(session, 'createStandalone', () async {
      return await _workspaceService.createStandalone(
          session, name, userId, description);
    });
  }

  Future<Workspace> createChild(
    Session session,
    String name,
    int parentWorkspaceId,
    String description,
  ) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) throw AuthenticationException('User not authenticated');

    return runWithLogger(session, 'createChild', () async {
      return await _workspaceService.createChild(
        session,
        name,
        userId,
        parentWorkspaceId,
        description,
      );
    });
  }

  // ===========================================================================
  // READ OPERATIONS (The Missing Ones!)
  // ===========================================================================

  Future<Workspace> getWorkspaceDetails(
    Session session, {
    required int workspaceId,
  }) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) throw AuthenticationException('User not authenticated');

    return runWithLogger(session, 'getWorkspaceDetails', () async {
      return await _workspaceService.getWorkspaceDetails(
        session,
        workspaceId,
        userId,
      );
    });
  }

  Future<List<Workspace>> getMyWorkspaces(Session session) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) throw AuthenticationException('User not authenticated');

    return runWithLogger(session, 'getMyWorkspaces', () async {
      return await _memberService.getMyWorkspaces(session, userId);
    });
  }

  Future<List<Workspace>> getChildWorkspaces(
    Session session, {
    required int parentWorkspaceId,
  }) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) throw AuthenticationException('User not authenticated');

    return runWithLogger(session, 'getChildWorkspaces', () async {
      return await _workspaceService.getChildWorkspaces(
        session,
        parentWorkspaceId,
        userId,
      );
    });
  }

  // ===========================================================================
  // MEMBER MANAGEMENT
  // ===========================================================================

  Future<WorkspaceMember> updateMemberRole(
    Session session, {
    required int memberId,
    required int workspaceId,
    required WorkspaceRole role,
  }) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) throw AuthenticationException('User not authenticated');

    return runWithLogger(session, 'updateMemberRole', () async {
      return await _memberService.updateMemberRole(
        session,
        memberId: memberId,
        workspaceId: workspaceId,
        role: role,
        actorId: userId,
      );
    });
  }

  Future<WorkspaceMember> removeMember(
    Session session, {
    required int memberId,
    required int workspaceId,
  }) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) throw AuthenticationException('User not authenticated');

    return runWithLogger(session, 'removeMember', () async {
      return await _memberService.removeMember(
        session,
        memberId: memberId,
        workspaceId: workspaceId,
        actorId: userId,
      );
    });
  }

  Future<void> leaveWorkspace(
    Session session, {
    required int workspaceId,
  }) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) throw AuthenticationException('User not authenticated');

    return runWithLogger(session, 'leaveWorkspace', () async {
      await _memberService.leaveWorkspace(
        session, 
        workspaceId, 
        userId
      );
    });
  }

  // ===========================================================================
  // INVITATIONS
  // ===========================================================================

  Future<WorkspaceInvitation> inviteMember(
    Session session,
    String email,
    int workspaceId,
    WorkspaceRole role,
  ) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) throw AuthenticationException('User not authenticated');

    final emailHandler = EmailHandler(session);
    final invitationService = InvitationService(
      _coreWorkspaceRepo,
      _memberRepo,
      _invitationRepo,
      emailHandler,
    );

    return runWithLogger(session, 'inviteMember', () async {
      return await invitationService.inviteMember(
        session,
        email,
        workspaceId,
        role,
        userId,
      );
    });
  }

  Future<WorkspaceMember> acceptInvitation(
    Session session,
    String token,
  ) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) throw AuthenticationException('User not authenticated');

    final emailHandler = EmailHandler(session);
    final invitationService = InvitationService(
      _coreWorkspaceRepo,
      _memberRepo,
      _invitationRepo,
      emailHandler,
    );

    return runWithLogger(session, 'acceptInvitation', () async {
      return await invitationService.acceptInvitation(
        session, 
        token,
        userId: userId
      );
    });
  }

  // ===========================================================================
  // UPDATE / ARCHIVE / DELETE
  // ===========================================================================

  Future<Workspace> updateWorkspaceDetails(
    Session session, {
    required int workspaceId,
    String? name,
    String? description,
  }) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) throw AuthenticationException('User not authenticated');

    return runWithLogger(session, 'updateWorkspaceDetails', () async {
      return await _workspaceService.updateWorkspaceDetails(
        session, 
        workspaceId, 
        name, 
        description, 
        userId
      );
    });
  }

  Future<Workspace> archiveWorkspace(
    Session session,
    int workspaceId,
  ) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) throw AuthenticationException('User not authenticated');

    return runWithLogger(session, 'archiveWorkspace', () async {
      return await _workspaceService.archiveWorkspace(session, workspaceId, userId);
    });
  }

  Future<Workspace> restoreWorkspace(
    Session session,
    int workspaceId,
  ) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) throw AuthenticationException('User not authenticated');

    return runWithLogger(session, 'restoreWorkspace', () async {
      return await _workspaceService.restoreWorkspace(session, workspaceId, userId);
    });
  }

  Future<bool> transferOwnership(
    Session session,
    int workspaceId,
    int newOwnerId,
  ) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) throw AuthenticationException('User not authenticated');

    return runWithLogger(session, 'transferOwnership', () async {
      return await _workspaceService.transferOwnership(
          session, workspaceId, newOwnerId, userId);
    });
  }

  Future<Workspace> initiateDeleteWorkspace(
    Session session,
    int workspaceId,
  ) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) throw AuthenticationException('User not authenticated');

    return runWithLogger(session, 'initiateDeleteWorkspace', () async {
      return await _workspaceService.initiateDeleteWorkspace(
          session, workspaceId, userId);
    });
  }
}