-------------------------------------------------------
-- SECTION: Getting current state
-------------------------------------------------------

create table Tab(ID integer, 
                 BD DATE, 
                 ED DATE, 
                 DATA varchar(20), 
                 primary key(ID, BD)
                );

insert into Tab values(1, TO_DATE('15.1.2022', 'DD.MM.YYYY'), null, 'state 1 obj. 1');
insert into Tab values(2, TO_DATE('10.3.2022', 'DD.MM.YYYY'), TO_DATE('12.3.2022', 'DD.MM.YYYY'), 'state 1 obj. 2');
insert into Tab values(2, TO_DATE('13.3.2022', 'DD.MM.YYYY'), TO_DATE('17.3.2022', 'DD.MM.YYYY'), 'state 2 obj. 2');
insert into Tab values(2, TO_DATE('20.5.2022', 'DD.MM.YYYY'), TO_DATE('28.5.2022', 'DD.MM.YYYY'), 'state 3 obj. 2');
insert into Tab values(3, TO_DATE('20.5.2022', 'DD.MM.YYYY'), TO_DATE('28.5.2022', 'DD.MM.YYYY'), 'state 1 obj. 3');


SELECT ID, BD, DATA 
 FROM
   (SELECT tab.*, 
           RANK() over(PARTITION BY ID ORDER BY BD desc)  
                                                as rank
     FROM Tab
   )
  WHERE rank=1;

SELECT * 
 FROM TAB
   WHERE (ID, BD) in (SELECT id, max(BD)
                       FROM TAB
                        GROUP BY ID);

SELECT * 
 FROM Tab
   WHERE (ID, BD) in (SELECT ID, max(BD)
                       FROM Tab
                        GROUP BY ID);


SELECT * FROM Tab 
 ORDER BY BD 
  FETCH FIRST 1 ROW ONLY;

SELECT  ID, 
        BD, 
        LEAD(BD) OVER(PARTITION BY ID ORDER BY BD) as ED, 
        DATA
 FROM Tab;


SELECT Tab.*, RANK() OVER(ORDER BY BD) as rank
 FROM Tab
  WHERE BD>T and ID=OBJ_REF;

SELECT * 
 FROM
   (SELECT Tab.*, RANK() OVER(ORDER BY BD)  as rank
     FROM Tab
      WHERE BD>T and ID=OBJ_REF
    )
  WHERE rank=1;

-------------------------------------------------------
-- SECTION: Closed - closed representation
-------------------------------------------------------
create table employee(id integer primary key, 
                      name varchar(30) not null, 
                      surname varchar(30) not null, 
                      date_from date not null, 
                      date_to date, 
                      position varchar(20), 
                      salary number(6,2));

insert into employee values(1, 'Jack', 'Smith', to_date('1.1.1990', 'DD.MM.YYYY'), to_date('31.12.2015', 'DD.MM.YYYY'), 'developer', 1000);
insert into employee values(2, 'John', 'Young', to_date('15.9.2000', 'DD.MM.YYYY'), null, 'manager', 3000);
insert into employee values(3, 'Mark', 'Barley', to_date('1.5.1993', 'DD.MM.YYYY'), to_date('9.6.2015', 'DD.MM.YYYY'), 'tester', 800);
insert into employee values(4, 'Arnas', 'Michel', to_date('1.6.2002', 'DD.MM.YYYY'), to_date('31.12.2003', 'DD.MM.YYYY'), 'senior developer', 2400);
insert into employee values(5, 'Tom', 'Moore', to_date('1.1.1990', 'DD.MM.YYYY'), null, 'junior tester', 950);
insert into employee values(6, 'Jack', 'Moore', to_date('1.1.2000', 'DD.MM.YYYY'), null, 'database admin', 3000);
insert into employee values(7, 'Jacob', 'Smith', to_date('1.1.2020', 'DD.MM.YYYY'), null, 'cloud operator', 2800);
insert into employee values(8, 'Thomas', 'Simson', to_date('1.1.1990', 'DD.MM.YYYY'), to_date('31.12.1990', 'DD.MM.YYYY'), 'database admin', 3200);
insert into employee values(9, 'Thomas', 'Simson', to_date('1.1.1991', 'DD.MM.YYYY'), to_date('31.12.1994', 'DD.MM.YYYY'), 'database integrator', 3800);
insert into employee values(10, 'Thomas', 'Simson', to_date('1.1.1995', 'DD.MM.YYYY'), null, 'analyst', 2800);


