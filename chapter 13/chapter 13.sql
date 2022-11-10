-------------------------------------------------------
-- SECTION: Transaction log structure
-------------------------------------------------------

-- setting archive log mode
SHUTDOWN;
set ORACLE_SID=orcl;
sqlplus sys as sysdba
STARTUP MOUNT;
ALTER DATABASE ARCHIVELOG;
ALTER DATABASE OPEN;

SELECT log_mode FROM v$database;

-------------------------------------------------------
-- SECTION: FLASHBACK DATABASE
-------------------------------------------------------

SHUTDOWN IMMEDIATE
STARTUP MOUNT
FLASHBACK DATABASE TO SCN <scn_value>;

ALTER DATABASE OPEN RESETLOGS;

CREATE RESTORE POINT <rp_name> 
  GUARANTEE FLASHBACK DATABASE;

SHUTDOWN IMMEDIATE
STARTUP MOUNT
FLASHBACK DATABASE TO RESTORE POINT '<rp_name>';

ALTER DATABASE OPEN RESETLOGS;

FLASHBACK DATABASE TO TIME 'SYSDATE-7';

select name, log_mode, open_mode, flashback_on, current_scn 
  from V$DATABASE;

-------------------------------------------------------
-- SECTION: DBMS_FLASHBACK package
-------------------------------------------------------

grant execute on dbms_flashback to <username>;  

select dbms_flashback.get_system_change_number from dual;

variable scn number;
 exec :scn:=dbms_flashback.get_system_change_number;
print scn;

ALTER TABLE <table_name> ENABLE ROW MOVEMENT;

Grant flashback any table to <username>;

flashback table tab_flash to scn :scn;

flashback table tab_flash
  TO TIMESTAMP (SYSDATE - INTERVAL '1' minute);

flashback table tab_flash TO TIMESTAMP
  TO_TIMESTAMP('20.12.2021 09:30:00', 
               'DD.MM.YYYY HH24:MI:SS');

flashback table tab_flash 
 TO TIMESTAMP TIMESTAMP '2021-12-20 09:30:00'; 

-------------------------------------------------------
-- SECTION: AS OF query
------------------------------------------------------- 
 
select * from tab_flash AS OF SCN 37787776900222; 

select * from tab_flash 
  AS OF timestamp (SYSDATE - INTERVAL '1' minute);

select * from tab_flash 
  AS OF TIMESTAMP(to_timestamp('20.12.2021 09:30:00', 
                               'DD.MM.YYYY HH24:MI:SS'));
