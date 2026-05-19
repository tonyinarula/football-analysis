SELECT
    l.name AS league,
    m.season,
    AVG(m.home_team_goal) AS avg_home_goals,
    AVG(m.away_team_goal) AS avg_away_goals,
    AVG(m.home_team_goal) - AVG(m.away_team_goal) AS home_advantage,
    AVG(CASE WHEN m.home_team_goal > m.away_team_goal THEN 1 ELSE 0 END) AS win_percent,
    AVG(CASE WHEN m.home_team_goal = m.away_team_goal THEN 1 ELSE 0 END) AS draw_percent,
    AVG(CASE WHEN m.home_team_goal < m.away_team_goal THEN 1 ELSE 0 END) AS loss_percent
FROM "Match" m
JOIN League l 
ON m.league_id = l.id 
GROUP BY l.name, m.season
ORDER BY home_advantage DESC;