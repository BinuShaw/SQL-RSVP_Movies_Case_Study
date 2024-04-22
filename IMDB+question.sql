USE imdb;
Show tables;
/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:




-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:

SELECT 'Director_mapping' AS table_name,COUNT(*) AS Row_count FROM director_mapping
UNION
SELECT 'Movie' AS table_name,COUNT(*) AS Row_count FROM movie
UNION
SELECT 'Genre' AS table_name,COUNT(*) AS Row_count FROM genre
UNION
SELECT 'Names' AS table_name,COUNT(*) AS Row_count FROM names
UNION
SELECT 'Ratings' AS table_name,COUNT(*) AS Row_count FROM ratings
UNION 
SELECT 'Role_mapping' AS table_name,COUNT(*) AS Row_count FROM role_mapping;


-- Q2. Which columns in the movie table have null values?
-- Type your code below:

SELECT * 
FROM movie 
WHERE title IS NULL 
		OR year IS NULL 
			OR date_published IS NULL 
				OR duration IS NULL 
					OR country IS NULL 
						OR worlwide_gross_income IS NULL 
							OR languages IS NULL 
								OR production_company IS NULL;
                                
SELECT *
-- Information_Schema.colums allows us to get informtion about all colums for all tables in the database
FROM INFORMATION_SCHEMA.COLUMNS
WHERE   table_name= 'movie' 
		AND Table_SCHEMA = 'imdb'
		AND IS_NULLABLE = 'YES';


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

SELECT Year , 
		count(id) AS number_of_movies
FROM MOVIE 
GROUP BY Year;

SELECT Month(date_published) AS month_num , count(id) AS number_of_movies
FROM MOVIE 
GROUP BY month_num
ORDER BY month_num;


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT Country ,
		COUNT(id) AS No_of_movies 
FROM movie
WHERE country = 'India' 
		or country = 'USA' 
			AND year = 2019
GROUP BY country;


/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT Distinct(genre) AS Unique_Genre
FROM genre;


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT Genre ,
		Count(id) AS Total_Movie
FROM 
	Movie AS m
INNER JOIN
	Genre AS g
    ON m.id = g.movie_id
GROUP BY Genre
ORDER BY Total_Movie desc
limit 1;

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH Genre_1 AS
(
SELECT Count(Genre) as genre_count,
		movie_id
FROM Genre 
Group By movie_id
)
select Title ,
		Genre_count
from Genre_1 AS G
INNER JOIN 
	movie AS m
    ON g.movie_id = m.id
WHERE genre_count=1;


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

SELECT Genre ,
			ROUND(AVG(Duration),2) AS avg_duration
FROM 
	Movie AS m
INNER JOIN
	Genre AS g
    ON m.id = g.movie_id
GROUP BY Genre;


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

SELECT Genre ,
		Count(id) AS Total_Movie,
        RANK() OVER(Order By Count(id) desc) AS Genre_Rank
FROM 
	Movie AS m
INNER JOIN
	Genre AS g
    ON m.id = g.movie_id
GROUP BY Genre;



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

SELECT Min(avg_rating)AS min_avg_rating ,
			Max(avg_rating)AS Max_avg_rating ,
				Min(total_votes) AS Min_total_votes,
					Max(total_votes) AS Max_total_votes,
						Min(median_rating) AS Min_median_rating,
							Max(median_rating) AS Max_median_rating
FROM ratings;


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

SELECT Title,
			avg_rating,
				Rank() Over(Order By avg_rating desc) AS Movie_Rank 
FROM Movie AS m
INNER JOIN ratings AS r
ON m.id=r.movie_id
limit 10;



/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
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

SELECT   Median_rating ,
			COUNT(Title) AS Movie_count
FROM 
	Movie AS m
INNER JOIN 
	ratings AS r
		ON m.id=r.movie_id
GROUP BY median_rating
ORDER BY Movie_count desc;


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

SELECT Distinct Production_company ,
		 count(title) AS Movie_count,
			Rank() Over(Order By count(title) desc) AS Prod_Company_Rank
FROM 
	movie AS m
INNER JOIN 
	ratings AS r
		ON m.id=r.movie_id
WHERE avg_rating > 8 AND Production_company IS NOT NULL
GROUP BY Production_company;

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

SELECT  Genre,
			Count(title) AS Movie_count 
FROM 
	movie AS m
INNER JOIN 
	genre as g
		ON m.id = g.movie_id
WhERE MONTH(date_published) = 3 AND year = 2017
GROUP BY genre
ORDER BY Movie_count desc;


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


SELECT  Title ,
			Avg_Rating ,
				Genre
FROM 
	movie AS m
INNER JOIN 
	genre as g
		ON m.id = g.movie_id
			INNER JOIN 
				ratings as r
					ON m.id = r.movie_id
WhERE title LIKE  'The%' AND avg_rating > 8 
ORDER BY avg_rating desc;


-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT Count(median_rating) AS Movie_released_count
FROM 
	movie AS m
INNER JOIN 
	ratings As r
    ON m.id =  r.movie_id
WHERE median_rating = 8 AND date_published BETWEEN '2018-04-01' AND '2019-04-01' ;


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

