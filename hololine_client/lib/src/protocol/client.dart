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
import 'package:hololine_client/src/protocol/workspace_dashboard_data.dart'
    as _i4;
import 'package:hololine_client/src/protocol/responses/workspace_summary.dart'
    as _i5;
import 'package:hololine_client/src/protocol/workspace_member.dart' as _i6;
import 'package:hololine_client/src/protocol/workspace_role.dart' as _i7;
import 'package:hololine_client/src/protocol/workspace_invitation.dart' as _i8;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i9;
import 'protocol.dart' as _i10;

/// {@category Endpoint}
class EndpointCron extends _i1.EndpointRef {
  EndpointCron(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'cron';

  _i2.Future<void> executeJob() => caller.callServerEndpoint<void>(
        'cron',
        'executeJob',
        {},
      );
}

/// [WorkspaceCleanupJob] is responsible for performing hard deletes on workspaces
/// that have been soft deleted and their grace period has expired.
/// {@category Endpoint}
class EndpointCleanup extends _i1.EndpointRef {
  EndpointCleanup(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'cleanup';

  /// [checkAndPerformHardDeletes] is the main method that checks for workspaces
  /// that are pending deletion and performs the hard delete if their
  /// `pendingDeletionUntil` timestamp is in the past.
  _i2.Future<void> checkAndPerformHardDeletes() =>
      caller.callServerEndpoint<void>(
        'cleanup',
        'checkAndPerformHardDeletes',
        {},
      );
}

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

  _i2.Future<_i3.Workspace> getWorkspaceDetails({required String publicId}) =>
      caller.callServerEndpoint<_i3.Workspace>(
        'workspace',
        'getWorkspaceDetails',
        {'publicId': publicId},
      );

  _i2.Future<_i4.WorkspaceDashboardData> getDashboardData(
          {required String publicId}) =>
      caller.callServerEndpoint<_i4.WorkspaceDashboardData>(
        'workspace',
        'getDashboardData',
        {'publicId': publicId},
      );

  _i2.Future<List<_i5.WorkspaceSummary>> getMyWorkspaces() =>
      caller.callServerEndpoint<List<_i5.WorkspaceSummary>>(
        'workspace',
        'getMyWorkspaces',
        {},
      );

  _i2.Future<List<_i3.Workspace>> getChildWorkspaces(
          {required int parentWorkspaceId}) =>
      caller.callServerEndpoint<List<_i3.Workspace>>(
        'workspace',
        'getChildWorkspaces',
        {'parentWorkspaceId': parentWorkspaceId},
      );

  _i2.Future<_i6.WorkspaceMember> updateMemberRole({
    required int memberId,
    required int workspaceId,
    required _i7.WorkspaceRole role,
  }) =>
      caller.callServerEndpoint<_i6.WorkspaceMember>(
        'workspace',
        'updateMemberRole',
        {
          'memberId': memberId,
          'workspaceId': workspaceId,
          'role': role,
        },
      );

  _i2.Future<_i6.WorkspaceMember> removeMember({
    required int memberId,
    required int workspaceId,
  }) =>
      caller.callServerEndpoint<_i6.WorkspaceMember>(
        'workspace',
        'removeMember',
        {
          'memberId': memberId,
          'workspaceId': workspaceId,
        },
      );

  _i2.Future<_i6.WorkspaceMember> leaveWorkspace({required int workspaceId}) =>
      caller.callServerEndpoint<_i6.WorkspaceMember>(
        'workspace',
        'leaveWorkspace',
        {'workspaceId': workspaceId},
      );

  _i2.Future<_i8.WorkspaceInvitation> inviteMember(
    String email,
    int workspaceId,
    _i7.WorkspaceRole role,
  ) =>
      caller.callServerEndpoint<_i8.WorkspaceInvitation>(
        'workspace',
        'inviteMember',
        {
          'email': email,
          'workspaceId': workspaceId,
          'role': role,
        },
      );

  _i2.Future<_i6.WorkspaceMember> acceptInvitation(String token) =>
      caller.callServerEndpoint<_i6.WorkspaceMember>(
        'workspace',
        'acceptInvitation',
        {'token': token},
      );

  _i2.Future<_i3.Workspace> updateWorkspaceDetails({
    required int workspaceId,
    String? name,
    String? description,
  }) =>
      caller.callServerEndpoint<_i3.Workspace>(
        'workspace',
        'updateWorkspaceDetails',
        {
          'workspaceId': workspaceId,
          'name': name,
          'description': description,
        },
      );

  _i2.Future<_i3.Workspace> archiveWorkspace(int workspaceId) =>
      caller.callServerEndpoint<_i3.Workspace>(
        'workspace',
        'archiveWorkspace',
        {'workspaceId': workspaceId},
      );

  _i2.Future<_i3.Workspace> restoreWorkspace(int workspaceId) =>
      caller.callServerEndpoint<_i3.Workspace>(
        'workspace',
        'restoreWorkspace',
        {'workspaceId': workspaceId},
      );

  _i2.Future<bool> transferOwnership(
    int workspaceId,
    int newOwnerId,
  ) =>
      caller.callServerEndpoint<bool>(
        'workspace',
        'transferOwnership',
        {
          'workspaceId': workspaceId,
          'newOwnerId': newOwnerId,
        },
      );

  _i2.Future<_i3.Workspace> initiateDeleteWorkspace(int workspaceId) =>
      caller.callServerEndpoint<_i3.Workspace>(
        'workspace',
        'initiateDeleteWorkspace',
        {'workspaceId': workspaceId},
      );
}

class Modules {
  Modules(Client client) {
    auth = _i9.Caller(client);
  }

  late final _i9.Caller auth;
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
          _i10.Protocol(),
          securityContext: securityContext,
          authenticationKeyManager: authenticationKeyManager,
          streamingConnectionTimeout: streamingConnectionTimeout,
          connectionTimeout: connectionTimeout,
          onFailedCall: onFailedCall,
          onSucceededCall: onSucceededCall,
          disconnectStreamsOnLostInternetConnection:
              disconnectStreamsOnLostInternetConnection,
        ) {
    cron = EndpointCron(this);
    cleanup = EndpointCleanup(this);
    workspace = EndpointWorkspace(this);
    modules = Modules(this);
  }

  late final EndpointCron cron;

  late final EndpointCleanup cleanup;

  late final EndpointWorkspace workspace;

  late final Modules modules;

  @override
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
        'cron': cron,
        'cleanup': cleanup,
        'workspace': workspace,
      };

  @override
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup =>
      {'auth': modules.auth};
}
