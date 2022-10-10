CREATE OR REPLACE PACKAGE BODY utl_unld IS
/*---------------------------------------------------------------------------------------*/
 Version CONSTANT VARCHAR2(30) := 'UTL_UNLD Version 1.0.0.6';
 Banner CONSTANT VARCHAR2(55) := 'rem Written by Y.Voinov (C) 2002-2005';
 Banner2 CONSTANT VARCHAR2(80) := 'rem Must be run from (i)SQL*Plus from existing account';
 DefaultExtension CONSTANT VARCHAR2(4) := '.sql';

 TermoutOn CONSTANT VARCHAR2(15) := 'set termout on';   -- Performance stuff for scripts exec
 TermoutOff CONSTANT VARCHAR2(15) := 'set termout off';
 EchoOn CONSTANT VARCHAR2(16) := 'rem set echo on';     -- Debug stuff for scripts exec
 EchoOff CONSTANT VARCHAR2(16) := 'rem set echo off';

 PromptBeginSpare VARCHAR2(15) := 'prompt Loading ';
 PromptBeginSpare2 VARCHAR2(15) := ' started...';
 PromptEnd CONSTANT VARCHAR2(25) := 'prompt Loading complete.';

 Obj_type_view CONSTANT VARCHAR2(5) := 'Views';         -- Object types
 Obj_type_synonym CONSTANT VARCHAR2(8) := 'Synonyms';
 Obj_type_grants CONSTANT VARCHAR2(6) := 'Grants';

 Obj_file UTL_FILE.file_type;  /* File descriptor for output. */

 Views_cnt NUMBER;       -- Global internal package variable for views quantity checking
 Obj_cnt NUMBER := 0;    -- Unload and quanity checking internal counter
 Syn_cnt NUMBER;         -- Global internal package variable for synonyms quantity checking
 Tab_grants_cnt NUMBER;  -- Global internal package variable for table grants checking
 Col_grants_cnt NUMBER;  -- Global internal package variable for column grants checking

 Time_start DATE;        -- Global begin unloading timestamp
 Time_end DATE;          -- Global end unloading timestamp
 Time_total_hh NUMBER;   -- Global hours total time counter
 Time_total_mi NUMBER;   -- Global minutes total time counter
 Time_total_ss NUMBER;   -- Global seconds total time counter
 /*---------------------------------------------------------------------------------------*/
FUNCTION views_exists RETURN NUMBER IS
-- Function for checking views existence in target schema.
-- When user_objects contains any views, return counter,
-- otherwise return NULL.
BEGIN
 SELECT COUNT(1)
 INTO Views_cnt
 FROM user_objects
 WHERE object_type = 'VIEW';
 IF Views_cnt <> 0 THEN RETURN Views_cnt; END IF;
 RETURN NULL;
END views_exists;
/*---------------------------------------------------------------------------------------*/
FUNCTION synonyms_exists RETURN NUMBER IS
-- Function for checking synonyms existence in target schema.
-- When all_synonyms contains any sysnonyms, return counter,
-- otherwise return NULL.
BEGIN
 SELECT COUNT(1)
 INTO Syn_cnt
 FROM all_synonyms
 WHERE table_owner = USER OR
       owner = USER; -- Checking sysnonyms owned by executing user...
 IF Syn_cnt <> 0 THEN RETURN Syn_cnt; END IF;
 RETURN NULL;
END synonyms_exists;
/*---------------------------------------------------------------------------------------*/
FUNCTION tab_grants_exists RETURN NUMBER IS
-- Function for checking table grants existence in target schema.
-- When user_tab_privs_made contains any grants, return counter,
-- otherwise return 0.
BEGIN
 SELECT COUNT(1)
 INTO Tab_grants_cnt
 FROM user_tab_privs_made;
 IF Tab_grants_cnt = 0 THEN RETURN 0; END IF;
 RETURN Tab_grants_cnt;
END tab_grants_exists;
/*---------------------------------------------------------------------------------------*/
FUNCTION col_grants_exists RETURN NUMBER IS
-- Function for checking table grants existence in target schema.
-- When user_col_privs_made contains any grants, return counter,
-- otherwise return 0.
BEGIN
 SELECT COUNT(1)
 INTO Col_grants_cnt
 FROM user_col_privs_made;
 IF Col_grants_cnt = 0 THEN RETURN 0; END IF;
 RETURN Col_grants_cnt;
