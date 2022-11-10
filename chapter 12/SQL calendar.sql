alter session set nls_territory='Belgium';
alter session set nls_date_format='DD.MM.YYYY HH24:MI:SS';
alter session set nls_date_language='English';

select text 
  from
  ( select ' MON TUE WED THU FRI SAT SUN' as text
     from dual
     union 
    select text
     from
      (select case when substr(calendar_row,3,2)<7 
                             then lpad(calendar_row,28)
                   when substr(calendar_row,3,2)>20 
                        and substr(calendar_row,-1)=' ' 
                             then rpad(calendar_row,28)
                             else calendar_row
              end as text
        from
         (select listagg(lpad(day_val, 4)) within group 
                         (order by day_val) as calendar_row
           from
            (select level as day_val
              from dual
              connect by level <=last_day(sysdate)
                                   - trunc(sysdate, 'MM')+1
             )
           group by to_char(trunc(sysdate, 'MM') 
                                      + day_val -1, 
                           'IW')
          )
       )
  ) 
   order by case when substr(text,2,1)='M' 
                      then 1 
                 else 2 end, 
            substr(text,3,2);
          
------------------------------         
            
select text 
  from
  ( select ' MON TUE WED THU FRI SAT SUN' as text
     from dual
     union 
    select text
     from
      (select case when substr(calendar_row,3,2)<7 
                             then lpad(calendar_row,28)
                   when substr(calendar_row,3,2)>20 
                        and substr(calendar_row,-1)=' ' 
                             then rpad(calendar_row,28)
                             else calendar_row
              end as text
        from
         (select listagg(lpad(day_val, 4)) within group 
                         (order by day_val) as calendar_row
           from
            (select level as day_val
              from dual
              connect by level 
           <=last_day(to_date('&&MONTH.&&YEAR', 'MM.YYYY'))
 		   - trunc(to_date('&&MONTH.&&YEAR', 'MM.YYYY'), 
                      'MM')+1
             )
            group by 
                  to_char(trunc(to_date('&&MONTH.&&YEAR', 
                                        'MM.YYYY'), 
                                'MM') 
                     + day_val -1, 
                  'IW')
          )
       )
  ) 
   order by case when substr(text,2,1)='M' 
                   then 1 
                 else 2 end, 
            substr(text,3,2);
            
undefine month;
undefine year;

alter session set nls_date_language='English';

select case day_of_week when '1' then 'MON'
                        when '2' then 'TUE'
                        when '3' then 'WED'
                        when '4' then 'THU'
                        when '5' then 'FRI'
                        when '6' then 'SAT'
                        when '7' then 'SUN'
       end as week_day,                 
     case 
      when to_char(trunc(sysdate, 'MM'), 'D') > day_of_week
         then '    '||text
         else text
    end as calendar from                    
   (select day_of_week, listagg(lpad(day_id,4)) 
                           within group 
 						(order by day_id) as text
     from
       (select to_char(trunc(sysdate, 'MM')+day_id-1, 'D') 
                                               day_of_week, 
               day_id
          from
           (select level as day_id
             from dual
              connect by level <=last_day(sysdate)
                                   - trunc(sysdate, 'MM')+1
           )
       )
      group by day_of_week
    )
  order by day_of_week;