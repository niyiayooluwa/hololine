BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "workspace" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "workspace" (
    "id" bigserial PRIMARY KEY,
    "publicId" text NOT NULL,
    "name" text NOT NULL,
    "description" text NOT NULL,
    "parentId" bigint,
    "isPremium" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL,
    "deletedAt" timestamp without time zone,
    "archivedAt" timestamp without time zone,
    "pendingDeletionUntil" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "workspace_public_id_idx" ON "workspace" USING btree ("publicId");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "workspace"
    ADD CONSTRAINT "workspace_fk_0"
    FOREIGN KEY("parentId")
    REFERENCES "workspace"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR hololine
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('hololine', '20260321093002920', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260321093002920', "timestamp" = now();

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
