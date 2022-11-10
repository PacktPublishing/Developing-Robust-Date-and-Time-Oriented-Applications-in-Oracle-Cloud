create or replace function CONVERT_DATE_TIMEZONES
 (p_date DATE, 
  input_timezone varchar, 
  output_timezone varchar
  )
 return date
   is
     v_timestamp TIMESTAMP WITH TIME ZONE;
begin
   v_timestamp:=FROM_TZ(CAST(p_date AS TIMESTAMP), 
                        input_timezone);
   return CAST(v_timestamp AT TIME ZONE output_timezone  
               as DATE); 
end;
/