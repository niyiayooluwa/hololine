/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'responses/response.dart' as _i2;
import 'responses/workspace_summary.dart' as _i3;
import 'workspace.dart' as _i4;
import 'workspace_invitation.dart' as _i5;
import 'workspace_member.dart' as _i6;
import 'workspace_role.dart' as _i7;
import 'package:hololine_client/src/protocol/responses/workspace_summary.dart'
    as _i8;
import 'package:hololine_client/src/protocol/workspace.dart' as _i9;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i10;
export 'responses/response.dart';
export 'responses/workspace_summary.dart';
export 'workspace.dart';
export 'workspace_invitation.dart';
export 'workspace_member.dart';
export 'workspace_role.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i2.Response) {
      return _i2.Response.fromJson(data) as T;
    }
    if (t == _i3.WorkspaceSummary) {
      return _i3.WorkspaceSummary.fromJson(data) as T;
    }
    if (t == _i4.Workspace) {
      return _i4.Workspace.fromJson(data) as T;
    }
    if (t == _i5.WorkspaceInvitation) {
      return _i5.WorkspaceInvitation.fromJson(data) as T;
    }
    if (t == _i6.WorkspaceMember) {
      return _i6.WorkspaceMember.fromJson(data) as T;
    }
    if (t == _i7.WorkspaceRole) {
      return _i7.WorkspaceRole.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Response?>()) {
      return (data != null ? _i2.Response.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.WorkspaceSummary?>()) {
      return (data != null ? _i3.WorkspaceSummary.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.Workspace?>()) {
      return (data != null ? _i4.Workspace.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.WorkspaceInvitation?>()) {
      return (data != null ? _i5.WorkspaceInvitation.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i6.WorkspaceMember?>()) {
      return (data != null ? _i6.WorkspaceMember.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.WorkspaceRole?>()) {
      return (data != null ? _i7.WorkspaceRole.fromJson(data) : null) as T;
    }
    if (t == List<_i6.WorkspaceMember>) {
      return (data as List)
              .map((e) => deserialize<_i6.WorkspaceMember>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i6.WorkspaceMember>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i6.WorkspaceMember>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i8.WorkspaceSummary>) {
      return (data as List)
              .map((e) => deserialize<_i8.WorkspaceSummary>(e))
              .toList()
          as T;
    }
    if (t == List<_i9.Workspace>) {
      return (data as List).map((e) => deserialize<_i9.Workspace>(e)).toList()
          as T;
    }
    try {
      return _i10.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.Response => 'Response',
      _i3.WorkspaceSummary => 'WorkspaceSummary',
      _i4.Workspace => 'Workspace',
      _i5.WorkspaceInvitation => 'WorkspaceInvitation',
      _i6.WorkspaceMember => 'WorkspaceMember',
      _i7.WorkspaceRole => 'WorkspaceRole',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('hololine.', '');
    }

    switch (data) {
      case _i2.Response():
        return 'Response';
      case _i3.WorkspaceSummary():
        return 'WorkspaceSummary';
      case _i4.Workspace():
        return 'Workspace';
      case _i5.WorkspaceInvitation():
        return 'WorkspaceInvitation';
      case _i6.WorkspaceMember():
        return 'WorkspaceMember';
      case _i7.WorkspaceRole():
        return 'WorkspaceRole';
    }
    className = _i10.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'WorkspaceSummary') {
      return deserialize<_i3.WorkspaceSummary>(data['data']);
    }
    if (dataClassName == 'Workspace') {
      return deserialize<_i4.Workspace>(data['data']);
    }
    if (dataClassName == 'WorkspaceInvitation') {
      return deserialize<_i5.WorkspaceInvitation>(data['data']);
    }
    if (dataClassName == 'WorkspaceMember') {
      return deserialize<_i6.WorkspaceMember>(data['data']);
    }
    if (dataClassName == 'WorkspaceRole') {
      return deserialize<_i7.WorkspaceRole>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i10.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i10.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
