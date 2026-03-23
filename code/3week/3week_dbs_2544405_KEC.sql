select * from animals;


select  * from prof;

insert into prof (name, dept, salary, salary_level, hire_date)
values('김정은','컴퓨터공학', 10000, 1, '1990-12-31'),
	('고다','컴퓨터공학', 20000, 3, '1999-09-11'),
	('김니엘','컴퓨터공학', 3000000, 2, '1999-05-13'),
	('고다니엘','소프트웨어', 700000, 4, '2001-12-31'),
	('정석호','소프트웨어', 1000000, 4, '2001-03-31');



SELECT name, salary FROM prof;
SELECT name, salary FROM prof ORDER BY salary DESC; -- ASC
SELECT name, salary FROM prof WHERE salary > 90000;
SELECT name, salary FROM prof WHERE name LIKE '김%'; -- PostgresSQL ILIKE 대/소문자 상관없음
SELECT name, dept FROM prof 
   WHERE dept LIKE '%공%'
   ORDER BY dept ASC; -- DESC / ASC
   
SELECT name, salary FROM prof WHERE salary between 40000 and 1200000;
 
