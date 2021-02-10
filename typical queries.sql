-- match stats by teams
SELECT mpt.name AS team_name, COUNT(m.winner_team) AS wins, mpt.mp AS matches, CONCAT(ROUND(COUNT(m.winner_team)/mpt.mp*100),'%') AS win_rate
FROM 
	matches m
JOIN
	(SELECT t.id AS team, t.name AS name, COUNT(m2.id) AS mp -- total matches played by team;
	FROM matches m2 
	LEFT JOIN teams t 
	ON t.id IN (m2.team_1_id, m2.team_2_id)
	WHERE m2.active_status_id = 1
	GROUP BY t.id 
	ORDER BY t.id) AS mpt
ON m.winner_team = mpt.team
WHERE m.active_status_id = 1
GROUP BY mpt.team
ORDER BY mpt.team;

-- current team roster by teams
SELECT t.name AS team, p.nickname, tf.name AS role
FROM teams t 
LEFT JOIN players p ON t.id = p.current_team_ID 
LEFT JOIN team_functions tf ON p.team_function_id = tf.id;  

-- Count the amount of titles among titleholders
SELECT COUNT(tp.name) AS titles, t2.name AS team_name
FROM teams t2 
LEFT JOIN tournaments t 
ON t.winner_team_id = t2.id 
LEFT JOIN tournament_profiles tp 
ON t.id = tp.tournament_id 
GROUP BY t2.name
ORDER BY titles DESC;

SELECT m.id, p.nickname
FROM matches m 
LEFT JOIN teams t 
	ON t.id IN (m.team_1_id, m.team_2_id)
LEFT JOIN players p
	ON p.current_team_id = t.id;

-- VIEWS
CREATE OR REPLACE VIEW current_roster  -- current members of the team
AS SELECT t.name AS team, p.nickname, tf.name AS role
FROM teams t 
LEFT JOIN players p ON t.id = p.current_team_ID 
LEFT JOIN team_functions tf ON p.team_function_id = tf.id;

CREATE OR REPLACE VIEW members_of_match
AS SELECT m.id, p.nickname
FROM matches m 
LEFT JOIN teams t 
	ON t.id IN (m.team_1_id, m.team_2_id)
LEFT JOIN players p
	ON p.current_team_id = t.id;

-- triggers

DROP TRIGGER last_team_upd;
CREATE TRIGGER last_team_upd AFTER UPDATE ON players
FOR EACH ROW 
BEGIN
	IF NEW.current_team_id != OLD.current_team_id THEN
		UPDATE player_profiles SET last_team_id = OLD.current_team_id, WHERE OLD.id = player_id;
	END IF;
END;

DROP TRIGGER add_career_teams;
CREATE TRIGGER add_career_teams BEFORE UPDATE ON player_profiles
FOR EACH ROW
BEGIN
	IF NEW.last_team_id != OLD.last_team_id THEN
		SET NEW.career_teams = CONCAT (OLD.career_teams, '|', (SELECT name FROM teams WHERE id = NEW.last_team_id));
	END IF;
END;

-- this is to test triggers
UPDATE players SET current_team_id = 4 WHERE id = 2;
SELECT p.current_team_id, pp.last_team_id, pp.career_teams 
FROM player_profiles pp 
JOIN players p 
	ON pp.player_id = p.id 
WHERE player_id = 2;

	





