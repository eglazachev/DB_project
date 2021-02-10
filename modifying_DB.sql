USE project;

-- forgot to add function table for team roles
CREATE TABLE IF NOT EXISTS team_functions (
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(60) NOT NULL COMMENT "names of roles in team structure",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);
SELECT * FROM team_functions;
INSERT INTO team_functions(name) VALUES ('player'), ('coach'), ('psychologist'), ('manager'), ('benchwarmer');

SHOW TABLES;
UPDATE cast_studios SET updated_at = NOW() WHERE created_at >= updated_at;
UPDATE countries SET updated_at = NOW() WHERE created_at >= updated_at;
UPDATE disciplines SET updated_at = NOW() WHERE created_at >= updated_at;
UPDATE matches SET updated_at = NOW() WHERE created_at >= updated_at;
UPDATE media SET updated_at = NOW() WHERE created_at >= updated_at;
UPDATE media_types SET updated_at = NOW() WHERE created_at >= updated_at;
UPDATE player_profiles SET updated_at = NOW() WHERE created_at >= updated_at;
UPDATE players SET updated_at = NOW() WHERE created_at >= updated_at;
UPDATE statuses SET updated_at = NOW() WHERE created_at >= updated_at;
UPDATE teams SET updated_at = NOW() WHERE created_at >= updated_at;
UPDATE tournament_operators SET updated_at = NOW() WHERE created_at >= updated_at;
UPDATE tournament_profiles SET updated_at = NOW() WHERE created_at >= updated_at;
UPDATE tournaments SET updated_at = NOW() WHERE created_at >= updated_at;

SELECT id, name FROM disciplines d;
UPDATE disciplines SET name = 'DOTA 2' WHERE id = 1;
UPDATE disciplines SET name = 'Counter-Strike' WHERE id = 2;
UPDATE disciplines SET name = 'PUBG' WHERE id = 3;
UPDATE disciplines SET name = 'Rocket League' WHERE id = 4;
UPDATE disciplines SET name = 'StarCraft II' WHERE id = 5;
UPDATE disciplines SET name = 'VALORANT' WHERE id = 6;
UPDATE disciplines SET name = 'Overwatch' WHERE id = 7;
UPDATE disciplines SET name = 'Rainbow Six' WHERE id = 8;
UPDATE disciplines SET name = 'Apex Legends' WHERE id = 9;
UPDATE disciplines SET name = 'League of Legends' WHERE id = 10;
UPDATE disciplines SET name = 'Warcraft III' WHERE id = 11;
UPDATE disciplines SET name = 'Smash' WHERE id = 12;
UPDATE disciplines SET name = 'Brood War' WHERE id = 13;
UPDATE disciplines SET name = 'Hearthstone' WHERE id = 14;
UPDATE disciplines SET name = 'Heroes' WHERE id = 15;

SELECT * FROM statuses s;
UPDATE statuses SET name = 'Upcoming' WHERE id = 1;
UPDATE statuses SET name = 'Ongoing' WHERE id = 2;
UPDATE statuses SET name = 'Concluded' WHERE id = 3;

SELECT * FROM media_types mt;
UPDATE media_types SET name = 'logo' WHERE id = 1;
UPDATE media_types SET name = 'avatar' WHERE id = 2;
UPDATE media_types SET name = 'flag' WHERE id = 1;
UPDATE media_types SET name = 'other' WHERE id = 1;

-- foreign keys

DESC tournaments;
SELECT name FROM statuses s2 ;
ALTER TABLE tournaments CHANGE winner winner_team_id INT UNSIGNED;
UPDATE tournaments SET winner_team_id = FLOOR(1 + RAND()*1000) WHERE active_status_id = 1;


