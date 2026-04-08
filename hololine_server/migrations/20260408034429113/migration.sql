BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "product" CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "catalog" CASCADE;

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
    "minOrderQty" double precision,
    "price" bigint NOT NULL,
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
-- ACTION DROP TABLE
--
DROP TABLE "inventory" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "inventory" (
    "id" bigserial PRIMARY KEY,
    "workspaceId" bigint NOT NULL,
    "catalogId" bigint NOT NULL,
    "currentQty" double precision NOT NULL,
    "availableQty" double precision NOT NULL,
    "totalValue" bigint NOT NULL,
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
-- ACTION DROP TABLE
--
DROP TABLE "ledger" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "ledger" (
    "id" bigserial PRIMARY KEY,
    "workspaceId" bigint NOT NULL,
    "referenceNumber" text,
    "transactionType" bigint NOT NULL,
    "paymentStatus" bigint NOT NULL,
    "totalAmount" bigint NOT NULL,
    "currency" text NOT NULL DEFAULT 'NGN'::text,
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
-- ACTION DROP TABLE
--
DROP TABLE "ledger_line_item" CASCADE;

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
    "unitPrice" bigint NOT NULL,
    "quantity" double precision NOT NULL,
    "unit" text NOT NULL,
    "currency" text NOT NULL DEFAULT 'NGN'::text,
    "subtotal" bigint NOT NULL,
    "position" bigint NOT NULL DEFAULT 0,
    "createdAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "ledger_line_item_ledger_idx" ON "ledger_line_item" USING btree ("ledgerId");
CREATE INDEX "ledger_line_item_workspace_catalog_idx" ON "ledger_line_item" USING btree ("workspaceId", "catalogId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "ledger_line_item"
    ADD CONSTRAINT "ledger_line_item_fk_0"
    FOREIGN KEY("ledgerId")
    REFERENCES "ledger"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR hololine
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('hololine', '20260408034429113', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260408034429113', "timestamp" = now();

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
