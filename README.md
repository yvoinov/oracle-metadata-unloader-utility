# UTL_UNLD package
[![License](https://img.shields.io/badge/License-BSD%203--Clause-blue.svg)](https://github.com/yvoinov/oracle-metadata-unloader-utility/blob/master/LICENSE)

                      *******************
                      * Version 1.0.0.6 *
                      *******************

Utility and package for unloading views, synonims, grants and other objects to the plain text file - sql-script for creation under (i)SQL*Plus.

Note: Output text files is regular SQL-scripts and must execute from (i)SQL*Plus.

Uses OS filesystem for output plain text file named ObjectsFileName. Directory ObjectsFilePath, if file exists, it'll be owerwritten without any warnings. ORACLE owner user must have permissions for write into specified directory.

Note: Directory path is OS specific. UTL_FILE_DIR = * parameter must be specified.

## Usage:

1. Prepare Oracle parameter file and restart instance
2. Modify if need and run unload.sh/bat/cmd script. All required parameters can be set interactively.
 
All logs will be moved to directory named "trace", which must be created from working directory in lower case. Note, that unloaded objects will be in SQL-scripts, named "synonyms.sql", "views.sql" etc. without main starting script. You must transfer it to the target system and run as You need.

One-step usage: For one-step unloading open shell scripts unload.sh/bat/cmd, edit environment variables as You need for Your system, then run it. Scripts installs all needful components to target schema, execute unload procedure and completely remove all installed objects. All operations are logged, please, check out log files to errors.
