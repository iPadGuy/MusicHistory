-- date_queries.sql - Sunday, October 30, 2022

SET search_path TO media_library,public;

-- Date Test BEGIN
DO
$do$
DECLARE
	filedate DATE;
BEGIN
FOR filedate IN
	SELECT DISTINCT playdate
	FROM dt_playinfo dp
	WHERE playdate < CURRENT_DATE
	ORDER BY playdate DESC
	LIMIT 3
LOOP
	RAISE NOTICE 'File Date: %', filedate;
	COPY (	EXECUTE '
		SELECT	ROW_NUMBER() OVER (ORDER BY count(*) DESC) rownum, count(*) playcount,
			dpt.filename
		FROM	dt_playinfo dpt INNER JOIN
			dim_date dd ON
				dpt.playdate = dd.date_actual 
		WHERE	dd.date_actual = '%', $1 AND
			dpt.filename LIKE '/home/patrick/Music/%'
		GROUP BY dpt.filename
		ORDER BY playcount DESC
		LIMIT 10;'
		USING filedate
	) TO '/tmp/Top10_Daily.m3u';

END LOOP;
END $do$;
-- Date Test END


-- Test BEGIN
DO
$do$
-- DECLARE
-- 	filedate DATE;
BEGIN
	FOR i IN 1 .. 3
	LOOP
		RAISE NOTICE 'Number Count: %', i;
		-- filedate = NOW() - INTERVAL '% day', i
		COPY (
			SELECT	ROW_NUMBER() OVER (ORDER BY count(*) DESC) rownum, count(*) playcount,
				dpt.filename
			FROM	dt_playinfo dpt INNER JOIN
				dim_date dd ON
					dpt.playdate = dd.date_actual 
			WHERE	dd.day_of_year = EXTRACT(DOY FROM NOW() - INTERVAL '% day', i) AND
				dd.year_actual  = EXTRACT(YEAR FROM NOW() - INTERVAL '% day', i) AND
				dpt.filename LIKE '/home/patrick/Music/%'
			GROUP BY dpt.filename
			ORDER BY playcount DESC
			LIMIT 10
		) TO '/tmp/Top10_Daily.m3u';
	END LOOP;
END;
$do$;
-- Test END


-- Yesterday's Top 10 plays
SELECT	ROW_NUMBER() OVER (ORDER BY count(*) DESC) rownum, count(*) playcount, dpt.filename
FROM	dt_playinfo dpt INNER JOIN
	dim_date dd ON
		dpt.playdate = dd.date_actual 
WHERE	dd.day_of_year = EXTRACT(DOY FROM NOW() - INTERVAL '2 day') AND
	dd.year_actual  = EXTRACT(YEAR FROM NOW() - INTERVAL '2 day') AND
	dpt.filename LIKE '/home/patrick/Music/%'
GROUP BY dpt.filename
ORDER BY playcount DESC
LIMIT 10;


-- Last Week's Top 40 plays
SELECT	ROW_NUMBER() OVER (ORDER BY count(*) DESC) rownum, count(*) playcount, dpt.filename
FROM	dt_playinfo dpt INNER JOIN
	dim_date dd ON
		dpt.playdate = dd.date_actual 
WHERE	dd.week_of_year = EXTRACT(WEEK FROM NOW() - INTERVAL '1 week') AND
	dd.year_actual  = EXTRACT(YEAR FROM NOW() - INTERVAL '1 week') AND
	dpt.filename LIKE '/home/patrick/Music/%'
GROUP BY dpt.filename
ORDER BY playcount DESC
LIMIT 40;

-- Last Month's Top 100 plays (October)
SELECT	ROW_NUMBER() OVER (ORDER BY count(*) DESC) rownum, count(*) playcount, dpt.filename
FROM	dt_playinfo dpt INNER JOIN
	dim_date dd ON
		dpt.playdate = dd.date_actual 
WHERE	dd.month_actual = EXTRACT(MONTH FROM NOW() - INTERVAL '1 month') AND
	dd.year_actual  = EXTRACT(YEAR  FROM NOW() - INTERVAL '1 month') AND
	dpt.filename LIKE '/home/patrick/Music/%'
	GROUP BY dpt.filename
ORDER BY playcount DESC
LIMIT 100;


-- Top 100 plays, two months ago
-- I skipped the Top 100 list for September because everything only had one play
SELECT	ROW_NUMBER() OVER (ORDER BY count(*) DESC) rownum, count(*) playcount, dpt.filename
FROM	dt_playinfo dpt INNER JOIN
	dim_date dd ON
		dpt.playdate = dd.date_actual 
WHERE	dd.month_actual = EXTRACT(MONTH FROM NOW() - INTERVAL '2 months') AND
	dd.year_actual  = EXTRACT(YEAR  FROM NOW() - INTERVAL '2 months') AND
	dpt.filename LIKE '/home/patrick/Music/%'
	GROUP BY dpt.filename
