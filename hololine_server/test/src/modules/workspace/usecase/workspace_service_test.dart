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
}
