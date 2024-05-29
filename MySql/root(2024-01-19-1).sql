CREATE DATABASE bookDB;

USE bookDB;

CREATE TABLE tbl_books(
isbn VARCHAR(13) PRIMARY KEY,
title	VARCHAR(100)	NOT NULL,
author	VARCHAR(100)	NOT NULL,
publisher	VARCHAR(100)	NOT NULL,
price	INT(7)	NOT NULL,
discount	INT(7),	
descrip	 VARCHAR(8000),	
pubdate	VARCHAR(10),	
link	VARCHAR(125),	
image	VARCHAR(125)	
);


INSERT INTO tbl_books (
isbn,
title,
author,
publisher,
price,
discount
)
VALUES('9791188850501','왕이된 남자 1','김선덕','북라이프','14000','12600');

INSERT INTO tbl_books (
isbn,
title,
author,
publisher,
price,
discount
)
VALUES('9788901057415','엑셀함수 필살기','이동숙','NEWRUN','13900','0');


CREATE TABLE tbl_users (M_ID	VARCHAR(20)	PRIMARY KEY,
M_PASSWORD	VARCHAR(125)	NOT NULL,	
M_EMAIL	VARCHAR(125)	NOT NULL,	
M_NAME	VARCHAR(12)	NOT NULL	
);

INSERT INTO tbl_users (
M_ID,
M_PASSWORD,
M_EMAIL,
M_NAME
)
VALUES('hams1111','hams8888','hams@naver.com','hamster');

SELECT * FROM tbl_users;