ORDER BY playcount DESC
LIMIT 100;


-- Top 100 plays, Three months ago (August)
SELECT	ROW_NUMBER() OVER (ORDER BY count(*) DESC) rownum, count(*) playcount, dpt.filename
FROM	dt_playinfo dpt INNER JOIN
	dim_date dd ON
		dpt.playdate = dd.date_actual 
WHERE	dd.month_actual = EXTRACT(MONTH FROM NOW() - INTERVAL '3 months') AND
	dd.year_actual  = EXTRACT(YEAR  FROM NOW() - INTERVAL '3 months') AND
	dpt.filename LIKE '/home/patrick/Music/%'
	GROUP BY dpt.filename
ORDER BY playcount DESC
LIMIT 100;

-- This year's Top 500 plays (year-to-date after six months)
COPY (
	SELECT	ROW_NUMBER() OVER (ORDER BY count(*) DESC) rownum, count(*) playcount,
		dpt.filename
	FROM	dt_playinfo dpt INNER JOIN
		dim_date dd ON
			dpt.playdate = dd.date_actual 
	WHERE	dd.year_actual  = EXTRACT(YEAR  FROM NOW() - INTERVAL '6 months') AND
		dpt.filename LIKE '/home/patrick/Music/%'
		GROUP BY dpt.filename
	ORDER BY playcount DESC
	LIMIT 500
) TO '/tmp/Top500_2022_YTD.tsv';


-- Last year's Top 500 plays
COPY (
	SELECT	ROW_NUMBER() OVER (ORDER BY count(*) DESC) rownum, count(*) playcount, dpt.filename
	FROM	dt_playinfo dpt INNER JOIN
		dim_date dd ON
			dpt.playdate = dd.date_actual 
	WHERE	dd.year_actual  = EXTRACT(YEAR  FROM NOW() - INTERVAL '1 year') AND
		dpt.filename LIKE '/home/patrick/Music/%'
		GROUP BY dpt.filename
	ORDER BY playcount DESC
	LIMIT 500
) TO '/tmp/Top500_2021.tsv';


-- Top 500 plays, two years ago
COPY (
	SELECT	ROW_NUMBER() OVER (ORDER BY count(*) DESC) rownum, count(*) playcount, dpt.filename
	FROM	dt_playinfo dpt INNER JOIN
		dim_date dd ON
			dpt.playdate = dd.date_actual 
	WHERE	dd.year_actual  = EXTRACT(YEAR  FROM NOW() - INTERVAL '2 years') AND
		dpt.filename LIKE '/home/patrick/Music/%'
		GROUP BY dpt.filename
	ORDER BY playcount DESC
	LIMIT 500
) TO '/tmp/Top500_2020.tsv';


-- Top 500 plays, 2019
COPY (
	SELECT	ROW_NUMBER() OVER (ORDER BY count(*) DESC) rownum, count(*) playcount, dpt.filename
	FROM	dt_playinfo dpt INNER JOIN
		dim_date dd ON
			dpt.playdate = dd.date_actual 
	WHERE	dd.year_actual  = 2019 AND
		dpt.filename LIKE '/home/patrick/Music/%'
		GROUP BY dpt.filename
	ORDER BY playcount DESC
	LIMIT 500
) TO '/tmp/Top500_2019.tsv';


-- Top 500 plays, 2018
COPY (
	SELECT	ROW_NUMBER() OVER (ORDER BY count(*) DESC) rownum, count(*) playcount, dpt.filename
	FROM	dt_playinfo dpt INNER JOIN
		dim_date dd ON
			dpt.playdate = dd.date_actual 
	WHERE	dd.year_actual  = 2018 AND
		dpt.filename LIKE '/home/patrick/Music/%'
		GROUP BY dpt.filename
	ORDER BY playcount DESC
	LIMIT 500
) TO '/tmp/Top500_2018.tsv';





/* Cleanup
SELECT filename 
FROM dt_playinfo dp 
WHERE filename NOT LIKE '/%' AND filename NOT LIKE 'dvd://%'
LIMIT 100;

UPDATE dt_playinfo
SET filename = '/home/patrick/Videos/ydl/' || ltrim(filename, './')
WHERE filename LIKE './%';

UPDATE dt_playinfo
SET filename = '/home/patrick/Downloads/' || ltrim(filename, '../../Downloads/')
WHERE filename LIKE '../../Downloads/%';

UPDATE dt_playinfo
SET filename = '/home/patrick/Videos/utorrent/' || ltrim(filename, '../utorrent/')
WHERE filename LIKE '../utorrent/%';

DELETE FROM dt_playinfo dp 
WHERE filename LIKE '-r%';

DELETE FROM dt_playinfo dp 
WHERE filename NOT LIKE '/%' AND filename NOT LIKE 'dvd://%'
*/
