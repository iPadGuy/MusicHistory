-- date_queries.sql - Sunday, October 30, 2022

SET search_path TO media_library,public;

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

-- Last Month's Top 100 plays
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
