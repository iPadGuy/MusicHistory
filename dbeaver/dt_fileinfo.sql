-- dt_fileinfo.sql - Friday, October 28, 2022

SET search_path TO media_library,public;

SELECT * FROM dt_fileinfo LIMIT 10;

INSERT INTO dt_fileinfo (filename)
SELECT	lf.filename 
FROM	log_filenames lf LEFT OUTER JOIN 
	dt_fileinfo df ON lf.filename = df.filename 
WHERE	df.filename IS NULL;

SELECT COUNT(*) FROM dt_fileinfo df ;

-- ALTER TABLE dt_fileinfo RENAME COLUMN filename TO filename;

SELECT * FROM dt_fileinfo df LIMIT 10;

SELECT to_char(timestamp '2020-12-16 10:41:35', 'Day') AS "Day";
