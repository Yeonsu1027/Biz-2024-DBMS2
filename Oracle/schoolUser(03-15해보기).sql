-- schoolUser 화면

CREATE TABLE tbl_std (
s_stdnum	VARCHAR2(5)	,
s_subject	nVARCHAR2(20)	NOT NULL,
s_score	NUMBER	NOT NULL
	
	
);


DROP TABLE tbl_std_sub;

CREATE TABLE tbl_subject (
sb_sbcode	VARCHAR2(5)		PRIMARY KEY,
sb_subject	nVARCHAR2(20)	NOT NULL	
);

CREATE TABLE tbl_std_sub (
c_stdcode	VARCHAR2(5)	NOT NULL,
c_subcode	VARCHAR2(5)	NOT NULL,
	CONSTRAINT stsu_pk PRIMARY KEY(c_stdcode,c_subcode)
	
);





--------------------------- 2트) 
-- 학생정보
CREATE TABLE tbl_student
(
s_stdnum	VARCHAR2(5)		PRIMARY KEY,
s_name	nVARCHAR2(20)	NOT NULL	
);

-- 점수
CREATE TABLE tbl_score
(
c_sstdnum	VARCHAR2(5)	NOT NULL,
c_subject	nVARCHAR2(20)	NOT NULL,
c_score	NUMBER	NOT NULL
);

-- 과목코드
CREATE TABLE tbl_subject (
sb_sbcode	VARCHAR2(5)		PRIMARY KEY,
sb_subject	nVARCHAR2(20)	NOT NULL	
);

-- 학번&학생이름 의 과목별 점수
SELECT ST.*,SC.c_subject,SC.c_score
FROM tbl_student ST
    JOIN tbl_score SC
    ON s_stdnum = c_sstdnum;


--  모든 학생의 수학점수
SELECT st.s_name, st.s_stdnum,sb.sb_sbcode, sb.sb_subject, sc.c_score
FROM tbl_student st
JOIN tbl_score sc ON st.s_stdnum = sc.c_sstdnum 
JOIN tbl_subject sb ON sc.c_subject = sb.sb_subject
WHERE sb.sb_subject IN ('수학'); -- 지우면 학생의 과목별점수           //조건추가가능 st.s_stdnum = 'S0004' AND
-- WHERE sb.sb_sbcode IN ('SU003');




