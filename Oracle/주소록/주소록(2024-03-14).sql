-- addrUSer 화면

/*
주소록 테이블명세를 보고
tbl_address 테이블을 생성하시오
*/
CREATE TABLE tbl_address (
    a_code	VARCHAR2(6)		PRIMARY KEY,
    a_name	nVARCHAR2(20)	NOT NULL,	
    a_tel	VARCHAR2(15)	NOT NULL,	
    a_addr	nVARCHAR2(125)	,	
    a_hobby1	nVARCHAR2(20),		
    a_hobby2	nVARCHAR2(20),		
    a_hobby3	nVARCHAR2(20)
);

SELECT COUNT(*) FROM tbl_address;
SELECT * FROM tbl_address;

-- 이름 순으로 오름차순 정렬하여 SELECT 하기

SELECT * FROM tbl_address
ORDER BY a_name;  -- 내림차순은 ORDER BY a_name DESC;

-- 이름, 전화번호, 취미1 칼럼만 나타나도록 Projection 실행
SELECT a_name,a_tel,a_hobby1
FROM tbl_address;

-- 이름 칼럼에 민 이란 단어가 포함된 리스트만 SELECTION 실행
SELECT * FROM tbl_address
WHERE a_name LIKE '%민%'
ORDER BY a_name;

-- 취미1의 각 취미별 인원수를 계산하기
SELECT a_hobby1,
COUNT(a_hobby1)
FROM tbl_address
GROUP BY a_hobby1
ORDER BY COUNT(a_hobby1) ASC; -- DESC 하면 7부터 내림차순

-- 주소록 테이블에는 취미1, 취미2, 취미3 이 있다.
-- 여행이 취미인 사람 리스트를 출력하기
SELECT *
FROM tbl_address
WHERE a_hobby1 = '여행' OR a_hobby2 = '여행' OR a_hobby3 = '여행';


-- 3개의 취미칸을 중복없이 한줄로 출력하기

SELECT * FROM
(
SELECT a_hobby1 AS 취미 FROM tbl_address WHERE a_hobby1 IS NOT NULL GROUP BY a_hobby1
UNION
SELECT a_hobby2 FROM tbl_address WHERE a_hobby2 IS NOT NULL GROUP BY a_hobby2
UNION
SELECT a_hobby3 FROM tbl_address WHERE a_hobby3 IS NOT NULL GROUP BY a_hobby3
)
ORDER BY 취미;

-- 03.15
-- DROP AND CREATE 테이블정보 삭제하고 다시만들어라
TRUNCATE TABLE tbl_address;
SELECT * FROM tbl_address;


SELECT * FROM
(
SELECT a_code AS 코드,a_hobby1 AS 취미 FROM tbl_address WHERE a_hobby1 IS NOT NULL GROUP BY a_code,a_hobby1
UNION
SELECT a_code, a_hobby2 FROM tbl_address WHERE a_hobby2 IS NOT NULL GROUP BY a_code,a_hobby2
UNION
SELECT a_code, a_hobby3 FROM tbl_address WHERE a_hobby3 IS NOT NULL GROUP BY a_code,a_hobby3
)
ORDER BY 코드;

-- 취미정보를 저장할 테이블 생성하기
CREATE TABLE tbl_hobby (
h_code	VARCHAR2(5)		PRIMARY KEY,
h_name	nVARCHAR2(20)	NOT NULL,	
h_rem	nVARCHAR2(125)		
	
);

CREATE TABLE tbl_addr_hobby(
    r_acode	VARCHAR2(6)	NOT NULL,
    r_hcode	VARCHAR2(5)	NOT NULL,
	CONSTRAINT ah_pk PRIMARY KEY(r_acode, r_hcode)	
);

SELECT COUNT(*) FROM tbl_hobby;
SELECT COUNT(*) FROM tbl_addr_hobby;

-- 3개의 Table 에 관계설정(FK 키 설정)
-- 두개의 Table 이 1:N 의 관계일때 N의 table 에서 설정한다
-- Relation 과 tbl_address 간의 관계설정
ALTER TABLE tbl_addr_hobby
ADD CONSTRAINT fk_addr
FOREIGN KEY(r_acode)
REFERENCES tbl_address(a_code);

