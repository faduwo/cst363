-- homework 5.sql
-- The tables used in this exercise come from 'courses-small.sql';
-- Unless specified otherwise, the result should be ordered by the first column of the result.

-- 1.  Find the department(s)  with the most students. 
--     Return department name and the count of students labeled as "students" 
--     Your should find that Comp. Sci. has the most students with 4.
select dept_name, 
	(select count(*) 
		from student 
		where department.dept_name = student.dept_name)
	as students
from department
order by students desc
limit 1;

-- 2.  Find all students in the Comp. Sci. department 
--     with more than 90 credits (column "tot_cred" in student table).
--     Return the student ID and name.
--     Answer: there is one student  00128, Zhang
select ID, name
from student
where dept_name in('Comp. Sci.') and tot_cred > 90;

-- 3.  Find courses that have not been taken by any student Return the course_id.
--     Hint: use NOT EXISTS or NOT IN predicate. 
--     Answer: BIO-399 has not been taken by any students.
select course_id
from course
where (course_id) not in (select course_id
							from takes);

-- 4.  Do #3 in another way that uses a join.
select course.course_id
from course left join takes on course.course_id = takes.course_id
where takes.ID is null;

-- 5.  Find the courses taken by students from query #2.  
--     Return the course_id and title.  List each course only once. 
--     Use a subquery and your select statement from #2.
--     The answers will be CS-101 and CS-347
select takes.course_id, title
from takes join course on takes.course_id = course.course_id
where (ID) in (select ID
					from student
					where dept_name in('Comp. Sci.') and tot_cred > 90)
;

-- 6.  Find students who passed a 4 credit course (course.credits=4)
--     A passing grade is A+, A, A-, B+, B, B-, C+, C, C-.
--     Use a subquery. 
--     Return student ID and name ordered by student name.
--     The answer will have 8 students.
select distinct student.ID, student.name
from takes join course using(course_id) join student using(ID)
where (grade != 'F'and grade is not null) and takes.course_id in (select course_id from course where credits = 4)

order by student.ID;

-- 7.  Find the course(s) taken by the most students.  Return columns 
--     course_id, title,  enrollment (the count of students that have taken the course)
--     The answer is CS-101 with an enrollment of 7
select course_id, title, 
		(select count(*) 
                from takes 
                where course.course_id = takes.course_id)
             as enrollment
from course
order by enrollment desc
limit 1;

-- 8.  create a view named "vcourse" showing columns course_id, title, credits, enrollment
--     If no students have taken the course, the enrollment should be 0.
create view vcourse as
select distinct course.course_id, course.title, course.credits, (select count(*) 
                from takes 
                where course.course_id = takes.course_id)
             as enrollment
from course left join takes on course.course_id = takes.course_id;

select * from vcourse;
drop view vcourse;
-- 9. Use the view to display to the course(s) with highest enrollment.
--    Return course_id, title, enrollment 
--    Answer is same as #7.
select course_id, title, enrollment 
from vcourse
order by enrollment desc
limit 1;

-- 10. Update the tot_cred column in the student table by calculating the actual total credits 
--     based on a passing grade and the credits given for the course (course.credits column)
--     A passing grade is given in problem #4.
--     If the student has not taken any course, then the sum will be null.
--     Use the IFNULL function to set tot_cred to the value 0 instead of null.
--     complete the update statement.
update student set tot_cred =( select ifnull(sum(course.credits), 0) 
								from takes join course on takes.course_id = course.course_id
								where student.ID=takes.ID);

-- 11. Return id, name and tot_cred of all students ordered by id;
--     Number 10 is correct if Zhang has 7 total credits, Shankar has 14, Brandt has 3 and Snow has 0.
select ID, name, tot_cred from student;
     
     
-- 12.  List the instructor(s) (ID, name) who advise the most students
--      Answer:  Einstein, Katz and Kim  advise the most students.
with adv_total as
        (select count(s_ID) as total
         from advisor
         group by i_ID),        
adv_max as
       (select max(total) as max
        from adv_total)
select distinct instructor.ID, instructor.name, (select count(*)
										from advisor where instructor.ID = advisor.i_ID)
								as num_of_students
from instructor, adv_total, adv_max
where (select count(*)
	   from advisor 
       where instructor.ID = advisor.i_ID) = adv_max.max;

-- 13. List the course_id and title for courses that are offered both in Fall 2009 and in Spring 2010.
--     A correct answers shows that CS-101 is the only course offered both semesters.
select section.course_id, course.title
from section join course on section.course_id = course.course_id
where semester = 'Fall' and year = 2009 
and section.course_id in (select section.course_id
from section
where semester = 'Spring' and year= 2010);

