-- Verify MusicHistory:dt_playhistory3 on pg

BEGIN;

SET search_path TO media_library,public;

SELECT id, playdatetime, playdate, play_secs, play_time
FROM dt_playhistory3
WHERE FALSE;

ROLLBACK;
