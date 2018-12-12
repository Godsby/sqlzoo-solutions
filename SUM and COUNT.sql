/*
1.Show the total population of the world.
*/

SELECT SUM(population)
FROM world

/*
2.List all the continents - just once each.
*/

SELECT DISTINCT(continent)
FROM world

/*
3.Give the total GDP of Africa
*/

SELECT SUM(gdp)
FROM world
WHERE continent = 'Africa'

/*
4.How many countries have an area of at least 1000000
*/

SELECT COUNT(name)
FROM world
WHERE area >= 1000000

/*
5.What is the total population of ('Estonia', 'Latvia', 'Lithuania')
*/

SELECT SUM(population)
FROM world
WHERE name IN ('Estonia', 'Latvia', 'Lithuania')

/*
6.For each continent show the continent and number of countries.
*/

SELECT continent, COUNT(name)
FROM world
GROUP BY continent

/*
7.For each continent show the continent and number of countries with populations of at least 10 million.
*/

SELECT continent, COUNT(name)
FROM world
WHERE population >= 10000000
GROUP BY continent

/*
8.List the continents that have a total population of at least 100 million.
*/

SELECT continent
FROM world
GROUP BY continent
HAVING SUM(population) >=100000000

/*
9.List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]
*/

SELECT title
FROM movie 
  JOIN casting ON id = movieid
WHERE actorid = (SELECT id FROM actor WHERE name = 'Harrison Ford' ) AND ord != 1

/*
10.List the films together with the leading star for all 1962 films.
*/

SELECT title, name
FROM movie 
  JOIN casting ON id = movieid
  JOIN actor ON actorid = actor.id
WHERE yr = 1962 AND ord =1

/*
11.Which were the busiest years for 'John Travolta', show the year and the number of movies he made each year for any year in which he made more than 2 movies.
*/

SELECT yr, COUNT(title) 
FROM movie 
  JOIN casting ON movie.id = movieid
  JOIN actor ON actorid = actor.id
where name ='John Travolta'
GROUP BY yr
HAVING COUNT(title) > 2 

/*
12.List the film title and the leading actor for all of the films 'Julie Andrews' played in.
*/

SELECT title, name 
FROM movie
  JOIN casting ON movie.id = movieid
  JOIN actor ON actor.id = actorid
WHERE ord=1 AND movieid IN(
  SELECT movieid 
  FROM casting
    JOIN actor ON actor.id = actorid
  WHERE name = 'Julie Andrews')

/*
13.Obtain a list, in alphabetical order, of actors who've had at least 30 starring roles.
*/

SELECT name
FROM actor
  JOIN casting ON (id = actorid 
  AND (SELECT COUNT(ord) FROM casting WHERE actorid = actor.id 
  AND ord = 1)>= 30)
GROUP BY name

/*
14.List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
*/

SELECT title, COUNT(actorid) AS cast
FROM movie 
  JOIN casting on id = movieid
WHERE yr = 1978
GROUP BY title
ORDER BY cast DESC, title

/*
15.List all the people who have worked with 'Art Garfunkel'.
*/

SELECT DISTINCT name 
FROM actor 
  JOIN casting ON actor.id = actorid
WHERE movieid IN (
  SELECT movieid FROM casting 
    JOIN actor ON actorid = id 
  AND name = 'Art Garfunkel') 
AND name != 'Art Garfunkel'