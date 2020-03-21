-- Join two tables; game and goals:

-- 1 Show the matchid and player name for all goals scored by Germany. 

SELECT matchid, player FROM goal 
  WHERE teamid = 'GER';
  
-- 2 Show id, stadium, team1, team2 for just game 1012

SELECT id, stadium, team1, team2
  FROM game
 WHERE id = 1012;

-- 3 Show the player, teamid, stadium and mdate for every German goal.

SELECT goal.player, goal.teamid, game.stadium, game.mdate
  FROM game JOIN goal ON (game.id=goal.matchid)
WHERE goal.teamid = 'GER';

-- 4 Show the team1, team2 and player for every goal scored by a player called Mario

SELECT m.team1, m.team2, g.player
  FROM game as m JOIN goal AS g ON (m.id=g.matchid)
WHERE player LIKE 'Mario%';

-- 5 Show player, teamid, coach, gtime for all goals scored in the first 10 minutes

SELECT g.player, g.teamid, t.coach, g.gtime
  FROM goal AS g JOIN eteam AS t
    ON g.teamid = t.id
 WHERE gtime<=10;

-- 6 List the the dates of the matches and the name of the team in which 'Fernando Santos' was the
--   team1 coach.

SELECT m.mdate, t.teamname
  FROM game AS m JOIN eteam AS t
    ON m.team1 = t.id
 WHERE t.coach = 'Fernando Santos';

-- 7 List the player for every goal scored in a game where the stadium was 'National Stadium, Warsaw'

SELECT g.player
  FROM goal AS g JOIN game AS m
    ON m.id = g.matchid
 WHERE m.stadium = 'National Stadium, Warsaw';

-- 8 Instead show the name of all players who scored a goal against Germany.

SELECT DISTINCT g.player
  FROM game AS m JOIN goal AS g
   ON g.matchid = m.id 
 WHERE (m.team1='GER' OR m.team2='GER')
  AND g.teamid != 'GER'; 

-- 9 Show teamname and the total number of goals scored.

SELECT t.teamname, COUNT(g.gtime) 
  FROM eteam AS t JOIN goal AS g
   ON t.id=g.teamid
 GROUP BY t.teamname
 ORDER BY t.teamname;

-- 10 Show the stadium and the number of goals scored in each stadium.

SELECT m.stadium, COUNT(g.gtime) 
  FROM game AS m JOIN goal AS g
   ON m.id=g.matchid
 GROUP BY m.stadium
 ORDER BY m.stadium;

-- 11 For every match involving 'POL', show the matchid, date and the number of goals scored.

SELECT g.matchid, m.mdate, COUNT(g.gtime)
  FROM game AS m JOIN goal AS g ON g.matchid = m.id 
 WHERE (team1 = 'POL' OR team2 = 'POL')
GROUP BY m.id;

-- 12 For every match where 'GER' scored, show matchid, match date and the number of goals scored
--    by 'GER'

SELECT g.matchid, m.mdate, COUNT(g.gtime)
  FROM game AS m JOIN goal AS g ON g.matchid = m.id 
 WHERE teamid = 'GER'
GROUP BY m.id;

-- 13 List every match with the goals scored by each team as shown. USE CASE WHEN

SELECT m.mdate,
  m.team1,
  SUM(CASE WHEN g.teamid=m.team1 THEN 1 ELSE 0 END) AS score1,
  m.team2,
  SUM(CASE WHEN g.teamid=m.team2 THEN 1 ELSE 0 END) AS score2
 FROM game AS m LEFT JOIN goal AS g ON g.matchid = m.id
 GROUP BY m.id
 ORDER BY mdate, matchid, team1, team2;
