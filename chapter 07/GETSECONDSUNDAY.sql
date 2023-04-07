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
