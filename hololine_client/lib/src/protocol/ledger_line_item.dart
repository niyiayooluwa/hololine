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

abstract class LedgerLineItem implements _i1.SerializableModel {
  LedgerLineItem._({
    this.id,
    required this.workspaceId,
    required this.ledgerId,
    required this.catalogId,
    required this.catalogName,
    this.catalogSku,
    required this.unitPrice,
    required this.quantity,
    required this.unit,
    required this.subtotal,
    required this.createdAt,
  });

  factory LedgerLineItem({
    int? id,
    required int workspaceId,
    required int ledgerId,
    required int catalogId,
    required String catalogName,
    String? catalogSku,
    required double unitPrice,
    required double quantity,
    required String unit,
    required double subtotal,
    required DateTime createdAt,
  }) = _LedgerLineItemImpl;

  factory LedgerLineItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return LedgerLineItem(
      id: jsonSerialization['id'] as int?,
      workspaceId: jsonSerialization['workspaceId'] as int,
      ledgerId: jsonSerialization['ledgerId'] as int,
      catalogId: jsonSerialization['catalogId'] as int,
      catalogName: jsonSerialization['catalogName'] as String,
      catalogSku: jsonSerialization['catalogSku'] as String?,
      unitPrice: (jsonSerialization['unitPrice'] as num).toDouble(),
      quantity: (jsonSerialization['quantity'] as num).toDouble(),
      unit: jsonSerialization['unit'] as String,
      subtotal: (jsonSerialization['subtotal'] as num).toDouble(),
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int workspaceId;

  int ledgerId;

  int catalogId;

  String catalogName;

  String? catalogSku;

  double unitPrice;

  double quantity;

  String unit;

  double subtotal;

  DateTime createdAt;

  /// Returns a shallow copy of this [LedgerLineItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LedgerLineItem copyWith({
    int? id,
    int? workspaceId,
    int? ledgerId,
    int? catalogId,
    String? catalogName,
    String? catalogSku,
    double? unitPrice,
    double? quantity,
    String? unit,
    double? subtotal,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'workspaceId': workspaceId,
      'ledgerId': ledgerId,
      'catalogId': catalogId,
      'catalogName': catalogName,
      if (catalogSku != null) 'catalogSku': catalogSku,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'unit': unit,
      'subtotal': subtotal,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _LedgerLineItemImpl extends LedgerLineItem {
  _LedgerLineItemImpl({
    int? id,
    required int workspaceId,
    required int ledgerId,
    required int catalogId,
    required String catalogName,
    String? catalogSku,
    required double unitPrice,
    required double quantity,
    required String unit,
    required double subtotal,
    required DateTime createdAt,
  }) : super._(
          id: id,
          workspaceId: workspaceId,
          ledgerId: ledgerId,
          catalogId: catalogId,
          catalogName: catalogName,
          catalogSku: catalogSku,
          unitPrice: unitPrice,
          quantity: quantity,
          unit: unit,
          subtotal: subtotal,
          createdAt: createdAt,
        );

  /// Returns a shallow copy of this [LedgerLineItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  LedgerLineItem copyWith({
    Object? id = _Undefined,
    int? workspaceId,
    int? ledgerId,
    int? catalogId,
    String? catalogName,
    Object? catalogSku = _Undefined,
    double? unitPrice,
    double? quantity,
    String? unit,
    double? subtotal,
    DateTime? createdAt,
  }) {
    return LedgerLineItem(
      id: id is int? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      ledgerId: ledgerId ?? this.ledgerId,
      catalogId: catalogId ?? this.catalogId,
      catalogName: catalogName ?? this.catalogName,
      catalogSku: catalogSku is String? ? catalogSku : this.catalogSku,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      subtotal: subtotal ?? this.subtotal,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
