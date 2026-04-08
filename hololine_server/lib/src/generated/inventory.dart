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
import 'catalog.dart' as _i2;

abstract class Inventory
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Inventory._({
    this.id,
    required this.workspaceId,
    required this.catalogId,
    this.catalog,
    required this.currentQty,
    required this.availableQty,
    required this.totalValue,
    this.location,
    this.lowStockThreshold,
    this.lastRestockedAt,
    this.lastRestockedByName,
    this.lastRestockedById,
    this.lastDeductedAt,
    this.lastDeductedByName,
    this.lastDeductedById,
    required this.createdAt,
    required this.lastModifiedAt,
  });

  factory Inventory({
    int? id,
    required int workspaceId,
    required int catalogId,
    _i2.Catalog? catalog,
    required double currentQty,
    required double availableQty,
    required int totalValue,
    String? location,
    double? lowStockThreshold,
    DateTime? lastRestockedAt,
    String? lastRestockedByName,
    int? lastRestockedById,
    DateTime? lastDeductedAt,
    String? lastDeductedByName,
    int? lastDeductedById,
    required DateTime createdAt,
    required DateTime lastModifiedAt,
  }) = _InventoryImpl;

  factory Inventory.fromJson(Map<String, dynamic> jsonSerialization) {
    return Inventory(
      id: jsonSerialization['id'] as int?,
      workspaceId: jsonSerialization['workspaceId'] as int,
      catalogId: jsonSerialization['catalogId'] as int,
      catalog: jsonSerialization['catalog'] == null
          ? null
          : _i2.Catalog.fromJson(
              (jsonSerialization['catalog'] as Map<String, dynamic>)),
      currentQty: (jsonSerialization['currentQty'] as num).toDouble(),
      availableQty: (jsonSerialization['availableQty'] as num).toDouble(),
      totalValue: jsonSerialization['totalValue'] as int,
      location: jsonSerialization['location'] as String?,
      lowStockThreshold:
          (jsonSerialization['lowStockThreshold'] as num?)?.toDouble(),
      lastRestockedAt: jsonSerialization['lastRestockedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastRestockedAt']),
      lastRestockedByName: jsonSerialization['lastRestockedByName'] as String?,
      lastRestockedById: jsonSerialization['lastRestockedById'] as int?,
      lastDeductedAt: jsonSerialization['lastDeductedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastDeductedAt']),
      lastDeductedByName: jsonSerialization['lastDeductedByName'] as String?,
      lastDeductedById: jsonSerialization['lastDeductedById'] as int?,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      lastModifiedAt: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['lastModifiedAt']),
    );
  }

  static final t = InventoryTable();

  static const db = InventoryRepository._();

  @override
  int? id;

  int workspaceId;

  int catalogId;

  _i2.Catalog? catalog;

  double currentQty;

  double availableQty;

  int totalValue;

  String? location;

  double? lowStockThreshold;

  DateTime? lastRestockedAt;

  String? lastRestockedByName;

  int? lastRestockedById;

  DateTime? lastDeductedAt;

  String? lastDeductedByName;

  int? lastDeductedById;

  DateTime createdAt;

  DateTime lastModifiedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Inventory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Inventory copyWith({
    int? id,
    int? workspaceId,
    int? catalogId,
    _i2.Catalog? catalog,
    double? currentQty,
    double? availableQty,
    int? totalValue,
    String? location,
    double? lowStockThreshold,
    DateTime? lastRestockedAt,
    String? lastRestockedByName,
    int? lastRestockedById,
    DateTime? lastDeductedAt,
    String? lastDeductedByName,
    int? lastDeductedById,
    DateTime? createdAt,
    DateTime? lastModifiedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'workspaceId': workspaceId,
      'catalogId': catalogId,
      if (catalog != null) 'catalog': catalog?.toJson(),
      'currentQty': currentQty,
      'availableQty': availableQty,
      'totalValue': totalValue,
      if (location != null) 'location': location,
      if (lowStockThreshold != null) 'lowStockThreshold': lowStockThreshold,
      if (lastRestockedAt != null) 'lastRestockedAt': lastRestockedAt?.toJson(),
      if (lastRestockedByName != null)
        'lastRestockedByName': lastRestockedByName,
      if (lastRestockedById != null) 'lastRestockedById': lastRestockedById,
      if (lastDeductedAt != null) 'lastDeductedAt': lastDeductedAt?.toJson(),
      if (lastDeductedByName != null) 'lastDeductedByName': lastDeductedByName,
      if (lastDeductedById != null) 'lastDeductedById': lastDeductedById,
      'createdAt': createdAt.toJson(),
      'lastModifiedAt': lastModifiedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'workspaceId': workspaceId,
      'catalogId': catalogId,
      if (catalog != null) 'catalog': catalog?.toJsonForProtocol(),
      'currentQty': currentQty,
      'availableQty': availableQty,
      'totalValue': totalValue,
      if (location != null) 'location': location,
      if (lowStockThreshold != null) 'lowStockThreshold': lowStockThreshold,
      if (lastRestockedAt != null) 'lastRestockedAt': lastRestockedAt?.toJson(),
      if (lastRestockedByName != null)
        'lastRestockedByName': lastRestockedByName,
      if (lastRestockedById != null) 'lastRestockedById': lastRestockedById,
      if (lastDeductedAt != null) 'lastDeductedAt': lastDeductedAt?.toJson(),
      if (lastDeductedByName != null) 'lastDeductedByName': lastDeductedByName,
      if (lastDeductedById != null) 'lastDeductedById': lastDeductedById,
      'createdAt': createdAt.toJson(),
      'lastModifiedAt': lastModifiedAt.toJson(),
    };
  }

  static InventoryInclude include({_i2.CatalogInclude? catalog}) {
    return InventoryInclude._(catalog: catalog);
  }

  static InventoryIncludeList includeList({
    _i1.WhereExpressionBuilder<InventoryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<InventoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<InventoryTable>? orderByList,
    InventoryInclude? include,
  }) {
    return InventoryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Inventory.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Inventory.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _InventoryImpl extends Inventory {
  _InventoryImpl({
    int? id,
    required int workspaceId,
    required int catalogId,
    _i2.Catalog? catalog,
    required double currentQty,
    required double availableQty,
    required int totalValue,
    String? location,
    double? lowStockThreshold,
    DateTime? lastRestockedAt,
    String? lastRestockedByName,
    int? lastRestockedById,
    DateTime? lastDeductedAt,
    String? lastDeductedByName,
    int? lastDeductedById,
    required DateTime createdAt,
    required DateTime lastModifiedAt,
  }) : super._(
          id: id,
          workspaceId: workspaceId,
          catalogId: catalogId,
          catalog: catalog,
          currentQty: currentQty,
          availableQty: availableQty,
          totalValue: totalValue,
          location: location,
          lowStockThreshold: lowStockThreshold,
          lastRestockedAt: lastRestockedAt,
          lastRestockedByName: lastRestockedByName,
          lastRestockedById: lastRestockedById,
          lastDeductedAt: lastDeductedAt,
          lastDeductedByName: lastDeductedByName,
          lastDeductedById: lastDeductedById,
          createdAt: createdAt,
          lastModifiedAt: lastModifiedAt,
        );

  /// Returns a shallow copy of this [Inventory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Inventory copyWith({
    Object? id = _Undefined,
    int? workspaceId,
    int? catalogId,
    Object? catalog = _Undefined,
    double? currentQty,
    double? availableQty,
    int? totalValue,
    Object? location = _Undefined,
    Object? lowStockThreshold = _Undefined,
    Object? lastRestockedAt = _Undefined,
    Object? lastRestockedByName = _Undefined,
    Object? lastRestockedById = _Undefined,
    Object? lastDeductedAt = _Undefined,
    Object? lastDeductedByName = _Undefined,
    Object? lastDeductedById = _Undefined,
    DateTime? createdAt,
    DateTime? lastModifiedAt,
  }) {
    return Inventory(
      id: id is int? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      catalogId: catalogId ?? this.catalogId,
      catalog: catalog is _i2.Catalog? ? catalog : this.catalog?.copyWith(),
      currentQty: currentQty ?? this.currentQty,
      availableQty: availableQty ?? this.availableQty,
      totalValue: totalValue ?? this.totalValue,
      location: location is String? ? location : this.location,
      lowStockThreshold: lowStockThreshold is double?
          ? lowStockThreshold
          : this.lowStockThreshold,
      lastRestockedAt:
          lastRestockedAt is DateTime? ? lastRestockedAt : this.lastRestockedAt,
      lastRestockedByName: lastRestockedByName is String?
          ? lastRestockedByName
          : this.lastRestockedByName,
      lastRestockedById: lastRestockedById is int?
          ? lastRestockedById
          : this.lastRestockedById,
      lastDeductedAt:
          lastDeductedAt is DateTime? ? lastDeductedAt : this.lastDeductedAt,
      lastDeductedByName: lastDeductedByName is String?
          ? lastDeductedByName
          : this.lastDeductedByName,
      lastDeductedById:
          lastDeductedById is int? ? lastDeductedById : this.lastDeductedById,
      createdAt: createdAt ?? this.createdAt,
      lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
    );
  }
}

