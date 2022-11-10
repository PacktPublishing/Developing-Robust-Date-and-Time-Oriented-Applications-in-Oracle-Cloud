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