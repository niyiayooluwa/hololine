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
import '../endpoints/catalog_endpoint.dart' as _i2;
import '../endpoints/jobs/cron_endpoint.dart' as _i3;
import '../endpoints/jobs/workspace_cleanup.dart' as _i4;
import '../endpoints/ledger_endpoint.dart' as _i5;
import '../endpoints/workspace_endpoint.dart' as _i6;
import 'package:hololine_server/src/generated/catalog.dart' as _i7;
import 'package:hololine_server/src/generated/requests/catalog_update_params.dart'
    as _i8;
import 'package:hololine_server/src/generated/requests/inventory_update_params.dart'
    as _i9;
import 'package:hololine_server/src/generated/ledger_line_item.dart' as _i10;
import 'package:hololine_server/src/generated/transaction_type.dart' as _i11;
import 'package:hololine_server/src/generated/payment_status.dart' as _i12;
import 'package:hololine_server/src/generated/workspace_role.dart' as _i13;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i14;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'catalog': _i2.CatalogEndpoint()
        ..initialize(
          server,
          'catalog',
          null,
        ),
      'cron': _i3.CronEndpoint()
        ..initialize(
          server,
          'cron',
          null,
        ),
      'cleanup': _i4.CleanupEndpoint()
        ..initialize(
          server,
          'cleanup',
          null,
        ),
      'ledger': _i5.LedgerEndpoint()
        ..initialize(
          server,
          'ledger',
          null,
        ),
      'workspace': _i6.WorkspaceEndpoint()
        ..initialize(
          server,
          'workspace',
          null,
        ),
    };
    connectors['catalog'] = _i1.EndpointConnector(
      name: 'catalog',
      endpoint: endpoints['catalog']!,
      methodConnectors: {
        'createProduct': _i1.MethodConnector(
          name: 'createProduct',
          params: {
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'catalogData': _i1.ParameterDescription(
              name: 'catalogData',
              type: _i1.getType<_i7.Catalog>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['catalog'] as _i2.CatalogEndpoint).createProduct(
            session,
            workspaceId: params['workspaceId'],
            catalogData: params['catalogData'],
          ),
        ),
        'listProducts': _i1.MethodConnector(
          name: 'listProducts',
          params: {
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['catalog'] as _i2.CatalogEndpoint).listProducts(
            session,
            workspaceId: params['workspaceId'],
          ),
        ),
        'updateProduct': _i1.MethodConnector(
          name: 'updateProduct',
          params: {
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'catalogId': _i1.ParameterDescription(
              name: 'catalogId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'catalogUpdates': _i1.ParameterDescription(
              name: 'catalogUpdates',
              type: _i1.getType<_i8.CatalogUpdateParams>(),
              nullable: false,
            ),
            'inventoryUpdates': _i1.ParameterDescription(
              name: 'inventoryUpdates',
              type: _i1.getType<_i9.InventoryUpdateParams>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['catalog'] as _i2.CatalogEndpoint).updateProduct(
            session,
            workspaceId: params['workspaceId'],
            catalogId: params['catalogId'],
            catalogUpdates: params['catalogUpdates'],
            inventoryUpdates: params['inventoryUpdates'],
          ),
        ),
        'archiveProduct': _i1.MethodConnector(
          name: 'archiveProduct',
          params: {
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'catalogId': _i1.ParameterDescription(
              name: 'catalogId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['catalog'] as _i2.CatalogEndpoint).archiveProduct(
            session,
            workspaceId: params['workspaceId'],
            catalogId: params['catalogId'],
          ),
        ),
      },
    );
    connectors['cron'] = _i1.EndpointConnector(
      name: 'cron',
      endpoint: endpoints['cron']!,
      methodConnectors: {
        'executeJob': _i1.MethodConnector(
          name: 'executeJob',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['cron'] as _i3.CronEndpoint).executeJob(session),
        )
      },
    );
    connectors['cleanup'] = _i1.EndpointConnector(
      name: 'cleanup',
      endpoint: endpoints['cleanup']!,
      methodConnectors: {
        'checkAndPerformHardDeletes': _i1.MethodConnector(
          name: 'checkAndPerformHardDeletes',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['cleanup'] as _i4.CleanupEndpoint)
                  .checkAndPerformHardDeletes(session),
        )
      },
    );
    connectors['ledger'] = _i1.EndpointConnector(
      name: 'ledger',
      endpoint: endpoints['ledger']!,
      methodConnectors: {
        'createTransaction': _i1.MethodConnector(
          name: 'createTransaction',
          params: {
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'lineItems': _i1.ParameterDescription(
              name: 'lineItems',
              type: _i1.getType<List<_i10.LedgerLineItem>>(),
              nullable: false,
            ),
            'transactionType': _i1.ParameterDescription(
              name: 'transactionType',
              type: _i1.getType<_i11.TransactionType>(),
              nullable: false,
            ),
            'paymentStatus': _i1.ParameterDescription(
              name: 'paymentStatus',
              type: _i1.getType<_i12.PaymentStatus>(),
              nullable: false,
            ),
            'transactionAt': _i1.ParameterDescription(
              name: 'transactionAt',
              type: _i1.getType<DateTime>(),
              nullable: false,
            ),
            'referenceNumber': _i1.ParameterDescription(
              name: 'referenceNumber',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'notes': _i1.ParameterDescription(
              name: 'notes',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'counterpartyName': _i1.ParameterDescription(
              name: 'counterpartyName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['ledger'] as _i5.LedgerEndpoint).createTransaction(
            session,
            workspaceId: params['workspaceId'],
            lineItems: params['lineItems'],
            transactionType: params['transactionType'],
            paymentStatus: params['paymentStatus'],
            transactionAt: params['transactionAt'],
            referenceNumber: params['referenceNumber'],
            notes: params['notes'],
            counterpartyName: params['counterpartyName'],
          ),
        ),
        'listTransactions': _i1.MethodConnector(
          name: 'listTransactions',
          params: {
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'transactionType': _i1.ParameterDescription(
              name: 'transactionType',
              type: _i1.getType<_i11.TransactionType?>(),
              nullable: true,
            ),
            'from': _i1.ParameterDescription(
              name: 'from',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
            'to': _i1.ParameterDescription(
              name: 'to',
              type: _i1.getType<DateTime?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['ledger'] as _i5.LedgerEndpoint).listTransactions(
            session,
            workspaceId: params['workspaceId'],
            transactionType: params['transactionType'],
            from: params['from'],
            to: params['to'],
          ),
        ),
        'getTransaction': _i1.MethodConnector(
          name: 'getTransaction',
          params: {
            'ledgerId': _i1.ParameterDescription(
              name: 'ledgerId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['ledger'] as _i5.LedgerEndpoint).getTransaction(
            session,
            ledgerId: params['ledgerId'],
            workspaceId: params['workspaceId'],
          ),
        ),
      },
    );
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
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['workspace'] as _i6.WorkspaceEndpoint)
                  .createStandalone(
            session,
            params['name'],
            params['description'],
          ),
        ),
        'createChild': _i1.MethodConnector(
          name: 'createChild',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'parentWorkspaceId': _i1.ParameterDescription(
              name: 'parentWorkspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['workspace'] as _i6.WorkspaceEndpoint).createChild(
            session,
            params['name'],
            params['parentWorkspaceId'],
            params['description'],
          ),
        ),
        'getWorkspaceDetails': _i1.MethodConnector(
          name: 'getWorkspaceDetails',
          params: {
            'publicId': _i1.ParameterDescription(
              name: 'publicId',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['workspace'] as _i6.WorkspaceEndpoint)
                  .getWorkspaceDetails(
            session,
            publicId: params['publicId'],
          ),
        ),
        'getDashboardData': _i1.MethodConnector(
          name: 'getDashboardData',
          params: {
            'publicId': _i1.ParameterDescription(
              name: 'publicId',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['workspace'] as _i6.WorkspaceEndpoint)
                  .getDashboardData(
            session,
            publicId: params['publicId'],
          ),
        ),
        'getMyWorkspaces': _i1.MethodConnector(
          name: 'getMyWorkspaces',
          params: {},
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['workspace'] as _i6.WorkspaceEndpoint)
                  .getMyWorkspaces(session),
        ),
        'getChildWorkspaces': _i1.MethodConnector(
          name: 'getChildWorkspaces',
          params: {
            'parentWorkspaceId': _i1.ParameterDescription(
              name: 'parentWorkspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['workspace'] as _i6.WorkspaceEndpoint)
                  .getChildWorkspaces(
            session,
            parentWorkspaceId: params['parentWorkspaceId'],
          ),
        ),
        'updateMemberRole': _i1.MethodConnector(
          name: 'updateMemberRole',
          params: {
            'memberId': _i1.ParameterDescription(
              name: 'memberId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'role': _i1.ParameterDescription(
              name: 'role',
              type: _i1.getType<_i13.WorkspaceRole>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['workspace'] as _i6.WorkspaceEndpoint)
                  .updateMemberRole(
            session,
            memberId: params['memberId'],
            workspaceId: params['workspaceId'],
            role: params['role'],
          ),
        ),
        'removeMember': _i1.MethodConnector(
          name: 'removeMember',
          params: {
            'memberId': _i1.ParameterDescription(
              name: 'memberId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['workspace'] as _i6.WorkspaceEndpoint).removeMember(
            session,
            memberId: params['memberId'],
            workspaceId: params['workspaceId'],
          ),
        ),
        'leaveWorkspace': _i1.MethodConnector(
          name: 'leaveWorkspace',
          params: {
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['workspace'] as _i6.WorkspaceEndpoint).leaveWorkspace(
            session,
            workspaceId: params['workspaceId'],
          ),
        ),
        'inviteMember': _i1.MethodConnector(
          name: 'inviteMember',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'role': _i1.ParameterDescription(
              name: 'role',
              type: _i1.getType<_i13.WorkspaceRole>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['workspace'] as _i6.WorkspaceEndpoint).inviteMember(
            session,
            params['email'],
            params['workspaceId'],
            params['role'],
          ),
        ),
        'acceptInvitation': _i1.MethodConnector(
          name: 'acceptInvitation',
          params: {
            'token': _i1.ParameterDescription(
              name: 'token',
              type: _i1.getType<String>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['workspace'] as _i6.WorkspaceEndpoint)
                  .acceptInvitation(
            session,
            params['token'],
          ),
        ),
        'updateWorkspaceDetails': _i1.MethodConnector(
          name: 'updateWorkspaceDetails',
          params: {
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['workspace'] as _i6.WorkspaceEndpoint)
                  .updateWorkspaceDetails(
            session,
            workspaceId: params['workspaceId'],
            name: params['name'],
            description: params['description'],
          ),
        ),
        'archiveWorkspace': _i1.MethodConnector(
          name: 'archiveWorkspace',
          params: {
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['workspace'] as _i6.WorkspaceEndpoint)
                  .archiveWorkspace(
            session,
            params['workspaceId'],
          ),
        ),
        'restoreWorkspace': _i1.MethodConnector(
          name: 'restoreWorkspace',
          params: {
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['workspace'] as _i6.WorkspaceEndpoint)
                  .restoreWorkspace(
            session,
            params['workspaceId'],
          ),
        ),
        'transferOwnership': _i1.MethodConnector(
          name: 'transferOwnership',
          params: {
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'newOwnerId': _i1.ParameterDescription(
              name: 'newOwnerId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['workspace'] as _i6.WorkspaceEndpoint)
                  .transferOwnership(
            session,
            params['workspaceId'],
            params['newOwnerId'],
          ),
        ),
        'initiateDeleteWorkspace': _i1.MethodConnector(
          name: 'initiateDeleteWorkspace',
          params: {
            'workspaceId': _i1.ParameterDescription(
              name: 'workspaceId',
              type: _i1.getType<int>(),
              nullable: false,
            )
          },
          call: (
            _i1.Session session,
            Map<String, dynamic> params,
          ) async =>
              (endpoints['workspace'] as _i6.WorkspaceEndpoint)
                  .initiateDeleteWorkspace(
            session,
            params['workspaceId'],
          ),
        ),
      },
    );
    modules['serverpod_auth'] = _i14.Endpoints()..initializeEndpoints(server);
  }
}
