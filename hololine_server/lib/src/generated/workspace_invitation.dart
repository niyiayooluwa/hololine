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
import 'workspace_role.dart' as _i2;

abstract class WorkspaceInvitation
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  WorkspaceInvitation._({
    this.id,
    required this.workspaceId,
    required this.inviteeEmail,
    required this.inviterId,
    required this.role,
    required this.token,
    required this.expiresAt,
    this.acceptedAt,
  });

  factory WorkspaceInvitation({
    int? id,
    required int workspaceId,
    required String inviteeEmail,
    required int inviterId,
    required _i2.WorkspaceRole role,
    required String token,
    required DateTime expiresAt,
    DateTime? acceptedAt,
  }) = _WorkspaceInvitationImpl;

  factory WorkspaceInvitation.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkspaceInvitation(
      id: jsonSerialization['id'] as int?,
      workspaceId: jsonSerialization['workspaceId'] as int,
      inviteeEmail: jsonSerialization['inviteeEmail'] as String,
      inviterId: jsonSerialization['inviterId'] as int,
      role: _i2.WorkspaceRole.fromJson((jsonSerialization['role'] as int)),
      token: jsonSerialization['token'] as String,
      expiresAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      acceptedAt: jsonSerialization['acceptedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['acceptedAt']),
    );
  }

  static final t = WorkspaceInvitationTable();

  static const db = WorkspaceInvitationRepository._();

  @override
  int? id;

  int workspaceId;

  String inviteeEmail;

  int inviterId;

  _i2.WorkspaceRole role;

  String token;

  DateTime expiresAt;

  DateTime? acceptedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [WorkspaceInvitation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  WorkspaceInvitation copyWith({
    int? id,
    int? workspaceId,
    String? inviteeEmail,
    int? inviterId,
    _i2.WorkspaceRole? role,
    String? token,
    DateTime? expiresAt,
    DateTime? acceptedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'workspaceId': workspaceId,
      'inviteeEmail': inviteeEmail,
      'inviterId': inviterId,
      'role': role.toJson(),
      'token': token,
      'expiresAt': expiresAt.toJson(),
      if (acceptedAt != null) 'acceptedAt': acceptedAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'workspaceId': workspaceId,
      'inviteeEmail': inviteeEmail,
      'inviterId': inviterId,
      'role': role.toJson(),
      'token': token,
      'expiresAt': expiresAt.toJson(),
      if (acceptedAt != null) 'acceptedAt': acceptedAt?.toJson(),
    };
  }

  static WorkspaceInvitationInclude include() {
    return WorkspaceInvitationInclude._();
  }

  static WorkspaceInvitationIncludeList includeList({
    _i1.WhereExpressionBuilder<WorkspaceInvitationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WorkspaceInvitationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WorkspaceInvitationTable>? orderByList,
    WorkspaceInvitationInclude? include,
  }) {
    return WorkspaceInvitationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WorkspaceInvitation.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(WorkspaceInvitation.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorkspaceInvitationImpl extends WorkspaceInvitation {
  _WorkspaceInvitationImpl({
    int? id,
    required int workspaceId,
    required String inviteeEmail,
    required int inviterId,
    required _i2.WorkspaceRole role,
    required String token,
    required DateTime expiresAt,
    DateTime? acceptedAt,
  }) : super._(
          id: id,
          workspaceId: workspaceId,
          inviteeEmail: inviteeEmail,
          inviterId: inviterId,
          role: role,
          token: token,
          expiresAt: expiresAt,
          acceptedAt: acceptedAt,
        );

  /// Returns a shallow copy of this [WorkspaceInvitation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  WorkspaceInvitation copyWith({
    Object? id = _Undefined,
    int? workspaceId,
    String? inviteeEmail,
    int? inviterId,
    _i2.WorkspaceRole? role,
    String? token,
    DateTime? expiresAt,
    Object? acceptedAt = _Undefined,
  }) {
    return WorkspaceInvitation(
      id: id is int? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      inviteeEmail: inviteeEmail ?? this.inviteeEmail,
      inviterId: inviterId ?? this.inviterId,
      role: role ?? this.role,
      token: token ?? this.token,
      expiresAt: expiresAt ?? this.expiresAt,
      acceptedAt: acceptedAt is DateTime? ? acceptedAt : this.acceptedAt,
    );
  }
}

class WorkspaceInvitationTable extends _i1.Table<int?> {
  WorkspaceInvitationTable({super.tableRelation})
      : super(tableName: 'invitation') {
    workspaceId = _i1.ColumnInt(
      'workspaceId',
      this,
    );
    inviteeEmail = _i1.ColumnString(
      'inviteeEmail',
      this,
    );
    inviterId = _i1.ColumnInt(
      'inviterId',
      this,
    );
    role = _i1.ColumnEnum(
      'role',
      this,
      _i1.EnumSerialization.byIndex,
    );
    token = _i1.ColumnString(
      'token',
      this,
    );
    expiresAt = _i1.ColumnDateTime(
      'expiresAt',
      this,
    );
    acceptedAt = _i1.ColumnDateTime(
      'acceptedAt',
      this,
    );
  }

  late final _i1.ColumnInt workspaceId;

  late final _i1.ColumnString inviteeEmail;

  late final _i1.ColumnInt inviterId;

  late final _i1.ColumnEnum<_i2.WorkspaceRole> role;

  late final _i1.ColumnString token;

  late final _i1.ColumnDateTime expiresAt;

  late final _i1.ColumnDateTime acceptedAt;

  @override
  List<_i1.Column> get columns => [
        id,
        workspaceId,
        inviteeEmail,
        inviterId,
        role,
        token,
        expiresAt,
        acceptedAt,
      ];
}

class WorkspaceInvitationInclude extends _i1.IncludeObject {
  WorkspaceInvitationInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => WorkspaceInvitation.t;
}

class WorkspaceInvitationIncludeList extends _i1.IncludeList {
  WorkspaceInvitationIncludeList._({
    _i1.WhereExpressionBuilder<WorkspaceInvitationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(WorkspaceInvitation.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => WorkspaceInvitation.t;
}

class WorkspaceInvitationRepository {
  const WorkspaceInvitationRepository._();

  /// Returns a list of [WorkspaceInvitation]s matching the given query parameters.
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
  Future<List<WorkspaceInvitation>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WorkspaceInvitationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WorkspaceInvitationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WorkspaceInvitationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<WorkspaceInvitation>(
      where: where?.call(WorkspaceInvitation.t),
      orderBy: orderBy?.call(WorkspaceInvitation.t),
      orderByList: orderByList?.call(WorkspaceInvitation.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [WorkspaceInvitation] matching the given query parameters.
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
  Future<WorkspaceInvitation?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WorkspaceInvitationTable>? where,
    int? offset,
    _i1.OrderByBuilder<WorkspaceInvitationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WorkspaceInvitationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<WorkspaceInvitation>(
      where: where?.call(WorkspaceInvitation.t),
      orderBy: orderBy?.call(WorkspaceInvitation.t),
      orderByList: orderByList?.call(WorkspaceInvitation.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [WorkspaceInvitation] by its [id] or null if no such row exists.
  Future<WorkspaceInvitation?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<WorkspaceInvitation>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [WorkspaceInvitation]s in the list and returns the inserted rows.
  ///
  /// The returned [WorkspaceInvitation]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<WorkspaceInvitation>> insert(
    _i1.Session session,
    List<WorkspaceInvitation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<WorkspaceInvitation>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [WorkspaceInvitation] and returns the inserted row.
  ///
  /// The returned [WorkspaceInvitation] will have its `id` field set.
  Future<WorkspaceInvitation> insertRow(
    _i1.Session session,
    WorkspaceInvitation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<WorkspaceInvitation>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [WorkspaceInvitation]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<WorkspaceInvitation>> update(
    _i1.Session session,
    List<WorkspaceInvitation> rows, {
    _i1.ColumnSelections<WorkspaceInvitationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<WorkspaceInvitation>(
      rows,
      columns: columns?.call(WorkspaceInvitation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WorkspaceInvitation]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<WorkspaceInvitation> updateRow(
    _i1.Session session,
    WorkspaceInvitation row, {
    _i1.ColumnSelections<WorkspaceInvitationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<WorkspaceInvitation>(
      row,
      columns: columns?.call(WorkspaceInvitation.t),
      transaction: transaction,
    );
  }

  /// Deletes all [WorkspaceInvitation]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<WorkspaceInvitation>> delete(
    _i1.Session session,
    List<WorkspaceInvitation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<WorkspaceInvitation>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [WorkspaceInvitation].
  Future<WorkspaceInvitation> deleteRow(
    _i1.Session session,
    WorkspaceInvitation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<WorkspaceInvitation>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<WorkspaceInvitation>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<WorkspaceInvitationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<WorkspaceInvitation>(
      where: where(WorkspaceInvitation.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WorkspaceInvitationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<WorkspaceInvitation>(
      where: where?.call(WorkspaceInvitation.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
