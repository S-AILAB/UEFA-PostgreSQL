CREATE TABLE goals(
 GOAL_ID varchar,
 MATCH_ID varchar,
 PID varchar,
 DURATION int,
 ASSIT varchar,
 GOAL_DESC varchar
);

copy goals
FROM 'C:\Program Files\PostgreSQL\17\data\UEFA\goals.csv' DELIMITER ',' CSV HEADER;



CREATE TABLE matches( 
MATCH_ID varchar,
SEASON varchar,
DATE varchar, --since it is not matching the format yyyy-mm-dd
HOME_TEAM varchar,
AWAY_TEAM varchar,
STADIUM varchar,
HOME_TEAM_SCORE int,
AWAY_TEAM_SCORE int,
PEANLTY_SHOOT_OUT int,
ATTENDANCE int
);

copy matches
FROM 'C:\Program Files\PostgreSQL\17\data\UEFA\Matches.csv' DELIMITER ',' CSV HEADER;


SELECT * FROM goals;

SELECT * FROM matches;
--changing the date format by inserting new column

ALTER TABLE matches ADD COLUMN match_date DATE;
UPDATE matches
SET match_date = TO_DATE(date , 'DD-MM-YYYY');

SELECT * FROM matches;

CREATE TABLE players(
PLAYER_ID varchar,
FIRST_NAME varchar,
LAST_NAME varchar,
NATIONALITY varchar,
DOB date,
TEAM varchar,
JERSER_NUMBER float,
POSITION varchar,
HEIGHT float,
WEIGHT float,
FOOT varchar
);

COPY players
FROM 'C:\Program Files\PostgreSQL\17\data\UEFA\Players.csv' DELIMITER ',' CSV HEADER;

SELECT * FROM players;
/* ADDING A COLUMN TO GET FULL NAME */
ALTER TABLE players ADD COLUMN full_name varchar;
UPDATE players
SET full_name = CONCAT(first_name, ' ', last_name);

CREATE TABLE teams(
TEAM_NAME varchar,
COUNTRY varchar,
HOME_STADIUM varchar
);

COPY teams
FROM 'C:\Program Files\PostgreSQL\17\data\UEFA\Teams.csv' DELIMITER ',' CSV HEADER;


SELECT * FROM teams;

CREATE TABLE stadium(
NAME varchar,
CITY varchar,
COUNTRY varchar,
CAPACITY int
);
COPY stadium
FROM 'C:\Program Files\PostgreSQL\17\data\UEFA\Stadiums.csv' DELIMITER ',' CSV HEADER;

SELECT * FROM stadium;

SELECT * FROM goals;

SELECT * FROM matches;

--EDA

-- ROW COUNT for all the tables
SELECT 'players' AS table, COUNT(*) FROM players --2769
UNION ALL
SELECT 'matches', COUNT(*) FROM matches --744
UNION ALL
SELECT 'goals',  COUNT(*) FROM goals -- 2279
UNION ALL
SELECT 'teams',  COUNT(*) FROM teams --74
UNION ALL
SELECT 'stadium', COUNT (*) FROM stadium; --86


-- Check null count
SELECT COUNT(*) AS total_rows,
	COUNT(assit) AS not_null_values,
	COUNT(*) - COUNT(assit) AS null_count,
	ROUND(100*(COUNT(*) - COUNT(assit))/COUNT(*),2) AS null_percentage
FROM goals; -- 29% null these nulls can be self goals assuming so keeping them

-- moving to excel for pre data processing i.e finding null values since the dataset is large


--Conclusion from excel 
/* not removing the null values */ 


-- Checking for duplicate in players - player-id
SELECT * FROM players
SELECT player_id
FROM players
GROUP BY 1
HAVING COUNT (*) > 1
-- No playerID is duplicate in players table


-- Checking for duplicate in matches table - match_id
SELECT * FROM matches
SELECT match_id
FROM matches
GROUP BY 1
HAVING COUNT (*) > 1
--No matchID is duplicate in matches table