SELECT * 
  FROM employee
   WHERE T between DATE_FROM and DATE_TO;

SELECT * 
 FROM employee
   WHERE DATE_FROM<=TBD 
     AND DATE_TO>=TED;

SELECT * 
 FROM employee
  WHERE <DATE_FROM, DATE_TO> intersects <TBD, TED>;

SELECT * 
 FROM employee
  WHERE (TBD between DATE_FROM and DATE_TO)
              OR
        (TED between DATE_FROM and DATE_TO);

-------------------------------------------------------
-- SECTION: Closed - open representation
-------------------------------------------------------
SELECT * 
 FROM employee
  WHERE T between DATE_FROM and DATE_TO-1;

 SELECT * 
  FROM employee
   WHERE T >= DATE_FROM AND T < DATE_TO;


-------------------------------------------------------
-- SECTION: Coverage
-------------------------------------------------------
SELECT * 
 FROM employee
  WHERE DATE_FROM <= TBD 
    AND DATE_TO >= TED;

SELECT * 
 FROM employee
  WHERE <DATE_FROM, DATE_TO) intersects <TBD, TED);

SELECT * 
 FROM employee
  WHERE (TBD >= DATE_FROM and TBD < DATE_TO)
                OR
        (TED > DATE_FROM and TED <= DATE_TO);


-------------------------------------------------------
-- SECTION: Modeling unlimited validity
-------------------------------------------------------

DECLARE
  date1 DATE:=MaxValueTime;
  date2 DATE:=TO_DATE('31.12.9999', 'DD.MM.YYYY');
BEGIN
 IF date1=date2 THEN 
  DBMS_OUTPUT.PUT_LINE('values are the same...');
 ELSE 
  DBMS_OUTPUT.PUT_LINE('values are different...');
 END IF; 
END;
/

DECLARE
  date1 DATE:=MaxValueTime;
  date2 DATE:=MaxValueTime;
BEGIN
 IF date1=date2 THEN 
  DBMS_OUTPUT.PUT_LINE('values are the same...');
 ELSE 
  DBMS_OUTPUT.PUT_LINE('values are different...');
 END IF; 
END;
/

DECLARE
  date1 DATE:=NULL;
  date2 DATE:=NULL;
BEGIN
 IF date1=date2 THEN 
  DBMS_OUTPUT.PUT_LINE('values are the same...');
 ELSE 
  DBMS_OUTPUT.PUT_LINE('values are different...');
 END IF; 
END;
/

DECLARE
  date1 DATE:=NULL;
  date2 DATE:=NULL;
BEGIN
 IF date1<>date2 THEN 
  DBMS_OUTPUT.PUT_LINE('values are the same...');
 ELSE 
  DBMS_OUTPUT.PUT_LINE('values are different...');
 END IF; 
END;
/

CREATE OR REPLACE TRIGGER MAXVALTRIG
  BEFORE INSERT OR UPDATE ON Tab
FOR EACH ROW
BEGIN
  IF :new.ED IS NULL 
    THEN :new.ED:=MaxValueTime;
  END IF;
END;
/

CREATE TABLE Tab
 (ID integer, 
  BD DATE, 
  ED DATE default on null MaxValueTime, 
  data ...);


-------------------------------------------------------
-- SECTION: Managing duration - getting elapse
-------------------------------------------------------

select TO_DATE('15.1.2022', 'DD.MM.YYYY') 
         - TO_DATE('10.1.2022', 'DD.MM.YYYY') 
  from dual;


