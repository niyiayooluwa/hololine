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

abstract class Workspace implements _i1.SerializableModel {
  Workspace._({
    this.id,
    required this.name,
    this.description,
    this.parentId,
    bool? isPremium,
    required this.createdAt,
    this.deletedAt,
    this.archivedAt,
  }) : isPremium = isPremium ?? false;

  factory Workspace({
    int? id,
    required String name,
    String? description,
    int? parentId,
    bool? isPremium,
    required DateTime createdAt,
    DateTime? deletedAt,
    DateTime? archivedAt,
  }) = _WorkspaceImpl;

  factory Workspace.fromJson(Map<String, dynamic> jsonSerialization) {
    return Workspace(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      parentId: jsonSerialization['parentId'] as int?,
      isPremium: jsonSerialization['isPremium'] as bool,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
      archivedAt: jsonSerialization['archivedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['archivedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String? description;

  int? parentId;

  bool isPremium;

  DateTime createdAt;

  DateTime? deletedAt;

  DateTime? archivedAt;

  /// Returns a shallow copy of this [Workspace]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Workspace copyWith({
    int? id,
    String? name,
    String? description,
    int? parentId,
    bool? isPremium,
    DateTime? createdAt,
    DateTime? deletedAt,
    DateTime? archivedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (description != null) 'description': description,
      if (parentId != null) 'parentId': parentId,
      'isPremium': isPremium,
      'createdAt': createdAt.toJson(),
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      if (archivedAt != null) 'archivedAt': archivedAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorkspaceImpl extends Workspace {
  _WorkspaceImpl({
    int? id,
    required String name,
    String? description,
    int? parentId,
    bool? isPremium,
    required DateTime createdAt,
    DateTime? deletedAt,
    DateTime? archivedAt,
  }) : super._(
          id: id,
          name: name,
          description: description,
          parentId: parentId,
          isPremium: isPremium,
          createdAt: createdAt,
          deletedAt: deletedAt,
          archivedAt: archivedAt,
        );

  /// Returns a shallow copy of this [Workspace]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Workspace copyWith({
    Object? id = _Undefined,
    String? name,
    Object? description = _Undefined,
    Object? parentId = _Undefined,
    bool? isPremium,
    DateTime? createdAt,
    Object? deletedAt = _Undefined,
    Object? archivedAt = _Undefined,
  }) {
    return Workspace(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      parentId: parentId is int? ? parentId : this.parentId,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      archivedAt: archivedAt is DateTime? ? archivedAt : this.archivedAt,
    );
  }
}