-- Checking for duplicate records in stadium table
SELECT * FROM stadium
GROUP BY 1,2,3,4
HAVING COUNT (*) > 1
-- No duplicate records

--Checking for duplicate in teams
SELECT * FROM teams
GROUP BY 1,2,3
HAVING COUNT (*) > 1 
-- No duplicate records

--Checking for duplicate in goals table (goal_id)
SELECT goal_id 
FROM goals
GROUP BY 1
HAVING COUNT(*) > 1;
--No duplicate records
---
/* Goal Analysis (From the Goals table) */

/*1.Which player scored the most goals in a each season?*/
SELECT DISTINCT ON (m.season) 
	m.season, g.pid, COUNT(g.goal_id) AS total_goals
FROM goals AS g 
LEFT JOIN matches AS m
ON g.match_id = m.match_id
GROUP BY m.season, g.pid
ORDER BY m.season, total_goals DESC;
/* Since there are some null values avaliable in the table,
therefore we will not able to calculate which .*/

/*2.How many goals did each player score in a given season?*/
SELECT m.season, g.pid, COUNT(g.goal_id) AS total_goal 
FROM goals AS g
JOIN matches as m
ON g.match_id = m.match_id
GROUP BY 1, 2
ORDER BY 1, 2;


/* 3.What is the total number of goals scored in ‘mt403’ match? */
SELECT match_id, COUNT(goal_id) AS total_goals
FROM goals
WHERE match_id = 'mt403'
GROUP BY 1;
/* ANSWER - 4 */


/* 4.Which player assisted the most goals in a each season?  */
SELECT DISTINCT ON (m.season)
	m.season,  g.assit as player_id,COUNT(g.assit) AS assisted_goals
FROM matches AS m
JOIN goals AS g
ON m.match_id = g.match_id
GROUP BY 1,2;

/* 5.Which players have scored goals in more than 10 matches? */
/* Approach here we are using goals table along with match id and pid,
counting the distinct matches each player goaled. */

SELECT pid, COUNT(DISTINCT match_id) AS total_goals
FROM goals
GROUP BY 1
HAVING COUNT(DISTINCT match_id)>10;

/*6.What is the average number of goals scored per match in a given season?*/
SELECT season, AVG(total_goal)
FROM
(SELECT m.season,g.match_id, COUNT(g.goal_id) AS total_goal
FROM goals AS g 
JOIN matches AS m
ON m.match_id = g.match_id
GROUP BY 1,2) AS match_stats
GROUP BY season
ORDER BY 1;

/*7.Which player has the most goals in a single match?*/
SELECT pid, match_id, COUNT(goal_id) AS most_goal
FROM goals
GROUP BY 1,2
ORDER BY most_goal DESC;

/*8.Which team scored the most goals in the all seasons?*/
SELECT p.team, COUNT(g.goal_id) AS total_goals
FROM players AS p 
JOIN goals AS g
ON p.player_id = g.pid
GROUP BY 1
ORDER BY total_goals DESC;

/* 9.Which stadium hosted the most goals scored in a single season? */
SELECT m.season, m.stadium, COUNT(g.goal_id) AS goal_count
FROM matches m
JOIN goals g
ON m.match_id = g.match_id
GROUP BY 1, 2
ORDER BY goal_count DESC 
LIMIT 1;

/* Match Analysis (From the Matches table) */

/* 10.What was the highest-scoring match in a particular season? */
SELECT season, match_id, (home_team_score + away_team_score) AS total_score
FROM matches
ORDER BY season, total_score DESC;

/* SINCE THE QUESTION DOESN"T MENTION ANY PARTICULAR YEAR 
I AM FINDING FOR ALL THE YEAR
IF THERE WAS YEAR MENTIONED THEN I WOULD HAVE USED WHERE CLAUSE
WHERE season = ''     */

