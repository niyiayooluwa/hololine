import 'package:hololine_server/src/generated/protocol.dart';
import 'package:hololine_server/src/modules/workspace/repositories/repositories.dart';
import 'package:hololine_server/src/modules/workspace/usecase/services.dart';
import 'package:hololine_server/src/modules/catalog/repositories/catalog_repo.dart';
import 'package:hololine_server/src/modules/catalog/repositories/inventory_repo.dart';
import 'package:hololine_server/src/modules/catalog/usecase/catalog_service.dart';
import 'package:hololine_server/src/utils/authenticated_endpoint.dart';
import 'package:serverpod/serverpod.dart';

/// Endpoint for managing the core workspace lifecycle (creation, updates, deletion).
class WorkspaceEndpoint extends AuthenticatedEndpoint {
  final WorkspaceRepo _coreWorkspaceRepo = WorkspaceRepo();
  final MemberRepo _memberRepo = MemberRepo();
  final CatalogRepo _catalogRepo = CatalogRepo();
  final InventoryRepo _inventoryRepo = InventoryRepo();

  late final WorkspaceService _workspaceService = WorkspaceService(
    _memberRepo,
    _coreWorkspaceRepo,
  );

  late final CatalogService _catalogService =
      CatalogService(_catalogRepo, _inventoryRepo, _memberRepo);

  // ===========================================================================
  // CREATION
  // ===========================================================================

  /// Creates a new standalone workspace.
  Future<Workspace> createStandalone(
      Session session, String name, String description) async {
    return runAuthenticated(session, 'createStandalone', (userId) async {
      return await _workspaceService.createStandalone(
          session, name, userId, description);
    });
  }

  /// Creates a new child workspace under a parent.
  Future<Workspace> createChild(
    Session session,
    String name,
    int parentWorkspaceId,
    String description,
  ) async {
    return runAuthenticated(session, 'createChild', (userId) async {
      return await _workspaceService.createChild(
        session,
        name,
        userId,
        parentWorkspaceId,
        description,
      );
    });
  }

  // ===========================================================================
  // READ OPERATIONS
  // ===========================================================================

  /// Returns full details for a single workspace by its public ID.
  Future<Workspace> getWorkspaceDetails(
    Session session, {
    required String publicId,
  }) async {
    return runAuthenticated(session, 'getWorkspaceDetails', (userId) async {
      return await _workspaceService.getWorkspaceDetails(
        session,
        publicId,
        userId,
      );
    });
  }

  /// Returns an aggregated dashboard view for a workspace, including member info
  /// and a catalog snapshot.
  Future<WorkspaceDashboardData> getDashboardData(
    Session session, {
    required String publicId,
  }) async {
    return runAuthenticated(session, 'getDashboardData', (userId) async {
      // 1. Get workspace details
      final workspace = await _workspaceService.getWorkspaceDetails(
        session,
        publicId,
        userId,
      );

      // 2. Get rich member info
      final members = await _memberRepo.findMembersWithUserInfoByWorkspaceId(
        session,
        workspace.id!,
      );

      // 3. Get catalog snapshot
      final catalog = await _catalogService.getCatalogSnapshot(
        session,
        workspace.id!,
      );

      return WorkspaceDashboardData(
        workspace: workspace,
        members: members,
        catalog: catalog,
      );
    });
  }

  /// Returns a list of child workspaces for a given parent.
  Future<List<Workspace>> getChildWorkspaces(
    Session session, {
    required int parentWorkspaceId,
  }) async {
    return runAuthenticated(session, 'getChildWorkspaces', (userId) async {
      return await _workspaceService.getChildWorkspaces(
        session,
        parentWorkspaceId,
        userId,
      );
    });
  }

  // ===========================================================================
  // UPDATE / ARCHIVE / DELETE
  // ===========================================================================

  /// Updates the name and description of a workspace.
  Future<Workspace> updateWorkspaceDetails(
    Session session, {
    required int workspaceId,
    String? name,
    String? description,
  }) async {
    return runAuthenticated(session, 'updateWorkspaceDetails', (userId) async {
      return await _workspaceService.updateWorkspaceDetails(
          session, workspaceId, name, description, userId);
    });
  }

  /// Archives a workspace.
  Future<Workspace> archiveWorkspace(
    Session session,
    int workspaceId,
  ) async {
    return runAuthenticated(session, 'archiveWorkspace', (userId) async {
      return await _workspaceService.archiveWorkspace(
          session, workspaceId, userId);
    });
  }

  /// Restores a previously archived workspace.
  Future<Workspace> restoreWorkspace(
    Session session,
    int workspaceId,
  ) async {
    return runAuthenticated(session, 'restoreWorkspace', (userId) async {
      return await _workspaceService.restoreWorkspace(
          session, workspaceId, userId);
    });
  }

  /// Transfers ownership of the workspace to another member.
  Future<bool> transferOwnership(
    Session session,
    int workspaceId,
    int newOwnerId,
  ) async {
    return runAuthenticated(session, 'transferOwnership', (userId) async {
      await _workspaceService.transferOwnership(
          session, workspaceId, newOwnerId, userId);
      return true;
    });
  }

  /// Marks a workspace for deletion after a grace period.
  Future<Workspace> initiateDeleteWorkspace(
    Session session,
    int workspaceId,
  ) async {
    return runAuthenticated(session, 'initiateDeleteWorkspace', (userId) async {
      return await _workspaceService.initiateDeleteWorkspace(
          session, workspaceId, userId);
    });
  }
}
