-- Revert MusicHistory:app_schema from pg

BEGIN;

DROP SCHEMA app_schema;

COMMIT;
