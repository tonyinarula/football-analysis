WITH team_matches AS (
    SELECT
        season,
        date,
        home_team_api_id AS team_api_id,
        CASE WHEN home_team_goal > away_team_goal THEN 3
             WHEN home_team_goal = away_team_goal THEN 1
             ELSE 0 END AS points
    FROM Match

    UNION ALL

    SELECT
        season,
        date,
        away_team_api_id AS team_api_id,
        CASE WHEN away_team_goal > home_team_goal THEN 3
             WHEN away_team_goal = home_team_goal THEN 1
             ELSE 0 END AS points
    FROM Match
)
SELECT 
    t.team_long_name AS team,
    tm.season,
    tm.date,
	SUM(points) OVER (
	    PARTITION BY tm.team_api_id
	    ORDER BY date
	    ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
	) AS rolling_5_game_points
FROM team_matches tm
JOIN Team t 
ON tm.team_api_id = t.team_api_id;