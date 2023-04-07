-------------------------------------------------------
-- SECTION: Getting to know the ADD_MONTHS function
-------------------------------------------------------

-- SYNTAX: ADD_MONTHS
/*
ADD_MONTHS(<date_val>, <number_months>)
*/

select ADD_MONTHS(TO_DATE('15.02.2022', 'DD.MM.YYYY'), 7)   
  from dual;

select ADD_MONTHS(TO_DATE('15.02.2022', 'DD.MM.YYYY'), -7) 
  from dual;

select ADD_MONTHS(TO_DATE ('15.02.2021', 'DD.MM.YYYY'), 17) 
  from dual;

select ADD_MONTHS(TO_DATE ('31.01.2022', 'DD.MM.YYYY'), 1) 
  from dual;

select ADD_MONTHS(TO_DATE ('31.01.2024', 'DD.MM.YYYY'), 1) 
  from dual;

select ADD_MONTHS(TO_DATE ('31.03.2022','DD.MM.YYYY'), -1) 
  from dual;

select ADD_MONTHS(TO_DATE ('30.03.2022','DD.MM.YYYY'), -1) 
  from dual;

select ADD_MONTHS(TO_DATE ('29.03.2022','DD.MM.YYYY'), -1) 
  from dual;

select ADD_MONTHS(TO_DATE ('28.03.2022','DD.MM.YYYY'), -1) 
  from dual;

select ADD_MONTHS(TO_DATE('27.03.2022', 'DD.MM.YYYY'), -1)   
  from dual;

create or replace function ADD_YEARS(dat_val DATE, 
                                     number_years number)
 return DATE
is
 begin
  return ADD_MONTHS(dat_val, 12*number_years);
 end;
/

select sysdate + INTERVAL '1' MONTH from dual;


select TO_CHAR(p_date, 'DD'), 
       TO_CHAR(p_date, 'MM'), 
       TO_CHAR(p_date, 'YYYY')
   into v_day_orig, v_month_orig, v_year_orig
 from dual;


select v_year_orig 
       + decode(TRUNC((v_month_orig + p_month_shift) / 12), 
                0, 
                -1, 
                TRUNC((v_month_orig + p_month_shift) / 12)
               ) 
      into v_year_shifted 
 from dual;


create or replace function ADD_MONTHS_OWN
           (p_date DATE, p_month_shift integer)
 return varchar
is
 v_day_orig integer;
 v_month_orig integer;
 v_year_orig integer;
 v_last_day_orig integer;
 v_last_day_shifted integer;
 v_day_shifted integer;
 v_month_shifted integer;
 v_year_shifted integer;
 v_time_representation char(8);
begin
 if p_month_shift=0 
    then return p_date;
 end if;

 select TO_CHAR(p_date, 'DD'), 
        TO_CHAR(p_date, 'MM'), 
        TO_CHAR(p_date, 'YYYY')
     into v_day_orig, v_month_orig, v_year_orig
  from dual;
 
 v_time_representation:=TO_CHAR(p_date, 'HH24:MI:SS');

select v_year_orig 
       + DECODE(TRUNC((v_month_orig + p_month_shift) / 12), 
                       0, -1, trunc((v_month_orig 
                              + p_month_shift) / 12)
               ) 
  into v_year_shifted from dual;

 v_month_shifted:=mod(v_month_orig + p_month_shift, 12);  
 if v_month_shifted<=0 
    then v_month_shifted:=v_month_shifted + 12; 
 end if;
 
 v_last_day_orig:=TO_CHAR(last_day(p_date), 'DD');
 v_last_day_shifted:=TO_CHAR(last_day
  (TO_DATE('01.'||v_month_shifted||'.'||v_year_shifted,   
           'DD.MM.YYYY')), 
                             'DD');

 if v_day_orig=v_last_day_orig then   
    v_day_shifted:=v_last_day_shifted; 
 elsif v_day_orig>v_last_day_shifted 
    then v_day_shifted:=v_last_day_shifted;
 else v_day_shifted:=v_day_orig;
 end if;   

  return TO_DATE(v_day_shifted||'.'
                 ||v_month_shifted||'.'
                 ||v_year_shifted ||'.'
                 || v_time_representation, 
                     'DD.MM.YYYY HH24:MI:SS');
end;
/  


