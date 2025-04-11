-- Revert MusicHistory:dd_playhistory from pg

BEGIN;

SET search_path TO new_media_library,public;

DROP VIEW dd_playhistory;

COMMIT;
