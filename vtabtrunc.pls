CREATE OR REPLACE PROCEDURE views_tab_trunc IS
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
-- IDENTIFICATION: .\Unloader\UTL_UNLD\vtabtrunc.pls                         --
-- DESCRIPTION: Procedure for truncating temp views table. Must be called    --
--              from scripts or procedures with schema owner rights.         --
--                                                                           --
--                                                                           --
-- INTERNAL_FILE_VERSION: 0.0.0.6                                            --
--                                                                           --
-- COPYRIGHT: Yuri Voinov (C) 2002-2005                                      --
--                                                                           --
-- MODIFICATIONS:                                                            --
-- 17.09.2002 -Initial code written.                                         --
-------------------------------------------------------------------------------
 DDL_Trunc CONSTANT VARCHAR2(50) := 'TRUNCATE TABLE tmp_views';
BEGIN
 EXECUTE IMMEDIATE DDL_Trunc;
END views_tab_trunc;
/