/* 11.How many matches ended in a draw in a given season?*/
SELECT season, COUNT(match_id) AS total_draw_matches
FROM matches
WHERE home_team_score = away_team_score
GROUP BY 1
ORDER BY season;

/* 12.Which team had the highest average score (home and away) in the season 2021-2022? */
/* Here first we are finding separate avg goals for both home and away*/
SELECT home_team, ROUND(AVG(home_team_score),3) AS avg_home_goal
FROM matches
WHERE season = '2021-2022'
GROUP BY 1
ORDER BY avg_home_goal DESC;

SELECT away_team, ROUND(AVG(away_team_score),3) AS avg_away_goal
FROM matches
WHERE season = '2021-2022'
GROUP BY 1
ORDER BY avg_away_goal DESC;

/* Let's combine the above two query now*/

SELECT team, ROUND(AVG(goals),3) AS avg_goals
FROM (
SELECT home_team AS team, home_team_score AS goals
FROM matches
WHERE season = '2021-2022'

UNION ALL

SELECT away_team AS team, away_team_score AS goals
FROM matches
WHERE season = '2021-2022'
) AS total_avg_goals
GROUP BY 1
ORDER BY avg_goals DESC;

/* 13.How many penalty shootouts occurred in a each season? */
SELECT season, SUM(peanlty_shoot_out) AS total_peanlty_per_season
FROM matches
GROUP BY 1
ORDER BY total_peanlty_per_season DESC;
/*As per the output there weren't any peanlty shootouts in any season*/

/* 14.What is the average attendance for home teams in the 2021-2022 season? */
SELECT home_team, ROUND(AVG(attendance),3) AS avg_attendance
FROM matches
WHERE season = '2021-2022'
GROUP BY 1;

/* 15.Which stadium hosted the most matches in a each season? */
SELECT DISTINCT ON (season) season, stadium, COUNT(match_id) AS number_of_matches
FROM matches
GROUP BY 1, 2
ORDER BY 1;


/* 16.What is the distribution of matches played in different countries in a season? */
/* no year is mentioned i am using 2021 - 2021 */
SELECT s.country ,COUNT(m.match_id) AS match_count
FROM matches AS m
JOIN stadium AS s
ON m.stadium = s.name
WHERE m.season = '2021-2022'
GROUP BY 1
ORDER BY match_count DESC;

/* 17.What was the most common result in matches (home win, away win, draw)? */
SELECT results, COUNT(results) AS total_matches
FROM
(SELECT  
CASE 
WHEN home_team_score > away_team_score THEN 'HOME WIN'
WHEN away_team_score > home_team_score THEN 'AWAY WIN'
ELSE 'DRAW'
END AS results
FROM matches
) AS match_result
GROUP BY 1;

/* Player Analysis (From the Players table)

18.Which players have the highest total goals scored (including assists)?*/

SELECT p.full_name, COUNT(g.goal_id) AS goal_count
FROM players p
JOIN goals g
ON p.player_id = g.pid
GROUP BY 1
ORDER BY goal_count DESC
LIMIT 1;


/* 18.Which players have the highest total goals scored (including assists)? */

SELECT p.full_name, SUM(s.goal_scored + s.goal_assist) AS total_goal
FROM( 
SELECT pid, COUNT(goal_id) AS goal_scored, COUNT(assit) AS goal_assist
FROM goals
WHERE pid IS NOT NULL
GROUP BY 1) AS s 
JOIN players AS p
ON s.pid = p.player_id
GROUP BY 1
ORDER BY total_goal DESC
LIMIT 1;
-- Robert Lewandowski --

/* 19.What is the average height and weight of players per position? */

SELECT 
	DISTINCT ON (position) position, 
	ROUND(AVG(height) ::numeric,2) AS avg_height,
	ROUND(AVG(weight) ::numeric,2) AS avg_weight
FROM players
GROUP BY 1

