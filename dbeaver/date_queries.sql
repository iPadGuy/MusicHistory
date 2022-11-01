-- date_queries.sql - Sunday, October 30, 2022

SET search_path TO media_library,public;

SELECT	dpt.playdatetime, dd.date_actual, dd.week_of_year,
	dd.first_day_of_week , dd.last_day_of_week  
FROM	dt_playinfo_test dpt INNER JOIN
	dim_date dd ON
		dpt.playdate = dd.date_actual 
ORDER BY playdate DESC
LIMIT 100;
