-- loops_1.sql - Monday, November 21, 2022
/* VERSION: 1.1.19
*/

SET search_path TO media_library,public;

DO
$do$
DECLARE
	filedates RECORD;
BEGIN
FOR filedates IN
	SELECT DISTINCT playdate
	FROM dt_playinfo dp
	WHERE playdate < CURRENT_DATE
	ORDER BY playdate DESC
	LIMIT 3
LOOP
	RAISE NOTICE 'File Date: %', filedates.playdate;
	SELECT	ROW_NUMBER() OVER (ORDER BY count(*) DESC) rownum, count(*) playcount,
		dpt.filename
	FROM	dt_playinfo dpt INNER JOIN
		dim_date dd ON
			dpt.playdate = dd.date_actual 
	WHERE	dd.date_actual = filedates.playdate AND
		dpt.filename LIKE $$/home/patrick/Music/%$$
	GROUP BY dpt.filename
	ORDER BY playcount DESC
	LIMIT 10;
END LOOP;
END $do$;
