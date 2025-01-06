--+ server-message on

-- Verifies : CBRD-25658
-- default : procedure default 
-- If CUBRID string and NULL are bundled, NULL is output.
-- When expressed in Oracle style, set the system parameter in ".conf" to 'oracle_style_empty_string=yes' and run the database.

CREATE OR REPLACE PROCEDURE default_procedure_simple (
    p_id INTEGER DEFAULT 100
) AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('1: ' || p_id);
END;

CREATE OR REPLACE PROCEDURE default_procedure_with_pseudo (
    p_date DATE DEFAULT SYSDATE,
    p_id INTEGER DEFAULT 100,
    p_null_value INTEGER DEFAULT NULL,
    p_null_string VARCHAR DEFAULT 'NULL',
    p_empty_string VARCHAR DEFAULT '',
    p_user VARCHAR DEFAULT USER,
    p_fuser VARCHAR DEFAULT USER(),
    p_cuser VARCHAR DEFAULT CURRENT_USER
) AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('1: ' || CASE isnull(p_date) WHEN 0 THEN 'ok' WHEN 1 THEN 'nok' END);  
    DBMS_OUTPUT.PUT_LINE('2: ' || p_id);
    DBMS_OUTPUT.PUT_LINE('3: ' || p_null_value);
    DBMS_OUTPUT.PUT_LINE('4: ' || p_null_string);
    DBMS_OUTPUT.PUT_LINE('5: ' || p_empty_string);
    DBMS_OUTPUT.PUT_LINE('6: ' || CASE isnull(p_user) WHEN 0 THEN 'ok' WHEN 1 THEN 'nok' END);
    DBMS_OUTPUT.PUT_LINE('7: ' || CASE WHEN p_fuser = USER() THEN 'ok' ELSE 'no' END);
    DBMS_OUTPUT.PUT_LINE('8: ' || CASE isnull(p_cuser) WHEN 0 THEN 'ok' WHEN 1 THEN 'nok' END);
END;

CREATE OR REPLACE PROCEDURE default_proc_tochar (
    p_formatted_date VARCHAR DEFAULT TO_CHAR(SYSDATE, 'YYYY-MM-DD')
) AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Formatted Date: ' || CASE isnull(p_formatted_date) WHEN 0 THEN 'ok' WHEN 1 THEN 'nok' END);
END;

call default_procedure_simple ();
call default_procedure_with_pseudo ();
call default_proc_tochar ();

select * from _db_stored_procedure_args where sp_of.sp_name = 'default_procedure_simple';
select * from _db_stored_procedure_args where sp_of.sp_name = 'default_procedure_with_pseudo';
select * from _db_stored_procedure_args where sp_of.sp_name = 'default_proc_tochar';

drop procedure default_procedure_simple;
drop procedure default_procedure_with_pseudo;
drop procedure default_proc_tochar;

--+ server-message off
