-------------------------------------------------------
-- SECTION: Time zone reflection
-------------------------------------------------------
alter database set time_zone = '+09:00';

select DBTIMEZONE from dual;

alter session set time_zone='Europe/Brussels';

alter session set time_zone='00:00';

select sysdate, current_date from dual;

select systimestamp, current_timestamp from dual;


-------------------------------------------------------
-- SECTION: SQL translation profile
-------------------------------------------------------
begin
 -- create profile
 DBMS_SQL_TRANSLATOR.CREATE_PROFILE('DATE_PROF');
 -- register transformation for the DATE value
 DBMS_SQL_TRANSLATOR.REGISTER_SQL_TRANSLATION
   (profile_name => 'DATE_PROF', 
    sql_text=> 'select sysdate from dual', 
    translated_text=>'select current_date from dual');
 -- register transformation for the TIMESTAMP value
 DBMS_SQL_TRANSLATOR.REGISTER_SQL_TRANSLATION
   (profile_name => 'DATE_PROF', 
    sql_text=> 'select systimestamp from dual', 
    translated_text=>'select current_timestamp from dual'); 
end;
/


alter session set SQL_TRANSLATION_PROFILE=DATE_PROF;


exec DBMS_SQL_TRANSLATOR.DROP_PROFILE('DATE_PROF');

create or replace package DATE_TRANSLATOR_PACKAGE is
 procedure TRANSLATE_SQL(sql_text IN clob, 
                         translated_text OUT clob);
 procedure TRANSLATE_ERROR(error_code IN binary_integer, 
                     translated_code OUT binary_integer,
                     translated_sql_state OUT varchar);
end;
/

create or replace package body DATE_TRANSLATOR_PACKAGE
 is
  procedure TRANSLATE_SQL(sql_text in clob,
                          translated_text out clob)
    is
     begin
       translated_text:=REGEXP_REPLACE(sql_text, 
       					   'sysdate',                                            
   						     	'current_date',
 							 1,0,'i');
       translated_text:=REGEXP_REPLACE(translated_text, 
                                   	'systimestamp',
 						'current_timestamp',
 							 1,0,'i'); 
     end; 
   procedure TRANSLATE_ERROR(error_code IN binary_integer, 
                       translated_code OUT binary_integer,
                       translated_sql_state OUT varchar)   
    is
     begin
      null;
     end;
end;
/

exec DBMS_SQL_TRANSLATOR.CREATE_PROFILE
   (profile_name => 'DATE_PROF');

exec DBMS_SQL_TRANSLATOR.SET_ATTRIBUTE
   (profile_name => 'DATE_PROF',
    attribute_name 
        => dbms_sql_translator.ATTR_FOREIGN_SQL_SYNTAX,
    attribute_value 
        => dbms_sql_translator.ATTR_VALUE_FALSE);

exec DBMS_SQL_TRANSLATOR.SET_ATTRIBUTE
   (profile_name => 'DATE_PROF',
    attribute_name => dbms_sql_translator.attr_translator,
    attribute_value => 'DATE_TRANSLATOR');


alter session set sql_translation_profile=DATE_PROF;

alter session set sql_translation_profile=null;


-------------------------------------------------------
-- SECTION: Cloud database reference
-------------------------------------------------------

select dbtimezone from dual;

alter session set SYSDATE_AT_DBTIMEZONE=false;

select sysdate, current_date from dual; 

alter session set SYSDATE_AT_DBTIMEZONE=false;

select sysdate, current_date from dual; 

alter session set SYSDATE_AT_DBTIMEZONE=false;

select systimestamp, current_timestamp from dual;

alter session set SYSDATE_AT_DBTIMEZONE=true;

select systimestamp, current_timestamp from dual;

-------------------------------------------------------
-- DROP
-------------------------------------------------------

exec dbms_sql_translator.drop_profile('DATE_PROF');
drop package date_translator_package;
        
