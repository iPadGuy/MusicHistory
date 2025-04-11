-- Deploy MusicHistory:dd_playhistory to pg
-- requires: app_schema
-- requires: dt_playhistory

BEGIN;

SET search_path TO new_media_library,public;

CREATE VIEW dd_playhistory AS
SELECT	dpt.playdate, dpt.filename, dpt.play_secs, dpt.play_time,
	dd.week_thru,
	dd.week_thru_iso,
	dd.month_thru,
	dd.quarter_thru,
	dd.year_thru
FROM	dt_playhistory dpt INNER JOIN
	dim_date dd ON
		dpt.playdate = dd.date_id
LIMIT 10000;

COMMIT;
