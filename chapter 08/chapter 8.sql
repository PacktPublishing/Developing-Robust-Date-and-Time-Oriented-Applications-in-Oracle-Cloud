-------------------------------------------------------
-- SECTION: NLS_DATE_FORMAT parameter
-------------------------------------------------------

alter session set NLS_DATE_FORMAT='DD.MM.YYYY HH24:MI:SS';

select sysdate from dual;

alter session set NLS_DATE_FORMAT='DD/MM/YYYY';

select sysdate from dual;

alter system 
  set NLS_DATE_FORMAT='DD.MM.YYYY HH24:MI:SS' SCOPE=SPFILE;

alter session set NLS_DATE_FORMAT='DD.MM.YYYY HH24:MI:SS';


-------------------------------------------------------
-- SECTION: NLS_DATE_LANGUAGE parameter
-------------------------------------------------------

alter session set NLS_DATE_LANGUAGE='English';

select TO_CHAR(sysdate, 'FM DD (DAY).MONTH.YYYY') 
  from dual;

alter session set NLS_DATE_LANGUAGE='French';

select TO_CHAR(sysdate, 'FM DD (DAY).MONTH.YYYY') 
  from dual; 


-------------------------------------------------------
-- SECTION: NLS_CALENDAR parameter
-------------------------------------------------------

alter session set NLS_CALENDAR='Gregorian';

alter session set NLS_DATE_FORMAT='DD.MM.YYYY HH:MI:SS';

alter session set NLS_CALENDAR='Arabic Hijrah'; 

select sysdate from dual;

-------------------------------------------------------
-- SECTION: NLS_TERRITORY parameter
-------------------------------------------------------

alter session set NLS_TERRITORY='America';

select TO_CHAR(sysdate, 'D') from dual;

alter session set NLS_TERRITORY='Belgium';

select TO_CHAR(sysdate, 'D') from dual; 


create or replace function IS_WORKDAY (p_date DATE)
 return integer
is
  week_nr integer;
begin
  week_nr:=TO_CHAR(p_date, 'D');
  if week_nr between 1 and 5 
     then return 1;
   elsif week_nr in (6,7) 
     then return 0;
   else return -1;
  end if;
end;
/

select sysdate, TO_CHAR(sysdate, 'DAY'),
       case IS_WORKDAY(sysdate) when 1 then 'IS WORKDAY'
                                when 0 then 'IS WEEKEND'
                                else 'UNKNOWN'
       end
  from dual;     


alter session set NLS_TERRITORY='America';  

select sysdate, TO_CHAR(sysdate+1, 'DAY'),
       case IS_WORKDAY(sysdate+1) when 1 then 'IS WORKDAY'
                                   when 0 then 'IS WEEKEND'
                                   else 'UNKNOWN'
       end
  from dual;    

create or replace function IS_WORKDAY(p_date DATE)
 return integer
is
  week_desc varchar(20);
begin
  week_desc:=trim(TO_CHAR(p_date, 'DAY'));
  if week_desc in ('MONDAY', 'TUESDAY', 'WEDNESDAY', 
                   'THURSDAY', 'FRIDAY') 
     then return 1;
  elsif week_desc in ('SATURDAY', 'SUNDAY') 
     then return 0;
  else return -1;
 end if;
end;
/

alter session set NLS_DATE_LANGUAGE='English';

select sysdate, TO_CHAR(sysdate, 'DAY'),
       case IS_WORKDAY(sysdate) when 1 then 'IS WORKDAY'
                                when 0 then 'IS WEEKEND'
                                else 'UNKNOWN'
       end
  from dual;  

alter session set NLS_DATE_LANGUAGE='French';

select sysdate, TO_CHAR(sysdate, 'DAY'),
       case IS_WORKDAY(sysdate) when 1 then 'IS WORKDAY'
                                when 0 then 'IS WEEKEND'
                                else 'UNKNOWN'
       end
  from dual;  

-------------------------------------------------------
-- SECTION: Embedding NLS parameter into TO_CHAR function
-------------------------------------------------------

