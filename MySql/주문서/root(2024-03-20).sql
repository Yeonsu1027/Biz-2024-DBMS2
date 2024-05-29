-- 주문서 프로젝트

/*
주문서 excep 파일의 고객정보, 상품정보
데이터를 참조하여
1. 주문원장의 "상품코드" 칼럼의 데이터를 분리 후
2. "주문내역" 테이블로 이전하는 정규화 실행
3. 주문원장, 주문내역, 고객정보, 상품정보
	4가지 Entity 의 개념적 모델링
4. 논리적, 물리적 모델링
5. Table 명세 생성

Database : tmp_orderDB
*/

CREATE DATABASE tmp_orderDB;
USE tmp_orderDB;

-- 정리용 먼저
CREATE TABLE tbl_temp_order (
t_ocode	VARCHAR(6),
t_date	DATE,
t_ccode	VARCHAR(5),
t_order1	VARCHAR(6),
t_order2	VARCHAR(6),
t_order3	VARCHAR(6)
);

SELECT t_ocode, t_date, t_ccode, '주문1' AS 주문유형, t_order1 AS 주문상품 FROM tbl_temp_order
UNION
SELECT t_ocode, t_date, t_ccode, '주문2', t_order2 FROM tbl_temp_order
UNION
SELECT t_ocode, t_date, t_ccode, '주문3', t_order3 FROM tbl_temp_order;

-- -------------------------------------------------------------------

SELECT t_ocode AS 주문번호, t_date AS 주문날짜, t_ccode AS 주문고객,  t_order1 AS 주문상품 FROM tbl_temp_order
UNION
SELECT t_ocode, t_date, t_ccode, t_order2 FROM tbl_temp_order
UNION
SELECT t_ocode, t_date, t_ccode, t_order3 FROM tbl_temp_order;

-- ------------------------------------------


CREATE TABLE tbl_customer (
c_code	VARCHAR(5)		PRIMARY KEY,
c_name	VARCHAR(5)	NOT NULL,	
c_tel	VARCHAR(15)	NOT NULL	
);

CREATE TABLE tbl_product(
p_code	VARCHAR(6)		PRIMARY KEY,
p_name	VARCHAR(20)	NOT NULL	,
p_item	VARCHAR(20)	NOT NULL	,
p_price	INT	NOT NULL	
);


CREATE TABLE tbl_order(
o_code	VARCHAR(6),
o_date	DATE,
o_ccode	VARCHAR(5),
o_pcode	VARCHAR(6),

		CONSTRAINT order_pk PRIMARY KEY(o_code,o_ccode,o_pcode) 

);

-- ------------------------------------------- 거래원장 만들어보기
SELECT O.o_code AS 주문번호, O.o_date AS 거래날짜,
 C.c_code AS 고객코드, C.c_name AS 고객명,
 C.c_tel AS 연락처,
 O.o_pcode AS 거래상품, P.p_name AS 상품명
	FROM tbl_order O
    JOIN tbl_customer C
		ON O.o_ccode = C.c_code
	JOIN tbl_product P
		ON O.o_pcode = P.p_code;


