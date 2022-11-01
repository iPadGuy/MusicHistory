-- dt_filetime.sql - Friday, October 28, 2022

SET search_path TO media_library,public;

/*
 * id, epochtime, date, year, quarter, quarterid, monthnum, monthid, monthname, 
 * week, weekid, isoweek, isoweekid, dayofmonth, dayofweek, dayname 
 * 
 * CREATE OR REPLACE FUNCTION random_list()
        RETURNS TABLE(a INT, b INT, c INT) AS $$
DECLARE
        a INT;
        b INT;
        c INT;
BEGIN
        a = random() * 99 + 1;
        b = random() * 99 + 1;
        c = random() * 99 + 1;
        RETURN QUERY SELECT a,b,c;
 */

SELECT to_char(timestamp '2020-12-16 10:41:35', 'Day') AS "Day";

CREATE OR REPLACE FUNCTION date_info(datetime TIMESTAMPTZ)
	RETURNS TABLE()
SELECT * FROM 
