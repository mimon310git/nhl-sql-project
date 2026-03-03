-- 03_queries.sql (simple)
-- NHL SQL practice: basics + joins + aggregations + simple data checks

-- =========================================================
-- 1) BASIC SELECTS
-- =========================================================

-- 1. All teams
SELECT * FROM teams ORDER BY name;

-- 2. All players
SELECT * FROM players ORDER BY last_name;

-- 3. Players with their team
SELECT
  p.player_id,
  p.first_name,
  p.last_name,
  p.position,
  t.name AS team
FROM players p
JOIN teams t ON t.team_id = p.team_id
ORDER BY t.name, p.last_name;

-- 4. All games with team names
SELECT
  g.game_id,
  g.season,
  g.game_date,
  ht.name AS home_team,
  at.name AS away_team,
  g.home_goals,
  g.away_goals
FROM games g
JOIN teams ht ON ht.team_id = g.home_team_id
JOIN teams at ON at.team_id = g.away_team_id
ORDER BY g.game_date;

-- =========================================================
-- 2) GOALS & PENALTIES (JOINS)
-- =========================================================

-- 5. Goals with scorer + team
SELECT
  go.goal_id,
  p.first_name || ' ' || p.last_name AS scorer,
  t.name AS team,
  go.period,
  go.minute
FROM goals go
JOIN players p ON p.player_id = go.scorer_player_id
JOIN teams t ON t.team_id = p.team_id
ORDER BY go.goal_id;

-- 6. Penalties with player + team
SELECT
  pe.penalty_id,
  p.first_name || ' ' || p.last_name AS player,
  t.name AS team,
  pe.minutes,
  pe.reason,
  pe.period,
  pe.minute
FROM penalties pe
JOIN players p ON p.player_id = pe.player_id
JOIN teams t ON t.team_id = p.team_id
ORDER BY pe.penalty_id;

-- =========================================================
-- 3) AGGREGATIONS (GROUP BY)
-- =========================================================

-- 7. Player count per team
SELECT
  t.name AS team,
  COUNT(*) AS player_count
FROM teams t
JOIN players p ON p.team_id = t.team_id
GROUP BY t.name
ORDER BY player_count DESC, team;

-- 8. Goals per player (includes players with 0 goals)
SELECT
  p.first_name || ' ' || p.last_name AS player,
  t.name AS team,
  COUNT(go.goal_id) AS goals_scored
FROM players p
JOIN teams t ON t.team_id = p.team_id
LEFT JOIN goals go ON go.scorer_player_id = p.player_id
GROUP BY p.player_id, t.name
ORDER BY goals_scored DESC, player;

-- 9. Goals per team
SELECT
  t.name AS team,
  COUNT(go.goal_id) AS goals_scored
FROM teams t
JOIN players p ON p.team_id = t.team_id
LEFT JOIN goals go ON go.scorer_player_id = p.player_id
GROUP BY t.name
ORDER BY goals_scored DESC, team;

-- 10. Penalty minutes per player (includes players with 0 penalties)
SELECT
  p.first_name || ' ' || p.last_name AS player,
  t.name AS team,
  COALESCE(SUM(pe.minutes), 0) AS penalty_minutes
FROM players p
JOIN teams t ON t.team_id = p.team_id
LEFT JOIN penalties pe ON pe.player_id = p.player_id
GROUP BY p.player_id, t.name
ORDER BY penalty_minutes DESC, player;

-- 11. Penalty minutes per team
SELECT
  t.name AS team,
  COALESCE(SUM(pe.minutes), 0) AS team_penalty_minutes
FROM teams t
JOIN players p ON p.team_id = t.team_id
LEFT JOIN penalties pe ON pe.player_id = p.player_id
GROUP BY t.name
ORDER BY team_penalty_minutes DESC, team;

-- =========================================================
-- 4) SIMPLE “BUSINESS” QUESTIONS
-- =========================================================

-- 12. Games with total goals
SELECT
  g.game_id,
  g.game_date,
  ht.name AS home_team,
  at.name AS away_team,
  (g.home_goals + g.away_goals) AS total_goals
FROM games g
JOIN teams ht ON ht.team_id = g.home_team_id
JOIN teams at ON at.team_id = g.away_team_id
ORDER BY total_goals DESC;

-- 13. Winner of each game (simple)
SELECT
  g.game_id,
  g.game_date,
  ht.name AS home_team,
  at.name AS away_team,
  g.home_goals,
  g.away_goals,
  CASE
    WHEN g.home_goals > g.away_goals THEN ht.name
    WHEN g.away_goals > g.home_goals THEN at.name
    ELSE 'TIE'
  END AS winner
FROM games g
JOIN teams ht ON ht.team_id = g.home_team_id
JOIN teams at ON at.team_id = g.away_team_id
ORDER BY g.game_date;

-- 14. Players who scored at least 1 goal
SELECT
  p.first_name || ' ' || p.last_name AS player,
  COUNT(*) AS goals_scored
FROM players p
JOIN goals go ON go.scorer_player_id = p.player_id
GROUP BY p.player_id
ORDER BY goals_scored DESC, player;

-- =========================================================
-- 5) SIMPLE DATA CHECKS (QA mindset)
-- =========================================================

-- 15. Should return 0 rows: home team equals away team
SELECT *
FROM games
WHERE home_team_id = away_team_id;

-- 16. Should return 0 rows: negative scores
SELECT *
FROM games
WHERE home_goals < 0 OR away_goals < 0;

-- 17. Should return 0 rows: invalid positions (CHECK should prevent this)
SELECT *
FROM players
WHERE position NOT IN ('C','LW','RW','D','G');