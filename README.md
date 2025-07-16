# UEFA-PostgreSQL

UEFA Overview
The Union of European Football Associations (UEFA) is the administrative and controlling body for European football. Founded on June 15, 1954, in Basel, Switzerland, UEFA is one of the six continental confederations of world football's governing body FIFA. It consists of 55 member associations, each representing a country in Europe. UEFA organizes and oversees some of the most prestigious football competitions globally, including:
●UEFA Champions League: An annual club football competition contested by top-division European clubs.
●UEFA Europa League: A secondary club competition for European teams.
●UEFA European Championship: Also known as the Euros, it is a tournament for national teams in Europe.
●UEFA Nations League: A competition involving the men's national teams of the member associations of UEFA.
UEFA's responsibilities include regulating rules of the game, organizing international competitions, and promoting football development and fair play.
Dataset Overview
The dataset provided consists of five CSV files: Goals, Matches, Players, Stadiums, and Teams. These files contain comprehensive data on various aspects of UEFA competitions, enabling detailed analysis and insights into football dynamics. The project focuses on analyzing these datasets using SQL to answer specific questions about teams, players, goals, matches, and stadiums.










Data Dictionary 
Goals.csv
 Column Name 	 Data Type 	 Description                                      
 GOAL_ID     	 String    	 Unique identifier for each goal                  
 MATCH_ID    	 String    	 Identifier for the match in which the goal was scored 
 PID         	 String    	 Identifier for the player who scored the goal    
 DURATION    	 Integer   	 Minute in the match when the goal was scored     
 ASSIST      	 String    	 Identifier for the player who assisted the goal  
 GOAL_DESC   	 String    	 Description of how the goal was scored (e.g., right-footed shot, penalty) 










Matches.csv
Column Name	Data Type	Description
MATCH_ID	String	Unique identifier for each match
SEASON	String	The season during which the match took place (e.g., "2021-2022")
DATE	String	The date when the match was played (in DD-MM-YYYY format)
HOME_TEAM	String	The name of the home team
AWAY_TEAM	String	The name of the away team
STADIUM	String	The name of the stadium where the match was played
HOME_TEAM_SCORE	Integer	The score of the home team
AWAY_TEAM_SCORE	Integer	The score of the away team
PENALTY_SHOOT_OUT	Integer	Indicator of whether there was a penalty shootout (1 = Yes, 0 = No)
ATTENDANCE	Integer	The number of spectators attending the match
Players.csv
Column Name	Data Type	Description
PLAYER_ID	String	Unique identifier for each player
FIRST_NAME	String	First name of the player
LAST_NAME	String	Last name of the player
NATIONALITY	String	Nationality of the player
DOB	Date	Date of birth of the player (in YYYY-MM-DD format)
TEAM	String	Team that the player is currently playing for
JERSEY_NUMBER	Float	Jersey number of the player
POSITION	String	Playing position of the player (e.g., Defender, Midfielder)
HEIGHT	Float	Height of the player (in centimeters)
WEIGHT	Float	Weight of the player (in kilograms)
FOOT	String	Preferred foot of the player (R = Right, L = Left)
Teams.csv
Column Name	Data Type	Description
TEAM_NAME	String	Name of the team
COUNTRY	String	Country where the team is based
HOME_STADIUM	String	Name of the team's home stadium
Stadium.csv
column Name	Data Type	Description
Name 	String	Name of the stadium
City	String 	Name of the City
Country 	String	Name of the Country 
Capacity	Int	Capacity of the stadium
Tasks - 
Load up the 5 Tables in your Postgresql and try to solve the questions mentioned below. The link containing the CSV file of the tables is attached below. 
https://drive.google.com/drive/folders/1wo-LFBqkH-6MmwxTMoefVKv1HrLIL3Xi?usp=sharing


Goal Analysis (From the Goals table)
1.Which player scored the most goals in a each season?
2.How many goals did each player score in a given season?
3.What is the total number of goals scored in ‘mt403’ match?
4.Which player assisted the most goals in a each season?
5.Which players have scored goals in more than 10 matches?
6.What is the average number of goals scored per match in a given season?
7.Which player has the most goals in a single match?
8.Which team scored the most goals in the all seasons?
9.Which stadium hosted the most goals scored in a single season?


Match Analysis (From the Matches table)
10.What was the highest-scoring match in a particular season?
11.How many matches ended in a draw in a given season?
12.Which team had the highest average score (home and away) in the season 2021-2022?
13.How many penalty shootouts occurred in a each season?
14.What is the average attendance for home teams in the 2021-2022 season?
15.Which stadium hosted the most matches in a each season?
16.What is the distribution of matches played in different countries in a season?
17.What was the most common result in matches (home win, away win, draw)?


Player Analysis (From the Players table)
18.Which players have the highest total goals scored (including assists)?
19.What is the average height and weight of players per position?
20.Which player has the most goals scored with their left foot?
21.What is the average age of players per team?
22.How many players are listed as playing for a each team in a season?
23.Which player has played in the most matches in the each season?
24.What is the most common position for players across all teams?
25.Which players have never scored a goal?


Team Analysis (From the Teams table)
26.Which team has the largest home stadium in terms of capacity?
27.Which teams from a each country participated in the UEFA competition in a season?
28.Which team scored the most goals across home and away matches in a given season?
29.How many teams have home stadiums in a each city or country?
30.Which teams had the most home wins in the 2021-2022 season?
Stadium Analysis (From the Stadiums table)
31.Which stadium has the highest capacity?
32.How many stadiums are located in a ‘Russia’ country or ‘London’ city?
33.Which stadium hosted the most matches during a season?
34.What is the average stadium capacity for teams participating in a each season?
35.How many teams play in stadiums with a capacity of more than 50,000?
36.Which stadium had the highest attendance on average during a season?
37.What is the distribution of stadium capacities by country?


Cross-Table Analysis (Combining multiple tables)
38.Which players scored the most goals in matches held at a specific stadium?
39.Which team won the most home matches in the season 2021-2022 (based on match scores)?
40.Which players played for a team that scored the most goals in the 2021-2022 season?
41.How many goals were scored by home teams in matches where the attendance was above 50,000?
42.Which players played in matches where the score difference (home team score - away team score) was the highest?
43.How many goals did players score in matches that ended in penalty shootouts?
44.What is the distribution of home team wins vs away team wins by country for all seasons?
45.Which team scored the most goals in the highest-attended matches?
46.Which players assisted the most goals in matches where their team lost(you can include 3)?
47.What is the total number of goals scored by players who are positioned as defenders?
48.Which players scored goals in matches that were held in stadiums with a capacity over 60,000?
49.How many goals were scored in matches played in cities with specific stadiums in a season?
50.Which players scored goals in matches with the highest attendance (over 100,000)?


Additional Complex Queries (Combining multiple aspects)
51.What is the average number of goals scored by each team in the first 30 minutes of a match?
52.Which stadium had the highest average score difference between home and away teams?
53.How many players scored in every match they played during a given season?
54.Which teams won the most matches with a goal difference of 3 or more in the 2021-2022 season?
55.Which player from a specific country has the highest goals per match ratio?
