-- 1. How many stops are in the database.
SELECT COUNT(*)
FROM stops;

-- 2. Find the id value for the stop 'Craiglockhart'
SELECT id
FROM stops
WHERE name = 'Craiglockhart';

-- 3. Give the id and the name for the stops on the '4' 'LRT' service.
SELECT stops.id, stops.name
FROM stops
JOIN route
ON stops.id = route.stop
WHERE num = '4' AND company = 'LRT';

-- 4. The query shown gives the number of routes that visit
-- either London Road (149) or Craiglockhart (53). Run the
-- query and notice the two services that link these stops
-- have a count of 2. Add a HAVING clause to restrict the
-- output to these two routes.
SELECT company, num, COUNT(*)
FROM route
WHERE stop = 149 OR stop = 53
GROUP BY company, num
HAVING COUNT(*) = 1;

-- 5. Execute the self join shown and observe that b.stop
-- gives all the places you can get to from Craiglockhart,
-- without changing routes. Change the query so that it
-- shows the services from Craiglockhart to London Road.
SELECT a.company, a.num, a.stop, b.stop
FROM route a
JOIN route b
ON (a.company = b.company AND a.num = b.num)
WHERE a.stop = 53 AND b.stop = 149;

-- 6. The query shown is similar to the previous one,
-- however by joining two copies of the stops table we
-- can refer to stops by name rather than by number.
-- Change the query so that the services between
-- 'Craiglockhart' and 'London Road' are shown.
SELECT a.company, a.num, stopA.name, stopB.name
FROM route a
JOIN route b
ON (a.company = b.company AND a.num = b.num)
JOIN stops stopA ON (a.stop = stopA.id)
JOIN stops stopB ON (b.stop = stopB.id)
WHERE stopA.name = 'Craiglockhart' AND stopB.name = 'London Road';

-- 7. Give a list of all the services which connect stops 115 and 137
SELECT DISTINCT a.company, a.num
FROM route a
JOIN route b
ON (a.num = b.num AND a.company = b.company)
WHERE a.stop = 115 AND b.stop = 137;

-- 8. Give a list of the services which connect the stops
-- 'Craiglockhart' and 'Tollcross'
SELECT DISTINCT a.company, a.num
FROM route a
JOIN route b
ON (a.num = b.num AND a.company = b.company)
JOIN stops stopA ON (a.stop=stopA.id)
JOIN stops stopB ON (b.stop=stopB.id)
WHERE stopA.name = 'Craiglockhart' AND stopB.name = 'Tollcross';

-- 9. Give a distinct list of the stops which may be reached
-- from 'Craiglockhart' by taking one bus, including
-- 'Craiglockhart' itself, offered by the LRT company.
-- Include the company and bus no. of the relevant services.
SELECT dest.name, a.company, a.num
FROM route a
JOIN route b
ON (a.num = b.num AND a.company = b.company)
JOIN stops start ON (a.stop = start.id)
JOIN stops dest ON (b.stop = dest.id)
WHERE start.name = 'Craiglockhart' AND a.company = 'LRT';

-- 10. Find the routes involving two buses that can go
-- from Craiglockhart to Lochend. Show the bus no. and
-- company for the first bus, the name of the stop for
-- the transfer, and the bus no. and company for the second bus.
SELECT a.num, a.company, stopB.name, c.num, c.company
FROM route a
JOIN route b
ON (a.num = b.num AND a.company = b.company)
JOIN (route c JOIN route d
ON (c.num = d.num AND c.company = d.company))
JOIN stops stopA
ON (a.stop = stopA.id)
JOIN stops stopB
ON (b.stop = stopB.id)
JOIN stops stopC
ON (c.stop = stopC.id)
JOIN stops stopD
ON (d.stop = stopD.id)
WHERE stopA.name = 'Craiglockhart'
      AND stopD.name = 'Lochend'
      AND stopB.id = stopC.id
ORDER BY a.num, stopB.name, c.num;
