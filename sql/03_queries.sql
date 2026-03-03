-- 03_queries.sql
-- NHL mini DB - practice queries (joins, aggregations, CTEs, QA data checks)

-- =========================================================
-- BASIC SELECTS
-- =========================================================

-- 1) All teams
SELECT * FROM teams ORDER BY name;

-- 2) All players with teams
SELECT
  p.player_id,
  p.first_name,
  p.last_name,
  p.position,
  t.name AS team
FROM players p
JOIN teams t ON t.team_id = p.team_id
ORDER BY t.name, p.last_name;

-- 3) All games (with team names)
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
ORDER BY g.game_date, g.game_id;

-- =========================================================
-- GOALS / PENALTIES DETAIL (multi-table joins)
-- =========================================================

-- 4) Goals with scorer + team
SELECT
  g.goal_id,
  p.first_name || ' ' || p.last_name AS scorer,
  t.name AS team,
  g.period,
  g.minute
FROM goals g
JOIN players p ON p.player_id = g.scorer_player_id
JOIN teams t ON t.team_id = p.team_id
ORDER BY g.goal_id;

-- 5) Goals with assists (if present)
SELECT
  g.goal_id,
  sp.first_name || ' ' || sp.last_name AS scorer,
  a1.first_name || ' ' || a1.last_name AS assist1,
  a2.first_name || ' ' || a2.last_name AS assist2,
  g.period,
  g.minute
FROM goals g
JOIN players sp ON sp.player_id = g.scorer_player_id
LEFT JOIN players a1 ON a1.player_id = g.assist1_player_id
LEFT JOIN players a2 ON a2.player_id = g.assist2_player_id
ORDER BY g.goal_id;

-- 6) Penalties with player + team
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
-- AGGREGATIONS
-- =========================================================

-- 7) Player count per team
SELECT
  t.name AS team,
  COUNT(*) AS player_count
FROM teams t
JOIN players p ON p.team_id = t.team_id
GROUP BY t.team_id
ORDER BY player_count DESC, team;

-- 8) Goals scored per player (includes players with 0 goals)
SELECT
  p.first_name || ' ' || p.last_name AS player,
  t.name AS team,
  COUNT(g.goal_id) AS goals_scored
FROM players p
JOIN teams t ON t.team_id = p.team_id
LEFT JOIN goals g ON g.scorer_player_id = p.player_id
GROUP BY p.player_id, t.name
ORDER BY goals_scored DESC, player;

-- 9) Goals scored per team
SELECT
  t.name AS team,
  COUNT(g.goal_id) AS goals_scored
FROM teams t
JOIN players p ON p.team_id = t.team_id
LEFT JOIN goals g ON g.scorer_player_id = p.player_id
GROUP BY t.team_id
ORDER BY goals_scored DESC, team;

-- 10) Penalty minutes per player
SELECT
  p.first_name || ' ' || p.last_name AS player,
  t.name AS team,
  SUM(pe.minutes) AS penalty_minutes
FROM players p
JOIN teams t ON t.team_id = p.team_id
LEFT JOIN penalties pe ON pe.player_id = p.player_id
GROUP BY p.player_id, t.name
ORDER BY penalty_minutes DESC NULLS LAST, player;

-- 11) Total penalty minutes per team
SELECT
  t.name AS team,
  COALESCE(SUM(pe.minutes), 0) AS team_pim
FROM teams t
JOIN players p ON p.team_id = t.team_id
LEFT JOIN penalties pe ON pe.player_id = p.player_id
GROUP BY t.team_id
ORDER BY team_pim DESC, team;

-- =========================================================
-- GAME-LEVEL STATS
-- =========================================================

-- 12) Total goals per game
SELECT
  g.game_id,
  g.game_date,
  ht.name AS home_team,
  at.name AS away_team,
  (g.home_goals + g.away_goals) AS total_goals
FROM games g
JOIN teams ht ON ht.team_id = g.home_team_id
JOIN teams at ON at.team_id = g.away_team_id
ORDER BY total_goals DESC, g.game_date;

-- 13) Winner per game
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

-- =========================================================
-- FILTERING + HAVING
-- =========================================================

-- 14) Players with at least 1 goal
SELECT
  p.first_name || ' ' || p.last_name AS player,
  COUNT(*) AS goals_scored
FROM players p
JOIN goals g ON g.scorer_player_id = p.player_id
GROUP BY p.player_id
HAVING COUNT(*) >= 1
ORDER BY goals_scored DESC;

-- 15) Teams with more than 1 goal in the dataset
SELECT
  t.name AS team,
  COUNT(g.goal_id) AS goals_scored
FROM teams t
JOIN players p ON p.team_id = t.team_id
JOIN goals g ON g.scorer_player_id = p.player_id
GROUP BY t.team_id
HAVING COUNT(g.goal_id) > 1
ORDER BY goals_scored DESC;

-- =========================================================
-- CTE EXAMPLES
-- =========================================================

-- 16) CTE: top scorers
WITH scorer_totals AS (
  SELECT
    scorer_player_id,
    COUNT(*) AS goals_scored
  FROM goals
  GROUP BY scorer_player_id
)
SELECT
  p.first_name || ' ' || p.last_name AS player,
  t.name AS team,
  st.goals_scored
FROM scorer_totals st
JOIN players p ON p.player_id = st.scorer_player_id
JOIN teams t ON t.team_id = p.team_id
ORDER BY st.goals_scored DESC, player;

