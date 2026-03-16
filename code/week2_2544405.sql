create DATABASE ut;

create table animals(
	id bigserial,
	name varchar(20),
	age integer,
	kind varchar(20),
	dob date,	location varchar(50)
);

table animals;
insert into animals ( name, age, kind, dob, location)
values('Cat', 45 , 'tiger', '2010-10-10', 'Seoul, korea'),
	('poch', 13, 'beer', '1931-01-03','England'),
	('Togo', 13, 'dog','1897-12-13','Alaska, USA'),
	('Michaelangelo', 12, 'turtle', '1981-04-05', 'USA'),
	('Baghera', 27, 'panther', '1881-12-12', 'England');