import 'package:hololine_server/src/modules/catalog/repositories/catalog_repo.dart';
import 'package:hololine_server/src/modules/catalog/repositories/inventory_repo.dart';
import 'package:hololine_server/src/modules/catalog/usecase/catalog_service.dart';
import 'package:hololine_server/src/modules/inventory/usecase/inventory_service.dart';
import 'package:hololine_server/src/modules/ledger/repositories/ledger_repo.dart';
import 'package:hololine_server/src/modules/ledger/usecase/ledger_service.dart';
import 'package:hololine_server/src/modules/workspace/repositories/repositories.dart';
import 'package:hololine_server/src/modules/workspace/usecase/services.dart';
import 'package:hololine_server/src/services/email_service.dart';
import 'package:mockito/annotations.dart';
import 'package:serverpod/serverpod.dart';

@GenerateMocks([
  WorkspaceService,
  MemberService,
  InvitationService,
  CatalogService,
  InventoryService,
  LedgerService,
  WorkspaceRepo,
  MemberRepo,
  InvitationRepo,
  CatalogRepo,
  InventoryRepo,
  LedgerRepo,
  Session,
  EmailHandler
])
void main() {}
