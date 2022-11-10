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