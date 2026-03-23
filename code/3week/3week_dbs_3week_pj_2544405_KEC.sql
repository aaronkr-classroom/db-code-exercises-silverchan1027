--3week 과제

/*
[Entities]
- Buildings (건물)
- Clubs (동아리)

[Buildings Properties]
- id (SERIAL)
- name (TEXT)
- location (TEXT)

[Clubs Properties]
- id (SERIAL)
- name (TEXT)
- category (TEXT)
- building_id (INT)
- member_count (INT)
*/

-- 1. 건물 테이블 생성
CREATE TABLE buildings (
    id SERIAL PRIMARY KEY, -- PostgreSQL에서는 SERIAL이 자동 증가를 의미한다-구글링했습니
    name VARCHAR(50) NOT NULL,
    location VARCHAR(100)
);

-- 2. 동아리 테이블 생성
CREATE TABLE clubs (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    category VARCHAR(30),
    building_id INT,
    member_count INT DEFAULT 0,
    -- 외래키 설정
    CONSTRAINT fk_building 
        FOREIGN KEY (building_id) 
        REFERENCES buildings(id)
);

-- 건물 데이터 입력
INSERT INTO buildings (name, location) VALUES 
('학생회관', '캠퍼스 서측'),
('공학관', '캠퍼스 북측'),
('본관', '캠퍼스 중앙');

-- 동아리 데이터 입력 (총 5개)
INSERT INTO clubs (name, category, building_id, member_count) VALUES 
('데브코리아', 'IT/학술', 2, 25),
('울림밴드', '음악/공연', 1, 15),
('슛돌이', '체육', 1, 30),
('캔버스', '예술', 1, 12),
('알고리즘 정복', 'IT/학술', 2, 20);

-- 1 전체 조회 (Join 활용)
-- 동아리 정보와 그 동아리가 있는 건물 이름을 함께 확인
SELECT c.name AS 동아리명, c.category, b.name AS 건물명
FROM clubs c
JOIN buildings b ON c.building_id = b.id;

-- 2 정렬 (ORDER BY)
-- 인원수(member_count)가 많은 순서대로 동아리 정렬
SELECT * FROM clubs 
ORDER BY member_count DESC;

-- 3 조건 검색 (WHERE)
-- 'IT/학술' 카테고리에 속하는 동아리만 검색
SELECT name, category, member_count 
FROM clubs 
WHERE category = 'IT/학술';

 
