/*
Test Case: delete & update 
Priority: 1
Reference case:
Author: Ray

Test Plan: 
Test DELETE/UPDATE locks (X_LOCK on instance) if the instances of the transactions are not overlapped (with pk schema)
C2 updated before C1 deleted since C1 takes a long time

Test Scenario:
C1 delete, C2 update, the affected rows are not overlapped (based on where clause)
C2 completed before C1 executed since C1 takes a long time
C1's updated results affect a portion of the C2's deleting instances
C1, C2 where clause are not on pk column (heap scan)
C2 commit, C1 commit
Metrics: data size = small, where clause = simple, schema = single table with pk

Test Point:
1) C1 and C2 will not be waiting 
2) C2 instances should be updated first, C1 instances should be deleted based on the original search condition (i.e. its original snapshot)

NUM_CLIENTS = 3
C1: delete from table t1;   
C2: update table t1;  
C3: select on table t1; C3 is used to check the updated result
*/

MC: setup NUM_CLIENTS = 3;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

C3: set transaction lock timeout INFINITE;
C3: set transaction isolation level read committed;

/* preparation */
C1: DROP TABLE IF EXISTS t1;
C1: CREATE TABLE t1(id INT PRIMARY KEY, col VARCHAR(10), tag VARCHAR(2));
C1: INSERT INTO t1 VALUES(1,'abc','A'),(2,'def','B'),(3,'ghi','C'),(4,'jkl','D'),(5,'mno','E'),(6,'pqr','F'),(7,'abc','G');
C1: COMMIT WORK;
MC: wait until C1 ready;

/* test case */
C1: DELETE FROM t1 WHERE (col IN ('def','jkl') or id < 2) and 0 = (select sleep(6)); 
C2: UPDATE t1 SET col = 'def' WHERE tag BETWEEN 'F' and 'G';
/* expect: no transactions need to wait */
MC: wait until C2 ready;
/* expect: C2 select - id = 6,7 are updated */
C2: SELECT * FROM t1 order by 1,2;
C2: commit;
/* expect: C1 finished execution after C2 commit, 3 rows (id=1,2,4)deleted message, C1 select - id = 1,2,4 are deleted */
MC: wait until C1 ready;
C1: SELECT * FROM t1 order by 1,2;
C1: commit;
MC: wait until C1 ready;

/* expect: the instances of id = 6,7 are updated, id = 1,2,4 are deleted */
C3: select * from t1 order by 1,2;

C1: quit;
C2: quit;
C3: quit;