WITH movie_votes AS 
(
	SELECT country, 
	Sum(total_votes) as total_votes ,
    Rank() Over(Order By Sum(total_votes) desc) AS Vote_Rank 
	FROM movie AS m
		INNER JOIN ratings as r ON m.id=r.movie_id
	WHERE country = 'Germany' or country = 'Italy'
	GROUP BY country
)
SELECT 	country ,
		CASE 
			WHEN Vote_Rank = 1 And country = 'Germany' 
						Then 'Yes'
			Else 'No'
		End As 'Answer'
FROM movie_votes;

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


SELECT 
    SUM(CASE
        WHEN name IS NULL THEN 1
        ELSE 0
		END) AS name_nulls,
    SUM(CASE
        WHEN height IS NULL THEN 1
        ELSE 0
		END) AS height_nulls,
    SUM(CASE
        WHEN date_of_birth IS NULL THEN 1
        ELSE 0
		END) AS date_of_birth_nulls,
    SUM(CASE
        WHEN known_for_movies IS NULL THEN 1
        ELSE 0
		END) AS known_for_movies_nulls
FROM
    names;

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

WITH Director_name AS
(	
    SELECT 	n.name,
			m.title,
            g.genre,
            r.avg_rating
	FROM 
		movie AS m
	INNER JOIN 
		genre AS g
			ON m.id = g.movie_id
				INNER JOIN director_mapping as d
					ON m.id = d.movie_id
						INNER JOIN names AS n
							ON d.name_id = n.id
								INNER JOIN ratings AS r
									ON m.id = r.movie_id
WHERE r.avg_rating > 8                                    
),
Top_3_genre AS 
(
	Select genre , Count(title)
    FROM 
		movie As m
    INNER JOIN 
		genre AS g
			ON m.id = g.movie_id
				INNER JOIN ratings AS r
					ON m.id = r.movie_id
WHERE avg_rating > 8
GROUP BY genre
ORDER BY Count(title) desc
limit 3
)
SELECT 	name AS Director_name ,
		Count(title) As Movie_count
FROM 
	director_name 
INNER JOIN  
	top_3_genre
		USING(genre)
WHERE avg_rating
GROUP BY Director_name
ORDER BY movie_count desc
limit 3;



/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT	name AS Actor_name,
		count(title) AS Movie_count
FROM 
	movie AS m
INNER JOIN 
	genre AS g
		ON m.id = g.movie_id
			INNER JOIN role_mapping as rm
					ON m.id = rm.movie_id
						INNER JOIN names AS n
							ON rm.name_id = n.id
								INNER JOIN ratings AS r
									ON m.id = r.movie_id
WHERE r.median_rating > 8   
GROUP BY Actor_name  
ORDER BY Movie_count desc
limit 2;                               


/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
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

SELECT 	Production_company ,
		Sum(total_votes) AS Vote_count ,
        Rank() over(ORDER BY Sum(total_votes) desc) AS Prod_comp_rank
FROM 
	movie AS m
INNER JOIN
	ratings AS r
		ON m.id = r.movie_id
GROUP by production_company
limit 3;


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actor_summery AS
(
	SELECT	name AS Actor_name,
			Sum(total_votes) AS Total_votes ,
			Count(title) AS Movie_count ,
			Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS Actor_avg_rating 
	FROM 
		movie AS m
	INNER JOIN 
		genre AS g
			ON m.id = g.movie_id
				INNER JOIN role_mapping as rm
					ON m.id = rm.movie_id
						INNER JOIN names AS n
							ON rm.name_id = n.id
								INNER JOIN ratings AS r
									ON m.id = r.movie_id
	WHERE 	category = 'actor' 
			AND country = 'India'
	GROUP BY Actor_name  
	HAVING Movie_count > 5
    ORDER BY 	Actor_avg_rating desc,
				Total_votes desc
) 
SELECT 	* ,
		Row_number() Over(ORDER BY Actor_avg_rating desc) AS Actor_rank
FROM actor_summery;



-- Top actor is Vijay Sethupathi

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


WITH actress_summery AS
(
	SELECT	n.name AS Actress_name,
			Sum(total_votes) AS Total_votes ,
			Count(title) AS Movie_count ,
			Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS Actress_avg_rating 
	FROM 
		movie AS m
	INNER JOIN 
		role_mapping as rm
			ON m.id = rm.movie_id
				INNER JOIN names AS n
					ON rm.name_id = n.id
						INNER JOIN ratings AS r
							ON m.id = r.movie_id
	WHERE 	category = 'actress' 
			AND country = 'India'
            AND languages LIKE '%Hindi%'
	GROUP BY Actress_name  
	HAVING Movie_count >= 3
    ORDER BY 	Actress_avg_rating desc,
				Total_votes desc
) 
SELECT 	* ,
		Rank() Over(ORDER BY Actress_avg_rating desc) AS Actress_rank
FROM actress_summery
limit 5;



