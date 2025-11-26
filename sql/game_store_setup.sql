-- SQL Script: Game Store Database Setup and Practice Queries

-- =====================================================================
-- PART 1: DATABASE SETUP AND SCHEMA DEFINITION (DDL)
-- =====================================================================

-- ❓ Create the main database for the game store.
CREATE DATABASE IF NOT EXISTS game_store_db;
-- ❓ Select the newly created database for use.
USE game_store_db;

-- ---------------------------------------------------------------------
-- Table 1: developers
-- ❓ Create the 'developers' table to store information about game studios.
CREATE TABLE developers (
    developer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    country VARCHAR(100),
    founded_year INT
);

-- ---------------------------------------------------------------------
-- Table 2: games
-- ❓ Create the 'games' table, linking to 'developers' via Foreign Key.
CREATE TABLE games (
    game_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    genre VARCHAR(100),
    price DECIMAL(6,2),
    release_year INT,
    developer_id INT,
    FOREIGN KEY (developer_id) REFERENCES developers(developer_id)
);

-- ---------------------------------------------------------------------
-- Table 3: players
-- ❓ Create the 'players' table to track user information.
CREATE TABLE players (
    player_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    country VARCHAR(100)
);

-- ---------------------------------------------------------------------
-- Table 4: purchases
-- ❓ Create the 'purchases' table to record transactions, linking players and games.
CREATE TABLE purchases (
    purchase_id INT PRIMARY KEY AUTO_INCREMENT,
    player_id INT,
    game_id INT,
    purchase_date DATE,
    quantity INT DEFAULT 1,
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    FOREIGN KEY (game_id) REFERENCES games(game_id)
);


-- =====================================================================
-- PART 2: DATA INSERTION (DML)
-- =====================================================================

-- ❓ Insert initial data for the developers.
INSERT INTO developers (name, country, founded_year) VALUES
('FromSoftware', 'Japan', 1986),
('Santa Monica Studios', 'USA', 1999),
('CD Project Red', 'Poland', 2002),
('Rockstar Games', 'USA', 1998),
('Nintendo', 'Japan', 1889);

-- ❓ Insert initial data for the games, linking them to their developers.
INSERT INTO games (title, genre, price, release_year, developer_id) VALUES
('Sekiro: Shadow Die Twice', 'Action', 59.99, 2019, 1),
('God of War', 'Action', 49.99, 2018, 2),
('Cyberpunk 2077', 'RPG', 69.99, 2020, 2),
('GTA V', 'Action', 39.99, 2013, 4),
('Elden Ring', 'RPG', 59.99, 2022, 1),
('Legend of Zelda: Breath of the Wild', 'Adventure', 59.99, 2017, 5);

-- ❓ Insert initial data for the players.
INSERT INTO players (username, email, country) VALUES
('ShadowSlayer', 'shadow@example.com', 'India'),
('NoobMaster69', 'noob@example.com', 'USA'),
('RagnarokKing', 'ragnarok@example.com', 'Norway'),
('StealthNinja', 'ninja@example.com', 'Japan');

-- ❓ Insert initial data for the purchases (transactions).
INSERT INTO purchases (player_id, game_id, purchase_date, quantity) VALUES
(1, 1, '2024-01-10', 1),
(2, 2, '2024-01-11', 2),
(3, 3, '2024-01-15', 1),
(4, 1, '2024-01-17', 3),
(2, 4, '2024-01-18', 1),
(1, 5, '2024-01-19', 1);

-- =====================================================================
-- PART 3: PRACTICE QUERIES (DQL)
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Basic Selection and Filtering
-- ---------------------------------------------------------------------

-- ❓ Retrieve all columns and all rows from the 'games' table.
SELECT * FROM games;

-- ❓ Show only the title and price for every game.
SELECT title, price FROM games;

-- ❓ Find all player records for users located in 'India'.
SELECT * FROM players WHERE country = 'India';

-- ❓ List the titles of all games released after the year 2018.
SELECT title FROM games WHERE release_year > 2018;

-- ❓ List the titles of all games priced over 50.
SELECT title FROM games WHERE price > 50;

-- ❓ Find all games with a price between 40 and 60 (inclusive).
SELECT * FROM games WHERE price BETWEEN 40 AND 60;

-- ❓ Show all players who are NOT from the 'USA'.
SELECT * FROM players WHERE country <> 'USA';

-- ---------------------------------------------------------------------
-- 2. Ordering, Unique Values, and Pattern Matching
-- ---------------------------------------------------------------------

-- ❓ Get all player usernames, sorted in alphabetical (ascending) order.
SELECT username FROM players ORDER BY username ASC;

-- ❓ List all unique genres available in the 'games' table.
SELECT DISTINCT genre FROM games;