select sysdate, 
       ADD_MONTHS_OWN(sysdate, 1), 
       ADD_MONTHS(sysdate, 1) 
 from dual;


select ADD_MONTHS_OWN(TO_DATE('28.2.2022', 'DD.MM.YYYY'), 
                               -1)
  from dual;


select ADD_MONTHS_OWN(TO_DATE('28.2.2022', 'DD.MM.YYYY'), 
                               -63) 
  from dual;


-------------------------------------------------------
-- SECTION: Identifying the number of days in a month using LAST_DAY
-------------------------------------------------------

-- SYNTAX: LAST_DAY
/*
LAST_DAY(<date_val>)
*/


select LAST_DAY(TO_DATE('10.1.2022', 'DD.MM.YYYY')) 
  from dual;

select LAST_DAY(TO_DATE('15.2.2023', 'DD.MM.YYYY')) 
  from dual;

select LAST_DAY(TO_DATE('15.2.2024', 'DD.MM.YYYY')) 
  from dual;


select systimestamp,
       LAST_DAY(systimestamp), 
       LAST_DAY(sysdate)  
 from dual;

-------------------------------------------------------
-- SECTION: Understanding the usage of the MONTHS_BETWEEN function
-------------------------------------------------------

-- SYNTAX: MONTHS_BETWEEN
/*
MONTHS_BETWEEN(date_val1, date_val2)
*/


select MONTHS_BETWEEN(TO_DATE ('15.12.2022', 'DD.MM.YYYY'),
                      TO_DATE ('15.2.2022', 'DD.MM.YYYY')) 
  from dual;

select MONTHS_BETWEEN(TO_DATE ('15.2.2022', 'DD.MM.YYYY'),
                      TO_DATE ('15.12.2022', 'DD.MM.YYYY')) 
  from dual;

select
  MONTHS_BETWEEN(TO_DATE('15.12.2022 6:22:12',
                          'DD.MM.YYYY HH:MI:SS'),
                 TO_DATE('13.2.2022 5:13:12', 
                          'DD.MM.YYYY HH:MI:SS')) 
  from dual;



-------------------------------------------------------
-- SECTION: Exploring principles of NEXT_DAY function
-------------------------------------------------------

-- SYNTAX: NEXT_DAY
/*
NEXT_DAY(<date_val>, <weekday>)
*/

select actual_date, 
       TO_CHAR(actual_date, 'DAY'), 
       NEXT_DAY(actual_date, 'SUNDAY'), 
       TO_CHAR(NEXT_DAY(actual_date, 'SUNDAY'), 'DAY')
  from (select TO_DATE ('23.2.2022', 'DD.MM.YYYY') 
                                         as actual_date
          from dual);

select actual_date, 
       TO_CHAR(actual_date, 'DAY'), 
       NEXT_DAY(actual_date, 'SUNDAY' ), 
       TO_CHAR(NEXT_DAY(actual_date, 'SUNDAY' ), 'DAY')
  from (select TO_DATE ('27.2.2022', 'DD.MM.YYYY') 
 	                                   as actual_date
          from dual);

-------------------------------------------------------
-- SECTION: Impact of language definition on NEXT_DAY function
-------------------------------------------------------

alter session set nls_date_language='English';

select NEXT_DAY(TO_DATE('1.1.2022', 'DD.MM.YYYY'), 'MON')  
  from dual;  

select NEXT_DAY(TO_DATE('1.1.2022', 'DD.MM.YYYY'), 'SAT') 
  from dual;  

select NEXT_DAY(TO_DATE('1.1.2022 17:24:12', 
                         'DD.MM.YYYY HH24:MI:SS'),   
                'SAT') 
  from dual;

select systimestamp, NEXT_DAY(systimestamp, 'MON')
  from dual;

select NEXT_DAY(TO_DATE('1.1.2022', 'DD.MM.YYYY'), 
                'MONXXX') from dual;


alter session set NLS_DATE_LANGUAGE='German';


select NEXT_DAY(TO_DATE('1.1.2022', 'DD.MM.YYYY'), 'TUE') 
  from dual;
--> ORA-01846: "not a valid day of the week"

select NEXT_DAY(TO_DATE('1.1.2022', 'DD.MM.YYYY'), 'DIE') 
  from dual;


