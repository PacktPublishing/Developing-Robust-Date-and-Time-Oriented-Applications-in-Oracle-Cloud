-------------------------------------------------------
-- SECTION: Understanding TO_CHAR and TO_DATE conversion functions
-------------------------------------------------------

-- SYNTAX: TO_CHAR, TO_DATE
/*
TO_CHAR (<value> [, <format> [, <nls_parameter>]]
TO_DATE (<value> [, <format> [, <nls_parameter>]]
*/

drop table tab;

create table tab 
       as (select TO_CHAR(sysdate, 'MM') x from dual);

desc tab;

create table employee(id integer primary key, 
                      name varchar(30) not null, 
                      surname varchar(30) not null, 
                      date_from DATE not null, 
                      date_to DATE, 
                      position varchar(20), 
                      salary number(6,2));

insert into employee values(1, 'Jack', 'Smith', to_date('1.1.1990', 'DD.MM.YYYY'), to_date('31.12.2015', 'DD.MM.YYYY'), 'developer', 1000);
insert into employee values(2, 'John', 'Young', to_date('15.9.2020', 'DD.MM.YYYY'), null, 'manager', 3000);
insert into employee values(3, 'Mark', 'Barley', to_date('1.5.1993', 'DD.MM.YYYY'), to_date('9.6.2015', 'DD.MM.YYYY'), 'tester', 800);
insert into employee values(4, 'Arnas', 'Michel', to_date('1.6.2002', 'DD.MM.YYYY'), to_date('31.12.2003', 'DD.MM.YYYY'), 'senior developer', 2400);
insert into employee values(5, 'Tom', 'Moore', to_date('1.1.1990', 'DD.MM.YYYY'), null, 'junior tester', 950);
insert into employee values(6, 'Jack', 'Moore', to_date('1.1.2020', 'DD.MM.YYYY'), null, 'database admin', 3000);
insert into employee values(7, 'Jacob', 'Smith', to_date('1.1.2020', 'DD.MM.YYYY'), null, 'cloud operator', 2800);
insert into employee values(8, 'Thomas', 'Simson', to_date('1.1.1990', 'DD.MM.YYYY'), to_date('31.12.1990', 'DD.MM.YYYY'), 'database admin', 3200);
insert into employee values(9, 'Thomas', 'Simson', to_date('1.1.1991', 'DD.MM.YYYY'), to_date('31.12.1994', 'DD.MM.YYYY'), 'database integrator', 3800);
insert into employee values(10, 'Thomas', 'Simson', to_date('1.1.1995', 'DD.MM.YYYY'), null, 'analyst', 2800);

select * from employee 
  where TO_CHAR(date_from, 'YYYY')= 2020;

select * from employee 
  where to_char(date_from, 'YYYY')= '2020';


select sysdate, TO_CHAR(sysdate, 'D'),  
                TO_CHAR(sysdate, 'DD'),  
                TO_CHAR(sysdate, 'DDD') 
  from dual;

select TO_CHAR(sysdate, 'DD.MM.YYYY') from dual;

select sysdate, TO_CHAR(sysdate, 'DAY'), 
                TO_CHAR(sysdate, 'MONTH'), 
                TO_CHAR(sysdate, 'YEAR') 
  from dual;

select sysdate, TO_CHAR(sysdate, 'MONTH'), 
                TO_CHAR(sysdate, 'month') 
  from dual;


select sysdate, TO_CHAR(sysdate, 'mONTH'), 
                TO_CHAR(sysdate, 'MoNTh'), 
                TO_CHAR(sysdate, 'MONth') 
  from dual;

select sysdate, TO_CHAR(sysdate, 'YYYY'), 
                TO_CHAR(sysdate, 'YY') 
  from dual;

select TO_CHAR(sysdate, 'DAY, DD.MONTH.YYYY') from dual;

select TO_CHAR(sysdate, 'FM DAY, DD.MONTH.YYYY') 
  from dual; 

select TO_CHAR(sysdate, 'HH:MI:SS'), 
       TO_CHAR(sysdate, 'HH24:MI:SS') 
  from dual;

select TO_DATE('15.October.2020', 'dd.MONTH.yyyy') 
  from dual;

select TO_DATE('15.October.2020', 'dd.month.yyyy') 
  from dual;

