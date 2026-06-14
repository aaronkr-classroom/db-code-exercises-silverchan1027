-- 2026학년도 1학기 데이터베이스 설계 및 구현 기말 프로젝트
-- 여행사 데이터베이스 구현

DROP TABLE IF EXISTS assign_bus;
DROP TABLE IF EXISTS assign_driver;
DROP TABLE IF EXISTS reserve;
DROP TABLE IF EXISTS tour;
DROP TABLE IF EXISTS driver;
DROP TABLE IF EXISTS tour_bus;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS task_code;
DROP TABLE IF EXISTS class_code;

-- =========================
-- 1. 코드 테이블
-- =========================

CREATE TABLE class_code (
                            code INT PRIMARY KEY,
                            class VARCHAR(10) NOT NULL,
                            basis VARCHAR(20)
);

CREATE TABLE task_code (
                           code INT PRIMARY KEY,
                           task VARCHAR(30) NOT NULL
);

-- =========================
-- 2. 기본 테이블
-- =========================

CREATE TABLE customer (
                          cus_id VARCHAR(15) PRIMARY KEY,
                          name VARCHAR(20) NOT NULL,
                          cell CHAR(13) NOT NULL UNIQUE,
                          addr VARCHAR(100),
                          c_code INT DEFAULT 3 NOT NULL,
                          FOREIGN KEY (c_code) REFERENCES class_code(code),
                          CONSTRAINT chk_customer_class CHECK (c_code IN (1, 2, 3))
);

CREATE TABLE staff (
                       staff_id INT PRIMARY KEY,
                       name VARCHAR(20) NOT NULL,
                       birthday CHAR(6) NOT NULL,
                       tel CHAR(13),
                       salary INT NOT NULL,
                       t_code INT NOT NULL,
                       hire_date CHAR(8) NOT NULL,
                       FOREIGN KEY (t_code) REFERENCES task_code(code),
                       CONSTRAINT chk_staff_salary CHECK (salary > 0),
                       CONSTRAINT chk_staff_task CHECK (t_code IN (1, 2, 3, 4, 5))
);

CREATE TABLE tour (
                      tour_num CHAR(8) PRIMARY KEY,
                      departure VARCHAR(50) NOT NULL,
                      arrival VARCHAR(50) NOT NULL,
                      program VARCHAR(100),
                      start_dt TIMESTAMP NOT NULL,
                      end_dt TIMESTAMP NOT NULL,
                      min_num INT NOT NULL,
                      max_num INT NOT NULL,
                      expense INT NOT NULL,
                      deposit INT NOT NULL,
                      dept_yn CHAR(1) DEFAULT 'N' NOT NULL,
                      staff_id INT,
                      FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
                      CONSTRAINT chk_tour_people CHECK (min_num > 0 AND max_num >= min_num),
                      CONSTRAINT chk_tour_fee CHECK (expense > 0 AND deposit >= 0),
                      CONSTRAINT chk_tour_dept CHECK (dept_yn IN ('Y', 'N'))
);

CREATE TABLE reserve (
                         cus_id VARCHAR(15),
                         tour_num CHAR(8),
                         res_date DATE DEFAULT CURRENT_DATE,
                         dep_yn CHAR(1) DEFAULT 'N' NOT NULL,
                         exp_yn CHAR(1) DEFAULT 'N' NOT NULL,
                         PRIMARY KEY (cus_id, tour_num),
                         FOREIGN KEY (cus_id) REFERENCES customer(cus_id),
                         FOREIGN KEY (tour_num) REFERENCES tour(tour_num),
                         CONSTRAINT chk_reserve_dep CHECK (dep_yn IN ('Y', 'N')),
                         CONSTRAINT chk_reserve_exp CHECK (exp_yn IN ('Y', 'N'))
);

-- =========================
-- 3. 보너스 테이블
-- =========================

CREATE TABLE driver (
                        driver_id INT PRIMARY KEY,
                        name VARCHAR(20) NOT NULL,
                        birthday CHAR(6) NOT NULL,
                        cell CHAR(13) NOT NULL,
                        pay INT DEFAULT 15000 NOT NULL,
                        cont_date CHAR(8),
                        cont_term VARCHAR(10),
                        CONSTRAINT chk_driver_pay CHECK (pay > 0)
);

