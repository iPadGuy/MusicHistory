-- Revert MusicHistory:dt_playhistory from pg

BEGIN;

DROP TABLE dt_playhistory;

COMMIT;