END col_grants_exists;
/*---------------------------------------------------------------------------------------*/
FUNCTION views_col (view_name IN VARCHAR2) RETURN VARCHAR2 IS
-- ----------------------------------------------------------------------------------------
-- Function for get views columns to comma-separated list for correctly forming views    --
-- headers.                                                                              --
-- Corrected: Column names formed in "<name>" for composite names.                       --
-- ----------------------------------------------------------------------------------------
 Col VARCHAR2(32767) := '';                         /* Undocumented */
 Separator VARCHAR2(1);

 CURSOR Col_view IS
  SELECT /*+ PARALLEL */ * FROM user_tab_columns
  WHERE table_name = view_name
  ORDER BY column_id;
BEGIN
 Separator := '';
 FOR Col_rec IN Col_view LOOP
  Col := Col || Separator || '"' || Col_rec.column_name || '"';
  Separator := ',';
 END LOOP;
 RETURN Col;
END views_col;
/*---------------------------------------------------------------------------------------*/
PROCEDURE views_tab_create IS
-- Parallel clause added
 DDL_Create CONSTANT VARCHAR2(255) := 'CREATE TABLE tmp_views NOLOGGING PARALLEL' ||
  'AS SELECT view_name, text_length, TO_LOB(text) text FROM user_views';
 Exist_table user_objects%ROWTYPE;
BEGIN
 BEGIN
  SELECT * INTO Exist_table
  FROM user_objects
  WHERE object_name = 'TMP_VIEWS' AND object_type = 'TABLE';
 EXCEPTION
  WHEN NO_DATA_FOUND THEN EXECUTE IMMEDIATE DDL_Create;
 END;
EXCEPTION
 WHEN OTHERS THEN
  raise_application_error (-20023, 'Cannot create table TMP_VIEWS. ORA' || SQLCODE || ' raised.');
END views_tab_create;
/*---------------------------------------------------------------------------------------*/
PROCEDURE views_tab_drop IS
 DDL_Drop CONSTANT VARCHAR2(50) := 'DROP TABLE tmp_views';
BEGIN
 EXECUTE IMMEDIATE DDL_Drop;
EXCEPTION
 WHEN OTHERS THEN
  raise_application_error (-20024, 'Table TMP_VIEWS does not exists or cannot drop. ORA' ||
                                   SQLCODE || ' raised.');
END views_tab_drop;
/*---------------------------------------------------------------------------------------*/
PROCEDURE views_unload (ObjectsFilePath IN VARCHAR2, 
                        ObjectsFileName IN VARCHAR2,
                        ObjectForceFlag IN VARCHAR2 DEFAULT 'NOFORCE') IS
-- ----------------------------------------------------------------------------------------
-- Procedure for unloading views to the text file.                                       --
-- Must be executed from DBA user.                                                       --
-- Uses OS filesystem for output plain text file named ObjectsFileName.                  --
-- Directory-ObjectsFilePath, if file exists, it'll be owerwritten without any warnings. --
-- ORACLE owner user must have permissions for write into specified directory.           --
-- Note: Directory path is OS-specific! UTL_FILE_DIR = * parameter must be specified!    --
-- Written by Yuri Voinov (C) 2002-2005.                                                 --
--                                                                                       --
-- Modifications:                                                                        --
-- 31.10.2005- 'create or replace force view' capability added.                          --
-- 01.01.2003- Global constants are transferring to package body specification.          --
-- 28.11.2002- Check for exists views in target schema. Exception ORA-20024 added.       --
-- 07.11.2002- Added '"' in view_name forming.                                           --
-- 11.10.2002- Column names for unloaded views formed in "<name>" for composite names.   --
-- 10.10.2002- Parallel execution added.                                                 --
-- 17.09.2002- Initial code written.                                                     --
-- ----------------------------------------------------------------------------------------
 Create_command CONSTANT VARCHAR2(30) := 'CREATE OR REPLACE VIEW ';
 Create_command_force CONSTANT VARCHAR2(30) := 'CREATE OR REPLACE FORCE VIEW ';
 Create_command_col_list VARCHAR2(32767);
 Create_command_spare CONSTANT VARCHAR2(4) := ' AS ';
 Create_command_spare2 CONSTANT VARCHAR2(1) := ';';
 SpoolOn CONSTANT VARCHAR2(30) := 'spool views.log';
 SpoolOff CONSTANT VARCHAR2(30) := 'spool off';
 Output_buffer VARCHAR2(32767);               /* Undocumented */
 Amount NUMBER;                               /* Buffer CLOB amount */

 v_command VARCHAR2(30);                      /* Create command variable */

 CURSOR Views_cursor IS                       /* Cursor for unload views */
  SELECT /*+ PARALLEL */ * FROM tmp_views
  ORDER BY view_name;                         /* ORDER BY view_name */

 VIEWS_NOT_FOUND EXCEPTION;    /* Check views exception */ 
 INVALID_FLAG EXCEPTION;       /* Check FORCE flag exception */ 
