use imdb;

/*1.Find the total number of rows in each table of the schema.*/

use imdb;
 select "director_mapping" as "table" , count(*) as totalrows from director_mapping
 union all
 select "genre" as "table" , count(*) as totalrows from genre
 union all
 select "movie" as "table" , count(*) as totalrows from movie
 union all 
 select "names" as "table" , count(*) as totalrows from names
 union all
 select "ratings" as "table" , count(*) as totalrows from ratings
 union all 
 select "role_mapping" as "table" , count(*) as totalrows from role_mapping;
 
 /*2.Which columns in the movie table have null values?*/
 
 select "id" as "column_name" , count(*) as null_count
 from movie where id is null
 union all
 select "title" as "column_name" , count(*) as null_count
 from movie where title is null
 union all
 select "year" as "column_name" , count(*) as null_count
 from movie where year is null
 union all
 select "date_published" as "column_name" , count(*) as null_count
 from movie where date_published is null
 union all
 select "duration" as "column_name" , count(*) as null_count
 from movie where duration is null
 union all
 select "country" as "column_name" , count(*) as null_count
 from movie where country is null
 union all
 select "worlwide_gross_income" as "column_name" , count(*) as null_count
 from movie where worlwide_gross_income is null
 union all
 select "languages" as "column_name" , count(*) as null_count
 from movie where languages is null
 union all
 select "production_company" as "column_name" , count(*) as null_count
 from movie where production_company is null;
 
 
 /*3.Find the total number of movies released each year. How does the trend look month-wise?*/
 
 select year , count(*) as Total_movies from movie
 group by year ;
 
 select month(date_published) as "month" , count(*) as Total_movies
 from movie
 group by month
 order by month asc;
 
 /*4.How many movies were produced in the USA or India in the year 2019?*/
 
 select year , country, count(*) as Total_movies from movie
 where year =2019 and (country="USA" or country="India")
 group by year , country;
 
 /*5.Find the unique list of genres present in the dataset and how many movies belong to only one genre.*/

/*a*/

 select distinct genre from genre;
 
  /*b*/
  
 Select Count(movie_id) As Single_genre_movies
From (
    Select movie_id, Count(genre) As number_of_movies
    From genre
    Group by movie_id
    Having Count(genre) = 1
) As subquery;
 
 /*6.Which genre had the highest number of movies produced overall?*/
 
 select genre ,count(*) as numberofmovies  from genre
 group by genre
 limit 1;

/*7.What is the average duration of movies in each genre?*/

select genre , avg(duration) as Avg_duration from movie
inner join genre on id=movie_id
group by genre
order by avg_duration desc;

/*8.Identify actors or actresses who have worked in more than three movies with an average rating below 5?*/

select n.name,count(*) as low_rated_movies
from names n join role_mapping rm on
n.id=rm.name_id join ratings r on r.movie_id=rm.movie_id
where r.avg_rating < 5
group by n.id
having count(rm.movie_id)>3
order by low_rated_movies desc;

/*9.Find the minimum and maximum values in each column of the ratings table except the movie_id column.*/

select max(avg_rating) as Max_rating,min(avg_rating) as min_rating,
max(total_votes) as Max_votse , min(total_votes) as Min_votes,
max(median_rating) as Max_median_rating ,Min(median_rating) as Min_median_rating
from ratings;

/*10.Which are the top 10 movies based on average rating?*/

select m.title, avg_rating
from movie m join ratings r on m.id=r.movie_id
order by avg_rating desc
limit 10;

/*11.Summarise the ratings table based on the movie counts by median ratings.*/
use imdb;
select median_rating,count(*) as moivecounts
from ratings
group by median_rating
order by median_rating asc;

/*12.How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?*/

select g.genre , count(*) as Totalmovies
 from genre g join ratings r on g.movie_id=r.movie_id join movie m on g.movie_id = m.id
 where country="USA" and total_votes> 1000 and month(date_published)=3 and year =2017
group by genre
order by totalmovies desc;

/*13.Find movies of each genre that start with the word ‘The ’ and which have an average rating > 8.*/

select g.genre , m.title , avg_rating 
from genre g join movie m on g.movie_id= m.id join ratings r on g.movie_id =r.movie_id
where (title like"The %" and avg_rating >8)
order by genre asc;

/*14.Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?*/

select count(*) as Toatlmovies
from movie join ratings on movie.id=ratings.movie_id
where date_published between "2018-04-01" and "2019-04-01" and median_rating= 8;

/*15.Do German movies get more votes than Italian movies?*/

select country , sum(total_votes) as total_votes  
from movie join ratings on movie.id=ratings.movie_id
where country in ("Germany" , "Italy") 
group by country;

/*16.Which columns in the names table have null values?*/

select "id" as column_name ,count(*) as null_count from names where id is null
union all 
select "name" as column_name , count(*) as null_count from names where name is null
union all 
select "height" as column_name , count(*) as null_count from names where height is null
union all 
select "date_of_birth" as column_name , count(*) as null_count from names where date_of_birth is null
union all
select "known_for_movies" as column_name , count(*) as null_count from names where known_for_movies is null;


/*17.Who are the top two actors whose movies have a median rating >= 8?*/

select name , count(*) as totalmovies
from names join role_mapping on names.id=role_mapping.name_id join ratings on role_mapping.movie_id=ratings.movie_id
where median_rating>=8 and category="actor"
group by name , category 
order by totalmovies desc
limit 2;

/*18.Which are the top three production houses based on the number of votes received by their movies?*/

select production_company , sum(total_votes) as totalvotes
from movie join ratings on movie.id=ratings.movie_id
group by production_company
order by totalvotes desc
limit 3;

/*19.How many directors worked on more than three movies?*/
use imdb;

select name, count(*) as totalmovies
from names join director_mapping d on names.id=d.name_id
group by name 
having count(movie_id) > 3
order by totalmovies desc;

/*20.Find the average height of actors and actresses separately.*/

select category , round(avg(height),2)as Avg_height
from names n join role_mapping r on n.id=r.name_id
group by category 
order by avg_height desc;

/*21.Identify the 10 oldest movies in the dataset along with its title, country, and director.*/

select m.title,m.country, n.name as director,m.date_published
from movie m join director_mapping d on m.id=d.movie_id join names n on d.name_id = n.id
order by date_published asc , country asc
limit 10;

/*22.List the top 5 movies with the highest total votes and their genres.*/

select title , genre,total_votes 
from movie join genre on movie.id=genre.movie_id join ratings  on movie.id=ratings.movie_id 
order by genre asc, total_votes desc
limit 5;


/*23.Find the movie with the longest duration, along with its genre and production company.*/

select m.title,m.duration , g.genre,m.production_company
from movie m join genre g on m.id =g.movie_id 
order by duration desc
limit 1;

/*24.Determine the total votes received for each movie released in 2018.*/

select title , total_votes
from movie join ratings on movie.id=ratings.movie_id
where year="2018"
order by total_votes desc;

/*25.Find the most common language in which movies were produced.*/

select languages, count(*) as Total_movies
from movie
group by languages
order by total_movies desc
limit 1;





