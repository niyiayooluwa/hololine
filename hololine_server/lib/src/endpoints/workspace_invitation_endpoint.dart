import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/modules/workspace/repositories/repositories.dart';
import 'package:hololine_server/src/modules/workspace/usecase/services.dart';
import 'package:hololine_server/src/services/email_service.dart';
import 'package:hololine_server/src/utils/authenticated_endpoint.dart';
import 'package:serverpod/serverpod.dart';

/// Endpoint for managing workspace invitations and onboarding.
class WorkspaceInvitationEndpoint extends AuthenticatedEndpoint {
  final WorkspaceRepo _coreWorkspaceRepo = WorkspaceRepo();
  final MemberRepo _memberRepo = MemberRepo();
  final InvitationRepo _invitationRepo = InvitationRepo();

  /// Invites a new member to a workspace via email.
  Future<WorkspaceInvitation> inviteMember(
    Session session,
    String email,
    int workspaceId,
    WorkspaceRole role,
  ) async {
    return runAuthenticated(session, 'inviteMember', (userId) async {
      final emailHandler = EmailHandler(session);
      final invitationService = InvitationService(
        _coreWorkspaceRepo,
        _memberRepo,
        _invitationRepo,
        emailHandler,
      );

      return await invitationService.inviteMember(
        session,
        email,
        workspaceId,
        role,
        userId,
      );
    });
  }

  /// Accepts a workspace invitation using a secret token.
  Future<WorkspaceMember> acceptInvitation(
    Session session,
    String token,
  ) async {
    return runAuthenticated(session, 'acceptInvitation', (userId) async {
      final emailHandler = EmailHandler(session);
      final invitationService = InvitationService(
        _coreWorkspaceRepo,
        _memberRepo,
        _invitationRepo,
        emailHandler,
      );

      return await invitationService.acceptInvitation(session, token,
          userId: userId);
    });
  }
}
