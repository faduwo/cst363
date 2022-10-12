-------------------------------------------------------------------------------
-- Homework 6
-- CST 363, Intro to Databases
-- The problems are based on the normalized CA candidate, contributor and contribution 
-- tables in file 'campaign-normal.sql';
-- NOTE:  this is a large file.  It will be faster if you use the File--> Run Script ...  function
-- in the workbench rather than open the file and execute it.


-- 1. Create a view 'c_summary' summarizing campaign contributions,
-- with four attributes: cand_name, contbr_name, occupation, zip and amount.
-- Use a count(*) query to verify that the view correctly returns 180478 rows.
-- Use the view in the problems that follow to avoid coding the join operation.
create view c_summary (cand_name, contbr_name, occupation, zip, amount) as 
select candidate.name, contributor.name, contributor.occupation, contributor.zip, contribution.amount
from candidate join contribution using(cand_id) 
				join contributor on contribution.contbr_id = contributor.contbr_id;

select count(*) from c_summary;
     

-- 2. For the 3 occupations 'STUDENT', 'TEACHER', and 'LAWYER',
-- show the occupation, and average dollar contribution rounded to an whole number 
-- labeled as "avg_contribution" from contributors in that occupation.
-- The average contribution by STUDENT should be 538.
select occupation, round(avg(amount)) as avgdollarcontribution
from contributor join contribution using(contbr_id)
where occupation = 'STUDENT' or occupation = 'TEACHER' or occupation = 'LAWYER'
group by occupation;


-- 3. Let's focus on lawyers.  For each candidate, show the candidate
-- name and total amount (labeled as "amount") of contributions 
-- from contributors with occupation 'LAWYER' and zip code that starts with 939.
-- Use the view c_summary in your query.
-- Your result should have 2 rows with amounts of 1350 and 125.
select cand_name as candidate, sum(amount) as amount 
from c_summary
where occupation = 'LAWYER' and zip like '939%' 
group by contbr_name
order by cand_name;

-- 4. Do lawyers list their occupations in lots of different ways?
-- List the distinct occupations that contain 'LAWYER' within them?
-- Your result should have 28 rows.
select distinct occupation from contributor where occupation like '%LAWYER%';

-- 5. How many contributors have occupation 'LAWYER'?  
--    Give just the count labeled as "count".
--    The correct answer is 553.
select count(occupation) as count from contributor where occupation = 'LAWYER';

-- 6. How many contributors have an occupation that contains 'LAWYER'?
-- Query should return a single count labeled as "count". The correct answer is 592.
select count(occupation) as count from contributor where occupation like '%LAWYER%';

-- 7. Give number of contributors (labeled as "count") with 
-- an occupation that contain the substring 'LAWYER'.  
-- The result should have 2 columns:  occupation, count
-- Order by decreasing count.  
-- Answer: the first row is LAWYER with count 553, 
--         the second row is TRIAL LAWYER with count 8
select occupation, count(contbr_id) 
from contributor 
where occupation like '%LAWYER%'
group by occupation order by count(contbr_id) desc;

-- 8. The occupation 'LAWYER FOR THE OPPRESSED' has an unusual name.
-- Look at all columns of the contributor table for contributors who
-- list their occupation this way.  The result should have 2 rows.
select * from contributor where occupation = 'LAWYER FOR THE OPPRESSED';

-- 9. What is the average number of contributions per zip code?  Use only
-- the first five digits of the zip code.  Round the average to an integer and 
-- label it "average".
--  The correct answer is 96.
select round((select (count(CONTB_ID )) from contribution)/(select (count(distinct(substring(zip,1,5)))) from contributor)) as average;

-- 10. Looking at only the first five digits of the zip code, show the 20
-- zip codes with the highest number of contributors (not contributions).
-- Show the five-digit form of the zip code labeled as "zip"
--  and  the number of contributors labels as "count"
-- Order by count high to low, and then zip low to high.
--  The first result row should be 92067, 35.
select substring(zip,1,5) as zip, count(contbr_id) as count 
from contributor
group by zip  
order by count(contbr_id) desc, substring(zip,1,5) asc limit 20;

-- 11. List the last name, zip, and number of contributors with that last name and zip.
-- Use output labels "lastname", "zip" and "number". 
-- Only list rows where number is greater than 6.
-- Use the substring_index function to extract the last name from the name column.




-- 12. For each contributor that made more than 75 contributions,
-- show the contributor name, total dollar amount contributed (use label "total"),
-- and number of contributions (use label "number").
-- Order by descreasing number.
select name, sum(amount) as total, count(*) as number
from contributor join contribution using(contbr_id)
group by name having number > 75
order by number desc;

-- 13. For each candidate, what decimal fraction of the number of positive contributions
-- came from contributions > $2500?  
-- The result should have a calculated labeled as "fraction" that is a subquery to calculate the sum of 
-- contributions over $2500 by candidate divided by the sum of all positive contributions for the candidate.
-- Order by fraction in decreasing order.
-- The result should include a row with Hillary Clinton with a fraction value 0.705948
select 13;
