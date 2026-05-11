# **Chp 8 Exercise**

# **수업 실습 예제: 게임 관리 데이터베이스**

## **1\. 요구사항**

게임 회사는 유저, 게임, 아이템, 유저의 아이템 보유 내역을 관리하려고 한다.

요구사항은 다음과 같다.

1. 유저는 유저ID, 이름, 닉네임, 레벨, 가입일 정보를 가진다.  
2. 게임은 게임ID, 게임명, 장르, 출시일 정보를 가진다.  
3. 아이템은 아이템ID, 아이템명, 가격, 등급 정보를 가진다.  
   1. 한 유저는 여러 게임을 플레이할 수 있다. (m:n)  
   2. 한 게임은 여러 유저가 플레이할 수 있다. (m:n)  
   3. 유저가 게임을 플레이한 시작일과 총 플레이 시간을 저장한다.  
      1. 한 유저는 여러 아이템을 가질 수 있다. (m:n)  
      2. 하나의 아이템은 여러 유저가 가질 수 있다. (m:n)  
      3. 유저가 아이템을 획득한 날짜와 수량을 저장한다.

---

# **2\. 엔티티와 속성**

## **유저(User)**

속성: 설명

1. user\_id \- PK  
2. user\_name \-  
3. nickname \-  
4. user\_level \-  
5. join\_date \- 

## **게임(Game)**

속성: 설명

1. game\_id \- PK  
2. game\_name   
3. genre  
4. release\_date

## **아이템(Item)**

속성: 설명

1. item\_id \- PK  
2. item\_name  
3. item\_price  
4. item\_grade

# **3\. 관계 정리**

| 관계 | 관계 유형 | 변환 방법 |
| :---- | :---- | :---- |
| 유저:게임 | m:n | 새로운 개체 Play 테이블 생성 |
| 유저:아이템 | m:n | 새로운 개체 UserItem 테이블 |

핵심 설명:

M:N 관계는 직접 테이블로 표현할 수 없으므로 중간 테이블을 만든다.

# **2b. 새로운 엔티티와 속성**

## **Play**

속성: 설명

1. user\_id \- FK  
2. game\_id \- FK  
3. start\_date  
4. play\_time

## **UserItem**

속성: 설명

1. user\_id \- FK  
2. item\_id \- FK  
3. acquired\_date   
4. quantity

# **4\. 릴레이션 스키마**

User( user\_id, user\_name, nickname, user\_level, join\_date )

Game( game\_id, game\_name, genre, release\_date )

Item( item\_id, item\_name, item\_price, item\_grade)

Play( user\_id (FK), game\_id (FK), start\_date, play\_time )

UserItem( user\_id (FK), item\_id (FK), acquired\_date, quantity )

# **5\. 최초 테이블 생성 SQL**

*CREATE TABLE* users (  
                      user\_id *INT PRIMARY KEY*,  
                      *name VARCHAR*(30) *NOT NULL*,  
                      nickname *VARCHAR*(30) *NOT NULL*,  
                      user\_level *INT*,  
                      join\_date *DATE*  
);

*CREATE TABLE* games (  
                      game\_id *INT PRIMARY KEY*,  
                      game\_name *VARCHAR*(50) *NOT NULL*,  
                      genre *VARCHAR*(20),  
                      release\_date *DATE*  
);

*CREATE TABLE* items (  
                      item\_id *INT PRIMARY KEY*,  
                      item\_name *VARCHAR*(30),  
                      price *INT*,  
                      grade *CHAR*(1)  
);

*CREATE TABLE* plays (  
                      user\_id *INT*,  
                      game\_id *INT*,  
                      start\_date *DATE*,  
                      play\_time *INT*,  
                      *PRIMARY KEY* (user\_id, game\_id),  
                      *FOREIGN KEY* (user\_id) *REFERENCES* users(user\_id),  
                      *FOREIGN KEY* (game\_id) *REFERENCES* games(game\_id)  
);

*CREATE TABLE* user\_items (  
                           user\_id *INT*,  
                           item\_id *INT*,  
                           acquired\_date *DATE*,  
                           quantity *INT*,  
                           *PRIMARY KEY* (user\_id, item\_id),  
                           *FOREIGN KEY* (user\_id) *REFERENCES* users(user\_id),  
                           *FOREIGN KEY* (item\_id) *REFERENCES* items(item\_id)  
);

