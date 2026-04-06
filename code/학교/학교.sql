-- 디비다이어그램.io를 위해 수정하기 

--학교_dbdiagram.sql
table Professor{
	Professor_id int [pk]
	Professor_name varchar(30)
	department varchar(100)
	salary numeric
	salary_level numeric
	hire_date date
}


table student{
	student_id int [pk]
	student_name varchar(100)
	major varchar(100)
}

table Course{
	course_id int
	section_id int
	professor_id int
	course_name varchar(100)
	indexes{
		(course_id,scetion_id)[pk]
	}
}

table Enrollment{
	student_id int
	course_id int
	grade varchar(2)
	points numeric
	enrolled_at DATE
	indexs{
		(student_id,course_id)
	}
}

ref: Enrollment.studeunt_id > Student.student_id
ref: Course.professor_id > Professor.professor_id