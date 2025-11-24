import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/usecase/workspace_service.dart';
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
  });
}
