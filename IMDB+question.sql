USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

Select COUNT(*) as Count_director_mapping from director_mapping;
Select COUNT(*) as Count_genre from genre;
Select COUNT(*) as Count_movie from movie; 
Select COUNT(*) as Count_names from names;
Select COUNT(*) as Count_ratings from ratings;
Select COUNT(*) as Count_role_mapping from role_mapping;

-- Q2. Which columns in the movie table have null values?
-- Type your code below:
Select 
      sum(case when id IS NULL then 1 else 0 end)  as id_null_count,
      sum(case when title IS NULL then 1 else 0 end) as title_null_count ,
      sum(case when "year" IS NULL then 1 else 0 end) as year_null_count,
      sum(case when date_published IS NULL then 1 else 0 end) as date_published_null_count,
      sum(case when duration IS NULL then 1 else 0 end) as duration_null_count,
      sum(case when country IS NULL then 1 else 0 end) as country_null_count,
      sum(case when worlwide_gross_income IS NULL then 1 else 0 end) as worlwide_gross_income_null_count,
      sum(case when languages IS NULL then 1 else 0 end) as languages_null_count,
      sum(case when production_company IS NULL then 1 else 0 end) as production_company_null_count
from movie;

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
select year,
       count(id) as number_of_movies 
from movie
group by year
order by year;

select month(date_published) as month_num,
       count(id) as number_of_movies 
from movie
group by month(date_published)
order by month(date_published);

/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
select year, Count(id) as number_of_movies
from movie
where (country LIKE "%USA%" or country like "%INDIA%")
       and
       year = 2019;

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
select distinct genre
from genre
order by genre;


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT 
        g.genre, 
        count(m.title) AS number_of_movies_produced
FROM
		genre AS g
INNER JOIN
		movie AS m
ON  
		g.movie_id = m.id
GROUP BY g.genre
ORDER BY COUNT(m.title) desc;

SELECT 
        genre, 
        count(movie_id) AS number_of_movies_produced
FROM genre
GROUP BY genre
ORDER BY COUNT(movie_id) desc;

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH one_genre
     AS (SELECT title, Count(DISTINCT genre)
           FROM   genre g 
         inner join movie m 
         on m.id = g.movie_id
         group by title
         HAVING Count(DISTINCT genre) = 1)
SELECT Count(*) AS movies_one_genre
FROM   one_genre;

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
Select g.genre, round(avg(m.duration),0) AS avg_movie_duration
from genre AS g
inner join movie AS m
on g.movie_id = m.id
group by genre


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)


/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

with thriller_rank
AS
(select genre, count(movie_id) as movie_count,
rank() over(order by count(movie_id) desc) as genre_rank
from genre
group by genre
order by movie_count desc)
select * 
from thriller_rank
where genre  = "thriller";


/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:
SELECT Min(avg_rating)    AS min_avg_rating,
       Max(avg_rating)    AS max_avg_rating,
       Min(total_votes)   AS min_total_votes,
       Max(total_votes)   AS max_total_votes,
       Min(median_rating) AS min_median_rating,
       Max(median_rating) AS max_median_rating
FROM   ratings;

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too


with top_movies
AS
(Select title, avg_rating,
rank() over(order by avg_rating desc) as movie_rank
from movie as m
inner join ratings as r
on 
m.id = r.movie_id
group by title,avg_rating
order by movie_rank)
Select * 
from top_movies
where movie_rank<=10;

with top_movies
AS
(Select title, avg_rating,
dense_rank() over(order by avg_rating desc) as movie_rank
from movie as m
inner join ratings as r
on 
m.id = r.movie_id
group by title,avg_rating
order by movie_rank)
Select * 
from top_movies
where movie_rank<=10;


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actresss and filler actresss can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

select median_rating,count(movie_id) as movie_count
from ratings
group by median_rating
order by median_rating
;

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

with most_number_of_hits
AS
(
select production_company,count(id) as movie_count,
rank() over(order by count(id)desc) as prod_company_rank
from movie as m
inner join ratings as r
on m.id = r.movie_id
where avg_rating>8
     and
     production_company IS NOT NULL
group by production_company
order by movie_count)
select*
from most_number_of_hits
where prod_company_rank=1;

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
Select genre, count(g.movie_id) as movie_count
from genre as g
inner join movie as m
on g.movie_id = m.id
inner join ratings as r
on m.id = r.movie_id
where m.year = 2017 and month(m.date_published) = 3 and m.country LIKE "%USA%" and r.total_votes>1000
group by g.genre
order by movie_count desc;

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
select m.title, r.avg_rating, g.genre
from genre AS g
inner join movie AS m
on g.movie_id = m.id
inner join  ratings as r
on m.id = r.movie_id
where avg_rating>8 and
      title like "The%"
