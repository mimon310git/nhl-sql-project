-- 02_seed.sql

-- Teams
INSERT INTO teams (name, city, conference, division) VALUES
('Penguins', 'Pittsburgh', 'Eastern', 'Metropolitan'),
('Oilers', 'Edmonton', 'Western', 'Pacific'),
('Rangers', 'New York', 'Eastern', 'Metropolitan'),
('Avalanche', 'Colorado', 'Western', 'Central');

-- Players
INSERT INTO players (team_id, first_name, last_name, position, shoots, birth_date) VALUES
(1, 'Sidney', 'Crosby', 'C', 'L', '1987-08-07'),
(1, 'Evgeni', 'Malkin', 'C', 'L', '1986-07-31'),
(2, 'Connor', 'McDavid', 'C', 'L', '1997-01-13'),
(2, 'Leon', 'Draisaitl', 'C', 'L', '1995-10-27'),
(3, 'Artemi', 'Panarin', 'LW', 'R', '1991-10-30'),
(4, 'Nathan', 'MacKinnon', 'C', 'R', '1995-09-01');

-- Games
INSERT INTO games (season, game_date, home_team_id, away_team_id, home_goals, away_goals) VALUES
('2025-2026', '2026-02-10', 1, 2, 3, 4),
('2025-2026', '2026-02-12', 3, 4, 2, 1);

-- Goals
INSERT INTO goals (game_id, scorer_player_id, assist1_player_id, assist2_player_id, period, minute) VALUES
(1, 3, 4, NULL, 1, 5),
(1, 1, 2, NULL, 2, 11),
(1, 4, 3, NULL, 3, 18),
(2, 5, NULL, NULL, 1, 7),
(2, 6, NULL, NULL, 2, 9);

-- Penalties
INSERT INTO penalties (game_id, player_id, period, minute, minutes, reason) VALUES
(1, 2, 2, 3, 2, 'Hooking'),
(2, 5, 3, 15, 5, 'Fighting');