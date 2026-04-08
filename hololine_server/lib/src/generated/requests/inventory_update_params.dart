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

abstract class InventoryUpdateParams
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  InventoryUpdateParams._({
    this.location,
    this.lowStockThreshold,
  });

  factory InventoryUpdateParams({
    String? location,
    double? lowStockThreshold,
  }) = _InventoryUpdateParamsImpl;

  factory InventoryUpdateParams.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return InventoryUpdateParams(
      location: jsonSerialization['location'] as String?,
      lowStockThreshold:
          (jsonSerialization['lowStockThreshold'] as num?)?.toDouble(),
    );
  }

  String? location;

  double? lowStockThreshold;

  /// Returns a shallow copy of this [InventoryUpdateParams]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  InventoryUpdateParams copyWith({
    String? location,
    double? lowStockThreshold,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (location != null) 'location': location,
      if (lowStockThreshold != null) 'lowStockThreshold': lowStockThreshold,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (location != null) 'location': location,
      if (lowStockThreshold != null) 'lowStockThreshold': lowStockThreshold,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _InventoryUpdateParamsImpl extends InventoryUpdateParams {
  _InventoryUpdateParamsImpl({
    String? location,
    double? lowStockThreshold,
  }) : super._(
          location: location,
          lowStockThreshold: lowStockThreshold,
        );

  /// Returns a shallow copy of this [InventoryUpdateParams]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  InventoryUpdateParams copyWith({
    Object? location = _Undefined,
    Object? lowStockThreshold = _Undefined,
  }) {
    return InventoryUpdateParams(
      location: location is String? ? location : this.location,
      lowStockThreshold: lowStockThreshold is double?
          ? lowStockThreshold
          : this.lowStockThreshold,
    );
  }
}