/*---------------------------------------------------------------------------------------*/
BEGIN
 -- Check if any views exists.
 IF views_exists IS NULL THEN RAISE VIEWS_NOT_FOUND; END IF;
 -- Open file for write. Directory is ObjectsFilePath,
 -- file name ObjectsFileName.sql, file is open for write.
 BEGIN
  Obj_file := UTL_FILE.fopen (ObjectsFilePath, ObjectsFileName || DefaultExtension, 'w', 32767);
 EXCEPTION
  WHEN UTL_FILE.INVALID_PATH THEN
   raise_application_error(-20020, 'Path your specified not found or permission denied.');
  WHEN UTL_FILE.INVALID_FILEHANDLE THEN
   raise_application_error (-20021, 'File handle is invalid.');
  WHEN UTL_FILE.WRITE_ERROR THEN
   raise_application_error (-20022, 'Write error. Path not found or permission denied.');
  WHEN OTHERS THEN
   raise_application_error (-20029, 'Unknown OS error.');
 END;

 UTL_FILE.put_line (Obj_file, 'rem ' || Obj_type_view || ' unloaded by package ' || Version);
 Time_start := SYSDATE;

 UTL_FILE.put_line (Obj_file, Banner);
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */

 UTL_FILE.put_line (Obj_file, Banner2);
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */

 UTL_FILE.put_line (Obj_file, 'rem Found ' || Views_cnt || ' in target schema.');
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */
 -- Prompt begin prompt in script
 UTL_FILE.put_line (Obj_file, PromptBeginSpare || LOWER(Obj_type_view) || PromptBeginSpare2);
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */
 UTL_FILE.put_line (Obj_file, TermoutOff);
 UTL_FILE.put_line (Obj_file, EchoOn);
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */

 UTL_FILE.put_line (Obj_file, SpoolOn);
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */

 IF UPPER(ObjectForceFlag) = 'FORCE' THEN    /* Check FORCE flag */ 
  v_command := Create_command_force;  /* and set create command */ 
 ELSIF UPPER(ObjectForceFlag) = 'NOFORCE' THEN 
  v_command := Create_command;
 ELSE RAISE INVALID_FLAG;
 END IF;

 FOR Cursor_record IN Views_cursor
  LOOP
   Create_command_col_list := REPLACE(views_col(Cursor_record.view_name),',',',' || CHR(13));
   UTL_FILE.put_line(Obj_file, v_command || '"' || Cursor_record.view_name || '"' ||
                     '(' || Create_command_col_list || ')' ||
                     Create_command_spare);
   Amount := DBMS_LOB.getlength(Cursor_record.text);
   DBMS_LOB.read(Cursor_record.text, Amount, 1, Output_buffer);
   Output_buffer := REPLACE(Output_buffer,'","','",' || CHR(13) ||'"');
   UTL_FILE.put (Obj_file, Output_buffer);
   UTL_FILE.put_line (Obj_file, Create_command_spare2);
   UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. Put CR/LF after each string */
   Obj_cnt := Views_cursor%ROWCOUNT; -- Obj_cnt increment by cursor ROWCOUNT
  END LOOP;

 UTL_FILE.put_line (Obj_file, SpoolOff);
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */
 UTL_FILE.put_line (Obj_file, EchoOff);
 UTL_FILE.put_line (Obj_file, TermoutOn);
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */
 -- Total unload counter write
 UTL_FILE.put_line (Obj_file, 'rem Unloaded ' || Obj_cnt || ' views.');
 -- Final quantity checking ...
 IF Views_cnt > Obj_cnt THEN
  UTL_FILE.put_line (Obj_file, 'rem WARNING! Actually unloaded views are LESS then owned.');
 ELSIF Views_cnt < Obj_cnt THEN
  UTL_FILE.put_line (Obj_file, 'rem WARNING! Actually unloaded views are MORE then owned.');
 ELSIF Views_cnt = Obj_cnt THEN
  UTL_FILE.put_line (Obj_file, 'rem Quantity checking OK. Views found equal unloaded.');
 END IF;
 
 Time_end := SYSDATE; -- Get timings
 Time_total_hh := Trunc(((Time_end-Time_start)*24),0);
 Time_total_mi := Trunc((((Time_end-Time_start)*24 - Time_total_hh)*60),0);
 Time_total_ss := Trunc(((((Time_end-Time_start)*24 - Time_total_hh)*60 - Time_total_mi)*60),0);
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */
 UTL_FILE.put_line (Obj_file, 'rem Unload begun at: ' || TO_CHAR(Time_start,'fxDD-MM-YYYY HH24:MI:SS'));
 UTL_FILE.put_line (Obj_file, 'rem Unload end at  : ' || TO_CHAR(Time_end,'fxDD-MM-YYYY HH24:MI:SS'));
 UTL_FILE.put_line (Obj_file, 'rem TOTAL TIME: ' || Time_total_hh || ' hours ' ||
                                                    Time_total_mi || ' minutes ' ||
                                                    Time_total_ss || ' seconds');
 
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */
 UTL_FILE.put_line (Obj_file, PromptEnd); -- Put end prompt in script
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */
 UTL_FILE.put_line (Obj_file, 'exit'); -- Exit command in script

 BEGIN
  UTL_FILE.fflush (Obj_file); -- Flush OS cache ...
  UTL_FILE.fclose (Obj_file); -- Finally close views file ...
 EXCEPTION
  WHEN UTL_FILE.WRITE_ERROR THEN
   raise_application_error (-20022, 'Write error. Path not found or permission denied.');
 END;
