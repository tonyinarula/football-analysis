WITH home_results AS (
	SELECT m.country_id,
		m.league_id,
		m.season,
		m.home_team_api_id AS team_api_id,
		SUM(CASE WHEN m.home_team_goal > m.away_team_goal THEN 3
			WHEN m.home_team_goal = m.away_team_goal THEN 1
			ELSE 0 END) as points,
		SUM(CASE WHEN m.home_team_goal > m.away_team_goal THEN 1 ELSE 0 END) AS wins,
		SUM(CASE WHEN m.home_team_goal = m.away_team_goal THEN 1 ELSE 0 END) AS draws,
		SUM(CASE WHEN m.home_team_goal < m.away_team_goal THEN 1 ELSE 0 END) AS losses,	
		SUM(m.home_team_goal) AS goals_for,
		SUM(m.away_team_goal) AS goals_against,
		SUM(m.home_team_goal ) - SUM(m.away_team_goal) AS goal_diff
	FROM "Match" m
	GROUP BY m.league_id, m.season, m.home_team_api_id
),
away_results AS (
	SELECT m.country_id,
		m.league_id,
		m.season,
		m.away_team_api_id AS team_api_id,
		SUM(CASE WHEN m.away_team_goal > m.home_team_goal THEN 3
			WHEN m.home_team_goal = m.away_team_goal THEN 1
			ELSE 0 END) as points,
		SUM(CASE WHEN m.away_team_goal > m.home_team_goal THEN 1 ELSE 0 END) AS wins,
		SUM(CASE WHEN m.away_team_goal = m.home_team_goal THEN 1 ELSE 0 END) AS draws,
		SUM(CASE WHEN m.away_team_goal < m.home_team_goal THEN 1 ELSE 0 END) AS losses,	
		SUM(m.away_team_goal) AS goals_for,
		SUM(m.home_team_goal) AS goals_against,
		SUM(m.away_team_goal ) - SUM(m.home_team_goal) AS goal_diff
	FROM "Match" m
	GROUP BY m.league_id, m.season, m.away_team_api_id
),
combined AS (
	SELECT * FROM (
	SELECT * FROM home_results
	UNION ALL 
	SELECT * FROM away_results
	) AS all_results
),
standings AS (
	SELECT season,
		league_id,
		team_api_id,
		SUM(points) AS points,
        SUM(wins) AS wins,
        SUM(draws) AS draws,
        SUM(losses) AS losses,
        SUM(goals_for) AS goals_for,
        SUM(goals_against) AS goals_against,
        SUM(goals_for) - SUM(goals_against) AS goal_diff,
        SUM(wins) + SUM(draws) + SUM(losses) AS played
     FROM combined
    GROUP BY country_id, league_id, season, team_api_id
),
final_standings AS (
    SELECT s.season,
        l.name AS league,
        t.team_long_name AS team,
        s.points
    FROM standings s
    JOIN League l ON s.league_id = l.id
    JOIN Team t ON s.team_api_id = t.team_api_id
)
SELECT
    season,
    league,
    team,
    points,
    LAG(points) OVER (
        PARTITION BY team, league
        ORDER BY season
    ) AS prev_season_points,
    points - LAG(points) OVER (
        PARTITION BY team, league
        ORDER BY season
    ) AS points_change
FROM final_standings
ORDER BY team, season;