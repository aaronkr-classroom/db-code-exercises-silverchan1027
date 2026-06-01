/*
 문화센터 예시

 --릴레이션 스키마
    강사(강사번호(PK), 이름, 전문분야,연락처)
    강좌(강좌번호(PK), 강좌명, 수강료, 최대인원, 강사번호(FK))
    회원(회원번호(PK), 이름, 전화번호, 가입일)
    수강신청(회원번호(FK), 강좌번호(FK),신청일)

 --간단한 ERD
    강사 --- 1:N ---강좌 ---- N:M---- 회원 (원본)
    강사 --- 1:N ---강좌 ---- 1:M---- 수강신청 --- N:1 --- 회원

 */

 Create table instructors (
     instructor_id int PRIMARY KEY, --자동 인덱스
     name VARCHAR(30) NOT NULL,
     specialty VARCHAR(50),
     contact VARCHAR(13)
 );

create table classes (
    -- 최대인원 5~50명,check 제약조건 필수
    class_id int PRIMARY KEY,
    class_name VARCHAR(50) NOT NULL,
    fee int check ( fee >= 0),
    max_students int check ( max_students between 5 and 50),
    instructor_id int, --fk
    FOREIGN KEY (instructor_id)
        REFERENCES instructors(instructor_id)
);

create table members (
    member_id int PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    phone VARCHAR(13),
    join_date DATE
);

create table registrations (
    member_id int, --fk
    class_id int, --fk
    registration_date DATE,
    PRIMARY KEY (member_id, class_id),
    FOREIGN KEY (member_id)
        REFERENCES members(member_id)
        on delete cascade, -- 회원이 탈퇴하면 수강신청도 삭제

    FOREIGN KEY (class_id)
        REFERENCES classes(class_id)
        on delete cascade -- 강좌가 폐강되면 수강신청도 삭제
);

insert into instructors values
    (1, '김영희', '요가', '010-1111-1111'),
    (2, '박민수', '드로잉', '010-2222-2222'),
    (3, '이지은', '영어회화', '010-3333-3333');

insert into classes values
    (101, '아침 요가', 50000, 20, 1),
    (201, '수채화 기초', 40000, 15, 2),
    (301, '영어회화', 60000, 25, 3);

insert into members values
    (1001, '홍길동', '010-9999-9999', '2026-03-01'),
    (1002, '김철수', '010-8888-8888', '2026-03-02'),
    (1003, '이영희', '010-7777-7777', '2026-03-03');

insert into registrations values
    (1001, 101, '2026-03-04'),
    (1001, 103, '2026-03-05'),
    (1002, 101, '2026-03-06'),
    (1003, 102, '2026-03-07');


--join
select m.name, c.class_name
from registrations r
join members m on r.member_id = m.member_id
join classes c on r.class_id = c.class_id;

--INDEX
--members에서 100,000명 추가


create table members2 (
                         member_id serial PRIMARY KEY,
                         name VARCHAR(30) NOT NULL,
                         phone VARCHAR(13),
                         join_date DATE
);

INSERT INTO members (name, phone, join_date)
SELECT
    'Member_' || g,
    '010-' ||
    lpad((random() * 9999)::int::text, 4, '0') ||
    '-' ||
    lpad((random() * 9999)::int::text, 4, '0'),
    current_date - ((random() * 1000)::int)
FROM generate_series(1, 100000) g;

-- INDEX
-- members에서 100,000명 추가
drop table members2;

CREATE TABLE members2 (
                          member_id SERIAL PRIMARY KEY, -- 자동 인덱스
                          name VARCHAR(30) NOT NULL,
                          phone VARCHAR(13),
                          join_date DATE
);


tABLE members2;

-- 검색 시간 확인하기
EXPLAIN ANALYZE
SELECT * FROM members2
WHERE name = '홍길동';
-- Planning Time: 0.052s
-- Execution Time: 11.921ms

-- INDEX 추가
CREATE TABLE idx_members_name ON members2(name);

-- VIEW 추가
CREATE VIEW registration_view AS
SELECT
    m.name AS 회원명,
    c.class_name AS 강좌명,
    r.register_date AS 신청일
FROM registrations r
         JOIN members m ON r.member_id = m.member_id
         JOIN classes c ON r.class_id = c.class_id;

SELECT * FROM registration_view;








