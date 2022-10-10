@Echo off
cls
title UNLOADER 1.0.0.6 running...
Echo UNLOADER 1.0.0.6 running...
rem --------------------------------------------------------------------------
rem -- PROJECT_NAME: UTL_UNLD_prj                                           --
rem -- RELEASE_VERSION: 1.0.0.6                                             --
rem -- RELEASE_STATUS: Production                                           --
rem --                                                                      --
rem -- PLATFORM_IDENTIFICATION: Windows NT4 (x86)/Win2K (x86)               --
rem --                                                                      --
rem -- IDENTIFICATION: .\Unloader\UTL_UNLDR\unload.cmd                      --
rem -- DESCRIPTION: Description for this file see below.                    --
rem --                                                                      --
rem --                                                                      --
rem -- INTERNAL_FILE_VERSION: 0.0.0.7                                       --
rem --                                                                      --
rem -- COPYRIGHT: Yuri Voinov (C) 2002-2005                                 --
rem --                                                                      --
rem -- MODIFICATIONS:                                                       --
rem -- 28.10.2005 -Script completely re-written.                            --
rem -- 17.09.2002 -Initial code written.                                    --
rem --------------------------------------------------------------------------

sqlplus /nolog @unload.sql

rem Move all logs to trace directory
copy *.log trace
del /f /q *.log

Echo UNLOADER 1.0.0.6 complete.
title UNLOADER 1.0.0.6 complete.