select TO_DATE('15.1.2022 15:12:03', 
               'DD.MM.YYYY HH24:MI:SS')
         - TO_DATE('10.1.2022 5:18:26', 
                   'DD.MM.YYYY HH24:MI:SS') as days 
  from dual;


select (TO_DATE('15.1.2022 15:12:03', 
                'DD.MM.YYYY HH24:MI:SS') 
         - TO_DATE('10.1.2022 5:18:26', 
                   'DD.MM.YYYY HH24:MI:SS'))*24 
             as hours 
 from dual;

select (TO_DATE('15.1.2022 15:12:03', 
                'DD.MM.YYYY HH24:MI:SS') 
          - TO_DATE('10.1.2022 5:18:26', 
                    'DD.MM.YYYY HH24:MI:SS'))*24*60 
              as minutes 
 from dual;


select (TO_DATE('15.1.2022 15:12:03', 
                'DD.MM.YYYY HH24:MI:SS') 
        - TO_DATE('10.1.2022 5:18:26', 
                  'DD.MM.YYYY HH24:MI:SS'))*24*60*60 
            as seconds 
 from dual;

select TO_DATE('1.2.2022', 'DD.MM.YYYY') 
        - TO_DATE('1.1.2022', 'DD.MM.YYYY') 
 from dual;

select TO_DATE('1.3.2022', 'DD.MM.YYYY') 
        - TO_DATE('1.2.2022', 'DD.MM.YYYY') 
 from dual;

select TO_DATE('1.3.2024', 'DD.MM.YYYY') 
        - TO_DATE('1.2.2024', 'DD.MM.YYYY') 
 from dual;

-------------------------------------------------------
-- SECTION: Sophisticated solution for getting duration
-------------------------------------------------------
create or replace function GET_DIFFERENCE_DATE
                           (pDate1 date, pDate2 date)
 return varchar
is
 v_shift boolean:=false;
 v_date1 date;
 v_date2 date;
 v_updatedDate date;
 v_year_count integer;
 v_month_count integer;
 v_day_count integer;
 v_second_difference integer;
 v_hour_count integer;
 v_minute_count integer;
 v_second_count integer;
begin
 if pDate1 > pDate2 
   then v_date1:=pDate2;
        v_date2:=pDate1;
        v_shift:=true;
 else
  v_date1:=pDate1;
  v_date2:=pdate2;
 end if;
  v_year_count:=trunc(months_between(v_date2,v_date1) / 12);
  v_updatedDate:=add_months(v_date1, v_year_count * 12);
  v_month_count:=trunc(months_between(v_date2,v_updatedDate));
  v_updatedDate:=add_months(v_updatedDate, v_month_count);
   v_day_count:= trunc(v_date2 - v_updatedDate);
    v_second_difference:=(v_date2 
                          - add_months(v_date1,
                                       12*v_year_count
                                        + v_month_count) 
                                        - v_day_count)*24*60*60;
  v_hour_count:=trunc(v_second_difference/3600);
  v_minute_count:=trunc((v_second_difference 
                        - v_hour_count*3600)/60);
  v_second_count:=trunc(v_second_difference 
                      - v_hour_count*3600 
                      - v_minute_count*60);
  return case v_shift when true then '-' 
                    when false then '+'
                    else '' 
         end           
          	|| v_year_count || ' years, '
          	|| v_month_count || ' months, '
          	|| v_day_count || ' days, '
         	|| v_hour_count || ' hours, '
          	|| v_minute_count || ' minutes, '
          	|| v_second_count || ' seconds. ';           
end;
/


select GET_DIFFERENCE_DATE(
   TO_DATE('10.1.2020 15:10:22', 'DD.MM.YYYY HH24:MI:SS'),
   TO_DATE('29.4.2023 11:00:11','DD.MM.YYYY HH24:MI:SS')) 
            as difference
      from dual;

select GET_DIFFERENCE_DATE(
   TO_DATE('8.4.2016 15:10:22', 'DD.MM.YYYY HH24:MI:SS'),
   TO_DATE('6.3.2014 11:00:11','DD.MM.YYYY HH24:MI:SS')) 
            as difference
      from dual;



