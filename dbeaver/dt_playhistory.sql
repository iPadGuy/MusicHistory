-- dt_playhistory.sql - Monday, November 28, 2022
/* Ref: https://stackoverflow.com/a/71041431/2719754
 * 
 * Example:
 * 
select 
    t1."timestamp", 
    t1.state, 
    (t2."timestamp" - t1."timestamp")::interval hour to minute as "duration"
from 
    (
        select "timestamp", state,  
        (ROW_NUMBER () OVER (ORDER BY idx)) as row_num 
        from test.tbl_status
    ) t1 
inner join 
    (
        select "timestamp",
        (ROW_NUMBER () OVER (ORDER BY idx)) as row_num 
        from test.tbl_status
    ) t2 on t1.row_num + 1 = t2.row_num
 */
SET search_path TO media_library,public;

-- DROP VIEW play_times;
CREATE VIEW play_times AS
SELECT	t1.id id, t1.filename, 
	t1.playdatetime playdatetime,
	t1.epochtime epochtime,
    (t2.epochtime - t1.epochtime) AS play_secs,  -- ::interval hour to minute as "duration"
    (t2.playdatetime - t1.playdatetime)::INTERVAL MINUTE TO SECOND AS play_time
FROM	(
	SELECT id, epochtime, playdatetime, filename, ROW_NUMBER() OVER (ORDER BY epochtime) AS row_num
	FROM dt_playhistory
	) t1
INNER JOIN
	(
	SELECT id, epochtime, playdatetime, filename, ROW_NUMBER() OVER (ORDER BY epochtime) AS row_num
	FROM dt_playhistory
	) t2 ON t1.row_num + 1 = t2.row_num
;

SELECT playdatetime, play_secs, play_time, filename
FROM media_library.dt_playhistory
WHERE playdate = CURRENT_DATE - INTERVAL '1 day'
ORDER BY playdatetime DESC
LIMIT 200;

SELECT * FROM dt_playhistory dp 
WHERE filename LIKE '/home/patrick/Music/%'
  AND play_secs < 3 
ORDER BY playdatetime DESC 
LIMIT 10;

SELECT playdate, count(*) FROM dt_playhistory dp 
WHERE filename LIKE '/home/patrick/Music/%'
  AND play_secs < 30
GROUP BY playdate 
ORDER BY playdate DESC;

SELECT * FROM dt_playhistory dp WHERE play_time < '0';

SELECT MIN(playdate) FROM dt_playhistory dp ;

SELECT COUNT(DISTINCT filename) FROM dt_playhistory dp ;

SELECT COUNT(*) FROM dt_playhistory WHERE filename NOT LIKE '/home/%';

/*
UPDATE	dt_playhistory AS ph 
SET 	play_secs = pt.play_secs,
	play_time = pt.play_time 
FROM	play_times AS pt
WHERE	ph.play_secs IS NULL AND
	ph.id = pt.id ;

UPDATE dt_playhistory SET play_time = NULL WHERE play_secs IS NULL;

 */