-- use schema from '1994-census-summary.file';

-- 1. What is the highest average age for any education level? 
--    hint:  find the average age by education level (inner query)
--           find the max of the average_age inner query (outer query)
select max(avg_age) as highestAvgAge
from (select avg(age) as avg_age
	  from census
	  group by education) as t1;

-- 2. What are the usid values and occupations of the people in the data set with the highest age?  
--    Expected output:
--      223,Other_service
--      1041,Other_service
--      1936,Exec_managerial
--      (etc.)
--    hint:  code a subquery to return the largest age    
--           then find all rows with the largest_age value
select usid, occupation
from census
where age in (select max(age)
              from census);

-- 3. Try solving problem 1 in a different way.
select avg(age) as highestAvgAge
from census
group by education
order by avg_age desc
limit 1;

-- 4. Try solving problem 2 in a different way.
select usid, occupation
from census join (select max(age) from census) as t1(max_age)
where census.age = t1.max_age;

-- use schema from files 'courses-ddl.sql', 'courses-small.sql';

-- 5. Show student ID and name for students
--    who have taken class taught in the Painter building?
--    hint:  Use the in predicate with a subquery.
select distinct s.id, s.name
from student as s natural join takes
where (course_id, sec_id, semester, year) in (select course_id, sec_id, semester, year
                                              from section
                                              where building = "Painter");

-- 6. Define a view that gives the highest salary in each department.  
--     Name the view ‘max_dept_salary’.  
--     The view should have columns ‘dept_name’ and ‘max_salary’.
create view max_dept_salary as
select dept_name, max(salary) as max_salary
from instructor
group by dept_name; 

-- 7.  Use the max_dept_salary view from problem 6 to find the average salary among 
--     the instructors who are the most highly paid in their departments.
select avg(max_salary)
from max_dept_salary;

-- 8.  Define an avg_dept_salary view. 
create view avg_dept_salary as
select dept_name, avg(salary) as avg_salary
from instructor
group by dept_name; 

-- 9.  Use the avg_dept_salary view to code a query showing all instructors whose salary 
--     is greater than the average salary within their own department.
select *
from instructor 
natural join avg_dept_salary
where salary > avg_salary;

-- 10. Delete the max_dept_salary view. 
drop view max_dept_salary; 
drop view avg_dept_salary; 



-- 11.  Create a table actor, with fields 'name' and 'birthyear'.  Figure out domains for the fields, 
--      add an integer ID field for the primary key.  Use the check keyword to require that birthyear be greater than 1900.
create table actor
(ID varchar(2) not null,
name varchar(20) not null,
birthyear varchar(4) not null,
primary key(ID),
check (birthyear >1900)

); 

create table actor(
ID int primary key,
name varchar(30),
birthyear int check (birthyear >1900)
);

drop table actor;

-- 12.  Try to insert actor Simon Pegg (born 1970) twice.  Use an ID value of 1 both times.
insert into actor(ID, name, birthyear) values(1, 'Simon Pegg', 1970);
select * from actor;

-- 13.  Try to insert an actor into the actor table with ID 3, name 'Neil Old', and birthyear 1754.
insert into actor(ID, name, birthyear) values(3, 'Neil Old', 1754);

-- 14. Create another table 'movie', with fields title, yearMovie, and director.   
--     Use type varchar(30) for title and director, and integer for year.  
--     Define the primary key to be the attributes title and yearMovie.   
--     Include a check so that the year is greater than 1880.
create table movie(
title varchar(30) not null,
yearMovie int not null,
director varchar(30) not null,
primary key(title, yearMovie),
check (yearMovie > 1880) 
);

drop table movie;
-- 15. Insert a movie into the movie table, with title 'Paul', year 2011, and director 'Greg Mottola’. 
insert into movie(title, yearMovie, director) values('Paul', 2011, 'Greg Mottola'); 

select * from movie;
-- 16.  Create another table 'appears’  with fields actor_ID, title, and year.   
--      Add two constraints so that the actor_ID is the ID of an actor in the actor table, 
--      and title, yearMovie identify a movie in the movie table.   
--      The primary key should be the attributes actor_ID, title, yearMovie.
create table appears (
actor_ID int,
title varchar(30) not null,
yearMovie int not null,
foreign key(actor_ID) references actor(ID),
foreign key(title, yearMovie) references movie(title, yearMovie),
primary key(actor_ID, title, yearMovie)
); 
drop table appears;
-- 17. Insert a row into the 'appears' table with actor_ID = 1, title = 'Paul', and year = 2010 (NOT 2011).
insert into appears (actor_id, title, yearMovie) values(1, 'Paul', 2010);

insert into appears (actor_id, title, yearMovie) values(1, 'Paul', 2011);



