-- Revert MusicHistory:dt_playhistory3 from pg

BEGIN;

DROP TABLE dt_playhistory3;

COMMIT;
