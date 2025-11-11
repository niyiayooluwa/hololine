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
import 'package:hololine_client/src/protocol/responses/response.dart' as _i4;
import 'package:hololine_client/src/protocol/workspace_role.dart' as _i5;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i6;
import 'protocol.dart' as _i7;

/// Manages workspace-related operations such as creation, member management,
/// and invitations. All endpoints require user authentication.
/// {@category Endpoint}
class EndpointWorkspace extends _i1.EndpointRef {
  EndpointWorkspace(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'workspace';

  /// Creates a new standalone workspace.
  ///
  /// A standalone workspace does not have a parent. The authenticated user
  /// will become the owner of this new workspace.
  ///
  /// - [name]: The name of the workspace.
  /// - [description]: A description for the workspace.
  ///
  /// Returns the newly created [Workspace].
  /// Throws an [Exception] if the user is not authenticated or if creation fails.
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

  /// Creates a new child workspace under a specified parent.
  ///
  /// The authenticated user must have permissions to create a child workspace
  /// under the given [parentWorkspaceId].
  ///
  /// - [name]: The name of the new child workspace.
  /// - [parentWorkspaceId]: The ID of the parent workspace.
  /// - [description]: A description for the new workspace.
  ///
  /// Returns the newly created child [Workspace].
  /// Throws an [Exception] if the user is not authenticated or if creation fails.
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

  /// Updates the role of a member within a workspace.
  ///
  /// The authenticated user must have the necessary permissions to modify member roles.
  ///
  /// - [memberId]: The ID of the member whose role is to be updated.
  /// - [workspaceId]: The ID of the workspace where the member belongs.
  /// - [role]: The new [WorkspaceRole] to assign to the member.
  ///
  /// Returns a [Response] object indicating success or failure.
  _i2.Future<_i4.Response> updateMemberRole({
    required int memberId,
    required int workspaceId,
    required _i5.WorkspaceRole role,
  }) =>
      caller.callServerEndpoint<_i4.Response>(
        'workspace',
        'updateMemberRole',
        {
          'memberId': memberId,
          'workspaceId': workspaceId,
          'role': role,
        },
      );

  /// Removes a member from a workspace.
  ///
  /// The authenticated user must have permissions to remove members from the
  /// specified [workspaceId].
  ///
  /// - [memberId]: The ID of the member to remove.
  /// - [workspaceId]: The ID of the workspace from which to remove the member.
  ///
  /// Returns a [Response] object indicating success or failure.
  _i2.Future<_i4.Response> removeMember({
    required int memberId,
    required int workspaceId,
  }) =>
      caller.callServerEndpoint<_i4.Response>(
        'workspace',
        'removeMember',
        {
          'memberId': memberId,
          'workspaceId': workspaceId,
        },
      );

  /// Sends an invitation to a user to join a workspace.
  ///
  /// The authenticated user must have permissions to invite members to the
  /// specified [workspaceId].
  ///
  /// - [email]: The email address of the user to invite.
  /// - [workspaceId]: The ID of the workspace to invite the user to.
  /// - [role]: The [WorkspaceRole] to assign to the user upon joining.
  ///
  /// Returns a [Response] object indicating success or failure.
  _i2.Future<_i4.Response> inviteMember(
    String email,
    int workspaceId,
    _i5.WorkspaceRole role,
  ) =>
      caller.callServerEndpoint<_i4.Response>(
        'workspace',
        'inviteMember',
        {
          'email': email,
          'workspaceId': workspaceId,
          'role': role,
        },
      );

  /// Accepts a workspace invitation using an invitation token.
  ///
  /// The authenticated user will be added to the workspace associated with the
  /// invitation [token].
  ///
  /// - [token]: The unique invitation token.
  ///
  /// Returns a [Response] object indicating success or failure.
  _i2.Future<_i4.Response> acceptInvitation(String token) =>
      caller.callServerEndpoint<_i4.Response>(
        'workspace',
        'acceptInvitation',
        {'token': token},
      );

  /// Archives a workspace, making it inactive.
  ///
  /// The authenticated user must have the necessary permissions to archive the
  /// specified [workspaceId].
  ///
  /// - [workspaceId]: The ID of the workspace to archive.
  ///
  /// Returns a [Response] object indicating success or failure.
  _i2.Future<_i4.Response> archiveWorkspace(int workspaceId) =>
      caller.callServerEndpoint<_i4.Response>(
        'workspace',
        'archiveWorkspace',
        {'workspaceId': workspaceId},
      );

  /// Restores an archived workspace.
  ///
  /// The authenticated user must have the necessary permissions to restore the
  /// specified [workspaceId].
  ///
  /// - [workspaceId]: The ID of the workspace to restore.
  ///
  /// Returns a [Response] object indicating success or failure.
  _i2.Future<_i4.Response> restoreWorkspace(int workspaceId) =>
      caller.callServerEndpoint<_i4.Response>(
        'workspace',
        'restoreWorkspace',
        {'workspaceId': workspaceId},
      );

  /// Transfers ownership of a workspace to another member.
  ///
  /// The authenticated user must be the current owner of the workspace.
  ///
  /// - [workspaceId]: The ID of the workspace.
  /// - [newOwnerId]: The ID of the member who will become the new owner.
  ///
  /// Returns a [Response] object indicating success or failure.
  /// Throws an [Exception] if the user is not authenticated.
  _i2.Future<_i4.Response> transferOwnership(
    int workspaceId,
    int newOwnerId,
  ) =>
      caller.callServerEndpoint<_i4.Response>(
        'workspace',
        'transferOwnership',
        {
          'workspaceId': workspaceId,
          'newOwnerId': newOwnerId,
        },
      );
}

class Modules {
  Modules(Client client) {
    auth = _i6.Caller(client);
  }

  late final _i6.Caller auth;
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
          _i7.Protocol(),
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
