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
import 'dart:async' as _i2;
import 'package:hololine_client/src/protocol/workspace.dart' as _i3;
import 'package:hololine_client/src/protocol/workspace_role.dart' as _i4;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i5;
import 'protocol.dart' as _i6;

/// {@category Endpoint}
class EndpointWorkspace extends _i1.EndpointRef {
  EndpointWorkspace(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'workspace';

  _i2.Future<_i3.Workspace> createStandalone(
    String name,
    String description,
  ) =>
      caller.callServerEndpoint<_i3.Workspace>(
        'workspace',
        'createStandalone',
        {
          'name': name,
          'description': description,
        },
      );

  _i2.Future<_i3.Workspace> createChild(
    String name,
    int parentWorkspaceId,
    String description,
  ) =>
      caller.callServerEndpoint<_i3.Workspace>(
        'workspace',
        'createChild',
        {
          'name': name,
          'parentWorkspaceId': parentWorkspaceId,
          'description': description,
        },
      );

  _i2.Future<void> updateMemberRole({
    required int memberId,
    required int workspaceId,
    required _i4.WorkspaceRole role,
  }) =>
      caller.callServerEndpoint<void>(
        'workspace',
        'updateMemberRole',
        {
          'memberId': memberId,
          'workspaceId': workspaceId,
          'role': role,
        },
      );

  _i2.Future<void> removeMember({
    required int memberId,
    required int workspaceId,
  }) =>
      caller.callServerEndpoint<void>(
        'workspace',
        'removeMember',
        {
          'memberId': memberId,
          'workspaceId': workspaceId,
        },
      );
}

class Modules {
  Modules(Client client) {
    auth = _i5.Caller(client);
  }

  late final _i5.Caller auth;
}

class Client extends _i1.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    _i1.AuthenticationKeyManager? authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )? onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
          host,
          _i6.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    workspace = EndpointWorkspace(this);
    modules = Modules(this);
  }

  late final EndpointWorkspace workspace;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup =>
      {'workspace': workspace};

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup =>
      {'auth': modules.auth};
}
