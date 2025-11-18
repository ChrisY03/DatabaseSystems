-- Inserting series data
INSERT INTO series (series_title, rating) VALUES
('Breaking Bad', 4.0),
('Stranger Things', 4.5),
('The Mandalorian', 3.99);

-- Inserting episodes data
INSERT INTO episodes (series_id, season_number, episode_number, episode_title, episode_length, date_of_release) VALUES
(1, 1, 1, 'Pilot', 58.5, '2008-01-20'),
(1, 1, 2, 'Cat''s in the Bag...', 49.2, '2008-01-27'),
(1, 2, 1, 'Seven Thirty-Seven', 47.8, '2009-03-08'),
(2, 1, 1, 'Chapter One: The Vanishing of Will Byers', 50.0, '2016-07-15'),
(2, 1, 2, 'Chapter Two: The Weirdo on Maple Street', 48.5, '2016-07-15'),
(3, 1, 1, 'Chapter 1: The Mandalorian', 40.2, '2019-11-12'),
(3, 1, 2, 'Chapter 2: The Child', 33.8, '2019-11-15');

-- Inserting actors data
INSERT INTO actors (actor_name) VALUES
('Bryan Cranston'),
('Aaron Paul'),
('Anna Gunn'),
('Millie Bobby Brown'),
('Finn Wolfhard'),
('Pedro Pascal'),
('Gina Carano'),
('Carl Weathers');

-- Inserting actor_episode data
INSERT INTO actor_episode (actor_id, episode_id) VALUES
(1, 1),
(1, 2),
(2, 1),
(2, 2),
(3, 3),
(4, 4),
(4, 5),
(5, 4),
(5, 5),
(6, 6),
(6, 7),
(7, 6),
(7, 7),
(8, 6),
(8, 7);

-- Inserting users data
INSERT INTO users (user_name, user_email) VALUES
('User1', 'user1@example.com'),
('User2', 'user2@example.com'),
('User3', 'user3@example.com');

-- Inserting user_history data
INSERT INTO user_history (user_id, episode_id, minutes_played) VALUES
(1, 1, 30.0),
(1, 2, 45.0),
(2, 4, 20.0),
(2, 5, 35.0),
(3, 6, 15.0),
(3, 7, 28.0),
(1, 3, 22.0),
(2, 3, 15.0),
(3, 1, 30.0),
(3, 3, 25.0);