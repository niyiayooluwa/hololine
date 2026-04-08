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
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i3;
import 'catalog.dart' as _i4;
import 'catalog_snapshot.dart' as _i5;
import 'inventory.dart' as _i6;
import 'ledger.dart' as _i7;
import 'ledger_line_item.dart' as _i8;
import 'payment_status.dart' as _i9;
import 'requests/catalog_update_params.dart' as _i10;
import 'requests/inventory_update_params.dart' as _i11;
import 'responses/response.dart' as _i12;
import 'responses/workspace_summary.dart' as _i13;
import 'transaction_type.dart' as _i14;
import 'workspace.dart' as _i15;
import 'workspace_dashboard_data.dart' as _i16;
import 'workspace_invitation.dart' as _i17;
import 'workspace_member.dart' as _i18;
import 'workspace_member_info.dart' as _i19;
import 'workspace_role.dart' as _i20;
import 'package:hololine_server/src/generated/catalog.dart' as _i21;
import 'package:hololine_server/src/generated/ledger_line_item.dart' as _i22;
import 'package:hololine_server/src/generated/ledger.dart' as _i23;
import 'package:hololine_server/src/generated/responses/workspace_summary.dart'
    as _i24;
import 'package:hololine_server/src/generated/workspace.dart' as _i25;
export 'catalog.dart';
export 'catalog_snapshot.dart';
export 'inventory.dart';
export 'ledger.dart';
export 'ledger_line_item.dart';
export 'payment_status.dart';
export 'requests/catalog_update_params.dart';
export 'requests/inventory_update_params.dart';
export 'responses/response.dart';
export 'responses/workspace_summary.dart';
export 'transaction_type.dart';
export 'workspace.dart';
export 'workspace_dashboard_data.dart';
export 'workspace_invitation.dart';
export 'workspace_member.dart';
export 'workspace_member_info.dart';
export 'workspace_role.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'catalog',
      dartName: 'Catalog',
      schema: 'public',
      module: 'hololine',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'catalog_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'workspaceId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'type',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'sku',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'unit',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'category',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'weight',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'minOrderQty',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'price',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'currency',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'NGN\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'status',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'active\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'addedByName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'addedById',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'lastModifiedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'catalog_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'catalog_workspace_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'workspaceId',
            )
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'catalog_sku_workspace_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'workspaceId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'sku',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'inventory',
      dartName: 'Inventory',
      schema: 'public',
      module: 'hololine',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'inventory_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'workspaceId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'catalogId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'currentQty',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'availableQty',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'totalValue',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'location',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'lowStockThreshold',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'lastRestockedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'lastRestockedByName',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'lastRestockedById',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'lastDeductedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'lastDeductedByName',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'lastDeductedById',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'lastModifiedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'inventory_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'inventory_workspace_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'workspaceId',
            )
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'inventory_catalog_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'catalogId',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'invitation',
      dartName: 'WorkspaceInvitation',
      schema: 'public',
      module: 'hololine',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'invitation_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'workspaceId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'inviteeEmail',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'inviterId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'role',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'protocol:WorkspaceRole',
        ),
        _i2.ColumnDefinition(
          name: 'token',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'expiresAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'acceptedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'invitation_fk_0',
          columns: ['workspaceId'],
          referenceTable: 'workspace',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'invitation_fk_1',
          columns: ['inviterId'],
          referenceTable: 'serverpod_user_info',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'invitation_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'ledger',
      dartName: 'Ledger',
      schema: 'public',
      module: 'hololine',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'ledger_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'workspaceId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'referenceNumber',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'transactionType',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'protocol:TransactionType',
        ),
        _i2.ColumnDefinition(
          name: 'paymentStatus',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'protocol:PaymentStatus',
        ),
        _i2.ColumnDefinition(
          name: 'totalAmount',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'currency',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'NGN\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'notes',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'transactionAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'createdByName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'createdById',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'counterpartyName',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'lastModifiedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'ledger_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'ledger_workspace_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'workspaceId',
            )
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'ledger_type_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'workspaceId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'transactionType',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'ledger_line_item',
      dartName: 'LedgerLineItem',
      schema: 'public',
      module: 'hololine',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'ledger_line_item_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'workspaceId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'ledgerId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'catalogId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'catalogName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'catalogSku',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'unitPrice',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'quantity',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'unit',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'currency',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'NGN\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'subtotal',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'position',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'ledger_line_item_fk_0',
          columns: ['ledgerId'],
          referenceTable: 'ledger',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'ledger_line_item_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'ledger_line_item_ledger_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'ledgerId',
            )
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'ledger_line_item_workspace_catalog_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'workspaceId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'catalogId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'workspace',
      dartName: 'Workspace',
      schema: 'public',
      module: 'hololine',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'workspace_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'publicId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'parentId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'isPremium',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'deletedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'archivedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'pendingDeletionUntil',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'workspace_fk_0',
          columns: ['parentId'],
          referenceTable: 'workspace',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'workspace_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'workspace_public_id_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'publicId',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'workspace_member',
      dartName: 'WorkspaceMember',
      schema: 'public',
      module: 'hololine',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'workspace_member_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'userInfoId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'workspaceId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'role',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'protocol:WorkspaceRole',
        ),
        _i2.ColumnDefinition(
          name: 'invitedById',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'joinedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'isActive',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'workspace_member_fk_0',
          columns: ['userInfoId'],
          referenceTable: 'serverpod_user_info',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'workspace_member_fk_1',
          columns: ['workspaceId'],
          referenceTable: 'workspace',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'workspace_member_fk_2',
          columns: ['invitedById'],
          referenceTable: 'serverpod_user_info',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'workspace_member_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'user_workspace_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userInfoId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'workspaceId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i4.Catalog) {
      return _i4.Catalog.fromJson(data) as T;
    }
    if (t == _i5.CatalogSnapshot) {
      return _i5.CatalogSnapshot.fromJson(data) as T;
    }
    if (t == _i6.Inventory) {
      return _i6.Inventory.fromJson(data) as T;
    }
    if (t == _i7.Ledger) {
      return _i7.Ledger.fromJson(data) as T;
    }
    if (t == _i8.LedgerLineItem) {
      return _i8.LedgerLineItem.fromJson(data) as T;
    }
    if (t == _i9.PaymentStatus) {
      return _i9.PaymentStatus.fromJson(data) as T;
    }
    if (t == _i10.CatalogUpdateParams) {
      return _i10.CatalogUpdateParams.fromJson(data) as T;
    }
    if (t == _i11.InventoryUpdateParams) {
      return _i11.InventoryUpdateParams.fromJson(data) as T;
    }
    if (t == _i12.Response) {
      return _i12.Response.fromJson(data) as T;
    }
    if (t == _i13.WorkspaceSummary) {
      return _i13.WorkspaceSummary.fromJson(data) as T;
    }
    if (t == _i14.TransactionType) {
      return _i14.TransactionType.fromJson(data) as T;
    }
    if (t == _i15.Workspace) {
      return _i15.Workspace.fromJson(data) as T;
    }
    if (t == _i16.WorkspaceDashboardData) {
      return _i16.WorkspaceDashboardData.fromJson(data) as T;
    }
    if (t == _i17.WorkspaceInvitation) {
      return _i17.WorkspaceInvitation.fromJson(data) as T;
    }
    if (t == _i18.WorkspaceMember) {
      return _i18.WorkspaceMember.fromJson(data) as T;
    }
    if (t == _i19.WorkspaceMemberInfo) {
      return _i19.WorkspaceMemberInfo.fromJson(data) as T;
    }
    if (t == _i20.WorkspaceRole) {
      return _i20.WorkspaceRole.fromJson(data) as T;
    }
    if (t == _i1.getType<_i4.Catalog?>()) {
      return (data != null ? _i4.Catalog.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.CatalogSnapshot?>()) {
      return (data != null ? _i5.CatalogSnapshot.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.Inventory?>()) {
      return (data != null ? _i6.Inventory.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.Ledger?>()) {
      return (data != null ? _i7.Ledger.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.LedgerLineItem?>()) {
      return (data != null ? _i8.LedgerLineItem.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.PaymentStatus?>()) {
      return (data != null ? _i9.PaymentStatus.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.CatalogUpdateParams?>()) {
      return (data != null ? _i10.CatalogUpdateParams.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.InventoryUpdateParams?>()) {
      return (data != null ? _i11.InventoryUpdateParams.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.Response?>()) {
      return (data != null ? _i12.Response.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.WorkspaceSummary?>()) {
      return (data != null ? _i13.WorkspaceSummary.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.TransactionType?>()) {
      return (data != null ? _i14.TransactionType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.Workspace?>()) {
      return (data != null ? _i15.Workspace.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.WorkspaceDashboardData?>()) {
      return (data != null ? _i16.WorkspaceDashboardData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i17.WorkspaceInvitation?>()) {
      return (data != null ? _i17.WorkspaceInvitation.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i18.WorkspaceMember?>()) {
      return (data != null ? _i18.WorkspaceMember.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.WorkspaceMemberInfo?>()) {
      return (data != null ? _i19.WorkspaceMemberInfo.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i20.WorkspaceRole?>()) {
      return (data != null ? _i20.WorkspaceRole.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<List<_i8.LedgerLineItem>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i8.LedgerLineItem>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i18.WorkspaceMember>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i18.WorkspaceMember>(e))
              .toList()
          : null) as T;
    }
    if (t == List<_i19.WorkspaceMemberInfo>) {
      return (data as List)
          .map((e) => deserialize<_i19.WorkspaceMemberInfo>(e))
          .toList() as T;
    }
    if (t == List<_i21.Catalog>) {
      return (data as List).map((e) => deserialize<_i21.Catalog>(e)).toList()
          as T;
    }
    if (t == List<_i22.LedgerLineItem>) {
      return (data as List)
          .map((e) => deserialize<_i22.LedgerLineItem>(e))
          .toList() as T;
    }
    if (t == List<_i23.Ledger>) {
      return (data as List).map((e) => deserialize<_i23.Ledger>(e)).toList()
          as T;
    }
    if (t == List<_i24.WorkspaceSummary>) {
      return (data as List)
          .map((e) => deserialize<_i24.WorkspaceSummary>(e))
          .toList() as T;
    }
    if (t == List<_i25.Workspace>) {
      return (data as List).map((e) => deserialize<_i25.Workspace>(e)).toList()
          as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i4.Catalog) {
      return 'Catalog';
    }
    if (data is _i5.CatalogSnapshot) {
      return 'CatalogSnapshot';
    }
    if (data is _i6.Inventory) {
      return 'Inventory';
    }
    if (data is _i7.Ledger) {
      return 'Ledger';
    }
    if (data is _i8.LedgerLineItem) {
      return 'LedgerLineItem';
    }
    if (data is _i9.PaymentStatus) {
      return 'PaymentStatus';
    }
    if (data is _i10.CatalogUpdateParams) {
      return 'CatalogUpdateParams';
    }
    if (data is _i11.InventoryUpdateParams) {
      return 'InventoryUpdateParams';
    }
    if (data is _i12.Response) {
      return 'Response';
    }
    if (data is _i13.WorkspaceSummary) {
      return 'WorkspaceSummary';
    }
    if (data is _i14.TransactionType) {
      return 'TransactionType';
    }
    if (data is _i15.Workspace) {
      return 'Workspace';
    }
    if (data is _i16.WorkspaceDashboardData) {
      return 'WorkspaceDashboardData';
    }
    if (data is _i17.WorkspaceInvitation) {
      return 'WorkspaceInvitation';
    }
    if (data is _i18.WorkspaceMember) {
      return 'WorkspaceMember';
    }
    if (data is _i19.WorkspaceMemberInfo) {
      return 'WorkspaceMemberInfo';
    }
    if (data is _i20.WorkspaceRole) {
      return 'WorkspaceRole';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
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
      return deserialize<_i4.Catalog>(data['data']);
    }
    if (dataClassName == 'CatalogSnapshot') {
      return deserialize<_i5.CatalogSnapshot>(data['data']);
    }
    if (dataClassName == 'Inventory') {
      return deserialize<_i6.Inventory>(data['data']);
    }
    if (dataClassName == 'Ledger') {
      return deserialize<_i7.Ledger>(data['data']);
    }
    if (dataClassName == 'LedgerLineItem') {
      return deserialize<_i8.LedgerLineItem>(data['data']);
    }
    if (dataClassName == 'PaymentStatus') {
      return deserialize<_i9.PaymentStatus>(data['data']);
    }
    if (dataClassName == 'CatalogUpdateParams') {
      return deserialize<_i10.CatalogUpdateParams>(data['data']);
    }
    if (dataClassName == 'InventoryUpdateParams') {
      return deserialize<_i11.InventoryUpdateParams>(data['data']);
    }
    if (dataClassName == 'Response') {
      return deserialize<_i12.Response>(data['data']);
    }
    if (dataClassName == 'WorkspaceSummary') {
      return deserialize<_i13.WorkspaceSummary>(data['data']);
    }
    if (dataClassName == 'TransactionType') {
      return deserialize<_i14.TransactionType>(data['data']);
    }
    if (dataClassName == 'Workspace') {
      return deserialize<_i15.Workspace>(data['data']);
    }
    if (dataClassName == 'WorkspaceDashboardData') {
      return deserialize<_i16.WorkspaceDashboardData>(data['data']);
    }
    if (dataClassName == 'WorkspaceInvitation') {
      return deserialize<_i17.WorkspaceInvitation>(data['data']);
    }
    if (dataClassName == 'WorkspaceMember') {
      return deserialize<_i18.WorkspaceMember>(data['data']);
    }
    if (dataClassName == 'WorkspaceMemberInfo') {
      return deserialize<_i19.WorkspaceMemberInfo>(data['data']);
    }
    if (dataClassName == 'WorkspaceRole') {
      return deserialize<_i20.WorkspaceRole>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i3.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i4.Catalog:
        return _i4.Catalog.t;
      case _i6.Inventory:
        return _i6.Inventory.t;
      case _i7.Ledger:
        return _i7.Ledger.t;
      case _i8.LedgerLineItem:
        return _i8.LedgerLineItem.t;
      case _i15.Workspace:
        return _i15.Workspace.t;
      case _i17.WorkspaceInvitation:
        return _i17.WorkspaceInvitation.t;
      case _i18.WorkspaceMember:
        return _i18.WorkspaceMember.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'hololine';
}
