-- User, Game, Item, Play, UserItem
CREATE TABLE users (
                       user_id INT PRIMARY KEY,
                       user_name VARCHAR(30) NOT NULL,
                       nickname VARCHAR(30) NOT NULL,
                       user_level INT,
                       join_date DATE
);

CREATE TABLE games (
                       game_id INT PRIMARY KEY,
                       game_name VARCHAR(50) NOT NULL,
                       genre VARCHAR(20),
                       release_date DATE
);

CREATE TABLE items (
                       item_id INT PRIMARY KEY,
                       item_name VARCHAR(30),
                       price INT,
                       grade CHAR -- 'S'
);

CREATE TABLE plays (
                       user_id INT,
                       game_id INT,
                       start_date DATE,
                       play_time INT, -- 시작: Time.now(), 현재: Time.now()
    -- Time.now() = 176864523 - 176854321 = 10202 / 3600
                       PRIMARY KEY (user_id, game_id),
                       FOREIGN KEY (user_id) REFERENCES users(user_id),
                       FOREIGN KEY (game_id) REFERENCES games(game_id)
);

CREATE TABLE user_items (
                            user_id INT,
                            item_id INT,
                            acquired_date DATE,
                            quantity INT,
                            PRIMARY KEY (user_id, item_id),
                            FOREIGN KEY (user_id) REFERENCES users(user_id),
                            FOREIGN KEY (item_id) REFERENCES items(item_id)
);

TABLE users;
TABLE games;
TABLE items;
TABLE plays;
TABLE user_items;

-- INSERT VALUES
INSERT INTO users VALUES
                      (1, '김민준', 'DragonKing', 15, '2024-03-01'),
                      (2, '이서연', 'StarMage', 22, '2024-03-15'),
                      (3, '박지훈', 'DarkKnight', 8, '2024-04-05'),
                      (4, '최유진', 'HealerQueen', 34, '2024-06-11'),
                      (5, '정도윤', 'FastArcher', 17, '2024-11-11');

INSERT INTO games VALUES
                      (101, 'Super Mario RPG', 'RPG', '2021-01-01'),
                      (102, 'Gran Turismo', 'Racing', '2019-12-31'),
                      (103, 'Puzzle Bobble', 'Puzzle', '2022-07-14');

INSERT INTO items VALUES
                      (1001, '강철검', 5000, 'B'),
                      (1002, '마법지팡이', 12000, 'A'),
                      (1003, '회복포션', 500, 'C'),
                      (1004, '황금방패', 20000, 'S'),
                      (1005, '불꽃활', 15000, 'A');

INSERT INTO plays VALUES
                      (1, 101, '2024-03-23', 120),
                      (2, 101, '2021-03-21', 97),
                      (3, 102, '2024-05-05', 500),
                      (4, 101, '2024-03-21', 140),
                      (5, 103, '2019-12-31', 1000);

INSERT INTO user_items VALUES
                           (1, 1001, '2024-03-23', 1),
                           (2, 1003, '2021-03-21', 2),
                           (3, 1002, '2024-05-05', 5),
                           (4, 1004, '2024-03-21', 4),
                           (5, 1005, '2019-12-31', 10);

TABLE users;
TABLE games;
TABLE items;
TABLE plays;
TABLE user_items;

-- 기본 조회 연습
-- 1. 전체 유저 조회
SELECT * FROM users;

-- 2. 레벨 높은 순서로 조회
SELECT * FROM users
ORDER BY user_level DESC;

-- 3. 레벨이 10 이상인 유저 조회
SELECT * FROM users
WHERE user_level >= 10;

-- 4. 'S' 등급 아이템 조회
SELECT * FROM items
WHERE grade = 'S';

-- 테이블 수정할 때 (ALTER TABLE)
-- 1. 게임 회사에서 유저의 이메일도 저장하기로 했다.
ALTER TABLE users
    ADD COLUMN email VARCHAR(50);
TABLE users;

-- 2. 유저에게 현재 접속 상태를 저장해야 한다.
ALTER TABLE users
    ADD COLUMN status VARCHAR(10) DEFAULT 'offline';
TABLE users;

-- 3. 아이템 테이블에 판매 가능 여부를 추가해야 한다.
ALTER TABLE items
    ADD COLUMN is_sellable BOOLEAN DEFAULT TRUE;
TABLE items;

-- 4. 게임 테이블에 게임 등급 정보를 추가해야 한다.
ALTER TABLE games
    ADD COLUMN age_rating VARCHAR(10);
TABLE games;

-- 테이블에 있는 값이 변경할 때 (UPDATE)
-- 1. 김민준 유저의 이메일을 추가합니다.
UPDATE users
SET email = 'minjun@email.com'
WHERE user_id = 1;

