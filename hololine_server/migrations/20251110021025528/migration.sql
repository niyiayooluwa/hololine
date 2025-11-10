BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "invitation" (
    "id" bigserial PRIMARY KEY,
    "workspaceId" bigint NOT NULL,
    "inviteeEmail" text NOT NULL,
    "inviterId" bigint NOT NULL,
    "role" bigint NOT NULL,
    "token" text NOT NULL,
    "expiresAt" timestamp without time zone NOT NULL,
    "acceptedAt" timestamp without time zone
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "invitation"
    ADD CONSTRAINT "invitation_fk_0"
    FOREIGN KEY("workspaceId")
    REFERENCES "workspace"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "invitation"
    ADD CONSTRAINT "invitation_fk_1"
    FOREIGN KEY("inviterId")
    REFERENCES "serverpod_user_info"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR hololine
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('hololine', '20251110021025528', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251110021025528', "timestamp" = now();

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