order by avg_rating desc;

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
select count(movie_id) AS total_movies_released
from ratings 
inner join movie
on ratings.movie_id = movie.id
where median_rating=8 and date_published between "2018-04-01" AND '2019-04-01';

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

with total_german_votes
AS
(
Select sum(total_votes) as total_german_votes
from ratings AS r
inner join movie as m
on r.movie_id = m.id
where languages like "%German%"
),

total_italian_votes
AS
(
Select sum(total_votes) as total_italian_votes
from ratings AS r
inner join movie as m
on r.movie_id = m.id
where languages like "%Italian%"
)
select 
       (case when total_german_votes>total_italian_votes then "Yes" else "NO" end) as total_german_votes_greater_total_italian_votes
from total_german_votes 
cross join total_italian_votes;



(SELECT Sum(total_votes) AS no_of_votes
 FROM   movie m
        INNER JOIN ratings r
                ON m.id = r.movie_id
 WHERE  languages LIKE '%German%')
UNION
(SELECT Sum(total_votes) AS no_of_votes
 FROM   movie m
        INNER JOIN ratings r
                ON m.id = r.movie_id
 WHERE  languages LIKE '%Italian%');


Select sum(total_votes) as total_german_votes
from ratings AS r
inner join movie as m
on r.movie_id = m.id
where languages like "%German%";

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:





SELECT Sum(CASE
             WHEN id IS NULL THEN 1
             ELSE 0
           end) AS id_null_count,
       Sum(CASE
             WHEN name IS NULL THEN 1
             ELSE 0
           end) AS name_null_count,
       Sum(CASE
             WHEN height IS NULL THEN 1
             ELSE 0
           end) AS height_null_count,
       Sum(CASE
             WHEN date_of_birth IS NULL THEN 1
             ELSE 0
           end) AS date_of_birth_null_count,
Sum(CASE
             WHEN known_for_movies IS NULL THEN 1
             ELSE 0
           end) AS known_for_movies_null_count
FROM   names;
	

/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

with top_three_genre
AS
(
Select g.genre, count(g.movie_id),
       rank() over(order by count(g.movie_id) desc) as genre_rank
from genre g
inner join ratings r
using(movie_id)
where r.avg_rating > 8
group by g.genre
order by genre_rank
limit 3)
Select name, count(movie_id) as movie_count
from director_mapping d
inner join genre g
using(movie_id)
inner join names n
on d.name_id = n.id
inner join top_three_genre
using(genre)
inner join ratings r 
using(movie_id)
where avg_rating >8
group by name
order by movie_count desc
limit 3;


/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actresss.*/

-- Q20. Who are the top two actresss whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actress_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:


Select *
from role_mapping
where category = "actress";

with top_actresss
AS
(
select name as actress_name, count(r.movie_id) as movie_count,
               rank() over( order by count(r.movie_id)  desc) as actress_rank 
from names n
inner join role_mapping rl
on n.id = rl.name_id
inner join ratings r
using(movie_id)
where category ="actress" and median_rating >=8
group by name
order by count(r.movie_id) desc)
select actress_name, movie_count
from top_actresss
where actress_rank<3;

/* Have you find your favourite actress 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

Select m.production_company, sum(r.total_votes) as vote_count,
        rank() over(order by sum(r.total_votes) desc) AS prod_comp_rank  
from movie m
inner join ratings r
ON m.id = r.movie_id
group by m.production_company
limit 3;

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actresss for its upcoming project to give a regional feel. 
Let’s find who these actresss could be.*/

-- Q22. Rank actresss with movies released in India based on their average ratings. Which actress is at the top of the list?
-- Note: The actress should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

with top_actress
AS
(
select n.name , sum(r.total_votes) as total_votes, count(r.movie_id) as movie_count, Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actress_avg_rating,
       Rank() OVER (ORDER BY (Sum(avg_rating * total_votes)) / (Sum(total_votes))DESC) AS actress_rank
from names n
inner join role_mapping as rl
on n.id = rl.name_id
inner join ratings r
using(movie_id)
inner join movie m
on r.movie_id = m.id
where category = "actress"  and country = "India"
group by name
having movie_count>=5
order by total_votes desc)
Select *
from top_actress
where actress_rank<=5
order by actress_rank;
-----------------------------------------------------------------------------------------------------------------------
WITH top_actress
     AS (SELECT n.NAME AS actress_name,
                Sum(total_votes) AS total_votes,
                Count(r.movie_id) AS movie_count,
                Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actress_avg_rating,
				Rank() OVER (ORDER BY (Sum(avg_rating * total_votes)) / (Sum(total_votes))DESC) AS actress_rank
         FROM   movie AS m
                INNER JOIN ratings AS r
                        ON m.id = r.movie_id
		
				INNER JOIN role_mapping AS rm
                        ON m.id = rm.movie_id
                INNER JOIN names AS n
                        ON rm.name_id = n.id
         WHERE  category = "actress"
                AND country = 'india'
         GROUP  BY NAME
         HAVING movie_count >= 5
         ORDER  BY total_votes DESC)
