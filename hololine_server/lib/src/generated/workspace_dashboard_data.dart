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
import 'workspace.dart' as _i2;
import 'workspace_member_info.dart' as _i3;
import 'catalog_snapshot.dart' as _i4;

abstract class WorkspaceDashboardData
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  WorkspaceDashboardData._({
    required this.workspace,
    required this.members,
    required this.catalog,
  });

  factory WorkspaceDashboardData({
    required _i2.Workspace workspace,
    required List<_i3.WorkspaceMemberInfo> members,
    required _i4.CatalogSnapshot catalog,
  }) = _WorkspaceDashboardDataImpl;

  factory WorkspaceDashboardData.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return WorkspaceDashboardData(
      workspace: _i2.Workspace.fromJson(
          (jsonSerialization['workspace'] as Map<String, dynamic>)),
      members: (jsonSerialization['members'] as List)
          .map((e) =>
              _i3.WorkspaceMemberInfo.fromJson((e as Map<String, dynamic>)))
          .toList(),
      catalog: _i4.CatalogSnapshot.fromJson(
          (jsonSerialization['catalog'] as Map<String, dynamic>)),
    );
  }

  _i2.Workspace workspace;

  List<_i3.WorkspaceMemberInfo> members;

  _i4.CatalogSnapshot catalog;

  /// Returns a shallow copy of this [WorkspaceDashboardData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  WorkspaceDashboardData copyWith({
    _i2.Workspace? workspace,
    List<_i3.WorkspaceMemberInfo>? members,
    _i4.CatalogSnapshot? catalog,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'workspace': workspace.toJson(),
      'members': members.toJson(valueToJson: (v) => v.toJson()),
      'catalog': catalog.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'workspace': workspace.toJsonForProtocol(),
      'members': members.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'catalog': catalog.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _WorkspaceDashboardDataImpl extends WorkspaceDashboardData {
  _WorkspaceDashboardDataImpl({
    required _i2.Workspace workspace,
    required List<_i3.WorkspaceMemberInfo> members,
    required _i4.CatalogSnapshot catalog,
  }) : super._(
          workspace: workspace,
          members: members,
          catalog: catalog,
        );

  /// Returns a shallow copy of this [WorkspaceDashboardData]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  WorkspaceDashboardData copyWith({
    _i2.Workspace? workspace,
    List<_i3.WorkspaceMemberInfo>? members,
    _i4.CatalogSnapshot? catalog,
  }) {
    return WorkspaceDashboardData(
      workspace: workspace ?? this.workspace.copyWith(),
      members: members ?? this.members.map((e0) => e0.copyWith()).toList(),
      catalog: catalog ?? this.catalog.copyWith(),
    );
  }
}
