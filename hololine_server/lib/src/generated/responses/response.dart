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

abstract class Response
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  Response._({
    required this.success,
    this.error,
    this.message,
  });

  factory Response({
    required bool success,
    String? error,
    String? message,
  }) = _ResponseImpl;

  factory Response.fromJson(Map<String, dynamic> jsonSerialization) {
    return Response(
      success: jsonSerialization['success'] as bool,
      error: jsonSerialization['error'] as String?,
      message: jsonSerialization['message'] as String?,
    );
  }

  bool success;

  String? error;

  String? message;

  /// Returns a shallow copy of this [Response]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Response copyWith({
    bool? success,
    String? error,
    String? message,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      if (error != null) 'error': error,
      if (message != null) 'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      'success': success,
      if (error != null) 'error': error,
      if (message != null) 'message': message,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ResponseImpl extends Response {
  _ResponseImpl({
    required bool success,
    String? error,
    String? message,
  }) : super._(
          success: success,
          error: error,
          message: message,
        );

  /// Returns a shallow copy of this [Response]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Response copyWith({
    bool? success,
    Object? error = _Undefined,
    Object? message = _Undefined,
  }) {
    return Response(
      success: success ?? this.success,
      error: error is String? ? error : this.error,
      message: message is String? ? message : this.message,
    );
  }
}