# **6\. 데이터 입력**

*INSERT INTO* users *VALUES*  
                     (1,'김민준','dragonking',15,'2024-03-01'),  
                     (2,'이서연','starmage',22,'2024-03-15'),  
                     (3,'박지훈','darkknight',8,'2024-04-05'),  
                     (4,'최유진','healerqueen',34,'2024-06-11'),  
                     (5,'정도윤','fastarcher',17,'2024-11-11');

*INSERT INTO* games *VALUES*  
                     (101,'supermarioRPG','RPG','2021-01-01'),  
                     (102,'granTurismo','racing','2019-12-31'),  
                     (103,'puzzlebobble','puzzle','2022-07-14');

*INSERT INTO* items *VALUES*  
                     (1001,'강철검',5000,'B'),  
                     (1002,'마법지팡이',12000,'A'),  
                     (1003,'회복포션',500,'B'),  
                     (1004,'황금방패',20000,'S'),  
                     (1005,'불꽃활',15000,'A');

*INSERT INTO* plays *VALUES*  
                     (1,101,'2024-03-23',120),  
                     (2,101,'2024-03-21',97),  
                     (3,102,'2024-05-05',500),  
                     (4,101,'2024-03-21',140),  
                     (5,103,'2019-12-31',1000);

*INSERT INTO* user\_items *VALUES*  
                          (1,1001,'2024-03-23',1),  
                          (2,1001,'2024-03-21',2),  
                          (3,1002,'2024-05-05',5),  
                          (4,1001,'2024-03-21',4),  
                          (5,1003,'2019-12-31',10);

*\-- 1\. 전체 유저 조회*  
*SELECT \* FROM* users;

*\-- 2\. 레벨 높은 순서로 조회*  
*SELECT \* FROM* users  
*ORDER BY* user\_level *DESC*;

*\-- 3\. 레벨이 10 이상인 유저 조회*  
*SELECT \* FROM* users  
*WHERE* user\_level \>= 10;

*\-- 4\. 'S' 등급 아이템 조회*  
*SELECT \* FROM* items  
*WHERE* grade \= 'S';

*\-- ALTER TABLE 연습*  
*\-- 1\. 유저 이메일 추가*  
*ALTER TABLE* users *ADD COLUMN* email *VARCHAR*(100);

*\-- 2\. 현재 접속 상태 추가*  
*ALTER TABLE* users *ADD COLUMN* status *VARCHAR*(20);

*\-- 3\. 아이템 판매 가능 여부 추가*  
*ALTER TABLE* items *ADD COLUMN* is\_available *BOOLEAN*;

*\--4. 게임 설정*  
*alter table* games  
*add column* age\_rating *varchar*(10);  
*table* games;

*\--테이블에 있는 값이 변경할 때 (update)*  
*\--1.김민준 유저의 이메일을 추가합니다*  
*update* users  
*set* email \= 'minjun@email.com'  
*where* user\_id \= 1;  
*\--2. 이서연 유저의 레벨이 25로 올랐다.*  
*update* users  
*set* user\_level \= 25  
*where* user\_id \= 2;  
*\--3. 모든 유저의 기본 접속 상태를 online으로 설정한다*  
*update* users  
*set* status \= 'online';  
*\--4. DragonKing 유저가 현재 접속 중이다.*  
*update* users  
*set* status \='connecting'  
*where* nickname \= 'dragonKing';  
*\--5. 회복포션의 가격을 700원으로 변경한다.*  
*update* items  
*set* price \= 700  
*where* item\_name \= '회복포션';  
*\--6 Gran Turismo의 이용가능 연령을 12세 이상으로 설정한다.*  
*update* games  
*set* age\_rating \= '12+'  
*where* game\_id \= 102;

*\-- 주의 설명*  
*\-- Delete는 데이터를 삭제한다.*  
*\-- Drop table은 테이블 자체를 사게한다.*  
*\-- alter table은 테이블 구조를 변경한다.*  
*\-- update는 기존 데이터를 수정한다.*

