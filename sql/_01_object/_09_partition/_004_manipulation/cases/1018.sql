--test insert(time) for many list partition(have NULL value) with null value.
create table list_test(id int not null,	                
			   test_time time,                              
			   test_date date,                              
			   test_timestamp timestamp,
                           primary key (id, test_time))                    
	PARTITION BY LIST (test_time) (                                 
	PARTITION p0 VALUES IN ('09:00:00','09:10:00','09:20:00'),      
	PARTITION p1 VALUES IN ('10:00:00','10:10:00','10:20:00',NULL), 
	PARTITION p2 VALUES IN ('11:00:00','11:10:00','11:20:00')       
);                                                                      

insert into list_test values(4,'10:00:00','2006-03-01','2006-03-01 09:00:00');
insert into list_test values(5,'10:10:00','2006-03-11','2006-03-11 09:00:00');
insert into list_test values(9,NULL,NULL,NULL);         
select * from list_test order by 1;


drop table list_test;
