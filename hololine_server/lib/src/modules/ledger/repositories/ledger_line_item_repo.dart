import 'package:hololine_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

/// Repository responsible for all direct database access on the [LedgerLineItem] table.
///
/// [LedgerLineItem] records are always created in bulk as part of a [Ledger]
/// transaction and are never mutated after creation — they represent an
/// immutable snapshot of a product's price and quantity at the time of the
/// transaction.
class LedgerLineItemRepo {
  /// Inserts all [items] in a single batch as part of an ongoing [transaction].
  ///
  /// This is an atomic batch operation — if one row fails to insert, none of
  /// the rows will be inserted (guaranteed by the enclosing transaction).
  ///
  /// Must be called inside a `session.db.transaction()` block.
  /// Returns the inserted list with each item's database-assigned [id] populated.
  Future<List<LedgerLineItem>> insertManyWithTransaction(
    Session session,
    List<LedgerLineItem> items,
    Transaction transaction,
  ) async {
    return await LedgerLineItem.db.insert(session, items, transaction: transaction);
  }

  /// Returns all [LedgerLineItem] records belonging to the given [ledgerId],
  /// ordered by [LedgerLineItem.position] ascending (preserving insertion order).
  ///
  /// Returns an empty list if no line items exist for the ledger.
  Future<List<LedgerLineItem>> findByLedgerId(Session session, int ledgerId) async {
    return await LedgerLineItem.db.find(
      session,
      where: (t) => t.ledgerId.equals(ledgerId),
      orderBy: (t) => t.position,
      orderDescending: false,
    );
  }
}
