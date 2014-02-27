INSERT INTO cities
VALUES ('Hermitage', '37076', 'us')

INSERT INTO venues (name, street_address, type, postal_code, country_code)
VALUES ('My Place', '5901 Old Hickory Blvd', 'private', '37076', 'us');

INSERT INTO events (title, starts, ends, venue_id)
VALUES ('Wedding', '2012-02-26 21:00:00', '2014-02-26 21:30:00', 2),
	('Dinner with Mom', '2012-02-26 18:00:00', '2012-02-26 20:30:00', 5),
	('Valentine''s Day', '2012-02-14 00:00:00', '2014-02-14 23:59:00', NULL);

SELECT count(title)
FROM events
WHERE title LIKE '%Day%';

SELECT min(starts), max(ends)
FROM events INNER JOIN venues
ON events.venue_id = venues.venue_id
WHERE venues.name = 'Crystal Ballroom';

SELECT venue_id, count(*)
FROM events
GROUP BY venue_id;

SELECT venue_id
FROM events
GROUP BY venue_id
HAVING count(*) >= 2 AND venue_id IS NOT NULL;

SELECT DISTINCT venue_id FROM events;

SELECT title, count(*) OVER (PARTITION BY venue_id) FROM events;

SELECT venue_id, count (*)
FROM events
GROUP BY venue_id
ORDER BY venue_id

BEGIN TRANSACTION;
	DELETE FROM events;
ROLLBACK;
SELECT * FROM events;

SELECT add_event('House Party', '2012-05-03 23:00', '2012-05-04 02:00', 'Run''s House', '97205', 'us');

CREATE TABLE logs (
	event_id integer,
	old_title varchar(255),
	old_starts timestamp,
	old_ends timestamp,
	logged_at timestamp DEFAULT current_timestamp
);

CREATE TRIGGER log_events
AFTER UPDATE ON events
FOR EACH ROW EXECUTE PROCEDURE log_event();

UPDATE events
SET ends = '2012-05-04 01:00:00'
WHERE title='House Party';

CREATE VIEW holidays AS
	SELECT event_id AS holiday_id, title AS name, starts AS date
	FROM events
	WHERE title LIKE '%Day%' AND venue_id IS NULL;

SELECT name, to_char(date, 'Month DD, YYYY') AS date
FROM holidays
WHERE date <= '2012-04-01';

ALTER TABLE events
ADD colors text ARRAY;

CREATE OR REPLACE VIEW holidays AS
	SELECT event_id AS holiday_id, title AS name, starts AS date, colors
	FROM events
	WHERE title LIKE '%Day%' AND venue_id IS NULL;

CREATE RULE update_holidays AS ON UPDATE TO holidays DO INSTEAD
	UPDATE events
	SET title = NEW.name,
		starts = NEW.date,
		colors = NEW.colors
	WHERE title = OLD.name;

UPDATE holidays SET colors = '{"red", "green"}' WHERE name = 'Christmas Day';

CREATE TEMPORARY TABLE month_count(month INT);
INSERT INTO month_count VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12);

SELECT * FROM crosstab(
	'SELECT 
		extract(year from starts) as year,
		extract(month from starts) as month,
		count(*)
	FROM
		events
	GROUP BY year, month',
	'SELECT * FROM month_count'
) AS (
	year int,
	jan int, feb int, mar int, apr int, may int, jun int,
	jul int, aug int, sep int, oct int, nov int, dec int
) ORDER BY YEAR;