-------------------------------------------------------
-- SECTION: Remarks – Date vs. Timestamp to get the elapse
-------------------------------------------------------

select  TO_TIMESTAMP('8.4.2016 15:10:22', 
                     'DD.MM.YYYY HH24:MI:SS')
      - TO_DATE('6.3.2014 11:00:11',
                 'DD.MM.YYYY HH24:MI:SS')
   from dual;

select  EXTRACT( 
           hour from (TO_TIMESTAMP('8.4.2016 15:10:22', 
                                   'DD.MM.YYYY HH24:MI:SS')
                      - TO_DATE('6.3.2014 11:00:11',
                                'DD.MM.YYYY HH24:MI:SS')))
  from dual;


select GET_DIFFERENCE_DATE(
                  TO_TIMESTAMP('8.4.2016 15:10:22.12', 
                               'DD.MM.YYYY HH24:MI:SS.FF'),
                  TO_TIMESTAMP('6.3.2014 11:00:11.17',
                               'DD.MM.YYYY HH24:MI:SS.FF')) 
            as difference
      from dual;   


create or replace function GET_DIFFERENCE_TIMESTAMP
                  (pTimestamp1 timestamp, 
                   pTimestamp2 timestamp)
 return varchar
is
 v_shift boolean:=false;
 v_date1 date;
 v_date2 date;
 v_fraction1 integer;
 v_fraction2 integer;
 v_updatedDate date;
 v_year_count integer;
 v_month_count integer;
 v_day_count integer;
 v_second_difference integer;
 v_hour_count integer;
 v_minute_count integer;
 v_second_count number(5,2);
begin
if pTimestamp1 > pTimestamp2 
   then v_date1:=pTimestamp2;
        v_date2:=pTimestamp1;
        v_shift:=true;
        v_fraction1:=to_char(pTimestamp2, 'FF');
        v_fraction2:=to_char(pTimestamp1, 'FF');
 else
      v_date1:=pTimestamp1;
      v_date2:=pTimestamp2;
      v_fraction1:=to_char(pTimestamp1, 'FF');
      v_fraction2:=to_char(pTimestamp2, 'FF');
 end if;
 if v_fraction2 < v_fraction1
 then
  v_fraction2:=v_fraction2 + 1000000000; 
                             -- adding one second
  v_date2:=v_date2 - Interval '1' second;
 end if; 
  v_year_count:=trunc(months_between(v_date2,v_date1) / 12);
  v_updatedDate:=add_months(v_date1, v_year_count * 12);
  v_month_count:=trunc(months_between(v_date2,v_updatedDate));
  v_updatedDate:=add_months(v_updatedDate, v_month_count);
  v_day_count:= trunc(v_date2 - v_updatedDate);
  v_second_difference:=(v_date2 
                      - add_months(v_date1,
                                   12*v_year_count
                                   + v_month_count) 
                                   - v_day_count)*24*60*60;
  v_hour_count:=trunc(v_second_difference/3600);
  v_minute_count:=trunc((v_second_difference 
                        - v_hour_count*3600)/60);
  v_second_count:=trunc(v_second_difference 
                      - v_hour_count*3600 
                      - v_minute_count*60);
 return case v_shift when true then '-' 
                      when false then '+'
                    else '' 
         end           
          	|| v_year_count || ' years, '
          	|| v_month_count || ' months, '
            || v_day_count || ' days, '
         	|| v_hour_count || ' hours, '
          	|| v_minute_count || ' minutes, '
          	|| v_second_count ||'.'
  		    || to_char(v_fraction2-v_fraction1)  
            || ' seconds. ';           
end;
/


-------------------------------------------------------
-- DROP
-------------------------------------------------------
drop table tab; 
drop table employee;
drop trigger MaxValTrig;
drop function GET_DIFFERENCE_DATE;
drop function GET_DIFFERENCE_TIMESTAMP;
