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