select TO_DATE('15.FÉVRIER.2020', 'DD.MONTH.YYYY') 
  from dual;
--> ORA-01843: not a valid month

select TO_DATE('15.13.2020', 'DD.MM.YYYY') from dual;
--> ORA-01843: not a valid month

select TO_DATE('15.10.2020', 'DD/MM/YYYY') 
  from dual;

select TO_DATE('15.      10    .    2020', 'DD/MM/YYYY')   
  from dual;


-------------------------------------------------------
-- SECTION: Working with flexible format mapping
-------------------------------------------------------

alter session set nls_language='English';
alter session set nls_date_language='English';

select to_date('10.september 2022', 'DD.MM.YYYY') 
 from dual;

select to_date('30.february 2022', 'DD.MM.YYYY') 
 from dual;
-- ORA-01858: a non-numeric character was found where a numeric was expected

-- SYNTAX: TO_CHAR - default <default_value> on conversion error
/*
TO_CHAR (<value> 
         [default <default_value> on conversion error] 
         [, <format> [, <nls_parameter>]]
*/

select to_date('30.february 2022' 
                 default null on conversion error, 
              'DD.MM.YYYY') 
 from dual;
 
select to_date('30.february 2022' 
                 default '01.01.0001' on conversion error, 
              'DD.MM.YYYY') 
 from dual;
 
select to_date('10.september 2022', 'DD.MM.YYYY') 
 from dual;

select to_date('10.sep 2022', 'DD.MM.YYYY') 
 from dual;
 
select to_date('12.05.2000', 'DD-MON-YYYY')
  from dual; 

select to_date('1.february 2022' 
                 default null on conversion error, 
              'DD.MM.YYYY') 
 from dual;

select to_date('1.feb 2022' 
                 default null on conversion error, 
              'DD.MM.YYYY') 
 from dual; 
 
 
select to_date('10.september 2022', 'FX DD.MM.YYYY') 
 from dual;
select to_date('31.dec 2022', 'FX DD.MM.YYYY') 
 from dual;
select to_date('31.12.2022', 'FX DD.MON.YYYY') 
 from dual;


select TO_TIMESTAMP('15.12.2021 15:24:14:535', 
                    'DD.MM.YYYY HH24:MI:SS:FF') 
  from dual;


select TO_CHAR(systimestamp, 'DD.MM.YYYY HH24:MI:SS:FF') 
  from dual;


select TO_TIMESTAMP('15/12/2021 15.24.14.535', 
                    'DD.MM.YYYY HH24:MI:SS:FF') 
  from dual;



-------------------------------------------------------
-- SECTION: Conversion functions – century reference
-------------------------------------------------------
create table Tab1(val DATE);

insert into Tab1 values(TO_DATE('1-1-99', 'DD-MM-RR'));

select TO_CHAR(val, 'DD.MM.YYYY') from Tab1;

select TO_CHAR(val, 'DD.MM.RRRR') from Tab1;

delete from Tab1;

insert into Tab1 values (TO_DATE('1-1-99', 'DD-MM-YY'));

select TO_CHAR(val, 'DD.MM.YYYY') from Tab1;

select TO_CHAR(val, 'DD.MM.RRRR') from Tab1;

-------------------------------------------------------
-- SECTION: TIMESTAMP precision in SQL and PL/SQL
-------------------------------------------------------

select TO_CHAR(systimestamp,'FF') from dual;

begin
  DBMS_OUTPUT.PUT_LINE(TO_CHAR(systimestamp,'FF'));
end;
/

declare
 v_fractions varchar(6);
begin
  v_fractions := TO_CHAR(systimestamp,'FF');
end;
/

declare
  v_fractions varchar(6);
begin
  select TO_CHAR(systimestamp,'FF') into v_fractions 
    from dual;
end;
/

declare
  v_timestamp TIMESTAMP(6):=systimestamp;
  v_fractions varchar(6);
begin
  select TO_CHAR(v_timestamp,'FF') into v_fractions 
   from dual;
end;
/
--> ORA-06502: PL/SQL: numeric or value error: character string buffer too small

declare
 v_fractions varchar(6);
begin
  v_fractions := SUBSTR(TO_CHAR(systimestamp,'FF'),    
                        LENGTH(v_fractions));
end;
/


declare
 v_timestamp TIMESTAMP(6) WITH TIME ZONE;
 v_fractions varchar(6);
