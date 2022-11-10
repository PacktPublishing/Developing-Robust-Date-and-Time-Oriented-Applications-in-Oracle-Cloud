-------------------------------------------------------
-- SECTION: Background & origin
-------------------------------------------------------

select sysdate, current_date from dual;

select SYS.STANDARD.SESSIONTIMEZONE from dual;
select SESSIONTIMEZONE from dual;

select DBTIMEZONE from dual;

-- SYNTAX: alter session set time_zone
/*
alter session set time_zone= ' {  {+ | -} <TZH>:<TZM> 
                             | <timezone_name> }’;
*/

alter session set time_zone='+3:00';

alter session set time_zone='-3:00';

alter session set time_zone='UTC';

alter session set time_zone='Europe/Lisbon';

alter session set time_zone=dbtimezone;

alter database set time_zone= ' {  {+ | -} <TZH>:<TZM> 
                              | <timezone_name> }';
SHUTDOWN IMMEDIATE;
STARTUP;

alter database set time_zone='-3:00';

alter database set time_zone='UTC';

alter database set time_zone='Europe/Vienna';

alter database set time_zone=sessiontimezone;

create database . . .  set time_zone='+00:00';


select (sysdate - current_date)*24 as TZH from dual;


-------------------------------------------------------
-- SECTION: TIMESTAMP & transformation across the time zones
-------------------------------------------------------

select SYS.STANDARD.systimestamp from dual;  

select systimestamp from dual;

select SYS.STANDARD.current_timestamp from dual;  

select current_timestamp from dual;

alter session 
  set NLS_TIMESTAMP_TZ_FORMAT=
                       'DD.MM.RR HH24:MI:SSXFF TZH:TZM';

alter system 
  set NLS_TIMESTAMP_TZ_FORMAT=
                       'DD.MM.RR HH24:MI:SSXFF TZH:TZM' 
      scope=spfile;

alter session 
   set NLS_TIMESTAMP_TZ_FORMAT=
                        'DD.MM.RR HH24:MI:SSXFF TZH:TZM';


create table timetab2 as 
  select 
     FROM_TZ(TIMESTAMP '2000-03-28 08:00:00', '3:00') t1,   
     TIMESTAMP '2000-03-28 08:00:00' t2
   from dual;

desc timetab2;

select current_timestamp, 
       current_timestamp AT TIME ZONE 'Australia/Sydney' 
 from dual;

select current_timestamp AT TIME ZONE 'Europe/Bratislava',   
       current_timestamp AT TIME ZONE '3:00' 
 from dual;

select current_date AT TIME ZONE 'US/Eastern' from dual;

select CAST(DATE '2014-04-08' as TIMESTAMP) d1,
       CAST(DATE '2014-04-08' as TIMESTAMP) 
                             AT TIME ZONE 'US/Easter' d2, 
       CAST(DATE '2014-04-08' as TIMESTAMP) 
                             AT TIME ZONE '3:00' d3
 from dual;

select FROM_TZ(CAST(sysdate as TIMESTAMP), '5:00') 
            AT TIME ZONE 'Europe/Brussels'
 from dual;


-------------------------------------------------------
-- SECTION: FROM_TZ function
-------------------------------------------------------
-- SYNTAX: FROM_TZ
/*
FROM_TZ( <timestamp_value>, <time_zone_value> )
*/

select FROM_TZ(TIMESTAMP '2022-04-28 9:40:05', '5:00')
 from dual;

select FROM_TZ(to_timestamp ('2022-04-28 9:40:05', 
                             'YYYY-MM-DD HH:MI:SS'), 
               'Pacific/Honolulu')
 from dual;

-------------------------------------------------------
-- SECTION: NEW_TIME
-------------------------------------------------------
select
  TO_DATE('15-12-2015 03:23:45',  'DD-MM-YYYY HH24:MI:SS') 
                     "Original date and time",
   NEW_TIME(TO_DATE('15-12-2015 03:23:45', 
                     'DD-MM-YYYY HH24:MI:SS'),
            'AST', 'PST') 
 		          "New date and time" 
 from dual;

