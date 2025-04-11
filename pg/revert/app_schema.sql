-- Revert MusicHistory:app_schema from pg

BEGIN;

DROP SCHEMA IF EXISTS new_media_library;

COMMIT;