-- ❓ Find all games whose title contains the word 'Sekiro' anywhere.
SELECT * FROM games WHERE title LIKE '%Sekiro%';

-- ❓ List all games whose title starts with the letter 'G'.
SELECT * FROM games WHERE title LIKE 'G%';

-- ❓ List all games, sorted by price from highest to lowest (descending).
SELECT * FROM games ORDER BY price DESC;

-- ---------------------------------------------------------------------
-- 3. Complex Filtering (AND/OR)
-- ---------------------------------------------------------------------

-- ❓ Find all games cheaper than 55 AND released after 2018.
SELECT * FROM games WHERE price < 55 AND release_year > 2018;

-- SQL Script: Advanced JOIN and Aggregation Queries for Game Store

-- =====================================================================
-- 1. INNER JOIN: Matching Records Only
-- =====================================================================

-- ❓ Query: List all games and the name of their developer. (Standard INNER JOIN)
-- 💡 Result: Only shows games that have a matching developer in the developers table.
SELECT
    G.title,
    D.name
FROM games AS G
INNER JOIN developers AS D
ON G.developer_id = D.developer_id;


-- ---------------------------------------------------------------------

-- ❓ Query: Get a list of every purchase, showing the player's username, the game title, and the purchase date. (Multi-Table INNER JOIN)
-- 💡 Result: Joins three tables (Purchases, Players, Games) to display transaction details.
SELECT
    P.username AS player,
    G.title AS game,
    PU.purchase_date
FROM purchases AS PU
JOIN players AS P ON PU.player_id = P.player_id
JOIN games AS G ON PU.game_id = G.game_id;


-- =====================================================================
-- 2. LEFT JOIN: Including Unmatched Records
-- =====================================================================

-- ❓ Query: List all games and their developer name. If a game exists without a developer (though unlikely with Foreign Key constraints), still list the game with a NULL developer name.
-- 💡 Result: Guarantees every row from the 'games' (LEFT) table is included.
SELECT
    G.title AS Title,
    D.name AS Developer
FROM games AS G
LEFT JOIN developers AS D 
ON G.developer_id = D.developer_id;


-- ❓ Query: Count the total number of games for each developer, including developers who have released zero games. (LEFT JOIN with GROUP BY)
-- 💡 Result: Every developer will be listed, and their game count will be 0 if no match exists.
SELECT
    d.name AS developer,
    COUNT(g.game_id) AS total_games
FROM developers AS d
LEFT JOIN games AS g
    ON d.developer_id = g.developer_id
GROUP BY d.name;


-- ❓ Query: Calculate the total revenue generated by each game. (LEFT JOIN with Aggregation)
-- 💡 Result: Lists every game and its total calculated revenue (SUM of quantity * price). Using LEFT JOIN ensures games with zero purchases are included (revenue will be 0 or NULL).
SELECT
    g.title AS Game,
    SUM(pu.quantity * g.price) AS Revenue
FROM purchases AS pu
LEFT JOIN games AS g
    ON g.game_id = pu.game_id
GROUP BY g.title;


-- =====================================================================
-- 3. Advanced Aggregation and Grouping
-- =====================================================================

-- ❓ Query: Calculate the total revenue earned by each developer across all their games. (Multi-JOIN and SUM)
-- 💡 Result: Sums up revenue for all games that belong to a specific developer.
SELECT 
    d.name AS Developer,
    SUM(g.price * pu.quantity) AS Total_revenue
FROM developers AS d
JOIN games AS g
    ON d.developer_id = g.developer_id
JOIN purchases AS pu
    ON g.game_id = pu.game_id
GROUP BY d.name;


-- ❓ Query: Calculate the total amount of money each player has spent, sorted from highest spender to lowest. (Multi-JOIN, SUM, and ORDER BY)
-- 💡 Result: Provides a leaderboard of players based on their total spending.
SELECT 
    p.username AS Player,
    SUM(pu.quantity * g.price) AS Total_Spent
FROM purchases AS pu
JOIN games AS g 
    ON g.game_id = pu.game_id
JOIN players AS p
    ON p.player_id = pu.player_id
GROUP BY p.username
ORDER BY Total_Spent DESC;


-- ❓ Query: Find all developers who have released more than one game. (GROUP BY with HAVING)
-- 💡 Result: Filters the results of the COUNT aggregation. The WHERE clause cannot be used here because it filters rows before aggregation occurs.
SELECT 
    d.name AS Developer,
    COUNT(g.game_id) AS Total_Games
FROM developers AS d
JOIN games AS g
    ON d.developer_id = g.developer_id
GROUP BY d.name 
HAVING COUNT(g.game_id) > 1;