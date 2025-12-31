import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/modules/workspace/usecase/services.dart';
import 'package:hololine_server/src/utils/exceptions.dart';
import 'package:mockito/mockito.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:test/test.dart';

import '../../../../mocks.mocks.dart';

void main() {
  late MockWorkspaceRepo mockWorkspaceRepo;
  late MockMemberRepo mockMemberRepo;
  late InvitationService invitationService;
  late MockSession mockSession;
  late MockInvitationRepo mockInvitationRepo;
  late MockEmailHandler mockEmailHandler;

  setUp(() {
    // Create fresh instances for each test.
    mockWorkspaceRepo = MockWorkspaceRepo();
    mockMemberRepo = MockMemberRepo();
    mockSession = MockSession();
    mockEmailHandler = MockEmailHandler();
    mockInvitationRepo = MockInvitationRepo();
    invitationService = InvitationService(
      mockWorkspaceRepo,
      mockMemberRepo,
      mockInvitationRepo,
      mockEmailHandler,
    );
  });

  group('inviteMember', () {
    late String workspaceName;
    late int workspaceId;
    late String workspaceDesc;
    late Workspace expectedWorkspace;
    late int userId;
    late int inviteeId;
    late String email;
    late String token;
    late WorkspaceInvitation expectedInvitation;
    late WorkspaceMember member;

    setUp(() {
      // Common test data
      token = 'some_token';
      email = 'tohlhuh@gmail.com';
      workspaceName = 'Test Workspace';
      workspaceDesc = 'A workspace for testing';
      userId = 1;
      inviteeId = 2;
      workspaceId = 55;

      expectedWorkspace = Workspace(
        id: workspaceId,
        name: workspaceName,
        description: workspaceDesc,
        createdAt: DateTime.now().toUtc(),
      );

      expectedInvitation = WorkspaceInvitation(
        workspaceId: workspaceId,
        inviteeEmail: email,
        inviterId: inviteeId,
        role: WorkspaceRole.admin,
        token: token,
        expiresAt: DateTime.now().toUtc().add(Duration(hours: 44)),
      );

      member = WorkspaceMember(
        id: 1,
        userInfoId: userId,
        workspaceId: workspaceId,
        role: WorkspaceRole.admin,
        joinedAt: DateTime.now().toUtc(),
        isActive: true,
      );

      // Mock workspace checks
      when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .thenAnswer((_) async => expectedWorkspace);

      when(mockMemberRepo.findMemberByEmail(mockSession, email, workspaceId))
          .thenAnswer((_) async => null);

      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, userId, workspaceId))
          .thenAnswer((_) async => member);

      when(mockInvitationRepo.checkForExistingInvitation(
              mockSession, email, workspaceId))
          .thenAnswer((_) async => null);

      when(mockInvitationRepo.deleteInvitation(mockSession, token))
          .thenAnswer((_) async => true);

      // Use 'any' matcher for token since the service generates a random one
      when(mockInvitationRepo.checkIfTokenIsUnique(mockSession, any))
          .thenAnswer((_) async => null);

      when(mockEmailHandler.sendInvitation(
        email,
        any,
        workspaceName,
        WorkspaceRole.member,
      )).thenAnswer((_) async => true);

      when(mockInvitationRepo.createInvitation(
        mockSession,
        any,
      )).thenAnswer((_) async => expectedInvitation);
    });

    test('Should send invite', () async {
      await invitationService.inviteMember(
        mockSession,
        email,
        workspaceId,
        WorkspaceRole.member,
        userId,
      );

      verify(mockInvitationRepo.createInvitation(mockSession, any)).called(1);
    });

    test('Should throw PermissionDeniedException if actor is not a member',
        () async {
      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, userId, workspaceId))
          .thenAnswer((_) async => null);

      expect(
        () => invitationService.inviteMember(
          mockSession,
          email,
          workspaceId,
          WorkspaceRole.member,
          userId,
        ),
        throwsA(isA<PermissionDeniedException>()),
      );
    });

    test('Should throw PermissionDeniedException if actor is inactive',
        () async {
      when(mockMemberRepo.findMemberByWorkspaceId(
        mockSession,
        userId,
        workspaceId,
      )).thenAnswer(
        (_) async => WorkspaceMember(
          id: 1,
          userInfoId: userId,
          workspaceId: workspaceId,
          role: WorkspaceRole.admin,
          joinedAt: DateTime.now().toUtc(),
          isActive: false,
        ),
      );
      expect(
        () => invitationService.inviteMember(
          mockSession,
          email,
          workspaceId,
          WorkspaceRole.member,
          userId,
        ),
        throwsA(isA<PermissionDeniedException>()),
      );
    });

    test(
        'Should throw PermissionDeniedException if actor has insufficient priviledges',
        () async {
      when(mockMemberRepo.findMemberByWorkspaceId(
        mockSession,
        userId,
        workspaceId,
      )).thenAnswer(
        (_) async => WorkspaceMember(
          id: 1,
          userInfoId: userId,
          workspaceId: workspaceId,
          role: WorkspaceRole.member,
          joinedAt: DateTime.now().toUtc(),
        ),
      );

      expect(
        () => invitationService.inviteMember(
          mockSession,
          email,
          workspaceId,
          WorkspaceRole.member,
          userId,
        ),
        throwsA(isA<PermissionDeniedException>()),
      );
    });

    test('Should throw ConflictException if user is already a member',
        () async {
      when(mockMemberRepo.findMemberByEmail(
        mockSession,
        email,
        workspaceId,
      )).thenAnswer(
        (_) async => WorkspaceMember(
          id: 1,
          userInfoId: inviteeId,
          workspaceId: workspaceId,
          role: WorkspaceRole.member,
          joinedAt: DateTime.now().toUtc(),
        ),
      );
      expect(
        () => invitationService.inviteMember(
          mockSession,
          email,
          workspaceId,
          WorkspaceRole.member,
          userId,
        ),
        throwsA(isA<ConflictException>()),
      );
    });

    test('Should throw ConflictException if an invitation already exists',
        () async {
      when(mockInvitationRepo.checkForExistingInvitation(
        mockSession,
        email,
        workspaceId,
      )).thenAnswer(
        (_) async => WorkspaceInvitation(
          workspaceId: workspaceId,
          inviteeEmail: email,
          inviterId: userId,
          role: WorkspaceRole.member,
          token: token,
          expiresAt: DateTime.now().toUtc().add(Duration(hours: 44)),
        ),
      );

      expect(
        () => invitationService.inviteMember(
          mockSession,
          email,
          workspaceId,
          WorkspaceRole.member,
          userId,
        ),
        throwsA(isA<ConflictException>()),
      );
    });

    test('Should throw InvalidStateException if token cant be generated',
        () async {
      when(mockInvitationRepo.checkIfTokenIsUnique(mockSession, any))
          .thenAnswer(
        (_) async => WorkspaceInvitation(
          workspaceId: workspaceId,
          inviteeEmail: email,
          inviterId: userId,
          role: WorkspaceRole.member,
          token: token,
          expiresAt: DateTime.now().toUtc().add(Duration(hours: 44)),
        ),
      );
      expect(
        () => invitationService.inviteMember(
          mockSession,
          email,
          workspaceId,
          WorkspaceRole.member,
          userId,
        ),
        throwsA(isA<InvalidStateException>()),
      );
    });

    test('Should throw ExternalServiceException due to failure to send mail',
        () async {
      when(mockEmailHandler.sendInvitation(
        email,
        any,
        workspaceName,
        WorkspaceRole.member,
      )).thenAnswer((_) async => false);

      expect(
        () => invitationService.inviteMember(
          mockSession,
          email,
          workspaceId,
          WorkspaceRole.member,
          userId,
        ),
        throwsA(isA<ExternalServiceException>()),
      );
    });
  });

  group('acceptInvitation', () {
    late String workspaceName;
    late int workspaceId;
    late String workspaceDesc;
    late Workspace expectedWorkspace;
    late int userId;
    late int inviterId;
    late String email;
    late String token;
    late WorkspaceInvitation expectedInvitation;
    late WorkspaceMember newMember;
    late UserInfo userInfo;

    setUp(() {
      // Common test data
      token = 'some_token';
      email = 'tanya@mail.com';
      workspaceName = 'Test Workspace';
      workspaceDesc = 'A workspace for testing';
      userId = 1;
      inviterId = 2;
      workspaceId = 55;

      expectedWorkspace = Workspace(
        id: workspaceId,
        name: workspaceName,
        description: workspaceDesc,
        createdAt: DateTime.now().toUtc(),
      );

      expectedInvitation = WorkspaceInvitation(
        workspaceId: workspaceId,
        inviteeEmail: email,
        inviterId: inviterId,
        role: WorkspaceRole.admin,
        token: token,
        expiresAt: DateTime.now().toUtc().add(Duration(hours: 44)),
      );

      newMember = WorkspaceMember(
        id: 1,
        userInfoId: userId,
        workspaceId: workspaceId,
        role: WorkspaceRole.admin,
        joinedAt: DateTime.now().toUtc(),
        isActive: true,
      );

      userInfo = UserInfo(
        userIdentifier: 'user_123',
        created: DateTime.now().toUtc(),
        blocked: false,
        email: email,
        scopeNames: [],
      );

      // Mock workspace checks
      when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .thenAnswer((_) async => expectedWorkspace);

      // Mock user info lookup
      when(mockWorkspaceRepo.getUserInfo(mockSession, userId))
          .thenAnswer((_) async => userInfo);

      // Mock invitation lookup
      when(mockInvitationRepo.findInvitationByToken(mockSession, token))
          .thenAnswer((_) async => expectedInvitation);

      // Mock member check (no existing member)
      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, userId, workspaceId))
          .thenAnswer((_) async => null);

      // Mock accepting the invitation
      when(mockInvitationRepo.acceptInvitation(
        mockSession,
        expectedInvitation,
        userId,
        token,
      )).thenAnswer((_) async => newMember);
    });

    test('Should successfully accept invitation', () async {
      // ACT - pass userId directly to service
      final result = await invitationService.acceptInvitation(
        mockSession,
        token,
        userId: userId,
      );

      // ASSERT
      expect(result, equals(newMember));

      // Verify all the repository methods were called
      verify(mockWorkspaceRepo.getUserInfo(mockSession, userId)).called(1);
      verify(mockInvitationRepo.findInvitationByToken(mockSession, token))
          .called(1);
      verify(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .called(1);
      verify(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, userId, workspaceId))
          .called(1);
      verify(mockInvitationRepo.acceptInvitation(
        mockSession,
        expectedInvitation,
        userId,
        token,
      )).called(1);
    });

    test('Should throw AuthenticationException if user not authenticated',
        () async {
      // ARRANGE - stub session.authenticated to return null
      when(mockSession.authenticated).thenAnswer((_) async => null);

      // ACT & ASSERT - pass null userId to trigger authentication error
      expect(
        () => invitationService.acceptInvitation(
          mockSession,
          token,
          userId: null,
        ),
        throwsA(isA<AuthenticationException>()),
      );
    });

    test('Should throw NotFoundException if invitation token is invalid',
        () async {
      // ARRANGE - reset and re-stub the invitation repo
      reset(mockInvitationRepo);
      when(mockInvitationRepo.findInvitationByToken(mockSession, token))
          .thenAnswer((_) async => null);

      // ACT & ASSERT
      expect(
        () => invitationService.acceptInvitation(mockSession, token,
            userId: userId),
        throwsA(isA<NotFoundException>()),
      );
    });

    test('Should throw InvalidStateException if invitation expired', () async {
      // ARRANGE - reset and re-stub the invitation repo
      reset(mockInvitationRepo);
      final expiredInvitation = expectedInvitation.copyWith(
        expiresAt: DateTime.now().toUtc().subtract(Duration(hours: 1)),
      );

      when(mockInvitationRepo.findInvitationByToken(mockSession, token))
          .thenAnswer((_) async => expiredInvitation);

      // ACT & ASSERT
      expect(
        () => invitationService.acceptInvitation(mockSession, token,
            userId: userId),
        throwsA(isA<InvalidStateException>()),
      );
    });

    test('Should throw PermissionDeniedException if email does not match',
        () async {
      // ARRANGE - reset and re-stub the invitation repo
      reset(mockInvitationRepo);
      final differentEmailInvitation = expectedInvitation.copyWith(
        inviteeEmail: 'different@mail.com',
      );

      when(mockInvitationRepo.findInvitationByToken(mockSession, token))
          .thenAnswer((_) async => differentEmailInvitation);

      // ACT & ASSERT
      expect(
        () => invitationService.acceptInvitation(mockSession, token,
            userId: userId),
        throwsA(isA<PermissionDeniedException>()),
      );
    });

    test('Should throw ConflictException if user already a member', () async {
      // ARRANGE - reset and re-stub the member repo
      reset(mockMemberRepo);
      final existingMember = WorkspaceMember(
        userInfoId: userId,
        workspaceId: workspaceId,
        role: WorkspaceRole.member,
        joinedAt: DateTime.now().toUtc(),
        isActive: true,
      );

      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, userId, workspaceId))
          .thenAnswer((_) async => existingMember);

      // ACT & ASSERT
      expect(
        () => invitationService.acceptInvitation(mockSession, token,
            userId: userId),
        throwsA(isA<ConflictException>()),
      );
    });
  });
}
