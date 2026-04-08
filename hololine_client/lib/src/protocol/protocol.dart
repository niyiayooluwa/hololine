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
import 'catalog.dart' as _i2;
import 'catalog_snapshot.dart' as _i3;
import 'inventory.dart' as _i4;
import 'ledger.dart' as _i5;
import 'ledger_line_item.dart' as _i6;
import 'payment_status.dart' as _i7;
import 'responses/response.dart' as _i8;
import 'responses/workspace_summary.dart' as _i9;
import 'transaction_type.dart' as _i10;
import 'workspace.dart' as _i11;
import 'workspace_dashboard_data.dart' as _i12;
import 'workspace_invitation.dart' as _i13;
import 'workspace_member.dart' as _i14;
import 'workspace_member_info.dart' as _i15;
import 'workspace_role.dart' as _i16;
import 'package:hololine_client/src/protocol/responses/workspace_summary.dart'
    as _i17;
import 'package:hololine_client/src/protocol/workspace.dart' as _i18;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i19;
export 'catalog.dart';
export 'catalog_snapshot.dart';
export 'inventory.dart';
export 'ledger.dart';
export 'ledger_line_item.dart';
export 'payment_status.dart';
export 'responses/response.dart';
export 'responses/workspace_summary.dart';
export 'transaction_type.dart';
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
    if (t == _i2.Catalog) {
      return _i2.Catalog.fromJson(data) as T;
    }
    if (t == _i3.CatalogSnapshot) {
      return _i3.CatalogSnapshot.fromJson(data) as T;
    }
    if (t == _i4.Inventory) {
      return _i4.Inventory.fromJson(data) as T;
    }
    if (t == _i5.Ledger) {
      return _i5.Ledger.fromJson(data) as T;
    }
    if (t == _i6.LedgerLineItem) {
      return _i6.LedgerLineItem.fromJson(data) as T;
    }
    if (t == _i7.PaymentStatus) {
      return _i7.PaymentStatus.fromJson(data) as T;
    }
    if (t == _i8.Response) {
      return _i8.Response.fromJson(data) as T;
    }
    if (t == _i9.WorkspaceSummary) {
      return _i9.WorkspaceSummary.fromJson(data) as T;
    }
    if (t == _i10.TransactionType) {
      return _i10.TransactionType.fromJson(data) as T;
    }
    if (t == _i11.Workspace) {
      return _i11.Workspace.fromJson(data) as T;
    }
    if (t == _i12.WorkspaceDashboardData) {
      return _i12.WorkspaceDashboardData.fromJson(data) as T;
    }
    if (t == _i13.WorkspaceInvitation) {
      return _i13.WorkspaceInvitation.fromJson(data) as T;
    }
    if (t == _i14.WorkspaceMember) {
      return _i14.WorkspaceMember.fromJson(data) as T;
    }
    if (t == _i15.WorkspaceMemberInfo) {
      return _i15.WorkspaceMemberInfo.fromJson(data) as T;
    }
    if (t == _i16.WorkspaceRole) {
      return _i16.WorkspaceRole.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Catalog?>()) {
      return (data != null ? _i2.Catalog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.CatalogSnapshot?>()) {
      return (data != null ? _i3.CatalogSnapshot.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.Inventory?>()) {
      return (data != null ? _i4.Inventory.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.Ledger?>()) {
      return (data != null ? _i5.Ledger.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.LedgerLineItem?>()) {
      return (data != null ? _i6.LedgerLineItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.PaymentStatus?>()) {
      return (data != null ? _i7.PaymentStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.Response?>()) {
      return (data != null ? _i8.Response.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.WorkspaceSummary?>()) {
      return (data != null ? _i9.WorkspaceSummary.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.TransactionType?>()) {
      return (data != null ? _i10.TransactionType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.Workspace?>()) {
      return (data != null ? _i11.Workspace.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.WorkspaceDashboardData?>()) {
      return (data != null ? _i12.WorkspaceDashboardData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i13.WorkspaceInvitation?>()) {
      return (data != null ? _i13.WorkspaceInvitation.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i14.WorkspaceMember?>()) {
      return (data != null ? _i14.WorkspaceMember.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.WorkspaceMemberInfo?>()) {
      return (data != null ? _i15.WorkspaceMemberInfo.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i16.WorkspaceRole?>()) {
      return (data != null ? _i16.WorkspaceRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<List<_i14.WorkspaceMember>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i14.WorkspaceMember>(e))
              .toList()
          : null) as T;
    }
    if (t == List<_i15.WorkspaceMemberInfo>) {
      return (data as List)
          .map((e) => deserialize<_i15.WorkspaceMemberInfo>(e))
          .toList() as T;
    }
    if (t == List<_i17.WorkspaceSummary>) {
      return (data as List)
          .map((e) => deserialize<_i17.WorkspaceSummary>(e))
          .toList() as T;
    }
    if (t == List<_i18.Workspace>) {
      return (data as List).map((e) => deserialize<_i18.Workspace>(e)).toList()
          as T;
    }
    try {
      return _i19.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.Catalog) {
      return 'Catalog';
    }
    if (data is _i3.CatalogSnapshot) {
      return 'CatalogSnapshot';
    }
    if (data is _i4.Inventory) {
      return 'Inventory';
    }
    if (data is _i5.Ledger) {
      return 'Ledger';
    }
    if (data is _i6.LedgerLineItem) {
      return 'LedgerLineItem';
    }
    if (data is _i7.PaymentStatus) {
      return 'PaymentStatus';
    }
    if (data is _i8.Response) {
      return 'Response';
    }
    if (data is _i9.WorkspaceSummary) {
      return 'WorkspaceSummary';
    }
    if (data is _i10.TransactionType) {
      return 'TransactionType';
    }
    if (data is _i11.Workspace) {
      return 'Workspace';
    }
    if (data is _i12.WorkspaceDashboardData) {
      return 'WorkspaceDashboardData';
    }
    if (data is _i13.WorkspaceInvitation) {
      return 'WorkspaceInvitation';
    }
    if (data is _i14.WorkspaceMember) {
      return 'WorkspaceMember';
    }
    if (data is _i15.WorkspaceMemberInfo) {
      return 'WorkspaceMemberInfo';
    }
    if (data is _i16.WorkspaceRole) {
      return 'WorkspaceRole';
    }
    className = _i19.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'Catalog') {
      return deserialize<_i2.Catalog>(data['data']);
    }
    if (dataClassName == 'CatalogSnapshot') {
      return deserialize<_i3.CatalogSnapshot>(data['data']);
    }
    if (dataClassName == 'Inventory') {
      return deserialize<_i4.Inventory>(data['data']);
    }
    if (dataClassName == 'Ledger') {
      return deserialize<_i5.Ledger>(data['data']);
    }
    if (dataClassName == 'LedgerLineItem') {
      return deserialize<_i6.LedgerLineItem>(data['data']);
    }
    if (dataClassName == 'PaymentStatus') {
      return deserialize<_i7.PaymentStatus>(data['data']);
    }
    if (dataClassName == 'Response') {
      return deserialize<_i8.Response>(data['data']);
    }
    if (dataClassName == 'WorkspaceSummary') {
      return deserialize<_i9.WorkspaceSummary>(data['data']);
    }
    if (dataClassName == 'TransactionType') {
      return deserialize<_i10.TransactionType>(data['data']);
    }
    if (dataClassName == 'Workspace') {
      return deserialize<_i11.Workspace>(data['data']);
    }
    if (dataClassName == 'WorkspaceDashboardData') {
      return deserialize<_i12.WorkspaceDashboardData>(data['data']);
    }
    if (dataClassName == 'WorkspaceInvitation') {
      return deserialize<_i13.WorkspaceInvitation>(data['data']);
    }
    if (dataClassName == 'WorkspaceMember') {
      return deserialize<_i14.WorkspaceMember>(data['data']);
    }
    if (dataClassName == 'WorkspaceMemberInfo') {
      return deserialize<_i15.WorkspaceMemberInfo>(data['data']);
    }
    if (dataClassName == 'WorkspaceRole') {
      return deserialize<_i16.WorkspaceRole>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i19.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
