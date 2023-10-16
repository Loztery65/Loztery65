

WITH
z AS (SELECT n.region, a.games, a.sport, a.medal
FROM athlete_events AS a INNER JOIN noc AS n USING(noc)),
y AS (SELECT * FROM z WHERE region = 'Indonesia'),
x AS (SELECT *, COUNT(medal) AS medals FROM y WHERE medal<>'NA' GROUP BY 1,2,3,4)
SELECT region, games, sport, SUM(medals) AS tot_medals
FROM x GROUP BY 1,2,3 ORDER BY 2;


SELECT n.region, a.sport, COUNT(*) AS tot_medals
FROM athlete_events AS a INNER JOIN noc AS n USING(noc)
WHERE medal <> 'NA' AND region = 'Indonesia'
GROUP BY 1,2 ORDER BY 3 DESC;


WITH
z AS (SELECT n.noc, a.games, n.region, a.medal FROM athlete_events AS a INNER JOIN noc AS n USING(noc)),
y AS (SELECT z.region, SUM(case when z.medal IN ('Gold','Silver','Bronze') then 1 ELSE 0 END) AS medals,
SUM(case when z.medal = 'Gold' then 1 ELSE 0 END) AS Gold, SUM(case when z.medal = 'Silver' then 1 ELSE 0 END) AS Silver,
SUM(case when z.medal = 'Bronze' then 1 ELSE 0 END) AS Bronze
FROM z GROUP BY 1)
SELECT * 
FROM Y WHERE Gold = 0 ORDER BY 3 ASC, 4 DESC;



WITH
z AS (SELECT n.noc, a.games, n.region, a.medal FROM athlete_events AS a INNER JOIN noc AS n USING(noc)),
y AS (SELECT z.region, z.games, SUM(case when z.medal IN ('Gold','Silver','Bronze') then 1 ELSE 0 END) AS medals,
SUM(case when z.medal = 'Gold' then 1 ELSE 0 END) AS Gold, SUM(case when z.medal = 'Silver' then 1 ELSE 0 END) AS Silver,
SUM(case when z.medal = 'Bronze' then 1 ELSE 0 END) AS Bronze
FROM z GROUP BY 1,2),
x AS (SELECT DISTINCT games, 
FIRST_VALUE(region) OVER(PARTITION BY games ORDER BY Gold DESC) AS  Country_Gold,
FIRST_VALUE(Gold) OVER(PARTITION BY games ORDER BY Gold DESC) AS Max_Gold,
FIRST_VALUE(region) OVER(PARTITION BY games ORDER BY Silver DESC) AS Country_Silver,
FIRST_VALUE(Silver) OVER(PARTITION BY games ORDER BY Silver DESC) AS Max_Silver,
FIRST_VALUE(region) OVER(PARTITION BY games ORDER BY Bronze DESC) AS Country_Bronze,
FIRST_VALUE(Bronze) OVER(PARTITION BY games ORDER BY Bronze DESC) AS Max_Bronze,
FIRST_VALUE(region) OVER(PARTITION BY games ORDER BY medals DESC) AS Country_medals,
FIRST_VALUE(medals) OVER(PARTITION BY games ORDER BY medals DESC) AS tot_medals
FROM y ORDER BY 1)
SELECT games,  CONCAT(Country_Gold, '-', Max_Gold) AS Golds, CONCAT(Country_Silver, '-', Max_Silver) AS Silvers,
CONCAT(Country_Bronze, '-', Max_Bronze) AS Bronzes, CONCAT(Country_medals, '-', tot_medals) AS Max_medals
FROM x;




WITH
z AS (SELECT a.games AS games, c.region AS country, COUNT(a.medal) AS tot_Gold_medals, 
DENSE_RANK() OVER(ORDER BY COUNT(a.medal) DESC) AS rank
FROM athlete_events AS a INNER JOIN noc AS c USING(noc)
WHERE a.medal = 'Gold'
GROUP BY c.region, a.games
ORDER BY RANK),
y AS (SELECT a.games AS games, c.region AS country, COUNT(a.medal) AS tot_Silver_medals, 
DENSE_RANK() OVER(ORDER BY COUNT(a.medal) DESC) AS rank
FROM athlete_events AS a INNER JOIN noc AS c USING(noc)
WHERE a.medal = 'Silver'
GROUP BY c.region, a.games
ORDER BY RANK),
x AS (SELECT a.games AS games, c.region AS country, COUNT(a.medal) AS tot_Bronze_medals, 
DENSE_RANK() OVER(ORDER BY COUNT(a.medal) DESC) AS rank
FROM athlete_events AS a INNER JOIN noc AS c USING(noc)
WHERE a.medal = 'Bronze'
GROUP BY c.region, a.games
ORDER BY RANK)
SELECT z.games, z.country, z.tot_Gold_medals, y.tot_Silver_medals, x.tot_Bronze_medals
FROM z INNER JOIN y USING(country) INNER JOIN x USING(country)
GROUP BY games, country
ORDER BY games, tot_gold_medals desc;



