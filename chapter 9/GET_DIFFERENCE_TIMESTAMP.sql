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
