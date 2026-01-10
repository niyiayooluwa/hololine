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
import 'responses/response.dart' as _i2;
import 'workspace.dart' as _i3;
import 'workspace_invitation.dart' as _i4;
import 'workspace_member.dart' as _i5;
import 'workspace_role.dart' as _i6;
import 'package:hololine_client/src/protocol/workspace.dart' as _i7;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i8;
export 'responses/response.dart';
export 'workspace.dart';
export 'workspace_invitation.dart';
export 'workspace_member.dart';
export 'workspace_role.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i2.Response) {
      return _i2.Response.fromJson(data) as T;
    }
    if (t == _i3.Workspace) {
      return _i3.Workspace.fromJson(data) as T;
    }
    if (t == _i4.WorkspaceInvitation) {
      return _i4.WorkspaceInvitation.fromJson(data) as T;
    }
    if (t == _i5.WorkspaceMember) {
      return _i5.WorkspaceMember.fromJson(data) as T;
    }
    if (t == _i6.WorkspaceRole) {
      return _i6.WorkspaceRole.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Response?>()) {
      return (data != null ? _i2.Response.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.Workspace?>()) {
      return (data != null ? _i3.Workspace.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.WorkspaceInvitation?>()) {
      return (data != null ? _i4.WorkspaceInvitation.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i5.WorkspaceMember?>()) {
      return (data != null ? _i5.WorkspaceMember.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.WorkspaceRole?>()) {
      return (data != null ? _i6.WorkspaceRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<List<_i5.WorkspaceMember>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i5.WorkspaceMember>(e))
              .toList()
          : null) as T;
    }
    if (t == List<_i7.Workspace>) {
      return (data as List).map((e) => deserialize<_i7.Workspace>(e)).toList()
          as T;
    }
    try {
      return _i8.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.Response) {
      return 'Response';
    }
    if (data is _i3.Workspace) {
      return 'Workspace';
    }
    if (data is _i4.WorkspaceInvitation) {
      return 'WorkspaceInvitation';
    }
    if (data is _i5.WorkspaceMember) {
      return 'WorkspaceMember';
    }
    if (data is _i6.WorkspaceRole) {
      return 'WorkspaceRole';
    }
    className = _i8.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Response') {
      return deserialize<_i2.Response>(data['data']);
    }
    if (dataClassName == 'Workspace') {
      return deserialize<_i3.Workspace>(data['data']);
    }
    if (dataClassName == 'WorkspaceInvitation') {
      return deserialize<_i4.WorkspaceInvitation>(data['data']);
    }
    if (dataClassName == 'WorkspaceMember') {
      return deserialize<_i5.WorkspaceMember>(data['data']);
    }
    if (dataClassName == 'WorkspaceRole') {
      return deserialize<_i6.WorkspaceRole>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i8.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
