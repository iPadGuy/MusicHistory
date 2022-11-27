-- dt_not_iso.sql - Thursday, November 24, 2022

DROP TABLE IF EXISTS dt_not_iso;

CREATE TABLE IF NOT EXISTS dt_not_iso (
	date_id			INT NOT NULL PRIMARY KEY,
	cal_date		DATE NOT NULL,
	epoch			BIGINT NOT NULL,
	day_name		VARCHAR(9) NOT NULL,
	day_of_week		INT NOT NULL,
	day_of_week_iso		INT NOT NULL,
	day_of_month		INT NOT NULL,
	day_of_year		INT NOT NULL,
	week_of_year		INT NOT NULL,
	week_of_year_iso	INT NOT NULL,
	-- week_name		VARCHAR(3) NOT NULL,
	-- week_name_iso	VARCHAR(3) NOT NULL,
	first_day_of_week	DATE NOT NULL,
	last_day_of_week	DATE NOT NULL,
	first_day_of_week_iso	DATE NOT NULL,
	last_day_of_week_iso	DATE NOT NULL,
	month_of_year		INT NOT NULL,
	month_name		VARCHAR(9) NOT NULL,
	month_abbr		VARCHAR(3) NOT NULL,
	first_day_of_month	DATE NOT NULL,
	last_day_of_month	DATE NOT NULL
);

CREATE UNIQUE INDEX idx_cal_date ON dt_not_iso(cal_date);


INSERT INTO dt_not_iso
SELECT	TO_CHAR(datum, 'YYYYMMDD')::INT AS date_id,
	datum AS cal_date,
	EXTRACT(EPOCH FROM datum) AS epoch,
	TO_CHAR(datum, 'TMDay') AS day_name,
	EXTRACT(DOW FROM datum) AS day_of_week,
	EXTRACT(ISODOW FROM datum) AS day_of_week_iso,
	EXTRACT(DAY FROM datum) AS day_of_month,
	EXTRACT(DOY FROM datum) AS day_of_year,
	EXTRACT(WEEK FROM datum + INTERVAL '1 day') AS week_of_year,
	EXTRACT(WEEK FROM datum) AS week_of_year_iso,
	datum + (0 - EXTRACT(DOW FROM datum))::INT AS first_day_of_week,
	datum + (6 - EXTRACT(DOW FROM datum))::INT AS last_day_of_week,
	datum + (1 - EXTRACT(ISODOW FROM datum))::INT AS first_day_of_week_iso,
	datum + (7 - EXTRACT(ISODOW FROM datum))::INT AS last_day_of_week_iso,
	EXTRACT(MONTH FROM datum) AS month_of_year,
	TO_CHAR(datum, 'TMMonth') AS month_name,
	TO_CHAR(datum, 'Mon') AS month_abbr,
	datum + (1 - EXTRACT(DAY FROM datum))::INT AS first_day_of_month,
	(DATE_TRUNC('MONTH', datum) + INTERVAL '1 MONTH - 1 day')::DATE AS last_day_of_month
	
	
FROM (SELECT '1977-01-01'::DATE + SEQUENCE.DAY AS datum
      FROM GENERATE_SERIES(0, 15) AS SEQUENCE (DAY)
      GROUP BY SEQUENCE.DAY) DQ
ORDER BY 1;


SELECT * FROM dt_not_iso;

SELECT	dni.cal_date, dni.day_name,
	dni.week_of_year, dd.week_of_year,
	dni.week_of_year_iso, dd.week_of_year_id, dd.week_of_year_iso_id,
	dni.first_day_of_week, dd.first_day_of_week, 
	dni.first_day_of_week_iso, dd.first_day_of_week_iso, 
	dni.last_day_of_week, dd.last_day_of_week, 
	dni.last_day_of_week_iso, dd.last_day_of_week_iso 
FROM 	dt_not_iso dni INNER JOIN
	dim_date dd ON
		dni.date_id = dd.date_dim_id 
LIMIT 10;

/*
SELECT '1970-12-01'::DATE + SEQUENCE.DAY AS datum
FROM GENERATE_SERIES(0, 95) AS SEQUENCE (DAY)
GROUP BY SEQUENCE.DAY
ORDER BY 1;
*/



