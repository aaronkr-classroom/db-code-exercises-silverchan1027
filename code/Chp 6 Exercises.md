# **활동 1: 학교 / 수강신청 DB**

## **Bad Design / 나쁜 설계**

STUDENT\_COURSE  
~~\- student\_id~~  
~~\- student\_name~~  
~~\- student\_phone~~  
~~\- major\_name~~  
\- course\_id  
\- course\_name  
~~\- professor\_name~~  
~~\- professor\_phone~~  
\- semester  
\- grade

CREATE TABLE…  
INSERT VALUES…

## **What is wrong? / 문제점**

* 학생, 과목, 교수, 수강신청 정보가 한 테이블에 섞여 있다.  
* 학생 정보가 수강 과목마다 반복된다.  
* 과목 정보가 학생마다 반복된다.  
* 교수는 별도의 개체로 분리해야 한다.  
* 수강신청은 단순 속성이 아니라 학생과 과목 사이의 관계 개체이다.

## **Fixed Design / 수정된 설계**

STUDENT \<-\> COURSE (M:N 관계) \= ENROLLMENT

STUDENT  
\- student\_id 		PK  
\- student\_name  
\- student\_phone  
\- major\_name  
\- birthday  
	\- age (유도속성)

PROFESSOR  
\- professor\_id		PK  
\- professor\_name  
\- professor\_phone  
\- hire\_date  
	\- working\_period (유도속성)

COURSE  
\- course\_id		PK  
\- course\_name  
\- course\_grade  
\- professor\_id		FK

ENROLLMENT  
\- semester  
\- grade  
\- student\_id	FK (PK+)  
\- course\_id	FK (PK+)  
\- PK \= course\_id \+ student\_id

## **Why this is better / 왜 더 좋은가?**

* 각 개체의 의미가 명확하다.  
* 중복 데이터가 줄어든다.  
* ENROLLMENT는 학생과 과목 사이의 M:N 관계를 올바르게 표현한다.  
* 성적은 학생이나 과목 자체가 아니라 수강신청 정보에 속한다.

# **활동 2: 게임 유저 관리 DB**

## **Bad Design / 나쁜 설계**

GAME\_USER  
\- user\_id  
\- nickname  
\- phone  
\- game1\_name  
\- game1\_level  
\- game1\_score  
\- game2\_name  
\- game2\_level  
\- game2\_score  
\- game3\_name  
\- game3\_level  
\- game3\_score

## **What is wrong? / 문제점**

* 속성이 너무 많아요.  
* game 열이 반복해서 문제죠\~\~  
* 최대 game 3개 밖에 못 저장합니다.  
* 게임 정보와 유저 정보의 기록이 섞여 있다…  
* 레벨과 점수는 게임 자체의 속성이 아니라 특정 유저가 특정 게임을 플레이한 기록의 속성이다.

## **Fixed Design / 수정된 설계**

USER \<-\> GAME (M:N 관계) \=\> USER\_GAME 

USER  
\- user\_id	PK  
\- nickname  
\- phone

GAME  
\- game\_id	PK  
\- game\_name  
\- genre

USER\_GAME  
\- level  
\- score  
\- last\_played\_time  
\- user\_id	FK, (PK+)  
\- game\_id	FK, (PK+)  
	PK \= user\_id \+ game\_id

## **Why this is better / 왜 더 좋은가?**

* 유저는 원하는 만큼 여러 게임을 플레이할 수 있다\!  
* 하나의 게임도 여러 유저가 플레이할 수 있다\!  
* USER\_GAME은 USER와 GAME 사이의 관계 개체이다.  
* 레벨과 점수는 올바른 위치에 저장된다.

# **활동 3: 쇼핑몰 DB**

## **Bad Design / 나쁜 설계**

ORDER\_TABLE  
\- order\_id  
\- customer\_name  
\- customer\_phone  
\- customer\_address  
\- product1\_name  
\- product1\_price  
\- product1\_quantity  
\- product2\_name  
\- product2\_price  
\- product2\_quantity  
\- product3\_name  
\- product3\_price  
\- product3\_quantity  
\- order\_date  
\- delivery\_status

## **What is wrong? / 문제점**

* 고객 정보가 주문마다 반복된다.  
* 상품 컬럼이 반복된다.  
* 주문 하나에 최대 3개의 상품만 넣을 수 있다.  
* 상품 정보와 주문 상세 정보가 섞여 있다.  
* 배송 상태는 시간이 지나면서 바뀔 수 있으므로, 이력을 관리하려면 하나의 상태 컬럼만으로 부족하다.

## **Fixed Design / 수정된 설계**

PRODUCT \<-\> ORDER (M:N) \=\> ORDER\_DETAIL  
CUSTOMER \<-\> ORDER (M:N).... 

CUSTOMER  
\- customer\_id 		PK  
\- customer\_name  
\- customer\_phone  
\- customer\_address

PRODUCT  
\- product\_id		PK  
\- product\_name  
\- product\_price  
\- product\_quantity (창고에 있는 개수)

ORDER  
\- order\_id	PK  
\- order\_date  
\- customer\_id 	FK

**ORDER\_DETAIL**  
\- order\_id	FK, (PK+)  
\- product\_id	FK, (PK+)  
\- order\_price  
\- quantity (몇 개 주문 했는지)

DELIVERY(\_HISTORY)  
\- delivery\_history\_id	PK  
\- delivery\_status  
\- order\_id 	FK  
\- changed\_at

## **Why this is better / 왜 더 좋은가?**

* 고객 정보는 한 번만 저장된다.  
* 상품 정보도 한 번만 저장된다.  
* 하나의 주문에 여러 상품을 포함할 수 있다.  
* ORDER\_DETAIL은 주문 안의 상품 목록을 올바르게 표현한다.  
* DELIVERY(\_HISTORY)를 사용하면 배송 상태 변화를 시간순으로 관리할 수 있다.

