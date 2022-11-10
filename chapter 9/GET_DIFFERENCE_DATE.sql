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
