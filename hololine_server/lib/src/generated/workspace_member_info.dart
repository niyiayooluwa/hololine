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
import 'workspace_member.dart' as _i2;

abstract class WorkspaceMemberInfo
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  WorkspaceMemberInfo._({
    required this.member,
    required this.userName,
    required this.email,
  });

  factory WorkspaceMemberInfo({
    required _i2.WorkspaceMember member,
    required String userName,
    required String email,
  }) = _WorkspaceMemberInfoImpl;

  factory WorkspaceMemberInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkspaceMemberInfo(
      member: _i2.WorkspaceMember.fromJson(
          (jsonSerialization['member'] as Map<String, dynamic>)),
      userName: jsonSerialization['userName'] as String,
      email: jsonSerialization['email'] as String,
    );
  }

  _i2.WorkspaceMember member;

  String userName;

  String email;

  /// Returns a shallow copy of this [WorkspaceMemberInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  WorkspaceMemberInfo copyWith({
    _i2.WorkspaceMember? member,
    String? userName,
    String? email,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'member': member.toJson(),
      'userName': userName,
      'email': email,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'member': member.toJsonForProtocol(),
      'userName': userName,
      'email': email,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _WorkspaceMemberInfoImpl extends WorkspaceMemberInfo {
  _WorkspaceMemberInfoImpl({
    required _i2.WorkspaceMember member,
    required String userName,
    required String email,
  }) : super._(
          member: member,
          userName: userName,
          email: email,
        );

  /// Returns a shallow copy of this [WorkspaceMemberInfo]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  WorkspaceMemberInfo copyWith({
    _i2.WorkspaceMember? member,
    String? userName,
    String? email,
  }) {
    return WorkspaceMemberInfo(
      member: member ?? this.member.copyWith(),
      userName: userName ?? this.userName,
      email: email ?? this.email,
    );
  }
}