select 
   NEW_TIME(TO_DATE('15-12-2015 03:23:45', 
                    'DD-MM-YYYY HH24:MI:SS'),
           '05:00', '07:00') "New date and time" 
 from dual;

-------------------------------------------------------
-- SECTION: Converting time zones
-------------------------------------------------------

create or replace function CONVERT_DATE_TIMEZONES
 (p_date DATE, 
  input_timezone varchar, 
  output_timezone varchar
  )
 return date
   is
     v_timestamp TIMESTAMP WITH TIME ZONE;
begin
   v_timestamp:=FROM_TZ(CAST(p_date AS TIMESTAMP), 
                        input_timezone);
   return CAST(v_timestamp AT TIME ZONE output_timezone  
               as DATE); 
end;
/


select sysdate "Original value",
       FROM_TZ(CAST (sysdate as TIMESTAMP), '05:00') 
              "Value extended by the input time zone",
       CONVERT_DATE_TIMEZONES(sysdate, '05:00', '07:00') 
              "Output" 
 from dual;  


-------------------------------------------------------
-- SECTION: Extracting UTC
-------------------------------------------------------

alter session set time_zone='3:00';

select current_timestamp,     
       SYS_EXTRACT_UTC(current_timestamp) 
  from dual;

select SYS_EXTRACT_UTC(FROM_TZ(CAST(sysdate AS TIMESTAMP), 
                              '3:00')),
   SYS_EXTRACT_UTC(FROM_TZ(CAST(current_date AS TIMESTAMP),
                          '3:00'))
 from dual;

select TZ_OFFSET('Europe/Paris')
 from dual;   

select TZ_OFFSET('3:00')
 from dual;

-- SYNTAX: TZ_OFFSET
/*
select TZ_OFFSET({ '<time_zone_name>'
         	 	| '{ + | - } <hh> : <mi>'
          		| SESSIONTIMEZONE
          		| DBTIMEZONE
                 }
                )
 from dual;

*/

alter session set time_zone='Europe/Vienna';
select
    SESSIONTIMEZONE,
    TZ_OFFSET(SESSIONTIMEZONE)
 from dual;

alter session set time_zone='+00:00';
select
    SESSIONTIMEZONE,
    TZ_OFFSET(SESSIONTIMEZONE)
 from dual;

alter session set time_zone='+UTC';
select
    SESSIONTIMEZONE,
    TZ_OFFSET(SESSIONTIMEZONE)
 from dual;


-------------------------------------------------------
-- SECTION: Local value reflection
-------------------------------------------------------
create table timetab(t1 TIMESTAMP, 
                     t2 TIMESTAMP WITH TIME ZONE, 
                     t3 TIMESTAMP WITH LOCAL TIME ZONE);

alter session set time_zone='3:00';

insert into timetab 
 values(TO_TIMESTAMP('11.1.2022 15:24:12.4', 
                     'DD.MM.YYYY HH24:MI:SS.FF'), 
        TO_TIMESTAMP('11.1.2022 15:24:12.4',  
                     'DD.MM.YYYY HH24:MI:SS.FF'),
        TO_TIMESTAMP('11.1.2022 15:24:12.4',  
                     'DD.MM.YYYY HH24:MI:SS.FF'));

alter session set time_zone='5:00';

select * from timetab;

select t2, t2 AT TIME ZONE '5:00' from timetab; 

select t2, t2 AT TIME ZONE sessiontimezone from timetab;

select DBTIMEZONE, SESSIONTIMEZONE from dual;

select t3 from timetab;

select t3, t3 AT TIME ZONE sessiontimezone from timetab;

create table timetab5(id integer,
                      t1 timestamp, 
                      t2 timestamp with time zone, 
                      t3 timestamp with local time zone);

-------------------------------------------------------
-- SECTION: Local vs. global merchantability
-------------------------------------------------------

select * 
 from orders 
   where order_date > sysdate – 1/24; 


-------------------------------------------------------
-- DROP
-------------------------------------------------------
drop table timetab;
drop table timetab2;
drop table timetab5;
drop function CONVERT_DATE_TIMEZONES;
