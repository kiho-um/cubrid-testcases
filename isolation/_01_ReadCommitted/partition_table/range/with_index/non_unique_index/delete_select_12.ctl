/*
Test Case: delete & select 
Priority: 1
Reference case:
Author: Mandy

Test Point:
Test delete null data in partition table
1. Reading queries can only have a look at data committed before the queries began
2. Uncommitted data are never seen
3. The only visible uncommitted data are the effects of current transaction's dates, that is to say
   the new version is only visible to the current transaction
At the same time check delete dose not block select

NUM_CLIENTS = 2 
C1: delete and select on table t1
C2: select on table t1 before C1 commit
*/


MC: setup NUM_CLIENTS = 2;

C1: set transaction lock timeout INFINITE;
C1: set transaction isolation level read committed;

C2: set transaction lock timeout INFINITE;
C2: set transaction isolation level read committed;

/* preparation */
C1: drop table if exists t1; 
C1: create table t1(id int, col varchar(10)) partition by range (id) (partition p1 values less than (10), partition p2 values less than (20));
C1: insert into t1 values(1,'abc'),(9,'def'),(10,'abc'),(11,'gh'),(null,'def'),(null,'abc');
C1: create index idx on t1(id);
C1: commit work;
MC: wait until C1 ready;

/* test case */
C1: delete from t1 where id is null;
C1: select * from t1 order by 1,2;
MC: wait until C1 ready;

C2: select * from t1 order by 1,2;
MC: wait until C2 ready;
C1: commit;
MC: wait until C1 ready;

C2: select * from t1 order by 1,2;
C2: select * from t1 order by 1,2;
C2: commit;
MC: wait until C2 ready;

C1: quit;
C2: quit;