CREATE TABLE tour_bus (
                          bus_id INT PRIMARY KEY,
                          seat INT NOT NULL,
                          del_year INT,
                          CONSTRAINT chk_bus_seat CHECK (seat > 0)
);

CREATE TABLE assign_driver (
                               tour_num CHAR(8) PRIMARY KEY,
                               driver_id INT NOT NULL,
                               work_hour INT,
                               FOREIGN KEY (tour_num) REFERENCES tour(tour_num),
                               FOREIGN KEY (driver_id) REFERENCES driver(driver_id),
                               CONSTRAINT chk_work_hour CHECK (work_hour >= 0)
);

CREATE TABLE assign_bus (
                            tour_num CHAR(8) PRIMARY KEY,
                            bus_id INT NOT NULL,
                            FOREIGN KEY (tour_num) REFERENCES tour(tour_num),
                            FOREIGN KEY (bus_id) REFERENCES tour_bus(bus_id)
);

-- =========================
-- 4. 초기 데이터
-- =========================

INSERT INTO class_code VALUES
                           (1, '최우수', '6회 이상'),
                           (2, '우수', '3~5회'),
                           (3, '일반', '3회 미만');

INSERT INTO task_code VALUES
                          (1, '여행상품관리'),
                          (2, '예약관리'),
                          (3, '관광버스배차관리'),
                          (4, '직원관리'),
                          (5, '고객관리');

INSERT INTO customer VALUES
                         ('C001', '김철수', '010-1111-1111', '서울시 강남구', 1),
                         ('C002', '이영희', '010-2222-2222', '부산시 해운대구', 2),
                         ('C003', '박민수', '010-3333-3333', '대구시 수성구', 3),
                         ('C004', '최지은', '010-4444-4444', '인천시 연수구', 1),
                         ('C005', '정수민', '010-5555-5555', '광주시 북구', 2);

INSERT INTO staff VALUES
                      (2001, '김대리', '880312', '010-9001-0001', 3800000, 1, '20200301'),
                      (2002, '박과장', '830721', '010-9002-0002', 4500000, 2, '20180615'),
                      (2003, '이주임', '921105', '010-9003-0003', 3200000, 3, '20220110'),
                      (2004, '최부장', '790930', '010-9004-0004', 5800000, 4, '20150901'),
                      (2005, '정사원', '980518', '010-9005-0005', 2800000, 5, '20240201');

INSERT INTO tour VALUES
                     ('T0000001', '서울', '부산', '부산 해운대 2박3일 여행', '2026-07-01 08:00:00', '2026-07-03 20:00:00', 10, 40, 450000, 100000, 'Y', 2001),
                     ('T0000002', '서울', '제주', '제주도 힐링 패키지', '2026-07-10 09:00:00', '2026-07-13 18:00:00', 8, 30, 780000, 200000, 'Y', 2002),
                     ('T0000003', '대전', '강릉', '강릉 바다 여행', '2026-08-05 07:30:00', '2026-08-07 19:00:00', 12, 35, 390000, 80000, 'N', 2003),
                     ('T0000004', '부산', '경주', '경주 문화유산 투어', '2026-08-15 08:30:00', '2026-08-16 21:00:00', 15, 45, 320000, 70000, 'Y', 2004),
                     ('T0000005', '서울', '전주', '전주 한옥마을 먹거리 여행', '2026-09-01 09:00:00', '2026-09-02 20:00:00', 6, 25, 250000, 50000, 'N', 2005);

INSERT INTO reserve VALUES
                        ('C001', 'T0000001', '2026-06-01', 'Y', 'Y'),
                        ('C002', 'T0000001', '2026-06-02', 'Y', 'N'),
                        ('C003', 'T0000002', '2026-06-05', 'Y', 'Y'),
                        ('C004', 'T0000003', '2026-06-10', 'N', 'N'),
                        ('C005', 'T0000004', '2026-06-15', 'Y', 'Y');

INSERT INTO driver VALUES
                       (3001, '강기사', '800101', '010-7001-0001', 15000, '20260101', '12개월'),
                       (3002, '문기사', '820202', '010-7002-0002', 16000, '20260201', '12개월'),
                       (3003, '신기사', '850303', '010-7003-0003', 15000, '20260301', '6개월'),
                       (3004, '오기사', '780404', '010-7004-0004', 17000, '20260401', '12개월'),
                       (3005, '한기사', '900505', '010-7005-0005', 15000, '20260501', '6개월');

