import 'package:hololine_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

/// Repository responsible for all direct database access on the [Ledger] table.
///
/// Follows the Repository pattern — no business logic lives here.
/// All validation, permission checks, and transaction orchestration belong
/// in [LedgerService].
class LedgerRepo {
  /// Inserts a new [Ledger] record as part of an ongoing [transaction].
  ///
  /// Must be called inside a `session.db.transaction()` block. The caller
  /// is responsible for managing the transaction lifecycle (commit/rollback).
  ///
  /// Returns the inserted [Ledger] with its database-assigned [id] populated.
  Future<Ledger> insertWithTransaction(
    Session session,
    Ledger ledger,
    Transaction transaction,
  ) async {
    return await Ledger.db.insertRow(session, ledger, transaction: transaction);
  }

  /// Updates an existing [Ledger] record within a [transaction].
  ///
  /// Used to write back the computed `totalAmount` after line items are created.
  Future<Ledger> updateWithTransaction(
    Session session,
    Ledger ledger,
    Transaction transaction,
  ) async {
    return await Ledger.db.updateRow(session, ledger, transaction: transaction);
  }

  /// Finds a [Ledger] record by its primary key [ledgerId].
  ///
  /// Returns `null` if no record exists with the given [ledgerId].
  /// Does not include [LedgerLineItem]s — fetch those separately via
  /// [LedgerLineItemRepo.findByLedgerId].
  Future<Ledger?> findById(Session session, int ledgerId) async {
    return await Ledger.db.findById(session, ledgerId);
  }

  /// Finds a [Ledger] by its primary key and eagerly loads its
  /// [LedgerLineItem]s via the declared `ledger_line_items` relation,
  /// ordered by [LedgerLineItem.position] ascending.
  ///
  /// Returns `null` if no record exists with the given [ledgerId].
  /// Prefer this over [findById] when the caller needs line items
  /// alongside the ledger header (e.g. [getTransaction]).
  Future<Ledger?> findByIdWithLineItems(Session session, int ledgerId) async {
    return await Ledger.db.findById(
      session,
      ledgerId,
      include: Ledger.include(
        lineItems: LedgerLineItem.includeList(
          orderBy: (t) => t.position,
          orderDescending: false,
        ),
      ),
    );
  }

  /// Returns a list of [Ledger] records for the given [workspaceId],
  /// sorted by [Ledger.transactionAt] descending (most recent first).
  ///
  /// All filters are optional and composed additively (AND logic):
  /// - [transactionType]: Restricts results to a single [TransactionType].
  /// - [from]: Only includes records where [transactionAt] >= [from].
  /// - [to]: Only includes records where [transactionAt] <= [to].
  ///
  /// Always scoped to [workspaceId] — cross-workspace queries are not permitted.
  Future<List<Ledger>> list(
    Session session,
    int workspaceId, {
    TransactionType? transactionType,
    DateTime? from,
    DateTime? to,
  }) async {
    return await Ledger.db.find(
      session,
      where: (t) {
        var expr = t.workspaceId.equals(workspaceId);
        if (transactionType != null) {
          expr = expr & t.transactionType.equals(transactionType);
        }
        if (from != null) {
          expr = expr & (t.transactionAt >= from);
        }
        if (to != null) {
          expr = expr & (t.transactionAt <= to);
        }
        return expr;
      },
      orderBy: (t) => t.transactionAt,
      orderDescending: true,
    );
  }
}