begin
  select systimestamp into v_timestamp 
    from dual;
  select SUBSTR(TO_CHAR(v_timestamp,'FF'),  
                length(v_fractions)) 
           into v_fractions 
    from dual;
  DBMS_OUTPUT.PUT_LINE(v_fractions);
end;
/

-------------------------------------------------------
-- SECTION: Getting to know the EXTRACT function
-------------------------------------------------------

select EXTRACT(day from sysdate) from dual;

select EXTRACT(hour from systimestamp) from dual;

select EXTRACT(timezone_hour from sysdate) from dual;
--> ORA-30076: invalid extract field for extract source

select EXTRACT(timezone_hour from systimestamp) from dual;

select EXTRACT(timezone_hour from localtimestamp) 
  from dual;
--> ORA-30076: invalid extract field for extract source


-------------------------------------------------------
-- SECTION: Reliability and integrity issues
-------------------------------------------------------
--> SYSTEM 1
  select sysdate, SUBSTR(sysdate, 4,2) from dual;

--> SYSTEM 2
  select sysdate, SUBSTR(sysdate, 4,2) from dual;


-------------------------------------------------------
-- SECTION: Investigating the CAST function
-------------------------------------------------------

-- SYNTAX: CAST
/*
CAST ( {<expression> | NULL } as <output_datatype> )
*/

-------------------------------------------------------
-- SECTION: CASTing character string to DATE value
-------------------------------------------------------

select CAST('15/1/2000' as DATE) from dual;

select CAST('2000/1/15' as DATE) from dual;

-------------------------------------------------------
-- SECTION: CASTing numerical value to DATE value
-------------------------------------------------------

select CAST('02032022' as date) from dual;

select CAST('20220302' as date) from dual;

-------------------------------------------------------
-- SECTION: CASTing DATE value to TIMESTAMP format
-------------------------------------------------------

select sysdate, CAST(sysdate as TIMESTAMP) from dual;

select CAST(sysdate AS TIMESTAMP WITH LOCAL TIME ZONE)
 from dual;

-------------------------------------------------------
-- SECTION: CASTing TIMESTAMP value to DATE format
-------------------------------------------------------

select systimestamp, CAST(systimestamp as DATE) from dual;

-------------------------------------------------------
-- SECTION: CASTing DATE value to character string format
-------------------------------------------------------

select CAST(sysdate as char(20)) from dual;

select CAST(sysdate as varchar(30)) from dual;

select CAST(sysdate as char(1)) from dual;
--> ORA-25137: "Data value out of range"

select CAST(sysdate as varchar(3)) from dual;
--> ORA-01801: 
--> "date format is too long for internal buffer"

-------------------------------------------------------
-- SECTION: CASTing TIMESTAMP value to character string format
-------------------------------------------------------

select CAST(systimestamp as char(100)) from dual;

select CAST(systimestamp as varchar(100)) from dual;

select CAST(systimestamp as char(1)) from dual;
--> ORA-25137: "Data value out of range"

select CAST(systimestamp as varchar(3)) from dual;
--> ORA-01801: 
--> "date format is too long for internal buffer"

-------------------------------------------------------
-- SECTION: CASTing NULL
-------------------------------------------------------

select CAST(null as DATE) from dual; 

select CAST(null as TIMESTAMP) from dual;

-------------------------------------------------------
-- SECTION: Validating conversions
-------------------------------------------------------

select validate_conversion('12-05-2000' as date, 
                           'DD-MM-YYYY') 
 from dual; --> 1

select validate_conversion('12.05.2000' as date, 
                           'DD-MM-YYYY') 
 from dual;  --> 1

select validate_conversion('12-SEPTEMBER-2000' as date, 
                           'DD-MON-YYYY') 
 from dual; --> 1

select validate_conversion('12-SEPTEMBER-2000' as date, 
                           'FXDD-MON-YYYY') 
 from dual; --> 0

select validate_conversion('12-SEPTEMBER-2000' as date, 
                           'FXDD-MM-YYYY') 
 from dual; --> 0

select validate_conversion('31-SEPTEMBER-2000' as date, 
                           'DD-MM-YYYY') 
 from dual; --> 0

-------------------------------------------------------
-- DROP
-------------------------------------------------------
drop table tab;
drop table employee;
drop table tab1;