select NEXT_DAY(TO_DATE('1.1.2022', 'DD.MM.YYYY'), 'MON') 
  from dual;

select NEXT_DAY(TO_DATE('1.1.2022', 'DD.MM.YYYY'), 1)
  from dual;

select SYS.STANDARD.NEXT_DAY(sysdate, 'MON') from dual; 
select NEXT_DAY(sysdate, 'MON') from dual; 


-------------------------------------------------------
-- SECTION: Implementing NEXT_DATE function
-------------------------------------------------------

create or replace function NEXT_DATE(p_date_val date, p_spec varchar)
 return date
is 
 v_weekday varchar(20);
 v_input_day_nr integer;
 v_output_day_nr integer;
 shift integer;
 function get_shift(i integer, j integer)
  return 
   integer
 is
  begin
    if i=j then return 7; 
           else return mod(7-i+j, 7);
    end if;
  end; 
begin
 select to_char(p_date_val, 'DAY', 
                            'nls_date_language=American') 
         into v_weekday 
  from dual;
  -- input day number
 case trim(v_weekday)
    when 'MONDAY'    then v_input_day_nr:=1;
    when 'TUESDAY'   then v_input_day_nr:=2;
    when 'WEDNESDAY' then v_input_day_nr:=3;                   
    when 'THURSDAY'  then v_input_day_nr:=4;
    when 'FRIDAY'    then v_input_day_nr:=5;
    when 'SATURDAY'  then v_input_day_nr:=6;
    when 'SUNDAY'    then v_input_day_nr:=7;
    else raise_application_error(-20000,
               'Input format not correctly specified');
 end case; 
 -- output day number
 case trim(p_spec)
    when 'MON'  then v_output_day_nr:=1;
    when 'TUE'  then v_output_day_nr:=2;
    when 'WED'  then v_output_day_nr:=3;                   
    when 'THU'  then v_output_day_nr:=4;
    when 'FRI'  then v_output_day_nr:=5;
    when 'SAT'  then v_output_day_nr:=6;
    when 'SUN'  then v_output_day_nr:=7;
    when '1'    then v_output_day_nr:=1;
    when '2'    then v_output_day_nr:=2;
    when '3'    then v_output_day_nr:=3;                   
    when '4'    then v_output_day_nr:=4;
    when '5'    then v_output_day_nr:=5;
    when '6'    then v_output_day_nr:=6;
    when '7'    then v_output_day_nr:=7;
    else raise_application_error(-20001,
               'Output format not correctly specified');
 end case; 
  shift:=get_shift(v_input_day_nr,v_output_day_nr); 
 return p_date_val+ shift; 
end;
/

-------------------------------------------------------
-- SECTION: Numerical day of week representation related to the NEXT_DATE function
-------------------------------------------------------

create or replace function NEXT_DATE
   (p_date_val date, p_spec varchar, 
    p_sunday_first integer default 0)
 return date
is 
 v_weekday varchar(20);
 v_input_day_nr integer;
 v_output_day_nr integer;
 shift integer;
function get_shift(i integer, j integer)
  return 
   integer
 is
  begin
    if i=j then return 7; 
           else return mod(7-i+j, 7);
    end if;
  end;
 function is_numeric(p_spec varchar)
  return boolean
 is
  v_integer integer;
  begin
   v_integer:=to_number(p_spec);
   return true;
   exception when others then return false;
  end;
begin
 if p_sunday_first=1 and is_numeric(p_spec) then
     return NEXT_DATE(p_date_val,case 
                                   when p_spec=1 then 7 
                                   else p_spec-1 
                                 end, 0);
 end if;  
 select to_char(p_date_val, 'DAY', 
                           'nls_date_language=American') 
        into v_weekday 
  from dual;
  -- input day number
 case trim(v_weekday)
    when 'MONDAY'    then v_input_day_nr:=1;
    when 'TUESDAY'   then v_input_day_nr:=2;
    when 'WEDNESDAY' then v_input_day_nr:=3;                   
    when 'THURSDAY'  then v_input_day_nr:=4;
    when 'FRIDAY'    then v_input_day_nr:=5;
    when 'SATURDAY'  then v_input_day_nr:=6;
    when 'SUNDAY'    then v_input_day_nr:=7;
    else raise_application_error(-20000,
               'Input format not correctly specified');
 end case; 
 
