import 'package:hololine_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

/// Repository for performing persistence and query operations related to
/// Workspace and WorkspaceMember entities.
///
/// Provides higher-level methods that encapsulate common database patterns
/// (for example, transactional creation of a workspace together with its
/// owner member) so callers do not need to manipulate raw ORM calls
/// directly.
class WorkspaceRepo {

  /// Finds the first workspace with the given [name] in which the user with
  /// id [userId] is a member with the owner role.
  ///
  /// - [session]: The active Serverpod session used to execute the query.
  /// - [name]: The workspace name to match.
  /// - [userId]: The id of the user that must be an owner member of the
  ///   workspace.
  /// 
  /// Returns a [Future] that completes with the matching [Workspace], or `null`
  /// if no matching workspace is found. The underlying query checks that a
  /// workspace's members contain an entry with `userInfoId == userId` and
  /// `role == WorkspaceRole.owner`.
  Future<Workspace?> findByNameAndOwner(
    Session session,
    String name,
    int userId,
  ) async {
    return Workspace.db.findFirstRow(
      session,
      where: (workspace) {
        var nameMatch = workspace.name.equals(name);
        var ownerMatch = workspace.members.any((member) =>
            member.userInfoId.equals(userId) &
            member.role.equals(WorkspaceRole.owner));
        return nameMatch & ownerMatch;
      },
    );
  }

  /// Creates a new workspace and inserts an owner member for it within a single
  /// database transaction.
  ///
  /// - [session]: The active Serverpod session used to execute the transaction.
  /// - [workspace]: The [Workspace] instance to insert (its id will be populated
  ///   after insertion).
  /// - [ownerId]: The user id that should be added as the owner member for the
  ///   newly created workspace.
  ///
  /// The method performs the following steps in one transaction:
  /// 1. Insert the provided [workspace] into the database.
  /// 2. Create and insert a [WorkspaceMember] for [ownerId] with
  ///    `role == WorkspaceRole.owner`, `joinedAt` set to the current UTC time,
  ///    and `isActive == true`, referencing the newly inserted workspace id.
  /// 
  /// Returns a [Future] that completes with the inserted [Workspace] (including
  /// its database-generated id). If any database operation fails, the
  /// transaction is rolled back and the error is propagated to the caller.
  Future<Workspace> create(
    Session session,
    Workspace workspace,
    int ownerId,
  ) async {
    return await session.db.transaction((transaction) async {
      var insertedWorkspace = await Workspace.db.insertRow(
        session,
        workspace,
        transaction: transaction,
      );

      var newOwner = WorkspaceMember(
          userInfoId: ownerId,
          workspaceId: insertedWorkspace.id!,
          role: WorkspaceRole.owner,
          joinedAt: DateTime.now().toUtc(),
          isActive: true);

      await WorkspaceMember.db.insertRow(
        session,
        newOwner,
        transaction: transaction,
      );

      return insertedWorkspace;
    });
  }
}
