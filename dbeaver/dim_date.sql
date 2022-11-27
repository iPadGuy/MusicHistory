-- dim_date.sql - Friday, October 28, 2022
/*
 * Ref: https://duffn.github.io/postgresql-date-dimension/
 */


DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_date2;

CREATE TABLE IF NOT EXISTS dim_date (
	id			INT NOT NULL PRIMARY KEY,
	date_id			DATE NOT NULL UNIQUE,
	epoch			BIGINT NOT NULL,
	day_suffix		VARCHAR(4) NOT NULL,
	day_name		VARCHAR(9) NOT NULL,
	day_of_week		INT NOT NULL,
	day_of_week_iso		INT NOT NULL,
	day_of_month		INT NOT NULL,
	day_of_quarter		INT NOT NULL,
	day_of_year		INT NOT NULL,
	week_id			VARCHAR(7) NOT NULL,
	week_id_iso		VARCHAR(7) NOT NULL,
	week_name		VARCHAR(3) NOT NULL,
	week_name_iso		VARCHAR(3) NOT NULL,
	week_of_month		INT NOT NULL,
	week_of_year		INT NOT NULL,
	week_of_year_id		CHAR(10) NOT NULL,
	week_of_year_iso	INT NOT NULL,
	week_of_year_iso_id	CHAR(10) NOT NULL,
	month_of_year		INT NOT NULL,
	month_name		VARCHAR(9) NOT NULL,
	month_abbr		CHAR(3) NOT NULL,
	quarter_of_year		INT NOT NULL,
	quarter_name		VARCHAR(9) NOT NULL,
	quarter_id		CHAR(6) NOT NULL,
	yyyy			INT NOT NULL,
	week_from		DATE NOT NULL,
	week_thru		DATE NOT NULL,
	week_from_iso		DATE NOT NULL,
	week_thru_iso		DATE NOT NULL,
	month_from		DATE NOT NULL,
	month_thru		DATE NOT NULL,
	quarter_from		DATE NOT NULL,
	quarter_thru		DATE NOT NULL,
	year_from		DATE NOT NULL,
	year_thru		DATE NOT NULL,
	mmyyyy			CHAR(6) NOT NULL,
	mmddyyyy		CHAR(10) NOT NULL,
	is_weekend		BOOLEAN NOT NULL
);

-- ALTER TABLE public.dim_date ADD CONSTRAINT dim_date_date_dim_id_pk PRIMARY KEY (id);

-- CREATE INDEX dim_date_actual_idx ON dim_date(date_id);
CREATE INDEX idx_dim_date_week_thru ON dim_date(week_thru);
CREATE INDEX idx_dim_date_month_thru ON dim_date(month_thru);
CREATE INDEX idx_dim_date_year ON dim_date(yyyy);


INSERT INTO dim_date
SELECT TO_CHAR(datum, 'yyyymmdd')::INT AS id,
	datum AS date_id,
	EXTRACT(EPOCH FROM datum) AS epoch,
	TO_CHAR(datum, 'fmDDth') AS day_suffix,
	TO_CHAR(datum, 'TMDay') AS day_name,
	EXTRACT(DOW FROM datum) AS day_of_week,
	EXTRACT(ISODOW FROM datum) AS day_of_week_iso,
	EXTRACT(DAY FROM datum) AS day_of_month,
	datum - DATE_TRUNC('quarter', datum)::DATE + 1 AS day_of_quarter,
	EXTRACT(DOY FROM datum) AS day_of_year,
	EXTRACT(YEAR FROM datum - INTERVAL '1 day') || TO_CHAR(datum - INTERVAL '1 day', '"W"WW') AS week_id,
	EXTRACT(YEAR FROM datum) || TO_CHAR(datum, '"W"WW') AS week_id_iso,
	TO_CHAR(datum - INTERVAL '1 day', '"W"WW') AS week_name,
	TO_CHAR(datum, '"W"WW') AS week_name_iso,
	TO_CHAR(datum, 'W')::INT AS week_of_month,
	EXTRACT(WEEK FROM datum + INTERVAL '1 day') AS week_of_year,
	EXTRACT(YEAR FROM datum - INTERVAL '1 day') || TO_CHAR(datum - INTERVAL '1 day', '"-W"WW-') || EXTRACT(DOW FROM datum) AS week_of_year_id,
	EXTRACT(WEEK FROM datum) AS week_of_year_iso,
	EXTRACT(ISOYEAR FROM datum) || TO_CHAR(datum, '"-W"IW-') || EXTRACT(ISODOW FROM datum) AS week_of_year_iso_id,
	EXTRACT(MONTH FROM datum) AS month_of_year,
	TO_CHAR(datum, 'TMMonth') AS month_name,
	TO_CHAR(datum, 'Mon') AS month_abbr,
	EXTRACT(QUARTER FROM datum) AS quarter_of_year,
	CASE
	WHEN EXTRACT(QUARTER FROM datum) = 1 THEN 'First'
	WHEN EXTRACT(QUARTER FROM datum) = 2 THEN 'Second'
	WHEN EXTRACT(QUARTER FROM datum) = 3 THEN 'Third'
	WHEN EXTRACT(QUARTER FROM datum) = 4 THEN 'Fourth'
	END AS quarter_name,
	EXTRACT(YEAR FROM datum) || 'Q' || EXTRACT(QUARTER FROM datum) AS quarter_id,
	EXTRACT(YEAR FROM datum) AS yyyy,
	datum + (0 - EXTRACT(DOW FROM datum))::INT AS week_from,
	datum + (6 - EXTRACT(DOW FROM datum))::INT AS week_thru,
	datum + (1 - EXTRACT(ISODOW FROM datum))::INT AS week_from_iso,
	datum + (7 - EXTRACT(ISODOW FROM datum))::INT AS week_thru_iso,
	datum + (1 - EXTRACT(DAY FROM datum))::INT AS month_from,
	(DATE_TRUNC('MONTH', datum) + INTERVAL '1 MONTH - 1 day')::DATE AS month_thru,
	DATE_TRUNC('quarter', datum)::DATE AS quarter_from,
	(DATE_TRUNC('quarter', datum) + INTERVAL '3 MONTH - 1 day')::DATE AS quarter_thru,
	TO_DATE(EXTRACT(YEAR FROM datum) || '-01-01', 'YYYY-MM-DD') AS year_from,
	TO_DATE(EXTRACT(YEAR FROM datum) || '-12-31', 'YYYY-MM-DD') AS year_thru,
	TO_CHAR(datum, 'mmyyyy') AS mmyyyy,
	TO_CHAR(datum, 'mmddyyyy') AS mmddyyyy,
	CASE
	WHEN EXTRACT(DOW FROM datum) IN (0, 6) THEN TRUE
	ELSE FALSE
	END AS is_weekend
FROM (SELECT '1970-01-01'::DATE + SEQUENCE.DAY AS datum
	FROM GENERATE_SERIES(0, 29219) AS SEQUENCE (DAY)
	GROUP BY SEQUENCE.DAY) DQ
ORDER BY 1;


SELECT date_id, day_name, day_suffix, month_name, yyyy
FROM dim_date
WHERE date_id BETWEEN '2022-10-21' AND '2022-10-25';

SELECT * FROM dim_date dd WHERE date_id BETWEEN '1977-01-01' AND '1977-01-15';