/* 20.Which player has the most goals scored with their left foot? */

SELECT p.full_name, p.foot, COUNT(g.goal_id) AS no_of_goals
FROM players AS p
JOIN goals AS g
ON p.player_id = g.pid
WHERE p.foot = 'L'
GROUP BY 1, 2
ORDER BY no_of_goals DESC
LIMIT 1;

/* 21.What is the average age of players per team? */

/* Here we are calculating the age of the players in years 
adding a age column*/

ALTER TABLE players ADD COLUMN age INT;
UPDATE players
SET age = DATE_PART('year',AGE(CURRENT_DATE, dob));


SELECT 	
	DISTINCT ON (team)team, 
	ROUND(AVG(age)::numeric, 2) AS avg_age_per_team
FROM players
GROUP BY 1;

/* 22.How many players are listed as playing for a each team in a season? */
/* USING DISTINCT HERE so that we avoid duplicate 
counting of the players in evey match in season.*/
SELECT m.season, p.team, COUNT(DISTINCT p.player_id) AS no_of_player
FROM matches AS m 
JOIN players AS p
ON p.team = m.home_team OR p.team = m.away_team
GROUP BY 1,2


/* 23.Which player has played in the most matches in the each season? */

SELECT DISTINCT ON (m.season) m.season, p.player_id,  p.first_name, p.last_name,  COUNT(m.match_id) AS matches_played
FROM players AS p
JOIN matches AS m
ON p.team = m.home_team OR p.team = m.away_team
GROUP BY 1,2,3,4
ORDER BY m.season, COUNT(m.match_id) DESC;

/* 24.What is the most common position for players across all teams? */
SELECT position, COUNT(position) AS frequency
FROM players
GROUP BY 1
ORDER BY frequency DESC
LIMIT 1;

/* 25.Which players have never scored a goal? */
SELECT p.player_id, p.first_name, p.last_name, g.pid
FROM players AS P
LEFT JOIN goals AS g
ON p.player_id = g.pid
WHERE g.pid IS NULL
LIMIT 1;

/* Team Analysis (From the Teams table)

26.Which team has the largest home stadium in terms of capacity?
*/
SELECT t.team_name, s.capacity
FROM teams as t
JOIN stadium as s
ON t.home_stadium = s.name
ORDER BY s.capacity DESC
LIMIT 1;

/* 27.Which teams from a each country participated 
in the UEFA competition in a season? */
SELECT DISTINCT m.season, t.country, t.team_name
FROM matches AS m
JOIN teams AS t
  ON m.home_team = t.team_name OR m.away_team = t.team_name
ORDER BY m.season, t.country, t.team_name;


/* 28.Which team scored the most goals across home and away matches in a given season?*/

/* 1. avg for home_team
   2. avh for away_team */
   
SELECT home_team, ROUND(AVG(home_team_score),3) AS avg_home_goal
FROM matches
WHERE season = '2021-2022'
GROUP BY 1
ORDER BY avg_home_goal DESC;

SELECT away_team, ROUND(AVG(away_team_score),3) AS avg_away_goal
FROM matches
WHERE season = '2021-2022'
GROUP BY 1
ORDER BY avg_away_goal DESC;

-- Combining the above two query
SELECT team, ROUND(AVG(goals),3) AS avg_goals
FROM (
SELECT home_team AS team, home_team_score AS goals
FROM matches
WHERE season = '2021-2022'

UNION ALL

SELECT away_team AS team, away_team_score AS goals
FROM matches
WHERE season = '2021-2022'
) AS total_avg_goals
GROUP BY 1
ORDER BY avg_goals DESC;


/* 29.How many teams have home stadiums in a each
city or country? */ 

SELECT s.country,s.city, COUNT(DISTINCT t.team_name) AS team_count
FROM teams as t
JOIN stadium as s
ON t.home_stadium = s.name
GROUP BY 1, 2
ORDER BY 1, team_count DESC;


