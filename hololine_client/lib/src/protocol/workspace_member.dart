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
import 'workspace_role.dart' as _i2;

abstract class WorkspaceMember implements _i1.SerializableModel {
  WorkspaceMember._({
    this.id,
    required this.userInfoId,
    required this.workspaceId,
    required this.role,
    this.invitedById,
    required this.joinedAt,
    bool? isActive,
  }) : isActive = isActive ?? true;

  factory WorkspaceMember({
    int? id,
    required int userInfoId,
    required int workspaceId,
    required _i2.WorkspaceRole role,
    int? invitedById,
    required DateTime joinedAt,
    bool? isActive,
  }) = _WorkspaceMemberImpl;

  factory WorkspaceMember.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkspaceMember(
      id: jsonSerialization['id'] as int?,
      userInfoId: jsonSerialization['userInfoId'] as int,
      workspaceId: jsonSerialization['workspaceId'] as int,
      role: _i2.WorkspaceRole.fromJson((jsonSerialization['role'] as int)),
      invitedById: jsonSerialization['invitedById'] as int?,
      joinedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['joinedAt']),
      isActive: jsonSerialization['isActive'] as bool,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int userInfoId;

  int workspaceId;

  _i2.WorkspaceRole role;

  int? invitedById;

  DateTime joinedAt;

  bool isActive;

  /// Returns a shallow copy of this [WorkspaceMember]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  WorkspaceMember copyWith({
    int? id,
    int? userInfoId,
    int? workspaceId,
    _i2.WorkspaceRole? role,
    int? invitedById,
    DateTime? joinedAt,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userInfoId': userInfoId,
      'workspaceId': workspaceId,
      'role': role.toJson(),
      if (invitedById != null) 'invitedById': invitedById,
      'joinedAt': joinedAt.toJson(),
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorkspaceMemberImpl extends WorkspaceMember {
  _WorkspaceMemberImpl({
    int? id,
    required int userInfoId,
    required int workspaceId,
    required _i2.WorkspaceRole role,
    int? invitedById,
    required DateTime joinedAt,
    bool? isActive,
  }) : super._(
          id: id,
          userInfoId: userInfoId,
          workspaceId: workspaceId,
          role: role,
          invitedById: invitedById,
          joinedAt: joinedAt,
          isActive: isActive,
        );

  /// Returns a shallow copy of this [WorkspaceMember]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  WorkspaceMember copyWith({
    Object? id = _Undefined,
    int? userInfoId,
    int? workspaceId,
    _i2.WorkspaceRole? role,
    Object? invitedById = _Undefined,
    DateTime? joinedAt,
    bool? isActive,
  }) {
    return WorkspaceMember(
      id: id is int? ? id : this.id,
      userInfoId: userInfoId ?? this.userInfoId,
      workspaceId: workspaceId ?? this.workspaceId,
      role: role ?? this.role,
      invitedById: invitedById is int? ? invitedById : this.invitedById,
      joinedAt: joinedAt ?? this.joinedAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
