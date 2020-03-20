-- Examine UK general election results

-- 1 Show the lastName, party and votes for the constituency 'S14000024' in 2017.

SELECT lastName, party, votes
  FROM ge
 WHERE constituency = 'S14000024' AND yr = 2017
ORDER BY votes DESC;

-- 2 Show the party and RANK for constituency S14000024 in 2017. List the output by party

SELECT party, votes,
       RANK() OVER (ORDER BY votes DESC) as posn
  FROM ge
 WHERE constituency = 'S14000024' AND yr = 2017
ORDER BY party;

-- 3 Use PARTITION to show the ranking of each party in S14000021 in each year. Include yr, party,
-- votes and ranking (the party with the most votes is 1).

SELECT yr,party, votes,
      RANK() OVER (PARTITION BY yr ORDER BY votes DESC) as posn
  FROM ge
 WHERE constituency = 'S14000021'
ORDER BY party,yr;

-- 4 Use PARTITION BY constituency to show the ranking of each party in Edinburgh in 2017. Order
-- your results so the winners are shown first, then ordered by constituency.

SELECT constituency,party, votes, RANK() OVER (PARTITION BY constituency ORDER BY votes DESC) AS pos
  FROM ge
 WHERE constituency BETWEEN 'S14000021' AND 'S14000026'
   AND yr  = 2017
ORDER BY pos, constituency;

-- 5 Show the parties that won for each Edinburgh constituency in 2017.

SELECT constituency, party
  FROM (
     SELECT constituency, party, votes, 
         RANK() OVER (PARTITION BY constituency ORDER BY votes DESC) AS pos
       FROM ge
      WHERE constituency BETWEEN 'S14000021' AND 'S14000026'
       AND yr  = 2017
      ) AS postion_table
 WHERE pos = 1
ORDER BY constituency,votes DESC;

-- 6 Show how many seats for each party in Scotland in 2017.

SELECT party, COUNT(party)
  FROM (
     SELECT constituency, party, votes, 
         RANK() OVER (PARTITION BY constituency ORDER BY votes DESC) AS pos
       FROM ge
      WHERE constituency LIKE 'S%'
       AND yr  = 2017
      ) AS postion_table
 WHERE pos = 1
GROUP BY party
ORDER BY party;
