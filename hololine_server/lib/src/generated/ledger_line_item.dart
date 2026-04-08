/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'ledger.dart' as _i2;

abstract class LedgerLineItem
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  LedgerLineItem._({
    this.id,
    required this.workspaceId,
    required this.ledgerId,
    this.ledger,
    required this.catalogId,
    required this.catalogName,
    this.catalogSku,
    required this.unitPrice,
    required this.quantity,
    required this.unit,
    String? currency,
    required this.subtotal,
    int? position,
    required this.createdAt,
  })  : currency = currency ?? 'NGN',
        position = position ?? 0;

  factory LedgerLineItem({
    int? id,
    required int workspaceId,
    required int ledgerId,
    _i2.Ledger? ledger,
    required int catalogId,
    required String catalogName,
    String? catalogSku,
    required int unitPrice,
    required double quantity,
    required String unit,
    String? currency,
    required int subtotal,
    int? position,
    required DateTime createdAt,
  }) = _LedgerLineItemImpl;

  factory LedgerLineItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return LedgerLineItem(
      id: jsonSerialization['id'] as int?,
      workspaceId: jsonSerialization['workspaceId'] as int,
      ledgerId: jsonSerialization['ledgerId'] as int,
      ledger: jsonSerialization['ledger'] == null
          ? null
          : _i2.Ledger.fromJson(
              (jsonSerialization['ledger'] as Map<String, dynamic>)),
      catalogId: jsonSerialization['catalogId'] as int,
      catalogName: jsonSerialization['catalogName'] as String,
      catalogSku: jsonSerialization['catalogSku'] as String?,
      unitPrice: jsonSerialization['unitPrice'] as int,
      quantity: (jsonSerialization['quantity'] as num).toDouble(),
      unit: jsonSerialization['unit'] as String,
      currency: jsonSerialization['currency'] as String,
      subtotal: jsonSerialization['subtotal'] as int,
      position: jsonSerialization['position'] as int,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = LedgerLineItemTable();

  static const db = LedgerLineItemRepository._();

  @override
  int? id;

  int workspaceId;

  int ledgerId;

  _i2.Ledger? ledger;

  int catalogId;

  String catalogName;

  String? catalogSku;

  int unitPrice;

  double quantity;

  String unit;

  String currency;

  int subtotal;

  int position;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [LedgerLineItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LedgerLineItem copyWith({
    int? id,
    int? workspaceId,
    int? ledgerId,
    _i2.Ledger? ledger,
    int? catalogId,
    String? catalogName,
    String? catalogSku,
    int? unitPrice,
    double? quantity,
    String? unit,
    String? currency,
    int? subtotal,
    int? position,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'workspaceId': workspaceId,
      'ledgerId': ledgerId,
      if (ledger != null) 'ledger': ledger?.toJson(),
      'catalogId': catalogId,
      'catalogName': catalogName,
      if (catalogSku != null) 'catalogSku': catalogSku,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'unit': unit,
      'currency': currency,
      'subtotal': subtotal,
      'position': position,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'workspaceId': workspaceId,
      'ledgerId': ledgerId,
      if (ledger != null) 'ledger': ledger?.toJsonForProtocol(),
      'catalogId': catalogId,
      'catalogName': catalogName,
      if (catalogSku != null) 'catalogSku': catalogSku,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'unit': unit,
      'currency': currency,
      'subtotal': subtotal,
      'position': position,
      'createdAt': createdAt.toJson(),
    };
  }

  static LedgerLineItemInclude include({_i2.LedgerInclude? ledger}) {
    return LedgerLineItemInclude._(ledger: ledger);
  }

  static LedgerLineItemIncludeList includeList({
    _i1.WhereExpressionBuilder<LedgerLineItemTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LedgerLineItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LedgerLineItemTable>? orderByList,
    LedgerLineItemInclude? include,
  }) {
    return LedgerLineItemIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(LedgerLineItem.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(LedgerLineItem.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LedgerLineItemImpl extends LedgerLineItem {
  _LedgerLineItemImpl({
    int? id,
    required int workspaceId,
    required int ledgerId,
    _i2.Ledger? ledger,
    required int catalogId,
    required String catalogName,
    String? catalogSku,
    required int unitPrice,
    required double quantity,
    required String unit,
    String? currency,
    required int subtotal,
    int? position,
    required DateTime createdAt,
  }) : super._(
          id: id,
          workspaceId: workspaceId,
          ledgerId: ledgerId,
          ledger: ledger,
          catalogId: catalogId,
          catalogName: catalogName,
          catalogSku: catalogSku,
          unitPrice: unitPrice,
          quantity: quantity,
          unit: unit,
          currency: currency,
          subtotal: subtotal,
          position: position,
          createdAt: createdAt,
        );

  /// Returns a shallow copy of this [LedgerLineItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LedgerLineItem copyWith({
    Object? id = _Undefined,
    int? workspaceId,
    int? ledgerId,
    Object? ledger = _Undefined,
    int? catalogId,
    String? catalogName,
    Object? catalogSku = _Undefined,
    int? unitPrice,
    double? quantity,
    String? unit,
    String? currency,
    int? subtotal,
    int? position,
    DateTime? createdAt,
  }) {
    return LedgerLineItem(
      id: id is int? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      ledgerId: ledgerId ?? this.ledgerId,
      ledger: ledger is _i2.Ledger? ? ledger : this.ledger?.copyWith(),
      catalogId: catalogId ?? this.catalogId,
      catalogName: catalogName ?? this.catalogName,
      catalogSku: catalogSku is String? ? catalogSku : this.catalogSku,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      currency: currency ?? this.currency,
      subtotal: subtotal ?? this.subtotal,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class LedgerLineItemTable extends _i1.Table<int?> {
  LedgerLineItemTable({super.tableRelation})
      : super(tableName: 'ledger_line_item') {
    workspaceId = _i1.ColumnInt(
      'workspaceId',
      this,
    );
    ledgerId = _i1.ColumnInt(
      'ledgerId',
      this,
    );
    catalogId = _i1.ColumnInt(
      'catalogId',
      this,
    );
    catalogName = _i1.ColumnString(
      'catalogName',
      this,
    );
    catalogSku = _i1.ColumnString(
      'catalogSku',
      this,
    );
    unitPrice = _i1.ColumnInt(
      'unitPrice',
      this,
    );
    quantity = _i1.ColumnDouble(
      'quantity',
      this,
    );
    unit = _i1.ColumnString(
      'unit',
      this,
    );
    currency = _i1.ColumnString(
      'currency',
      this,
      hasDefault: true,
    );
    subtotal = _i1.ColumnInt(
      'subtotal',
      this,
    );
    position = _i1.ColumnInt(
      'position',
      this,
      hasDefault: true,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final _i1.ColumnInt workspaceId;

  late final _i1.ColumnInt ledgerId;

  _i2.LedgerTable? _ledger;

  late final _i1.ColumnInt catalogId;

  late final _i1.ColumnString catalogName;

  late final _i1.ColumnString catalogSku;

  late final _i1.ColumnInt unitPrice;

  late final _i1.ColumnDouble quantity;

  late final _i1.ColumnString unit;

  late final _i1.ColumnString currency;

  late final _i1.ColumnInt subtotal;

  late final _i1.ColumnInt position;

  late final _i1.ColumnDateTime createdAt;

  _i2.LedgerTable get ledger {
    if (_ledger != null) return _ledger!;
    _ledger = _i1.createRelationTable(
      relationFieldName: 'ledger',
      field: LedgerLineItem.t.ledgerId,
      foreignField: _i2.Ledger.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.LedgerTable(tableRelation: foreignTableRelation),
    );
    return _ledger!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        workspaceId,
        ledgerId,
        catalogId,
        catalogName,
        catalogSku,
        unitPrice,
        quantity,
        unit,
        currency,
        subtotal,
        position,
        createdAt,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'ledger') {
      return ledger;
    }
    return null;
  }
}

class LedgerLineItemInclude extends _i1.IncludeObject {
  LedgerLineItemInclude._({_i2.LedgerInclude? ledger}) {
    _ledger = ledger;
  }

  _i2.LedgerInclude? _ledger;

  @override
  Map<String, _i1.Include?> get includes => {'ledger': _ledger};

  @override
  _i1.Table<int?> get table => LedgerLineItem.t;
}

class LedgerLineItemIncludeList extends _i1.IncludeList {
  LedgerLineItemIncludeList._({
    _i1.WhereExpressionBuilder<LedgerLineItemTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(LedgerLineItem.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => LedgerLineItem.t;
}

class LedgerLineItemRepository {
  const LedgerLineItemRepository._();

  final attachRow = const LedgerLineItemAttachRowRepository._();

  /// Returns a list of [LedgerLineItem]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<LedgerLineItem>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LedgerLineItemTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LedgerLineItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LedgerLineItemTable>? orderByList,
    _i1.Transaction? transaction,
    LedgerLineItemInclude? include,
  }) async {
    return session.db.find<LedgerLineItem>(
      where: where?.call(LedgerLineItem.t),
      orderBy: orderBy?.call(LedgerLineItem.t),
      orderByList: orderByList?.call(LedgerLineItem.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [LedgerLineItem] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<LedgerLineItem?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LedgerLineItemTable>? where,
    int? offset,
    _i1.OrderByBuilder<LedgerLineItemTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LedgerLineItemTable>? orderByList,
    _i1.Transaction? transaction,
    LedgerLineItemInclude? include,
  }) async {
    return session.db.findFirstRow<LedgerLineItem>(
      where: where?.call(LedgerLineItem.t),
      orderBy: orderBy?.call(LedgerLineItem.t),
      orderByList: orderByList?.call(LedgerLineItem.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [LedgerLineItem] by its [id] or null if no such row exists.
  Future<LedgerLineItem?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    LedgerLineItemInclude? include,
  }) async {
    return session.db.findById<LedgerLineItem>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [LedgerLineItem]s in the list and returns the inserted rows.
  ///
  /// The returned [LedgerLineItem]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<LedgerLineItem>> insert(
    _i1.Session session,
    List<LedgerLineItem> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<LedgerLineItem>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [LedgerLineItem] and returns the inserted row.
  ///
  /// The returned [LedgerLineItem] will have its `id` field set.
  Future<LedgerLineItem> insertRow(
    _i1.Session session,
    LedgerLineItem row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<LedgerLineItem>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [LedgerLineItem]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<LedgerLineItem>> update(
    _i1.Session session,
    List<LedgerLineItem> rows, {
    _i1.ColumnSelections<LedgerLineItemTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<LedgerLineItem>(
      rows,
      columns: columns?.call(LedgerLineItem.t),
      transaction: transaction,
    );
  }

  /// Updates a single [LedgerLineItem]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<LedgerLineItem> updateRow(
    _i1.Session session,
    LedgerLineItem row, {
    _i1.ColumnSelections<LedgerLineItemTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<LedgerLineItem>(
      row,
      columns: columns?.call(LedgerLineItem.t),
      transaction: transaction,
    );
  }

  /// Deletes all [LedgerLineItem]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<LedgerLineItem>> delete(
    _i1.Session session,
    List<LedgerLineItem> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<LedgerLineItem>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [LedgerLineItem].
  Future<LedgerLineItem> deleteRow(
    _i1.Session session,
    LedgerLineItem row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<LedgerLineItem>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<LedgerLineItem>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<LedgerLineItemTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<LedgerLineItem>(
      where: where(LedgerLineItem.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LedgerLineItemTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<LedgerLineItem>(
      where: where?.call(LedgerLineItem.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class LedgerLineItemAttachRowRepository {
  const LedgerLineItemAttachRowRepository._();

  /// Creates a relation between the given [LedgerLineItem] and [Ledger]
  /// by setting the [LedgerLineItem]'s foreign key `ledgerId` to refer to the [Ledger].
  Future<void> ledger(
    _i1.Session session,
    LedgerLineItem ledgerLineItem,
    _i2.Ledger ledger, {
    _i1.Transaction? transaction,
  }) async {
    if (ledgerLineItem.id == null) {
      throw ArgumentError.notNull('ledgerLineItem.id');
    }
    if (ledger.id == null) {
      throw ArgumentError.notNull('ledger.id');
    }

    var $ledgerLineItem = ledgerLineItem.copyWith(ledgerId: ledger.id);
    await session.db.updateRow<LedgerLineItem>(
      $ledgerLineItem,
      columns: [LedgerLineItem.t.ledgerId],
      transaction: transaction,
    );
  }
}
