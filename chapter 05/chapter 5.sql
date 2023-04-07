-------------------------------------------------------
-- SECTION: ANSI DATE constructor
-------------------------------------------------------

-- SYNTAX: ANSI DATE constructor
/*
DATE 'YYYY-MM-DD' 
*/

-- DATE
select DATE '2021-11-12' from dual;

select DATE '2021-12' from dual;
--> ORA-01861: literal does not match format string


-------------------------------------------------------
-- SECTION: TO_DATE function
-------------------------------------------------------

-- SYNTAX: TO_DATE 
/*
TO_DATE(<input_value> 
        [, <format> [, <nls_date_language_format> ]]);

*/

select TO_DATE('2021-11-10', 'YYYY-MM-DD') from dual;

select TO_DATE('2021-11-10') from dual; 
-- ORA-01861: literal does not match format string

select TO_DATE('2021-11-10', 'YYYY-MM-DD') from dual;

select TO_DATE('2021-10-11', 'YYYY-DD-MM') from dual;

select TO_DATE('11-10-2021', 'MM-DD-YYYY') from dual;

select TO_DATE('10.11.2021', 'DD.MM.YYYY') from dual;

select TO_DATEe('11/10/2021', 'MM/DD/YYYY') from dual;

select TO_DATE('10-11-2021 10:12:24','DD.MM.YYYY HH:MI:SS')   
  from dual;

select TO_DATE('10.11.2021 00:12:24', 
               'DD.MM.YYYY HH24:MI:SS') 
  from dual;

select TO_DATE('10.11.2021 12:24', 
               'DD.MM.YYYY MI:SS') 
  from dual;

select TO_DATE('11.2021', 'MM.YYYY') from dual;

select TO_DATE('5.2021', 'DD.YYYY') from dual;




-------------------------------------------------------
-- SECTION: ANSI TIMESTAMP constructor
-------------------------------------------------------

-- SYNTAX: TIMESTAMP
/*
TIMESTAMP 'YYYY-MM-DD HH24:MI:SS.FF'
*/

select TIMESTAMP '2021-05-01 16:20:15.1234' from dual;

select TIMESTAMP '2021-05 16:20:15.1234' from dual; 

declare 
 value TIMESTAMP(3);
begin
 value:=TO_TIMESTAMP('2021-05-01 16:20:15.1235', 
                     'YYYY-MM-DD HH24:MI:SS.FF');
 dDBMS_OUTPUT.PUT_LINE(value);
end;
/

-------------------------------------------------------
-- SECTION: TO_TIMESTAMP function
-------------------------------------------------------

-- SYNTAX: TO_TIMESTAMP
/*
TO_TIMESTAMP(<input_value> [, <format> ])
*/

select TO_TIMESTAMP('2021-05-01 16:20:15.1235', 
                    'YYYY-MM-DD HH24:MI:SS.FF') 
  from dual;


-------------------------------------------------------
-- SECTION: Time zone enhancements
-------------------------------------------------------

-- SYNTAX: TIMESTAMP + time zone reflection
/*
TIMESTAMP[(<n>)] WITH TIME ZONE
*/
  
select TIMESTAMP '2021-05-09 14:25:12.1234 -6:00' 
  from dual;

select TIMESTAMP '2021-05-09 14:25:12.1234 US/Pacific' 
  from dual;

select TIMESTAMP '2021-05-09 14:25:12.1234 Europe/Vienna' 
  from dual;

select tzname,tzabbrev from v$timezone_names;  


-- SYNTAX: TIMESTAMP with LOCAL TIME ZONE enhancements
/*
TIMESTAMP[(<n>)] WITH LOCAL TIME ZONE
*/


-------------------------------------------------------
-- SECTION: DATE and TIMESTAMP transformation
-------------------------------------------------------

create table Tab(id integer, 
                 date_val DATE, 
                 time_val TIMESTAMP);

insert into Tab 
  values(1, 
         TO_DATE('14/12/2021 15:24:12', 
                 'DD/MM/YYYY HH24:MI:SS'),  
         TO_TIMESTAMP('14/12/2021 15:24:12', 
                      'DD/MM/YYYY HH24:MI:SS'));

select * from Tab where id=1;

insert into Tab 
  values(2, 
         TO_TIMESTAMP('14/12/2021 15:24:12.9999', 
                      'DD/MM/YYYY HH24:MI:SS.FF'), 
         TO_DATE('14/12/2021 15:24:12', 
                  'DD/MM/YYYY HH24:MI:SS'));

select * from Tab where id=2;

drop table Tab;

create table Tab(id integer, 
                 date_val DATE, 
                 time_val TIMESTAMP WITH TIME ZONE);

insert into Tab 
  values(1, 
         TO_DATE('14/12/2021 15:24:12', 
                 'DD/MM/YYYY HH24:MI:SS'),     
         TO_TIMESTAMP('14/12/2021 15:24:12.9999', 
                      'DD/MM/YYYY HH24:MI:SS.FF'));

insert into Tab 
  values(2, 
         TO_TIMESTAMP('14/12/2021 15:24:12.9999', 
                      'DD/MM/YYYY HH24:MI:SS.FF'), 
         TO_DATE('14/12/2021 15:24:12', 
                 'DD/MM/YYYY HH24:MI:SS'));

