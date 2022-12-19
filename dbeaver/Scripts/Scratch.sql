-- Scratch.sql - Sunday, December 11, 2022
/**/

SET search_path TO media_library,public;

SELECT filename
FROM (
	SELECT filename, max(playdatetime) last_played
	FROM dt_playhistory dp 
	WHERE filename LIKE '/home/patrick/Music/%'
	  AND playdate >= '2022-12-10'
	GROUP BY filename
	ORDER BY filename
	LIMIT 1000
) a 
ORDER BY last_played DESC
LIMIT 25;


-- Original Playlist
COPY (
	SELECT	ROW_NUMBER() OVER(ORDER BY count(*) DESC) AS rownum,
		count(*) AS playcount,
		dpt.filename
	FROM	dt_playhistory dpt INNER JOIN
		dim_date dd ON
			dpt.playdate = dd.date_id
	WHERE	dd.date_id = '2022-12-13' AND
		dpt.play_secs > 3 AND
		dpt.filename LIKE '/home/patrick/Music/%'
	GROUP BY dpt.filename HAVING count(*) > 1
	ORDER BY playcount DESC
	LIMIT 10)
TO '/tmp/original.tsv' DELIMITER E'\t' CSV HEADER;

-- Rank by play count AND play time
COPY (
	SELECT	ROW_NUMBER() OVER(ORDER BY count(*) DESC, sum(play_secs) DESC) AS rownum,
		count(*) AS playcount,
		sum(play_secs) AS total_play_secs,
		dpt.filename
	FROM	dt_playhistory dpt INNER JOIN
		dim_date dd ON
			dpt.playdate = dd.date_id
	WHERE	dd.date_id = '2022-12-13' AND
		dpt.play_secs > 3 AND
		dpt.filename LIKE '/home/patrick/Music/%'
	GROUP BY dpt.filename HAVING count(*) > 1
	ORDER BY playcount DESC
	LIMIT 10)
TO '/tmp/AddRankByPlaySecs3.tsv' DELIMITER E'\t' CSV HEADER;

-- Increase play_secs filter from 3 to 30
COPY (
	SELECT	ROW_NUMBER() OVER(ORDER BY count(*) DESC) AS rownum,
		count(*) AS playcount,
		dpt.filename
	FROM	dt_playhistory dpt INNER JOIN
		dim_date dd ON
			dpt.playdate = dd.date_id
	WHERE	dd.date_id = '2022-12-13' AND
		dpt.play_secs > 30 AND
		dpt.filename LIKE '/home/patrick/Music/%'
	GROUP BY dpt.filename HAVING count(*) > 1
	ORDER BY playcount DESC
	LIMIT 10)
TO '/tmp/IncreasePlaySecsTo30.tsv' DELIMITER E'\t' CSV HEADER;

-- Combine play_sec rank and increased play_sec filter
COPY (
	SELECT	ROW_NUMBER() OVER(ORDER BY count(*) DESC, sum(play_secs) DESC) AS rownum,
		count(*) AS playcount,
		sum(play_secs) AS total_play_secs,
		dpt.filename
	FROM	dt_playhistory dpt INNER JOIN
		dim_date dd ON
			dpt.playdate = dd.date_id
	WHERE	dd.date_id = '2022-12-13' AND
		dpt.play_secs > 30 AND
		dpt.filename LIKE '/home/patrick/Music/%'
	GROUP BY dpt.filename HAVING count(*) > 1
	ORDER BY playcount DESC
	LIMIT 10)
TO '/tmp/CombineChanges.tsv' DELIMITER E'\t' CSV HEADER;

/*
SELECT ROW_NUMBER() OVER(ORDER BY count(*) DESC) rownum, count(*) playcount, dpt.filename
FROM dt_playhistory dpt INNER JOIN dim_date dd ON dpt.playdate = dd.date_id
WHERE dd.date_id = :list_date AND dpt.play_secs > 3 AND dpt.filename LIKE :file_prefix
GROUP BY dpt.filename HAVING count(*) > 1
ORDER BY playcount DESC
LIMIT :list_size;
*/