class InventoryTable extends _i1.Table<int?> {
  InventoryTable({super.tableRelation}) : super(tableName: 'inventory') {
    workspaceId = _i1.ColumnInt(
      'workspaceId',
      this,
    );
    catalogId = _i1.ColumnInt(
      'catalogId',
      this,
    );
    currentQty = _i1.ColumnDouble(
      'currentQty',
      this,
    );
    availableQty = _i1.ColumnDouble(
      'availableQty',
      this,
    );
    totalValue = _i1.ColumnInt(
      'totalValue',
      this,
    );
    location = _i1.ColumnString(
      'location',
      this,
    );
    lowStockThreshold = _i1.ColumnDouble(
      'lowStockThreshold',
      this,
    );
    lastRestockedAt = _i1.ColumnDateTime(
      'lastRestockedAt',
      this,
    );
    lastRestockedByName = _i1.ColumnString(
      'lastRestockedByName',
      this,
    );
    lastRestockedById = _i1.ColumnInt(
      'lastRestockedById',
      this,
    );
    lastDeductedAt = _i1.ColumnDateTime(
      'lastDeductedAt',
      this,
    );
    lastDeductedByName = _i1.ColumnString(
      'lastDeductedByName',
      this,
    );
    lastDeductedById = _i1.ColumnInt(
      'lastDeductedById',
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

  late final _i1.ColumnInt catalogId;

  _i2.CatalogTable? _catalog;

  late final _i1.ColumnDouble currentQty;

  late final _i1.ColumnDouble availableQty;

  late final _i1.ColumnInt totalValue;

  late final _i1.ColumnString location;

  late final _i1.ColumnDouble lowStockThreshold;

  late final _i1.ColumnDateTime lastRestockedAt;

  late final _i1.ColumnString lastRestockedByName;

  late final _i1.ColumnInt lastRestockedById;

  late final _i1.ColumnDateTime lastDeductedAt;

  late final _i1.ColumnString lastDeductedByName;

  late final _i1.ColumnInt lastDeductedById;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime lastModifiedAt;

  _i2.CatalogTable get catalog {
    if (_catalog != null) return _catalog!;
    _catalog = _i1.createRelationTable(
      relationFieldName: 'catalog',
      field: Inventory.t.catalogId,
      foreignField: _i2.Catalog.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.CatalogTable(tableRelation: foreignTableRelation),
    );
    return _catalog!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        workspaceId,
        catalogId,
        currentQty,
        availableQty,
        totalValue,
        location,
        lowStockThreshold,
        lastRestockedAt,
        lastRestockedByName,
        lastRestockedById,
        lastDeductedAt,
        lastDeductedByName,
        lastDeductedById,
        createdAt,
        lastModifiedAt,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'catalog') {
      return catalog;
    }
    return null;
  }
}

class InventoryInclude extends _i1.IncludeObject {
  InventoryInclude._({_i2.CatalogInclude? catalog}) {
    _catalog = catalog;
  }