/* 30.Which teams had the most home 
wins in the 2021-2022 season? */

SELECT home_team, COUNT(*) AS frequency
FROM matches
WHERE season = '2021-2022' AND home_team_score > away_team_score
GROUP BY 1
ORDER BY frequency DESC
LIMIT 1;

/* Machester City has highest home wins i.e. 5. */

/*
Stadium Analysis (From the Stadiums table)

31.Which stadium has the highest capacity?
*/

SELECT name, capacity
FROM stadium
ORDER BY capacity DESC
LIMIT 1;
/* ANSWER - SPOTIFY CAMP NOU */

/* 32.How many stadiums are located 
in a ‘Russia’ country or ‘London’ city? */

SELECT country, city, COUNT(name) AS total_count
FROM stadium
WHERE country = 'Russia' OR city = 'London'
GROUP BY 1,2;


/* 33.Which stadium hosted 
the most matches during a season? */

SELECT stadium, COUNT(stadium) AS frequency_of_match
FROM matches
GROUP BY 1
ORDER BY frequency_of_match DESC
LIMIT 3;

/* RESULT -- Etihad stadium = 29
Allianz Arean = 29 
*/

/* 34.What is the average stadium capacity for 
teams participating in a each season? */

SELECT m.season, 
	ROUND(AVG(s.capacity),2) AS avg_capaicty
FROM matches AS m
JOIN stadium AS s
ON m.stadium = s.name
GROUP BY 1
ORDER by 1

/* 35.How many teams play in stadiums with 
a capacity of more than 50,000? */
SELECT COUNT(t.team_name) AS total_teams
FROM teams AS t
JOIN stadium AS s
ON t.home_stadium = s.name
WHERE s.capacity > 50000;


/*  36.Which stadium had the highest 
attendance on average during a season? */
SELECT season, stadium, ROUND(AVG(attendance),2) AS avg_attendance
FROM matches
GROUP BY 1,2
ORDER BY avg_attendance DESC
LIMIT 1;
/* ANSWER = "Spotify Camp Nou" */ 

/* 37.What is the distribution of stadium capacities by country? */
SELECT country, 
	COUNT(*) AS total_stadium,
	MIN(capacity) AS min_capacity,
	MAX(capacity) AS max_capacity,
	ROUND(AVG(capacity),2) AS avg_capacity
FROM stadium
GROUP BY 1;

/* Cross-Table Analysis (Combining multiple tables)

38.Which players scored the most goals in matches held at a specific stadium?
*/

SELECT p.full_name,
	COUNT(g.goal_id) AS no_of_goals
FROM players AS p
JOIN goals AS g
ON p.player_id = g.pid
JOIN matches AS m
ON g.match_id = m.match_id
WHERE m.stadium = 'Spotify Camp Nou'
GROUP BY 1
ORDER BY no_of_goals DESC
LIMIT 1;

/* 39.Which team won the most home matches in 
the season 2021-2022 (based on match scores)? */
SELECT home_team, COUNT(home_team) AS frequency
FROM matches
WHERE season ='2021-2022' AND home_team_score > away_team_score
GROUP BY 1
ORDER BY frequency DESC
LIMIT 1;
/* ANSWER - Manchester City */ 


/* 40.Which players played for a team that scored 
the most goals in the 2021-2022 season? */ 

SELECT team, SUM(goals) AS total_score
FROM(
SELECT home_team AS team, home_team_score AS goals
FROM matches
WHERE season = '2021-2022'

UNION ALL

SELECT away_team AS team, away_team_score AS goals
FROM matches
WHERE season = '2021-2022'
) AS all_goals
GROUP BY 1
ORDER BY total_score DESC
LIMIT 1;


 /* 41.How many goals were scored by home teams in 
 matches where the attendance was above 50,000? */
 SELECT home_team, SUM(home_team_score) AS total_goals
 FROM matches
 WHERE attendance > 50000
 GROUP BY 1
 ORDER BY total_goals DESC;