EXCEPTION  -- Main exception interceptors for views_unload procedure.
 WHEN VIEWS_NOT_FOUND THEN
  raise_application_error (-20026, 'CANNOT FIND any views in current schema.');
 WHEN INVALID_FLAG THEN
  raise_application_error (-20030, 'ObjectForceFlag must be only FORCE or NOFORCE');
 WHEN OTHERS THEN
  raise_application_error (-20025, 'ORA' || SQLCODE || ' raised.');
END views_unload;
/*---------------------------------------------------------------------------------------*/
PROCEDURE synonyms_unload (ObjectsFilePath IN VARCHAR2, ObjectsFileName IN VARCHAR2) IS
-- ----------------------------------------------------------------------------------------
-- Procedure for unloading synonyms to the text file.                                    --
-- Must be executed from DBA user.                                                       --
-- Uses OS filesystem for output plain text file named ObjectsFileName.                  --
-- Directory-ObjectsFilePath, if file exists, it'll be owerwritten without any warnings. --
-- ORACLE owner user must have permissions for write into specified directory.           --
-- Note: Directory path is OS-specific! UTL_FILE_DIR = * parameter must be specified!    --
-- Written by Yuri Voinov (C) 2002-2005.                                                 --
-- ------------------------------------------------------------------------------------- --
-- Notes and Limitations:                                                                --
-- ======================                                                                --
-- 02.01.2005- PUBLIC synonyms for objects in NOT OWN schema cannot be found and         --
--             unloaded for ANY owner (including user SYS).                              --
--                                                                                       --
-- Modifications:                                                                        --
-- 02.01.2003- Initial code written.                                                     --
-- ----------------------------------------------------------------------------------------

 Create_command CONSTANT VARCHAR2(30) := 'CREATE ';
 Create_command2 CONSTANT VARCHAR2(30) := 'SYNONYM ';
 Create_command_spare CONSTANT VARCHAR2(4) := 'FOR ';
 Create_command_spare2 CONSTANT VARCHAR2(1) := ';';
 Create_command_public VARCHAR2(30);
 Create_command_owner VARCHAR2(30);
 Dog VARCHAR2(1); -- Internal symbol '@'
 SpoolOn CONSTANT VARCHAR2(30) := 'spool synonyms.log';
 SpoolOff CONSTANT VARCHAR2(30) := 'spool off';

 CURSOR Synonyms_cursor IS                          /* Cursor for unload synonyms */
  SELECT /*+ PARALLEL */ * FROM all_synonyms
  WHERE table_owner = USER OR owner = USER;

 SYNONYMS_NOT_FOUND EXCEPTION;
