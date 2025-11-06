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
import '../endpoints/workspace_endpoint.dart' as _i2;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i3;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'workspace': _i2.WorkspaceEndpoint()
        ..initialize(
          server,
          'workspace',
          null,
        )
    };
    connectors['workspace'] = _i1.EndpointConnector(
      name: 'workspace',
      endpoint: endpoints['workspace']!,
      methodConnectors: {
        'createStandalone': _i1.MethodConnector(
          name: 'createStandalone',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['workspace'] as _i2.WorkspaceEndpoint)
                  .createStandalone(
            session,
            params['name'],
          ),
        )
      },
    );
    modules['serverpod_auth'] = _i3.Endpoints()..initializeEndpoints(server);
  }
}
