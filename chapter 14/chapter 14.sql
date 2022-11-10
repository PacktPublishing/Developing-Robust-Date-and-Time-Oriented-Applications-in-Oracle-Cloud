-------------------------------------------------------
-- SECTION: SQL injection
-------------------------------------------------------

create table v_emp(employee_id integer primary key, 
                      name varchar(30) not null, 
                      surname varchar(30) not null, 
                      date_from date not null, 
                      date_to date, 
                      position varchar(20), 
                      salary number(6,2));

insert into v_emp values(1, 'Jack', 'Smith', to_date('1.1.1990', 'DD.MM.YYYY'), to_date('31.12.2015', 'DD.MM.YYYY'), 'developer', 1000);
insert into v_emp values(2, 'John', 'Young', to_date('15.9.2000', 'DD.MM.YYYY'), null, 'manager', 3000);
insert into v_emp values(3, 'Mark', 'Barley', to_date('1.5.1993', 'DD.MM.YYYY'), to_date('9.6.2015', 'DD.MM.YYYY'), 'tester', 800);
insert into v_emp values(4, 'Arnas', 'Michel', to_date('1.6.2002', 'DD.MM.YYYY'), to_date('31.12.2003', 'DD.MM.YYYY'), 'senior developer', 2400);
insert into v_emp values(5, 'Tom', 'Moore', to_date('1.1.1990', 'DD.MM.YYYY'), null, 'junior tester', 950);
insert into v_emp values(6, 'Jack', 'Moore', to_date('1.1.2000', 'DD.MM.YYYY'), null, 'database admin', 3000);
insert into v_emp values(7, 'Jacob', 'Smith', to_date('1.1.2020', 'DD.MM.YYYY'), null, 'cloud operator', 2800);
insert into v_emp values(8, 'Thomas', 'Simson', to_date('1.1.1990', 'DD.MM.YYYY'), to_date('31.12.1990', 'DD.MM.YYYY'), 'database admin', 3200);
insert into v_emp values(9, 'Thomas', 'Simson', to_date('1.1.1991', 'DD.MM.YYYY'), to_date('31.12.1994', 'DD.MM.YYYY'), 'database integrator', 3800);
insert into v_emp values(10, 'Thomas', 'Simson', to_date('1.1.1995', 'DD.MM.YYYY'), null, 'analyst', 2800);


create or replace procedure get_employees(p_date date)
is
 v_statement varchar2(10000);
 v_cursor sys_refcursor;
 v_ns varchar(100);
 v_pid varchar(11);
begin
 v_statement:='select name || '' '' || surname as ns, 
                      employee_id
                from v_emp
                 where date_from>='''||p_date||'''';
  open v_cursor for v_statement;
   loop
     fetch v_cursor into v_ns, v_pid;
    exit when v_cursor%notfound;
     dbms_output.put_line(v_ns ||': ' || v_pid);
   end loop;
  close v_cursor;
end;
/

alter session set nls_date_format='YYYY-MM-DD';

exec get_employees(to_date('1.1.2015', 'DD.MM.YYYY'));
exec get_employees(sysdate);

select name || ' ' || surname as ns, employee_id
 from v_emp
   where date_from='2015-01-01';

alter session 
 set nls_date_format = '"'' union select surname,salary from v_emp --"';

select name || ' ' || surname as ns, employee_id
  from v_emp
     where date_from='' 
 union 
select surname,salary from v_emp --';
;

exec get_employees(sysdate);
-- It provides the salary of the employees!!!

create or replace procedure get_employees(p_date date)
is
 v_statement varchar2(10000);
 v_cursor sys_refcursor;
 v_ns varchar(100);
 v_pid varchar(11);
begin
 v_statement:='select name || '' '' || surname as ns, 
                      employee_id
                from v_emp
                 where date_from <= :bind_date';
    dbms_output.put_line(v_statement);            
  open v_cursor for v_statement using p_date;
   loop
     fetch v_cursor into v_ns, v_pid;
      exit when v_cursor%notfound;
     dbms_output.put_line(v_ns ||': ' || v_pid);
   end loop;
  close v_cursor;
end;
/

alter session 
 set nls_date_format = '"'' union select ''hack'',1000 from dual --"';

exec get_employees(sysdate);



-------------------------------------------------------
-- SECTION: Explicit Date and Time value conversion
-------------------------------------------------------


select name || ' ' || surname as ns, employee_id
 from v_emp
  where to_char(date_from, 'DD.MM.YYYY') 
                       <= to_char(p_date, 'DD.MM.YYYY');

alter session set nls_date_format='"hack"';


select name || ' ' || surname as ns, 
  employee_id
    from v_emp
      where to_char(date_from, 'DD.MM.YYYY') 
           <= to_char(to_date('15.10.2022'), 'DD.MM.YYYY');

select name || ' ' || surname as ns, 
  employee_id
    from v_emp
      where to_char(date_from, 'DD.MM.YYYY') 
           <= to_char("hack", 'DD.MM.YYYY');


-------------------------------------------------------
-- SECTION: ENQUOTE_LITERAL function
-------------------------------------------------------

select DBMS_ASSERT.ENQUOTE_LITERAL(''' or ''1=1') 
  from dual;

select DBMS_ASSERT.ENQUOTE_LITERAL('Michal') 
  from dual;

select DBMS_ASSERT.ENQUOTE_LITERAL('Michal Kvet') 
  from dual;

select DBMS_ASSERT.ENQUOTE_LITERAL(1) 
  from dual;  

select DBMS_ASSERT.ENQUOTE_LITERAL(null) 
  from dual;

select DBMS_ASSERT.ENQUOTE_LITERAL('null') 
  from dual;

select DBMS_ASSERT.ENQUOTE_LITERAL('''1'' 
                                 union select 1 from dual') 
  from dual;   

-------------------------------------------------------
-- DROP
-------------------------------------------------------
drop procedure get_employees;
drop table v_emp;
