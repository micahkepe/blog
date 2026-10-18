CREATE TABLE LIKES (
    DRINKER TEXT,
    BEER TEXT
);

-- SIMPLE EXAMPLE

-- Example data
INSERT INTO LIKES (DRINKER, BEER) VALUES
('Ava', 'Bud Light'),
('Ava', 'Pabst'),
('Ava', 'Miller Lite'),
('Bob', 'Bud Light'),
('Bob', 'Coors Light'),
('Bob', 'Miller Lite'),
('Charlie', 'Bud Light'),
('Charlie', 'Coors Light'),
('Charlie', 'Miller Lite');

-- Find beers Ava drinks
SELECT BEER FROM LIKES WHERE DRINKER = 'Ava';

-- Explain query plan
EXPLAIN QUERY PLAN
SELECT BEER FROM LIKES WHERE DRINKER = 'Ava';

-- Create index on drinker and re-explain
CREATE INDEX idx_drinker ON LIKES(DRINKER);
EXPLAIN QUERY PLAN
SELECT BEER FROM LIKES WHERE DRINKER = 'Ava';

-- cleanup
DROP TABLE LIKES;


-- COMPLEX EXAMPLE

CREATE TABLE DRINKER (
    ID INTEGER PRIMARY KEY,
    NAME TEXT
);

CREATE TABLE BEER (
    ID INTEGER PRIMARY KEY,
    NAME TEXT,
    TYPE TEXT
);

CREATE TABLE LIKES (
    DRINKER_ID INTEGER,
    BEER_ID INTEGER,
    PREFERENCE INTEGER, -- Lower numbers indicate higher preference
    FOREIGN KEY(DRINKER_ID) REFERENCES DRINKER(ID),
    FOREIGN KEY(BEER_ID) REFERENCES BEER(ID)
);

-- Example data
INSERT INTO DRINKER (ID, NAME) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

INSERT INTO BEER (ID, NAME, TYPE) VALUES
(1, 'Budweiser', 'Lager'),
(2, 'Coors Light', 'Lager'),
(3, 'Miller Lite', 'Pilsner');

INSERT INTO LIKES (DRINKER_ID, BEER_ID, PREFERENCE) VALUES
(1, 1, 1),  -- Alice likes Budweiser the most
(1, 2, 2),  -- Alice likes Coors Light second
(2, 3, 1),  -- Bob prefers Miller Lite
(3, 1, 1),  -- Charlie likes Budweiser the most
(3, 2, 3),  -- Charlie's least favorite is Coors Light
(3, 3, 2);  -- Charlie likes Miller Lite second

-- query example
SELECT DRINKER.NAME, BEER.NAME, LIKES.PREFERENCE
FROM DRINKER
JOIN LIKES ON DRINKER.ID = LIKES.DRINKER_ID
JOIN BEER ON BEER.ID = LIKES.BEER_ID
ORDER BY DRINKER.NAME, LIKES.PREFERENCE;

-- execution plan
EXPLAIN QUERY PLAN
SELECT DRINKER.NAME, BEER.NAME, LIKES.PREFERENCE
FROM DRINKER
JOIN LIKES ON DRINKER.ID = LIKES.DRINKER_ID
JOIN BEER ON BEER.ID = LIKES.BEER_ID
ORDER BY DRINKER.NAME, LIKES.PREFERENCE;

-- optimizing
CREATE INDEX idx_likes_drinker_pref ON LIKES(DRINKER_ID, PREFERENCE);

ANALYZE; -- update plan 

EXPLAIN QUERY PLAN
SELECT DRINKER.NAME, BEER.NAME, LIKES.PREFERENCE
FROM DRINKER
JOIN LIKES ON DRINKER.ID = LIKES.DRINKER_ID
JOIN BEER ON BEER.ID = LIKES.BEER_ID
ORDER BY DRINKER.NAME, LIKES.PREFERENCE;