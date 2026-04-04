/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class Ledger implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Ledger._({
    this.id,
    required this.workspaceId,
    this.referenceNumber,
    required this.transactionType,
    required this.paymentStatus,
    required this.totalAmount,
    this.notes,
    required this.transactionAt,
    required this.createdByName,
    this.createdById,
    this.counterpartyName,
    required this.createdAt,
    required this.lastModifiedAt,
  });

  factory Ledger({
    int? id,
    required int workspaceId,
    String? referenceNumber,
    required String transactionType,
    required String paymentStatus,
    required double totalAmount,
    String? notes,
    required DateTime transactionAt,
    required String createdByName,
    int? createdById,
    String? counterpartyName,
    required DateTime createdAt,
    required DateTime lastModifiedAt,
  }) = _LedgerImpl;

  factory Ledger.fromJson(Map<String, dynamic> jsonSerialization) {
    return Ledger(
      id: jsonSerialization['id'] as int?,
      workspaceId: jsonSerialization['workspaceId'] as int,
      referenceNumber: jsonSerialization['referenceNumber'] as String?,
      transactionType: jsonSerialization['transactionType'] as String,
      paymentStatus: jsonSerialization['paymentStatus'] as String,
      totalAmount: (jsonSerialization['totalAmount'] as num).toDouble(),
      notes: jsonSerialization['notes'] as String?,
      transactionAt: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['transactionAt']),
      createdByName: jsonSerialization['createdByName'] as String,
      createdById: jsonSerialization['createdById'] as int?,
      counterpartyName: jsonSerialization['counterpartyName'] as String?,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      lastModifiedAt: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['lastModifiedAt']),
    );
  }

  static final t = LedgerTable();

  static const db = LedgerRepository._();

  @override
  int? id;

  int workspaceId;

  String? referenceNumber;

  String transactionType;

  String paymentStatus;

  double totalAmount;

  String? notes;

  DateTime transactionAt;

  String createdByName;

  int? createdById;

  String? counterpartyName;

  DateTime createdAt;

  DateTime lastModifiedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Ledger]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Ledger copyWith({
    int? id,
    int? workspaceId,
    String? referenceNumber,
    String? transactionType,
    String? paymentStatus,
    double? totalAmount,
    String? notes,
    DateTime? transactionAt,
    String? createdByName,
    int? createdById,
    String? counterpartyName,
    DateTime? createdAt,
    DateTime? lastModifiedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'workspaceId': workspaceId,
      if (referenceNumber != null) 'referenceNumber': referenceNumber,
      'transactionType': transactionType,
      'paymentStatus': paymentStatus,
      'totalAmount': totalAmount,
      if (notes != null) 'notes': notes,
      'transactionAt': transactionAt.toJson(),
      'createdByName': createdByName,
      if (createdById != null) 'createdById': createdById,
      if (counterpartyName != null) 'counterpartyName': counterpartyName,
      'createdAt': createdAt.toJson(),
      'lastModifiedAt': lastModifiedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'workspaceId': workspaceId,
      if (referenceNumber != null) 'referenceNumber': referenceNumber,
      'transactionType': transactionType,
      'paymentStatus': paymentStatus,
      'totalAmount': totalAmount,
      if (notes != null) 'notes': notes,
      'transactionAt': transactionAt.toJson(),
      'createdByName': createdByName,
      if (createdById != null) 'createdById': createdById,
      if (counterpartyName != null) 'counterpartyName': counterpartyName,
      'createdAt': createdAt.toJson(),
      'lastModifiedAt': lastModifiedAt.toJson(),
    };
  }

  static LedgerInclude include() {
    return LedgerInclude._();
  }

  static LedgerIncludeList includeList({
    _i1.WhereExpressionBuilder<LedgerTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LedgerTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LedgerTable>? orderByList,
    LedgerInclude? include,
  }) {
    return LedgerIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Ledger.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Ledger.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LedgerImpl extends Ledger {
  _LedgerImpl({
    int? id,
    required int workspaceId,
    String? referenceNumber,
    required String transactionType,
    required String paymentStatus,
    required double totalAmount,
    String? notes,
    required DateTime transactionAt,
    required String createdByName,
    int? createdById,
    String? counterpartyName,
    required DateTime createdAt,
    required DateTime lastModifiedAt,
  }) : super._(
          id: id,
          workspaceId: workspaceId,
          referenceNumber: referenceNumber,
          transactionType: transactionType,
          paymentStatus: paymentStatus,
          totalAmount: totalAmount,
          notes: notes,
          transactionAt: transactionAt,
          createdByName: createdByName,
          createdById: createdById,
          counterpartyName: counterpartyName,
          createdAt: createdAt,
          lastModifiedAt: lastModifiedAt,
        );

  /// Returns a shallow copy of this [Ledger]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Ledger copyWith({
    Object? id = _Undefined,
    int? workspaceId,
    Object? referenceNumber = _Undefined,
    String? transactionType,
    String? paymentStatus,
    double? totalAmount,
    Object? notes = _Undefined,
    DateTime? transactionAt,
    String? createdByName,
    Object? createdById = _Undefined,
    Object? counterpartyName = _Undefined,
    DateTime? createdAt,
    DateTime? lastModifiedAt,
  }) {
    return Ledger(
      id: id is int? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      referenceNumber:
          referenceNumber is String? ? referenceNumber : this.referenceNumber,
      transactionType: transactionType ?? this.transactionType,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      totalAmount: totalAmount ?? this.totalAmount,
      notes: notes is String? ? notes : this.notes,
      transactionAt: transactionAt ?? this.transactionAt,
      createdByName: createdByName ?? this.createdByName,
      createdById: createdById is int? ? createdById : this.createdById,
      counterpartyName: counterpartyName is String?
          ? counterpartyName
          : this.counterpartyName,
      createdAt: createdAt ?? this.createdAt,
      lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
    );
  }
}

