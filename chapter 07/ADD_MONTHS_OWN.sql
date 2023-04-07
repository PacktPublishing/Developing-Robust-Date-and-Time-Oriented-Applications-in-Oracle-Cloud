
create or replace function ADD_MONTHS_OWN
           (p_date DATE, p_month_shift integer)
 return varchar
is
 v_day_orig integer;
 v_month_orig integer;
 v_year_orig integer;
 v_last_day_orig integer;
 v_last_day_shifted integer;
 v_day_shifted integer;
 v_month_shifted integer;
 v_year_shifted integer;
 v_time_representation char(8);
begin
 if p_month_shift=0 
    then return p_date;
 end if;

 select TO_CHAR(p_date, 'DD'), 
        TO_CHAR(p_date, 'MM'), 
        TO_CHAR(p_date, 'YYYY')
     into v_day_orig, v_month_orig, v_year_orig
  from dual;
 
 v_time_representation:=TO_CHAR(p_date, 'HH24:MI:SS');

select v_year_orig 
       + DECODE(TRUNC((v_month_orig + p_month_shift) / 12), 
                       0, -1, trunc((v_month_orig 
                              + p_month_shift) / 12)
               ) 
  into v_year_shifted from dual;

 v_month_shifted:=mod(v_month_orig + p_month_shift, 12);  
 if v_month_shifted<=0 
    then v_month_shifted:=v_month_shifted + 12; 
 end if;
 
 v_last_day_orig:=TO_CHAR(last_day(p_date), 'DD');
 v_last_day_shifted:=TO_CHAR(last_day
  (TO_DATE('01.'||v_month_shifted||'.'||v_year_shifted,   
           'DD.MM.YYYY')), 
                             'DD');

 if v_day_orig=v_last_day_orig then   
    v_day_shifted:=v_last_day_shifted; 
 elsif v_day_orig>v_last_day_shifted 
    then v_day_shifted:=v_last_day_shifted;
 else v_day_shifted:=v_day_orig;
 end if;   

  return TO_DATE(v_day_shifted||'.'
                 ||v_month_shifted||'.'
                 ||v_year_shifted ||'.'
                 || v_time_representation, 
                     'DD.MM.YYYY HH24:MI:SS');
end;
/  
