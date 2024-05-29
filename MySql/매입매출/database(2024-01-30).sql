-- 매입매출
/*
MySQL DataBase Dump 하기
=> Database Schema 를 통째로 파일로 백업하기
다른 DB에서 사용하거나
DB를 새로 설치할 경우 사전에 기존의 사용하던 DB를
백업하기
	메뉴의 Server / Data Export 를 선택하고
	백업할 Database 와 폴더를 선택한다
복원하기
	기존의 Database Schema 가 없으면
	복원할 Database Schema 를 생성
    메뉴의 Server / Data Import 를 선택하여
    백업파일이 저장된 폴더를 선택한다
    백업할때의 Database Schema 와 같은 이름으로
    Database를 생성해 둔다
*/
CREATE DATABASE ecountDB2;

USE edb;         -- 안지워서 2아님..
SHOW TABLES;

DROP DATABASE ecountDB;
CREATE DATABASE ecountDB;

DROP DATABASE newschema;
DROP DATABASE edb;

USE ecountDB;
SHOW TABLES;
SELECT COUNT(*) FROM tbl_depts;
SELECT COUNT(*) FROM tbl_iolist;
SELECT COUNT(*) FROM tbl_products; -- 잘 import됐나 확인

SELECT * FROM tbl_iolist LIMIT 10;
/*
tbl_iolist TABLE 의 데이터는 정규화(3정규화)가
완료된 상태이며, 상품정보 거래처정보가 단지 FK(외래키)로
설정된 코드만 저장되어 있다
매입매출정보를 조회하면서, 상품정보와 거래처정보를
연계하여 보기 위해서는 JOIN 을 실행해야 한다.
현재 Schema 에 저장된 3개의 Table 은 "참조무결성" 관계가
설정되어 있기 때문에 EQ JOIN 을 사용해서
데이터 조회에 문제가 없다
*/
-- 무조건적으로 두 테이블을 JOIN 하여 보기
SELECT *
FROM tbl_iolist, tbl_products     
WHERE io_pcode = p_code;	-- 가장기본적 join

-- 원하는 모양대로 조회결과를 확인하기 위하여는
-- 반드시 Projection 을 시행해야 한다.
-- Projection : 보고자 하는 모양대로 칼럼을 구성하기
SELECT io_seq, io_date, io_time,
	io_pcode, p_name, p_item, p_comp, -- 상품이름 품목 ,제조사
	io_dcode, io_div, io_quan, io_iprice, io_oprice
FROM tbl_iolist, tbl_products            -- 연계
WHERE io_pcode = p_code;

/*
JOIN을 통한 View 의 생성
	물리적인 2개 이상의 테이블을 서로 연계하여
	보고자 하는 모양의 View Table 을 출력하는
	SQL
*/
-- EQ JOIN(완전 JOIN)을 이용한 테이블 연계
-- EQ JOIN을 사용하려면 반드시 참조무결성, 외래키 설정이
-- 완전하게 이루어져야 한다.
SELECT io_seq, io_date, io_time, 
	io_pcode, p_name, p_item, p_comp, -- 상품이름 품목 ,제조사
	io_dcode, d_name, d_ceo, d_tel, d_addr,
    io_div, io_quan, io_iprice, io_oprice   -- 이 순서로
FROM tbl_iolist, tbl_products, tbl_depts         -- 이 테이블3개에서
WHERE io_pcode = p_code AND io_dcode = d_code;   -- 여러테이블에 흩어져있는 데이터를 원하는대로 보여준다 하나의테이블처럼
	-- io_pcode : 상품매출 tbl_iolist 의 상품코드
    -- p_code : 상품 tbl_products 의 상품코드
    -- d_code : 거래처 tbl_depts의 거래처코드
    -- io_dcode : 상품매출 tbl_iolist 의 거래처코드              상품코드=상품코드 and 거래처코드=거래처코드
    
/*
Table 과 Table 을 연계하는 과정에서
참조무결성이 되어있지 않는 경우도 매우 많다
이때는 절대 EQ JOIN 을 사용해서는 안된다
참조무결성이 되지 않은 Table 을 EQ JOIN 으로 연계하는경우
보여지는 데이터가 누락되거나, 전혀 엉뚱한 리스트가
보여질 수 있다.

이때는 EQ JOIN 이 아닌 OUTTER JOIN 이나 INNER JOIN을
사용해야 한다.
INNER JOIN은 실무에서 별로 사용하지 않고
주로 OUTTER JOIN을 사용한다
OUTTER JOIN에는 LEFT OUT JOIN, RIGTH OUT JOIN 이 있으며
주로 LEFT OUT JOIN을 사용한다.
LEFT OUT JOIN 은 OUT 키워드를 생략하고
일반적으로 "LEFT JOIN" 이라고 명명한다.
*/

/*
LEFT JOIN
키워드 왼쪽에 있는 테이블(tbl_iolist)전체를
펼쳐 놓고,
tbl_iolist.io_pcode 값으로
	키워드 오른쪽 테이블(tbl_products)의
    p_code 값을 조건(ON)으로 SELECT 한다
이때 tbl_products 테이블에 해당조건과 일치하는 값이
	있으면 그 데이터를 같이 보여주고
    없으면 null 로 표현하여 보여주기
*/
SELECT io_seq, io_date, io_time, 
	io_pcode, p_name, p_item, p_comp,
	io_dcode, 
    io_div, io_quan, io_iprice, io_oprice 
FROM tbl_iolist  -- FROM 에다가 전체데이터를 보여줄 테이블이름을 쓴다.
	LEFT JOIN tbl_products
		ON io_pcode = p_code;
        
