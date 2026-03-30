1. 시스템 선택
온라인 쇼핑몰(간단)

2. 요구사항 (5개 이상)
사용자는 회원가입을 할 수 있다.
사용자는 여러 상품을 조회할 수 있다.
사용자는 상품을 주문할 수 있다.
주문에는 주문한 사용자와 상품 정보가 포함된다.
상품은 이름, 가격, 재고 정보를 가진다.
관리자는 상품을 추가할 수 있다.

3. 데이터베이스 설계
데이터 베이스 엔티티 2개 이상
속성 정의 (모든 엔티티의 3개이상이여야한다.)
Users (사용자)
속성       설명          
user_id (int) 사용자 ID (PK) 
name    varchar(50) 사용자 이름     
email   varcahr(100) 이메일        

product(상품)
속성                           설명         
product_id (int)          상품 ID (PK) 
product_name varchar(100) 상품 이름      
price   (int)              가격         
stock   (int)                재고         

order(주문)
 속성                설명          
order_id(int)    주문 ID (PK)  
user_id(int)    사용자 ID (FK) 
product_id(int)  상품 ID (FK)  
quantity(int)    주문 수량       

관계는
Users → Orders : 1:N 관계
한 명의 사용자는 여러 주문을 가능
Products → Orders : 1:N 관계
하나의 상품은 여러 주문에 포함

4. sql 작성
-- 1. 테이블 생성
CREATE TABLE Users (
user_id INT PRIMARY KEY,
name VARCHAR(50),
email VARCHAR(100)
);
CREATE TABLE Products (
product_id INT PRIMARY KEY,
product_name VARCHAR(100),
price INT,
stock INT
);
CREATE TABLE Orders (
order_id INT PRIMARY KEY,
user_id INT,
product_id INT,
quantity INT,
FOREIGN KEY (user_id) REFERENCES Users(user_id),
FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

데이터 삽입
INSERT INTO Users VALUES (1, 'Kim', 'kim@example.com');
INSERT INTO Users VALUES (2, 'eun', 'eun@example.com');
INSERT INTO Products VALUES (1, 'note', 50000, 10);
INSERT INTO Products VALUES (2, 'ruler', 20000, 20);
INSERT INTO Orders VALUES (1, 1, 1, 1);
INSERT INTO Orders VALUES (2, 2, 2, 2);

조회
SELECT * FROM Users;
SELECT * FROM Products;
SELECT * FROM Orders;

조건 조회
SELECT *
FROM Products
WHERE price > 30000;

정렬 조회
SELECT *
FROM Products
ORDER BY price DESC;