ALTER TABLE tournaments
  ADD CONSTRAINT tournaments_discipline_id_fk
  FOREIGN KEY (discipline_id) REFERENCES disciplines(id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
  ADD CONSTRAINT tournaments_active_status_id_fk
  FOREIGN KEY (active_status_id) REFERENCES statuses(id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
DESC tournament_profiles;
SELECT * FROM tournament_profiles tp;
DESC countries;
ALTER TABLE tournament_profiles
  ADD CONSTRAINT tournament_profiles_tournament_id_fk
  FOREIGN KEY (tournament_id) REFERENCES tournaments(id)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  ADD CONSTRAINT tournament_profiles_tournament_operators_id_fk
  FOREIGN KEY (tournament_operator_id) REFERENCES tournament_operators(id)
  ON DELETE SET NULL
  ON UPDATE CASCADE,
  ADD CONSTRAINT tournament_profiles_cast_studio_id_fk
  FOREIGN KEY (cast_studio_id) REFERENCES cast_studios(id)
  ON DELETE SET NULL
  ON UPDATE CASCADE,
  ADD CONSTRAINT tournament_profiles_discipline_id_fk
  FOREIGN KEY (discipline_id) REFERENCES disciplines(id)
  ON DELETE RESTRICT 
  ON UPDATE CASCADE,
  ADD CONSTRAINT tournament_profiles_media_id_fk
  FOREIGN KEY (media_id) REFERENCES media(id)
  ON DELETE RESTRICT 
  ON UPDATE CASCADE;

UPDATE tournament_profiles SET country_id = FLOOR(1 + RAND() * 240);
ALTER TABLE tournament_profiles
  ADD CONSTRAINT tournament_profiles_country_id_fk
  FOREIGN KEY (country_id) REFERENCES countries(id)
  ON DELETE RESTRICT 
  ON UPDATE CASCADE;
  SELECT * FROM countries c;
  
DESC countries;
ALTER TABLE countries
  ADD CONSTRAINT countries_flag_id_fk
  FOREIGN KEY (flag_id) REFERENCES media(id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
DESC disciplines;
ALTER TABLE disciplines
  ADD CONSTRAINT disciplines_media_id_fk
  FOREIGN KEY (media_id) REFERENCES media(id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
  
SELECT ROUND(RAND()+1);
DESC matches;
UPDATE matches SET winner_team = LEAST(team_1_id, team_2_id);
UPDATE matches SET winner_team = LEAST(team_1_id, team_2_id) + ROUND(RAND())*(GREATEST(team_1_id, team_2_id) - LEAST(team_1_id, team_2_id));

DESC matches;
UPDATE matches SET winner_team = NULL WHERE active_status_id != 1;
SELECT final_score FROm matches m WHERE LEFT(final_score,1)=RIGHT(final_score,1) LIMIT 100; 
UPDATE matches SET final_score = CONCAT(ROUND(1+RAND()*2),':',(ROUND(1+RAND()*2)-1)) WHERE active_status_id = 1;
UPDATE matches SET winner_team = NULL WHERE LEFT(final_score,1)=RIGHT(final_score,1);
ALTER TABLE matches 
  ADD CONSTRAINT matches_team_1_id_fk
  FOREIGN KEY (team_1_id) REFERENCES teams(id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
  ADD CONSTRAINT matches_team_2_id_fk
  FOREIGN KEY (team_2_id) REFERENCES teams(id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
  ADD CONSTRAINT matches_active_status_id_fk
  FOREIGN KEY (active_status_id) REFERENCES statuses(id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
  ADD CONSTRAINT matches_winner_team_fk
  FOREIGN KEY (winner_team) REFERENCES teams(id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;

DESC media;
ALTER TABLE media
  ADD CONSTRAINT media_media_type_id_fk
  FOREIGN KEY (media_type_id) REFERENCES media_types(id)
  ON DELETE CASCADE
  ON UPDATE CASCADE;
  
DESC player_profiles;
ALTER TABLE player_profiles
  ADD CONSTRAINT player_profiles_player_id_fk
  FOREIGN KEY (player_id) REFERENCES players(id)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  ADD CONSTRAINT player_profiles_last_team_id_fk
  FOREIGN KEY (last_team_id) REFERENCES teams(id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
  ADD CONSTRAINT player_profiles_media_id_fk
  FOREIGN KEY (media_id) REFERENCES media(id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
  ADD CONSTRAINT player_profiles_flag_id_fk
  FOREIGN KEY (flag_id) REFERENCES media(id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;

DESC players;
SELECT team_function_id FROM players LIMIT 40;
ALTER TABLE players CHANGE currrent_discipline_id 
		current_discipline_id SMALLINT UNSIGNED NOT NULL 
		COMMENT "discipline of which is the team or single player";

ALTER TABLE players
  ADD CONSTRAINT player_country_id_fk
  FOREIGN KEY (country_id) REFERENCES countries(id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
  ADD CONSTRAINT player_current_team_id_fk
  FOREIGN KEY (current_team_id) REFERENCES teams(id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
  ADD CONSTRAINT player_current_discipline_id_fk
  FOREIGN KEY (current_discipline_id) REFERENCES disciplines(id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
  ADD CONSTRAINT player_team_function_id_fk
  FOREIGN KEY (team_function_id) REFERENCES team_functions(id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;
 
DESC teams;
ALTER TABLE teams CHANGE discipline_id 
		discipline_id SMALLINT UNSIGNED NOT NULL 
		COMMENT "discipline of which is the team or single player";
ALTER TABLE teams
  ADD CONSTRAINT teams_discipline_id_fk
  FOREIGN KEY (discipline_id) REFERENCES disciplines(id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
  ADD CONSTRAINT teams_country_id_fk
  FOREIGN KEY (country_id) REFERENCES countries(id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
  ADD CONSTRAINT teams_default_country_fk
  FOREIGN KEY (default_country) REFERENCES countries(id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE,
  ADD CONSTRAINT teams_media_id_fk
  FOREIGN KEY (media_id) REFERENCES media(id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;

ALTER TABLE matches_by
  ADD CONSTRAINT matches_by_match_id_fk
  FOREIGN KEY (match_id) REFERENCES matches(id)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  ADD CONSTRAINT matches_by_discipline_id_fk
  FOREIGN KEY (discipline_id) REFERENCES disciplines(id)
  ON DELETE RESTRICT
  ON UPDATE CASCADE;

INSERT INTO matches_by(discipline_id, match_id) SELECT ROUND(1 + RAND()*14), id FROM matches;
-- adding indexes 
CREATE INDEX teams_name_idx ON teams(name);
CREATE INDEX players_nickname_idx ON players(nickname);
CREATE INDEX tournament_profiles_name_idx ON tournament_profiles(name);