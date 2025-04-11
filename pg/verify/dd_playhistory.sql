-- Verify MusicHistory:dd_playhistory on pg

BEGIN;

SET search_path TO new_media_library,public;

SELECT	dpt.playdate, dpt.filename, dpt.play_secs, dpt.play_time,
	dd.week_thru,
	dd.week_thru_iso,
	dd.month_thru,
	dd.quarter_thru,
	dd.year_thru
FROM dd_playhistory
WHERE FALSE;

ROLLBACK;
