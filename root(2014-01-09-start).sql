/* 
여러줄 주석문 
*/
-- 한줄짜리 주석

/*
이 화면에서 SQL 명령어를 입력하고
Ctrl + Enter 를 입력하면 명령이 실행된다
명령어는 대체로 대소문자 구분이 없다
주요 키워드는 대문자로, 변수 등은 소문자로 입력

*/ 
SHOW DATABASES;
SHOW DATABASES; -- ctrl enter
USE mysql; -- mysqul 에대한 어떤명령을 실행하겠다. 
SHOW TABLES; --  table : 사용자입장에서보는 schema (외부 schema) / mysqul의 table을 보여라
SELECT * FROM user;  -- user라는 table에서 *(전체)모든것을 선택해서 보여줘 // 표로만들어서                          //서버에요청하고 응답받기
