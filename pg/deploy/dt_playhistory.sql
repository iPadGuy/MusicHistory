-- Deploy MusicHistory:dt_playhistory to pg
-- requires: app_schema

BEGIN;

SET search_path TO new_media_library,public;

CREATE TABLE dt_playhistory(
	id		INTEGER PRIMARY KEY GENERATED ALWAYS AS IDENTITY(START WITH 100001),
	playdate	DATE NOT NULL,
	playdatetime	TIMESTAMPTZ NOT NULL UNIQUE,
	stopdatetime	TIMESTAMPTZ,
	filename	TEXT,
	play_secs	DECIMAL(20,6) NOT NULL,
	play_time	INTERVAL NOT NULL
);

-- Indexes
CREATE INDEX idx_playhistory_playdate ON dt_playhistory(playdate);
CREATE INDEX idx_playhistory_filename ON dt_playhistory(filename);
CREATE INDEX idx_playhistory_playlists ON dt_playhistory(playdate, play_secs, filename);

-- Comments
COMMENT ON TABLE dt_playhistory IS 'Music History Table';
COMMENT ON COLUMN dt_playhistory.id IS 'Database ID';
COMMENT ON COLUMN dt_playhistory.playdate IS 'Play Date';
COMMENT ON COLUMN dt_playhistory.playdatetime IS 'Time Play Started';
COMMENT ON COLUMN dt_playhistory.stopdatetime IS 'Time Play Ended';
COMMENT ON COLUMN dt_playhistory.filename IS 'Filename';
COMMENT ON COLUMN dt_playhistory.play_secs IS 'Play Time Duration (seconds)';
COMMENT ON COLUMN dt_playhistory.play_time IS 'Play Time Duration (HH:MM:SS)';

COMMIT;
