-- Verify MusicHistory:dt_playhistory on pg

BEGIN;

SET search_path TO new_media_library,public;

SELECT id, playdatetime, playdate, play_secs, play_time
FROM dt_playhistory
WHERE FALSE;

ROLLBACK;
