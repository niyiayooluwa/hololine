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
import '../workspace_role.dart' as _i2;

abstract class WorkspaceSummary implements _i1.SerializableModel {
  WorkspaceSummary._({
    required this.id,
    required this.publicId,
    required this.name,
    required this.description,
    required this.memberCount,
    required this.lastActive,
    required this.role,
  });

  factory WorkspaceSummary({
    required int id,
    required String publicId,
    required String name,
    required String description,
    required int memberCount,
    required DateTime lastActive,
    required _i2.WorkspaceRole role,
  }) = _WorkspaceSummaryImpl;

  factory WorkspaceSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkspaceSummary(
      id: jsonSerialization['id'] as int,
      publicId: jsonSerialization['publicId'] as String,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      memberCount: jsonSerialization['memberCount'] as int,
      lastActive:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['lastActive']),
      role: _i2.WorkspaceRole.fromJson((jsonSerialization['role'] as int)),
    );
  }

  int id;

  String publicId;

  String name;

  String description;

  int memberCount;

  DateTime lastActive;

  _i2.WorkspaceRole role;

  /// Returns a shallow copy of this [WorkspaceSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  WorkspaceSummary copyWith({
    int? id,
    String? publicId,
    String? name,
    String? description,
    int? memberCount,
    DateTime? lastActive,
    _i2.WorkspaceRole? role,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'publicId': publicId,
      'name': name,
      'description': description,
      'memberCount': memberCount,
      'lastActive': lastActive.toJson(),
      'role': role.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _WorkspaceSummaryImpl extends WorkspaceSummary {
  _WorkspaceSummaryImpl({
    required int id,
    required String publicId,
    required String name,
    required String description,
    required int memberCount,
    required DateTime lastActive,
    required _i2.WorkspaceRole role,
  }) : super._(
          id: id,
          publicId: publicId,
          name: name,
          description: description,
          memberCount: memberCount,
          lastActive: lastActive,
          role: role,
        );

  /// Returns a shallow copy of this [WorkspaceSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  WorkspaceSummary copyWith({
    int? id,
    String? publicId,
    String? name,
    String? description,
    int? memberCount,
    DateTime? lastActive,
    _i2.WorkspaceRole? role,
  }) {
    return WorkspaceSummary(
      id: id ?? this.id,
      publicId: publicId ?? this.publicId,
      name: name ?? this.name,
      description: description ?? this.description,
      memberCount: memberCount ?? this.memberCount,
      lastActive: lastActive ?? this.lastActive,
      role: role ?? this.role,
    );
  }
}
