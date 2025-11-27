import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/modules/workspace/usecase/member_service.dart';
import 'package:hololine_server/src/utils/exceptions.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../mocks.mocks.dart';

void main() {
  late MockWorkspaceRepo mockWorkspaceRepo;
  late MockMemberRepo mockMemberRepo;
  late MemberService memberService;
  late MockSession mockSession;

  setUp(() {
    mockWorkspaceRepo = MockWorkspaceRepo();
    mockMemberRepo = MockMemberRepo();
    mockSession = MockSession();

    // MemberService depends on both repositories
    memberService = MemberService(
      mockMemberRepo,
      mockWorkspaceRepo,
    );
  });

  group('updateMemberRole', () {
    late String workspaceName;
    late int workspaceId;
    late String workspaceDesc;
    late Workspace expectedWorkspace;
    late int actorId;
    late int memberId;

    setUp(() {
      workspaceName = 'Test Workspace';
      workspaceDesc = 'A workspace for testing';
      actorId = 1;
      memberId = 2;
      workspaceId = 55;
    });
    // Happy Path
    test('Should update the member role', () async {
      // ARRANGE
      expectedWorkspace = Workspace(
        id: workspaceId,
        name: workspaceName,
        description: workspaceDesc,
        createdAt: DateTime.now().toUtc(),
      );

      // STUB
      when(mockMemberRepo.findMemberByWorkspaceId(any, actorId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: actorId,
                workspaceId: workspaceId,
                role: WorkspaceRole.admin,
                joinedAt: DateTime.now().toUtc(),
              ));

      when(mockMemberRepo.findMemberByWorkspaceId(any, memberId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: memberId,
                workspaceId: workspaceId,
                role: WorkspaceRole.member,
                joinedAt: DateTime.now().toUtc(),
              ));

      when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .thenAnswer((_) async => expectedWorkspace);

      // ACT
      await memberService.updateMemberRole(
        mockSession,
        memberId: memberId,
        workspaceId: workspaceId,
        role: WorkspaceRole.admin,
        actorId: actorId,
      );

      // ASSERT
      verify(mockMemberRepo.updateMemberRole(
        mockSession,
        memberId,
        WorkspaceRole.admin,
        workspaceId,
      )).called(1);
    });

    // Unhappy paths
    test(
        'Throws PermissionDeniedException because actor is not a member of the workspace',
        () async {
      // ARRANGE
      expectedWorkspace = Workspace(
        id: workspaceId,
        name: workspaceName,
        description: workspaceDesc,
        createdAt: DateTime.now().toUtc(),
      );

      // STUB
      when(mockMemberRepo.findMemberByWorkspaceId(any, actorId, any))
          .thenAnswer((_) async => null);

      when(mockMemberRepo.findMemberByWorkspaceId(any, memberId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: memberId,
                workspaceId: workspaceId,
                role: WorkspaceRole.member,
                joinedAt: DateTime.now().toUtc(),
              ));

      when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .thenAnswer((_) async => expectedWorkspace);

      // ACT
      expect(
        () => memberService.updateMemberRole(
          mockSession,
          memberId: memberId,
          workspaceId: workspaceId,
          role: WorkspaceRole.admin,
          actorId: actorId,
        ),
        throwsA(isA<PermissionDeniedException>()),
      );
    });

    test('Throws PermissionDeniedException because actor is inactive',
        () async {
      // ARRANGE
      expectedWorkspace = Workspace(
        id: workspaceId,
        name: workspaceName,
        description: workspaceDesc,
        createdAt: DateTime.now().toUtc(),
      );

      // STUB
      when(mockMemberRepo.findMemberByWorkspaceId(any, actorId, any))
          .thenAnswer((_) async => WorkspaceMember(
              userInfoId: actorId,
              workspaceId: workspaceId,
              role: WorkspaceRole.admin,
              joinedAt: DateTime.now().toUtc(),
              isActive: false));

      when(mockMemberRepo.findMemberByWorkspaceId(any, memberId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: memberId,
                workspaceId: workspaceId,
                role: WorkspaceRole.member,
                joinedAt: DateTime.now().toUtc(),
              ));

      when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .thenAnswer((_) async => expectedWorkspace);

      // ACT
      expect(
        () => memberService.updateMemberRole(
          mockSession,
          memberId: memberId,
          workspaceId: workspaceId,
          role: WorkspaceRole.admin,
          actorId: actorId,
        ),
        throwsA(isA<PermissionDeniedException>()),
      );
    });

    test(
        'Throws NotFoundException because target member not found in workspace',
        () async {
      // ARRANGE
      expectedWorkspace = Workspace(
        id: workspaceId,
        name: workspaceName,
        description: workspaceDesc,
        createdAt: DateTime.now().toUtc(),
      );

      // STUB
      when(mockMemberRepo.findMemberByWorkspaceId(any, actorId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: actorId,
                workspaceId: workspaceId,
                role: WorkspaceRole.admin,
                joinedAt: DateTime.now().toUtc(),
              ));

      when(mockMemberRepo.findMemberByWorkspaceId(any, memberId, any))
          .thenAnswer((_) async => null);

      when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .thenAnswer((_) async => expectedWorkspace);

      // ACT
      expect(
        () => memberService.updateMemberRole(
          mockSession,
          memberId: memberId,
          workspaceId: workspaceId,
          role: WorkspaceRole.admin,
          actorId: actorId,
        ),
        throwsA(isA<NotFoundException>()),
      );
    });

    test('Throws InvalidStateException because member is inactive', () async {
      // ARRANGE
      expectedWorkspace = Workspace(
        id: workspaceId,
        name: workspaceName,
        description: workspaceDesc,
        createdAt: DateTime.now().toUtc(),
      );

      // STUB
      when(mockMemberRepo.findMemberByWorkspaceId(any, actorId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: actorId,
                workspaceId: workspaceId,
                role: WorkspaceRole.admin,
                joinedAt: DateTime.now().toUtc(),
              ));

      when(mockMemberRepo.findMemberByWorkspaceId(any, memberId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: memberId,
                workspaceId: workspaceId,
                role: WorkspaceRole.member,
                joinedAt: DateTime.now().toUtc(),
                isActive: false,
              ));

      when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .thenAnswer((_) async => expectedWorkspace);

      // ACT
      expect(
        () => memberService.updateMemberRole(
          mockSession,
          memberId: memberId,
          workspaceId: workspaceId,
          role: WorkspaceRole.admin,
          actorId: actorId,
        ),
        throwsA(isA<InvalidStateException>()),
      );
    });

    test(
        'Throws PermissionDeniedException because actor and target member is owner',
        () async {
      // ARRANGE
      expectedWorkspace = Workspace(
        id: workspaceId,
        name: workspaceName,
        description: workspaceDesc,
        createdAt: DateTime.now().toUtc(),
      );

      // STUB
      when(mockMemberRepo.findMemberByWorkspaceId(any, actorId, any))
          .thenAnswer((_) async => WorkspaceMember(
              userInfoId: actorId,
              workspaceId: workspaceId,
              role: WorkspaceRole.owner,
              joinedAt: DateTime.now().toUtc(),
              isActive: false));

      when(mockMemberRepo.findMemberByWorkspaceId(any, memberId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: actorId,
                workspaceId: workspaceId,
                role: WorkspaceRole.owner,
                joinedAt: DateTime.now().toUtc(),
              ));

      when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .thenAnswer((_) async => expectedWorkspace);

      // ACT
      expect(
        () => memberService.updateMemberRole(
          mockSession,
          memberId: memberId,
          workspaceId: workspaceId,
          role: WorkspaceRole.admin,
          actorId: actorId,
        ),
        throwsA(isA<PermissionDeniedException>()),
      );
    });

    group(
        'Tests the role policy conditional, should throw PermissionDeniedException for all',
        () {
      test(
          'Should throw PermissionDeniedException when actor has insufficient privileges',
          () async {
        // ARRANGE
        expectedWorkspace = Workspace(
          id: workspaceId,
          name: workspaceName,
          description: workspaceDesc,
          createdAt: DateTime.now().toUtc(),
        );

        when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
            .thenAnswer((_) async => expectedWorkspace);

        when(mockMemberRepo.findMemberByWorkspaceId(any, actorId, any))
            .thenAnswer((_) async => WorkspaceMember(
                  userInfoId: actorId,
                  workspaceId: workspaceId,
                  role: WorkspaceRole.member,
                  // Actor is just a member
                  joinedAt: DateTime.now().toUtc(),
                  isActive: true,
                ));

        when(mockMemberRepo.findMemberByWorkspaceId(any, memberId, any))
            .thenAnswer((_) async => WorkspaceMember(
                  userInfoId: memberId,
                  workspaceId: workspaceId,
                  role: WorkspaceRole.viewer,
                  // Target is a viewer
                  joinedAt: DateTime.now().toUtc(),
                  isActive: true,
                ));

        // ACT & ASSERT
        expect(
          () => memberService.updateMemberRole(
            mockSession,
            memberId: memberId,
            workspaceId: workspaceId,
            role: WorkspaceRole.admin, // Trying to promote to admin
            actorId: actorId,
          ),
          throwsA(isA<PermissionDeniedException>()),
        );
      });

      test(
          'Should throw PermissionDeniedException when actor has insufficient privileges',
          () async {
        // ARRANGE
        expectedWorkspace = Workspace(
          id: workspaceId,
          name: workspaceName,
          description: workspaceDesc,
          createdAt: DateTime.now().toUtc(),
        );

        when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
            .thenAnswer((_) async => expectedWorkspace);

        when(mockMemberRepo.findMemberByWorkspaceId(any, actorId, any))
            .thenAnswer((_) async => WorkspaceMember(
                  userInfoId: actorId,
                  workspaceId: workspaceId,
                  role: WorkspaceRole.member,
                  // Actor is just a member
                  joinedAt: DateTime.now().toUtc(),
                  isActive: true,
                ));

        when(mockMemberRepo.findMemberByWorkspaceId(any, memberId, any))
            .thenAnswer((_) async => WorkspaceMember(
                  userInfoId: memberId,
                  workspaceId: workspaceId,
                  role: WorkspaceRole.member,
                  // Target is a viewer
                  joinedAt: DateTime.now().toUtc(),
                  isActive: true,
                ));

        // ACT & ASSERT
        expect(
          () => memberService.updateMemberRole(
            mockSession,
            memberId: memberId,
            workspaceId: workspaceId,
            role: WorkspaceRole.member,
            // Trying to promote to admin
            actorId: actorId,
          ),
          throwsA(isA<PermissionDeniedException>()),
        );
      });

      test(
          'Should throw PermissionDeniedException when actor has insufficient privileges',
          () async {
        // ARRANGE
        expectedWorkspace = Workspace(
          id: workspaceId,
          name: workspaceName,
          description: workspaceDesc,
          createdAt: DateTime.now().toUtc(),
        );

        when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
            .thenAnswer((_) async => expectedWorkspace);

        when(mockMemberRepo.findMemberByWorkspaceId(any, actorId, any))
            .thenAnswer((_) async => WorkspaceMember(
                  userInfoId: actorId,
                  workspaceId: workspaceId,
                  role: WorkspaceRole.admin,
                  // Actor is just a member
                  joinedAt: DateTime.now().toUtc(),
                  isActive: true,
                ));

        when(mockMemberRepo.findMemberByWorkspaceId(any, memberId, any))
            .thenAnswer((_) async => WorkspaceMember(
                  userInfoId: memberId,
                  workspaceId: workspaceId,
                  role: WorkspaceRole.owner,
                  // Target is a viewer
                  joinedAt: DateTime.now().toUtc(),
                  isActive: true,
                ));

        // ACT & ASSERT
        expect(
          () => memberService.updateMemberRole(
            mockSession,
            memberId: memberId,
            workspaceId: workspaceId,
            role: WorkspaceRole.member,
            // Trying to promote to admin
            actorId: actorId,
          ),
          throwsA(isA<PermissionDeniedException>()),
        );
      });
    });
  });

  group('removeMember', () {
    late String workspaceName;
    late int workspaceId;
    late String workspaceDesc;
    late Workspace expectedWorkspace;
    late int actorId;
    late int memberId;

    setUp(() {
      workspaceName = 'Test Workspace';
      workspaceDesc = 'A workspace for testing';
      actorId = 1;
      memberId = 2;
      workspaceId = 55;
      expectedWorkspace = Workspace(
        id: workspaceId,
        name: workspaceName,
        description: workspaceDesc,
        createdAt: DateTime.now().toUtc(),
      );
    });
    // HAPPY PATH
    test('Should remove the member from the workspace', () async {
      when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .thenAnswer((_) async => expectedWorkspace);

      when(mockMemberRepo.findMemberByWorkspaceId(any, actorId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: actorId,
                workspaceId: workspaceId,
                role: WorkspaceRole.admin,
                joinedAt: DateTime.now().toUtc(),
              ));

      when(mockMemberRepo.findMemberByWorkspaceId(any, memberId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: memberId,
                workspaceId: workspaceId,
                role: WorkspaceRole.member,
                joinedAt: DateTime.now().toUtc(),
              ));

      await memberService.removeMember(
        mockSession,
        actorId: actorId,
        memberId: memberId,
        workspaceId: workspaceId,
      );

      verify(mockMemberRepo.deactivateMember(
        mockSession,
        memberId,
        workspaceId,
      )).called(1);
    });

    // UNHAPPY PATHS
    test('Throws PermissionDeniedException because actor is not a member',
        () async {
      when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .thenAnswer((_) async => expectedWorkspace);

      when(mockMemberRepo.findMemberByWorkspaceId(any, actorId, any))
          .thenAnswer((_) async => null);

      when(mockMemberRepo.findMemberByWorkspaceId(any, memberId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: memberId,
                workspaceId: workspaceId,
                role: WorkspaceRole.member,
                joinedAt: DateTime.now().toUtc(),
              ));

      expect(
        () => memberService.removeMember(
          mockSession,
          memberId: memberId,
          workspaceId: workspaceId,
          actorId: actorId,
        ),
        throwsA(isA<PermissionDeniedException>()),
      );
    });

    test('Throws PermissionDeniedException because actor is inactive',
        () async {
      when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .thenAnswer((_) async => expectedWorkspace);

      when(mockMemberRepo.findMemberByWorkspaceId(any, actorId, any))
          .thenAnswer((_) async => WorkspaceMember(
              userInfoId: actorId,
              workspaceId: workspaceId,
              role: WorkspaceRole.owner,
              joinedAt: DateTime.now().toUtc(),
              isActive: false));

      when(mockMemberRepo.findMemberByWorkspaceId(any, memberId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: memberId,
                workspaceId: workspaceId,
                role: WorkspaceRole.member,
                joinedAt: DateTime.now().toUtc(),
              ));

      expect(
        () => memberService.removeMember(
          mockSession,
          memberId: memberId,
          workspaceId: workspaceId,
          actorId: actorId,
        ),
        throwsA(isA<PermissionDeniedException>()),
      );
    });

    test('Throws NotFoundException because target member not found', () async {
      when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .thenAnswer((_) async => expectedWorkspace);

      when(mockMemberRepo.findMemberByWorkspaceId(any, actorId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: actorId,
                workspaceId: workspaceId,
                role: WorkspaceRole.owner,
                joinedAt: DateTime.now().toUtc(),
              ));

      when(mockMemberRepo.findMemberByWorkspaceId(any, memberId, any))
          .thenAnswer((_) async => null);

      expect(
        () => memberService.removeMember(
          mockSession,
          memberId: memberId,
          workspaceId: workspaceId,
          actorId: actorId,
        ),
        throwsA(isA<NotFoundException>()),
      );
    });

    test('Throws PermissionDeniedException because actor is target member',
        () async {
      when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .thenAnswer((_) async => expectedWorkspace);

      when(mockMemberRepo.findMemberByWorkspaceId(any, actorId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: actorId,
                workspaceId: workspaceId,
                role: WorkspaceRole.owner,
                joinedAt: DateTime.now().toUtc(),
              ));

      when(mockMemberRepo.findMemberByWorkspaceId(any, actorId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: actorId,
                workspaceId: workspaceId,
                role: WorkspaceRole.member,
                joinedAt: DateTime.now().toUtc(),
              ));

      expect(
        () => memberService.removeMember(
          mockSession,
          memberId: actorId,
          workspaceId: workspaceId,
          actorId: actorId,
        ),
        throwsA(isA<PermissionDeniedException>()),
      );
    });

    test('Throws PermissionDeniedException because actor role is insufficient',
        () async {
      when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .thenAnswer((_) async => expectedWorkspace);

      when(mockMemberRepo.findMemberByWorkspaceId(any, actorId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: actorId,
                workspaceId: workspaceId,
                role: WorkspaceRole.member,
                joinedAt: DateTime.now().toUtc(),
              ));

      when(mockMemberRepo.findMemberByWorkspaceId(any, actorId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: actorId,
                workspaceId: workspaceId,
                role: WorkspaceRole.member,
                joinedAt: DateTime.now().toUtc(),
              ));

      expect(
        () => memberService.removeMember(
          mockSession,
          memberId: actorId,
          workspaceId: workspaceId,
          actorId: actorId,
        ),
        throwsA(isA<PermissionDeniedException>()),
      );
    });
  });
}
