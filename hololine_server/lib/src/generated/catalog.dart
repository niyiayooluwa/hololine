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

abstract class Catalog
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Catalog._({
    this.id,
    required this.workspaceId,
    required this.name,
    required this.type,
    this.sku,
    required this.unit,
    this.category,
    this.weight,
    this.minOrderQty,
    required this.price,
    String? currency,
    String? status,
    required this.addedByName,
    this.addedById,
    required this.createdAt,
    required this.lastModifiedAt,
  })  : currency = currency ?? 'NGN',
        status = status ?? 'active';

  factory Catalog({
    int? id,
    required int workspaceId,
    required String name,
    required String type,
    String? sku,
    required String unit,
    String? category,
    double? weight,
    double? minOrderQty,
    required int price,
    String? currency,
    String? status,
    required String addedByName,
    int? addedById,
    required DateTime createdAt,
    required DateTime lastModifiedAt,
  }) = _CatalogImpl;

  factory Catalog.fromJson(Map<String, dynamic> jsonSerialization) {
    return Catalog(
      id: jsonSerialization['id'] as int?,
      workspaceId: jsonSerialization['workspaceId'] as int,
      name: jsonSerialization['name'] as String,
      type: jsonSerialization['type'] as String,
      sku: jsonSerialization['sku'] as String?,
      unit: jsonSerialization['unit'] as String,
      category: jsonSerialization['category'] as String?,
      weight: (jsonSerialization['weight'] as num?)?.toDouble(),
      minOrderQty: (jsonSerialization['minOrderQty'] as num?)?.toDouble(),
      price: jsonSerialization['price'] as int,
      currency: jsonSerialization['currency'] as String,
      status: jsonSerialization['status'] as String,
      addedByName: jsonSerialization['addedByName'] as String,
      addedById: jsonSerialization['addedById'] as int?,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      lastModifiedAt: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['lastModifiedAt']),
    );
  }

  static final t = CatalogTable();

  static const db = CatalogRepository._();

  @override
  int? id;

  int workspaceId;

  String name;

  String type;

  String? sku;

  String unit;

  String? category;

  double? weight;

  double? minOrderQty;

  int price;

  String currency;

  String status;

  String addedByName;

  int? addedById;

  DateTime createdAt;

  DateTime lastModifiedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Catalog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Catalog copyWith({
    int? id,
    int? workspaceId,
    String? name,
    String? type,
    String? sku,
    String? unit,
    String? category,
    double? weight,
    double? minOrderQty,
    int? price,
    String? currency,
    String? status,
    String? addedByName,
    int? addedById,
    DateTime? createdAt,
    DateTime? lastModifiedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'workspaceId': workspaceId,
      'name': name,
      'type': type,
      if (sku != null) 'sku': sku,
      'unit': unit,
      if (category != null) 'category': category,
      if (weight != null) 'weight': weight,
      if (minOrderQty != null) 'minOrderQty': minOrderQty,
      'price': price,
      'currency': currency,
      'status': status,
      'addedByName': addedByName,
      if (addedById != null) 'addedById': addedById,
      'createdAt': createdAt.toJson(),
      'lastModifiedAt': lastModifiedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'workspaceId': workspaceId,
      'name': name,
      'type': type,
      if (sku != null) 'sku': sku,
      'unit': unit,
      if (category != null) 'category': category,
      if (weight != null) 'weight': weight,
      if (minOrderQty != null) 'minOrderQty': minOrderQty,
      'price': price,
      'currency': currency,
      'status': status,
      'addedByName': addedByName,
      if (addedById != null) 'addedById': addedById,
      'createdAt': createdAt.toJson(),
      'lastModifiedAt': lastModifiedAt.toJson(),
    };
  }

  static CatalogInclude include() {
    return CatalogInclude._();
  }

  static CatalogIncludeList includeList({
    _i1.WhereExpressionBuilder<CatalogTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CatalogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CatalogTable>? orderByList,
    CatalogInclude? include,
  }) {
    return CatalogIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Catalog.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Catalog.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CatalogImpl extends Catalog {
  _CatalogImpl({
    int? id,
    required int workspaceId,
    required String name,
    required String type,
    String? sku,
    required String unit,
    String? category,
    double? weight,
    double? minOrderQty,
    required int price,
    String? currency,
    String? status,
    required String addedByName,
    int? addedById,
    required DateTime createdAt,
    required DateTime lastModifiedAt,
  }) : super._(
          id: id,
          workspaceId: workspaceId,
          name: name,
          type: type,
          sku: sku,
          unit: unit,
          category: category,
          weight: weight,
          minOrderQty: minOrderQty,
          price: price,
          currency: currency,
          status: status,
          addedByName: addedByName,
          addedById: addedById,
          createdAt: createdAt,
          lastModifiedAt: lastModifiedAt,
        );

  /// Returns a shallow copy of this [Catalog]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Catalog copyWith({
    Object? id = _Undefined,
    int? workspaceId,
    String? name,
    String? type,
    Object? sku = _Undefined,
    String? unit,
    Object? category = _Undefined,
    Object? weight = _Undefined,
    Object? minOrderQty = _Undefined,
    int? price,
    String? currency,
    String? status,
    String? addedByName,
    Object? addedById = _Undefined,
    DateTime? createdAt,
    DateTime? lastModifiedAt,
  }) {
    return Catalog(
      id: id is int? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      name: name ?? this.name,
      type: type ?? this.type,
      sku: sku is String? ? sku : this.sku,
      unit: unit ?? this.unit,
      category: category is String? ? category : this.category,
      weight: weight is double? ? weight : this.weight,
      minOrderQty: minOrderQty is double? ? minOrderQty : this.minOrderQty,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      addedByName: addedByName ?? this.addedByName,
      addedById: addedById is int? ? addedById : this.addedById,
      createdAt: createdAt ?? this.createdAt,
      lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
    );
  }
}

