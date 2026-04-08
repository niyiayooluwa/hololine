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

abstract class Catalog implements _i1.SerializableModel {
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
    int? minOrderQty,
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
      minOrderQty: jsonSerialization['minOrderQty'] as int?,
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int workspaceId;

  String name;

  String type;

  String? sku;

  String unit;

  String? category;

  double? weight;

  int? minOrderQty;

  int price;

  String currency;

  String status;

  String addedByName;

  int? addedById;

  DateTime createdAt;

  DateTime lastModifiedAt;

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
    int? minOrderQty,
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
    int? minOrderQty,
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
      minOrderQty: minOrderQty is int? ? minOrderQty : this.minOrderQty,
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
