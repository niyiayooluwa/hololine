import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/utils/exceptions.dart';
import 'package:hololine_server/src/utils/permissions.dart';
import 'package:serverpod/server.dart';
import '../../catalog/repositories/inventory_repo.dart';
import '../../workspace/repositories/member_repo.dart';

/// Service that provides operations related to inventory levels and management.
class InventoryService {
  final InventoryRepo _inventoryRepository;
  final MemberRepo _memberRepository;

  InventoryService(this._inventoryRepository, this._memberRepository);

  /// Validates actor is an active workspace member with sufficient role.
  Future<WorkspaceMember> _assertMemberPermissions(
    Session session,
    int actorId,
    int workspaceId,
    bool Function(WorkspaceRole) permissionCheck,
  ) async {
    final member = await _memberRepository.findMemberByWorkspaceId(
      session,
      actorId,
      workspaceId,
    );

    if (member == null || !member.isActive) {
      throw PermissionDeniedException('User is not an active member of this workspace.');
    }

    if (!permissionCheck(member.role)) {
      throw PermissionDeniedException('Insufficient privileges for this action.');
    }

    return member;
  }

  /// Lists inventory for a workspace, joined with catalog data.
  /// Only includes active products unless [includeDiscontinued] is true.
  Future<List<Inventory>> listInventory(
    Session session, {
    required int workspaceId,
    required int actorId,
    bool includeDiscontinued = false,
  }) async {
    await _assertMemberPermissions(
      session,
      actorId,
      workspaceId,
      RolePolicy.canViewProducts,
    );

    return await _inventoryRepository.listWithCatalog(
      session,
      workspaceId,
      includeDiscontinued: includeDiscontinued,
    );
  }

  /// Lists inventory items that are at or below their low stock threshold.
  Future<List<Inventory>> getLowStockItems(
    Session session, {
    required int workspaceId,
    required int actorId,
  }) async {
    await _assertMemberPermissions(
      session,
      actorId,
      workspaceId,
      RolePolicy.canViewProducts,
    );

    return await _inventoryRepository.getLowStockWithCatalog(session, workspaceId);
  }

  /// Updates the low stock threshold for a product.
  Future<void> updateThreshold(
    Session session, {
    required int workspaceId,
    required int catalogId,
    required double? threshold,
    required int actorId,
  }) async {
    await _assertMemberPermissions(
      session,
      actorId,
      workspaceId,
      RolePolicy.canEditProduct,
    );

    final inventory = await _inventoryRepository.findByCatalogId(session, catalogId);
    if (inventory == null || inventory.workspaceId != workspaceId) {
      throw NotFoundException('Inventory record not found.');
    }

    final updatedInventory = inventory.copyWith(
      lowStockThreshold: threshold,
      lastModifiedAt: DateTime.now(),
    );

    await _inventoryRepository.update(session, updatedInventory);
  }
}
