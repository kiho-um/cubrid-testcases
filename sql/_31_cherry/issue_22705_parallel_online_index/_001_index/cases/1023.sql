-- [er]create class on all type and insert/update/delete/select data and create index on MULTISET type

drop if exists t1;
create class t1(
col1 int, 
col2 string, 
col3 char(10), 
col4 varchar(10), 
col5 FLOAT,
col6 SMALLINT,
col7 DOUBLE,
col8 DATE,
col9 TIME,
col10 TIMESTAMP,
col11 SET,
col12 MULTISET,
col13 SEQUENCE,
col14 bit );

INSERT INTO t1 VALUES (1,'string1','a','aaa',10,10,10, '05/26/2008', '14:24:00', '14:24:00 05/26/2008',{'a'},{'a'},{'a'},B'1');
INSERT INTO t1 VALUES (null,'string1','a','aaa',10,10,10, '05/26/2008', '14:24:00', '14:24:00 05/26/2008',{'a'},null,{'a'},B'1');
INSERT INTO t1 VALUES (2,'string1','a','aaa',10,10,10, '05/26/2008', '14:24:00', '14:24:00 05/26/2008',{'a'},{'b'},{'a'},B'1');
INSERT INTO t1 VALUES (1,'string1','a','aaa',10,10,10, '05/26/2008', '14:24:00', '14:24:00 05/26/2008',{'a'},{'a'},{'a'},B'1');
INSERT INTO t1 VALUES (3,'string1','a','aaa',10,10,10, '05/26/2008', '14:24:00', '14:24:00 05/26/2008',{'a'},{'c'},{'a'},B'1');

UPDATE t1 SET col12={'c'} WHERE col1=3;

DELETE  FROM t1 WHERE col1=2;

SELECT * FROM t1 order by 1,2;

create index t1_index on t1(col12) with online parallel 5;

SELECT * FROM db_index WHERE class_name='t1' order by 1,2;

drop class t1;
