-- Revert MusicHistory:dt_playhistory from pg

BEGIN;

SET search_path TO new_media_library,public;

DROP TABLE IF EXISTS dt_playhistory;

COMMIT;
