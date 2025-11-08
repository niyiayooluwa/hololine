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
import 'workspace_member.dart' as _i2;

abstract class Workspace
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Workspace._({
    this.id,
    required this.name,
    required this.description,
    this.parentId,
    bool? isPremium,
    required this.createdAt,
    this.deletedAt,
    this.archivedAt,
    this.members,
  }) : isPremium = isPremium ?? false;

  factory Workspace({
    int? id,
    required String name,
    required String description,
    int? parentId,
    bool? isPremium,
    required DateTime createdAt,
    DateTime? deletedAt,
    DateTime? archivedAt,
    List<_i2.WorkspaceMember>? members,
  }) = _WorkspaceImpl;

  factory Workspace.fromJson(Map<String, dynamic> jsonSerialization) {
    return Workspace(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      parentId: jsonSerialization['parentId'] as int?,
      isPremium: jsonSerialization['isPremium'] as bool,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
      archivedAt: jsonSerialization['archivedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['archivedAt']),
      members: (jsonSerialization['members'] as List?)
          ?.map(
              (e) => _i2.WorkspaceMember.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  static final t = WorkspaceTable();

  static const db = WorkspaceRepository._();

  @override
  int? id;

  String name;

  String description;

  int? parentId;

  bool isPremium;

  DateTime createdAt;

  DateTime? deletedAt;

  DateTime? archivedAt;

  List<_i2.WorkspaceMember>? members;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Workspace]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Workspace copyWith({
    int? id,
    String? name,
    String? description,
    int? parentId,
    bool? isPremium,
    DateTime? createdAt,
    DateTime? deletedAt,
    DateTime? archivedAt,
    List<_i2.WorkspaceMember>? members,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      if (parentId != null) 'parentId': parentId,
      'isPremium': isPremium,
      'createdAt': createdAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      if (archivedAt != null) 'archivedAt': archivedAt?.toJson(),
      if (members != null)
        'members': members?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      if (parentId != null) 'parentId': parentId,
      'isPremium': isPremium,
      'createdAt': createdAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      if (archivedAt != null) 'archivedAt': archivedAt?.toJson(),
      if (members != null)
        'members': members?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static WorkspaceInclude include({_i2.WorkspaceMemberIncludeList? members}) {
    return WorkspaceInclude._(members: members);
  }

  static WorkspaceIncludeList includeList({
    _i1.WhereExpressionBuilder<WorkspaceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WorkspaceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WorkspaceTable>? orderByList,
    WorkspaceInclude? include,
  }) {
    return WorkspaceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Workspace.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Workspace.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorkspaceImpl extends Workspace {
  _WorkspaceImpl({
    int? id,
    required String name,
    required String description,
    int? parentId,
    bool? isPremium,
    required DateTime createdAt,
    DateTime? deletedAt,
    DateTime? archivedAt,
    List<_i2.WorkspaceMember>? members,
  }) : super._(
          id: id,
          name: name,
          description: description,
          parentId: parentId,
          isPremium: isPremium,
          createdAt: createdAt,
          deletedAt: deletedAt,
          archivedAt: archivedAt,
          members: members,
        );

  /// Returns a shallow copy of this [Workspace]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Workspace copyWith({
    Object? id = _Undefined,
    String? name,
    String? description,
    Object? parentId = _Undefined,
    bool? isPremium,
    DateTime? createdAt,
    Object? deletedAt = _Undefined,
    Object? archivedAt = _Undefined,
    Object? members = _Undefined,
  }) {
    return Workspace(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      parentId: parentId is int? ? parentId : this.parentId,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      archivedAt: archivedAt is DateTime? ? archivedAt : this.archivedAt,
      members: members is List<_i2.WorkspaceMember>?
          ? members
          : this.members?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class WorkspaceTable extends _i1.Table<int?> {
  WorkspaceTable({super.tableRelation}) : super(tableName: 'workspace') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    parentId = _i1.ColumnInt(
      'parentId',
      this,
    );
    isPremium = _i1.ColumnBool(
      'isPremium',
      this,
      hasDefault: true,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    deletedAt = _i1.ColumnDateTime(
      'deletedAt',
      this,
    );
    archivedAt = _i1.ColumnDateTime(
      'archivedAt',
      this,
    );
  }

  late final _i1.ColumnString name;

  late final _i1.ColumnString description;

  late final _i1.ColumnInt parentId;

  late final _i1.ColumnBool isPremium;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime deletedAt;

  late final _i1.ColumnDateTime archivedAt;

  _i2.WorkspaceMemberTable? ___members;

  _i1.ManyRelation<_i2.WorkspaceMemberTable>? _members;

  _i2.WorkspaceMemberTable get __members {
    if (___members != null) return ___members!;
    ___members = _i1.createRelationTable(
      relationFieldName: '__members',
      field: Workspace.t.id,
      foreignField: _i2.WorkspaceMember.t.workspaceId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.WorkspaceMemberTable(tableRelation: foreignTableRelation),
    );
    return ___members!;
  }

  _i1.ManyRelation<_i2.WorkspaceMemberTable> get members {
    if (_members != null) return _members!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'members',
      field: Workspace.t.id,
      foreignField: _i2.WorkspaceMember.t.workspaceId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.WorkspaceMemberTable(tableRelation: foreignTableRelation),
    );
    _members = _i1.ManyRelation<_i2.WorkspaceMemberTable>(
      tableWithRelations: relationTable,
      table: _i2.WorkspaceMemberTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _members!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        description,
        parentId,
        isPremium,
        createdAt,
        deletedAt,
        archivedAt,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'members') {
      return __members;
    }
    return null;
  }
}

class WorkspaceInclude extends _i1.IncludeObject {
  WorkspaceInclude._({_i2.WorkspaceMemberIncludeList? members}) {
    _members = members;
  }

  _i2.WorkspaceMemberIncludeList? _members;

  @override
  Map<String, _i1.Include?> get includes => {'members': _members};

  @override
  _i1.Table<int?> get table => Workspace.t;
}

class WorkspaceIncludeList extends _i1.IncludeList {
  WorkspaceIncludeList._({
    _i1.WhereExpressionBuilder<WorkspaceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Workspace.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Workspace.t;
}

class WorkspaceRepository {
  const WorkspaceRepository._();

  final attach = const WorkspaceAttachRepository._();

  final attachRow = const WorkspaceAttachRowRepository._();

  final detach = const WorkspaceDetachRepository._();

  final detachRow = const WorkspaceDetachRowRepository._();

  /// Returns a list of [Workspace]s matching the given query parameters.
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
  Future<List<Workspace>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WorkspaceTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WorkspaceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WorkspaceTable>? orderByList,
    _i1.Transaction? transaction,
    WorkspaceInclude? include,
  }) async {
    return session.db.find<Workspace>(
      where: where?.call(Workspace.t),
      orderBy: orderBy?.call(Workspace.t),
      orderByList: orderByList?.call(Workspace.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Workspace] matching the given query parameters.
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
  Future<Workspace?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WorkspaceTable>? where,
    int? offset,
    _i1.OrderByBuilder<WorkspaceTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WorkspaceTable>? orderByList,
    _i1.Transaction? transaction,
    WorkspaceInclude? include,
  }) async {
    return session.db.findFirstRow<Workspace>(
      where: where?.call(Workspace.t),
      orderBy: orderBy?.call(Workspace.t),
      orderByList: orderByList?.call(Workspace.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Workspace] by its [id] or null if no such row exists.
  Future<Workspace?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    WorkspaceInclude? include,
  }) async {
    return session.db.findById<Workspace>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Workspace]s in the list and returns the inserted rows.
  ///
  /// The returned [Workspace]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Workspace>> insert(
    _i1.Session session,
    List<Workspace> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Workspace>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Workspace] and returns the inserted row.
  ///
  /// The returned [Workspace] will have its `id` field set.
  Future<Workspace> insertRow(
    _i1.Session session,
    Workspace row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Workspace>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Workspace]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Workspace>> update(
    _i1.Session session,
    List<Workspace> rows, {
    _i1.ColumnSelections<WorkspaceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Workspace>(
      rows,
      columns: columns?.call(Workspace.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Workspace]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Workspace> updateRow(
    _i1.Session session,
    Workspace row, {
    _i1.ColumnSelections<WorkspaceTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Workspace>(
      row,
      columns: columns?.call(Workspace.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Workspace]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Workspace>> delete(
    _i1.Session session,
    List<Workspace> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Workspace>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Workspace].
  Future<Workspace> deleteRow(
    _i1.Session session,
    Workspace row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Workspace>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Workspace>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<WorkspaceTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Workspace>(
      where: where(Workspace.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WorkspaceTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Workspace>(
      where: where?.call(Workspace.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class WorkspaceAttachRepository {
  const WorkspaceAttachRepository._();

  /// Creates a relation between this [Workspace] and the given [WorkspaceMember]s
  /// by setting each [WorkspaceMember]'s foreign key `workspaceId` to refer to this [Workspace].
  Future<void> members(
    _i1.Session session,
    Workspace workspace,
    List<_i2.WorkspaceMember> workspaceMember, {
    _i1.Transaction? transaction,
  }) async {
    if (workspaceMember.any((e) => e.id == null)) {
      throw ArgumentError.notNull('workspaceMember.id');
    }
    if (workspace.id == null) {
      throw ArgumentError.notNull('workspace.id');
    }

    var $workspaceMember = workspaceMember
        .map((e) => e.copyWith(workspaceId: workspace.id))
        .toList();
    await session.db.update<_i2.WorkspaceMember>(
      $workspaceMember,
      columns: [_i2.WorkspaceMember.t.workspaceId],
      transaction: transaction,
    );
  }
}

class WorkspaceAttachRowRepository {
  const WorkspaceAttachRowRepository._();

  /// Creates a relation between this [Workspace] and the given [WorkspaceMember]
  /// by setting the [WorkspaceMember]'s foreign key `workspaceId` to refer to this [Workspace].
  Future<void> members(
    _i1.Session session,
    Workspace workspace,
    _i2.WorkspaceMember workspaceMember, {
    _i1.Transaction? transaction,
  }) async {
    if (workspaceMember.id == null) {
      throw ArgumentError.notNull('workspaceMember.id');
    }
    if (workspace.id == null) {
      throw ArgumentError.notNull('workspace.id');
    }

    var $workspaceMember = workspaceMember.copyWith(workspaceId: workspace.id);
    await session.db.updateRow<_i2.WorkspaceMember>(
      $workspaceMember,
      columns: [_i2.WorkspaceMember.t.workspaceId],
      transaction: transaction,
    );
  }
}

class WorkspaceDetachRepository {
  const WorkspaceDetachRepository._();

  /// Detaches the relation between this [Workspace] and the given [WorkspaceMember]
  /// by setting the [WorkspaceMember]'s foreign key `workspaceId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> members(
    _i1.Session session,
    List<_i2.WorkspaceMember> workspaceMember, {
    _i1.Transaction? transaction,
  }) async {
    if (workspaceMember.any((e) => e.id == null)) {
      throw ArgumentError.notNull('workspaceMember.id');
    }

    var $workspaceMember =
        workspaceMember.map((e) => e.copyWith(workspaceId: null)).toList();
    await session.db.update<_i2.WorkspaceMember>(
      $workspaceMember,
      columns: [_i2.WorkspaceMember.t.workspaceId],
      transaction: transaction,
    );
  }
}

class WorkspaceDetachRowRepository {
  const WorkspaceDetachRowRepository._();

  /// Detaches the relation between this [Workspace] and the given [WorkspaceMember]
  /// by setting the [WorkspaceMember]'s foreign key `workspaceId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> members(
    _i1.Session session,
    _i2.WorkspaceMember workspaceMember, {
    _i1.Transaction? transaction,
  }) async {
    if (workspaceMember.id == null) {
      throw ArgumentError.notNull('workspaceMember.id');
    }

    var $workspaceMember = workspaceMember.copyWith(workspaceId: null);
    await session.db.updateRow<_i2.WorkspaceMember>(
      $workspaceMember,
      columns: [_i2.WorkspaceMember.t.workspaceId],
      transaction: transaction,
    );
  }
}