  _i2.CatalogInclude? _catalog;

  @override
  Map<String, _i1.Include?> get includes => {'catalog': _catalog};

  @override
  _i1.Table<int?> get table => Inventory.t;
}

class InventoryIncludeList extends _i1.IncludeList {
  InventoryIncludeList._({
    _i1.WhereExpressionBuilder<InventoryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Inventory.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Inventory.t;
}

class InventoryRepository {
  const InventoryRepository._();

  final attachRow = const InventoryAttachRowRepository._();

  /// Returns a list of [Inventory]s matching the given query parameters.
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
  Future<List<Inventory>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<InventoryTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<InventoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<InventoryTable>? orderByList,
    _i1.Transaction? transaction,
    InventoryInclude? include,
  }) async {
    return session.db.find<Inventory>(
      where: where?.call(Inventory.t),
      orderBy: orderBy?.call(Inventory.t),
      orderByList: orderByList?.call(Inventory.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Inventory] matching the given query parameters.
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
  Future<Inventory?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<InventoryTable>? where,
    int? offset,
    _i1.OrderByBuilder<InventoryTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<InventoryTable>? orderByList,
    _i1.Transaction? transaction,
    InventoryInclude? include,
  }) async {
    return session.db.findFirstRow<Inventory>(
      where: where?.call(Inventory.t),
      orderBy: orderBy?.call(Inventory.t),
      orderByList: orderByList?.call(Inventory.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Inventory] by its [id] or null if no such row exists.
  Future<Inventory?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    InventoryInclude? include,
  }) async {
    return session.db.findById<Inventory>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Inventory]s in the list and returns the inserted rows.
  ///
  /// The returned [Inventory]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Inventory>> insert(
    _i1.Session session,
    List<Inventory> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Inventory>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Inventory] and returns the inserted row.
  ///
  /// The returned [Inventory] will have its `id` field set.
  Future<Inventory> insertRow(
    _i1.Session session,
    Inventory row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Inventory>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Inventory]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Inventory>> update(
    _i1.Session session,
    List<Inventory> rows, {
    _i1.ColumnSelections<InventoryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Inventory>(
      rows,
      columns: columns?.call(Inventory.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Inventory]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Inventory> updateRow(
    _i1.Session session,
    Inventory row, {
    _i1.ColumnSelections<InventoryTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Inventory>(
      row,
      columns: columns?.call(Inventory.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Inventory]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Inventory>> delete(
    _i1.Session session,
    List<Inventory> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Inventory>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Inventory].
  Future<Inventory> deleteRow(
    _i1.Session session,
    Inventory row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Inventory>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Inventory>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<InventoryTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Inventory>(
      where: where(Inventory.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<InventoryTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Inventory>(
      where: where?.call(Inventory.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class InventoryAttachRowRepository {
  const InventoryAttachRowRepository._();

  /// Creates a relation between the given [Inventory] and [Catalog]
  /// by setting the [Inventory]'s foreign key `catalogId` to refer to the [Catalog].
  Future<void> catalog(
    _i1.Session session,
    Inventory inventory,
    _i2.Catalog catalog, {
    _i1.Transaction? transaction,
  }) async {
    if (inventory.id == null) {
      throw ArgumentError.notNull('inventory.id');
    }
    if (catalog.id == null) {
      throw ArgumentError.notNull('catalog.id');
    }

    var $inventory = inventory.copyWith(catalogId: catalog.id);
    await session.db.updateRow<Inventory>(
      $inventory,
      columns: [Inventory.t.catalogId],
      transaction: transaction,
    );
  }
}
