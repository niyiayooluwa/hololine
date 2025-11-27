import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/modules/workspace/repositories/repositories.dart';
import 'package:hololine_server/src/modules/workspace/usecase/services.dart';
import 'package:hololine_server/src/utils/endpoint_helper.dart';
import 'package:hololine_server/src/utils/exceptions.dart';
import 'package:serverpod/serverpod.dart';

/// Manages workspace-related operations such as creation, member management,
/// and invitations. All endpoints require user authentication.
class WorkspaceEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  final WorkspaceRepo _coreWorkspaceRepo = WorkspaceRepo();
  final MemberRepo _memberRepo = MemberRepo();
  final InvitationRepo _invitationRepo = InvitationRepo();

  // Now, create the services and inject their dependencies directly.
  // We use `late final` because they depend on the repositories defined above.
  late final WorkspaceService _workspaceService = WorkspaceService(
    _memberRepo,
    _coreWorkspaceRepo,
  );
  late final MemberService _memberService = MemberService(
    _memberRepo,
    _coreWorkspaceRepo,
  );
  late final InvitationService _invitationService = InvitationService(
    _coreWorkspaceRepo,
    _memberRepo,
    _invitationRepo,
  );

  /// Creates a new standalone workspace.
  ///
  /// A standalone workspace does not have a parent. The authenticated user
  /// will become the owner of this new workspace.
  ///
  /// - [name]: The name of the workspace.
  /// - [description]: A description for the workspace.
  ///
  /// Returns the newly created [Workspace].
  /// Throws an [Exception] if the user is not authenticated or if creation fails.
  Future<Workspace> createStandalone(
      Session session, String name, String description) async {
    var userId = (await session.authenticated)?.userId;

    if (userId == null) {
      throw AuthenticationException('User not authenticated');
    }

    // This endpoint returns a Workspace, not a Response, so we can't use the
    // withLogging helper without creating a second helper. We'll add manual logging.
    try {
      session.log('Endpoint "createStandalone" called.', level: LogLevel.info);
      final workspace =
          await _workspaceService.createStandalone(session, name, userId, description);
      session.log('Endpoint "createStandalone" succeeded.',
          level: LogLevel.info);
      return workspace;
    } catch (e, stackTrace) {
      session.log(
        '"createStandalone" failed.',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Creates a new child workspace under a specified parent.
  ///
  /// The authenticated user must have permissions to create a child workspace
  /// under the given [parentWorkspaceId].
  ///
  /// - [name]: The name of the new child workspace.
  /// - [parentWorkspaceId]: The ID of the parent workspace.
  /// - [description]: A description for the new workspace.
  ///
  /// Returns the newly created child [Workspace].
  /// Throws an [Exception] if the user is not authenticated or if creation fails.
  Future<Workspace> createChild(
    Session session,
    String name,
    int parentWorkspaceId,
    String description,
  ) async {
    var userId = (await session.authenticated)?.userId;

    if (userId == null) {
      throw AuthenticationException('User not authenticated');
    }

    // This endpoint returns a Workspace, not a Response, so we can't use the
    // withLogging helper without creating a second helper. We'll add manual logging.
    try {
      session.log('Endpoint "createChild" called.', level: LogLevel.info);
      final workspace = await _workspaceService.createChild(
        session,
        name,
        userId,
        parentWorkspaceId,
        description,
      );
      session.log('Endpoint "createChild" succeeded.', level: LogLevel.info);
      return workspace;
    } catch (e, stackTrace) {
      session.log(
        '"createChild" failed.',
        level: LogLevel.error,
        exception: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  /// Updates the role of a member within a workspace.
  Future<Response> updateMemberRole(
    Session session, {
    required int memberId,
    required int workspaceId,
    required WorkspaceRole role,
  }) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) {
      throw AuthenticationException('User not authenticated');
    }

    return withLogging(
      session,
      'updateMemberRole',
      () async {
        await _memberService.updateMemberRole(
          session,
          memberId: memberId,
          workspaceId: workspaceId,
          role: role,
          actorId: userId,
        );
        return 'Member role updated';
      },
    );
  }

  /// Removes a member from a workspace.
  Future<Response> removeMember(
    Session session, {
    required int memberId,
    required int workspaceId,
  }) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) {
      throw AuthenticationException('User not authenticated');
    }

    return withLogging(
      session,
      'removeMember',
      () async {
        await _memberService.removeMember(
          session,
          memberId: memberId,
          workspaceId: workspaceId,
          actorId: userId,
        );
        return 'Member removed';
      },
    );
  }

  /// Sends an invitation to a user to join a workspace.
  Future<Response> inviteMember(
    Session session,
    String email,
    int workspaceId,
    WorkspaceRole role,
  ) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) {
      throw AuthenticationException('User not authenticated');
    }

    return withLogging(
      session,
      'inviteMember',
      () async {
        await _invitationService.inviteMember(
          session,
          email,
          workspaceId,
          role,
          userId,
        );
        return 'Member invited';
      },
    );
  }

  /// Accepts a workspace invitation using an invitation token.
  Future<Response> acceptInvitation(
    Session session,
    String token,
  ) async {
    final userId = (await session.authenticated)?.userId;
    if (userId == null) {
      throw AuthenticationException('User not authenticated');
    }

    return withLogging(
      session,
      'acceptInvitation',
      () async {
        await _invitationService.acceptInvitation(session, token);
        return 'Invitation accepted successfully. Welcome to the workspace!';
      },
    );
  }

  /// Archives a workspace, making it inactive.
  Future<Response> archiveWorkspace(
    Session session,
    int workspaceId,
  ) async {
    final user = (await session.authenticated)?.userId;
    if (user == null) {
      throw AuthenticationException('User not authenticated');
    }

    return withLogging(
      session,
      'archiveWorkspace',
      () async {
        await _workspaceService.archiveWorkspace(session, workspaceId, user);
        return 'Workspace archived successfully';
      },
    );
  }

  /// Restores an archived workspace.
  Future<Response> restoreWorkspace(
    Session session,
    int workspaceId,
  ) async {
    final user = (await session.authenticated)?.userId;
    if (user == null) {
      throw AuthenticationException('User not authenticated');
    }

    return withLogging(
      session,
      'restoreWorkspace',
      () async {
        await _workspaceService.restoreWorkspace(session, workspaceId, user);
        return 'Workspace restored successfully';
      },
    );
  }

  /// Transfers ownership of a workspace to another member.
  Future<Response> transferOwnership(
    Session session,
    int workspaceId,
    int newOwnerId,
  ) async {
    final user = (await session.authenticated)?.userId;
    if (user == null) {
      throw AuthenticationException('User not authenticated');
    }

    return withLogging(
      session,
      'transferOwnership',
      () async {
        await _workspaceService.transferOwnership(
            session, workspaceId, newOwnerId, user);
        return 'Ownership transferred successfully';
      },
    );
  }

  /// Initiate the deletion process
  Future<Response> initiateDeleteWorkspace(
    Session session,
    int workspaceId,
  ) async {
    final user = (await session.authenticated)?.userId;
    if (user == null) {
      throw AuthenticationException('User not authenticated');
    }

    return withLogging(
      session,
      'deleteWorkspace',
      () async {
        await _workspaceService.initiateDeleteWorkspace(session, workspaceId, user);
        return 'Workspace deletion initiated successfully';
      },
    );
  }
}
