-- 1. Show the lastName, party and votes for the constituency 'S14000024' in 2017.
SELECT lastName, party, votes
FROM ge
WHERE constituency = 'S14000024' AND yr = 2017
ORDER BY votes DESC;

-- 2. Show the party and RANK for constituency S14000024 in 2017.
-- List the output by party
SELECT party, votes, RANK() OVER (ORDER BY votes DESC) as posn
FROM ge
WHERE constituency = 'S14000024' AND yr = 2017
ORDER BY party;

-- 4. Use PARTITION BY constituency to show the ranking of
-- each party in Edinburgh in 2017. Order your results so
-- the winners are shown first, then ordered by constituency.
SELECT constituency, party, votes,
       RANK() OVER (PARTITION BY constituency ORDER BY votes DESC) as posn
FROM ge
WHERE constituency BETWEEN 'S14000021' AND 'S14000026'
      AND yr  = 2017
ORDER BY posn, constituency;

-- 5. You can use SELECT within SELECT to pick out only the
-- winners in Edinburgh. Show the parties that won for each
-- Edinburgh constituency in 2017.
SELECT constituency, party
FROM (
  SELECT constituency, party, votes,
         MAX(votes) OVER (PARTITION BY constituency) AS maxVote
  FROM ge
  WHERE constituency BETWEEN 'S14000021' AND 'S14000026' AND yr = 2017
) foo
WHERE votes = maxVote;

-- 6. Show how many seats for each party in Scotland in 2017.
SELECT party, COUNT(*)
FROM (
  SELECT constituency, party,
         RANK() OVER (PARTITION BY constituency ORDER BY votes DESC) AS posn
  FROM ge
  WHERE constituency LIKE 'S%' AND yr = 2017
) foo
WHERE posn = 1
GROUP BY party;