-- output day number
 case trim(p_spec)
    when 'MON'  then v_output_day_nr:=1;
    when 'TUE'  then v_output_day_nr:=2;
    when 'WED'  then v_output_day_nr:=3;                   
    when 'THU'  then v_output_day_nr:=4;
    when 'FRI'  then v_output_day_nr:=5;
    when 'SAT'  then v_output_day_nr:=6;
    when 'SUN'  then v_output_day_nr:=7;
    when '1'    then v_output_day_nr:=1;
    when '2'    then v_output_day_nr:=2;
    when '3'    then v_output_day_nr:=3;                   
    when '4'    then v_output_day_nr:=4;
    when '5'    then v_output_day_nr:=5;
    when '6'    then v_output_day_nr:=6;
    when '7'    then v_output_day_nr:=7;
    else raise_application_error(-20001,
               'Output format not correctly specified');
 end case; 
   shift:=get_shift(v_input_day_nr,v_output_day_nr);
  return p_date_val+ shift; 
end;
/

-------------------------------------------------------
-- SECTION: Getting the second Sunday of the month
-------------------------------------------------------

create or replace function GETSECONDSUNDAY(p_date_val DATE)
 return DATE
is
 v_date DATE;
 v_weekday varchar(20);
begin
-- step 1
 v_date:=TRUNC(p_date_val, 'MM');
-- step 2
 select trim(TO_CHAR(v_date, 'DAY', 
                             'nls_date_language=American')) 
        into v_weekday 
  from dual;
-- step 3
 if v_weekday = 'SUNDAY' 
     then return v_date+7;
 else return NEXT_DATE (v_date,'SUN')+7;
 end if;
end;
/

select GETSECONDSUNDAY(TO_DATE('7.3.2022', 'DD.MM.YYYY')) 
  from dual;


-------------------------------------------------------
-- SECTION: Investigating the TRUNC function
-------------------------------------------------------

-- SYNTAX: TRUNC
/*
TRUNC(<date_val>, [<format>])
*/

select sysdate from dual;

select TRUNC(sysdate) from dual;

select TRUNC(sysdate, 'DD') from dual;

select TRUNC(sysdate, 'MM') from dual;

select TRUNC(sysdate, 'YY') from dual;

select LAST_DAY(sysdate) from dual;

select TRUNC(ADD_MONTHS (sysdate,1), 'MM')-1 from dual;

select TRUNC(sysdate, 'CC') from dual;

select TRUNC(sysdate, 'Q') 
  from dual;

select TRUNC(to_date ('15.6.2020', 'DD.MM.YYYY'), 'Q') 
  from dual;


-------------------------------------------------------
-- SECTION: TRUNC function and week management
-------------------------------------------------------

select TRUNC(TO_DATE('10.1.2022', 'DD.MM.YYYY'), 'W') 
  from dual;

select TRUNC(TO_DATE('12.1.2022', 'DD.MM.YYYY'), 'IW') 
 from dual;

select TRUNC(TO_DATE('10.2.2022', 'DD.MM.YYYY'), 'WW') 
  from dual;

select TRUNC(TO_DATE('18.2.2022', 'DD.MM.YYYY'), 'WW') 
  from dual;


-------------------------------------------------------
-- SECTION: Understanding the usage of the ROUND function 
-------------------------------------------------------

-- SYNTAX: ROUND
/*
ROUND (<input_date> [, <format>])
*/

select ROUND(TO_DATE('26.1.2022 10:15:22', 
                     'DD.MM.YYYY HH24:MI:SS'), 'DD') 
  from dual;

select ROUND(TO_DATE('26.1.2022 16:15:22', 
                     'DD.MM.YYYY HH24:MI:SS'), 'DD') 
  from dual;


select ROUND(TO_DATE('26.1.2022 12:00:00', 
                     'DD.MM.YYYY HH24:MI:SS'), 'DD') 
  from dual;


select ROUND(TO_DATE('17.6.2022', 'DD.MM.YYYY'), 'YYYY') 
  from dual;


select ROUND(TO_DATE('15.2.2022 00:00:00', 
                     'DD.MM.YYYY HH24:MI:SS'), 'MM') 
  from dual;


select LAST_DAY(TO_DATE('15.2.2022 00:00:00', 
                        'DD.MM.YYYY HH24:MI:SS'))
         -(TO_DATE('15.2.2022 00:00:00', 
                   'DD.MM.YYYY HH24:MI:SS')) 
  from dual;