select * from Tab;

drop table Tab;

create table Tab(id integer, 
                 date_val DATE, 
                 time_val TIMESTAMP WITH LOCAL TIME ZONE);
                 
insert into Tab 
   values(1, 
          TO_DATE('14/12/2021 15:24:12', 
                  'DD/MM/YYYY HH24:MI:SS'),  
          TO_TIMESTAMP('14/12/2021 15:24:12.9999', 
                       'DD/MM/YYYY HH24:MI:SS.FF'));
                       
insert into Tab 
  values(2, 
         TO_TIMESTAMP('14/12/2021 15:24:12.9999', 
                      'DD/MM/YYYY HH24:MI:SS.FF'), 
         TO_DATE('14/12/2021 15:24:12', 
                 'DD/MM/YYYY HH24:MI:SS'));
                 
select * from Tab;



-------------------------------------------------------
-- SECTION: Getting the actual date and time values
-------------------------------------------------------

select sysdate, current_date from dual;

select systimestamp, localtimestamp from dual;


-------------------------------------------------------
-- SECTION: DATE arithmetic
-------------------------------------------------------

select TO_DATE ('15.02.2022', 'DD.MM.YYYY') + 1 from dual;

select TO_DATE ('28.02.2022', 'DD.MM.YYYY') + 1 from dual;

select TO_DATE ('31.12.2022', 'DD.MM.YYYY') + 1 from dual;

select sysdate as now, 
       sysdate + 1/24 as one_hour_later, 
       sysdate -1/24 as one_hour_sooner
 from dual;
 
select to_date('15.02.2022', 'DD.MM.YYYY') 
        - to_date('13.02.2022', 'DD.MM.YYYY')
  from dual;
 
select TO_DATE ('15.02.2022 12:00:00', 
                'DD.MM.YYYY HH24:MI:SS')
        - TO_DATE ('15.02.2022 04:00:00', 
                   'DD.MM.YYYY HH24:MI:SS') 
 from dual;

-------------------------------------------------------
-- SECTION: INTERVAL DAY TO SECOND
-------------------------------------------------------
 
select INTERVAL '1 2:30:00' DAY TO SECOND from dual; 

select INTERVAL '2-10' YEAR TO MONTH from dual;

select sysdate, 
       sysdate + INTERVAL '1 2:30:00' DAY TO SECOND 
  from dual;
  
select sysdate, 
       sysdate + INTERVAL '1 2:30:00.634' DAY TO SECOND 
  from dual;

select TO_DATE('1.2.2021', 'DD.MM.YYYY') 
        + INTERVAL '28 5' DAY TO HOUR 
  from dual;
  
select TO_DATE('1.2.2020', 'DD.MM.YYYY') 
        + INTERVAL '28 5' DAY TO HOUR 
  from dual;
  
select INTERVAL '2-10' YEAR TO MONTH 
         + INTERVAL '3-3' YEAR TO MONTH  
 from dual;
 
select INTERVAL '2-10' YEAR TO MONTH 
         - INTERVAL '3-3' YEAR TO MONTH  
  from dual;

select INTERVAL '1 2:30:00' DAY TO SECOND 
        + INTERVAL '2-10' YEAR TO MONTH 
 from dual;
-- ORA-30081: invalid data type for datetime/interval arithmetic 

select sysdate, sysdate 
                  + INTERVAL '1 2:30:00' DAY TO SECOND 
                  + INTERVAL '2-10' YEAR TO MONTH 
 from dual;
 
create table tab_interval 
  as select sysdate + INTERVAL '1 2:30:00' DAY TO SECOND 
                    + INTERVAL '2-10' YEAR TO MONTH x 
      from dual;

desc tab_interval;

select localtimestamp, 
       localtimestamp
         + INTERVAL '4 5:12:10.222' DAY TO SECOND(3) 
  from dual;

select localtimestamp, localtimestamp + 1 from dual; 


-------------------------------------------------------
-- SECTION: TIMESTAMP arithmetic
-------------------------------------------------------

drop table Tab;

create table Tab as 
  select localtimestamp as val1, 
         localtimestamp + 1 val2 
    from dual;

    
desc Tab;  

create table Tab2(val timestamp);

insert into Tab2 values(systimestamp + INTERVAL '1' DAY);

insert into Tab2 values(systimestamp 
                         + INTERVAL '10' MONTH);

insert into Tab2 values(systimestamp 
                         + INTERVAL '10' YEAR);

insert into Tab2 values(systimestamp 
                         - INTERVAL '10' MINUTE);
                         
insert into Tab2 values(
 systimestamp - INTERVAL '4 5:12:10.222' DAY TO SECOND(3));
                         
create table Tab3 
 as select systimestamp - localtimestamp as result_val 
      from Tab2;

select TO_TIMESTAMP('17.6.2018', 'DD.MM.YYYY') 
        -  TO_TIMESTAMP('10.1.2000', 'DD.MM.YYYY') 
  from dual;

-------------------------------------------------------
-- DROP
------------------------------------------------------- 
drop table tab;
drop table tab_interval;
drop table tab2;
drop table tab3;
