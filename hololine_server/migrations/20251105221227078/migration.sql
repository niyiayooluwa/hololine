BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "workspace" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "description" text,
    "parentId" bigint,
    "isPremium" boolean NOT NULL DEFAULT false,
    "createdAt" timestamp without time zone NOT NULL,
    "deletedAt" timestamp without time zone,
    "archivedAt" timestamp without time zone
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "workspace_member" (
    "id" bigserial PRIMARY KEY,
    "userInfoId" bigint NOT NULL,
    "workspaceId" bigint NOT NULL,
    "role" bigint NOT NULL,
    "invitedById" bigint,
    "joinedAt" timestamp without time zone NOT NULL,
    "isActive" boolean NOT NULL DEFAULT true
);

-- Indexes
CREATE UNIQUE INDEX "user_workspace_unique_idx" ON "workspace_member" USING btree ("userInfoId", "workspaceId");

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
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "workspace_member"
    ADD CONSTRAINT "workspace_member_fk_0"
    FOREIGN KEY("userInfoId")
    REFERENCES "serverpod_auth_user_info"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "workspace_member"
    ADD CONSTRAINT "workspace_member_fk_1"
    FOREIGN KEY("workspaceId")
    REFERENCES "workspace"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "workspace_member"
    ADD CONSTRAINT "workspace_member_fk_2"
    FOREIGN KEY("invitedById")
    REFERENCES "serverpod_auth_user_info"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR hololine
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('hololine', '20251105221227078', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251105221227078', "timestamp" = now();

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
