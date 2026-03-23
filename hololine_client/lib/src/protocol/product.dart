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

abstract class Product implements _i1.SerializableModel {
  Product._({
    this.id,
    required this.workspaceId,
    required this.name,
    this.description,
    required this.price,
    required this.createdAt,
  });

  factory Product({
    int? id,
    required int workspaceId,
    required String name,
    String? description,
    required double price,
    required DateTime createdAt,
  }) = _ProductImpl;

  factory Product.fromJson(Map<String, dynamic> jsonSerialization) {
    return Product(
      id: jsonSerialization['id'] as int?,
      workspaceId: jsonSerialization['workspaceId'] as int,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      price: (jsonSerialization['price'] as num).toDouble(),
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int workspaceId;

  String name;

  String? description;

  double price;

  DateTime createdAt;

  /// Returns a shallow copy of this [Product]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Product copyWith({
    int? id,
    int? workspaceId,
    String? name,
    String? description,
    double? price,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'workspaceId': workspaceId,
      'name': name,
      if (description != null) 'description': description,
      'price': price,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProductImpl extends Product {
  _ProductImpl({
    int? id,
    required int workspaceId,
    required String name,
    String? description,
    required double price,
    required DateTime createdAt,
  }) : super._(
          id: id,
          workspaceId: workspaceId,
          name: name,
          description: description,
          price: price,
          createdAt: createdAt,
        );

  /// Returns a shallow copy of this [Product]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Product copyWith({
    Object? id = _Undefined,
    int? workspaceId,
    String? name,
    Object? description = _Undefined,
    double? price,
    DateTime? createdAt,
  }) {
    return Product(
      id: id is int? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      price: price ?? this.price,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