-- SYNTAX: TO_CHAR
/*
TO_CHAR(<value> [, <format> [, <nls_parameter>]]
*/

select TO_CHAR(sysdate, 'D', 'NLS_DATE_LANGUAGE=American') 
  from dual;

create or replace function IS_WORKDAY(p_date DATE)
 return integer
is
 week_desc varchar(20);
begin
 week_desc:=trim(TO_CHAR(p_date, 
                         'DAY', 
                         'NLS_DATE_LANGUAGE=American'));
  if week_desc in ('MONDAY', 'TUESDAY', 'WEDNESDAY', 
                   'THURSDAY', 'FRIDAY') 
      then return 1;
  elsif week_desc in ('SATURDAY', 'SUNDAY') 
      then return 0;
  else return -1;
 end if;
end;
/

alter session set NLS_DATE_LANGUAGE='English';

select sysdate, TO_CHAR(sysdate, 'DAY'),
       case IS_WORKDAY(sysdate) when 1 then 'IS WORKDAY'
                                when 0 then 'IS WEEKEND'
                                else 'UNKNOWN'
       end
  from dual; 

alter session set NLS_DATE_LANGUAGE='Slovak';

select sysdate, TO_CHAR(sysdate+1, 'DAY'),
       case IS_WORKDAY(sysdate) when 1 then 'IS WORKDAY'
                                when 0 then 'IS WEEKEND'
                                else 'UNKNOWN'
       end
  from dual;   

create or replace function IS_WEEK_DAY(p_date DATE)
 return integer
is
 week_desc varchar(20);
begin
 week_desc:=trim(TO_CHAR(p_date, 
                         'DAY', 
                         'NLS_DATE_LANGUAGE=American'));
 case week_desc 
   when 'MONDAY'    then return 1;
   when 'TUESDAY'   then return 2;
   when 'WEDNESDAY' then return 3;
   when 'THURSDAY'  then return 4;
   when 'FRIDAY'    then return 5;
   when 'SATURDAY'  then return 6;
   when 'SUNDAY'    then return 7;
   else return -1;
 end case;
end;
/  

alter session set NLS_TERRITORY='America';

alter session set NLS_DATE_FORMAT='DD.MM.YYYY HH24:MI:SS';

select sysdate, TO_CHAR(sysdate+1, 'DAY'),
      IS_WEEK_DAY(sysdate+1) 
  from dual; 

alter session set NLS_TERRITORY='Belgium';

alter session set NLS_DATE_FORMAT='DD.MM.YYYY HH24:MI:SS';

select sysdate, TO_CHAR(sysdate+1, 'DAY'),
      IS_WEEK_DAY(sysdate+1) 
  from dual;

alter session set NLS_DATE_FORMAT='DD.MM.YYYY HH24:MI:SS';

select sysdate from dual;

alter session set NLS_DATE_FORMAT='DD.MM.YYYY HH24:MI:SS';

alter session set NLS_TERRITORY='America';

select sysdate from dual;

-------------------------------------------------------
-- SECTION: Other NLS parameters
-------------------------------------------------------

show parameter NLS_DATE

select * from nls_session_parameters
 where parameter like '%NLS_DATE%';

select parameter, value from nls_database_parameters;

CREATE OR REPLACE TRIGGER CHANGE_DATE_FORMAT
AFTER LOGON ON DATABASE
begin
 DBMS_SESSION.SET_NLS('NLS_DATE_FORMAT','YYYYMMDD');
end;
/

CREATE OR REPLACE TRIGGER DATABASE_AFTER_LOGON
  AFTER LOGON ON DATABASE
begin
  EXECUTE IMMEDIATE 'alter session set NLS_DATE_FORMAT = 
                       ''DD-MON-YYYY HH:MI:SS''';
end DATABASE_AFTER_LOGON;
/

-------------------------------------------------------
-- DROP
-------------------------------------------------------
drop function is_workday;
drop function is_week_day;
drop trigger CHANGE_DATE_FORMAT;
drop trigger DATABASE_AFTER_LOGON;