-- =========================================================
-- QA / DATA QUALITY CHECKS (should return 0 rows in a clean DB)
-- =========================================================

-- 17) Home team equals away team (should be none)
SELECT *
FROM games
WHERE home_team_id = away_team_id;

-- 18) Negative goals (should be none)
SELECT *
FROM games
WHERE home_goals < 0 OR away_goals < 0;

-- 19) Goals referencing non-existent game (should be none)
SELECT g.*
FROM goals g
LEFT JOIN games ga ON ga.game_id = g.game_id
WHERE ga.game_id IS NULL;

-- 20) Players without a team (should be none)
SELECT p.*
FROM players p
LEFT JOIN teams t ON t.team_id = p.team_id
WHERE t.team_id IS NULL;

-- 21) Penalties referencing non-existent player (should be none)
SELECT pe.*
FROM penalties pe
LEFT JOIN players p ON p.player_id = pe.player_id
WHERE p.player_id IS NULL;

-- 22) Duplicate team names (should be none)
SELECT name, COUNT(*)
FROM teams
GROUP BY name
HAVING COUNT(*) > 1;

-- 23) Invalid position (should be none; CHECK should prevent this)
SELECT *
FROM players
WHERE position NOT IN ('C','LW','RW','D','G');

-- =========================================================
-- INTERVIEW-FRIENDLY QUESTIONS
-- =========================================================

-- 24) Which team has the most goals?
SELECT
  t.name AS team,
  COUNT(g.goal_id) AS goals_scored
FROM teams t
JOIN players p ON p.team_id = t.team_id
LEFT JOIN goals g ON g.scorer_player_id = p.player_id
GROUP BY t.team_id
ORDER BY goals_scored DESC
LIMIT 1;

-- 25) List players who have penalties but no goals
SELECT
  p.first_name || ' ' || p.last_name AS player,
  t.name AS team
FROM players p
JOIN teams t ON t.team_id = p.team_id
WHERE EXISTS (SELECT 1 FROM penalties pe WHERE pe.player_id = p.player_id)
  AND NOT EXISTS (SELECT 1 FROM goals g WHERE g.scorer_player_id = p.player_id)
ORDER BY team, player;

-- 26) Goals per period
SELECT
  period,
  COUNT(*) AS goals
FROM goals
GROUP BY period
ORDER BY period;

-- 27) Penalty minutes per game
SELECT
  g.game_id,
  g.game_date,
  COALESCE(SUM(pe.minutes), 0) AS pim
FROM games g
LEFT JOIN penalties pe ON pe.game_id = g.game_id
GROUP BY g.game_id
ORDER BY pim DESC, g.game_date;

-- 28) Team record (W/L) based on home/away goals (simple, no OT)
WITH results AS (
  SELECT
    game_id,
    home_team_id AS team_id,
    CASE WHEN home_goals > away_goals THEN 1 ELSE 0 END AS win,
    CASE WHEN home_goals < away_goals THEN 1 ELSE 0 END AS loss
  FROM games
  UNION ALL
  SELECT
    game_id,
    away_team_id AS team_id,
    CASE WHEN away_goals > home_goals THEN 1 ELSE 0 END AS win,
    CASE WHEN away_goals < home_goals THEN 1 ELSE 0 END AS loss
  FROM games
)
SELECT
  t.name AS team,
  SUM(r.win) AS wins,
  SUM(r.loss) AS losses
FROM results r
JOIN teams t ON t.team_id = r.team_id
GROUP BY t.team_id
ORDER BY wins DESC, losses ASC, team;

-- 29) Players ordered by (goals - penalty minutes)
WITH goal_totals AS (
  SELECT scorer_player_id AS player_id, COUNT(*) AS goals
  FROM goals
  GROUP BY scorer_player_id
),
pim_totals AS (
  SELECT player_id, COALESCE(SUM(minutes), 0) AS pim
  FROM penalties
  GROUP BY player_id
)
SELECT
  p.first_name || ' ' || p.last_name AS player,
  t.name AS team,
  COALESCE(gt.goals, 0) AS goals,
  COALESCE(pt.pim, 0) AS penalty_minutes,
  (COALESCE(gt.goals, 0) - COALESCE(pt.pim, 0)) AS goal_minus_pim
FROM players p
JOIN teams t ON t.team_id = p.team_id
LEFT JOIN goal_totals gt ON gt.player_id = p.player_id
LEFT JOIN pim_totals pt ON pt.player_id = p.player_id
ORDER BY goal_minus_pim DESC, goals DESC, player;

-- 30) Find games where seeded score doesn't match counted goals table (consistency check)
SELECT
  g.game_id,
  g.home_goals,
  g.away_goals,
  COALESCE(SUM(CASE WHEN p.team_id = g.home_team_id THEN 1 ELSE 0 END), 0) AS counted_home_goals,
  COALESCE(SUM(CASE WHEN p.team_id = g.away_team_id THEN 1 ELSE 0 END), 0) AS counted_away_goals
FROM games g
LEFT JOIN goals go ON go.game_id = g.game_id
LEFT JOIN players p ON p.player_id = go.scorer_player_id
GROUP BY g.game_id
HAVING
  g.home_goals <> COALESCE(SUM(CASE WHEN p.team_id = g.home_team_id THEN 1 ELSE 0 END), 0)
  OR g.away_goals <> COALESCE(SUM(CASE WHEN p.team_id = g.away_team_id THEN 1 ELSE 0 END), 0)
ORDER BY g.game_id;