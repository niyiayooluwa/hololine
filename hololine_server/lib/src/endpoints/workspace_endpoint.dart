import 'package:hololine_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

class WorkspaceEndpoint extends Endpoint {
  // Protect every method in this group
  @override
  bool get requireLogin => true;

  /// Create a new standalone workspace and makes the caller the owner.
  Future<Workspace> createStandalone(Session session, String name) async {
    var userId = (await session.authenticated)?.userId;

    // --- CHECK FOR DUPLICATE NAME ---
    // This query finds a workspace if, and only if, a workspace with the same
    // name already exists AND is owned by the current user.
    var existing = await Workspace.db.findFirstRow(
      session,
      where: (w) {
        // Condition 1: THe worksapce name must match
        var nameMatch = w.name.equals(name);

        // Condition 2: The workspace must be owned byt the current user.
        // This is checked by looking at the members of theworkspace.
        // 'w.members' is a list of all members linked to that workspace.
        // '.any()' checks if any item in that list meets our condition.
        var ownerMatch = w.members.any((m) =>
            m.userInfoId.equals(userId) & m.role.equals(WorkspaceRole.owner));

        // Return a worspace only if BOTH conditions are true
        return nameMatch & ownerMatch;
      },
    );

    // If we found an existing workspace with that name, stop here.
    if (existing != null) {
      throw Exception('A workspace with the name "$name" already exists.');
    }
    // --- END OF CHECK ---

    // Two seperate database writes are to be performed (inserting a workspace AND
    // a member). To achieve this and ensure data integrity, they are to be wrapped
    // in a transaction
    var createdWorkspace = await session.db.transaction((transaction) async {
      //Step 1: Create the Workspace object
      var newWorkspace = Workspace(
        name: name,
        createdAt: DateTime.now().toUtc(),
      );

      // Insert the new workspace row and get the result.
      var insertedWorkspace = await Workspace.db.insertRow(
        session,
        newWorkspace,
        transaction: transaction,
      );

      // Step 2: Create the WorkspaceMember link to make the user the owner
      var newOwner = WorkspaceMember(
        userInfoId: userId!,
        workspaceId: insertedWorkspace.id!,
        role: WorkspaceRole.owner,
        joinedAt: DateTime.now().toUtc(),
        isActive: true,
      );

      // Insert the new member row.
      await WorkspaceMember.db.insertRow(
        session,
        newOwner,
        transaction: transaction,
      );

      return insertedWorkspace;
    });
    return createdWorkspace;
  }
}