select (TO_DATE('15.2.2022 00:00:00', 
                'DD.MM.YYYY HH24:MI:SS'))
          -TRUNC(TO_DATE('15.2.2022 00:00:00', 
                         'DD.MM.YYYY HH24:MI:SS'), 'MM') 
  from dual;

select ROUND(TO_DATE('15.2.2022 00:00:00', 
                     'DD.MM.YYYY HH24:MI:SS'), 'MM') 
 from dual;


select ROUND(TO_DATE('15.2.2022 23:59:59', 
                     'DD.MM.YYYY HH24:MI:SS'), 'MM') 
  from dual;


-------------------------------------------------------
-- SECTION: Getting to know PERSONAL_ID and birthday management
-------------------------------------------------------

create or replace function PIDTOBIRTH(p_pid varchar2)	
 return DATE
is 
 val varchar2(11);
begin
 val:=substr(p_pid,5,2)||'-'			-- DAY
      ||mod(substr(p_pid,3,2),50)      	-- MONTH
      ||case length(trim(p_pid))
         when 10 then '19'
         else '20'
        end 
      ||'-'
      || substr(p_pid,1,2);          	-- YEAR
 return TO_DATE(val, 'dd-mm-yyyy');
    EXCEPTION WHEN OTHERS 
     THEN return TO_DATE('01-01-0001', 'dd-mm-yyyy');
end;
/

select name, surname 
  from personal_data
   where to_char(PIDTOBIRTH(PERSONAL_ID), 'DD.MM')
                     =TO_CHAR(sysdate, 'DD.MM');


select name, surname 
 from personal_data
  where PIDTOBIRTH(PERSONAL_ID)=sysdate;

select name, surname 
  from personal_data
   where to_char(PIDTOBIRTH(PERSONAL_ID), 'DD.MM.YYYY')
                     =TO_CHAR(sysdate, 'DD.MM.YYYY');


-------------------------------------------------------
-- SECTION: Generating random dates
-------------------------------------------------------

-- SYNTAX: DBMS_RANDOM.VALUE
/*
DBMS_RANDOM.VALUE
  RETURN NUMBER;
DBMS_RANDOM.VALUE(
  <low>  IN  NUMBER,
  <high> IN  NUMBER)
RETURN NUMBER;

*/


create or replace function GENERATEBIRTH(L_year integer,  
                                         R_year integer)
 return DATE
  is
 v_date DATE;
 v_year integer;
 v_month integer;
 v_day_limit integer;
 v_day integer;
begin
	-- getting year element
 v_year:=DBMS_RANDOM.VALUE(l_year,r_year);
	-- getting month element
 v_month:=DBMS_RANDOM.VALUE(1,12);
	-- getting right border for the day of month
 v_day_limit:=TO_CHAR(
               LAST_DAY(TO_DATE(v_month||'.'||v_year,   
                                'MM.YYYY')), 
                        'DD');
      -- getting day element
   v_day:=DBMS_RANDOM.VALUE(1, v_day_limit);
      -- providing output
   return TO_DATE(v_day||'.'||v_month||'.'||v_year, 
                  'DD.MM.YYYY'); 
end;
/


select TRUNC(TO_DATE(2022, 'YYYY'), 'YYYY') 
        + DBMS_RANDOM.VALUE(0,364) 
  from dual;

create or replace function GENERATEBIRTH(L_year integer, 
                                         R_year integer) 
  return DATE
is
  start_limit DATE;
  end_limit DATE;
  difference integer;
begin
  start_limit:=TRUNC(TO_DATE(L_year, 'YYYY'), 'YYYY');
  end_limit:=TRUNC(TO_DATE(R_year+1, 'YYYY'), 'YYYY')-1;
  difference:=end_limit-start_limit;
  return start_limit 
         + ROUND(DBMS_RANDOM.VALUE(0,difference)); 
end;
/

-------------------------------------------------------
-- DROP
-------------------------------------------------------

drop function add_years;
drop function ADD_MONTHS_OWN;
drop function NEXT_DATE;
drop function GETSECONDSUNDAY;
drop function PIDTOBIRTH;
drop function GENERATEBIRTH;
drop table personal_data;


