import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/modules/ledger/usecase/ledger_service.dart';
import 'package:hololine_server/src/utils/exceptions.dart';
import 'package:mockito/mockito.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

import '../../../../mocks.mocks.dart';

void main() {
  late MockLedgerRepo mockLedgerRepo;
  late MockLedgerLineItemRepo mockLineItemRepo;
  late MockCatalogRepo mockCatalogRepo;
  late MockInventoryRepo mockInventoryRepo;
  late MockMemberRepo mockMemberRepo;
  late MockSession mockSession;
  late MockDatabase mockDb;
  late LedgerService ledgerService;

  setUp(() {
    mockLedgerRepo = MockLedgerRepo();
    mockLineItemRepo = MockLedgerLineItemRepo();
    mockCatalogRepo = MockCatalogRepo();
    mockInventoryRepo = MockInventoryRepo();
    mockMemberRepo = MockMemberRepo();
    mockSession = MockSession();
    mockDb = MockDatabase();

    when(mockSession.db).thenReturn(mockDb);
    when(mockCatalogRepo.getUserInfo(any, any)).thenAnswer((_) async => null);

    ledgerService = LedgerService(
      mockLedgerRepo,
      mockLineItemRepo,
      mockCatalogRepo,
      mockInventoryRepo,
      mockMemberRepo,
    );
  });

  group('LedgerService.createTransaction', () {
    const workspaceId = 1;
    const actorId = 42;

    test('throws InsufficientStockException for sales when stock is low',
        () async {
      // ---- Arrange ----
      final lineItems = [
        LedgerLineItem(
          workspaceId: workspaceId,
          ledgerId: 0,
          catalogId: 101,
          catalogName: 'Expensive Gadget',
          quantity: 10.0,
          unitPrice: 50000,
          unit: 'pcs',
          subtotal: 500000,
          position: 0,
          createdAt: DateTime.now(),
        )
      ];

      // Mock RBAC
      when(mockMemberRepo.findMemberByWorkspaceId(any, actorId, workspaceId))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: actorId,
                workspaceId: workspaceId,
                role: WorkspaceRole.member,
                isActive: true,
                joinedAt: DateTime.now(),
              ));

      // Mock Catalog lookup
      final catalog = Catalog(
        id: 101,
        workspaceId: workspaceId,
        name: 'Expensive Gadget',
        price: 50000,
        unit: 'pcs',
        type: 'product',
        addedByName: 'Admin',
        createdAt: DateTime.now(),
        lastModifiedAt: DateTime.now(),
      );
      when(mockCatalogRepo.findByIds(any, [101], workspaceId))
          .thenAnswer((_) async => [catalog]);

      // Mock Database Transaction
      when(mockDb.transaction<Ledger>(any)).thenAnswer((invocation) async {
        final callback = invocation.positionalArguments[0]
            as Future<Ledger> Function(Transaction);
        return await callback(MockTransaction());
      });

      // Mock Inventory lookup with lock (SELECT FOR UPDATE)
      final inventory = Inventory(
        workspaceId: workspaceId,
        catalogId: 101,
        currentQty: 5.0, // Only 5 in stock
        availableQty: 5.0,
        totalValue: 250000,
        createdAt: DateTime.now(),
        lastModifiedAt: DateTime.now(),
      );
      when(mockInventoryRepo.findByCatalogIdForUpdate(any, 101, workspaceId, any))
          .thenAnswer((_) async => inventory);

      // ---- Act & Assert ----
      expect(
        () => ledgerService.createTransaction(
          mockSession,
          workspaceId: workspaceId,
          actorId: actorId,
          lineItems: lineItems,
          transactionType: TransactionType.sale,
          paymentStatus: PaymentStatus.paid,
          transactionAt: DateTime.now(),
        ),
        throwsA(isA<InsufficientStockException>()),
      );
    });

    test('successfully creates a sale and updates inventory', () async {
      // ---- Arrange ----
      final lineItems = [
        LedgerLineItem(
          workspaceId: workspaceId,
          ledgerId: 0,
          catalogId: 101,
          catalogName: 'Widget',
          quantity: 2.0,
          unitPrice: 1000,
          unit: 'pcs',
          subtotal: 2000,
          position: 0,
          createdAt: DateTime.now(),
        )
      ];

      when(mockMemberRepo.findMemberByWorkspaceId(any, actorId, workspaceId))
          .thenAnswer((_) async => WorkspaceMember(
                userInfoId: actorId,
                workspaceId: workspaceId,
                role: WorkspaceRole.member,
                isActive: true,
                joinedAt: DateTime.now(),
              ));

      final catalog = Catalog(
        id: 101,
        workspaceId: workspaceId,
        name: 'Widget',
        price: 1000,
        unit: 'pcs',
        currency: 'NGN',
        type: 'product',
        addedByName: 'Admin',
        createdAt: DateTime.now(),
        lastModifiedAt: DateTime.now(),
      );
      when(mockCatalogRepo.findByIds(any, [101], workspaceId))
          .thenAnswer((_) async => [catalog]);

      when(mockDb.transaction<Ledger>(any)).thenAnswer((invocation) async {
        final callback = invocation.positionalArguments[0]
            as Future<Ledger> Function(Transaction);
        return await callback(MockTransaction());
      });

      final inventory = Inventory(
        workspaceId: workspaceId,
        catalogId: 101,
        currentQty: 10.0,
        availableQty: 10.0,
        totalValue: 10000,
        createdAt: DateTime.now(),
        lastModifiedAt: DateTime.now(),
      );
      when(mockInventoryRepo.findByCatalogIdForUpdate(any, 101, workspaceId, any))
          .thenAnswer((_) async => inventory);

      when(mockLedgerRepo.insertWithTransaction(any, any, any))
          .thenAnswer((inv) async => (inv.positionalArguments[1] as Ledger).copyWith(id: 1));

      when(mockLedgerRepo.updateWithTransaction(any, any, any))
          .thenAnswer((inv) async => inv.positionalArguments[1] as Ledger);

      when(mockLineItemRepo.insertManyWithTransaction(any, any, any))
          .thenAnswer((inv) async => inv.positionalArguments[1] as List<LedgerLineItem>);

      when(mockInventoryRepo.update(any, any, transaction: anyNamed('transaction')))
          .thenAnswer((inv) async => inv.positionalArguments[1] as Inventory);

      // ---- Act ----
      final result = await ledgerService.createTransaction(
        mockSession,
        workspaceId: workspaceId,
        actorId: actorId,
        lineItems: lineItems,
        transactionType: TransactionType.sale,
        paymentStatus: PaymentStatus.paid,
        transactionAt: DateTime.now(),
      );

      // ---- Assert ----
      expect(result.id, 1);
      expect(result.totalAmount, 2000); // 1000 * 2
      
      // Verify line items were inserted
      verify(mockLineItemRepo.insertManyWithTransaction(any, any, any)).called(1);
      
      // Verify inventory was updated (10 - 2 = 8)
      verify(mockInventoryRepo.update(
        any,
        argThat(predicate<Inventory>((inv) => inv.currentQty == 8.0 && inv.totalValue == 8000)),
        transaction: anyNamed('transaction'),
      )).called(1);
    });
  });
}
