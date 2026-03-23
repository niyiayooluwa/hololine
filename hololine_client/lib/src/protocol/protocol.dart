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
import 'catalog_snapshot.dart' as _i2;
import 'product.dart' as _i3;
import 'responses/response.dart' as _i4;
import 'responses/workspace_summary.dart' as _i5;
import 'workspace.dart' as _i6;
import 'workspace_dashboard_data.dart' as _i7;
import 'workspace_invitation.dart' as _i8;
import 'workspace_member.dart' as _i9;
import 'workspace_member_info.dart' as _i10;
import 'workspace_role.dart' as _i11;
import 'package:hololine_client/src/protocol/responses/workspace_summary.dart'
    as _i12;
import 'package:hololine_client/src/protocol/workspace.dart' as _i13;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i14;
export 'catalog_snapshot.dart';
export 'product.dart';
export 'responses/response.dart';
export 'responses/workspace_summary.dart';
export 'workspace.dart';
export 'workspace_dashboard_data.dart';
export 'workspace_invitation.dart';
export 'workspace_member.dart';
export 'workspace_member_info.dart';
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
    if (t == _i2.CatalogSnapshot) {
      return _i2.CatalogSnapshot.fromJson(data) as T;
    }
    if (t == _i3.Product) {
      return _i3.Product.fromJson(data) as T;
    }
    if (t == _i4.Response) {
      return _i4.Response.fromJson(data) as T;
    }
    if (t == _i5.WorkspaceSummary) {
      return _i5.WorkspaceSummary.fromJson(data) as T;
    }
    if (t == _i6.Workspace) {
      return _i6.Workspace.fromJson(data) as T;
    }
    if (t == _i7.WorkspaceDashboardData) {
      return _i7.WorkspaceDashboardData.fromJson(data) as T;
    }
    if (t == _i8.WorkspaceInvitation) {
      return _i8.WorkspaceInvitation.fromJson(data) as T;
    }
    if (t == _i9.WorkspaceMember) {
      return _i9.WorkspaceMember.fromJson(data) as T;
    }
    if (t == _i10.WorkspaceMemberInfo) {
      return _i10.WorkspaceMemberInfo.fromJson(data) as T;
    }
    if (t == _i11.WorkspaceRole) {
      return _i11.WorkspaceRole.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.CatalogSnapshot?>()) {
      return (data != null ? _i2.CatalogSnapshot.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.Product?>()) {
      return (data != null ? _i3.Product.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.Response?>()) {
      return (data != null ? _i4.Response.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.WorkspaceSummary?>()) {
      return (data != null ? _i5.WorkspaceSummary.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Workspace?>()) {
      return (data != null ? _i6.Workspace.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.WorkspaceDashboardData?>()) {
      return (data != null ? _i7.WorkspaceDashboardData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.WorkspaceInvitation?>()) {
      return (data != null ? _i8.WorkspaceInvitation.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i9.WorkspaceMember?>()) {
      return (data != null ? _i9.WorkspaceMember.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.WorkspaceMemberInfo?>()) {
      return (data != null ? _i10.WorkspaceMemberInfo.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.WorkspaceRole?>()) {
      return (data != null ? _i11.WorkspaceRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<List<_i9.WorkspaceMember>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i9.WorkspaceMember>(e))
              .toList()
          : null) as T;
    }
    if (t == List<_i10.WorkspaceMemberInfo>) {
      return (data as List)
          .map((e) => deserialize<_i10.WorkspaceMemberInfo>(e))
          .toList() as T;
    }
    if (t == List<_i12.WorkspaceSummary>) {
      return (data as List)
          .map((e) => deserialize<_i12.WorkspaceSummary>(e))
          .toList() as T;
    }
    if (t == List<_i13.Workspace>) {
      return (data as List).map((e) => deserialize<_i13.Workspace>(e)).toList()
          as T;
    }
    try {
      return _i14.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.CatalogSnapshot) {
      return 'CatalogSnapshot';
    }
    if (data is _i3.Product) {
      return 'Product';
    }
    if (data is _i4.Response) {
      return 'Response';
    }
    if (data is _i5.WorkspaceSummary) {
      return 'WorkspaceSummary';
    }
    if (data is _i6.Workspace) {
      return 'Workspace';
    }
    if (data is _i7.WorkspaceDashboardData) {
      return 'WorkspaceDashboardData';
    }
    if (data is _i8.WorkspaceInvitation) {
      return 'WorkspaceInvitation';
    }
    if (data is _i9.WorkspaceMember) {
      return 'WorkspaceMember';
    }
    if (data is _i10.WorkspaceMemberInfo) {
      return 'WorkspaceMemberInfo';
    }
    if (data is _i11.WorkspaceRole) {
      return 'WorkspaceRole';
    }
    className = _i14.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'CatalogSnapshot') {
      return deserialize<_i2.CatalogSnapshot>(data['data']);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i3.Product>(data['data']);
    }
    if (dataClassName == 'Response') {
      return deserialize<_i4.Response>(data['data']);
    }
    if (dataClassName == 'WorkspaceSummary') {
      return deserialize<_i5.WorkspaceSummary>(data['data']);
    }
    if (dataClassName == 'Workspace') {
      return deserialize<_i6.Workspace>(data['data']);
    }
    if (dataClassName == 'WorkspaceDashboardData') {
      return deserialize<_i7.WorkspaceDashboardData>(data['data']);
    }
    if (dataClassName == 'WorkspaceInvitation') {
      return deserialize<_i8.WorkspaceInvitation>(data['data']);
    }
    if (dataClassName == 'WorkspaceMember') {
      return deserialize<_i9.WorkspaceMember>(data['data']);
    }
    if (dataClassName == 'WorkspaceMemberInfo') {
      return deserialize<_i10.WorkspaceMemberInfo>(data['data']);
    }
    if (dataClassName == 'WorkspaceRole') {
      return deserialize<_i11.WorkspaceRole>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i14.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
