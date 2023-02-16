-- Dusty.sql - Tuesday, January 3, 2023
/* Find songs that haven't been played, recently */

SET search_path TO media_library,public;

-- Songs played in the last six months but not the last week
COPY (
	SELECT	plays, play_secs, last_playdate, filename
	FROM (
		SELECT	filename, count(*) plays,
			max(playdate) last_playdate,
			sum(play_secs) play_secs
		FROM	dt_playhistory dp 
		WHERE	filename  LIKE '/home/patrick/Music/%'
		  AND	filename  NOT LIKE '/home/patrick/Music/Christmas/%'
		GROUP BY filename
		ORDER BY filename, play_secs 
	) a
	WHERE last_playdate BETWEEN CURRENT_DATE - INTERVAL '6 months' AND CURRENT_DATE - INTERVAL '7 days'
	ORDER BY plays DESC
	LIMIT 25
) TO '/tmp/Dusty_7Days.tsv' DELIMITER E'\t' CSV HEADER;


-- Songs played in the last six months, but not the last 30 days
COPY (
	SELECT	plays, play_secs, last_playdate, filename
	FROM (
		SELECT	filename, count(*) plays,
			max(playdate) last_playdate,
			sum(play_secs) play_secs
		FROM	dt_playhistory dp 
		WHERE	filename  LIKE '/home/patrick/Music/%'
		  AND	filename  NOT LIKE '/home/patrick/Music/Christmas/%'
		GROUP BY filename
		ORDER BY filename, play_secs 
	) a
	WHERE last_playdate BETWEEN CURRENT_DATE - INTERVAL '6 months' AND CURRENT_DATE - INTERVAL '30 days'
	ORDER BY plays DESC
	LIMIT 25
) TO '/tmp/Dusty_30Days.tsv' DELIMITER E'\t' CSV HEADER;



-- Songs played in the last year, but not the last six months
COPY (
	SELECT	plays, play_secs, last_playdate, filename
	FROM (
		SELECT	filename, count(*) plays,
			max(playdate) last_playdate,
			sum(play_secs) play_secs
		FROM	dt_playhistory dp 
		WHERE	filename  LIKE '/home/patrick/Music/%'
		  AND	filename  NOT LIKE '/home/patrick/Music/Christmas/%'
		GROUP BY filename
		ORDER BY filename, play_secs 
	) a
	WHERE last_playdate BETWEEN CURRENT_DATE - INTERVAL '1 year' AND CURRENT_DATE - INTERVAL '6 months'
	ORDER BY plays DESC
	LIMIT 25
) TO '/tmp/Dusty_180Days.tsv' DELIMITER E'\t' CSV HEADER;
