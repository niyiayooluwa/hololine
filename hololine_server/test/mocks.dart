import 'package:hololine_server/src/modules/workspace/repositories/repositories.dart';
import 'package:hololine_server/src/modules/workspace/usecase/services.dart';
import 'package:mockito/annotations.dart';
import 'package:serverpod/serverpod.dart';

@GenerateMocks([
  WorkspaceService,
  MemberService,
  InvitationService,
  WorkspaceRepo,
  MemberRepo,
  InvitationRepo,
  Session,
])
void main() {}
