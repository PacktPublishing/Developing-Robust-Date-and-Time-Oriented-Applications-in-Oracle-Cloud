-------------------------------------------------------
-- SECTION: Connecting to the autonomous database
-------------------------------------------------------
begin
 ords_admin.enable_schema
  (p_enabled => TRUE, 
   p_schema => 'MICHAL', -- username for the grant
   p_url_mapping_type => 'BASE_PATH', 
   p_url_mapping_pattern => 'michal',  -- mapping pattern
   p_auto_rest_auth => NULL
  );
 commit;
end;
/
