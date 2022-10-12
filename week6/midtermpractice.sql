-- 1. Give all faculty in the Physics department a $3,500 salary increase.
  update instructor set salary = salary + 3500 where dept_nane='Physics';
-- 2. Give all faculty a 4% increase in salary.
  update instructor set salary = salary + .04*salary;
-- 3. How many buildings in the university are used for classes? 
  select count(distinct building) from section;
-- 4. Show the instructor id, name and the title of 
--    courses taught by the instructor. No duplicates should be listed. 
  select distinct instructor.ID, instructor.name, course.title
  from instructor join teashes using(id)
  join course using(course_id);
-- 5. Find the max and average student total credits.
--     Rename the result columns as "max_credits", "avg_credits".
  select max(tot_cred) as max_credits, avg(tot_cred) as avy_credits from student;
-- 6. Count the number of null grades in the takes table. ?????
  select count(*) from takes where grade is null;
-- 7a.  For the spring 2009 semester, show the department name
--     and total class enrollments in the department’s courses
  select course.dept_name, count(*) as enrollment
  from takes join course using(course_id) 
  where year = 2009 and semester = 'Spring'
  group by course.dept_name;
-- 7b.  For the spring 2009 semester, show the department name
--     and number of unique students that have taken classes 
--     from the department 
  select course.dept_name, count(distinct takes.id) as atudents_taught
  from takes join course using(course_id)
  where year = 2009 and semester = 'Spring'
  group by course.dept_name;

-- 8.  List the student majors with fewer than 3 students.
  select dept_name as major, count(*) as number_students
  from student
  group by dept_name
  having count(*)<3;
-- 9.  What is the question that this query answers?
select d.dept_name, count(*) as count
from department d left join instructor n on d.dept_name=n.dept_name
group by d.dept_name
order by d.dept_name;


for each department what is the number of instructors in that department?

-- 10.  create a table Schedule2022S with columns 
--     (course_id, sec_id, title, building, room, instructor, time).  
--     Define a multi column primary key of course_id and sec_id columns.
--     Allow columns instructor, building, room, time to be a null value,
--     other columns should not allow null values.
--     Insert the following 2 rows into the table
-- ('CS-363',1,'Intro to Database','BIT','104','Wisneski','T-Th 2-3:50pm')
-- ('CS-498',1,'Independent Study',null,null,'Tao',null )
  


-- 11.  List all departments and the number of students majoring in 
--     that department.  If a department has no majors, show 0.
  select d.dept_name , count(s.ID) as number_majors
  from department as d left join student as s on d.dept_name=s.dept_name


