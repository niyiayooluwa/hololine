import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/modules/workspace/usecase/services.dart';
import 'package:hololine_server/src/utils/exceptions.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import '../../../../mocks.mocks.dart';

void main() {
  late MockWorkspaceRepo mockWorkspaceRepo;
  late MockMemberRepo mockMemberRepo;
  late WorkspaceService workspaceService;
  late MockSession mockSession;

  setUp(() {
    // Create fresh instances for each test.
    mockWorkspaceRepo = MockWorkspaceRepo();
    mockMemberRepo = MockMemberRepo();
    mockSession = MockSession();

    workspaceService = WorkspaceService(
      mockMemberRepo,
      mockWorkspaceRepo,
    );
  });

  group('createStandalone', () {
    test('should return a new workspace when called with valid data', () async {
      // ARRANGE
      const workspaceName = 'Test Workspace';
      const workspaceDesc = 'A workspace for testing';
      const userId = 1;
      final expectedWorkspace = Workspace(
        id: 1,
        name: workspaceName,
        description: workspaceDesc,
        createdAt: DateTime.now().toUtc(),
      );

      // Stub the behavior on the CORE repository.
      when(mockWorkspaceRepo.create(any, any, any)).thenAnswer(
        (_) async => expectedWorkspace,
      );

      // ACT
      final result = await workspaceService.createStandalone(
        mockSession,
        workspaceName,
        userId,
        workspaceDesc,
      );

      // ASSERT
      expect(result, equals(expectedWorkspace));
      verify(mockWorkspaceRepo.create(any, any, any)).called(1);
    });

    test('should throw an exception if the repository fails', () async {
      // ARRANGE
      final exception = Exception('Database connection failed');
      when(mockWorkspaceRepo.create(any, any, any)).thenThrow(exception);

      // ACT & ASSERT
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

      when(mockMemberRepo.findMemberByWorkspaceId(any, any, any)).thenAnswer(
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

      when(mockMemberRepo.findMemberByWorkspaceId(any, any, any))
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

      when(mockMemberRepo.findMemberByWorkspaceId(any, any, any))
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

      when(mockMemberRepo.findMemberByWorkspaceId(any, any, any))
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

      when(mockMemberRepo.findMemberByWorkspaceId(any, any, any))
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

      when(mockMemberRepo.findMemberByWorkspaceId(any, any, any))
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

  group('archiveWorkspace', () {
    late String workspaceName;
    late int workspaceId;
    late String workspaceDesc;
    late Workspace expectedWorkspace;
    late int actorId;

    setUp(() {
      workspaceName = 'Test Workspace';
      workspaceDesc = 'A workspace for testing';
      actorId = 1;
      workspaceId = 55;
      expectedWorkspace = Workspace(
        id: workspaceId,
        name: workspaceName,
        description: workspaceDesc,
        createdAt: DateTime.now().toUtc(),
      );
    });

    // Happy Path
    test('Should archive the workspace', () async {
      when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .thenAnswer((_) async => expectedWorkspace);

      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, actorId, workspaceId))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: actorId,
                workspaceId: workspaceId,
                role: WorkspaceRole.owner,
                joinedAt: DateTime.now().toUtc(),
              ));

      when(mockWorkspaceRepo.archiveWorkspace(mockSession, workspaceId))
          .thenAnswer((_) async => true);

      await workspaceService.archiveWorkspace(
        mockSession,
        workspaceId,
        actorId,
      );

      verify(mockWorkspaceRepo.archiveWorkspace(
        mockSession,
        workspaceId,
      )).called(1);
    });

    test('Should return PermissionDeniedException beacause actor is null',
        () async {
      when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .thenAnswer((_) async => expectedWorkspace);

      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, actorId, workspaceId))
          .thenAnswer((_) async => null);

      when(mockWorkspaceRepo.archiveWorkspace(mockSession, workspaceId))
          .thenAnswer((_) async => true);

      expect(
        () async => await workspaceService.archiveWorkspace(
          mockSession,
          workspaceId,
          actorId,
        ),
        throwsA(isA<PermissionDeniedException>()),
      );
    });

    test('Should return NotFoundException beacause workspace is null',
        () async {
      when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .thenAnswer((_) async => null);

      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, actorId, workspaceId))
          .thenAnswer(
        (_) async => WorkspaceMember(
          userInfoId: actorId,
          workspaceId: workspaceId,
          role: WorkspaceRole.owner,
          joinedAt: DateTime.now().toUtc(),
        ),
      );

      when(mockWorkspaceRepo.archiveWorkspace(mockSession, workspaceId))
          .thenAnswer((_) async => true);

      expect(
        () async => await workspaceService.archiveWorkspace(
          mockSession,
          workspaceId,
          actorId,
        ),
        throwsA(isA<NotFoundException>()),
      );
    });
  });

  group('restoreWorkspace', () {
    late String workspaceName;
    late int workspaceId;
    late String workspaceDesc;
    late Workspace expectedWorkspace;
    late int actorId;

    setUp(() {
      workspaceName = 'Test Workspace';
      workspaceDesc = 'A workspace for testing';
      actorId = 1;
      workspaceId = 55;
      expectedWorkspace = Workspace(
          id: workspaceId,
          name: workspaceName,
          description: workspaceDesc,
          createdAt: DateTime.now().toUtc(),
          archivedAt: DateTime.now().toUtc().add(Duration(milliseconds: 1)));
    });

    // Happy Path
    test('Should restore an archived workspace', () async {
      when(mockMemberRepo.findMemberByWorkspaceId(any, any, any))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: actorId,
                workspaceId: workspaceId,
                role: WorkspaceRole.owner,
                joinedAt: DateTime.now().toUtc(),
              ));

      when(mockWorkspaceRepo.findWorkspaceById(any, any))
          .thenAnswer((_) async => expectedWorkspace);

      when(mockWorkspaceRepo.restoreWorkspace(any, any))
          .thenAnswer((_) async => true);

      await workspaceService.restoreWorkspace(
        mockSession,
        workspaceId,
        actorId,
      );

      verify(mockWorkspaceRepo.restoreWorkspace(
        mockSession,
        workspaceId,
      )).called(1);
    });

    test('Should return NotFoundException beacause workspace is null',
        () async {
      when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .thenAnswer((_) async => null);

      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, actorId, workspaceId))
          .thenAnswer(
        (_) async => WorkspaceMember(
          userInfoId: actorId,
          workspaceId: workspaceId,
          role: WorkspaceRole.owner,
          joinedAt: DateTime.now().toUtc(),
        ),
      );

      when(mockWorkspaceRepo.restoreWorkspace(mockSession, workspaceId))
          .thenAnswer((_) async => true);

      expect(
        () async => await workspaceService.restoreWorkspace(
          mockSession,
          workspaceId,
          actorId,
        ),
        throwsA(isA<NotFoundException>()),
      );
    });

    test(
        'Should return InvalidStateException beacause workspace is not archived',
        () async {
      when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .thenAnswer((_) async => Workspace(
                id: workspaceId,
                name: workspaceName,
                description: workspaceDesc,
                createdAt: DateTime.now().toUtc(),
              ));

      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, actorId, workspaceId))
          .thenAnswer(
        (_) async => WorkspaceMember(
          userInfoId: actorId,
          workspaceId: workspaceId,
          role: WorkspaceRole.owner,
          joinedAt: DateTime.now().toUtc(),
        ),
      );

      when(mockWorkspaceRepo.restoreWorkspace(mockSession, workspaceId))
          .thenAnswer((_) async => true);

      expect(
        () async => await workspaceService.restoreWorkspace(
          mockSession,
          workspaceId,
          actorId,
        ),
        throwsA(isA<InvalidStateException>()),
      );
    });

    test('Should return PermissionDeniedException beacause actor is null',
        () async {
      when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .thenAnswer((_) async => expectedWorkspace);

      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, actorId, workspaceId))
          .thenAnswer((_) async => null);

      when(mockWorkspaceRepo.restoreWorkspace(mockSession, workspaceId))
          .thenAnswer((_) async => true);

      expect(
        () async => await workspaceService.restoreWorkspace(
          mockSession,
          workspaceId,
          actorId,
        ),
        throwsA(isA<PermissionDeniedException>()),
      );
    });

    test(
        'Should return PermissionDeniedException beacause actor has insufficient role',
        () async {
      when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .thenAnswer((_) async => expectedWorkspace);

      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, actorId, workspaceId))
          .thenAnswer(
        (_) async => WorkspaceMember(
          userInfoId: actorId,
          workspaceId: workspaceId,
          role: WorkspaceRole.admin,
          joinedAt: DateTime.now().toUtc(),
        ),
      );

      when(mockWorkspaceRepo.restoreWorkspace(mockSession, workspaceId))
          .thenAnswer((_) async => true);

      expect(
        () async => await workspaceService.restoreWorkspace(
          mockSession,
          workspaceId,
          actorId,
        ),
        throwsA(isA<PermissionDeniedException>()),
      );
    });
  });

  group('transferOwnership', () {
    late String workspaceName;
    late int workspaceId;
    late String workspaceDesc;
    late Workspace expectedWorkspace;
    late int actorId;
    late int memberId;
    late WorkspaceMember actorMember;
    late WorkspaceMember targetMember;

    setUp(() {
      // Common test data
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
        // archivedAt: null, // Assuming not archived for ownership transfer
      );

      // Common member data
      actorMember = WorkspaceMember(
        userInfoId: actorId,
        workspaceId: workspaceId,
        role: WorkspaceRole.owner,
        joinedAt: DateTime.now().toUtc(),
        isActive: true,
      );

      targetMember = WorkspaceMember(
        userInfoId: memberId,
        workspaceId: workspaceId,
        role: WorkspaceRole.admin,
        joinedAt: DateTime.now().toUtc(),
        isActive: true,
      );

      when(mockMemberRepo.transferOwnership(
              mockSession, workspaceId, actorId, memberId))
          .thenAnswer((_) async => true);

      // Stub findWorkspaceById for the initial check
      when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .thenAnswer((_) async => expectedWorkspace);
    });

    // Happy Path
    test('Should successfully transfer ownership of the workspace', () async {
      // ARRANGE
      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, actorId, workspaceId))
          .thenAnswer((_) async => actorMember);

      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, memberId, workspaceId))
          .thenAnswer((_) async => targetMember);

      // ACT
      await workspaceService.transferOwnership(
        mockSession,
        workspaceId,
        memberId, // newOwnerId
        actorId, // actorId
      );

      // ASSERT
      // Verify that the workspace was found (implicitly checked by not throwing NotFoundException)
      verify(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .called(1);

      // Verify that the actor and target member were found
      verify(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, actorId, workspaceId))
          .called(1);

      verify(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, memberId, workspaceId))
          .called(1);

      // Verify that the transaction was initiated
      verify(mockMemberRepo.transferOwnership(
              mockSession, workspaceId, actorId, memberId))
          .called(1);
    });

    // Unhappy Paths
    test('Should throw PermissionDeniedException if actor is not a member',
        () async {
      // ARRANGE
      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, actorId, workspaceId))
          .thenAnswer((_) async => null); // Actor is not a member

      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, memberId, workspaceId))
          .thenAnswer((_) async => targetMember);

      // ACT & ASSERT
      expect(
        () => workspaceService.transferOwnership(
          mockSession,
          workspaceId,
          memberId,
          actorId,
        ),
        throwsA(isA<PermissionDeniedException>()),
      );
    });

    test('Should throw NotFoundException if target member is not found',
        () async {
      // ARRANGE
      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, actorId, workspaceId))
          .thenAnswer((_) async => actorMember);

      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, memberId, workspaceId))
          .thenAnswer((_) async => null); // Target member not found

      // ACT & ASSERT
      expect(
        () => workspaceService.transferOwnership(
          mockSession,
          workspaceId,
          memberId,
          actorId,
        ),
        throwsA(isA<NotFoundException>()),
      );
    });

    test(
        'Should throw PermissionDeniedException if actor membership is inactive',
        () async {
      // ARRANGE
      final inactiveActorMember = WorkspaceMember(
        userInfoId: actorId,
        workspaceId: workspaceId,
        role: WorkspaceRole.owner,
        joinedAt: DateTime.now().toUtc(),
        isActive: false, // Inactive
      );

      // STUB
      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, actorId, workspaceId))
          .thenAnswer((_) async => inactiveActorMember);

      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, memberId, workspaceId))
          .thenAnswer((_) async => targetMember);

      // ACT & ASSERT
      expect(
        () => workspaceService.transferOwnership(
          mockSession,
          workspaceId,
          memberId,
          actorId,
        ),
        throwsA(isA<PermissionDeniedException>()),
      );
    });

    test('Should throw InvalidStateException if target member is inactive',
        () async {
      // ARRANGE
      final inactiveTargetMember = WorkspaceMember(
        userInfoId: memberId,
        workspaceId: workspaceId,
        role: WorkspaceRole.admin,
        joinedAt: DateTime.now().toUtc(),
        isActive: false, // Inactive
      );
      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, actorId, workspaceId))
          .thenAnswer((_) async => actorMember);

      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, memberId, workspaceId))
          .thenAnswer((_) async => inactiveTargetMember);

      // ACT & ASSERT
      expect(
        () => workspaceService.transferOwnership(
          mockSession,
          workspaceId,
          memberId,
          actorId,
        ),
        throwsA(isA<InvalidStateException>()),
      );
    });

    test(
        'Should throw PermissionDeniedException if actor does not have ownership role',
        () async {
      // ARRANGE
      final nonOwnerActorMember = WorkspaceMember(
        userInfoId: actorId,
        workspaceId: workspaceId,
        role: WorkspaceRole.admin, // Insufficient role
        joinedAt: DateTime.now().toUtc(),
        isActive: true,
      );
      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, actorId, workspaceId))
          .thenAnswer((_) async => nonOwnerActorMember);

      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, memberId, workspaceId))
          .thenAnswer((_) async => targetMember);

      // ACT & ASSERT
      expect(
        () => workspaceService.transferOwnership(
          mockSession,
          workspaceId,
          memberId,
          actorId,
        ),
        throwsA(isA<PermissionDeniedException>()),
      );
    });

    test(
        'Should throw PermissionDeniedException if actor attempts to transfer to self',
        () async {
      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, actorId, workspaceId))
          .thenAnswer((_) async => actorMember);

      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, actorId, workspaceId))
          .thenAnswer((_) async => null);
      // ACT & ASSERT
      expect(
        () => workspaceService.transferOwnership(
          mockSession,
          workspaceId,
          actorId, // newOwnerId is the same as actorId
          actorId,
        ),
        throwsA(isA<PermissionDeniedException>()),
      );
    });

    test('Should throw exception if transaction fails', () async {
      // ARRANGE
      final transactionException = Exception('Database transaction failed');
      // Mock the transaction to throw an exception
      when(mockMemberRepo.transferOwnership(
              mockSession, workspaceId, actorId, memberId))
          .thenThrow(transactionException);

      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, actorId, workspaceId))
          .thenAnswer((_) async => actorMember);

      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, memberId, workspaceId))
          .thenAnswer((_) async => targetMember);

      // ACT & ASSERT
      expect(
        () => workspaceService.transferOwnership(
          mockSession,
          workspaceId,
          memberId,
          actorId,
        ),
        throwsA(transactionException),
      );
    });

    test('Should handle when transferOwnership returns false', () async {
      // ARRANGE
      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, actorId, workspaceId))
          .thenAnswer((_) async => actorMember);

      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, memberId, workspaceId))
          .thenAnswer((_) async => targetMember);

      when(mockMemberRepo.transferOwnership(
              mockSession, workspaceId, actorId, memberId))
          .thenAnswer((_) async => false);

      // ACT & ASSERT
      expect(
        () => workspaceService.transferOwnership(
          mockSession,
          workspaceId,
          memberId,
          actorId,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('tinitiateDeleteWorkspace', () {
    late String workspaceName;
    late int workspaceId;
    late String workspaceDesc;
    late Workspace expectedWorkspace;
    late int actorId;
    late int memberId;
    late WorkspaceMember actorMember;
    late WorkspaceMember targetMember;

    setUp(() {
      // Common test data
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
        // archivedAt: null, // Assuming not archived for ownership transfer
      );

      // Common member data
      actorMember = WorkspaceMember(
        userInfoId: actorId,
        workspaceId: workspaceId,
        role: WorkspaceRole.owner,
        joinedAt: DateTime.now().toUtc(),
        isActive: true,
      );

      targetMember = WorkspaceMember(
        userInfoId: memberId,
        workspaceId: workspaceId,
        role: WorkspaceRole.admin,
        joinedAt: DateTime.now().toUtc(),
        isActive: true,
      );

      when(mockWorkspaceRepo.softDeleteWorkspace(mockSession, workspaceId))
          .thenAnswer((_) async => true);

      // Stub findWorkspaceById for the initial check
      when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .thenAnswer((_) async => expectedWorkspace);
    });

    // Happy Path
    test('Should successfully mark the workspace for deletion', () async {
      // ARRANGE
      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, actorId, workspaceId))
          .thenAnswer((_) async => actorMember);

      // ACT
      await workspaceService.initiateDeleteWorkspace(
        mockSession,
        workspaceId,
        actorId, // actorId
      );

      // ASSERT
      // Verify that the workspace was found (implicitly checked by not throwing NotFoundException)
      verify(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .called(1);

      // Verify that the actor and target member were found
      verify(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, actorId, workspaceId))
          .called(1);

      // Verify that the transaction was initiated
      verify(mockWorkspaceRepo.softDeleteWorkspace(mockSession, workspaceId))
          .called(1);
    });

    // Unhappy Paths
    test('Should throw PermissionDeniedException if actor is not a member',
        () async {
      // ARRANGE
      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, actorId, workspaceId))
          .thenAnswer((_) async => null); // Actor is not a member

      // ACT & ASSERT
      expect(
        () => workspaceService.initiateDeleteWorkspace(
          mockSession,
          workspaceId,
          actorId,
        ),
        throwsA(isA<PermissionDeniedException>()),
      );
    });

    test(
        'Should throw PermissionDeniedException if actor membership is inactive',
        () async {
      // ARRANGE
      final inactiveActorMember = WorkspaceMember(
        userInfoId: actorId,
        workspaceId: workspaceId,
        role: WorkspaceRole.owner,
        joinedAt: DateTime.now().toUtc(),
        isActive: false, // Inactive
      );

      // STUB
      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, actorId, workspaceId))
          .thenAnswer((_) async => inactiveActorMember);

      // ACT & ASSERT
      expect(
        () => workspaceService.initiateDeleteWorkspace(
          mockSession,
          workspaceId,
          actorId,
        ),
        throwsA(isA<PermissionDeniedException>()),
      );
    });

    test(
        'Should throw PermissionDeniedException if actor does not have sufficient priviledge',
        () async {
      // ARRANGE
      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, actorId, workspaceId))
          .thenAnswer((_) async => targetMember);

      // ACT & ASSERT
      expect(
        () => workspaceService.initiateDeleteWorkspace(
          mockSession,
          workspaceId,
          actorId,
        ),
        throwsA(isA<PermissionDeniedException>()),
      );
    });

    test('Should throw NotFoundException if workspace doesnt exist', () async {
      when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .thenAnswer((_) async => null);

      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, actorId, workspaceId))
          .thenAnswer((_) async => actorMember);

      // ACT & ASSERT
      expect(
        () => workspaceService.initiateDeleteWorkspace(
          mockSession,
          workspaceId,
          actorId,
        ),
        throwsA(isA<NotFoundException>()),
      );
    });

    test('Should throw InvalidStateException if workspace is marked as deleted',
        () async {
      when(mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId))
          .thenAnswer((_) async => Workspace(
                name: workspaceName,
                description: workspaceDesc,
                createdAt: DateTime.now().toUtc(),
                pendingDeletionUntil:
                    DateTime.now().toUtc().add(Duration(milliseconds: 1)),
                deletedAt:
                    DateTime.now().toUtc().add(Duration(milliseconds: 2)),
              ));

      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, actorId, workspaceId))
          .thenAnswer((_) async => actorMember);

      // ACT & ASSERT
      expect(
        () => workspaceService.initiateDeleteWorkspace(
          mockSession,
          workspaceId,
          actorId,
        ),
        throwsA(isA<InvalidStateException>()),
      );
    });

    test(
        'Should throw InvalidStateException if workspace is already pending deletion',
        () async {
      when(
        mockWorkspaceRepo.findWorkspaceById(mockSession, workspaceId),
      ).thenAnswer(
        (_) async => Workspace(
          name: workspaceName,
          description: workspaceDesc,
          createdAt: DateTime.now().toUtc(),
          pendingDeletionUntil:
              DateTime.now().toUtc().add(Duration(milliseconds: 1)),
        ),
      );

      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, actorId, workspaceId))
          .thenAnswer((_) async => actorMember);

      // ACT & ASSERT
      expect(
        () => workspaceService.initiateDeleteWorkspace(
          mockSession,
          workspaceId,
          actorId,
        ),
        throwsA(isA<InvalidStateException>()),
      );
    });

    test('Should throw exception if transaction fails', () async {
      // ARRANGE
      final transactionException = Exception('Database transaction failed');
      // Mock the transaction to throw an exception
      when(mockWorkspaceRepo.softDeleteWorkspace(mockSession, workspaceId))
          .thenThrow(transactionException);

      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, actorId, workspaceId))
          .thenAnswer((_) async => actorMember);

      // ACT & ASSERT
      expect(
        () => workspaceService.initiateDeleteWorkspace(
          mockSession,
          workspaceId,
          actorId,
        ),
        throwsA(transactionException),
      );
    });

    test('Should handle when softDeleteWorkspace returns false', () async {
      // ARRANGE
      when(mockMemberRepo.findMemberByWorkspaceId(
              mockSession, actorId, workspaceId))
          .thenAnswer((_) async => actorMember);

      when(mockWorkspaceRepo.softDeleteWorkspace(mockSession, workspaceId))
          .thenAnswer((_) async => false);

      when(mockMemberRepo.transferOwnership(
              mockSession, workspaceId, actorId, memberId))
          .thenAnswer((_) async => false);

      // ACT & ASSERT
      expect(
        () => workspaceService.initiateDeleteWorkspace(
          mockSession,
          workspaceId,
          actorId,
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
