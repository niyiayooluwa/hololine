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
import 'ledger.dart' as _i2;

abstract class LedgerLineItem implements _i1.SerializableModel {
  LedgerLineItem._({
    this.id,
    required this.workspaceId,
    required this.ledgerId,
    this.ledger,
    required this.catalogId,
    required this.catalogName,
    this.catalogSku,
    required this.unitPrice,
    required this.quantity,
    required this.unit,
    String? currency,
    required this.subtotal,
    int? position,
    required this.createdAt,
  })  : currency = currency ?? 'NGN',
        position = position ?? 0;

  factory LedgerLineItem({
    int? id,
    required int workspaceId,
    required int ledgerId,
    _i2.Ledger? ledger,
    required int catalogId,
    required String catalogName,
    String? catalogSku,
    required int unitPrice,
    required double quantity,
    required String unit,
    String? currency,
    required int subtotal,
    int? position,
    required DateTime createdAt,
  }) = _LedgerLineItemImpl;

  factory LedgerLineItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return LedgerLineItem(
      id: jsonSerialization['id'] as int?,
      workspaceId: jsonSerialization['workspaceId'] as int,
      ledgerId: jsonSerialization['ledgerId'] as int,
      ledger: jsonSerialization['ledger'] == null
          ? null
          : _i2.Ledger.fromJson(
              (jsonSerialization['ledger'] as Map<String, dynamic>)),
      catalogId: jsonSerialization['catalogId'] as int,
      catalogName: jsonSerialization['catalogName'] as String,
      catalogSku: jsonSerialization['catalogSku'] as String?,
      unitPrice: jsonSerialization['unitPrice'] as int,
      quantity: (jsonSerialization['quantity'] as num).toDouble(),
      unit: jsonSerialization['unit'] as String,
      currency: jsonSerialization['currency'] as String,
      subtotal: jsonSerialization['subtotal'] as int,
      position: jsonSerialization['position'] as int,
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

  _i2.Ledger? ledger;

  int catalogId;

  String catalogName;

  String? catalogSku;

  int unitPrice;

  double quantity;

  String unit;

  String currency;

  int subtotal;

  int position;

  DateTime createdAt;

  /// Returns a shallow copy of this [LedgerLineItem]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  LedgerLineItem copyWith({
    int? id,
    int? workspaceId,
    int? ledgerId,
    _i2.Ledger? ledger,
    int? catalogId,
    String? catalogName,
    String? catalogSku,
    int? unitPrice,
    double? quantity,
    String? unit,
    String? currency,
    int? subtotal,
    int? position,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'workspaceId': workspaceId,
      'ledgerId': ledgerId,
      if (ledger != null) 'ledger': ledger?.toJson(),
      'catalogId': catalogId,
      'catalogName': catalogName,
      if (catalogSku != null) 'catalogSku': catalogSku,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'unit': unit,
      'currency': currency,
      'subtotal': subtotal,
      'position': position,
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
    _i2.Ledger? ledger,
    required int catalogId,
    required String catalogName,
    String? catalogSku,
    required int unitPrice,
    required double quantity,
    required String unit,
    String? currency,
    required int subtotal,
    int? position,
    required DateTime createdAt,
  }) : super._(
          id: id,
          workspaceId: workspaceId,
          ledgerId: ledgerId,
          ledger: ledger,
          catalogId: catalogId,
          catalogName: catalogName,
          catalogSku: catalogSku,
          unitPrice: unitPrice,
          quantity: quantity,
          unit: unit,
          currency: currency,
          subtotal: subtotal,
          position: position,
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
    Object? ledger = _Undefined,
    int? catalogId,
    String? catalogName,
    Object? catalogSku = _Undefined,
    int? unitPrice,
    double? quantity,
    String? unit,
    String? currency,
    int? subtotal,
    int? position,
    DateTime? createdAt,
  }) {
    return LedgerLineItem(
      id: id is int? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      ledgerId: ledgerId ?? this.ledgerId,
      ledger: ledger is _i2.Ledger? ? ledger : this.ledger?.copyWith(),
      catalogId: catalogId ?? this.catalogId,
      catalogName: catalogName ?? this.catalogName,
      catalogSku: catalogSku is String? ? catalogSku : this.catalogSku,
      unitPrice: unitPrice ?? this.unitPrice,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      currency: currency ?? this.currency,
      subtotal: subtotal ?? this.subtotal,
      position: position ?? this.position,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
