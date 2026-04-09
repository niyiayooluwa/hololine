import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/modules/catalog/usecase/catalog_service.dart';
import 'package:mockito/mockito.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart';
import 'package:test/test.dart';

import '../../../../mocks.mocks.dart';

void main() {
  late MockCatalogRepo mockCatalogRepo;
  late MockInventoryRepo mockInventoryRepo;
  late MockMemberRepo mockMemberRepo;
  late MockSession mockSession;
  late CatalogService catalogService;

  setUp(() {
    mockCatalogRepo = MockCatalogRepo();
    mockMemberRepo = MockMemberRepo();
    mockInventoryRepo = MockInventoryRepo();
    mockSession = MockSession();

    catalogService = CatalogService(
      mockCatalogRepo,
      mockInventoryRepo,
      mockMemberRepo,
    );
  });

  group('createProduct', () {
    test('createProduct creates catalog + initial inventory', () async {
      // ---- Arrange ---------------------------------------------------
      const workspaceId = 1;
      const actorId = 42;
      final catalogData = Catalog(
        name: 'Test Widget',
        price: 1999,
        unit: 'pcs',
        sku: 'TW-001',
        workspaceId: workspaceId,
        type: '',
        addedByName: '',
        createdAt: DateTime.now().toUtc(),
        lastModifiedAt: DateTime.now().toUtc(),
      );
      // Mock member permission check (mockMemberRepo returns a valid member)
      when(mockMemberRepo.findMemberByWorkspaceId(
        any,
        actorId,
        workspaceId,
      )).thenAnswer((_) async => WorkspaceMember(
            userInfoId: actorId,
            workspaceId: workspaceId,
            role: WorkspaceRole.admin,
            joinedAt: DateTime.now().toUtc(),
          ));

      // Mock SKU uniqueness
      when(mockCatalogRepo.isSkuTaken(any, 'TW-001', workspaceId))
          .thenAnswer((_) async => false);

      // Mock userInfo lookup
      when(mockCatalogRepo.getUserInfo(any, actorId))
          .thenAnswer((_) async => UserInfo(
                userName: 'Alice',
                userIdentifier: '',
                created: DateTime.now().toUtc(),
                scopeNames: [],
                blocked: false,
              ));

      // Mock insert – return the same object with an ID
      when(mockCatalogRepo.insertWithTransaction(any, any, any))
          .thenAnswer((invocation) async {
        final Catalog toInsert = invocation.positionalArguments[1] as Catalog;
        return toInsert.copyWith(id: 100);
      });

      // Mock inventory insert – just complete
      when(mockInventoryRepo.insert(any, any, transaction: any)).thenAnswer(
          (_) async => Inventory(
              workspaceId: workspaceId,
              catalogId: 2,
              currentQty: 2,
              availableQty: 2,
              totalValue: 2,
              createdAt: DateTime.now(),
              lastModifiedAt: DateTime.now()));

      final result = await catalogService.createProduct(
        mockSession,
        workspaceId: workspaceId,
        catalogData: catalogData,
        actorId: actorId,
      );

      // ---- Assert ----------------------------------------------------
      expect(result.id, 100);
      expect(result.addedById, actorId);
      expect(result.status, 'active');

      // Verify that the inventory insert was called once
      verify(() => mockInventoryRepo.insert(any, any, transaction: any))
          .called(1);
    });

    // -----------------------------------------------------------------
    // 2️⃣ updateProduct – price change triggers inventory value update
    // -----------------------------------------------------------------
    test('updateProduct updates inventory totalValue when price changes',
        () async {
      const workspaceId = 1;
      const actorId = 42;
      const catalogId = 100;
      // Existing catalog row
      final existing = Catalog(
        id: catalogId,
        workspaceId: workspaceId,
        name: 'Widget',
        price: 1000,
        unit: 'pcs',
        status: 'active',
        type: '',
        addedByName: '',
        createdAt: DateTime.now(),
        lastModifiedAt: DateTime.now(),
      );
      // Existing inventory row
      final existingInv = Inventory(
        id: 1,
        workspaceId: workspaceId,
        catalogId: catalogId,
        currentQty: 5,
        totalValue: 5000, availableQty: 5, createdAt: DateTime.now(),
        lastModifiedAt: DateTime.now(), // 5 * 1000
      );
      // Mock permission
      when(mockMemberRepo.findMemberByWorkspaceId(any, actorId, workspaceId))
          .thenAnswer((_) async => WorkspaceMember(
              userInfoId: actorId,
              workspaceId: workspaceId,
              role: WorkspaceRole.admin,
              isActive: true,
              joinedAt: DateTime.now()));
      // Mock fetches
      when(mockCatalogRepo.findById(any, catalogId))
          .thenAnswer((_) async => existing);
      when(mockInventoryRepo.findByCatalogId(any, catalogId))
          .thenAnswer((_) async => existingInv);
      // Mock update – just return the passed catalog
      when(mockCatalogRepo.update(any, any, transaction: any))
          .thenAnswer((inv) async => inv.positionalArguments[1] as Catalog);
      // Mock inventory update
      when(mockInventoryRepo.update(any, any, transaction: any)).thenAnswer(
          (_) async => Inventory(
              workspaceId: workspaceId,
              catalogId: catalogId,
              currentQty: 5,
              availableQty: 5,
              totalValue: 500,
              createdAt: DateTime.now(),
              lastModifiedAt: DateTime.now()));
      // Act
      final updated = await catalogService.updateProduct(
        mockSession,
        workspaceId: workspaceId,
        catalogId: catalogId,
        catalogUpdates: CatalogUpdateParams(price: 1500), // price ↑
        inventoryUpdates: InventoryUpdateParams(),
        actorId: actorId,
      );
      // Assert catalog price changed
      expect(updated.price, 1500);
      // Verify inventory totalValue was recomputed (5 * 1500 = 7500)
      verify(mockInventoryRepo.update(
        any,
        argThat(predicate<Inventory>((inv) => inv.totalValue == 7500)),
        transaction: any,
      )).called(1);
    });
  });
}
