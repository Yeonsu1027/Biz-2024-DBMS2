-- 매입매출
DROP DATABASE edb;
CREATE DATABASE edb;
USE edb;
SHOW TABLES;

DESC tbl_iolist;
-- 정의된 FK를 삭제하기
ALTER TABLE tbl_iolist
DROP FOREIGN KEY tbl_iolist_ibfk_2; -- 시퀄라이즈가 만든 키

-- FK 정의
-- Table 간의 참조무결성관계를 설정하기
-- 1:N 관계의 table 에서 N 의 위치에 있는 Table 에 선언
ALTER TABLE tbl_iolist
ADD CONSTRAINT FK_PCODE
FOREIGN KEY (io_pcode)
REFERENCES tbl_products(p_code);

ALTER TABLE tbl_iolist
ADD CONSTRAINT FK_CODE
FOREIGN KEY (io_dcode)
REFERENCES tbl_depts(d_code);

SELECT * FROM tbl_members;
TRUNCATE tbl_members;
DESC tbl_members;
/*
기존의 Table 구조 변경하기
칼럼의 이름을 변경하거나, 칼럼의 type 을 변경하는 일
FK 를 새로 설정하거나, PK 도 새로설정 또는 변경하는일
AlTER TABLE ... 명령을 사용하여 변경한다

기존 Table 구조를 변경할때 발생할 수 있는 여러가지 문제
1. 칼럼의 Type 을 변경 : 문자열을->숫자, 숫자-> 문자열, 저장공간 변경
	Type 의 형태에 따라 문제를 일으키는데, 보편적인 DB SW 에서는
    문제가 발생하면 명령 실행 자체가 실패한다.
    하지만 간혹 대량의 데이터가 보관되어 있는 경우, 실행이 진행되다가
    중간에 중단되는 경우도 있다
    이럴때 기존의 데이터에 손상이 가해지는 경우가 있다.
    
2. 칼럼의 이름 변경 : 연관된 여러 애플리케이션에서 해당 칼럼을 찾지 못하는
	문제가 발생한다
*/
