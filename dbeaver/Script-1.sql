SET search_path TO media_library,public;

SELECT * FROM dt_log_analyzer dla LIMIT 10;

CREATE VIEW playcounts AS
	SELECT	filename, count(*) playcount 
	FROM	dt_log_analyzer dla
	GROUP BY filename;

SELECT * FROM playcounts
ORDER BY playcount DESC;

CREATE VIEW daily_plays AS
	SELECT	filename, playdate::DATE, count(*) playcount 
	FROM	dt_log_analyzer dla
	WHERE	filename LIKE '/%'
	GROUP BY filename, playdate::DATE
	ORDER BY filename, playdate::DATE;

SELECT * FROM daily_plays 
ORDER BY playdate DESC;

-- Working on time period columns
SELECT	DATE_PART('year', playdate) AS "year",
		DATE_PART('month', playdate) AS "month",
		DATE_PART('week', playdate + INTERVAL '1 day') AS "week",
		playdate::DATE playdate,
		filename,
		count(*) playcount 
FROM	dt_log_analyzer dla
WHERE	filename LIKE '/%'
GROUP BY "year",
		"month",
		"week",
		playdate,
		filename
ORDER BY "year",
		"month",
		"week",
		playdate,
		filename;


SELECT 	DATE_PART('week', '2022-10-22'::DATE) AS "Saturday",
		DATE_PART('week', '2022-10-23'::DATE + INTERVAL '1 day') AS "Sunday",
		DATE_PART('week', '2022-10-24'::DATE) AS "Monday";

SELECT EXTRACT('week' FROM now()) AS "week";

/*
INSERT INTO dt_log_analyzer 
SELECT * FROM	dt_sorted;
*/

SELECT * FROM dt_log_analyzer dla  LIMIT 10;

SELECT COUNT(*) FROM dt_log_analyzer dla;
SELECT COUNT(*) FROM dt_sorted;

-- TRUNCATE TABLE dt_log_analyzer;

CREATE VIEW log_filenames AS
	SELECT filename
	FROM dt_log_analyzer dla
	GROUP BY filename;