/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT 	title ,
		avg_rating ,
		CASE 
			WHEN avg_rating >= 8 
					THEN  "Superhit movies"
			WHEN avg_rating BETWEEN 7 AND 8 
					THEN  "Hit movies"
			WHEN avg_rating BETWEEN 5 AND 7
					THEN  "One-time-watch movies"
			ELSE " Flop movies"
		END AS Rating_category
FROM 
	movie AS M
INNER JOIN  
	genre AS g
	ON m.id = g.movie_id
		INNER JOIN ratings AS r
			ON m.id = r.movie_id
WHERE 	genre = "thriller";


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


SELECT 	Genre ,
		Round(avg(duration),2) AS Avg_duration ,
        Sum(Round(Avg(duration),2)) Over(ORDER BY genre) AS Running_total_duration ,
        Avg(Round(Avg(duration),2)) Over(ORDER BY genre) AS Moving_total_duration
FROM 
	movie AS M
INNER JOIN  
	genre AS g
	ON m.id = g.movie_id
		INNER JOIN ratings AS r
			ON m.id = r.movie_id
GROUP BY Genre;



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


WITH Grossing_movies AS 
(
	SELECT 	Genre ,
			Year ,
			title AS Movie_name ,
            worlwide_gross_income,
            -- Removing "INR","$" expression From worlwide_gross_income column
            CAST(replace(replace(ifnull(worlwide_gross_income,0),'INR',''),'$','') AS decimal(10)) AS worlwide_gross_incomes
	FROM 
		movie AS m
	INNER JOIN 
		genre AS g
			ON m.id = g.movie_id
),
top3_genre AS 
(
	SELECT genre 
    FROM 
		movie AS m
	INNER JOIN 
		genre AS g
			ON m.id = g.movie_id
	GROUP BY Genre 
    ORDER BY count(title) desc
    limit 3
) ,
Grossing AS 
(
	SELECT 	Genre ,
			Year ,
			Movie_name ,
            -- Deviding "INR" Income with 80 so That WE can balance With "$"
			CASE 
				WHEN worlwide_gross_income LIke "INR%" 
							THEN Round(worlwide_gross_incomes / 80)
				Else worlwide_gross_incomes
			END AS worlwide_gross_income
	FROM 
		Grossing_movies 
	INNER JOIN 
		top3_genre 
			USING(genre)
),
Year_wise AS 
(
SELECT  * ,
		Row_number() Over(PARTITION BY year ORDER BY worlwide_gross_income desc) AS year_rank
FROM Grossing
) 
	SELECT 	* 
	FROM Year_wise
    WHERE year_rank <=5;



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



SELECT 	Production_company ,
		Count(title) AS Movie_count ,
        Rank() Over(ORDER BY Count(title) desc) AS prod_comp_rank 
   
FROM 	
		movie AS m
INNER JOIN 
		ratings AS r
        ON m.id = r.movie_id
WHERE 	median_rating >= 8 AND
		production_company IS NOT NULL AND 
		position("," IN languages) > 0
GROUP BY production_company ;



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


WITH actress_summery AS
(
	SELECT	n.name AS Actress_name,
			Sum(total_votes) AS Total_votes ,
			Count(title) AS Movie_count ,
			Round(Sum(avg_rating * total_votes) / Sum(total_votes), 2) AS Actress_avg_rating ,
            avg(avg_rating) AS Avg_movie_rating
	FROM 
		movie AS m
	INNER JOIN 
		role_mapping as rm
			ON m.id = rm.movie_id
				INNER JOIN names AS n
					ON rm.name_id = n.id
						INNER JOIN ratings AS r
							ON m.id = r.movie_id
								INNER JOIN genre AS g
									ON m.id = g.movie_id
	WHERE 	category = "actress" AND
			genre = "Drama" 
	GROUP BY Actress_name  
    ORDER BY 	Actress_avg_rating desc,
				Total_votes desc
) 
SELECT 	Actress_name,
		Total_votes	,
        Movie_count ,
        Actress_avg_rating ,
		Rank() Over(ORDER BY movie_count desc) AS Actress_rank
FROM actress_summery
WHERE Avg_movie_rating > 8
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


WITH date_summery AS
(
	SELECT 	d.name_id,
			NAME,
			d.movie_id,
			duration,
			r.avg_rating,
			total_votes,
			m.date_published,
			Lead(date_published,1) Over(PARTITION BY name ORDER BY date_published,movie_id) AS Next_Published
	FROM 
		movie AS m
	INNER JOIN 
		ratings as r
			ON m.id = r.movie_id
				INNER JOIN director_mapping AS d
					ON m.id = d.movie_id
						INNER JOIN names AS n
							ON d.name_id = n.id
)
SELECT 	name_id AS director_id,
		NAME AS director_name,
		Count(movie_id) AS number_of_movies,
		Round(Avg(Datediff(Next_Published, date_published)),2) AS avg_inter_movie_days,
		Round(Avg(avg_rating),2) AS avg_rating,
		Sum(total_votes) AS total_votes,
		Min(avg_rating) AS min_rating,
		Max(avg_rating) AS max_rating,
		Sum(duration)  AS total_duration
FROM   date_summery
GROUP BY director_id
ORDER BY Count(movie_id) DESC limit 9;
					
	