INSERT INTO tour_bus VALUES
                         (1, 40, 2020),
                         (2, 45, 2021),
                         (3, 35, 2019),
                         (4, 30, 2022),
                         (5, 25, 2023);

INSERT INTO assign_driver VALUES
                              ('T0000001', 3001, 20),
                              ('T0000002', 3002, 25),
                              ('T0000003', 3003, 18),
                              ('T0000004', 3004, 15),
                              ('T0000005', 3005, 12);

INSERT INTO assign_bus VALUES
                           ('T0000001', 1),
                           ('T0000002', 2),
                           ('T0000003', 3),
                           ('T0000004', 4),
                           ('T0000005', 5);

-- =========================
-- 5. INDEX 생성
-- =========================

CREATE INDEX tour_arrival_idx ON tour(arrival);
CREATE INDEX driver_name_idx ON driver(name);
CREATE INDEX reserve_customer_idx ON reserve(cus_id);
CREATE INDEX reserve_tour_idx ON reserve(tour_num);

-- =========================
-- 6. 필수 테스트 SQL
-- =========================

-- 1. 고객 등급 검색
SELECT
    customer.cus_id,
    customer.name,
    class_code.class
FROM customer
         JOIN class_code
              ON customer.c_code = class_code.code
WHERE customer.cus_id = 'C001';

-- 2. 직원 담당업무 검색
SELECT
    staff.staff_id,
    staff.name,
    task_code.task
FROM staff
         JOIN task_code
              ON staff.t_code = task_code.code
WHERE staff.staff_id = 2001;

-- 3. 여행상품 예약 고객 검색
SELECT
    tour.tour_num,
    tour.program,
    customer.name,
    reserve.res_date,
    reserve.dep_yn
FROM reserve
         JOIN customer
              ON reserve.cus_id = customer.cus_id
         JOIN tour
              ON reserve.tour_num = tour.tour_num
WHERE tour.tour_num = 'T0000001';

-- 4. 여행상품 배정 운전기사 검색
SELECT
    tour.tour_num,
    tour.departure,
    driver.name,
    driver.cell
FROM tour
         JOIN assign_driver
              ON tour.tour_num = assign_driver.tour_num
         JOIN driver
              ON assign_driver.driver_id = driver.driver_id
WHERE tour.tour_num = 'T0000001';

-- 5. 신규 고객 등록
INSERT INTO customer
VALUES
    ('C006', '한소희', '010-6666-6666', '제주시 애월읍', 3);

SELECT *
FROM customer
WHERE cus_id = 'C006';

-- 6. 직원 급여 수정
UPDATE staff
SET salary = salary + 200000
WHERE staff_id = 2001;

SELECT *
FROM staff
WHERE staff_id = 2001;

-- 7. 예약 정보 삭제
DELETE FROM reserve
WHERE cus_id = 'C002'
  AND tour_num = 'T0000001';

SELECT *
FROM reserve
WHERE cus_id = 'C002'
  AND tour_num = 'T0000001';

-- =========================
-- 7. 추가 확인용 SELECT
-- =========================

TABLE class_code;
TABLE task_code;
TABLE customer;
TABLE staff;
TABLE tour;
TABLE reserve;
TABLE driver;
TABLE tour_bus;
TABLE assign_driver;
TABLE assign_bus;

SELECT *
FROM pg_indexes
WHERE tablename IN ('tour', 'driver', 'reserve');

-- =========================
-- 8. 전체 삭제용 SQL
-- =========================

-- DROP TABLE IF EXISTS assign_bus;
-- DROP TABLE IF EXISTS assign_driver;
-- DROP TABLE IF EXISTS reserve;
-- DROP TABLE IF EXISTS tour;
-- DROP TABLE IF EXISTS driver;
-- DROP TABLE IF EXISTS tour_bus;
-- DROP TABLE IF EXISTS staff;
-- DROP TABLE IF EXISTS customer;
-- DROP TABLE IF EXISTS task_code;
-- DROP TABLE IF EXISTS class_code;