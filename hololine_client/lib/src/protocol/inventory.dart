/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class Inventory implements _i1.SerializableModel {
  Inventory._({
    this.id,
    required this.workspaceId,
    required this.catalogId,
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int workspaceId;

  int catalogId;

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

  /// Returns a shallow copy of this [Inventory]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Inventory copyWith({
    int? id,
    int? workspaceId,
    int? catalogId,
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