/* 42.Which players played in matches where the score 
difference(home team score - away team score) 
was the highest? */ 

SELECT p.player_id, p.full_name, MAX(dif.difference) AS max_diff
FROM(
SELECT match_id,home_team, away_team,(home_team_score - away_team_score) AS difference
FROM matches
) AS dif
JOIN players AS p
ON p.team = dif.home_team OR p.team = dif.away_team
GROUP BY 1,2
ORDER BY max_diff DESC;

SELECT * FROM matches
SELECT * FROM players
SELECT DISTINCT m.match_id, p.full_name, ABS(m.home_team_score-m.away_team_score) AS difference
FROM players as p
JOIN matches as m
ON p.team = m.home_team OR p.team = m.away_team
WHERE ABS(m.home_team_score-m.away_team_score) = (
  SELECT MAX(ABS(home_team_score - away_team_score)) 
  FROM matches
)
ORDER BY difference DESC
SELECT * FROM matches
/* 43.How many goals did players score 
in matches that ended in penalty shootouts? */
SELECT 
  COUNT(*) AS total_goals
FROM goals g
JOIN matches m ON g.match_id = m.match_id
WHERE m.peanlty_shoot_out = 1;
/* Output is 0 because in dataset penalty column has 0 values*/

/* 44.What is the distribution of home team wins vs 
away team wins by country for all seasons? */
SELECT 
  country,
  SUM(home_win) AS home_wins,
  SUM(away_win) AS away_wins
FROM (

  SELECT 
    t.country,
    1 AS home_win,
    0 AS away_win
  FROM matches m
  JOIN teams t ON m.home_team = t.team_name
  WHERE m.home_team_score > m.away_team_score

  UNION ALL

  SELECT 
    t.country,
    0 AS home_win,
    1 AS away_win
  FROM matches m
  JOIN teams t ON m.away_team = t.team_name
  WHERE m.away_team_score > m.home_team_score
) AS combined
GROUP BY country
ORDER BY country;

/* 45.Which team scored the most goals in 
the highest-attended matches? */ 

SELECT
  home_team AS team,
  SUM(home_team_score) AS goals
FROM matches
WHERE attendance = (SELECT MAX(attendance) FROM matches)
GROUP BY home_team

UNION ALL

SELECT
  away_team AS team,
  SUM(away_team_score) AS goals
FROM matches
WHERE attendance = (SELECT MAX(attendance) FROM matches)
GROUP BY away_team

ORDER BY goals DESC
LIMIT 1;


/* 46.Which players assisted the most goals in matches where their team lost(you can include 3)? */
SELECT sub.assist_player_id, p.full_name,p.team, 
SUM(sub.goal_assist) AS total_assists
FROM(
SELECT m.match_id, g.assit AS assist_player_id, 
COUNT(g.assit) AS goal_assist
FROM matches m
JOIN goals g
ON m.match_id = g.match_id
WHERE home_team_score < away_team_score OR away_team_score < home_team_score
GROUP BY 1,2) AS sub
JOIN players p 
ON sub.assist_player_id = p.player_id
GROUP BY 1,2,3
ORDER BY total_assists DESC
LIMIT 3;

/* 47.What is the total number of goals scored by players who are positioned as defenders? */
SELECT p.full_name AS defender_players, COUNT(g.goal_id) AS total_goals
FROM players AS p
JOIN goals AS g
ON p.player_id = g.pid
WHERE p.position = 'Defender'
GROUP BY 1
ORDER BY 2 DESC;

/* 48.Which players scored goals in matches that were 
held in stadiums with a capacity over 60,000? */
SELECT p.player_id, p.full_name, g.match_id
FROM(
	SELECT m.match_id
	FROM matches AS m
	JOIN stadium AS s
	ON m.stadium = s.name
	WHERE s.capacity > 60000
)AS sub
JOIN goals AS g ON sub.match_id = g.match_id
JOIN players AS p ON p.player_id = g.pid;

 /* 49.How many goals were scored in matches played in cities 
 with specific stadiums in a season? */

