-------------------------------------------------------
-- SECTION: SQL Loader
-------------------------------------------------------

-- SYNTAX - getting code definition of the object
/*
DBMS_METADATA.GET_DDL 
(
   object_type     IN VARCHAR2,
   name            IN VARCHAR2,
   schema          IN VARCHAR2 DEFAULT NULL,
   version         IN VARCHAR2 DEFAULT 'COMPATIBLE',
   model           IN VARCHAR2 DEFAULT 'ORACLE',
   transform       IN VARCHAR2 DEFAULT 'DDL'
)
RETURN CLOB;
*/

-- SQL Loader
/*
LOAD DATA
INFILE 'book.unl'
INTO TABLE book
FIELDS TERMINATED BY '|'
(
  BOOK_ID,
  TITLE_ID, 
  PRICE, 
  REGISTRATION_DATE 	DATE 'MM/DD/YYYY', 
  DISPOSAL_DATE 		DATE 'MM/DD/YYYY', 
  LOST_DATE 		DATE 'MM/DD/YYYY'
)
*/

-- SQL Loader - value transformation using replace function
/*
LOAD DATA
INFILE 'person_contact.unl'
INTO TABLE person
FIELDS TERMINATED BY '|'
(
  PERSON_ID,
  NAME, 
  SURNAME, 
  VALID_FROM 	DATE 'MM/DD/YYYY', 
  TELEPHONE		"replace(:telephone,' ','')",
  EMAIL  		"replace(:email,'(at)','@')"
)
*/

-- SQL Loader - value transformation using character string value transformation into DATE data type
/*
LOAD DATA
INFILE 'person_contact.unl'
INTO TABLE person
FIELDS TERMINATED BY '|'
(
  PERSON_ID,
  NAME, 
  SURNAME, 
  VALID_FROM "case length(trim(:valid_from)<=7 
               then to_date(:valid_from, 'MM/YYYY')
               else to_date(:valid_from, 'DD/MM/YYYY')
              end", 
  TELEPHONE "replace(:telephone,' ','')",
  EMAIL  	 "replace(:email,'(at)','@')"
)
*/

-- generating UNL file content
set echo off newpage 0 space 0 pagesize 0 feed off
spool author.unl
  select trim(name) || '|' || 
         trim(surname) || '|' || 
         trim(author_id) || '|' ||          
         to_char(registration_date,'MM/DD/YYYY') || '|' ||
         trim(note) || '|' || chr(10) from author;
spool off

-------------------------------------------------------
-- SECTION: Importing data using SQL Loader in Cloud interface
-------------------------------------------------------

-- PERSON table
CREATE TABLE ADMIN.PERSON 
    ( 
     PERSON_ID  NUMBER(38), 
     NAME       VARCHAR2(50)  NOT NULL, 
     SURNAME    VARCHAR2(50)  NOT NULL, 
     VALID_FROM DATE  	   	NOT NULL, 
     TELEPHONE  VARCHAR2(30), 
     EMAIL      VARCHAR2(50) 
    ) 
    LOGGING;

   ALTER TABLE ADMIN.PERSON 
    ADD CONSTRAINT PERSON_PK PRIMARY KEY ( PERSON_ID ) ;

-------------------------------------------------------
-- SECTION: External table
-------------------------------------------------------
-- Oracle directory
create or replace directory ext_tab_dir 
                              as 'X:\source_data';


-- external table
CREATE TABLE person_tab
   (person_id      	 INTEGER,
    title         	 VARCHAR(20),
    first_name   	 VARCHAR(20),
    last_name  		 VARCHAR(15), 
    birth_date 		 DATE, 
    retirement 		 DATE
    )
 ORGANIZATION EXTERNAL
   (TYPE ORACLE_LOADER
    DEFAULT DIRECTORY ext_tab_dir
    ACCESS PARAMETERS
     (RECORDS DELIMITED BY NEWLINE
       FIELDS TERMINATED BY ','
       missing field values are null
        (person_id, title, first_name, last_name, 
         birth_date DATE 'DD.MM.YYYY HH:MI:SS',
         retirement DATE 'MM.YYYY')
      ) LOCATION ('person_file.dat')
   );


-- external table with partitioning
create table student_tab
 (student_id integer, class integer, 
  start_date date, final_date date)
   organization external
    (type oracle_loader default directory ext_tab_dir)
     partition by range(class)
      (partition bachelor values less than (4) 
        location('class1.dat', 'class2.dat', 'class3.dat'),
       partition master values less than (6)
        location('all_classes.dat')
    );


-------------------------------------------------------
-- SECTION: Client site import / export
-------------------------------------------------------

-- Syntax: EXP
/* 
$ exp <login>@<connect_string> 
      tables='<list_of_tables>' file='<file_name>.exp'
*/

