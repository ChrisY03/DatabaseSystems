CREATE TABLE IF NOT EXISTS series (
  series_id INTEGER(10) AUTO_INCREMENT PRIMARY KEY,
  series_title VARCHAR(256), -- note that two different series may have the same title
  rating DOUBLE DEFAULT 0 -- max 5.00
);

CREATE TABLE IF NOT EXISTS episodes (
  episode_id INTEGER(10) AUTO_INCREMENT NOT NULL UNIQUE,
  series_id INTEGER(10) REFERENCES series(series_id),
  season_number TINYINT(4),
  episode_number TINYINT(4),
  episode_title VARCHAR(128),
  episode_length REAL, -- length of the episode in minutes
  date_of_release DATE,
  PRIMARY KEY (series_id, season_number, episode_number)
);

CREATE TABLE IF NOT EXISTS actors (
  actor_id INTEGER(10) AUTO_INCREMENT PRIMARY KEY,
  actor_name VARCHAR(128) -- note that two different actors may have the same name
);

CREATE TABLE IF NOT EXISTS actor_episode ( -- episode_id features actor_id
  actor_id INTEGER(10) REFERENCES actors(actor_id),  
  episode_id INTEGER(10) REFERENCES episodes(episode_id),
  PRIMARY KEY(actor_id, episode_id) 
);

CREATE TABLE IF NOT EXISTS users (
  user_id INTEGER(10) AUTO_INCREMENT PRIMARY KEY,
  user_name VARCHAR(128),
  user_email VARCHAR(128) UNIQUE
);

CREATE TABLE IF NOT EXISTS user_history (
  user_id INTEGER(10) REFERENCES users(user_id),  
  episode_id INTEGER(10) REFERENCES episodes(episode_id),
  minutes_played REAL, -- minutes of this episode the user has watched/played
  PRIMARY KEY(user_id, episode_id)
);