class CatalogTable extends _i1.Table<int?> {
  CatalogTable({super.tableRelation}) : super(tableName: 'catalog') {
    workspaceId = _i1.ColumnInt(
      'workspaceId',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    type = _i1.ColumnString(
      'type',
      this,
    );
    sku = _i1.ColumnString(
      'sku',
      this,
    );
    unit = _i1.ColumnString(
      'unit',
      this,
    );
    category = _i1.ColumnString(
      'category',
      this,
    );
    weight = _i1.ColumnDouble(
      'weight',
      this,
    );
    minOrderQty = _i1.ColumnDouble(
      'minOrderQty',
      this,
    );
    price = _i1.ColumnInt(
      'price',
      this,
    );
    currency = _i1.ColumnString(
      'currency',
      this,
      hasDefault: true,
    );
    status = _i1.ColumnString(
      'status',
      this,
      hasDefault: true,
    );
    addedByName = _i1.ColumnString(
      'addedByName',
      this,
    );
    addedById = _i1.ColumnInt(
      'addedById',
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

  late final _i1.ColumnString name;

  late final _i1.ColumnString type;

  late final _i1.ColumnString sku;

  late final _i1.ColumnString unit;

  late final _i1.ColumnString category;

  late final _i1.ColumnDouble weight;

  late final _i1.ColumnDouble minOrderQty;

  late final _i1.ColumnInt price;

  late final _i1.ColumnString currency;

  late final _i1.ColumnString status;

  late final _i1.ColumnString addedByName;

  late final _i1.ColumnInt addedById;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime lastModifiedAt;

  @override
  List<_i1.Column> get columns => [
        id,
        workspaceId,
        name,
        type,
        sku,
        unit,
        category,
        weight,
        minOrderQty,
        price,
        currency,
        status,
        addedByName,
        addedById,
        createdAt,
        lastModifiedAt,
      ];
}

class CatalogInclude extends _i1.IncludeObject {
  CatalogInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Catalog.t;
}

class CatalogIncludeList extends _i1.IncludeList {
  CatalogIncludeList._({
    _i1.WhereExpressionBuilder<CatalogTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Catalog.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Catalog.t;
}

class CatalogRepository {
  const CatalogRepository._();

  /// Returns a list of [Catalog]s matching the given query parameters.
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
  Future<List<Catalog>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CatalogTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CatalogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CatalogTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<Catalog>(
      where: where?.call(Catalog.t),
      orderBy: orderBy?.call(Catalog.t),
      orderByList: orderByList?.call(Catalog.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [Catalog] matching the given query parameters.
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
  Future<Catalog?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CatalogTable>? where,
    int? offset,
    _i1.OrderByBuilder<CatalogTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CatalogTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<Catalog>(
      where: where?.call(Catalog.t),
      orderBy: orderBy?.call(Catalog.t),
      orderByList: orderByList?.call(Catalog.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [Catalog] by its [id] or null if no such row exists.
  Future<Catalog?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<Catalog>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [Catalog]s in the list and returns the inserted rows.
  ///
  /// The returned [Catalog]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Catalog>> insert(
    _i1.Session session,
    List<Catalog> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Catalog>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Catalog] and returns the inserted row.
  ///
  /// The returned [Catalog] will have its `id` field set.
  Future<Catalog> insertRow(
    _i1.Session session,
    Catalog row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Catalog>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Catalog]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Catalog>> update(
    _i1.Session session,
    List<Catalog> rows, {
    _i1.ColumnSelections<CatalogTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Catalog>(
      rows,
      columns: columns?.call(Catalog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Catalog]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Catalog> updateRow(
    _i1.Session session,
    Catalog row, {
    _i1.ColumnSelections<CatalogTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Catalog>(
      row,
      columns: columns?.call(Catalog.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Catalog]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Catalog>> delete(
    _i1.Session session,
    List<Catalog> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Catalog>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Catalog].
  Future<Catalog> deleteRow(
    _i1.Session session,
    Catalog row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Catalog>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Catalog>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CatalogTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Catalog>(
      where: where(Catalog.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CatalogTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Catalog>(
      where: where?.call(Catalog.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
