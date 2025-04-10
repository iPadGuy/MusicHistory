-- Deploy MusicHistory:dt_playhistory to pg

BEGIN;

SET search_path TO new_media_library,public;

CREATE TABLE dt_playhistory(
	id		INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY(START WITH 100001),
	playdatetime	TIMESTAMPTZ NOT NULL UNIQUE,
	playdate	DATE NOT NULL,
	play_secs	DECIMAL(20,6) NOT NULL,
	play_time	INTERVAL NOT NULL
);

-- Indexes
CREATE INDEX idx_playhistory_playdate ON dt_playhistory(playdate);
CREATE INDEX idx_playhistory_playsecs ON dt_playhistory(play_secs);

-- Comments
COMMENT ON TABLE dt_playhistory IS "Music History Table";
COMMENT ON COLUMN dt_playhistory.id IS "Database ID";
COMMENT ON COLUMN dt_playhistory.playdatetime IS "Time of Play Start";
COMMENT ON COLUMN dt_playhistory.play_secs IS "Play Time Duration (seconds)";
COMMENT ON COLUMN dt_playhistory.play_time IS "Play Time Duration (HH:MM:SS)";

COMMIT;
