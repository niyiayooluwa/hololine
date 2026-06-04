import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/modules/inventory/usecase/inventory_service.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../mocks.mocks.dart';

void main() {
  late MockInventoryRepo mockInventoryRepo;
  late MockMemberRepo mockMemberRepo;
  late MockSession mockSession;
  late InventoryService inventoryService;

  setUp(() {
    mockInventoryRepo = MockInventoryRepo();
    mockMemberRepo = MockMemberRepo();
    mockSession = MockSession();

    inventoryService = InventoryService(
      mockInventoryRepo,
      mockMemberRepo,
    );
  });

  group('InventoryService', () {
    const workspaceId = 1;
    const actorId = 42;

    test('listInventory calls repo after permission check', () async {
      when(mockMemberRepo.findMemberByWorkspaceId(any, actorId, workspaceId))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: actorId,
                workspaceId: workspaceId,
                role: WorkspaceRole.member,
                isActive: true,
                joinedAt: DateTime.now(),
              ));

      when(mockInventoryRepo.listWithCatalog(any, workspaceId,
              includeDiscontinued: false))
          .thenAnswer((_) async => []);

      final result = await inventoryService.listInventory(
        mockSession,
        workspaceId: workspaceId,
        actorId: actorId,
      );

      expect(result, isEmpty);
      verify(mockInventoryRepo.listWithCatalog(any, workspaceId,
              includeDiscontinued: false))
          .called(1);
    });

    test('getLowStockItems calls repo after permission check', () async {
      when(mockMemberRepo.findMemberByWorkspaceId(any, actorId, workspaceId))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: actorId,
                workspaceId: workspaceId,
                role: WorkspaceRole.member,
                isActive: true,
                joinedAt: DateTime.now(),
              ));

      when(mockInventoryRepo.getLowStockWithCatalog(any, workspaceId))
          .thenAnswer((_) async => []);

      final result = await inventoryService.getLowStockItems(
        mockSession,
        workspaceId: workspaceId,
        actorId: actorId,
      );

      expect(result, isEmpty);
      verify(mockInventoryRepo.getLowStockWithCatalog(any, workspaceId))
          .called(1);
    });

    test('updateThreshold updates record when exists and actor has permission',
        () async {
      when(mockMemberRepo.findMemberByWorkspaceId(any, actorId, workspaceId))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: actorId,
                workspaceId: workspaceId,
                role: WorkspaceRole.admin,
                isActive: true,
                joinedAt: DateTime.now(),
              ));

      final existingInv = Inventory(
        id: 10,
        workspaceId: workspaceId,
        catalogId: 5,
        currentQty: 10.0,
        availableQty: 10.0,
        totalValue: 1000,
        createdAt: DateTime.now(),
        lastModifiedAt: DateTime.now(),
      );

      when(mockInventoryRepo.findByCatalogId(any, 5))
          .thenAnswer((_) async => existingInv);

      // Mock the update call
      when(mockInventoryRepo.update(any, any, transaction: anyNamed('transaction')))
          .thenAnswer((inv) async => inv.positionalArguments[1] as Inventory);

      await inventoryService.updateThreshold(
        mockSession,
        workspaceId: workspaceId,
        catalogId: 5,
        threshold: 2.0,
        actorId: actorId,
      );

      verify(mockInventoryRepo.update(
        any,
        argThat(predicate<Inventory>((inv) => inv.lowStockThreshold == 2.0)),
        transaction: anyNamed('transaction'),
      )).called(1);
    });
  });
}
