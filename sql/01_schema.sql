-- 01_schema.sql (PostgreSQL) - NHL mini model (5 tables)

DROP TABLE IF EXISTS penalties;
DROP TABLE IF EXISTS goals;
DROP TABLE IF EXISTS games;
DROP TABLE IF EXISTS players;
DROP TABLE IF EXISTS teams;

CREATE TABLE teams (
  team_id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  city VARCHAR(100) NOT NULL,
  conference VARCHAR(20) NOT NULL CHECK (conference IN ('Eastern', 'Western')),
  division VARCHAR(50) NOT NULL
);

CREATE TABLE players (
  player_id SERIAL PRIMARY KEY,
  team_id INT NOT NULL REFERENCES teams(team_id) ON DELETE RESTRICT,
  first_name VARCHAR(100) NOT NULL,
  last_name VARCHAR(100) NOT NULL,
  position VARCHAR(5) NOT NULL CHECK (position IN ('C','LW','RW','D','G')),
  shoots CHAR(1) CHECK (shoots IN ('L','R')),
  birth_date DATE
);

CREATE TABLE games (
  game_id SERIAL PRIMARY KEY,
  season VARCHAR(9) NOT NULL, -- e.g. '2025-2026'
  game_date DATE NOT NULL,
  home_team_id INT NOT NULL REFERENCES teams(team_id) ON DELETE RESTRICT,
  away_team_id INT NOT NULL REFERENCES teams(team_id) ON DELETE RESTRICT,
  home_goals INT NOT NULL DEFAULT 0 CHECK (home_goals >= 0),
  away_goals INT NOT NULL DEFAULT 0 CHECK (away_goals >= 0),
  CHECK (home_team_id <> away_team_id)
);

CREATE TABLE goals (
  goal_id SERIAL PRIMARY KEY,
  game_id INT NOT NULL REFERENCES games(game_id) ON DELETE CASCADE,
  scorer_player_id INT NOT NULL REFERENCES players(player_id) ON DELETE RESTRICT,
  assist1_player_id INT REFERENCES players(player_id) ON DELETE RESTRICT,
  assist2_player_id INT REFERENCES players(player_id) ON DELETE RESTRICT,
  period INT NOT NULL CHECK (period BETWEEN 1 AND 3),
  minute INT NOT NULL CHECK (minute BETWEEN 0 AND 20),

  -- basic sanity checks
  CHECK (assist1_player_id IS NULL OR assist1_player_id <> scorer_player_id),
  CHECK (assist2_player_id IS NULL OR assist2_player_id <> scorer_player_id),
  CHECK (assist2_player_id IS NULL OR assist1_player_id IS NOT NULL)
);

CREATE TABLE penalties (
  penalty_id SERIAL PRIMARY KEY,
  game_id INT NOT NULL REFERENCES games(game_id) ON DELETE CASCADE,
  player_id INT NOT NULL REFERENCES players(player_id) ON DELETE RESTRICT,
  period INT NOT NULL CHECK (period BETWEEN 1 AND 3),
  minute INT NOT NULL CHECK (minute BETWEEN 0 AND 20),
  minutes INT NOT NULL CHECK (minutes IN (2, 5, 10)),
  reason VARCHAR(100) NOT NULL
);