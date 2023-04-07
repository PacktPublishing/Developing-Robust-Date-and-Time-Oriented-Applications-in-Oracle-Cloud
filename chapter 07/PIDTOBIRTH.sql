create or replace function PIDTOBIRTH(p_pid varchar2)	
 return DATE
is 
 val varchar2(11);
begin
 val:=substr(p_pid,5,2)||'-'			-- DAY
      ||mod(substr(p_pid,3,2),50)      	-- MONTH
      ||case length(trim(p_pid))
         when 10 then '19'
         else '20'
        end 
      ||'-'
      || substr(p_pid,1,2);          	-- YEAR
 return TO_DATE(val, 'dd-mm-yyyy');
    EXCEPTION WHEN OTHERS 
     THEN return TO_DATE('01-01-0001', 'dd-mm-yyyy');
end;
/
