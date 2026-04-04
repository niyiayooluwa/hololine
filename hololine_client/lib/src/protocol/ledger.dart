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

abstract class Ledger implements _i1.SerializableModel {
  Ledger._({
    this.id,
    required this.workspaceId,
    this.referenceNumber,
    required this.transactionType,
    required this.paymentStatus,
    required this.totalAmount,
    this.notes,
    required this.transactionAt,
    required this.createdByName,
    this.createdById,
    this.counterpartyName,
    required this.createdAt,
    required this.lastModifiedAt,
  });

  factory Ledger({
    int? id,
    required int workspaceId,
    String? referenceNumber,
    required String transactionType,
    required String paymentStatus,
    required double totalAmount,
    String? notes,
    required DateTime transactionAt,
    required String createdByName,
    int? createdById,
    String? counterpartyName,
    required DateTime createdAt,
    required DateTime lastModifiedAt,
  }) = _LedgerImpl;

  factory Ledger.fromJson(Map<String, dynamic> jsonSerialization) {
    return Ledger(
      id: jsonSerialization['id'] as int?,
      workspaceId: jsonSerialization['workspaceId'] as int,
      referenceNumber: jsonSerialization['referenceNumber'] as String?,
      transactionType: jsonSerialization['transactionType'] as String,
      paymentStatus: jsonSerialization['paymentStatus'] as String,
      totalAmount: (jsonSerialization['totalAmount'] as num).toDouble(),
      notes: jsonSerialization['notes'] as String?,
      transactionAt: _i1.DateTimeJsonExtension.fromJson(
          jsonSerialization['transactionAt']),
      createdByName: jsonSerialization['createdByName'] as String,
      createdById: jsonSerialization['createdById'] as int?,
      counterpartyName: jsonSerialization['counterpartyName'] as String?,
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

  String? referenceNumber;

  String transactionType;

  String paymentStatus;

  double totalAmount;

  String? notes;

  DateTime transactionAt;

  String createdByName;

  int? createdById;

  String? counterpartyName;

  DateTime createdAt;

  DateTime lastModifiedAt;

  /// Returns a shallow copy of this [Ledger]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Ledger copyWith({
    int? id,
    int? workspaceId,
    String? referenceNumber,
    String? transactionType,
    String? paymentStatus,
    double? totalAmount,
    String? notes,
    DateTime? transactionAt,
    String? createdByName,
    int? createdById,
    String? counterpartyName,
    DateTime? createdAt,
    DateTime? lastModifiedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'workspaceId': workspaceId,
      if (referenceNumber != null) 'referenceNumber': referenceNumber,
      'transactionType': transactionType,
      'paymentStatus': paymentStatus,
      'totalAmount': totalAmount,
      if (notes != null) 'notes': notes,
      'transactionAt': transactionAt.toJson(),
      'createdByName': createdByName,
      if (createdById != null) 'createdById': createdById,
      if (counterpartyName != null) 'counterpartyName': counterpartyName,
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

class _LedgerImpl extends Ledger {
  _LedgerImpl({
    int? id,
    required int workspaceId,
    String? referenceNumber,
    required String transactionType,
    required String paymentStatus,
    required double totalAmount,
    String? notes,
    required DateTime transactionAt,
    required String createdByName,
    int? createdById,
    String? counterpartyName,
    required DateTime createdAt,
    required DateTime lastModifiedAt,
  }) : super._(
          id: id,
          workspaceId: workspaceId,
          referenceNumber: referenceNumber,
          transactionType: transactionType,
          paymentStatus: paymentStatus,
          totalAmount: totalAmount,
          notes: notes,
          transactionAt: transactionAt,
          createdByName: createdByName,
          createdById: createdById,
          counterpartyName: counterpartyName,
          createdAt: createdAt,
          lastModifiedAt: lastModifiedAt,
        );

  /// Returns a shallow copy of this [Ledger]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Ledger copyWith({
    Object? id = _Undefined,
    int? workspaceId,
    Object? referenceNumber = _Undefined,
    String? transactionType,
    String? paymentStatus,
    double? totalAmount,
    Object? notes = _Undefined,
    DateTime? transactionAt,
    String? createdByName,
    Object? createdById = _Undefined,
    Object? counterpartyName = _Undefined,
    DateTime? createdAt,
    DateTime? lastModifiedAt,
  }) {
    return Ledger(
      id: id is int? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      referenceNumber:
          referenceNumber is String? ? referenceNumber : this.referenceNumber,
      transactionType: transactionType ?? this.transactionType,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      totalAmount: totalAmount ?? this.totalAmount,
      notes: notes is String? ? notes : this.notes,
      transactionAt: transactionAt ?? this.transactionAt,
      createdByName: createdByName ?? this.createdByName,
      createdById: createdById is int? ? createdById : this.createdById,
      counterpartyName: counterpartyName is String?
          ? counterpartyName
          : this.counterpartyName,
      createdAt: createdAt ?? this.createdAt,
      lastModifiedAt: lastModifiedAt ?? this.lastModifiedAt,
    );
  }
}
