-- Verify MusicHistory:app_schema on pg

BEGIN;

SELECT pg_catalog.has_schema_privilege('new_media_library', 'usage');

ROLLBACK;
