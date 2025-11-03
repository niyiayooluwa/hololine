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

abstract class UserInfo
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  UserInfo._({
    this.id,
    required this.userIdentifier,
    this.userName,
    this.fullName,
    this.email,
    required this.created,
    required this.blocked,
    required this.scopeNames,
  });

  factory UserInfo({
    int? id,
    required String userIdentifier,
    String? userName,
    String? fullName,
    String? email,
    required DateTime created,
    required bool blocked,
    required List<String> scopeNames,
  }) = _UserInfoImpl;

  factory UserInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserInfo(
      id: jsonSerialization['id'] as int?,
      userIdentifier: jsonSerialization['userIdentifier'] as String,
      userName: jsonSerialization['userName'] as String?,
      fullName: jsonSerialization['fullName'] as String?,
      email: jsonSerialization['email'] as String?,
      created: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['created']),
      blocked: jsonSerialization['blocked'] as bool,
      scopeNames: (jsonSerialization['scopeNames'] as List)
          .map((e) => e as String)
          .toList(),
    );
  }

  static final t = UserInfoTable();

  static const db = UserInfoRepository._();

  @override
  int? id;

  String userIdentifier;

  String? userName;

  String? fullName;

  String? email;

  DateTime created;

  bool blocked;

  List<String> scopeNames;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  UserInfo copyWith({
    int? id,
    String? userIdentifier,
    String? userName,
    String? fullName,
    String? email,
    DateTime? created,
    bool? blocked,
    List<String>? scopeNames,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userIdentifier': userIdentifier,
      if (userName != null) 'userName': userName,
      if (fullName != null) 'fullName': fullName,
      if (email != null) 'email': email,
      'created': created.toJson(),
      'blocked': blocked,
      'scopeNames': scopeNames.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'userIdentifier': userIdentifier,
      if (userName != null) 'userName': userName,
      if (fullName != null) 'fullName': fullName,
      if (email != null) 'email': email,
      'created': created.toJson(),
      'blocked': blocked,
      'scopeNames': scopeNames.toJson(),
    };
  }

  static UserInfoInclude include() {
    return UserInfoInclude._();
  }

  static UserInfoIncludeList includeList({
    _i1.WhereExpressionBuilder<UserInfoTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserInfoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserInfoTable>? orderByList,
    UserInfoInclude? include,
  }) {
    return UserInfoIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserInfo.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(UserInfo.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserInfoImpl extends UserInfo {
  _UserInfoImpl({
    int? id,
    required String userIdentifier,
    String? userName,
    String? fullName,
    String? email,
    required DateTime created,
    required bool blocked,
    required List<String> scopeNames,
  }) : super._(
          id: id,
          userIdentifier: userIdentifier,
          userName: userName,
          fullName: fullName,
          email: email,
          created: created,
          blocked: blocked,
          scopeNames: scopeNames,
        );

  /// Returns a shallow copy of this [UserInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  UserInfo copyWith({
    Object? id = _Undefined,
    String? userIdentifier,
    Object? userName = _Undefined,
    Object? fullName = _Undefined,
    Object? email = _Undefined,
    DateTime? created,
    bool? blocked,
    List<String>? scopeNames,
  }) {
    return UserInfo(
      id: id is int? ? id : this.id,
      userIdentifier: userIdentifier ?? this.userIdentifier,
      userName: userName is String? ? userName : this.userName,
      fullName: fullName is String? ? fullName : this.fullName,
      email: email is String? ? email : this.email,
      created: created ?? this.created,
      blocked: blocked ?? this.blocked,
      scopeNames: scopeNames ?? this.scopeNames.map((e0) => e0).toList(),
    );
  }
}

class UserInfoTable extends _i1.Table<int?> {
  UserInfoTable({super.tableRelation})
      : super(tableName: 'serverpod_auth_user_info') {
    userIdentifier = _i1.ColumnString(
      'userIdentifier',
      this,
    );
    userName = _i1.ColumnString(
      'userName',
      this,
    );
    fullName = _i1.ColumnString(
      'fullName',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    created = _i1.ColumnDateTime(
      'created',
      this,
    );
    blocked = _i1.ColumnBool(
      'blocked',
      this,
    );
    scopeNames = _i1.ColumnSerializable(
      'scopeNames',
      this,
    );
  }

  late final _i1.ColumnString userIdentifier;

  late final _i1.ColumnString userName;

  late final _i1.ColumnString fullName;

  late final _i1.ColumnString email;

  late final _i1.ColumnDateTime created;

  late final _i1.ColumnBool blocked;

  late final _i1.ColumnSerializable scopeNames;

  @override
  List<_i1.Column> get columns => [
        id,
        userIdentifier,
        userName,
        fullName,
        email,
        created,
        blocked,
        scopeNames,
      ];
}

class UserInfoInclude extends _i1.IncludeObject {
  UserInfoInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => UserInfo.t;
}

class UserInfoIncludeList extends _i1.IncludeList {
  UserInfoIncludeList._({
    _i1.WhereExpressionBuilder<UserInfoTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserInfo.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => UserInfo.t;
}

class UserInfoRepository {
  const UserInfoRepository._();

  /// Returns a list of [UserInfo]s matching the given query parameters.
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
  Future<List<UserInfo>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserInfoTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<UserInfoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserInfoTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<UserInfo>(
      where: where?.call(UserInfo.t),
      orderBy: orderBy?.call(UserInfo.t),
      orderByList: orderByList?.call(UserInfo.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [UserInfo] matching the given query parameters.
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
  Future<UserInfo?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserInfoTable>? where,
    int? offset,
    _i1.OrderByBuilder<UserInfoTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<UserInfoTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<UserInfo>(
      where: where?.call(UserInfo.t),
      orderBy: orderBy?.call(UserInfo.t),
      orderByList: orderByList?.call(UserInfo.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [UserInfo] by its [id] or null if no such row exists.
  Future<UserInfo?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<UserInfo>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [UserInfo]s in the list and returns the inserted rows.
  ///
  /// The returned [UserInfo]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<UserInfo>> insert(
    _i1.Session session,
    List<UserInfo> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<UserInfo>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [UserInfo] and returns the inserted row.
  ///
  /// The returned [UserInfo] will have its `id` field set.
  Future<UserInfo> insertRow(
    _i1.Session session,
    UserInfo row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserInfo>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [UserInfo]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<UserInfo>> update(
    _i1.Session session,
    List<UserInfo> rows, {
    _i1.ColumnSelections<UserInfoTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<UserInfo>(
      rows,
      columns: columns?.call(UserInfo.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserInfo]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserInfo> updateRow(
    _i1.Session session,
    UserInfo row, {
    _i1.ColumnSelections<UserInfoTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserInfo>(
      row,
      columns: columns?.call(UserInfo.t),
      transaction: transaction,
    );
  }

  /// Deletes all [UserInfo]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<UserInfo>> delete(
    _i1.Session session,
    List<UserInfo> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<UserInfo>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [UserInfo].
  Future<UserInfo> deleteRow(
    _i1.Session session,
    UserInfo row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserInfo>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<UserInfo>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<UserInfoTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<UserInfo>(
      where: where(UserInfo.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<UserInfoTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<UserInfo>(
      where: where?.call(UserInfo.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
