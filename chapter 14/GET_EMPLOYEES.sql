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