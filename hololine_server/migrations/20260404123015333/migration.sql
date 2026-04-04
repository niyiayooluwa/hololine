BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "catalog" (
    "id" bigserial PRIMARY KEY,
    "workspaceId" bigint NOT NULL,
    "name" text NOT NULL,
    "type" text NOT NULL,
    "sku" text,
    "unit" text NOT NULL,
    "category" text,
    "weight" double precision,
    "minOrderQty" bigint,
    "price" double precision NOT NULL,
    "currency" text NOT NULL DEFAULT 'NGN'::text,
    "status" text NOT NULL DEFAULT 'active'::text,
    "addedByName" text NOT NULL,
    "addedById" bigint,
    "createdAt" timestamp without time zone NOT NULL,
    "lastModifiedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "catalog_workspace_idx" ON "catalog" USING btree ("workspaceId");
CREATE UNIQUE INDEX "catalog_sku_workspace_idx" ON "catalog" USING btree ("workspaceId", "sku");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "inventory" (
    "id" bigserial PRIMARY KEY,
    "workspaceId" bigint NOT NULL,
    "catalogId" bigint NOT NULL,
    "currentQty" double precision NOT NULL,
    "availableQty" double precision NOT NULL,
    "totalValue" double precision NOT NULL,
    "location" text,
    "lowStockThreshold" double precision,
    "lastRestockedAt" timestamp without time zone,
    "lastRestockedByName" text,
    "lastRestockedById" bigint,
    "lastDeductedAt" timestamp without time zone,
    "lastDeductedByName" text,
    "lastDeductedById" bigint,
    "createdAt" timestamp without time zone NOT NULL,
    "lastModifiedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "inventory_workspace_idx" ON "inventory" USING btree ("workspaceId");
CREATE UNIQUE INDEX "inventory_catalog_idx" ON "inventory" USING btree ("catalogId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ledger" (
    "id" bigserial PRIMARY KEY,
    "workspaceId" bigint NOT NULL,
    "referenceNumber" text,
    "transactionType" text NOT NULL,
    "paymentStatus" text NOT NULL,
    "totalAmount" double precision NOT NULL,
    "notes" text,
    "transactionAt" timestamp without time zone NOT NULL,
    "createdByName" text NOT NULL,
    "createdById" bigint,
    "counterpartyName" text,
    "createdAt" timestamp without time zone NOT NULL,
    "lastModifiedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "ledger_workspace_idx" ON "ledger" USING btree ("workspaceId");
CREATE INDEX "ledger_type_idx" ON "ledger" USING btree ("workspaceId", "transactionType");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ledger_line_item" (
    "id" bigserial PRIMARY KEY,
    "workspaceId" bigint NOT NULL,
    "ledgerId" bigint NOT NULL,
    "catalogId" bigint NOT NULL,
    "catalogName" text NOT NULL,
    "catalogSku" text,
    "unitPrice" double precision NOT NULL,
    "quantity" double precision NOT NULL,
    "unit" text NOT NULL,
    "subtotal" double precision NOT NULL,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "ledger_line_item_ledger_idx" ON "ledger_line_item" USING btree ("ledgerId");
CREATE INDEX "ledger_line_item_workspace_catalog_idx" ON "ledger_line_item" USING btree ("workspaceId", "catalogId");


--
-- MIGRATION VERSION FOR hololine
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('hololine', '20260404123015333', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260404123015333', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20240520102713718', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240520102713718', "timestamp" = now();


COMMIT;
