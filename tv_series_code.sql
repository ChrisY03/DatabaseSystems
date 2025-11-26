-- Task 2.1: View showing cast for series with rating 4.0 or higher
CREATE OR REPLACE VIEW top_series_cast (series_id, series_title, `cast`) AS
SELECT
    s.series_id,
    s.series_title,
    GROUP_CONCAT(DISTINCT a.actor_name ORDER BY a.actor_name SEPARATOR ', ') AS `cast`
FROM series AS s
JOIN episodes AS e
  ON e.series_id = s.series_id
JOIN actor_episode AS ae
  ON ae.episode_id = e.episode_id
JOIN actors AS a
  ON a.actor_id = ae.actor_id
WHERE s.rating >= 4.00
GROUP BY s.series_id, s.series_title;

-- Task 2.2: View calculating total minutes played per actor
CREATE OR REPLACE VIEW actor_minutes (actor_id, actor_name, total_minutes_played) AS
SELECT
    a.actor_id,
    a.actor_name,
    IF(SUM(uh.minutes_played) IS NULL, 0, SUM(uh.minutes_played)) AS total_minutes_played
FROM actors AS a
LEFT JOIN actor_episode AS ae
  ON ae.actor_id = a.actor_id
LEFT JOIN user_history AS uh
  ON uh.episode_id = ae.episode_id
GROUP BY a.actor_id, a.actor_name;

-- Task 2.3: Trigger preventing invalid minutes and adjusting series rating
DELIMITER $$
CREATE TRIGGER AdjustRating
BEFORE INSERT ON user_history
FOR EACH ROW
BEGIN
  DECLARE ep_len REAL;
  DECLARE sid INT;

  SELECT e.episode_length, e.series_id
    INTO ep_len, sid
  FROM episodes AS e
  WHERE e.episode_id = NEW.episode_id;

  IF ep_len IS NOT NULL THEN
    IF NEW.minutes_played > ep_len THEN
      SET NEW.minutes_played = ep_len;
    END IF;
  END IF;

  IF NEW.minutes_played < 0 THEN
    SET NEW.minutes_played = 0;
  END IF;

  UPDATE series AS s
  SET s.rating = LEAST(5.00, s.rating + (0.0001 * NEW.minutes_played))
  WHERE s.series_id = sid AND s.rating < 5.00;
END$$
DELIMITER ;

-- Task 2.4: Procedure to add a new episode if it doesn't already exist
DELIMITER $$
CREATE PROCEDURE AddEpisode(
  IN s_id INT,
  IN s_number TINYINT,
  IN e_number TINYINT,
  IN e_title VARCHAR(128),
  IN e_length REAL
)
BEGIN
  DECLARE series_exists INT DEFAULT 0;
  DECLARE ep_exists INT DEFAULT 0;

  SELECT COUNT(*) INTO series_exists
  FROM series
  WHERE series_id = s_id;

  IF series_exists = 1 THEN

    SELECT COUNT(*) INTO ep_exists
    FROM episodes
    WHERE series_id = s_id
      AND season_number = s_number
      AND episode_number = e_number;

    IF ep_exists = 0 THEN
      INSERT INTO episodes
        (series_id, season_number, episode_number, episode_title, episode_length, date_of_release)
      VALUES
        (s_id, s_number, e_number, e_title, e_length, CURRENT_DATE());
    END IF;
  END IF;
END$$
DELIMITER ;

-- Task 2.5: Function returning episode titles for a given series and season
DELIMITER $$
CREATE FUNCTION GetEpisodeList(
  s_id INT,
  s_number TINYINT
) RETURNS TEXT
DETERMINISTIC
READS SQL DATA
BEGIN
  DECLARE titles TEXT;

  SELECT GROUP_CONCAT(e.episode_title ORDER BY e.episode_number SEPARATOR ', ')
    INTO titles
  FROM episodes AS e
  WHERE e.series_id = s_id
    AND e.season_number = s_number;

  IF titles IS NULL THEN
    SET titles = '';
  END IF;

  RETURN titles;
END$$
DELIMITER ;
