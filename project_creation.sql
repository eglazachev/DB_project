USE project;
CREATE TABLE IF NOT EXISTS disciplines(
	id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(40) UNIQUE NOT NULL COMMENT "name of disciplines: DotA2, Counter-Strike, etc.",
	media_id INT UNSIGNED NOT NULL COMMENT "logo of discipline",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS tournaments(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	discipline_id SMALLINT UNSIGNED NOT NULL COMMENT "name of tournaments",
	active_status_id TINYINT UNSIGNED NOT NULL COMMENT "status of tournament upcoming, ongoing, recent",
	begins_at DATE NOT NULL COMMENT "date of start of tournament",
	ends_at DATE COMMENT "date of finish of tournament ",
	prize INT UNSIGNED COMMENT "prize pool",
	participants_num SMALLINT UNSIGNED COMMENT "number of participants", 
	location VARCHAR(100) COMMENT "place of holding of tournament",
	is_online BOOLEAN COMMENT "is the tournament via net or an offline tournament in a particular place",
	winner VARCHAR(100) COMMENT "team or nickname of winner",
	add_info VARCHAR (255),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP	
);

CREATE TABLE IF NOT EXISTS tournament_profiles (
	tournament_id INT UNSIGNED NOT NULL,
	name VARCHAR(100) NOT NULL COMMENT "name of tournament",
	tournament_operator_id SMALLINT UNSIGNED COMMENT "an id of organization which is provide tournament", 
	location VARCHAR(100) COMMENT "place of holding of tournament",
	cast_studio_id SMALLINT UNSIGNED COMMENT "broadcaster of tournament",
	discipline_id SMALLINT UNSIGNED NOT NULL COMMENT "name of tournaments",
	media_id INT UNSIGNED NOT NULL COMMENT "a logo of tournament",
	country_id SMALLINT UNSIGNED NOT NULL COMMENT "a country of tournament placement",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


CREATE TABLE IF NOT EXISTS teams (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(100) NOT NULL COMMENT "team tag or nickname ",
	discipline_id INT UNSIGNED NOT NULL COMMENT "discipline of which is the team or single player",
	country_id SMALLINT UNSIGNED NOT NULL COMMENT "a nationality of current roster",
	default_country SMALLINT UNSIGNED NOT NULL COMMENT "a country of team foundament",
	media_id INT UNSIGNED NOT NULL COMMENT "logo of the team",
	add_info VARCHAR (255),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS players (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nickname VARCHAR(100) NOT NULL COMMENT "ingame name of player",
	country_id SMALLINT UNSIGNED NOT NULL COMMENT "origin of player",
	current_team_id INT UNSIGNED COMMENT "id of the team which player belongs to",
	currrent_discipline_id INT UNSIGNED NOT NULL COMMENT "id of discipline which player represent now",
	is_active BOOLEAN COMMENT "is the player active now",
	team_function_id TINYINT UNSIGNED NOT NULL COMMENT "the role of player in the team",
	add_info VARCHAR (255),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS player_profiles(
	player_id INT UNSIGNED NOT NULL,
	first_name VARCHAR(60) NOT NULL,
	last_name VARCHAR(60) NOT NULL,
	last_team_id INT UNSIGNED COMMENT "id of the previous team which player was belong to",
	career_teams VARCHAR(2000) COMMENT "the list of teams which player played for",
	career_start DATE NOT NULL COMMENT "date of first official players' game",
	career_end DATE DEFAULT NULL COMMENT "date of last official players' game",
	career_prize INT UNSIGNED COMMENT "total amount of prize in career",
	media_id INT UNSIGNED NOT NULL COMMENT "an avatar of player",
	flag_id INT UNSIGNED NOT NULL,
	birthplace VARCHAR(255),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS matches (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	team_1_id INT UNSIGNED NOT NULL,
	team_2_id INT UNSIGNED NOT NULL,
	start_at DATETIME NOT NULL COMMENT "date and time of the beginning of the match",
	active_status_id TINYINT UNSIGNED NOT NULL COMMENT "status of tournament upcoming, ongoing, recent",
	final_score VARCHAR(15) COMMENT "result of match (ex. 2:1)",
	winner_team INT UNSIGNED COMMENT "team name of the winner of match", 
	cast_at VARCHAR(2000) COMMENT  "a link to broeadcaster of match at twtch, youtube, etc.",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS countries (
	id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR (150) COMMENT "country name",
	flag_id INT UNSIGNED NOT NULL COMMENT "link to flag image",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS media (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
	filename VARCHAR(255) NOT NULL COMMENT "name of file path",
    file_size INT UNSIGNED NOT NULL COMMENT "the size of object",
    metadata json DEFAULT NULL,
    media_type_id TINYINT UNSIGNED NOT NULL COMMENT "type of media",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP, 
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS media_types (
	id TINYINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(20) COMMENT "names of media types",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP	
);

CREATE TABLE IF NOT EXISTS tournament_operators(
	id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(60) COMMENT "name of organization",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP		
);

CREATE TABLE IF NOT EXISTS cast_studios(
	id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(60) COMMENT "name of cast studio",
	cast_language_flag_id INT UNSIGNED COMMENT "language of broadcast",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP		
);

CREATE TABLE IF NOT EXISTS statuses (
	id TINYINT UNSIGNED NOT NULL PRIMARY KEY,
	name VARCHAR (20) UNIQUE COMMENT "status name for matches and tournaments",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP	
);

CREATE TABLE IF NOT EXISTS team_functions (
	id TINYINT UNSIGNED NOT NULL PRIMARY KEY,
	name VARCHAR (20) UNIQUE COMMENT "name of team role of person",
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP	
);

CREATE TABLE IF NOT EXISTS matches_by (
	match_id BIGINT UNSIGNED NOT NULL UNIQUE,
	discipline_id SMALLINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY(match_id,discipline_id)
);
