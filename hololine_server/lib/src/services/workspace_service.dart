import 'package:hololine_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';
import 'package:hololine_server/src/repositories/workspace_repository.dart';

class WorkspaceService {
  final WorkspaceRepo _workspaceRepository = WorkspaceRepo();

  Future<Workspace> createStandalone(
    Session session,
    String name,
    int userId,
  ) async {
    var existing =
        await _workspaceRepository.findByNameAndOwner(session, name, userId);

    if (existing != null) {
      throw Exception('A worksapce with the name "$name" already exists');
    }

    var newWorksapce = Workspace(
      name: name,
      createdAt: DateTime.now().toUtc(),
    );

    return await _workspaceRepository.create(
      session,
      newWorksapce,
      userId,
    );
  }
}
