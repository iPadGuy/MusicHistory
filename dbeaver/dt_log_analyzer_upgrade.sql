-- dt_log_analyzer_upgrade.sql - Tuesday, November 1, 2022
/**
 * 
 */

SET search_path TO media_library,public;

INSERT INTO dt_playinfo_test (epochtime, playdate, playdatetime, filename)
SELECT a.epochtime, playdate::DATE playdate, playdate playdatetime, filename
FROM (	SELECT epochtime, max(playdate) playdate, max(filename) filename 
	FROM dt_log_analyzer dla 
	GROUP BY epochtime
	ORDER BY epochtime
) a;

SELECT * FROM d_date dd LIMIT 10;

SELECT * FROM dt_playinfo_test LIMIT 10;

SELECT a.* FROM (
	SELECT epochtime, count(*), min(playdate) col1, max(playdate) col2
	FROM dt_log_analyzer dla 
	GROUP BY epochtime HAVING count(*) > 1
	ORDER BY epochtime DESC) a
WHERE a.col1 <> a.col2;

SELECT a.epochtime, playdate::DATE playdate, playdate playdatetime, filename
FROM (	SELECT epochtime, max(playdate) playdate, max(filename) filename 
	FROM dt_log_analyzer dla 
	GROUP BY epochtime
	ORDER BY epochtime
) a;

