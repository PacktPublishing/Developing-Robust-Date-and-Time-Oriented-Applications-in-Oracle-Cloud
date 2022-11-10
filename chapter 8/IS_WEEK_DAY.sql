create or replace function IS_WEEK_DAY(p_date DATE)
 return integer
is
 week_desc varchar(20);
begin
 week_desc:=trim(TO_CHAR(p_date, 
                         'DAY', 
                         'NLS_DATE_LANGUAGE=American'));
 case week_desc 
   when 'MONDAY'    then return 1;
   when 'TUESDAY'   then return 2;
   when 'WEDNESDAY' then return 3;
   when 'THURSDAY'  then return 4;
   when 'FRIDAY'    then return 5;
   when 'SATURDAY'  then return 6;
   when 'SUNDAY'    then return 7;
   else return -1;
 end case;
end;
/  