SELECT *      
FROM   top_actress
where actress_rank <= 5
order by actress_rank;

-- Top actress is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:
with top_actress
AS
(
select n.name , sum(r.total_votes) as total_votes, count(r.movie_id) as movie_count, Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS actress_avg_rating,
       Rank() OVER (ORDER BY (Sum(avg_rating * total_votes)) / (Sum(total_votes))DESC) AS actress_rank
from names n
inner join role_mapping as rl
on n.id = rl.name_id
inner join ratings r
using(movie_id)
inner join movie m
on r.movie_id = m.id
where category = "actress" and country = "India" and languages = "Hindi"
group by name
having movie_count>=3
order by total_votes desc)
Select *
from top_actress
where actress_rank<=5
order by actress_rank;

/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:
select genre, avg_rating,
     ( Case when avg_rating>8 then "Superhit movies" 
	        when avg_rating between 7 and 8 then "Hit movies" 
            when avg_rating between 5 and 7 then "One-time-watch movies" 
            else
            "Flop movies" end)as category
from genre as g
inner join ratings r
using(movie_id)
where genre = "thriller"
order by avg_rating desc;

/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:
select genre, round(avg(duration),2) as avg_duration, sum(avg(duration)) over w1 as running_total_duration,
avg(round(avg(duration),2)) over w2 as moving_avg_duration
from genre g
inner join movie m 
on g.movie_id = m.id
group by genre
window w1 as (order by genre  ROWS UNBOUNDED PRECEDING),
w2 as (order by genre  ROWS 10 PRECEDING);

-- Round is good to have and not a must have; Same thing applies to sorting


-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies

with top_three_genres
As
(
select genre, count(movie_id) as movie_count      
from genre as g
inner join movie as m
on g.movie_id = m.id
group by genre
order by movie_count desc
limit 3),
top_five
AS
(
select genre, year, title as movie_name, worlwide_gross_income,
       dense_rank() over( partition by year  order by worlwide_gross_income desc) as movie_rank
from genre as g
inner join movie m
on g.movie_id = m.id
where genre in( select genre  from top_three_genres))
Select *
from top_five
where movie_rank<=5;

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:
with top_two
AS
(
select production_company,count(id) as movie_count, 
       rank() over ( order by count(id) desc) as prod_comp_rank
from movie m 
inner join ratings r 
on m.id = r.movie_id
where median_rating>=8 and POSITION(',' IN languages)>0 
group by production_company
having production_company IS NOT NULL
order by prod_comp_rank)
Select * 
from top_two
where prod_comp_rank<=2;

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

with top_three_actress
As
(
select n.name as actress_name, sum(total_votes) as total_votes , count(r.movie_id) as movie_count,
                 round(sum(avg_rating*total_votes)/sum(total_votes),2) AS actress_avg_rating,
                 rank() over(order by count(r.movie_id)desc )as actress_rank
FROM genre g
INNER JOIN ratings r
USING (movie_id)
INNER JOIN role_mapping rl
USING (movie_id)
INNER JOIN names n
ON rl.name_id = n.id
where   genre = "drama" and category = "actress" and avg_rating>8
group by actress_name
order by movie_count desc)
select * 
from top_three_actress
limit 3;

/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:  
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:
WITH movie_date_information AS
(
SELECT d.name_id, name, d.movie_id,
	   m.date_published, 
       LEAD(date_published, 1) OVER(PARTITION BY d.name_id ORDER BY date_published, d.movie_id) AS next_movie_date
FROM director_mapping d
	 JOIN names AS n 
     ON d.name_id=n.id 
	 JOIN movie AS m 
     ON d.movie_id=m.id
),
date_diff AS
(
	 SELECT *, DATEDIFF(next_movie_date, date_published) AS diff
	 FROM movie_date_information
 ),
 
 avg_inter_days AS
 (
	 SELECT name_id, AVG(diff) AS avg_inter_movie_days
	 FROM date_diff
	 GROUP BY name_id
 ),


final_output
As
(
select 
		name_id as director_id, 
        n.name as director_name, 
        count(d.movie_id) as number_of_movies, 
        round(avg_inter_movie_days) as avg_inter_movie_days,
        round(sum(avg_rating*total_votes)/sum(total_votes),2) as avg_rating,
        sum(total_votes) as total_votes,
        min(avg_rating) as min_rating,
        max(avg_rating) as max_rating,
        sum(duration) as total_duration
from 
         director_mapping as d
inner join 
          names as n
on 
         d.name_id = n.id
inner join 
          ratings as r
using(movie_id)
inner join  
          movie as m
on 
           d.movie_id = m.id
inner join  avg_inter_days 
using(name_id)          
group by 
         name_id , 
         n.name
order by
         count(d.movie_id) desc)
         

select *
from final_output
limit 9;