-- 매입매출과 거래처정보를 연계한 JOIN
SELECT io_seq, io_date, io_time, 
	io_pcode, 
	io_dcode, d_name, d_ceo, d_tel, d_addr,
    io_div, io_quan, io_iprice, io_oprice 
FROM tbl_iolist
	LEFT JOIN tbl_depts
		ON io_dcode = d_code;

/*
VIEW 의 생성
복잡한 SELECT 명령문을 자주 사용해야 하는 경우
사용할때마다 명령을 입력해야 하는 번거로움이 존재한다
이때 복잡한 SELECT 명령문을 VIEW 로 등록해 두면
마치 물리적인 Table 을 조회하는 것과 똑같이
SELECT 를 실행하여 결과를 확인할 수 있다

VIEW 를 생성할때 Projection 을 적절히 수행하여
VIEW 를 만들어두고, 권한이 제한적인 관리자(사용자)에게
해당 VIEW 에만 접근허락하고,
실제적인 물리적 Table 에는 접근을 금지하여
보안성을 높이는 용도로도 사용한다.

데이터의 논리적 독립성을 보장한다

VIEW 는 실제 데이터가 저장된 곳이 아니고
실제 데이터는 물리적인 Table 에 저장된다
물리적 Table 의 데이터가 변경되면(Insert, Update, Delete)
VIEW 에도 변화된 데이터가 조회된다

요즘의 DB 소프트웨어 에서는 VIEW 를 통하여
제한적으로 CRUD 가 모두 가능하다
초기에는 VIEW 는 SELECT Only 로 사용되었었다.

*/
CREATE VIEW view_iolist AS               -- select 문을사용해서 view 만들기
(
	SELECT io_seq, io_date, io_time, 
		io_pcode, p_name, p_item, p_comp, 
		io_dcode, d_name, d_ceo, d_tel, d_addr,
		io_div, io_quan, io_iprice, io_oprice   
	FROM tbl_iolist
		LEFT JOIN tbl_products
			ON io_pcode = p_code 
		LEFT JOIN tbl_depts
			ON io_dcode = d_code 
);

SELECT *
FROM view_iolist;

SELECT *
FROM view_iolist
ORDER BY io_pcode;

-- SELECTION 을 하여 조건 조회 // WHERE 문에 조건
SELECT *
FROM view_iolist
WHERE io_date BETWEEN '2023-02-01' AND '2023-02-29';

SELECT io_date, io_pcode, p_name
FROM view_iolist; -- view 에서도 필요한 것만 골라 볼 수있다

SELECT io_date, io_pcode, p_name,
	io_quan * io_iprice AS 매입금액,
	io_quan * io_oprice AS 매출금액
FROM view_iolist
ORDER BY io_date;


-- 상품명 별로 매입 매출 전체 합산 구하기
SELECT io_pcode, p_name,
	SUM(io_quan * io_iprice) AS 매입합산,
    SUM(io_quan * io_oprice) AS 매출합산
FROM view_iolist
GROUP BY io_pcode, p_name
ORDER BY p_name;

-- 상품명 별로 매입 매출 ""합산""을 구하고
-- 매입, 매출금액이 많은 상품부터 정렬하여 나열하기
-- 합계와 합산은 개념적으로 약간 다른 의미
-- 합산은 통계와 연관된 단어

SELECT io_pcode AS 코드, p_name AS 상품명,
	SUM(io_quan * io_iprice) AS 매입합산,
    SUM(io_quan * io_oprice) AS 매출합산
FROM view_iolist
GROUP BY io_pcode
ORDER BY 매입합산 DESC, 매출합산 DESC;  -- 매입합산으로 정렬하고 똑같은 값이 있으면 다시정렬
-- DB 소프트웨어에 따라 ORDER BY 에서 Alias 를
-- 사용할 수 없는 경우도 있다 이때는 식을 사용한다
-- ORDER BY SUM(io_quan * io_iprice) DESC, SUM(io_quan * io_oprice) DESC

-- HAVING
-- GROUP BY 키워드가 있고,
-- 통계함수를 사용한 값이 있을경우
-- 통계함수를 통해 산출된 결과를 필터링 하기
-- HAVING 을 사용하면 SELECT 가 매우 느려진다
-- 잘못사용하면 DB 성능에 막대한 문제를 일으키기도 한다
SELECT io_pcode AS 코드, p_name AS 상품명,
	SUM(io_quan * io_iprice) AS 매입합산,
    SUM(io_quan * io_oprice) AS 매출합산
FROM view_iolist
GROUP BY io_pcode 
HAVING 매입합산 > 536199
ORDER BY 매입합산 DESC, 매출합산 DESC;

-- 매입매출 데이터에서 매입항목(io_div = 1)만 SELECT 하여
-- 상품코드, 상품명, 매입합계를 출력
SELECT io_div,
	SUM(io_quan * io_iprice) AS 매입합산,
    SUM(io_quan * io_oprice) AS 매출합산
FROM view_iolist           -- 500개 데이터 가져와서
GROUP BY io_div              -- 1 , 2 로 그룹하고
HAVING io_div ='1';  -- 그중에서 1만 출력     2가만들어진 후인데  2가필요없음 비효율적

-- 이렇게 써야한다.
SELECT io_div,
	SUM(io_quan * io_iprice) AS 매입합산,
    SUM(io_quan * io_oprice) AS 매출합산
FROM view_iolist           
WHERE io_div ='1'          -- 애초에 1만 찾아서 그룹한다.
GROUP BY io_div;           
 
CREATE TABLE tbl_members (
	m_username	VARCHAR(15)		PRIMARY KEY,
	m_password	VARCHAR(125)	NOT NULL,	
	m_realname	VARCHAR(20),		
	m_tel	VARCHAR(15),		
	m_role	VARCHAR(5)		
);