class LedgerTable extends _i1.Table<int?> {
  LedgerTable({super.tableRelation}) : super(tableName: 'ledger') {
    workspaceId = _i1.ColumnInt(
      'workspaceId',
      this,
    );
    referenceNumber = _i1.ColumnString(
      'referenceNumber',
      this,
    );
    transactionType = _i1.ColumnString(
      'transactionType',
      this,
    );
    paymentStatus = _i1.ColumnString(
      'paymentStatus',
      this,
    );
    totalAmount = _i1.ColumnDouble(
      'totalAmount',
      this,
    );
    notes = _i1.ColumnString(
      'notes',
      this,
    );
    transactionAt = _i1.ColumnDateTime(
      'transactionAt',
      this,
    );
    createdByName = _i1.ColumnString(
      'createdByName',
      this,
    );
    createdById = _i1.ColumnInt(
      'createdById',
      this,
    );
    counterpartyName = _i1.ColumnString(
      'counterpartyName',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    lastModifiedAt = _i1.ColumnDateTime(
      'lastModifiedAt',
      this,
    );
  }

  late final _i1.ColumnInt workspaceId;

  late final _i1.ColumnString referenceNumber;

  late final _i1.ColumnString transactionType;

  late final _i1.ColumnString paymentStatus;

  late final _i1.ColumnDouble totalAmount;

  late final _i1.ColumnString notes;

  late final _i1.ColumnDateTime transactionAt;

  late final _i1.ColumnString createdByName;

  late final _i1.ColumnInt createdById;

  late final _i1.ColumnString counterpartyName;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime lastModifiedAt;

  @override
  List<_i1.Column> get columns => [
        id,
        workspaceId,
        referenceNumber,
        transactionType,
        paymentStatus,
        totalAmount,
        notes,
        transactionAt,
        createdByName,
        createdById,
        counterpartyName,
        createdAt,
        lastModifiedAt,
      ];
}

class LedgerInclude extends _i1.IncludeObject {
  LedgerInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Ledger.t;
}

class LedgerIncludeList extends _i1.IncludeList {
  LedgerIncludeList._({
    _i1.WhereExpressionBuilder<LedgerTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Ledger.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Ledger.t;
}

class LedgerRepository {
  const LedgerRepository._();

  /// Returns a list of [Ledger]s matching the given query parameters.
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
  Future<List<Ledger>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LedgerTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<LedgerTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LedgerTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Ledger>(
      where: where?.call(Ledger.t),
      orderBy: orderBy?.call(Ledger.t),
      orderByList: orderByList?.call(Ledger.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Ledger] matching the given query parameters.
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
  Future<Ledger?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LedgerTable>? where,
    int? offset,
    _i1.OrderByBuilder<LedgerTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<LedgerTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Ledger>(
      where: where?.call(Ledger.t),
      orderBy: orderBy?.call(Ledger.t),
      orderByList: orderByList?.call(Ledger.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Ledger] by its [id] or null if no such row exists.
  Future<Ledger?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Ledger>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Ledger]s in the list and returns the inserted rows.
  ///
  /// The returned [Ledger]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Ledger>> insert(
    _i1.Session session,
    List<Ledger> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Ledger>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Ledger] and returns the inserted row.
  ///
  /// The returned [Ledger] will have its `id` field set.
  Future<Ledger> insertRow(
    _i1.Session session,
    Ledger row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Ledger>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Ledger]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Ledger>> update(
    _i1.Session session,
    List<Ledger> rows, {
    _i1.ColumnSelections<LedgerTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Ledger>(
      rows,
      columns: columns?.call(Ledger.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Ledger]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Ledger> updateRow(
    _i1.Session session,
    Ledger row, {
    _i1.ColumnSelections<LedgerTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Ledger>(
      row,
      columns: columns?.call(Ledger.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Ledger]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Ledger>> delete(
    _i1.Session session,
    List<Ledger> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Ledger>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Ledger].
  Future<Ledger> deleteRow(
    _i1.Session session,
    Ledger row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Ledger>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Ledger>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<LedgerTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Ledger>(
      where: where(Ledger.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<LedgerTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Ledger>(
      where: where?.call(Ledger.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
