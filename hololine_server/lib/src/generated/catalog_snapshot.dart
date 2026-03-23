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

abstract class CatalogSnapshot
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  CatalogSnapshot._({
    required this.totalItems,
    this.lastProductName,
    this.lastProductDate,
  });

  factory CatalogSnapshot({
    required int totalItems,
    String? lastProductName,
    DateTime? lastProductDate,
  }) = _CatalogSnapshotImpl;

  factory CatalogSnapshot.fromJson(Map<String, dynamic> jsonSerialization) {
    return CatalogSnapshot(
      totalItems: jsonSerialization['totalItems'] as int,
      lastProductName: jsonSerialization['lastProductName'] as String?,
      lastProductDate: jsonSerialization['lastProductDate'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastProductDate']),
    );
  }

  int totalItems;

  String? lastProductName;

  DateTime? lastProductDate;

  /// Returns a shallow copy of this [CatalogSnapshot]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CatalogSnapshot copyWith({
    int? totalItems,
    String? lastProductName,
    DateTime? lastProductDate,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'totalItems': totalItems,
      if (lastProductName != null) 'lastProductName': lastProductName,
      if (lastProductDate != null) 'lastProductDate': lastProductDate?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'totalItems': totalItems,
      if (lastProductName != null) 'lastProductName': lastProductName,
      if (lastProductDate != null) 'lastProductDate': lastProductDate?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CatalogSnapshotImpl extends CatalogSnapshot {
  _CatalogSnapshotImpl({
    required int totalItems,
    String? lastProductName,
    DateTime? lastProductDate,
  }) : super._(
          totalItems: totalItems,
          lastProductName: lastProductName,
          lastProductDate: lastProductDate,
        );

  /// Returns a shallow copy of this [CatalogSnapshot]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CatalogSnapshot copyWith({
    int? totalItems,
    Object? lastProductName = _Undefined,
    Object? lastProductDate = _Undefined,
  }) {
    return CatalogSnapshot(
      totalItems: totalItems ?? this.totalItems,
      lastProductName:
          lastProductName is String? ? lastProductName : this.lastProductName,
      lastProductDate:
          lastProductDate is DateTime? ? lastProductDate : this.lastProductDate,
    );
  }
}
