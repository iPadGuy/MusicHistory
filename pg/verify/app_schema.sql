-- Verify MusicHistory:app_schema on pg

BEGIN;

SELECT pg_catalog.has_schema_privilege('media_library', 'usage');

ROLLBACK;