/*---------------------------------------------------------------------------------------*/
BEGIN
 -- Check if any synonyms exists.
 IF synonyms_exists IS NULL THEN RAISE SYNONYMS_NOT_FOUND; END IF;
 -- Open file for write. Directory is ObjectsFilePath,
 -- file name ObjectsFileName.sql, file is open for write.
 BEGIN
  Obj_file := UTL_FILE.fopen (ObjectsFilePath, ObjectsFileName || DefaultExtension, 'w', 32767);
 EXCEPTION
  WHEN UTL_FILE.INVALID_PATH THEN
   raise_application_error(-20020, 'Path your specified not found or permission denied.');
  WHEN UTL_FILE.INVALID_FILEHANDLE THEN
   raise_application_error (-20021, 'File handle is invalid.');
  WHEN UTL_FILE.WRITE_ERROR THEN
   raise_application_error (-20022, 'Write error. Path not found or permission denied.');
  WHEN OTHERS THEN
   raise_application_error (-20029, 'Unknown OS error.');
 END;

 UTL_FILE.put_line (Obj_file, 'rem ' || Obj_type_synonym || ' unloaded by package ' ||  Version);
 Time_start := SYSDATE;
 
 UTL_FILE.put_line (Obj_file, Banner);
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */

 UTL_FILE.put_line (Obj_file, Banner2);
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */

 UTL_FILE.put_line (Obj_file, 'rem Found ' || Syn_cnt || ' in target schema.');
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */
-- Prompt begin prompt in script
 UTL_FILE.put_line (Obj_file, PromptBeginSpare || LOWER(Obj_type_synonym) || PromptBeginSpare2);
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */
 UTL_FILE.put_line (Obj_file, TermoutOff);
 UTL_FILE.put_line (Obj_file, EchoOn);
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */

 UTL_FILE.put_line (Obj_file, SpoolOn);
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */

 FOR Cursor_record IN Synonyms_cursor
  LOOP
 -- ----------------------------------------------------------------------------------------
   IF (Cursor_record.owner = USER AND -- Synonym type checking...
       Cursor_record.owner = Cursor_record.table_owner) THEN -- If OWNER = current_user then
       Create_command_public := '';      -- PUBLIC not added. My OWN synonyms.
   ELSIF (Cursor_record.owner = 'PUBLIC' AND
          Cursor_record.table_owner = USER AND
          Cursor_record.db_link IS NULL) THEN -- Otherwise PUBLIC word inserted.
    Create_command_public := 'PUBLIC '; -- Public synonyms on my OWN ibjects.
    Create_command_owner := '';
   ELSIF (Cursor_record.owner = USER AND
          Cursor_record.owner <> Cursor_record.table_owner) THEN
    Create_command_public := ''; -- OWN synonyms for ANOTHER objects.
    Create_command_owner := Cursor_record.table_owner || '.';
   ELSIF (Cursor_record.owner = 'PUBLIC' AND -- Stupid combination!
          Cursor_record.table_owner = USER AND
          Cursor_record.db_link IS NOT NULL) THEN
    Create_command_public := 'PUBLIC '; -- PUBLIC synonyms for OWN objects with links.
    Create_command_owner := Cursor_record.table_owner || '.';
   END IF;
 -- ----------------------------------------------------------------------------------------
   IF Cursor_record.db_link IS NULL THEN -- Db_links maintenance. If DB_LINK field is empty,
    Dog := '';                           -- link symbol is suppressed.
   ELSE                                  -- Otherwise no.
    Dog := '@';
   END IF;
 -- ----------------------------------------------------------------------------------------
   UTL_FILE.put_line(Obj_file, Create_command || Create_command_public || Create_command2 ||
                               '"' || Cursor_record.synonym_name ||
                               '"' || CHR(13) || Create_command_spare ||
                               Create_command_owner || Cursor_record.table_name ||
                               Dog || Cursor_record.db_link);
   UTL_FILE.put_line (Obj_file, Create_command_spare2);
   UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. Put CR/LF after each string */
   Obj_cnt := Synonyms_cursor%ROWCOUNT; -- Increment Obj_cnt by
  END LOOP;                                       -- cursor ROWCOUNT

 UTL_FILE.put_line (Obj_file, SpoolOff);
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */
 UTL_FILE.put_line (Obj_file, EchoOff);
 UTL_FILE.put_line (Obj_file, TermoutOn);
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */
 -- Total unload counter write
 UTL_FILE.put_line (Obj_file, 'rem Unloaded ' || Obj_cnt || ' synonyms.');
 -- Final quantity checking ...
 IF Syn_cnt > Obj_cnt THEN
  UTL_FILE.put_line (Obj_file, 'rem WARNING! Actually unloaded synonyms are LESS then owned.');
 ELSIF Syn_cnt < Obj_cnt THEN
  UTL_FILE.put_line (Obj_file, 'rem WARNING! Actually unloaded synonyms are MORE then owned.');
 ELSIF Syn_cnt = Obj_cnt THEN
  UTL_FILE.put_line (Obj_file, 'rem Quantity checking OK. Synonyms found equal unloaded.');
 END IF;

 Time_end := SYSDATE; -- Get timings
 Time_total_hh := Trunc(((Time_end-Time_start)*24),0);
 Time_total_mi := Trunc((((Time_end-Time_start)*24 - Time_total_hh)*60),0);
 Time_total_ss := Trunc(((((Time_end-Time_start)*24 - Time_total_hh)*60 - Time_total_mi)*60),0);
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */
 UTL_FILE.put_line (Obj_file, 'rem Unload begun at: ' || TO_CHAR(Time_start,'fxDD-MM-YYYY HH24:MI:SS'));
 UTL_FILE.put_line (Obj_file, 'rem Unload end at  : ' || TO_CHAR(Time_end,'fxDD-MM-YYYY HH24:MI:SS'));
 UTL_FILE.put_line (Obj_file, 'rem TOTAL TIME: ' || Time_total_hh || ' hours ' ||
                                                    Time_total_mi || ' minutes ' ||
                                                    Time_total_ss || ' seconds');
                                                    
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */
 UTL_FILE.put_line (Obj_file, PromptEnd); -- Put end prompt in script
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */
 UTL_FILE.put_line (Obj_file, 'exit'); -- Exit command in script

 BEGIN
  UTL_FILE.fflush (Obj_file); -- Flush OS cache ...
  UTL_FILE.fclose (Obj_file); -- Finally close views file ...
 EXCEPTION
  WHEN UTL_FILE.WRITE_ERROR THEN
   raise_application_error (-20022, 'Write error. Path not found or permission denied.');
 END;
