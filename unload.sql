rem --------------------------------------------------------------------------
rem -- PROJECT_NAME: UTL_UNLD_prj                                           --
rem -- RELEASE_VERSION: 1.0.0.6                                             --
rem -- RELEASE_STATUS: Production                                           --
rem --                                                                      --
rem -- REQUIRED_ORACLE_VERSION: 8.1.6.x                                     --
rem -- MINIMUM_ORACLE_VERSION: 8.1.6.x                                      --
rem -- MAXIMUM_ORACLE_VERSION: 10.2.0.x                                     --
rem -- PLATFORM_IDENTIFICATION: Generic                                     --
rem --                                                                      --
rem -- IDENTIFICATION: .\Unloader\UTL_UNLDR\unload.sql                      --
rem -- DESCRIPTION: Calling script for unload views, synonyms and grants    --
rem --              both from client and server.                            --
rem --                                                                      --
rem --                                                                      --
rem -- INTERNAL_FILE_VERSION: 0.0.0.2                                       --
rem --                                                                      --
rem -- COPYRIGHT: Yuri Voinov (C) 2002-2005                                 --
rem --                                                                      --
rem -- MODIFICATIONS:                                                       --
rem -- 31.10.2005 -Force mode capability is added for unload views.         --
rem -- 28.10.2005 -Initial code written.                                    --
rem --------------------------------------------------------------------------

rem Define variables
ACCEPT oracle_sid CHAR -
PROMPT 'Input ORACLE SID: '
ACCEPT unload_dir CHAR -
PROMPT 'Input unload directory: '
ACCEPT par_degree CHAR DEFAULT '4' -
PROMPT 'Input parallel degree for operation, default 4: '
ACCEPT force_mode CHAR DEFAULT 'NOFORCE' -
PROMPT 'Input unload mode for views (FORCE, NOFORCE), default NOFORCE: '
ACCEPT schema_owner CHAR -
PROMPT 'Input schema owner: '
ACCEPT own_pwd CHAR -
PROMPT 'Input schema owner password: ' HIDE

rem Environment preparation
set echo off
set verify off

rem ======================== MAIN BLOCK =========================

rem For RDBMS 9.x-10.x you must connect as sysdba to unload SYS objects
rem connect &&schema_owner/&&own_pwd@&&oracle_sid as sysdba

connect &&schema_owner/&&own_pwd@&&oracle_sid

rem Define constants
DEFINE v_file_name = 'views'
DEFINE s_file_name = 'synonyms'
DEFINE g_file_name = 'grants'

rem -- Setup all needful components --

set echo on

spool setup.log

rem Create temporary LOB table for views code. 
rem Need for correctly package compilation.
rem Can be re-created from package.

rem For more performance, uncomment keyword PARALLEL in next statement.
rem It commented because can produce 
rem ORA-00600: internal error code, arguments: [QerpxObjMd2]
rem on some Oracle RDBMS (8.1.6.0.0, 8.1.7.0.0 for example)


CREATE TABLE tmp_views NOLOGGING PARALLEL AS 
SELECT /* PARALLEL &&par_degree */ view_name, text_length, 
       TO_LOB(text) text 
FROM user_views;

set echo off

@@utlunld.pls

show errors

rem Main package body. In production releases uncomment *.plb string and
rem comment *.pls string. Be sure you wrap *.pls code before use this script.

@@prvtunld.pls
rem @@prvtunld.plb
rem @@prvtunld10.plb

show errors

rem Additional procedural component for cleaning views LOB table

@@vtabtrunc.pls

show errors

spool off

rem -- End setup block --

set echo on

rem -- Views unload call --

spool unload_views.log

execute utl_unld.views_tab_create;

rem Third parameter must be defined for unload views in FORCE mode.
rem By default, views_unload procedure creates views in NOFORCE mode.
rem Default value is set when third parameter is ommitted.

execute utl_unld.views_unload('&&unload_dir', '&&v_file_name', '&&force_mode');

spool off

rem -- End views unload call --

rem -- Synonyms unload call --

spool unload_synonyms.log

execute utl_unld.synonyms_unload('&&unload_dir', '&&s_file_name');

spool off

rem -- End synonyms unload call --

rem -- Grants unload call --

spool unload_grants.log

execute utl_unld.grants_unload('&&unload_dir', '&&g_file_name');

spool off

rem -- End grants unload call --

rem -- Remove all structures --

spool remove.log

rem Truncate temporary table first for speed up drop table command
execute views_tab_trunc;

drop package utl_unld;

drop procedure views_tab_trunc;

drop table tmp_views;

spool off

rem -- End remove all structures --

set echo off

rem ===================== END MAIN BLOCK ========================

rem Undefine constants for current session
UNDEFINE v_file_name
UNDEFINE s_file_name
UNDEFINE g_file_name

disconnect

exit
