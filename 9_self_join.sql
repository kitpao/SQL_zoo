-- Join Edinburgh bus routes to Edinburgh bus routes.

-- 1 How many stops are in the database.

SELECT COUNT(s.id)
 FROM stops AS s;

-- 2 Find the id value for the stop 'Craiglockhart'

SELECT id
  FROM stops
 WHERE name = 'Craiglockhart';

-- 3 Give the id and the name for the stops on the '4' 'LRT' service.

SELECT DISTINCT s.id, s.name
  FROM stops AS s JOIN route AS r
   ON s.id = r.stop
 WHERE r.company = 'LRT'
  AND r.num = '4';

-- 4 Show the services that pass through both London Road (149) and Craiglockhart (53).

SELECT company, num, COUNT(*)
FROM route WHERE stop=149 OR stop=53
GROUP BY company, num
HAVING COUNT(*)= 2

-- 5 Show the services from Craiglockhart 53 to London Road 149.

SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
WHERE a.stop=53
 AND b.stop=149;

-- 6 Show the services between 'Craiglockhart' and 'London Road' by names rather than id

SELECT a.company, a.num, stopa.name, stopb.name
FROM route a JOIN route b ON
  (a.company=b.company AND a.num=b.num)
  JOIN stops stopa ON (a.stop=stopa.id)
  JOIN stops stopb ON (b.stop=stopb.id)
WHERE stopa.name='Craiglockhart'
 AND stopb.name = 'London Road';

-- 7 Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')

SELECT a.company, a.num
  FROM route AS a JOIN route AS b ON
   (a.company=b.company AND a.num=b.num)
 WHERE a.stop = 115
  AND b.stop = 137
GROUP BY a.num;

-- 8 Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'

SELECT a.company, a.num
  FROM route AS a JOIN route AS b ON
   (a.company=b.company AND a.num=b.num)
    JOIN stops AS stopa ON (a.stop = stopa.id)
    JOIN stops AS stopb ON (b.stop = stopb.id)
 WHERE stopa.name = 'Craiglockhart'
  AND stopb.name = 'Tollcross'
GROUP BY a.num;

-- 9 Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one
--   bus, including 'Craiglockhart' itself, offered by the LRT company. Include the company and
--   bus no. of the relevant services.

SELECT stopb.name, a.company, a.num
  FROM route AS a JOIN route AS b ON
   (a.company=b.company AND a.num=b.num)
    JOIN stops AS stopa ON (a.stop = stopa.id)
    JOIN stops AS stopb ON (b.stop = stopb.id)
 WHERE stopa.name = 'Craiglockhart';

-- 10 Find the routes involving two buses that can go from Craiglockhart to Lochend.
--    Show the bus no. and company for the first bus, the name of the stop for the transfer,
--    and the bus no. and company for the second bus.

SELECT first.num, first.company, first.name, second.num, second.company
  FROM (SELECT a.company, a.num, stopb.id AS intermediate, stopb.name
             FROM route AS a JOIN route AS b ON
                (a.company=b.company AND a.num=b.num)
              JOIN stops AS stopa ON (a.stop = stopa.id)
              JOIN stops AS stopb ON (b.stop = stopb.id)
            WHERE stopa.name = 'Craiglockhart') AS first
  JOIN (SELECT c.company, c.num, c.stop AS intermediate
             FROM route AS c JOIN route AS d ON
               (c.company=d.company AND c.num=d.num)
              JOIN stops AS stopd ON (d.stop = stopd.id)
            WHERE stopd.name = 'Lochend') AS second
   ON (first.intermediate = second.intermediate)
ORDER BY first.num, first.name, second.num;
