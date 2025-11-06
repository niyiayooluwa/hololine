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
import 'workspace.dart' as _i2;
import 'workspace_role.dart' as _i3;

abstract class WorkspaceMember
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  WorkspaceMember._({
    this.id,
    required this.userInfoId,
    required this.workspaceId,
    this.workspace,
    required this.role,
    this.invitedById,
    required this.joinedAt,
    bool? isActive,
  }) : isActive = isActive ?? true;

  factory WorkspaceMember({
    int? id,
    required int userInfoId,
    required int workspaceId,
    _i2.Workspace? workspace,
    required _i3.WorkspaceRole role,
    int? invitedById,
    required DateTime joinedAt,
    bool? isActive,
  }) = _WorkspaceMemberImpl;

  factory WorkspaceMember.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkspaceMember(
      id: jsonSerialization['id'] as int?,
      userInfoId: jsonSerialization['userInfoId'] as int,
      workspaceId: jsonSerialization['workspaceId'] as int,
      workspace: jsonSerialization['workspace'] == null
          ? null
          : _i2.Workspace.fromJson(
              (jsonSerialization['workspace'] as Map<String, dynamic>)),
      role: _i3.WorkspaceRole.fromJson((jsonSerialization['role'] as int)),
      invitedById: jsonSerialization['invitedById'] as int?,
      joinedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['joinedAt']),
      isActive: jsonSerialization['isActive'] as bool,
    );
  }

  static final t = WorkspaceMemberTable();

  static const db = WorkspaceMemberRepository._();

  @override
  int? id;

  int userInfoId;

  int workspaceId;

  _i2.Workspace? workspace;

  _i3.WorkspaceRole role;

  int? invitedById;

  DateTime joinedAt;

  bool isActive;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [WorkspaceMember]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  WorkspaceMember copyWith({
    int? id,
    int? userInfoId,
    int? workspaceId,
    _i2.Workspace? workspace,
    _i3.WorkspaceRole? role,
    int? invitedById,
    DateTime? joinedAt,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      'workspaceId': workspaceId,
      if (workspace != null) 'workspace': workspace?.toJson(),
      'role': role.toJson(),
      if (invitedById != null) 'invitedById': invitedById,
      'joinedAt': joinedAt.toJson(),
      'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      'workspaceId': workspaceId,
      if (workspace != null) 'workspace': workspace?.toJsonForProtocol(),
      'role': role.toJson(),
      if (invitedById != null) 'invitedById': invitedById,
      'joinedAt': joinedAt.toJson(),
      'isActive': isActive,
    };
  }

  static WorkspaceMemberInclude include({_i2.WorkspaceInclude? workspace}) {
    return WorkspaceMemberInclude._(workspace: workspace);
  }

  static WorkspaceMemberIncludeList includeList({
    _i1.WhereExpressionBuilder<WorkspaceMemberTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WorkspaceMemberTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WorkspaceMemberTable>? orderByList,
    WorkspaceMemberInclude? include,
  }) {
    return WorkspaceMemberIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WorkspaceMember.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(WorkspaceMember.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorkspaceMemberImpl extends WorkspaceMember {
  _WorkspaceMemberImpl({
    int? id,
    required int userInfoId,
    required int workspaceId,
    _i2.Workspace? workspace,
    required _i3.WorkspaceRole role,
    int? invitedById,
    required DateTime joinedAt,
    bool? isActive,
  }) : super._(
          id: id,
          userInfoId: userInfoId,
          workspaceId: workspaceId,
          workspace: workspace,
          role: role,
          invitedById: invitedById,
          joinedAt: joinedAt,
          isActive: isActive,
        );

  /// Returns a shallow copy of this [WorkspaceMember]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  WorkspaceMember copyWith({
    Object? id = _Undefined,
    int? userInfoId,
    int? workspaceId,
    Object? workspace = _Undefined,
    _i3.WorkspaceRole? role,
    Object? invitedById = _Undefined,
    DateTime? joinedAt,
    bool? isActive,
  }) {
    return WorkspaceMember(
      id: id is int? ? id : this.id,
      userInfoId: userInfoId ?? this.userInfoId,
      workspaceId: workspaceId ?? this.workspaceId,
      workspace:
          workspace is _i2.Workspace? ? workspace : this.workspace?.copyWith(),
      role: role ?? this.role,
      invitedById: invitedById is int? ? invitedById : this.invitedById,
      joinedAt: joinedAt ?? this.joinedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

class WorkspaceMemberTable extends _i1.Table<int?> {
  WorkspaceMemberTable({super.tableRelation})
      : super(tableName: 'workspace_member') {
    userInfoId = _i1.ColumnInt(
      'userInfoId',
      this,
    );
    workspaceId = _i1.ColumnInt(
      'workspaceId',
      this,
    );
    role = _i1.ColumnEnum(
      'role',
      this,
      _i1.EnumSerialization.byIndex,
    );
    invitedById = _i1.ColumnInt(
      'invitedById',
      this,
    );
    joinedAt = _i1.ColumnDateTime(
      'joinedAt',
      this,
    );
    isActive = _i1.ColumnBool(
      'isActive',
      this,
      hasDefault: true,
    );
  }

  late final _i1.ColumnInt userInfoId;

  late final _i1.ColumnInt workspaceId;

  _i2.WorkspaceTable? _workspace;

  late final _i1.ColumnEnum<_i3.WorkspaceRole> role;

  late final _i1.ColumnInt invitedById;

  late final _i1.ColumnDateTime joinedAt;

  late final _i1.ColumnBool isActive;

  _i2.WorkspaceTable get workspace {
    if (_workspace != null) return _workspace!;
    _workspace = _i1.createRelationTable(
      relationFieldName: 'workspace',
      field: WorkspaceMember.t.workspaceId,
      foreignField: _i2.Workspace.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.WorkspaceTable(tableRelation: foreignTableRelation),
    );
    return _workspace!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        userInfoId,
        workspaceId,
        role,
        invitedById,
        joinedAt,
        isActive,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'workspace') {
      return workspace;
    }
    return null;
  }
}

class WorkspaceMemberInclude extends _i1.IncludeObject {
  WorkspaceMemberInclude._({_i2.WorkspaceInclude? workspace}) {
    _workspace = workspace;
  }

  _i2.WorkspaceInclude? _workspace;

  @override
  Map<String, _i1.Include?> get includes => {'workspace': _workspace};

  @override
  _i1.Table<int?> get table => WorkspaceMember.t;
}

class WorkspaceMemberIncludeList extends _i1.IncludeList {
  WorkspaceMemberIncludeList._({
    _i1.WhereExpressionBuilder<WorkspaceMemberTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(WorkspaceMember.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => WorkspaceMember.t;
}

class WorkspaceMemberRepository {
  const WorkspaceMemberRepository._();

  final attachRow = const WorkspaceMemberAttachRowRepository._();

  /// Returns a list of [WorkspaceMember]s matching the given query parameters.
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
  Future<List<WorkspaceMember>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WorkspaceMemberTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WorkspaceMemberTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WorkspaceMemberTable>? orderByList,
    _i1.Transaction? transaction,
    WorkspaceMemberInclude? include,
  }) async {
    return session.db.find<WorkspaceMember>(
      where: where?.call(WorkspaceMember.t),
      orderBy: orderBy?.call(WorkspaceMember.t),
      orderByList: orderByList?.call(WorkspaceMember.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [WorkspaceMember] matching the given query parameters.
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
  Future<WorkspaceMember?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WorkspaceMemberTable>? where,
    int? offset,
    _i1.OrderByBuilder<WorkspaceMemberTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WorkspaceMemberTable>? orderByList,
    _i1.Transaction? transaction,
    WorkspaceMemberInclude? include,
  }) async {
    return session.db.findFirstRow<WorkspaceMember>(
      where: where?.call(WorkspaceMember.t),
      orderBy: orderBy?.call(WorkspaceMember.t),
      orderByList: orderByList?.call(WorkspaceMember.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [WorkspaceMember] by its [id] or null if no such row exists.
  Future<WorkspaceMember?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    WorkspaceMemberInclude? include,
  }) async {
    return session.db.findById<WorkspaceMember>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [WorkspaceMember]s in the list and returns the inserted rows.
  ///
  /// The returned [WorkspaceMember]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<WorkspaceMember>> insert(
    _i1.Session session,
    List<WorkspaceMember> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<WorkspaceMember>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [WorkspaceMember] and returns the inserted row.
  ///
  /// The returned [WorkspaceMember] will have its `id` field set.
  Future<WorkspaceMember> insertRow(
    _i1.Session session,
    WorkspaceMember row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<WorkspaceMember>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [WorkspaceMember]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<WorkspaceMember>> update(
    _i1.Session session,
    List<WorkspaceMember> rows, {
    _i1.ColumnSelections<WorkspaceMemberTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<WorkspaceMember>(
      rows,
      columns: columns?.call(WorkspaceMember.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WorkspaceMember]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<WorkspaceMember> updateRow(
    _i1.Session session,
    WorkspaceMember row, {
    _i1.ColumnSelections<WorkspaceMemberTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<WorkspaceMember>(
      row,
      columns: columns?.call(WorkspaceMember.t),
      transaction: transaction,
    );
  }

  /// Deletes all [WorkspaceMember]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<WorkspaceMember>> delete(
    _i1.Session session,
    List<WorkspaceMember> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<WorkspaceMember>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [WorkspaceMember].
  Future<WorkspaceMember> deleteRow(
    _i1.Session session,
    WorkspaceMember row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<WorkspaceMember>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<WorkspaceMember>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<WorkspaceMemberTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<WorkspaceMember>(
      where: where(WorkspaceMember.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WorkspaceMemberTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<WorkspaceMember>(
      where: where?.call(WorkspaceMember.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class WorkspaceMemberAttachRowRepository {
  const WorkspaceMemberAttachRowRepository._();

  /// Creates a relation between the given [WorkspaceMember] and [Workspace]
  /// by setting the [WorkspaceMember]'s foreign key `workspaceId` to refer to the [Workspace].
  Future<void> workspace(
    _i1.Session session,
    WorkspaceMember workspaceMember,
    _i2.Workspace workspace, {
    _i1.Transaction? transaction,
  }) async {
    if (workspaceMember.id == null) {
      throw ArgumentError.notNull('workspaceMember.id');
    }
    if (workspace.id == null) {
      throw ArgumentError.notNull('workspace.id');
    }

    var $workspaceMember = workspaceMember.copyWith(workspaceId: workspace.id);
    await session.db.updateRow<WorkspaceMember>(
      $workspaceMember,
      columns: [WorkspaceMember.t.workspaceId],
      transaction: transaction,
    );
  }
}