EXCEPTION  -- Main exception interceptors for synonys_unload procedure.
 WHEN SYNONYMS_NOT_FOUND THEN
  raise_application_error (-20027, 'CANNOT FIND any synonyms in current schema.');
 WHEN OTHERS THEN
  raise_application_error (-20025, 'ORA' || SQLCODE || ' raised.');
END synonyms_unload;
/*---------------------------------------------------------------------------------------*/
PROCEDURE grants_unload (ObjectsFilePath IN VARCHAR2, ObjectsFileName IN VARCHAR2) IS
-- ----------------------------------------------------------------------------------------
-- Procedure for unloading object grants to the text file.                               --
-- Must be executed from DBA user.                                                       --
-- Uses OS filesystem for output plain text file named ObjectsFileName.                  --
-- Directory-ObjectsFilePath, if file exists, it'll be owerwritten without any warnings. --
-- ORACLE owner user must have permissions for write into specified directory.           --
-- Note: Directory path is OS-specific! UTL_FILE_DIR = * parameter must be specified!    --
-- Written by Yuri Voinov (C) 2002-2005.                                                 --
-- ------------------------------------------------------------------------------------- --
-- Modifications:                                                                        --
-- 30.01.2003- Initial code written.                                                     --
-- ----------------------------------------------------------------------------------------

 Create_command CONSTANT VARCHAR2(30) := 'GRANT ';
 Create_command_spare CONSTANT VARCHAR2(4) := ' ON ';
 Create_command_spare2 CONSTANT VARCHAR2(4) := ' TO ';
 Create_command_spare3 CONSTANT VARCHAR2(1) := ';';
 Create_command_grantable_spare CONSTANT VARCHAR2(20) := ' WITH GRANT OPTION';
 Create_command_grant_option VARCHAR2(20);

 SpoolOn CONSTANT VARCHAR2(30) := 'spool grants.log';
 SpoolOff CONSTANT VARCHAR2(30) := 'spool off';
 Obj_cnt2 NUMBER; /* Local internal counter for column grants checking */

 CURSOR Grants_tab_cursor IS                     /* Cursor for unload table grants */
  SELECT /*+ PARALLEL */ * FROM user_tab_privs_made;

 CURSOR Grants_col_cursor IS                     /* Cursor for unload column grants */
  SELECT /*+ PARALLEL */ * FROM user_col_privs_made;

 GRANTS_NOT_FOUND EXCEPTION;