WITH
z AS (SELECT c.region AS country, COUNT(a.medal) AS tot_Gold_medals, DENSE_RANK() OVER(ORDER BY COUNT(a.medal) DESC) AS rank
FROM athlete_events AS a INNER JOIN noc AS c USING(noc)
WHERE a.medal = 'Gold'
GROUP BY c.region
ORDER BY RANK),
y AS (SELECT c.region AS country, COUNT(a.medal) AS tot_Silver_medals, DENSE_RANK() OVER(ORDER BY COUNT(a.medal) DESC) AS rank
FROM athlete_events AS a INNER JOIN noc AS c USING(noc)
WHERE a.medal = 'Silver'
GROUP BY c.region
ORDER BY RANK),
x AS (SELECT c.region AS country, COUNT(a.medal) AS tot_Bronze_medals, DENSE_RANK() OVER(ORDER BY COUNT(a.medal) DESC) AS rank
FROM athlete_events AS a INNER JOIN noc AS c USING(noc)
WHERE a.medal = 'Bronze'
GROUP BY c.region
ORDER BY RANK)
SELECT z.country, z.tot_Gold_medals, y.tot_Silver_medals, x.tot_Bronze_medals
FROM z INNER JOIN y USING(country) INNER JOIN x USING(country) ORDER BY z.tot_Gold_medals DESC;



WITH
z AS (SELECT c.region, COUNT(a.medal) AS tot_medals, DENSE_RANK() OVER(ORDER BY COUNT(a.medal) DESC) AS rank
FROM athlete_events AS a INNER JOIN noc AS c USING(noc)
WHERE a.medal != 'NA'
GROUP BY c.region
ORDER BY rank)
SELECT * FROM z
;



WITH
z AS (SELECT NAME, team, COUNT(medal) AS tot_medal, 
DENSE_RANK() OVER(ORDER BY COUNT(medal) DESC) AS ranking FROM athlete_events WHERE medal != 'NA' GROUP BY  NAME, team
ORDER BY ranking),
y AS (SELECT * FROM z WHERE ranking <= 5)
SELECT * FROM y;



WITH
z AS (SELECT NAME, team, COUNT(medal) AS tot_medal, 
DENSE_RANK() OVER(ORDER BY COUNT(medal) DESC) AS ranking FROM athlete_events WHERE medal = 'Gold' GROUP BY  NAME, team
ORDER BY ranking),
y AS (SELECT * FROM z WHERE ranking <= 5)
SELECT * FROM y;



WITH 
z AS (SELECT sex, COUNT(1) AS cnt FROM athlete_events GROUP BY sex),
y AS (select *, row_number() over(order by cnt) as rn from z),
MIN AS (SELECT cnt FROM y WHERE rn = 1),
max AS (SELECT cnt FROM y WHERE rn = 2)
SELECT CONCAT(ROUND(MIN.cnt/MIN.cnt), ":", ROUND(max.cnt/MIN.cnt,2)) as ratio 
from MIN, max;


WITH
z AS (SELECT DISTINCT a.name, a.sex, (case when age = 'NA' then '0' else age end) ages,
a.team, a.games, a.city, a.sport, a.`event`, a.medal
FROM athlete_events AS a WHERE a.medal = 'Gold' ),
y AS (SELECT *, DENSE_RANK() OVER(ORDER BY ages DESC) AS rank FROM z)
SELECT name, sex, ages, team, games, city, sport, event, medal from Y
WHERE RANK = 1;



WITH
w AS (SELECT DISTINCT  games, sport FROM athlete_events),
y AS (SELECT games, COUNT(1) AS Tot_sport FROM w GROUP BY games)
SELECT w.games, y.Tot_sport
FROM w JOIN y ON w.games = y.games
GROUP BY games
ORDER BY Tot_sport DESC, games;



WITH
y AS (SELECT DISTINCT games, sport FROM athlete_events),
w AS (SELECT sport, COUNT(1) AS Tot_games FROM y GROUP BY sport)
SELECT Y.*, w.Tot_games
FROM y JOIN w ON y.sport = w.sport
WHERE w.Tot_games = 1
GROUP BY sport;


WITH z AS (select count(distinct games) as total_games from athlete_events where season = 'Summer'),
x AS (select distinct games, sport from athlete_events where season = 'Summer'),
w AS (select sport, count(1) as no_of_games FROM x group by sport)
SELECT * FROM w JOIN z ON z.total_games = w.no_of_games;


SELECT COUNT(DISTINCT a.games) AS total_games, n.noc, n.region
FROM athlete_events AS a INNER JOIN noc AS n USING(noc)
GROUP BY n.noc
ORDER BY total_games DESC;


SELECT max(c.games) AS games, MAX(c.Total_country) AS highes, MIN(c.games) as games, MIN(c.Total_country) AS lowest
FROM (SELECT b.games, COUNT(b.noc) AS Total_country
FROM (SELECT a.games,  a.noc
FROM athlete_events AS a
GROUP BY a.noc,1) AS b
GROUP BY b.games,1) AS c;


SELECT b.games, COUNT(b.noc) AS Total_country
FROM (SELECT a.games,  a.noc
FROM athlete_events AS a
GROUP BY a.noc,1) AS b
GROUP BY b.games;


SELECT a.`year`, a.games AS season, a.city
FROM athlete_events AS a
GROUP BY a.games
ORDER BY a.`year`;


SELECT COUNT(b.games) AS Total_Games_Olim
FROM (SELECT a.games
FROM athlete_events AS a
GROUP BY a.games) AS b;