/* 
$ exp <login>/<password>@<connect_string> 
         tables='k_person k_reader' file='library.exp'
*/         


-- Syntax: IMP
/* 
$ imp <login>@<connect_string> 
       tables='<list_of_tables>' ignore=Y 
               file='<filename.exp>'
*/

-- Mapping user
/* 
$ imp <login>@<connect_string> 
       fromuser=<old_login> touser=<new_login> 
         file='<filename.exp>'
*/


-------------------------------------------------------
-- SECTION: Creating Credentials
-------------------------------------------------------

-- SYNTAX: CREATE_CREDENTIAL
/*
DBMS_CREDENTIAL.CREATE_CREDENTIAL (
   credential_name   IN  VARCHAR2,
   username          IN  VARCHAR2,
   password          IN  VARCHAR2,
   database_role     IN  VARCHAR2  DEFAULT NULL
   windows_domain    IN  VARCHAR2  DEFAULT NULL,
   comments          IN  VARCHAR2  DEFAULT NULL,
   enabled           IN  BOOLEAN   DEFAULT TRUE);
*/

-- Create credential
-- principle
BEGIN
DBMS_CLOUD.CREATE_CREDENTIAL(
   credential_name => 'CREDENTIAL_NAME',
   username => 'tenancy_name',
   password => 'authentication_token');
END;
/

-------------------------------------------------------
-- SECTION: Authentication token
-------------------------------------------------------

-- usage
BEGIN
DBMS_CLOUD.CREATE_CREDENTIAL(
   credential_name => 'ATP_CREDENTIAL_MK',
   username => 'kvetmichal',
   password => 'H26oW:]:q]xb2KuWRmvQ'); 
END;
/

-- listing credentials
SELECT credential_name, username
  FROM all_credentials
    ORDER BY credential_name;


-------------------------------------------------------
-- SECTION: Import process using dump files
-------------------------------------------------------

-- creating new user for import
create user library_user identified by *******;
grant connect, resource, unlimited tablespace 
      to library_user;

-- put object to object storage
BEGIN
 DBMS_CLOUD.PUT_OBJECT(
  credential_name => 'ATP_CREDENTIAL_MK',
  object_uri => 'https://objectstorage.eu-frankfurt-
                 1.oraclecloud.com
      /p/PvVxyzBu2Ntwnm1Pyp4VUwMfCaD4zz1rIGBAUq1soUp1qU1-
         K9bBvD75bnxfYw8u
      /n/frrt85axbzme
      /b/bucket_library
      /o/log_library_import.log', -- destination file name
  directory_name => 'DATA_PUMP_DIR',
  file_name => 'IMPORT_LIBRARY.LOG'); -- source file name
END;
/


-------------------------------------------------------
-- SECTION: Transportable Tablespace Data Pump
-------------------------------------------------------

-- SYNTAX: transportable tablespaces
/*
ALTER TABLESPACE <tablespace_name> READ ONLY;
ALTER TABLESPACE <tablespace_name> READ WRITE;
*/

-- Full Transportable Tablespace Data Pump
$ mkdir /u01/app/oracle/admin/orcl/dump_files

$ sqlplus system

CREATE DIRECTORY data_pump_dir AS  
      '/u01/app/oracle/admin/orcl/dump_files';
      
ALTER TABLESPACE main_tblspc READ ONLY;
ALTER TABLESPACE index_tblspc READ ONLY;
      
SELECT tablespace_name, file_name FROM dba_data_files; 

$ expdp system FULL=y TRANSPORTABLE=always 

$ mkdir /u01/app/oracle/admin/orclpdb/dump_files

$ scp -i private_key_file
         /u01/app/oracle/oradata/orcl/main1.dbf
       oracle@dest_IP_address:    
         /u01/app/oracle/admin/orclpdb/dump_files

$ sqlplus system

ALTER TABLESPACE main_tblspc READ WRITE;
ALTER TABLESPACE index_tblspc READ WRITE;

CREATE DIRECTORY data_imp_dir AS  
      '/u01/app/oracle/admin/orclpdb/dump_files';

$ impdp system@orclpdb FULL=y DIRECTORY=data_pump_dir 
        TRANSPORT_DATAFILES=
 		'/u01/app/oracle/oradata/orcl/main1.dbf',
 		'/u01/app/oracle/oradata/orcl/main2.dbf',
 		'/u01/app/oracle/oradata/orcl/index.dbf'


-------------------------------------------------------
-- SECTION: Oracle Cloud Infrastructure Database Migration
-------------------------------------------------------

show parameter streams_pool_size;

show parameter global_names;

shutdown immediate;
startup mount;
alter database archivelog;
alter database open;

select name,log_mode from v$database;

select supplemental_log_data_min, force_logging 
 from v$database;

alter database add supplemental log data;

alter database force logging;


show parameter global_names;

alter system set global_names=false;