-- 2. 이서연 유저의 레벨이 25로 올랐다.
UPDATE users
SET user_level = 25
WHERE user_id = 2;

-- 3. 모든 유저의 기본 접속 상태를 online으로 설정한다.
UPDATE users
SET status = 'online';

-- 4. DragonKing 유저가 현재 연결 중이다.
UPDATE users
SET status = 'connecting'
WHERE nickname = 'DragonKing';

-- 5. 회복포션의 가격을 700으로 변경한다.
UPDATE items
SET price = 700
WHERE item_name = '회복포션';

-- 6. Gran Turismo의 이용 가능 연령을 12세 이상으로 설정한다.
UPDATE games
SET age_rating = '12+'
WHERE game_id = 102;

-- 주의 설명
-- DELETE는 데이터를 삭제한다.
-- DROP TABLE은 테이블 자체를 삭제한다.
-- ALTER TABLE은 테이블 구조를 변경한다.
-- UPDATE는 기존 데이터를 수정한다.

select user_level from users;

-- check 유저 레벨은 1~100만 가능하다
alter table users
ADD CONSTRAINT chk_user_level
check (user_level >= 1 AND user_level <= 100);


update users
set user_level = 100
where user_id =1;


update users
set user_level = 101
where user_id =1;

-- 2. 접속 상태는 온라인 또는 오프라인 만 가능하다
alter table users
add constraint chk_user_staus
check (status in ('online','offline', 'connecting'));

ALTER TABLE users
    DROP CONSTRAINT chk_user_staus;

table users;

select status from users;

update users
set status = 'sleeping'
where user_id = 2;

--3. 아이템 가격은 0 원 이상이여야한다.
select price from items;

alter table items
add constraint chk_item_price
check (price >= 0);

update items
set price = -10
where item_id = 1001;

--4. 아이템 등급을 정해진 값만 가능하다 (s,a,b,c,d,e,f)
select grade from items;

alter table items
add constraint chek_item_grade
check (grade in ('S','A','B','C','D','E','F'))

--5. 닉네임은 중복되면 안 된다.
alter table users
add constraint uq_user_nickname
unique (nickname);

insert into users values
(6,'앙은찬','dragonKing','11','2026-05-18','home@home.com','offline')

select * from users;

--
select constraint_NAME, TABLE_NAME
from information_schema.table.CONSTRAINTS
where CONSTRAINT_TYPE = 'FOREIGN KEY'
AND table_NAME = 'plays';

--plays_user_ide_fkey
--plays_game_id_fkey
--user_items_user_id_fkey
--user_items_item_id_fkey

select constraint_NAME, TABLE_NAME
from information_schema.table.CONSTRAINTS
where CONSTRAINT_TYPE = 'FOREIGN KEY'
  AND table_NAME = 'plays';

--plays_user_ide_fkey
--plays_game_id_fkey
--user_items_user_id_fkey
--user_items_item_id_fkey
-- 기존 FK 삭제

ALTER TABLE plays
    DROP CONSTRAINT plays_user_id_fkey;

ALTER TABLE plays
    DROP CONSTRAINT plays_game_id_fkey;

ALTER TABLE user_items
    DROP CONSTRAINT user_items_user_id_fkey;

ALTER TABLE user_items
    DROP CONSTRAINT user_items_item_id_fkey;

-- 새 FK 추가

-- 1. 유저가 삭제되면 플레이 기록도 삭제되게 하기

ALTER TABLE plays
    ADD CONSTRAINT fk_plays_users
        FOREIGN KEY (user_id)
            REFERENCES users(user_id)
            ON DELETE CASCADE;

-- 2. 게임은 플레이 기록이 있으면 삭제하지 못하게 하기

ALTER TABLE plays
    ADD CONSTRAINT fk_plays_games
        FOREIGN KEY (game_id)
            REFERENCES games(game_id)
            ON DELETE RESTRICT;

-- 3. 유저가 삭제되면 보유 아이템 기록도 삭제

ALTER TABLE user_items
    ADD CONSTRAINT fk_user_items_users
        FOREIGN KEY (user_id)
            REFERENCES users(user_id)
            ON DELETE CASCADE;

-- 4. 아이템을 누군가 보유 중이면 삭제하지 못하게 하기

ALTER TABLE user_items
    ADD CONSTRAINT fk_user_items_items
        FOREIGN KEY (item_id)
            REFERENCES items(item_id)
            ON DELETE RESTRICT;

-- CASCADE 테스트

SELECT * FROM plays
WHERE user_id = 1;

SELECT * FROM user_items
WHERE user_id = 1;

DELETE FROM users
WHERE user_id = 1;

-- RESTRICT 테스트

SELECT * FROM games;

DELETE FROM games
WHERE game_id = 101;

DELETE FROM items
WHERE item_id = 1001;
