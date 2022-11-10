alter session set nls_date_language='English';

declare
 composed_date date;
 cur_date integer;
 first_month_date integer;
 output_text varchar2(100);
 type t_week_days is table of char(4);
 week_days t_week_days:=t_week_days('MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN');
begin
 
 composed_date:=trunc(to_date('&MONTH.&YEAR', 'MM.YYYY'), 'MM')-1;
 -- dbms_output.put_line(to_char(composed_date, 'DD.MM.YYYY'));
 first_month_date:=to_char(composed_date, 'D');
 for i in week_days.first .. week_days.last
  loop  
    cur_date:=to_char(next_day(composed_date, week_days(i)), 'DD'); 
     output_text:=week_days(i) ||':';
      if first_month_date >= i then output_text:=output_text || '    '; end if;
     while cur_date <= to_char(last_day(composed_date+1), 'DD')
      loop 
       output_text:= output_text || lpad(cur_date, 4);
         --dbms_output.put_line(cur_date);
       cur_date:=cur_date + 7;
      end loop; 
       dbms_output.put_line(output_text);
  end loop;
  exception when others then dbms_output.put_line('Incorrectly specified date');
end;
/

------------------------------

declare
 composed_date date;
 cur_date integer;
 first_month_date integer;
 output_text varchar2(100);
 type t_week_days is table of char(4);
 week_days t_week_days:=t_week_days('MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN');
 last_month_date integer;
begin
 composed_date:=trunc(to_date('&MONTH.&YEAR', 'MM.YYYY'), 'MM')-1;
 first_month_date:=to_char(composed_date, 'D'); -- cislo dna
 last_month_date:=to_char(last_day(composed_date), 'DD');
 for i in week_days.first .. week_days.last
  loop 
   dbms_output.put(week_days(i) ||' ');
  end loop;
   dbms_output.new_line();
   cur_date:=1;
   output_text:=lpad(' ', 5*(first_month_date));
    loop   
     output_text:=output_text || rpad(cur_date, 5);
     if mod(cur_date+first_month_date,7)=0
     then 
      dbms_output.put_line(output_text);
      output_text:='';
     end if;      
      
     if cur_date>last_month_date then exit; end if;
      cur_date:=cur_date+1;
    end loop; 
     
  exception when others then dbms_output.put_line('Incorrectly specified date');
end;
/
