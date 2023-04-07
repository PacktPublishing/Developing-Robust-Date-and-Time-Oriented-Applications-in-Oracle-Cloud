-------------------------------------------------------
-- SECTION: Leap second and Oracle database reflection
-------------------------------------------------------

-- setting language for the messages between client and database environment. 
alter session set nls_language='American';

-- leap second
select TO_DATE('31.12.2016, 23:59:60', 
               'DD.MM.YYYY HH24:MI:SS') 
 from dual;
-- ORA-01852: seconds must be between 0 and 59 

-- getting elapse
select EXTRACT( SECOND FROM 
                (TIMESTAMP '2017-07-01 00:00:00.000' 
                 - TIMESTAMP '2016-12-31 23:59:59.000')
               ) from dual;

-- managing leap second as a character string
create table T(id integer, occurrence varchar(30));

insert into T values(500, '2016-12-31 23:59:60.000');

-------------------------------------------------------
-- DROP
-------------------------------------------------------
drop table T;
