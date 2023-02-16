-- Dusty.sql -- Thursday, February 16, 2023
/*  */

SET search_path TO media_library,public;

/* 
DROP VIEW recent_plays_3;
DROP VIEW recent_plays_30;
DROP VIEW older_plays_3;
DROP VIEW older_plays_30;
*/

-- DROP VIEW recent_plays_3 
CREATE VIEW recent_plays_3 AS
SELECT * 
FROM dt_playhistory 
WHERE filename LIKE '/home/patrick/Music/%'
  AND filename NOT LIKE '/home/patrick/Music/Christmas/%'
  AND playdate >= current_date - INTERVAL '3 days';

-- DROP VIEW older_plays_3
CREATE VIEW older_plays_3 AS
SELECT * 
FROM dt_playhistory 
WHERE filename LIKE '/home/patrick/Music/%'
  AND filename NOT LIKE '/home/patrick/Music/Christmas/%'
  AND playdate < current_date - INTERVAL '3 days';

/* SELECT	op.*
FROM	older_plays_3 op LEFT OUTER JOIN
	recent_plays_3 rp ON
		op.filename = rp.filename
WHERE	rp.filename IS NULL;
*/
 
 
-- 30 days
-- DROP VIEW recent_plays_30
CREATE VIEW recent_plays_30 AS
SELECT * 
FROM dt_playhistory 
WHERE filename LIKE '/home/patrick/Music/%'
  AND filename NOT LIKE '/home/patrick/Music/Christmas/%'
  AND playdate >= current_date - INTERVAL '30 days';

-- DROP VIEW older_plays_30
CREATE VIEW older_plays_30 AS
SELECT * 
FROM dt_playhistory 
WHERE filename LIKE '/home/patrick/Music/%'
  AND filename NOT LIKE '/home/patrick/Music/Christmas/%'
  AND playdate < current_date - INTERVAL '30 days';
 
/*
SELECT	op.*
FROM	older_plays_30 op LEFT OUTER JOIN
	recent_plays_30 rp ON
		op.filename = rp.filename
WHERE	rp.filename IS NULL;
*/

CREATE VIEW recent_filenames_30 AS
SELECT DISTINCT filename
FROM recent_plays_30;
 
CREATE VIEW older_filenames_30 AS
SELECT DISTINCT filename
FROM older_plays_30;


CREATE VIEW dusty_30 AS
SELECT	op.filename
FROM	older_filenames_30 op LEFT OUTER JOIN
	recent_filenames_30 rp ON
		op.filename = rp.filename
WHERE	rp.filename IS NULL; 


-- SELECT count(*) FROM dusty_30;

SELECT * FROM dusty_30 ORDER BY random() LIMIT 25;