/*---------------------------------------------------------------------------------------*/
BEGIN
 -- Check if any grants exists.
 IF (tab_grants_exists = 0) AND (col_grants_exists  = 0)
  THEN RAISE GRANTS_NOT_FOUND;
  ELSE Col_grants_cnt := col_grants_exists; -- This is need for workaTrunc with not
 END IF;                                    -- execute second IF branch, when column grants
                                            -- is absent.
 -- Open file for write. Directory is ObjectsFilePath,
 -- file name ObjectsFileName.sql, file is open for write.
 BEGIN
  Obj_file := UTL_FILE.fopen (ObjectsFilePath, ObjectsFileName || DefaultExtension, 'w', 32767);
 EXCEPTION
  WHEN UTL_FILE.INVALID_PATH THEN
   raise_application_error(-20020, 'Path your specified not found or permission denied.');
  WHEN UTL_FILE.INVALID_FILEHANDLE THEN
   raise_application_error (-20021, 'File handle is invalid.');
  WHEN UTL_FILE.WRITE_ERROR THEN
   raise_application_error (-20022, 'Write error. Path not found or permission denied.');
  WHEN OTHERS THEN
   raise_application_error (-20029, 'Unknown OS error.');
 END;

 UTL_FILE.put_line (Obj_file, 'rem ' || Obj_type_grants || ' unloaded by package ' || Version);
 Time_start := SYSDATE;
 
 UTL_FILE.put_line (Obj_file, Banner);
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */

 UTL_FILE.put_line (Obj_file, Banner2);
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */

 UTL_FILE.put_line (Obj_file, 'rem Found ' || Tab_grants_cnt || ' table grants in target schema.');
 UTL_FILE.put_line (Obj_file, 'rem Found ' || Col_grants_cnt || ' column grants in target schema.');
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */
 -- Prompt begin prompt in script
 UTL_FILE.put_line (Obj_file, PromptBeginSpare || LOWER(Obj_type_grants) || PromptBeginSpare2);
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */
 UTL_FILE.put_line (Obj_file, TermoutOff);
 UTL_FILE.put_line (Obj_file, EchoOn);
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */

 UTL_FILE.put_line (Obj_file, SpoolOn);
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */
 /* ====== TABLE GRANTS UNLOAD CYCLE ====== */
 UTL_FILE.put_line (Obj_file, 'rem Table grants.'); -- Output group comment
 UTL_FILE.put_line (Obj_file, 'rem =============');
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */

 FOR Cursor_record IN Grants_tab_cursor
  LOOP
   IF Cursor_record.grantable = 'YES'
    THEN Create_command_grant_option := Create_command_grantable_spare;
    ELSE Create_command_grant_option := '';
   END IF;
   UTL_FILE.put_line(Obj_file, Create_command || Cursor_record.privilege ||
                               Create_command_spare ||
                               '"' || Cursor_record.table_name || '"' ||
                               Create_command_spare2 || Cursor_record.grantee ||
                               Create_command_grant_option || Create_command_spare3);
   UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. Put CR/LF after each string */
   Obj_cnt := Grants_tab_cursor%ROWCOUNT;  -- Increment Obj_cnt by cursor ROWCOUNT
  END LOOP;
 /* ====== COLUMN GRANTS UNLOAD CYCLE ====== */
 UTL_FILE.put_line (Obj_file, 'rem Column grants.'); -- Output group comment
 UTL_FILE.put_line (Obj_file, 'rem ==============');
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */
 FOR Cursor_record IN Grants_col_cursor
  LOOP
   IF Cursor_record.grantable = 'YES'
    THEN Create_command_grant_option := Create_command_grantable_spare;
    ELSE Create_command_grant_option := '';
   END IF;
   UTL_FILE.put_line(Obj_file, Create_command || Cursor_record.privilege ||
                               ' (' || Cursor_record.column_name || ')' ||
                               Create_command_spare ||
                               '"' || Cursor_record.table_name || '"' ||
                               Create_command_spare2 || Cursor_record.grantee ||
                               Create_command_grant_option || Create_command_spare3);
   UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. Put CR/LF after each string */
   Obj_cnt2 := Grants_col_cursor%ROWCOUNT;  -- Increment Obj_cnt2 by cursor ROWCOUNT
  END LOOP;

 UTL_FILE.put_line (Obj_file, SpoolOff);
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */
 UTL_FILE.put_line (Obj_file, EchoOff);
 UTL_FILE.put_line (Obj_file, TermoutOn);
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */
 -- Total unload table grants counter write
 UTL_FILE.put_line (Obj_file, 'rem Unloaded ' || Tab_grants_cnt || ' table grants.');

 -- Total unload column grants counter write
 UTL_FILE.put_line (Obj_file, 'rem Unloaded ' || Col_grants_cnt || ' column grants.');

 -- Final quantity checking table grants...
 IF Tab_grants_cnt > Obj_cnt THEN
  UTL_FILE.put_line (Obj_file, 'rem WARNING! Actually unloaded table grants are LESS then owned.');
 ELSIF Tab_grants_cnt < Obj_cnt THEN
  UTL_FILE.put_line (Obj_file, 'rem WARNING! Actually unloaded table grants are MORE then owned.');
 ELSIF Tab_grants_cnt = Obj_cnt THEN
  UTL_FILE.put_line (Obj_file, 'rem Quantity checking OK. Table grants found equal unloaded.');
 END IF;

 -- Final quantity chacking column grants. Obj_cnt2 using.
 IF Col_grants_cnt > Obj_cnt2 THEN
  UTL_FILE.put_line (Obj_file, 'rem WARNING! Actually unloaded column grants are LESS then owned.');
 ELSIF Col_grants_cnt < Obj_cnt2 THEN
  UTL_FILE.put_line (Obj_file, 'rem WARNING! Actually unloaded column grants are MORE then owned.');
 ELSIF Col_grants_cnt = Obj_cnt2 THEN
  UTL_FILE.put_line (Obj_file, 'rem Quantity checking OK. Column grants found equal unloaded.');
 END IF;

 Time_end := SYSDATE; -- Get timings
 Time_total_hh := Trunc(((Time_end-Time_start)*24),0);
 Time_total_mi := Trunc((((Time_end-Time_start)*24 - Time_total_hh)*60),0);
 Time_total_ss := Trunc(((((Time_end-Time_start)*24 - Time_total_hh)*60 - Time_total_mi)*60),0);
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */
 UTL_FILE.put_line (Obj_file, 'rem Unload begun at: ' || TO_CHAR(Time_start,'fxDD-MM-YYYY HH24:MI:SS'));
 UTL_FILE.put_line (Obj_file, 'rem Unload end at  : ' || TO_CHAR(Time_end,'fxDD-MM-YYYY HH24:MI:SS'));
 UTL_FILE.put_line (Obj_file, 'rem TOTAL TIME: ' || Time_total_hh || ' hours ' ||
                                                    Time_total_mi || ' minutes ' ||
                                                    Time_total_ss || ' seconds');
                                                    
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */
 UTL_FILE.put_line (Obj_file, PromptEnd); -- Put end prompt in script
 UTL_FILE.new_line (Obj_file, 1); /* Writeln; analog. */
 UTL_FILE.put_line (Obj_file, 'exit'); -- Exit command in script

 BEGIN
  UTL_FILE.fflush (Obj_file); -- Flush OS cache ...
  UTL_FILE.fclose (Obj_file); -- Finally close views file ...
 EXCEPTION
  WHEN UTL_FILE.WRITE_ERROR THEN
   raise_application_error (-20022, 'Write error. Path not found or permission denied.');
 END;
EXCEPTION  -- Main exception interceptors for grants_unload procedure.
 WHEN GRANTS_NOT_FOUND THEN
  raise_application_error (-20028, 'CANNOT FIND any grants in current schema.');
 WHEN OTHERS THEN
  raise_application_error (-20025, 'ORA' || SQLCODE || ' raised.');
END grants_unload;
/*---------------------------------------------------------------------------------------*/
END utl_unld;
/