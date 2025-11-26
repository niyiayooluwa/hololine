import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/usecase/workspace_service.dart';
import 'package:hololine_server/src/utils/exceptions.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../mocks.mocks.dart';

void main() {
  late MockWorkspaceRepo mockWorkspaceRepo;
  late WorkspaceService workspaceService;
  late MockSession mockSession;

  setUp(() {
    // Create fresh instances of our mocks and the service for each test.
    mockWorkspaceRepo = MockWorkspaceRepo();
    mockSession = MockSession();
    workspaceService = WorkspaceService(workspaceRepository: mockWorkspaceRepo);
  });

  group('createStandalone', () {
    test('should return a new workspace when called with valid data', () async {
      // ARRANGE

      // 1. Define the test data we'll be using.
      const workspaceName = 'Test Workspace';
      const workspaceDesc = 'A workspace for testing';
      const userId = 1;
      final expectedWorkspace = Workspace(
        id: 1,
        name: workspaceName,
        description: workspaceDesc,
        createdAt: DateTime.now().toUtc(),
      );

      // 2. Stub the behavior of our mock repository.
      // We are telling the mock: "When the 'create' method is called with ANY
      // arguments, then return our expected workspace."
      // We use `thenAnswer` because `create` returns a Future.
      when(mockWorkspaceRepo.create(any, any, any)).thenAnswer(
        (_) async => expectedWorkspace,
      );

      // ACT

      // 3. Call the actual method we want to test on our service.
      final result = await workspaceService.createStandalone(
        mockSession, // We pass our mock session here.
        workspaceName,
        userId,
        workspaceDesc,
      );

      // ASSERT

      // 4. Check that the result from the service is the one we told our mock to return.
      expect(result, equals(expectedWorkspace));

      // 5. Verify that the 'create' method on our mock repository was called
      // exactly one time. This confirms our service is correctly interacting
      // with its dependency.
      verify(mockWorkspaceRepo.create(any, any, any)).called(1);
    });

    test('should throw an exception if the repository fails', () async {
      // ARRANGE

      // 1. Define the exception we want our mock to throw.
      final exception = Exception('Database connection failed');

      // 2. Stub the mock to throw an error.
      // We are telling the mock: "When the 'create' method is called,
      // throw this exception."
      when(mockWorkspaceRepo.create(any, any, any)).thenThrow(exception);

      // ACT & ASSERT

      // 3. We expect that calling the service method will result in an exception.
      // The `throwsA(isA<Exception>())` matcher checks that an exception of
      // the specified type is thrown.
      expect(
        () => workspaceService.createStandalone(
          mockSession,
          'any name',
          1,
          'any description',
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('createChild', () {
    // Happy Path
    test('Should return a new child workspace when called with valid data',
        () async {
      // ARRANGE
      const workspaceName = 'Test Workspace';
      const workspaceDesc = 'A workspace for testing';
      const userId = 1;
      const parentId = 55;
      final expectedWorkspace = Workspace(
        id: 1,
        name: workspaceName,
        parentId: parentId,
        description: workspaceDesc,
        createdAt: DateTime.now().toUtc(),
      );

      // STUB
      when(mockWorkspaceRepo.create(any, any, any)).thenAnswer(
        (_) async => expectedWorkspace,
      );

      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, any, any)).thenAnswer(
          (_) async => WorkspaceMember(
              userInfoId: userId,
              workspaceId: parentId,
              role: WorkspaceRole.admin,
              joinedAt: DateTime.now().toUtc()));

      when(mockWorkspaceRepo.findWorkspaceById(any, any))
          .thenAnswer((_) async => Workspace(
                name: 'Parent Workspace',
                id: parentId,
                description: 'Parent workspace description',
                createdAt: DateTime.now().toUtc(),
              ));

      // ACT
      final result = await workspaceService.createChild(
        mockSession,
        workspaceName,
        userId,
        parentId,
        workspaceDesc,
      );

      // ASSERT
      expect(result, equals(expectedWorkspace));
      verify(mockWorkspaceRepo.create(any, any, any)).called(1);
    });

    // Unhappy Path
    test('Should return PermissionDeniedException because member is null',
        () async {
      // ARRANGE
      const workspaceName = 'Test Workspace';
      const workspaceDesc = 'A workspace for testing';
      const userId = 1;
      const parentId = 55;
      final expectedWorkspace = Workspace(
        id: 1,
        name: workspaceName,
        parentId: parentId,
        description: workspaceDesc,
        createdAt: DateTime.now().toUtc(),
      );

      // STUB
      when(mockWorkspaceRepo.create(any, any, any)).thenAnswer(
        (_) async => expectedWorkspace,
      );

      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, any, any))
          .thenAnswer((_) async => null);

      // ACT & ASSERT
      expect(
          () => workspaceService.createChild(
                mockSession,
                workspaceName,
                userId,
                parentId,
                workspaceDesc,
              ),
          throwsA(isA<PermissionDeniedException>()));
    });

    test('Should return PermissionDeniedException because member is inactive',
        () async {
      // ARRANGE
      const workspaceName = 'Test Workspace';
      const workspaceDesc = 'A workspace for testing';
      const userId = 1;
      const parentId = 55;
      final expectedWorkspace = Workspace(
        id: 1,
        name: workspaceName,
        parentId: parentId,
        description: workspaceDesc,
        createdAt: DateTime.now().toUtc(),
      );

      // STUB
      when(mockWorkspaceRepo.create(any, any, any)).thenAnswer(
        (_) async => expectedWorkspace,
      );

      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, any, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: userId,
                workspaceId: parentId,
                role: WorkspaceRole.admin,
                joinedAt: DateTime.now().toUtc(),
                isActive: false,
              ));

      // ACT & ASSERT
      expect(
          () => workspaceService.createChild(
                mockSession,
                workspaceName,
                userId,
                parentId,
                workspaceDesc,
              ),
          throwsA(isA<PermissionDeniedException>()));
    });

    test(
        'Should return PermissionDeniedException because action is above member role',
        () async {
      // ARRANGE
      const workspaceName = 'Test Workspace';
      const workspaceDesc = 'A workspace for testing';
      const userId = 1;
      const parentId = 55;
      final expectedWorkspace = Workspace(
        id: 1,
        name: workspaceName,
        parentId: parentId,
        description: workspaceDesc,
        createdAt: DateTime.now().toUtc(),
      );

      // STUB
      when(mockWorkspaceRepo.create(any, any, any)).thenAnswer(
        (_) async => expectedWorkspace,
      );

      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, any, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: userId,
                workspaceId: parentId,
                role: WorkspaceRole.member,
                joinedAt: DateTime.now().toUtc(),
              ));

      // ACT & ASSERT
      expect(
          () => workspaceService.createChild(
                mockSession,
                workspaceName,
                userId,
                parentId,
                workspaceDesc,
              ),
          throwsA(isA<PermissionDeniedException>()));
    });

    test(
        'Should return NotFoundException because parent workspace doesnt exist',
        () async {
      // ARRANGE
      const workspaceName = 'Test Workspace';
      const workspaceDesc = 'A workspace for testing';
      const userId = 1;
      const parentId = 55;
      final expectedWorkspace = Workspace(
        id: 1,
        name: workspaceName,
        parentId: parentId,
        description: workspaceDesc,
        createdAt: DateTime.now().toUtc(),
      );

      // STUB
      when(mockWorkspaceRepo.create(any, any, any)).thenAnswer(
        (_) async => expectedWorkspace,
      );

      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, any, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: userId,
                workspaceId: parentId,
                role: WorkspaceRole.admin,
                joinedAt: DateTime.now().toUtc(),
              ));

      when(mockWorkspaceRepo.findWorkspaceById(any, parentId))
          .thenAnswer((_) async => null);

      // ACT & ASSERT
      expect(
          () => workspaceService.createChild(
                mockSession,
                workspaceName,
                userId,
                parentId,
                workspaceDesc,
              ),
          throwsA(isA<NotFoundException>()));
    });

    test(
        'Should return InvalidStateException because workspace is a child of another workspace',
        () async {
      // ARRANGE
      const workspaceName = 'Test Workspace';
      const workspaceDesc = 'A workspace for testing';
      const userId = 1;
      const parentId = 55;
      final expectedWorkspace = Workspace(
        id: 1,
        name: workspaceName,
        parentId: parentId,
        description: workspaceDesc,
        createdAt: DateTime.now().toUtc(),
      );

      // STUB
      when(mockWorkspaceRepo.create(any, any, any)).thenAnswer(
        (_) async => expectedWorkspace,
      );

      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, any, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: userId,
                workspaceId: parentId,
                role: WorkspaceRole.admin,
                joinedAt: DateTime.now().toUtc(),
              ));

      when(mockWorkspaceRepo.findWorkspaceById(any, any))
          .thenAnswer((_) async => Workspace(
                name: 'Parent Workspace',
                id: parentId,
                parentId: 88,
                description: 'Parent workspace description',
                createdAt: DateTime.now().toUtc(),
              ));

      // ACT & ASSERT
      expect(
          () => workspaceService.createChild(
                mockSession,
                workspaceName,
                userId,
                parentId,
                workspaceDesc,
              ),
          throwsA(isA<InvalidStateException>()));
    });
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
      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, actorId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: actorId,
                workspaceId: workspaceId,
                role: WorkspaceRole.admin,
                joinedAt: DateTime.now().toUtc(),
              ));

      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, memberId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: memberId,
                workspaceId: workspaceId,
                role: WorkspaceRole.member,
                joinedAt: DateTime.now().toUtc(),
              ));

      when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .thenAnswer((_) async => expectedWorkspace);

      // ACT
      await workspaceService.updateMemberRole(
        mockSession,
        memberId: memberId,
        workspaceId: workspaceId,
        role: WorkspaceRole.admin,
        actorId: actorId,
      );

      // ASSERT
      verify(mockWorkspaceRepo.updateMemberRole(
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
      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, actorId, any))
          .thenAnswer((_) async => null);

      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, memberId, any))
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
        () => workspaceService.updateMemberRole(
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
      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, actorId, any))
          .thenAnswer((_) async => WorkspaceMember(
              userInfoId: actorId,
              workspaceId: workspaceId,
              role: WorkspaceRole.admin,
              joinedAt: DateTime.now().toUtc(),
              isActive: false));

      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, memberId, any))
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
        () => workspaceService.updateMemberRole(
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
      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, actorId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: actorId,
                workspaceId: workspaceId,
                role: WorkspaceRole.admin,
                joinedAt: DateTime.now().toUtc(),
              ));

      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, memberId, any))
          .thenAnswer((_) async => null);

      when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .thenAnswer((_) async => expectedWorkspace);

      // ACT
      expect(
        () => workspaceService.updateMemberRole(
          mockSession,
          memberId: memberId,
          workspaceId: workspaceId,
          role: WorkspaceRole.admin,
          actorId: actorId,
        ),
        throwsA(isA<NotFoundException>()),
      );
    });

    test('Throws InvvalidStateException because member is inactive', () async {
      // ARRANGE
      expectedWorkspace = Workspace(
        id: workspaceId,
        name: workspaceName,
        description: workspaceDesc,
        createdAt: DateTime.now().toUtc(),
      );

      // STUB
      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, actorId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: actorId,
                workspaceId: workspaceId,
                role: WorkspaceRole.admin,
                joinedAt: DateTime.now().toUtc(),
              ));

      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, memberId, any))
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
        () => workspaceService.updateMemberRole(
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
      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, actorId, any))
          .thenAnswer((_) async => WorkspaceMember(
              userInfoId: actorId,
              workspaceId: workspaceId,
              role: WorkspaceRole.owner,
              joinedAt: DateTime.now().toUtc(),
              isActive: false));

      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, memberId, any))
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
        () => workspaceService.updateMemberRole(
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
        'Tests the rolepolicy conditional, should throw PermissionDeniedException for all',
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

        when(mockWorkspaceRepo.findMemberByWorkspaceId(any, actorId, any))
            .thenAnswer((_) async => WorkspaceMember(
                  userInfoId: actorId,
                  workspaceId: workspaceId,
                  role: WorkspaceRole.member, // Actor is just a member
                  joinedAt: DateTime.now().toUtc(),
                  isActive: true,
                ));

        when(mockWorkspaceRepo.findMemberByWorkspaceId(any, memberId, any))
            .thenAnswer((_) async => WorkspaceMember(
                  userInfoId: memberId,
                  workspaceId: workspaceId,
                  role: WorkspaceRole.viewer, // Target is a viewer
                  joinedAt: DateTime.now().toUtc(),
                  isActive: true,
                ));

        // ACT & ASSERT
        expect(
          () => workspaceService.updateMemberRole(
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

        when(mockWorkspaceRepo.findMemberByWorkspaceId(any, actorId, any))
            .thenAnswer((_) async => WorkspaceMember(
                  userInfoId: actorId,
                  workspaceId: workspaceId,
                  role: WorkspaceRole.member, // Actor is just a member
                  joinedAt: DateTime.now().toUtc(),
                  isActive: true,
                ));

        when(mockWorkspaceRepo.findMemberByWorkspaceId(any, memberId, any))
            .thenAnswer((_) async => WorkspaceMember(
                  userInfoId: memberId,
                  workspaceId: workspaceId,
                  role: WorkspaceRole.member, // Target is a viewer
                  joinedAt: DateTime.now().toUtc(),
                  isActive: true,
                ));

        // ACT & ASSERT
        expect(
          () => workspaceService.updateMemberRole(
            mockSession,
            memberId: memberId,
            workspaceId: workspaceId,
            role: WorkspaceRole.member, // Trying to promote to admin
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

        when(mockWorkspaceRepo.findMemberByWorkspaceId(any, actorId, any))
            .thenAnswer((_) async => WorkspaceMember(
                  userInfoId: actorId,
                  workspaceId: workspaceId,
                  role: WorkspaceRole.admin, // Actor is just a member
                  joinedAt: DateTime.now().toUtc(),
                  isActive: true,
                ));

        when(mockWorkspaceRepo.findMemberByWorkspaceId(any, memberId, any))
            .thenAnswer((_) async => WorkspaceMember(
                  userInfoId: memberId,
                  workspaceId: workspaceId,
                  role: WorkspaceRole.owner, // Target is a viewer
                  joinedAt: DateTime.now().toUtc(),
                  isActive: true,
                ));

        // ACT & ASSERT
        expect(
          () => workspaceService.updateMemberRole(
            mockSession,
            memberId: memberId,
            workspaceId: workspaceId,
            role: WorkspaceRole.member, // Trying to promote to admin
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

      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, actorId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: actorId,
                workspaceId: workspaceId,
                role: WorkspaceRole.admin,
                joinedAt: DateTime.now().toUtc(),
              ));

      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, memberId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: memberId,
                workspaceId: workspaceId,
                role: WorkspaceRole.member,
                joinedAt: DateTime.now().toUtc(),
              ));

      await workspaceService.removeMember(
        mockSession,
        actorId: actorId,
        memberId: memberId,
        workspaceId: workspaceId,
      );

      verify(mockWorkspaceRepo.deactivateMember(
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

      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, actorId, any))
          .thenAnswer((_) async => null);

      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, memberId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: memberId,
                workspaceId: workspaceId,
                role: WorkspaceRole.member,
                joinedAt: DateTime.now().toUtc(),
              ));

      expect(
        () => workspaceService.removeMember(
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

      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, actorId, any))
          .thenAnswer((_) async => WorkspaceMember(
              userInfoId: actorId,
              workspaceId: workspaceId,
              role: WorkspaceRole.owner,
              joinedAt: DateTime.now().toUtc(),
              isActive: false));

      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, memberId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: memberId,
                workspaceId: workspaceId,
                role: WorkspaceRole.member,
                joinedAt: DateTime.now().toUtc(),
              ));

      expect(
        () => workspaceService.removeMember(
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

      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, actorId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: actorId,
                workspaceId: workspaceId,
                role: WorkspaceRole.owner,
                joinedAt: DateTime.now().toUtc(),
              ));

      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, memberId, any))
          .thenAnswer((_) async => null);

      expect(
        () => workspaceService.removeMember(
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

      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, actorId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: actorId,
                workspaceId: workspaceId,
                role: WorkspaceRole.owner,
                joinedAt: DateTime.now().toUtc(),
              ));

      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, actorId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: actorId,
                workspaceId: workspaceId,
                role: WorkspaceRole.member,
                joinedAt: DateTime.now().toUtc(),
              ));

      expect(
        () => workspaceService.removeMember(
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

      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, actorId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: actorId,
                workspaceId: workspaceId,
                role: WorkspaceRole.member,
                joinedAt: DateTime.now().toUtc(),
              ));

      when(mockWorkspaceRepo.findMemberByWorkspaceId(any, actorId, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: actorId,
                workspaceId: workspaceId,
                role: WorkspaceRole.member,
                joinedAt: DateTime.now().toUtc(),
              ));

      expect(
        () => workspaceService.removeMember(
          mockSession,
          memberId: actorId,
          workspaceId: workspaceId,
          actorId: actorId,
        ),
        throwsA(isA<PermissionDeniedException>()),
      );
    });

    group('inviteMember', () {
      late String workspaceName;
      late int workspaceId;
      late String workspaceDesc;
      late Workspace expectedWorkspace;
      late int actorId;
      late int memberId;
      late String email;

      setUp(() {
        workspaceName = 'Test Workspace';
        workspaceDesc = 'A workspace for testing';
        actorId = 1;
        memberId = 2;
        email = "user@gmail.com";
        workspaceId = 55;
        expectedWorkspace = Workspace(
          id: workspaceId,
          name: workspaceName,
          description: workspaceDesc,
          createdAt: DateTime.now().toUtc(),
        );
      });

      // Happy Path
      /*test('Should invite a member to the workspace', () async {
        // STUB
        when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
            .thenAnswer((_) async => expectedWorkspace);

        when(
          mockWorkspaceRepo.findMemberByWorkspaceId(
            mockSession,
            actorId,
            workspaceId,
          ),
        ).thenAnswer(
          (_) async => WorkspaceMember(
            userInfoId: actorId,
            workspaceId: workspaceId,
            role: WorkspaceRole.owner,
            joinedAt: DateTime.now().toUtc(),
          ),
        );

        when(mockWorkspaceRepo.findMemberByEmail(
                mockSession, email, workspaceId))
            .thenAnswer((_) async => null);
        
        when (WorkspaceInvitation.db.findFirstRow(mockSession, email, workspaceId))
      });*/
    });
  });
}
