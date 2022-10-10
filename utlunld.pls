CREATE OR REPLACE PACKAGE utl_unld AUTHID DEFINER IS
-------------------------------------------------------------------------------
-- PROJECT_NAME: UTL_UNLD_prj                                                --
-- RELEASE_VERSION: 1.0.0.6                                                  --
-- RELEASE_STATUS: Production                                                --
--                                                                           --
-- REQUIRED_ORACLE_VERSION: 8.1.6.x                                          --
-- MINIMUM_ORACLE_VERSION: 8.1.6.x                                           --
-- MAXIMUM_ORACLE_VERSION: 10.2.0.x                                          --
-- PLATFORM_IDENTIFICATION: Generic                                          --
--                                                                           --
-- IDENTIFICATION: .\Unloader\UTL_UNLD\utlunld.pls                           --
-- DESCRIPTION:                                                              --
-- Package for unloading schema obects definitions to the create script file.--
-- All procedures must be executed from DBA user.                            --
-- Uses OS filesystem for output plain text file named ViewsFileName.        --
-- Directory - ViewsFilePath, if file exists, it'll be owerwritten without   --
-- any warnings.                                                             --
-- ORACLE owner user must have permissions for write into specified          --
-- directory.                                                                --
-- Note: Directory path is OS-specific! UTL_FILE_DIR = * parameter must be   --
-- specified!                                                                --
--                                                                           --
-- Usage:                                                                    --
-- 1. Install package and all its components by run setup.sql script         --
-- 2. Prepare Oracle parameter file and restart instance                     --
-- 3. Modify if need and run unload.sql script                               --
-- 4. Run script vtabclear.sql to truncate tmp_views table                   --
-- 5. To completely remove all package components, run remove.sql script     --
--                                                                           --
-- INTERNAL_FILE_VERSION: 0.0.0.7                                            --
--                                                                           --
-- COPYRIGHT: Yuri Voinov (C) 2002-2005                                      --
--                                                                           --
-- MODIFICATIONS:                                                            --
-- 31.10.2005- 'Force' specification added in views_unload procedure.        --
-- 30.01.2003- Object grants unload procedure added.                         --
-- 02.01.2003- Stupid minor bug with time format mask corrected. (Must be MI,--
--             not MM ;))                                                    --
-- 01.01.2003- Stupid combination with synonyms added - PUBLIC synonym for   --
--             OWN objects.                                                  --
--             database links using...                                       --
-- 28.11.2002- AUTHID clause added. Additional exceptions interceptors added.--
-- 10.10.2002- Parallel execution added.                                     --
-- 17.09.2002- Initial code written.                                         --
-- ----------------------------------------------------------------------------

 PROCEDURE views_tab_create;

 PROCEDURE views_tab_drop;

 PROCEDURE views_unload (ObjectsFilePath IN VARCHAR2, 
                         ObjectsFileName IN VARCHAR2,
                         ObjectForceFlag IN VARCHAR2 DEFAULT 'NOFORCE');
 /* ObjectForceFlag uses for unload CREATE VIEW commands with FORCE clause. */ 
 /* Possible values is 'FORCE' and 'NOFORCE'. Default is 'NOFORCE'.         */
 /* Case will be ignored. Any different values produces an error ORA-20030. */ 

 PROCEDURE synonyms_unload (ObjectsFilePath IN VARCHAR2, 
                            ObjectsFileName IN VARCHAR2);

 PROCEDURE grants_unload (ObjectsFilePath IN VARCHAR2, 
                          ObjectsFileName IN VARCHAR2);

END utl_unld;
/