-- Relation 과 tbl_hobby 간의 관계설정
ALTER TABLE tbl_addr_hobby
ADD CONSTRAINT fk_hobby
FOREIGN KEY(r_hcode)
REFERENCES tbl_hobby(h_code);

-- 정규화가 완료된 후 주소록 테이블에 불필요한 칼럼(hobby1, hobby2, hobby3) 삭제
ALTER TABLE tbl_address DROP COLUMN a_hobby1;
ALTER TABLE tbl_address DROP COLUMN a_hobby2;
ALTER TABLE tbl_address DROP COLUMN a_hobby3;


-- 주소록의 데이터의 개인들이 어떤 취미를 갖는지 알고 싶다
SELECT A.*,AH.r_hcode, H.h_name --  A.* 주소록에 있는 모든걸보여주어라
FROM tbl_address A
    JOIN tbl_addr_hobby AH
        ON a_code = r_acode      
    JOIN tbl_hobby H
        ON r_hcode = h_code;
        
-- 위의 SELECT(조회) 쿼리를 view_address 라는 이름의 view 로 생성하기
CREATE VIEW view_address AS (
    SELECT A.*,AH.r_hcode, H.h_name
    FROM tbl_address A
        JOIN tbl_addr_hobby AH
            ON a_code = r_acode      
        JOIN tbl_hobby H
            ON r_hcode = h_code
);

-- view 를 사용하여 각 취미별로 몇명이 속해 있는지 계산 // 각 취미를 몇명이 즐기는가
/*
Database 의 통계 계산
개수, 합계, 평균, 최대값, 최소값
COUNT(), SUM(), AVG(), MAX, MIN() 이 함수를 사용하여 통계 계산을 한다

산술통계를 할때 거의 필수적으로 포함되는 GROUP BY 절이 필요
*/
-- 조건 없이 전체 데이터의 개수
SELECT COUNT(*) FROM view_address;

-- "취미별"로 라는 조건이 있으면 이때는 GROUP BY 가 필수이다
-- 취미(취미코드, 취미명) 라는 칼럼으로 그룹핑을 하고
-- 그 그룹내에 속한 레코드들의 개수가 몇개인가

SELECT r_hcode,h_name, COUNT(*) FROM view_address
GROUP BY r_hcode, h_name -- 같은것들(취미별로) 개수를 세어라
ORDER BY h_name;

-- 문자열 칼럼의 데이터를 범위를 지정하여 확인하기
SELECT a_name,r_hcode, h_name FROM view_address
WHERE h_name BETWEEN '마술' AND '스키'
ORDER BY h_name;

SELECT a_name,r_hcode, h_name FROM view_address
WHERE h_name >= '마술' AND  h_name <= '스키'
ORDER BY h_name;

SELECT a_name,r_hcode, h_name FROM view_address
WHERE h_name >= '마술' AND  h_name <= '스키'
ORDER BY h_name;

-- 다중 OR 조건문
SELECT a_name,r_hcode, h_name FROM view_address
WHERE h_name = '마술' OR h_name = '사격' OR h_name = '쇼핑'
OR h_name = '스쿼시'
ORDER BY h_name;

-- AND 조건문은 BETWEEN 키워드를 사용하여 코드를 다소 간소화 할 수 있다
-- 다중 OR 조건문을 간소화 하는 키워드를 찾아 SQL 을 작성
SELECT a_name, r_hcode, h_name FROM view_address
WHERE h_name IN ('마술', '사격', '쇼핑', '스쿼시')
ORDER BY h_name;

-- 취미가 '마술', '사격', '여행' 인 사람들의 참여 인원수를 계산하기
SELECT h_name, COUNT(h_name) FROM view_address
WHERE h_name IN ('마술', '사격', '여행')
GROUP BY h_name;

SELECT  r_hcode,h_name, COUNT(*) FROM view_address
WHERE h_name IN ('마술', '사격', '여행')
GROUP BY r_hcode, h_name
ORDER BY count(*) DESC;

SELECT  r_hcode,h_name, COUNT(*) FROM view_address
GROUP BY r_hcode, h_name
HAVING h_name IN ('마술', '사격', '여행')
ORDER BY count(*) DESC;