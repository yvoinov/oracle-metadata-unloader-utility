#!/bin/sh

# --------------------------------------------------------------------------
# -- PROJECT_NAME: UTL_UNLD_prj                                           --
# -- RELEASE_VERSION: 1.0.0.6                                             --
# -- RELEASE_STATUS: Production                                           --
# --                                                                      --
# -- PLATFORM_IDENTIFICATION: UNIX                                        --
# --                                                                      --
# -- IDENTIFICATION: .\Unloader\UTL_UNLD\unload.sh                        --
# -- DESCRIPTION: Description for this file see below.                    --
# --                                                                      --
# --                                                                      --
# -- INTERNAL_FILE_VERSION: 0.0.0.7                                       --
# --                                                                      --
# -- COPYRIGHT: Yuri Voinov (C) 2002-2005                                 --
# --                                                                      --
# -- MODIFICATIONS:                                                       --
# -- 28.10.2005 -Script completely re-written.                            --
# -- 12.08.2001 -Initial code written.                                    --
# --------------------------------------------------------------------------

echo UNLOADER 1.0.0.6 running...

sqlplus /nolog @unload.sql

mv *.log trace

echo UNLOADER 1.0.0.6 complete.