create or replace function NEXT_DATE
   (p_date_val date, p_spec varchar, 
    p_sunday_first integer default 0)
 return date
is 
 v_weekday varchar(20);
 v_input_day_nr integer;
 v_output_day_nr integer;
 shift integer;
function get_shift(i integer, j integer)
  return 
   integer
 is
  begin
    if i=j then return 7; 
           else return mod(7-i+j, 7);
    end if;
  end;
 function is_numeric(p_spec varchar)
  return boolean
 is
  v_integer integer;
  begin
   v_integer:=to_number(p_spec);
   return true;
   exception when others then return false;
  end;
begin
 if p_sunday_first=1 and is_numeric(p_spec) then
     return NEXT_DATE(p_date_val,case 
                                   when p_spec=1 then 7 
                                   else p_spec-1 
                                 end, 0);
 end if;  
 select to_char(p_date_val, 'DAY', 
                           'nls_date_language=American') 
        into v_weekday 
  from dual;
  -- input day number
 case trim(v_weekday)
    when 'MONDAY'    then v_input_day_nr:=1;
    when 'TUESDAY'   then v_input_day_nr:=2;
    when 'WEDNESDAY' then v_input_day_nr:=3;                   
    when 'THURSDAY'  then v_input_day_nr:=4;
    when 'FRIDAY'    then v_input_day_nr:=5;
    when 'SATURDAY'  then v_input_day_nr:=6;
    when 'SUNDAY'    then v_input_day_nr:=7;
    else raise_application_error(-20000,
               'Input format not correctly specified');
 end case; 
 
-- output day number
 case trim(p_spec)
    when 'MON'  then v_output_day_nr:=1;
    when 'TUE'  then v_output_day_nr:=2;
    when 'WED'  then v_output_day_nr:=3;                   
    when 'THU'  then v_output_day_nr:=4;
    when 'FRI'  then v_output_day_nr:=5;
    when 'SAT'  then v_output_day_nr:=6;
    when 'SUN'  then v_output_day_nr:=7;
    when '1'    then v_output_day_nr:=1;
    when '2'    then v_output_day_nr:=2;
    when '3'    then v_output_day_nr:=3;                   
    when '4'    then v_output_day_nr:=4;
    when '5'    then v_output_day_nr:=5;
    when '6'    then v_output_day_nr:=6;
    when '7'    then v_output_day_nr:=7;
    else raise_application_error(-20001,
               'Output format not correctly specified');
 end case; 
   shift:=get_shift(v_input_day_nr,v_output_day_nr);
  return p_date_val+ shift; 
end;
/
