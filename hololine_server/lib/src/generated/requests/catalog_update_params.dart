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

abstract class CatalogUpdateParams
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  CatalogUpdateParams._({
    this.name,
    this.type,
    this.sku,
    bool? clearSku,
    this.unit,
    this.category,
    this.weight,
    this.minOrderQty,
    this.price,
    this.currency,
  }) : clearSku = clearSku ?? false;

  factory CatalogUpdateParams({
    String? name,
    String? type,
    String? sku,
    bool? clearSku,
    String? unit,
    String? category,
    double? weight,
    double? minOrderQty,
    int? price,
    String? currency,
  }) = _CatalogUpdateParamsImpl;

  factory CatalogUpdateParams.fromJson(Map<String, dynamic> jsonSerialization) {
    return CatalogUpdateParams(
      name: jsonSerialization['name'] as String?,
      type: jsonSerialization['type'] as String?,
      sku: jsonSerialization['sku'] as String?,
      clearSku: jsonSerialization['clearSku'] as bool,
      unit: jsonSerialization['unit'] as String?,
      category: jsonSerialization['category'] as String?,
      weight: (jsonSerialization['weight'] as num?)?.toDouble(),
      minOrderQty: (jsonSerialization['minOrderQty'] as num?)?.toDouble(),
      price: jsonSerialization['price'] as int?,
      currency: jsonSerialization['currency'] as String?,
    );
  }

  String? name;

  String? type;

  String? sku;

  bool clearSku;

  String? unit;

  String? category;

  double? weight;

  double? minOrderQty;

  int? price;

  String? currency;

  /// Returns a shallow copy of this [CatalogUpdateParams]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CatalogUpdateParams copyWith({
    String? name,
    String? type,
    String? sku,
    bool? clearSku,
    String? unit,
    String? category,
    double? weight,
    double? minOrderQty,
    int? price,
    String? currency,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (sku != null) 'sku': sku,
      'clearSku': clearSku,
      if (unit != null) 'unit': unit,
      if (category != null) 'category': category,
      if (weight != null) 'weight': weight,
      if (minOrderQty != null) 'minOrderQty': minOrderQty,
      if (price != null) 'price': price,
      if (currency != null) 'currency': currency,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (sku != null) 'sku': sku,
      'clearSku': clearSku,
      if (unit != null) 'unit': unit,
      if (category != null) 'category': category,
      if (weight != null) 'weight': weight,
      if (minOrderQty != null) 'minOrderQty': minOrderQty,
      if (price != null) 'price': price,
      if (currency != null) 'currency': currency,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CatalogUpdateParamsImpl extends CatalogUpdateParams {
  _CatalogUpdateParamsImpl({
    String? name,
    String? type,
    String? sku,
    bool? clearSku,
    String? unit,
    String? category,
    double? weight,
    double? minOrderQty,
    int? price,
    String? currency,
  }) : super._(
          name: name,
          type: type,
          sku: sku,
          clearSku: clearSku,
          unit: unit,
          category: category,
          weight: weight,
          minOrderQty: minOrderQty,
          price: price,
          currency: currency,
        );

  /// Returns a shallow copy of this [CatalogUpdateParams]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CatalogUpdateParams copyWith({
    Object? name = _Undefined,
    Object? type = _Undefined,
    Object? sku = _Undefined,
    bool? clearSku,
    Object? unit = _Undefined,
    Object? category = _Undefined,
    Object? weight = _Undefined,
    Object? minOrderQty = _Undefined,
    Object? price = _Undefined,
    Object? currency = _Undefined,
  }) {
    return CatalogUpdateParams(
      name: name is String? ? name : this.name,
      type: type is String? ? type : this.type,
      sku: sku is String? ? sku : this.sku,
      clearSku: clearSku ?? this.clearSku,
      unit: unit is String? ? unit : this.unit,
      category: category is String? ? category : this.category,
      weight: weight is double? ? weight : this.weight,
      minOrderQty: minOrderQty is double? ? minOrderQty : this.minOrderQty,
      price: price is int? ? price : this.price,
      currency: currency is String? ? currency : this.currency,
    );
  }
}
