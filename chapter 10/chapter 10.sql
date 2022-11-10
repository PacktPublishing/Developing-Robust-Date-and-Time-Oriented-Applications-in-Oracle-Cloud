-------------------------------------------------------
-- SECTION: Concepts of temporal validity
-------------------------------------------------------

Create table Emp
 (employee_id integer not null, 
  name varchar(20) not null,
  surname varchar(20) not null,
  date_from DATE not null,
  date_to DATE, 
  position varchar(20) not null, 
  salary number(6,2) not null, 
  PERIOD FOR VALIDITY(date_from,date_to)
 );


Create table Emp
 (employee_id integer not null, 
  name varchar(20) not null,
  surname varchar(20) not null,
  position varchar(20) not null, 
  salary number(6,2) not null, 
  PERIOD FOR validity
 );


select COLUMN_NAME, DATA_TYPE, COLUMN_ID,
       SEGMENT_COLUMN_ID, INTERNAL_COLUMN_ID, 
       HIDDEN_COLUMN 
 from USER_TAB_COLS 
  where TABLE_NAME='EMP';

select constraint_name, constraint_type, search_condition 
 from user_constraints 
  where table_name='EMP'
    and search_condition_vc not like '%NOT NULL%';

insert into Emp(employee_id, name, surname, 
                date_from, 
                date_to, 
                position, salary) 
   values(1, 'Michal', 'Kvet', 
          TO_DATE('1.1.2010', 'DD.MM.YYYY'), 
          TO_DATE('1.1.2020', 'DD.MM.YYYY'),
          'Researcher', 1000);

insert into Emp(employee_id, name, surname, 
                date_from, 
                date_to, 
                position, salary) 
   values(1, 'Michal', 'Kvet', 
          TO_DATE('1.1.2020', 'DD.MM.YYYY'), 
          null, 
          'University teacher', 1200);   


insert into Emp(employee_id, name, surname, 
                date_from, 
                date_to, 
                position, salary) 
   values(2, 'Karol', 'Matiasko', 
          TO_DATE('1.1.2001', 'DD.MM.YYYY'), 
          null, 
          'Manager', 1500); 


insert into Emp 
  values(3, 'Stefan', 'Toth', 
         TO_DATE('1.1.2005', 'DD.MM.YYYY'), 
         null, 'Developer', 1300);
insert into Emp
   values(3, 'Stefan', 'Toth', 
          TO_DATE('1.1.2006', 'DD.MM.YYYY'), 
          null, 'Tester', 700);

insert into Emp
   values(4, 'Emil', 'Krsak', 
          TO_DATE('1.1.2005', 'DD.MM.YYYY'), 
          TO_DATE('1.1.2002', 'DD.MM.YYYY'),
          'Development Manager', 1400);    
--> ORA-02290: check constraint KVET3.VALIDITYcon violated  

insert into Emp
   values(5, 'Vitaly', 'Levashenko', 
          TO_DATE('1.1.2005', 'DD.MM.YYYY'), 
          TO_DATE('1.1.2005', 'DD.MM.YYYY'),
          'Development Manager', 1400);       
--> ORA-02290: check constraint KVET3.VALIDITYcon violated  

insert into Emp
   values(6, 'Elena', 'Zaitseva', 
          TO_DATE('1.1.2005 00:00:00',      
    		       'DD.MM.YYYY HH24:MI:SS'), 
          TO_DATE('1.1.2005 00:00:01', 
                  'DD.MM.YYYY HH24:MI:SS'), 
          'Development Manager', 1400);

create table sensor_tab
 (sensor_id integer not null, 
  value integer, 
  ts_from TIMESTAMP(6), 
  ts_to TIMESTAMP(6), 
  PERIOD FOR duration(ts_from,ts_to)
 );


insert into sensor_tab 
  values(1,5,
         TO_TIMESTAMP('12.1.2022 14:12:22.643891',
                      'DD.MM.YYYY HH24:MI:SS.FF'), 
         TO_TIMESTAMP('12.1.2022 14:12:22.643892',
                      'DD.MM.YYYY HH24:MI:SS.FF'));



insert into sensor_tab 
 values(2,3,
        TO_TIMESTAMP('12.1.2022 14:12:22.6438910',
                     'DD.MM.YYYY HH24:MI:SS.FF'), 
        TO_TIMESTAMP('12.1.2022 14:12:22.6438914',
                     'DD.MM.YYYY HH24:MI:SS.FF'));


insert into sensor_tab 
 values(3,8,
        TO_TIMESTAMP('12.1.2022 14:12:22.6438910',
                     'DD.MM.YYYY HH24:MI:SS.FF'), 
        TO_TIMESTAMP('12.1.2022 14:12:22.6438915',
                     'DD.MM.YYYY HH24:MI:SS.FF'));  