SELECT s.city, m.stadium, m.season, COUNT(g.goal_id) AS total_goals
FROM(
	SELECT season, match_id, stadium
	FROM matches 
) AS m
JOIN goals AS g ON m.match_id = g.match_id
JOIN stadium AS s ON m.stadium = s.name
GROUP BY s.city, m.stadium, m.season;

/* 50.Which players scored goals in matches with the highest attendance (over 100,000)? */

SELECT *
FROM matches
WHERE attendance > 100000 

/* I tried this condition to check where did i miss 
found out that no match is played where 
attendance is more than 100000.*/ 

SELECT * FROM matches

/* Additional Complex Queries (Combining multiple aspects)*/


/* 51.What is the average number of goals scored by each team in the 
first 30 minutes of a match? */
SELECT sub.team, 
	ROUND(AVG(goal_count),2) AS avg_goal_count_30_min
FROM(
	SELECT p.team, g.match_id, 
	COUNT(g.goal_id)AS goal_count
	FROM goals AS g
	JOIN players AS p
	ON g.pid = p.player_id
	WHERE g.duration < 30
	GROUP BY 1,2
) AS sub
GROUP BY 1

/* 52.Which stadium had the highest average score 
difference between home and away teams? */
SELECT stadium,
       ROUND(AVG(home_team_score - away_team_score), 2) AS avg_score_diff
FROM matches
GROUP BY stadium
ORDER BY avg_score_diff DESC
LIMIT 1;
-- Allianz Areana

/* 53.How many players scored in every match they played during a given season? */
SELECT COUNT(*) AS players_scored_in_every_match
FROM (
  SELECT g.pid, m.season,
         COUNT(DISTINCT g.match_id) AS matches_scored_in,
         (
           SELECT COUNT(DISTINCT g2.match_id)
           FROM goals g2
           JOIN matches m2 ON g2.match_id = m2.match_id
           WHERE g2.pid = g.pid AND m2.season = m.season
         ) AS total_matches
  FROM goals g
  JOIN matches m ON g.match_id = m.match_id
  GROUP BY g.pid, m.season
  HAVING COUNT(DISTINCT g.match_id) = (
    SELECT COUNT(DISTINCT g2.match_id)
    FROM goals g2
    JOIN matches m2 ON g2.match_id = m2.match_id
    WHERE g2.pid = g.pid AND m2.season = m.season
  )
) AS result;


/* 54.Which teams won the most matches with a 
goal difference of 3 or more in the 2021-2022 season?*/
SELECT winner_team, COUNT(*) AS wins_with_diff_3
FROM(
SELECT 
       CASE
            WHEN home_team_score - away_team_score >= 3 THEN home_team
            WHEN away_team_score - home_team_score >= 3 THEN away_team
            ELSE NULL
        END AS winner_team
		FROM matches
		WHERE season = '2021-2022'
		AND (home_team_score - away_team_score) >=3
) AS sub
WHERE winner_team IS NOT NULL
GROUP BY winner_team
ORDER BY wins_with_diff_3 DESC;


/* 55.Which player from a specific country 
has the highest goals per match ratio? */ 
SELECT
  p.player_id,
  p.full_name,
  COUNT(DISTINCT g.match_id) AS matches_played,
  COUNT(g.goal_id) AS total_goals,
  ROUND(COUNT(g.goal_id)::decimal / NULLIF(COUNT(DISTINCT g.match_id), 0), 2) AS goals_per_match_ratio
FROM players p
JOIN goals g ON p.player_id = g.pid
WHERE p.nationality = 'France'
GROUP BY p.player_id, p.full_name
ORDER BY goals_per_match_ratio DESC
LIMIT 1;