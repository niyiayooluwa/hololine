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

abstract class WorkspaceInvitation implements _i1.SerializableModel {
  WorkspaceInvitation._({
    this.id,
    required this.workspaceId,
    required this.inviteeEmail,
    required this.inviterId,
    required this.role,
    required this.token,
    required this.expiresAt,
    this.acceptedAt,
  });

  factory WorkspaceInvitation({
    int? id,
    required int workspaceId,
    required String inviteeEmail,
    required int inviterId,
    required _i2.WorkspaceRole role,
    required String token,
    required DateTime expiresAt,
    DateTime? acceptedAt,
  }) = _WorkspaceInvitationImpl;

  factory WorkspaceInvitation.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkspaceInvitation(
      id: jsonSerialization['id'] as int?,
      workspaceId: jsonSerialization['workspaceId'] as int,
      inviteeEmail: jsonSerialization['inviteeEmail'] as String,
      inviterId: jsonSerialization['inviterId'] as int,
      role: _i2.WorkspaceRole.fromJson((jsonSerialization['role'] as int)),
      token: jsonSerialization['token'] as String,
      expiresAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      acceptedAt: jsonSerialization['acceptedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['acceptedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int workspaceId;

  String inviteeEmail;

  int inviterId;

  _i2.WorkspaceRole role;

  String token;

  DateTime expiresAt;

  DateTime? acceptedAt;

  /// Returns a shallow copy of this [WorkspaceInvitation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  WorkspaceInvitation copyWith({
    int? id,
    int? workspaceId,
    String? inviteeEmail,
    int? inviterId,
    _i2.WorkspaceRole? role,
    String? token,
    DateTime? expiresAt,
    DateTime? acceptedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'workspaceId': workspaceId,
      'inviteeEmail': inviteeEmail,
      'inviterId': inviterId,
      'role': role.toJson(),
      'token': token,
      'expiresAt': expiresAt.toJson(),
      if (acceptedAt != null) 'acceptedAt': acceptedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorkspaceInvitationImpl extends WorkspaceInvitation {
  _WorkspaceInvitationImpl({
    int? id,
    required int workspaceId,
    required String inviteeEmail,
    required int inviterId,
    required _i2.WorkspaceRole role,
    required String token,
    required DateTime expiresAt,
    DateTime? acceptedAt,
  }) : super._(
          id: id,
          workspaceId: workspaceId,
          inviteeEmail: inviteeEmail,
          inviterId: inviterId,
          role: role,
          token: token,
          expiresAt: expiresAt,
          acceptedAt: acceptedAt,
        );

  /// Returns a shallow copy of this [WorkspaceInvitation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  WorkspaceInvitation copyWith({
    Object? id = _Undefined,
    int? workspaceId,
    String? inviteeEmail,
    int? inviterId,
    _i2.WorkspaceRole? role,
    String? token,
    DateTime? expiresAt,
    Object? acceptedAt = _Undefined,
  }) {
    return WorkspaceInvitation(
      id: id is int? ? id : this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      inviteeEmail: inviteeEmail ?? this.inviteeEmail,
      inviterId: inviterId ?? this.inviterId,
      role: role ?? this.role,
      token: token ?? this.token,
      expiresAt: expiresAt ?? this.expiresAt,
      acceptedAt: acceptedAt is DateTime? ? acceptedAt : this.acceptedAt,
    );
  }
}