select * from sensor_tab where sensor_id=3;

select * 
 from Emp
  where date_from <=sysdate 
    and NVL(date_to, sysdate)>=sysdate;


select * 
 from Emp
  where date_from <=TO_DATE('1.1.2022', 'DD.MM.YYYY') 
    and date_to IS NULL;


-- SYNTAX: DBMS_FLASHBACK_ARCHIVE.ENABLE_AT_VALID_TIME
/*
DBMS_FLASHBACK_ARCHIVE.ENABLE_AT_VALID_TIME (
   level          IN    VARCHAR2, 
   query_time     IN    TIMESTAMP DEFAULT SYSTIMESTAMP);

*/

-- SYNTAX: DBMS_FLASHBACK_ARCHIVE.ENABLE_AT_VALID_TIME
/*
DBMS_FLASHBACK_ARCHIVE.ENABLE_AT_VALID_TIME
  ( { ALL | CURRENT | ASOF,QUERY_TIME } )

*/

select * from Emp;

EXECUTE    
   DBMS_FLASHBACK_ARCHIVE.ENABLE_AT_VALID_TIME('CURRENT');
select * from emp;

EXECUTE DBMS_FLASHBACK_ARCHIVE.ENABLE_AT_VALID_TIME('ALL');
select * from emp;


EXECUTE 
   DBMS_FLASHBACK_ARCHIVE.ENABLE_AT_VALID_TIME('ASOF', 
          			        TO_DATE('1-DEC-2020 00:00:00', 
                   		   'DD-MON-YYYY HH24:MI:SS'));
select * from Emp;


-- SYNTAX: GRANT
/*
GRANT execute ON DBMS_FLASHBACK_ARCHIVE to <username>;
*/


-------------------------------------------------------
-- SECTION: Concepts of temporal validity
-------------------------------------------------------
select DBMS_METADATA.GET_DDL('TABLE', 'EMP') from dual; 

CREATE TABLE "KVET3"."EMP" 
   (	"EMPLOYEE_ID" NUMBER(*,0) NOT NULL ENABLE, 
	"NAME" VARCHAR2(20) NOT NULL ENABLE, 
	"SURNAME" VARCHAR2(20) NOT NULL ENABLE, 
	"DATE_FROM" DATE NOT NULL ENABLE, 
	"DATE_TO" DATE, 
	"POSITION" VARCHAR2(20) NOT NULL ENABLE, 
	"SALARY" NUMBER(6,2) NOT NULL ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
  NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 
          MINEXTENTS 1 MAXEXTENTS 2147483645
          PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
          BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT   
          CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "SMALL_TBLSPC" 
  ALTER TABLE "KVET3"."EMP" 
        ADD PERIOD FOR "VALIDITY"("DATE_FROM","DATE_TO");


declare
 ddl_code clob;
 is_temporal integer;
begin
 for i in (select trim(table_name) as tab_name 
            from user_tables)
  loop
   select DBMS_METADATA.GET_DDL('TABLE', i.tab_name) 
          into ddl_code 
    from dual;
   select count(*) into is_temporal 
    from dual
     where ddl_code like '%PERIOD FOR%';
   if is_temporal>0 then 
    DBMS_OUTPUT.PUT_LINE(i.tab_name);
   end if;
  end loop;
end;
/

select column_name, hidden_column
 from user_tab_cols
  where table_name='EMP';


Create table Emp2
 (employee_id integer not null, 
  name varchar(20) not null,
  surname varchar(20) not null,
  date_from DATE not null,
  date_to DATE, 
  position varchar(20) not null, 
  salary number(6,2) not null
 );  


EXECUTE DBMS_FLASHBACK_ARCHIVE.ENABLE_AT_VALID_TIME('ALL');
 insert into emp2 select * from emp;

select count(*) from emp2;	
select count(*) from emp;	

EXECUTE   
   DBMS_FLASHBACK_ARCHIVE.ENABLE_AT_VALID_TIME('CURRENT');

select count(*) from emp2;	
select count(*) from emp;

desc SYS_FBA_PERIOD;


select periodname, periodstart, periodend
  from sys.SYS_FBA_PERIOD
  where obj# IN
    ( select object_id
       from user_objects
         where object_name = 'EMP'
    );


create or replace view validity_period_view as
   select name table_name,
          periodname period_name,
          periodstart period_start,
          periodend period_end
    from sys.sys_fba_period join 
         sys.obj$ using(obj#)
     where owner# = userenv('SCHEMAID');



create or replace public synonym validity_period_view 
  for kvet3.validity_period_view;


-------------------------------------------------------
-- DROP
-------------------------------------------------------

drop table emp;
drop table sensor_tab;
drop table emp2;
drop view validity_period_view;
drop public synonym validity_period_view;
