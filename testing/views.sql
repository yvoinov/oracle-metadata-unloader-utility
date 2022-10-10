rem Views unloaded by package UTL_UNLD Version 1.0.0.6
rem Written by Y.Voinov (C) 2002-2005

rem Must be run from (i)SQL*Plus from existing account

rem Found 2647 in target schema.

prompt Loading views started...

set termout off
rem set echo on

spool views.log

CREATE OR REPLACE FORCE VIEW "ALL_ALL_TABLES"("OWNER",
select OWNER, TABLE_NAME, TABLESPACE_NAME, CLUSTER_NAME, IOT_NAME,
     PCT_FREE, PCT_USED,
     INI_TRANS, MAX_TRANS,
     INITIAL_EXTENT, NEXT_EXTENT,
     MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE,
     FREELISTS, FREELIST_GROUPS, LOGGING,
     BACKED_UP, NUM_ROWS, BLOCKS, EMPTY_BLOCKS,
     AVG_SPACE, CHAIN_CNT, AVG_ROW_LEN,
     AVG_SPACE_FREELIST_BLOCKS, NUM_FREELIST_BLOCKS,
     DEGREE, INSTANCES, CACHE, TABLE_LOCK,
     SAMPLE_SIZE, LAST_ANALYZED, PARTITIONED,
     IOT_TYPE, NULL, NULL, NULL, TEMPORARY, SECONDARY, NESTED,
     BUFFER_POOL, ROW_MOVEMENT,
     GLOBAL_STATS, USER_STATS, DURATION, SKIP_CORRUPT, MONITORING,
     CLUSTER_OWNER, DEPENDENCIES, COMPRESSION, DROPPED
from all_tables
union all
select OWNER, TABLE_NAME, TABLESPACE_NAME, CLUSTER_NAME, IOT_NAME,
     PCT_FREE, PCT_USED,
     INI_TRANS, MAX_TRANS,
     INITIAL_EXTENT, NEXT_EXTENT,
     MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE,
     FREELISTS, FREELIST_GROUPS, LOGGING,
     BACKED_UP, NUM_ROWS, BLOCKS, EMPTY_BLOCKS,
     AVG_SPACE, CHAIN_CNT, AVG_ROW_LEN,
     AVG_SPACE_FREELIST_BLOCKS, NUM_FREELIST_BLOCKS,
     DEGREE, INSTANCES, CACHE, TABLE_LOCK,
     SAMPLE_SIZE, LAST_ANALYZED, PARTITIONED,
     IOT_TYPE, OBJECT_ID_TYPE,
     TABLE_TYPE_OWNER, TABLE_TYPE, TEMPORARY, SECONDARY, NESTED,
     BUFFER_POOL, ROW_MOVEMENT,
     GLOBAL_STATS, USER_STATS, DURATION, SKIP_CORRUPT, MONITORING,
     CLUSTER_OWNER, DEPENDENCIES, COMPRESSION, DROPPED
from all_object_tables;

CREATE OR REPLACE FORCE VIEW "ALL_APPLY"("APPLY_NAME",
select a."APPLY_NAME",a."QUEUE_NAME",a."QUEUE_OWNER",a."APPLY_CAPTURED",a."RULE_SET_NAME",a."RULE_SET_OWNER",a."APPLY_USER",a."APPLY_DATABASE_LINK",a."APPLY_TAG",a."DDL_HANDLER",a."PRECOMMIT_HANDLER",a."MESSAGE_HANDLER",a."STATUS",a."MAX_APPLIED_MESSAGE_NUMBER",a."NEGATIVE_RULE_SET_NAME",a."NEGATIVE_RULE_SET_OWNER",a."STATUS_CHANGE_TIME",a."ERROR_NUMBER",a."ERROR_MESSAGE"
  from dba_apply a, all_queues q
 where a.queue_name = q.name
   and a.queue_owner = q.owner
   and ((a.rule_set_owner is null and a.rule_set_name is null) or
        ((a.rule_set_owner, a.rule_set_name) in
          (select r.rule_set_owner, r.rule_set_name
             from all_rule_sets r)))
   and ((a.negative_rule_set_owner is null and
         a.negative_rule_set_name is null) or
        ((a.negative_rule_set_owner, a.negative_rule_set_name) in
          (select r.rule_set_owner, r.rule_set_name
             from all_rule_sets r)));

CREATE OR REPLACE FORCE VIEW "ALL_APPLY_CONFLICT_COLUMNS"("OBJECT_OWNER",
select c.object_owner, c.object_name, c.method_name,
       c.resolution_column, c.column_name, c.apply_database_link
  from all_tab_columns o, dba_apply_conflict_columns c
 where c.object_owner = o.owner
   and c.object_name = o.table_name
   and c.column_name = o.column_name;

CREATE OR REPLACE FORCE VIEW "ALL_APPLY_DML_HANDLERS"("OBJECT_OWNER",
select h.object_owner, h.object_name, h.operation_name,
       h.user_procedure, h.error_handler, h.apply_database_link, h.apply_name
  from all_tables o, dba_apply_dml_handlers h
 where h.object_owner = o.owner
   and h.object_name = o.table_name;

CREATE OR REPLACE FORCE VIEW "ALL_APPLY_ENQUEUE"("RULE_OWNER",
select e."RULE_OWNER",e."RULE_NAME",e."DESTINATION_QUEUE_NAME"
from dba_apply_enqueue e, ALL_RULES r, ALL_QUEUES aq
where e.rule_owner = r.rule_owner and e.rule_name = r.rule_name
  and e.destination_queue_name = '"'||aq.owner||'"' ||'.'|| '"'||aq.name||'"';

CREATE OR REPLACE FORCE VIEW "ALL_APPLY_ERROR"("APPLY_NAME",
(
select e.apply_name, e.queue_name, e.queue_owner, e.local_transaction_id,
       e.source_database, e.source_transaction_id,
       e.source_commit_scn, e.message_number, e.error_number,
       e.error_message, e.recipient_id, e.recipient_name, e.message_count
  from dba_apply_error e, all_users u, all_queues q
 where e.recipient_id = u.user_id
   and q.name = e.queue_name
   and q.owner = e.queue_owner
union all
select e.apply_name, e.queue_name, e.queue_owner, e.local_transaction_id,
       e.source_database, e.source_transaction_id,
       e.source_commit_scn, e.message_number, e.error_number,
       e.error_message, e.recipient_id, e.recipient_name, e.message_count
  from dba_apply_error e
 where e.recipient_id NOT IN (select user_id from dba_users));

CREATE OR REPLACE FORCE VIEW "ALL_APPLY_EXECUTE"("RULE_OWNER",
select e."RULE_OWNER",e."RULE_NAME",e."EXECUTE_EVENT"
from dba_apply_execute e, ALL_RULES r
where e.rule_owner = r.rule_owner and e.rule_name = r.rule_name;

CREATE OR REPLACE FORCE VIEW "ALL_APPLY_KEY_COLUMNS"("OBJECT_OWNER",
select k.object_owner, k.object_name, k.column_name, k.apply_database_link
  from all_tab_columns a, dba_apply_key_columns k
 where k.object_owner = a.owner
   and k.object_name = a.table_name
   and k.column_name = a.column_name;

CREATE OR REPLACE FORCE VIEW "ALL_APPLY_PARAMETERS"("APPLY_NAME",
select pa.apply_name, pa.parameter, pa.value, pa.set_by_user
  from dba_apply_parameters pa, all_apply aa
 where pa.apply_name = aa.apply_name;

CREATE OR REPLACE FORCE VIEW "ALL_APPLY_PROGRESS"("APPLY_NAME",
select ap.apply_name, ap.source_database, ap.applied_message_number,
       ap.oldest_message_number, ap.apply_time, ap.applied_message_create_time
  from dba_apply_progress ap, all_apply a
 where ap.apply_name = a.apply_name;

CREATE OR REPLACE FORCE VIEW "ALL_APPLY_TABLE_COLUMNS"("OBJECT_OWNER",
select do."OBJECT_OWNER",do."OBJECT_NAME",do."COLUMN_NAME",do."COMPARE_OLD_ON_DELETE",do."COMPARE_OLD_ON_UPDATE",do."APPLY_DATABASE_LINK"
  from all_tab_columns a, dba_apply_table_columns do
 where do.object_owner = a.owner
   and do.object_name = a.table_name
   and do.column_name = a.column_name;

CREATE OR REPLACE FORCE VIEW "ALL_ARGUMENTS"("OWNER",
select
u.name, /* OWNER */
nvl(a.procedure$,o.name), /* OBJECT_NAME */
decode(a.procedure$,null,null, o.name), /* PACKAGE_NAME */
o.obj#, /* OBJECT_ID */
decode(a.overload#,0,null,a.overload#), /* OVERLOAD */
a.argument, /* ARGUMENT_NAME */
a.position#, /* POSITION */
a.sequence#, /* SEQUENCE */
a.level#, /* DATA_LEVEL */
decode(a.type#,  /* DATA_TYPE */
0, null,
1, decode(a.charsetform, 2, 'NVARCHAR2', 'VARCHAR2'),
2, decode(a.scale, -127, 'FLOAT', 'NUMBER'),
3, 'NATIVE INTEGER',
8, 'LONG',
9, decode(a.charsetform, 2, 'NCHAR VARYING', 'VARCHAR'),
11, 'ROWID',
12, 'DATE',
23, 'RAW',
24, 'LONG RAW',
29, 'BINARY_INTEGER',
69, 'ROWID',
96, decode(a.charsetform, 2, 'NCHAR', 'CHAR'),
100, 'BINARY_FLOAT',
101, 'BINARY_DOUBLE',
102, 'REF CURSOR',
104, 'UROWID',
105, 'MLSLABEL',
106, 'MLSLABEL',
110, 'REF',
111, 'REF',
112, decode(a.charsetform, 2, 'NCLOB', 'CLOB'),
113, 'BLOB', 114, 'BFILE', 115, 'CFILE',
121, 'OBJECT',
122, 'TABLE',
123, 'VARRAY',
178, 'TIME',
179, 'TIME WITH TIME ZONE',
180, 'TIMESTAMP',
181, 'TIMESTAMP WITH TIME ZONE',
231, 'TIMESTAMP WITH LOCAL TIME ZONE',
182, 'INTERVAL YEAR TO MONTH',
183, 'INTERVAL DAY TO SECOND',
250, 'PL/SQL RECORD',
251, 'PL/SQL TABLE',
252, 'PL/SQL BOOLEAN',
'UNDEFINED'),
default$, /* DEFAULT_VALUE */
deflength, /* DEFAULT_LENGTH */
decode(in_out,null,'IN',1,'OUT',2,'IN/OUT','Undefined'), /* IN_OUT */
length, /* DATA_LENGTH */
precision#, /* DATA_PRECISION */
decode(a.type#, 2, scale, 1, null, 96, null, scale), /* DATA_SCALE */
radix, /* RADIX */
decode(a.charsetform, 1, 'CHAR_CS',           /* CHARACTER_SET_NAME */
                      2, 'NCHAR_CS',
                      3, NLS_CHARSET_NAME(a.charsetid),
                      4, 'ARG:'||a.charsetid),
a.type_owner, /* TYPE_OWNER */
a.type_name, /* TYPE_NAME */
a.type_subname, /* TYPE_SUBNAME */
a.type_linkname, /* TYPE_LINK */
a.pls_type, /* PLS_TYPE */
decode(a.type#, 1, a.scale, 96, a.scale, 0), /* CHAR_LENGTH */
decode(a.type#,
        1, decode(bitand(a.properties, 128), 128, 'C', 'B'),
       96, decode(bitand(a.properties, 128), 128, 'C', 'B'), 0) /* CHAR_USED */
from obj$ o,argument$ a,user$ u
where o.obj# = a.obj#
and o.owner# = u.user#
and (owner# = userenv('SCHEMAID')
or exists
  (select null from v$enabledprivs where priv_number in (-144,-141))
or o.obj# in (select obj# from sys.objauth$ where grantee# in
  (select kzsrorol from x$kzsro) and privilege# = 12));

CREATE OR REPLACE FORCE VIEW "ALL_ASSOCIATIONS"("OBJECT_OWNER",
select u.name, o.name, c.name,
         decode(a.property, 1, 'COLUMN', 2, 'TYPE', 3, 'PACKAGE', 4,
                'FUNCTION', 5, 'INDEX', 6, 'INDEXTYPE', 'INVALID'),
         u1.name, o1.name,a.default_selectivity,
         a.default_cpu_cost, a.default_io_cost, a.default_net_cost,
         a.interface_version#
   from  sys.association$ a, sys.obj$ o, sys.user$ u,
         sys.obj$ o1, sys.user$ u1, sys.col$ c
   where a.obj#=o.obj# and o.owner#=u.user#
   AND   a.statstype#=o1.obj# (+) and o1.owner#=u1.user# (+)
   AND   a.obj# = c.obj#  (+)  and a.intcol# = c.intcol# (+)
   and (o.owner# = userenv('SCHEMAID')
        or
        o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or
       ( o.type# in (2)  /* table */
         and
         exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */,
                                        -42 /* ALTER ANY TABLE */)
                 )
       )
       or
       ( o.type# in (8, 9)   /* package or function */
         and
         exists (select null from v$enabledprivs
                  where priv_number in (-140 /* CREATE PROCEDURE */,
                                        -141 /* CREATE ANY PROCEDURE */,
                                        -142 /* ALTER ANY PROCEDURE */,
                                        -143 /* DROP ANY PROCEDURE */,
                                        -144 /* EXECUTE ANY PROCEDURE */)
                 )
       )
       or
       ( o.type# in (13)     /* type */
         and
         exists (select null from v$enabledprivs
                  where priv_number in (-180 /* CREATE TYPE */,
                                        -181 /* CREATE ANY TYPE */,
                                        -182 /* ALTER ANY TYPE */,
                                        -183 /* DROP ANY TYPE */,
                                        -184 /* EXECUTE ANY TYPE */)
                 )
       )
       or
       ( o.type# in (1)     /* index */
         and
         exists (select null from v$enabledprivs
                  where priv_number in (-71 /* CREATE ANY INDEX */,
                                        -72 /* ALTER ANY INDEX */,
                                        -73 /* DROP ANY INDEX */)
                 )
       )
       or
       ( o.type# in (32)     /* indextype */
         and
         exists (select null from v$enabledprivs
                  where priv_number in (-205 /* CREATE INDEXTYPE */,
                                        -206 /* CREATE ANY INDEXTYPE */,
                                        -207 /* ALTER ANY INDEXTYPE */,
                                        -208 /* DROP ANY INDEXTYPE */)
                 )
       )
    );

CREATE OR REPLACE FORCE VIEW "ALL_AUDIT_POLICIES"("OBJECT_SCHEMA",
SELECT OBJECT_SCHEMA, OBJECT_NAME, POLICY_NAME, POLICY_TEXT,  POLICY_COLUMN,
       PF_SCHEMA, PF_PACKAGE, PF_FUNCTION, ENABLED,
       SEL, INS, UPD, DEL, AUDIT_TRAIL, POLICY_COLUMN_OPTIONS
FROM DBA_AUDIT_POLICIES, ALL_TABLES t
WHERE
(OBJECT_SCHEMA = t.OWNER AND OBJECT_NAME = t.TABLE_NAME)
union
SELECT OBJECT_SCHEMA, OBJECT_NAME, POLICY_NAME, POLICY_TEXT,  POLICY_COLUMN,
       PF_SCHEMA, PF_PACKAGE, PF_FUNCTION, ENABLED,
       SEL, INS, UPD, DEL, AUDIT_TRAIL, POLICY_COLUMN_OPTIONS
FROM DBA_AUDIT_POLICIES, ALL_VIEWS v
WHERE
(OBJECT_SCHEMA = v.OWNER AND OBJECT_NAME = v.VIEW_NAME);

CREATE OR REPLACE FORCE VIEW "ALL_AUDIT_POLICY_COLUMNS"("OBJECT_SCHEMA",
(select d.OBJECT_SCHEMA, d.OBJECT_NAME,
          d.POLICY_NAME, d.POLICY_COLUMN
from DBA_AUDIT_POLICY_COLUMNS d, ALL_TABLES t
where d.OBJECT_SCHEMA = t.OWNER AND d.OBJECT_NAME = t.TABLE_NAME)
union
(select d.OBJECT_SCHEMA, d.OBJECT_NAME,
          d.POLICY_NAME, d.POLICY_COLUMN
from DBA_AUDIT_POLICY_COLUMNS d, ALL_VIEWS v
where d.OBJECT_SCHEMA = v.OWNER AND d.OBJECT_NAME = v.VIEW_NAME);

CREATE OR REPLACE FORCE VIEW "ALL_AWS"("OWNER",
SELECT u.name, a.awseq#, a.awname,
       max(decode(a.version, 0, '9.1', 1, '10.1', NULL)),
       count(unique(p.psnumber)), count(unique(p.psgen))
FROM aw$ a, ps$ p, sys.obj$ o, sys.user$ u
WHERE  a.owner#=u.user#
       and o.owner# = a.owner#
       and o.name = 'AW$' || a.awname and o.type#= 2 /* type for table */
       and a.awseq#=p.awseq#
       and (a.owner# in (userenv('SCHEMAID'), 1)   /* public objects */
            or
            o.obj# in ( select obj#  /* directly granted privileges */
                        from sys.objauth$
                        where grantee# in ( select kzsrorol from x$kzsro )
                      )
            or   /* user has system privilages */
              ( exists (select null from v$enabledprivs
                        where priv_number in (-45 /* LOCK ANY TABLE */,
                                              -47 /* SELECT ANY TABLE */,
                                              -48 /* INSERT ANY TABLE */,
                                              -49 /* UPDATE ANY TABLE */,
                                              -50 /* DELETE ANY TABLE */)
                        )
              )
            )
group by a.awseq#, a.awname, u.name;

CREATE OR REPLACE FORCE VIEW "ALL_AW_PS"("OWNER",
SELECT u.name, a.awseq#, a.awname, p.psnumber, count(unique(p.psgen)), max(p.maxpages)
FROM aw$ a, ps$ p, user$ u, sys.obj$ o
WHERE  a.owner#=u.user#
       and o.owner# = a.owner#
       and o.name = 'AW$' || a.awname and o.type#= 2 /* type for table */
       and a.awseq#=p.awseq#
       and (a.owner# in (userenv('SCHEMAID'), 1)   /* public objects */
            or
            o.obj# in ( select obj#  /* directly granted privileges */
                        from sys.objauth$
                        where grantee# in ( select kzsrorol from x$kzsro )
                      )
            or   /* user has system privilages */
              ( exists (select null from v$enabledprivs
                        where priv_number in (-45 /* LOCK ANY TABLE */,
                                              -47 /* SELECT ANY TABLE */,
                                              -48 /* INSERT ANY TABLE */,
                                              -49 /* UPDATE ANY TABLE */,
                                              -50 /* DELETE ANY TABLE */)
                        )
              )
            )
group by a.awseq#, a.awname, u.name, p.psnumber;

CREATE OR REPLACE FORCE VIEW "ALL_BASE_TABLE_MVIEWS"("OWNER",
select s."OWNER",s."MASTER",s."MVIEW_LAST_REFRESH_TIME",s."MVIEW_ID" from dba_base_table_mviews s, all_mview_logs a
where a.log_owner = s.owner
  and a.master = s.master;

CREATE OR REPLACE FORCE VIEW "ALL_CAPTURE"("CAPTURE_NAME",
select c."CAPTURE_NAME",c."QUEUE_NAME",c."QUEUE_OWNER",c."RULE_SET_NAME",c."RULE_SET_OWNER",c."CAPTURE_USER",c."START_SCN",c."STATUS",c."CAPTURED_SCN",c."APPLIED_SCN",c."USE_DATABASE_LINK",c."FIRST_SCN",c."SOURCE_DATABASE",c."SOURCE_DBID",c."SOURCE_RESETLOGS_SCN",c."SOURCE_RESETLOGS_TIME",c."LOGMINER_ID",c."NEGATIVE_RULE_SET_NAME",c."NEGATIVE_RULE_SET_OWNER",c."MAX_CHECKPOINT_SCN",c."REQUIRED_CHECKPOINT_SCN",c."LOGFILE_ASSIGNMENT",c."STATUS_CHANGE_TIME",c."ERROR_NUMBER",c."ERROR_MESSAGE",c."VERSION",c."CAPTURE_TYPE"
  from dba_capture c, all_queues q
 where c.queue_name = q.name
   and c.queue_owner = q.owner
   and ((c.rule_set_owner is null and c.rule_set_name is null) or
        ((c.rule_set_owner, c.rule_set_name) in
          (select r.rule_set_owner, r.rule_set_name
             from all_rule_sets r)))
   and ((c.negative_rule_set_owner is null and
         c.negative_rule_set_name is null) or
        ((c.negative_rule_set_owner, c.negative_rule_set_name) in
          (select r.rule_set_owner, r.rule_set_name
             from all_rule_sets r)));

CREATE OR REPLACE FORCE VIEW "ALL_CAPTURE_EXTRA_ATTRIBUTES"("CAPTURE_NAME",
select e."CAPTURE_NAME",e."ATTRIBUTE_NAME",e."INCLUDE",e."ROW_ATTRIBUTE",e."DDL_ATTRIBUTE"
  from dba_capture_extra_attributes e, all_capture c
 where e.capture_name = c.capture_name;

CREATE OR REPLACE FORCE VIEW "ALL_CAPTURE_PARAMETERS"("CAPTURE_NAME",
select cp.capture_name, cp.parameter, cp.value, cp.set_by_user
  from dba_capture_parameters cp, all_capture ac
 where cp.capture_name = ac.capture_name;

CREATE OR REPLACE FORCE VIEW "ALL_CAPTURE_PREPARED_DATABASE"("TIMESTAMP") AS 
select "TIMESTAMP" from DBA_CAPTURE_PREPARED_DATABASE;

CREATE OR REPLACE FORCE VIEW "ALL_CAPTURE_PREPARED_SCHEMAS"("SCHEMA_NAME",
select s.schema_name, s.timestamp
  from dba_capture_prepared_schemas s, all_users u
 where s.schema_name = u.username;

CREATE OR REPLACE FORCE VIEW "ALL_CAPTURE_PREPARED_TABLES"("TABLE_OWNER",
select pt.table_owner, pt.table_name, pt.scn, pt.timestamp
  from all_tables at, dba_capture_prepared_tables pt
  where pt.table_name = at.table_name
    and pt.table_owner = at.owner;

CREATE OR REPLACE FORCE VIEW "ALL_CATALOG"("OWNER",
select u.name, o.name,
       decode(o.type#, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 'UNDEFINED')
from sys.user$ u, sys.obj$ o
where o.owner# = u.user#
  and ((o.type# in (4, 5, 6))
       or
       (o.type# = 2     /* tables, excluding iot - overflow and nested tables */
        and
        not exists (select null
                      from sys.tab$ t
                     where t.obj# = o.obj#
                       and (bitand(t.property, 512) = 512 or
                            bitand(t.property, 8192) = 8192))))
  and o.linkname is null
  and (o.owner# in (userenv('SCHEMAID'), 1)   /* public objects */
       or
       obj# in ( select obj#  /* directly granted privileges */
                 from sys.objauth$
                 where grantee# in ( select kzsrorol
                                      from x$kzsro
                                    )
                )
       or
       (
          o.type# in (2, 4, 5) /* table, view, synonym */
          and
          exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */))
       )
       or
       ( o.type# = 6 /* sequence */
         and
         exists (select null from v$enabledprivs
                 where priv_number = -109 /* SELECT ANY SEQUENCE */)));

CREATE OR REPLACE FORCE VIEW "ALL_CLUSTERS"("OWNER",
select u.name, o.name, ts.name,
          mod(c.pctfree$, 100),
          decode(bitand(ts.flags, 32), 32, to_number(NULL), c.pctused$),
          c.size$,c.initrans,c.maxtrans,
          s.iniexts * ts.blocksize,
          decode(bitand(ts.flags, 3), 1, to_number(NULL),
                               s.extsize * ts.blocksize),
          s.minexts, s.maxexts,
          decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                      s.extpct),
          decode(bitand(ts.flags, 32), 32, to_number(NULL),
           decode(s.lists, 0, 1, s.lists)),
          decode(bitand(ts.flags, 32), 32, to_number(NULL),
           decode(s.groups, 0, 1, s.groups)),
          c.avgchn, decode(c.hashkeys, 0, 'INDEX', 'HASH'),
          decode(c.hashkeys, 0, NULL,
                 decode(c.func, 0, 'COLUMN', 1, 'DEFAULT',
                                2, 'HASH EXPRESSION', 3, 'DEFAULT2', NULL)),
          c.hashkeys,
          lpad(decode(c.degree, 32767, 'DEFAULT', nvl(c.degree,1)),10),
          lpad(decode(c.instances, 32767, 'DEFAULT', nvl(c.instances,1)),10),
          lpad(decode(bitand(c.flags, 8), 8, 'Y', 'N'), 5),
          decode(s.cachehint, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL),
          lpad(decode(bitand(c.flags, 65536), 65536, 'Y', 'N'), 5),
          decode(bitand(c.flags, 8388608), 8388608, 'ENABLED', 'DISABLED')
from sys.user$ u, sys.ts$ ts, sys.seg$ s, sys.clu$ c, sys.obj$ o
where o.owner# = u.user#
  and o.obj#   = c.obj#
  and c.ts#    = ts.ts#
  and c.ts#    = s.ts#
  and c.file#  = s.file#
  and c.block# = s.block#
  and (o.owner# = userenv('SCHEMAID')
       or  /* user has system privilages */
         exists (select null from v$enabledprivs
                 where priv_number in (-61 /* CREATE ANY CLUSTER */,
                                       -62 /* ALTER ANY CLUSTER */,
                                       -63 /* DROP ANY CLUSTER */ )
                )
      );

CREATE OR REPLACE FORCE VIEW "ALL_CLUSTER_HASH_EXPRESSIONS"("OWNER",
select us.name, o.name, c.condition
from sys.cdef$ c, sys.user$ us, sys.obj$ o
where c.type#   = 8
and   c.obj#   = o.obj#
and   us.user# = o.owner#
and   ( us.user# = userenv('SCHEMAID')
        or  /* user has system privilages */
           exists (select null from v$enabledprivs
               where priv_number in (-61 /* CREATE ANY CLUSTER */,
                                     -62 /* ALTER ANY CLUSTER */,
                                     -63 /* DROP ANY CLUSTER */ )
                  )
      );

CREATE OR REPLACE FORCE VIEW "ALL_COLL_TYPES"("OWNER",
select u.name, o.name, co.name, c.upper_bound,
       decode(bitand(c.properties, 32768), 32768, 'REF',
              decode(bitand(c.properties, 16384), 16384, 'POINTER')),
       nvl2(c.synobj#, (select u.name from user$ u, obj$ o
            where o.owner#=u.user# and o.obj#=c.synobj#),
            decode(bitand(et.properties, 64), 64, null, eu.name)),
       nvl2(c.synobj#, (select o.name from obj$ o where o.obj#=c.synobj#),
            decode(et.typecode,
                   52, decode(c.charsetform, 2, 'NVARCHAR2', eo.name),
                   53, decode(c.charsetform, 2, 'NCHAR', eo.name),
                   54, decode(c.charsetform, 2, 'NCHAR VARYING', eo.name),
                   61, decode(c.charsetform, 2, 'NCLOB', eo.name),
                   eo.name)),
       c.length, c.precision, c.scale,
       decode(c.charsetform, 1, 'CHAR_CS',
                             2, 'NCHAR_CS',
                             3, NLS_CHARSET_NAME(c.charsetid),
                             4, 'ARG:'||c.charsetid),
       decode(bitand(c.properties, 131072), 131072, 'FIXED',
              decode(bitand(c.properties, 262144), 262144, 'VARYING')),
       decode(bitand(c.properties, 65536), 65536, 'NO', 'YES')
from sys.user$ u, sys.obj$ o, sys.collection$ c, sys.obj$ co,
     sys.obj$ eo, sys.user$ eu, sys.type$ et
where o.owner# = u.user#
  and o.type# <> 10 -- must not be invalid
  and o.oid$ = c.toid
  and o.subname IS NULL -- only the most recent version
  and c.coll_toid = co.oid$
  and c.elem_toid = eo.oid$
  and eo.owner# = eu.user#
  and c.elem_toid = et.tvoid
  and (o.owner# = userenv('SCHEMAID')
       or
       o.obj# in (select oa.obj#
                  from sys.objauth$ oa
                  where grantee# in (select kzsrorol
                                     from x$kzsro))
       or /* user has system privileges */
       exists (select null from v$enabledprivs
               where priv_number in (-184 /* EXECUTE ANY TYPE */,
                                     -181 /* CREATE ANY TYPE */)));

CREATE OR REPLACE FORCE VIEW "ALL_COL_COMMENTS"("OWNER",
select /*+ rule */ u.name, o.name, c.name, co.comment$
from sys.obj$ o, sys.col$ c, sys.user$ u, sys.com$ co
where o.owner# = u.user#
  and o.type# in (2, 4, 5)
  and o.obj# = c.obj#
  and c.obj# = co.obj#(+)
  and c.intcol# = co.col#(+)
  and bitand(c.property, 32) = 0 /* not hidden column */
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
         (select obj#
          from sys.objauth$
          where grantee# in ( select kzsrorol
                              from x$kzsro
                            )
          )
       or
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */))
      );

CREATE OR REPLACE FORCE VIEW "ALL_COL_PRIVS"("GRANTOR",
select ur.name, ue.name, u.name, o.name, c.name, tpm.name,
       decode(mod(oa.option$,2), 1, 'YES', 'NO')
from sys.objauth$ oa, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue,
     sys.col$ c, table_privilege_map tpm
where oa.obj# = o.obj#
  and oa.grantor# = ur.user#
  and oa.grantee# = ue.user#
  and u.user# = o.owner#
  and oa.obj# = c.obj#
  and oa.col# = c.col#
  and bitand(c.property, 32) = 0 /* not hidden column */
  and oa.col# is not null
  and oa.privilege# = tpm.privilege
  and (oa.grantor# = userenv('SCHEMAID') or
       oa.grantee# in (select kzsrorol from x$kzsro) or
       o.owner# = userenv('SCHEMAID'));

CREATE OR REPLACE FORCE VIEW "ALL_COL_PRIVS_MADE"("GRANTEE",
select ue.name, u.name, o.name, c.name, ur.name, tpm.name,
       decode(mod(oa.option$,2), 1, 'YES', 'NO')
from sys.objauth$ oa, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue,
     sys.col$ c, table_privilege_map tpm
where oa.obj# = o.obj#
  and oa.grantor# = ur.user#
  and oa.grantee# = ue.user#
  and u.user# = o.owner#
  and oa.obj# = c.obj#
  and oa.col# = c.col#
  and bitand(c.property, 32) = 0 /* not hidden column */
  and oa.col# is not null
  and oa.privilege# = tpm.privilege
  and userenv('SCHEMAID') in (o.owner#, oa.grantor#);

CREATE OR REPLACE FORCE VIEW "ALL_COL_PRIVS_RECD"("GRANTEE",
select ue.name, u.name, o.name, c.name, ur.name, tpm.name,
       decode(mod(oa.option$,2), 1, 'YES', 'NO')
from sys.objauth$ oa, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue,
     sys.col$ c, table_privilege_map tpm
where oa.obj# = o.obj#
  and oa.grantor# = ur.user#
  and oa.grantee# = ue.user#
  and u.user# = o.owner#
  and oa.obj# = c.obj#
  and oa.col# = c.col#
  and bitand(c.property, 32) = 0 /* not hidden column */
  and oa.col# is not null
  and oa.privilege# = tpm.privilege
  and oa.grantee# in (select kzsrorol from x$kzsro);

CREATE OR REPLACE FORCE VIEW "ALL_CONSTRAINTS"("OWNER",
select ou.name, oc.name,
       decode(c.type#, 1, 'C', 2, 'P', 3, 'U',
              4, 'R', 5, 'V', 6, 'O', 7,'C', '?'),
       o.name, c.condition, ru.name, rc.name,
       decode(c.type#, 4,
              decode(c.refact, 1, 'CASCADE', 2, 'SET NULL', 'NO ACTION'),
              NULL),
       decode(c.type#, 5, 'ENABLED',
              decode(c.enabled, NULL, 'DISABLED', 'ENABLED')),
       decode(bitand(c.defer, 1), 1, 'DEFERRABLE', 'NOT DEFERRABLE'),
       decode(bitand(c.defer, 2), 2, 'DEFERRED', 'IMMEDIATE'),
       decode(bitand(c.defer, 4), 4, 'VALIDATED', 'NOT VALIDATED'),
       decode(bitand(c.defer, 8), 8, 'GENERATED NAME', 'USER NAME'),
       decode(bitand(c.defer,16),16, 'BAD', null),
       decode(bitand(c.defer,32),32, 'RELY', null),
       c.mtime,
       decode(c.type#, 2, ui.name, 3, ui.name, null),
       decode(c.type#, 2, oi.name, 3, oi.name, null),
       decode(bitand(c.defer, 256), 256,
              decode(c.type#, 4,
                     case when (bitand(c.defer, 128) = 128
                                or o.status in (3, 5)
                                or ro.status in (3, 5)) then 'INVALID'
                          else null end,
                     case when (bitand(c.defer, 128) = 128
                                or o.status in (3, 5)) then 'INVALID'
                          else null end
                    ),
              null),
       decode(bitand(c.defer, 256), 256, 'DEPEND ON VIEW', null)
from sys.con$ oc, sys.con$ rc, sys.user$ ou, sys.user$ ru, sys.obj$ ro,
     sys.obj$ o, sys.cdef$ c, sys.obj$ oi, sys.user$ ui
where oc.owner# = ou.user#
  and oc.con# = c.con#
  and c.obj# = o.obj#
  and c.type# != 8
  and c.type# != 12       /* don't include log groups */
  and c.rcon# = rc.con#(+)
  and c.enabled = oi.obj#(+)
  and oi.obj# = ui.user#(+)
  and rc.owner# = ru.user#(+)
  and c.robj# = ro.obj#(+)
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in (select obj#
                     from sys.objauth$
                     where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                    )
        or /* user has system privileges */
          exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                  )
      );

CREATE OR REPLACE FORCE VIEW "ALL_CONS_COLUMNS"("OWNER",
select u.name, c.name, o.name,
       decode(ac.name, null, col.name, ac.name), cc.pos#
from sys.user$ u, sys.con$ c, sys.col$ col, sys.ccol$ cc, sys.cdef$ cd,
     sys.obj$ o, sys.attrcol$ ac
where c.owner# = u.user#
  and c.con# = cd.con#
  and cd.type# != 12       /* don't include log groups */
  and cd.con# = cc.con#
  and cc.obj# = col.obj#
  and cc.intcol# = col.intcol#
  and cc.obj# = o.obj#
  and (c.owner# = userenv('SCHEMAID')
       or cd.obj# in (select obj#
                      from sys.objauth$
                      where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                     )
        or /* user has system privileges */
          exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                  )
      )
  and col.obj# = ac.obj#(+)
  and col.intcol# = ac.intcol#(+);

CREATE OR REPLACE FORCE VIEW "ALL_CONS_OBJ_COLUMNS"("OWNER",
select uc.name, oc.name, c.name, ut.name, ot.name,
       lpad(decode(bitand(sc.flags, 2), 2, 'Y', 'N'), 15)
from sys.user$ uc, sys.obj$ oc, sys.col$ c, sys.user$ ut, sys.obj$ ot,
     sys.subcoltype$ sc
where oc.owner# = uc.user#
  and bitand(sc.flags, 1) = 1      /* Type is specified in the IS OF clause */
  and oc.obj#=sc.obj#
  and oc.obj#=c.obj#
  and c.intcol#=sc.intcol#
  and sc.toid=ot.oid$
  and ot.owner#=ut.user#
  and bitand(c.property,32768) != 32768                /* not unused column */
  and not exists (select null                  /* Doesn't exist in attrcol$ */
                  from sys.attrcol$ ac
                  where ac.intcol#=sc.intcol#
                        and ac.obj#=sc.obj#)
  and (oc.owner# = userenv('SCHEMAID')
       or oc.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
union all
select uc.name, oc.name, ac.name, ut.name, ot.name,
       lpad(decode(bitand(sc.flags, 2), 2, 'Y', 'N'), 15)
from sys.user$ uc, sys.obj$ oc, sys.col$ c, sys.user$ ut, sys.obj$ ot,
     sys.subcoltype$ sc, sys.attrcol$ ac
where oc.owner# = uc.user#
  and bitand(sc.flags, 1) = 1      /* Type is specified in the IS OF clause */
  and oc.obj#=sc.obj#
  and oc.obj#=c.obj#
  and oc.obj#=ac.obj#
  and c.intcol#=sc.intcol#
  and ac.intcol#=sc.intcol#
  and sc.toid=ot.oid$
  and ot.owner#=ut.user#
  and bitand(c.property,32768) != 32768                /* not unused column */
  and (oc.owner# = userenv('SCHEMAID')
       or oc.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_CONTEXT"("NAMESPACE",
select o.name, c.schema, c.package
from  context$ c, obj$ o
where exists ( select null
               from v$context  v
               where v.namespace = o.name
               and o.obj# = c.obj#
               and o.type# = 44
             );

CREATE OR REPLACE FORCE VIEW "ALL_DB_LINKS"("OWNER",
select u.name, l.name, l.userid, l.host, l.ctime
from sys.link$ l, sys.user$ u
where l.owner# in ( select kzsrorol from x$kzsro )
  and l.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "ALL_DEF_AUDIT_OPTS"("ALT",
select substr(t.audit$, 1, 1) || '/' || substr(t.audit$, 2, 1),
       substr(t.audit$, 3, 1) || '/' || substr(t.audit$, 4, 1),
       substr(t.audit$, 5, 1) || '/' || substr(t.audit$, 6, 1),
       substr(t.audit$, 7, 1) || '/' || substr(t.audit$, 8, 1),
       substr(t.audit$, 9, 1) || '/' || substr(t.audit$, 10, 1),
       substr(t.audit$, 11, 1) || '/' || substr(t.audit$, 12, 1),
       substr(t.audit$, 13, 1) || '/' || substr(t.audit$, 14, 1),
       substr(t.audit$, 15, 1) || '/' || substr(t.audit$, 16, 1),
       substr(t.audit$, 17, 1) || '/' || substr(t.audit$, 18, 1),
       substr(t.audit$, 19, 1) || '/' || substr(t.audit$, 20, 1),
       substr(t.audit$, 21, 1) || '/' || substr(t.audit$, 22, 1),
       '-/-',                                            /* dummy REF column */
       substr(t.audit$, 25, 1) || '/' || substr(t.audit$, 26, 1),
       substr(t.audit$, 23, 1) || '/' || substr(t.audit$, 24, 1)
from sys.obj$ o, sys.tab$ t
where o.obj# = t.obj#
  and o.owner# = 0
  and o.name = '_default_auditing_options_';

CREATE OR REPLACE FORCE VIEW "ALL_DEPENDENCIES"("OWNER",
select u.name, o.name,
       decode(o.type#, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 7, 'PROCEDURE',
                      8, 'FUNCTION', 9, 'PACKAGE', 10, 'NON-EXISTENT',
                      11, 'PACKAGE BODY', 12, 'TRIGGER',
                      13, 'TYPE', 14, 'TYPE BODY', 22, 'LIBRARY',
                      28, 'JAVA SOURCE', 29, 'JAVA CLASS',
                      32, 'INDEXTYPE', 33, 'OPERATOR',
                      42, 'MATERIALIZED VIEW', 43, 'DIMENSION',
                      46, 'RULE SET', 55, 'XML SCHEMA', 56, 'JAVA DATA',
                      59, 'RULE', 62, 'EVALUATION CONTXT',
                      'UNDEFINED'),
       decode(po.linkname, null, pu.name, po.remoteowner), po.name,
       decode(po.type#, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 7, 'PROCEDURE',
                      8, 'FUNCTION', 9, 'PACKAGE', 10, 'NON-EXISTENT',
                      11, 'PACKAGE BODY', 12, 'TRIGGER',
                      13, 'TYPE', 14, 'TYPE BODY', 22, 'LIBRARY',
                      28, 'JAVA SOURCE', 29, 'JAVA CLASS',
                      32, 'INDEXTYPE', 33, 'OPERATOR',
                      42, 'MATERIALIZED VIEW', 43, 'DIMENSION',
                      46, 'RULE SET', 55, 'XML SCHEMA', 56, 'JAVA DATA',
                      59, 'RULE', 62, 'EVALUATION CONTXT',
                      'UNDEFINED'),
       po.linkname,
       decode(bitand(d.property, 3), 2, 'REF', 'HARD')
from sys.obj$ o, sys.disk_and_fixed_objects po, sys.dependency$ d, sys.user$ u,
  sys.user$ pu
where o.obj# = d.d_obj#
  and o.owner# = u.user#
  and po.obj# = d.p_obj#
  and po.owner# = pu.user#
  and
  (
    o.owner# in (userenv('SCHEMAID'), 1 /* PUBLIC */)
    or
    (
      (
         (
          (o.type# = 7 or o.type# = 8 or o.type# = 9 or
           o.type# = 28 or o.type# = 29 or o.type# = 56)
          and
          o.obj# in (select obj# from sys.objauth$
                     where grantee# in (select kzsrorol from x$kzsro)
                       and privilege#  = 12 /* EXECUTE */)
        )
        or
        (
          o.type# = 4
          and
          o.obj# in (select obj# from sys.objauth$
                     where grantee# in (select kzsrorol from x$kzsro)
                       and privilege# in (3 /* DELETE */,   6 /* INSERT */,
                                                7 /* LOCK */,     9 /* SELECT */,
                                          10 /* UPDATE */))
        )
        or
        exists
        (
          select null from sys.sysauth$
          where grantee# in (select kzsrorol from x$kzsro)
          and
          (
            (
              /* procedure */
              (o.type# = 7 or o.type# = 8 or o.type# = 9 or
               o.type# = 28 or o.type# = 29 or o.type# = 56)
              and
              (
                privilege# = -144 /* EXECUTE ANY PROCEDURE */
                or
                privilege# = -141 /* CREATE ANY PROCEDURE */
              )
            )
            or
            (
              /* trigger */
              o.type# = 12 and
              privilege# = -152 /* CREATE ANY TRIGGER */
            )
            or
            (
              /* package body */
              o.type# = 11 and
              privilege# = -141 /* CREATE ANY PROCEDURE */
            )
            or
            (
              /* view */
              o.type# = 4
              and
              (
                privilege# in     ( -91 /* CREATE ANY VIEW */,
                                    -45 /* LOCK ANY TABLE */,
                                    -47 /* SELECT ANY TABLE */,
                                    -48 /* INSERT ANY TABLE */,
                                    -49 /* UPDATE ANY TABLE */,
                                    -50 /* DELETE ANY TABLE */)
              )
            )
            or
            (
              /* type */
              o.type# = 13
              and
              (
                privilege# = -184 /* EXECUTE ANY TYPE */
                or
                privilege# = -181 /* CREATE ANY TYPE */
              )
            )
            or
            (
              /* type body */
              o.type# = 14 and
              privilege# = -181 /* CREATE ANY TYPE */
            )
          )
        )
      )
    )
    /* don't worry about tables, sequences, synonyms since they cannot */
    /* depend on anything */
  );

CREATE OR REPLACE FORCE VIEW "ALL_DIMENSIONS"("OWNER",
select u.name, o.name,
       decode(o.status, 5, 'Y', 'N'),
       decode(o.status, 1, 'VALID', 5, 'NEEDS_COMPILE', 'ERROR'),
       1                  /* Metadata revision number */
from sys.dim$ d, sys.obj$ o, sys.user$ u
where o.owner# = u.user#
  and o.obj# = d.obj#
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-215 /* CREATE ANY DIMENSION */,
                                       -216 /* ALTER ANY DIMENSION */,
                                       -217 /* DROP ANY DIMENSION */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_DIM_ATTRIBUTES"("OWNER",
select u.name, o.name, da.attname, dl.levelname, c.name, 'N'
from sys.dimattr$ da, sys.obj$ o, sys.user$ u, sys.dimlevel$ dl, sys.col$ c
where da.dimobj# = o.obj#
  and o.owner# = u.user#
  and da.dimobj# = dl.dimobj#
  and da.levelid# = dl.levelid#
  and da.detailobj# = c.obj#
  and da.col# = c.intcol#
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-215 /* CREATE ANY DIMENSION */,
                                       -216 /* ALTER ANY DIMENSION */,
                                       -217 /* DROP ANY DIMENSION */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_DIM_CHILD_OF"("OWNER",
select u.name, o.name, h.hiername, chl.pos#,
       cdl.levelname,
       decode(phl.joinkeyid#, 0, NULL, phl.joinkeyid#),
       pdl.levelname
from sys.obj$ o, sys.user$ u, sys.hier$ h,
     sys.hierlevel$ phl, sys.hierlevel$ chl,
     sys.dimlevel$ pdl,  sys.dimlevel$ cdl
where phl.dimobj# = o.obj#
  and o.owner# = u.user#
  and phl.dimobj# = h.dimobj#
  and phl.hierid# = h.hierid#
  and phl.dimobj# = pdl.dimobj#
  and phl.levelid# = pdl.levelid#
  and phl.dimobj# = chl.dimobj#
  and phl.hierid# = chl.hierid#
  and phl.pos# = chl.pos# + 1
  and chl.dimobj# = cdl.dimobj#
  and chl.levelid# = cdl.levelid#
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-215 /* CREATE ANY DIMENSION */,
                                       -216 /* ALTER ANY DIMENSION */,
                                       -217 /* DROP ANY DIMENSION */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_DIM_HIERARCHIES"("OWNER",
select u.name, o.name, h.hiername
from sys.hier$ h, sys.obj$ o, sys.user$ u
where h.dimobj# = o.obj#
  and o.owner# = u.user#
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-215 /* CREATE ANY DIMENSION */,
                                       -216 /* ALTER ANY DIMENSION */,
                                       -217 /* DROP ANY DIMENSION */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_DIM_JOIN_KEY"("OWNER",
select u.name, o.name, djk.joinkeyid#, dl.levelname,
       djk.keypos#, h.hiername, c.name
from sys.dimjoinkey$ djk, sys.obj$ o, sys.user$ u,
     sys.dimlevel$ dl, sys.hier$ h, sys.col$ c
where djk.dimobj# = o.obj#
  and o.owner# = u.user#
  and djk.dimobj# = dl.dimobj#
  and djk.levelid# = dl.levelid#
  and djk.dimobj# = h.dimobj#
  and djk.hierid# = h.hierid#
  and djk.detailobj# = c.obj#
  and djk.col# = c.intcol#
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-215 /* CREATE ANY DIMENSION */,
                                       -216 /* ALTER ANY DIMENSION */,
                                       -217 /* DROP ANY DIMENSION */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_DIM_LEVELS"("OWNER",
select u.name, o.name, dl.levelname,
       temp.num_col,
       u1.name, o1.name
from (select dlk.dimobj#, dlk.levelid#, dlk.detailobj#,
             COUNT(*) as num_col
      from sys.dimlevelkey$ dlk
      group by dlk.dimobj#, dlk.levelid#, dlk.detailobj#) temp,
      sys.dimlevel$ dl, sys.obj$ o, sys.user$ u,
      sys.obj$ o1, sys.user$ u1
where dl.dimobj# = o.obj#   and
      o.owner# = u.user#    and
      dl.dimobj# = temp.dimobj# and
      dl.levelid# = temp.levelid# and
      temp.detailobj# = o1.obj# and
      o1.owner# = u1.user# and
      (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-215 /* CREATE ANY DIMENSION */,
                                       -216 /* ALTER ANY DIMENSION */,
                                       -217 /* DROP ANY DIMENSION */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_DIM_LEVEL_KEY"("OWNER",
select u.name, o.name, dl.levelname, dlk.keypos#, c.name
from sys.dimlevelkey$ dlk, sys.obj$ o, sys.user$ u, sys.dimlevel$ dl,
     sys.col$ c
where dlk.dimobj# = o.obj#
  and o.owner# = u.user#
  and dlk.dimobj# = dl.dimobj#
  and dlk.levelid# = dl.levelid#
  and dlk.detailobj# = c.obj#
  and dlk.col# = c.intcol#
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-215 /* CREATE ANY DIMENSION */,
                                       -216 /* ALTER ANY DIMENSION */,
                                       -217 /* DROP ANY DIMENSION */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_DIRECTORIES"("OWNER",
select u.name, o.name, d.os_path
from sys.user$ u, sys.obj$ o, sys.dir$ d
where u.user# = o.owner#
  and o.obj# = d.obj#
  and ( o.owner# =  userenv('SCHEMAID')
        or o.obj# in
           (select oa.obj#
            from sys.objauth$ oa
            where grantee# in (select kzsrorol
                               from x$kzsro
                              )
           )
        or exists (select null from v$enabledprivs
                   where priv_number in (-177, /* CREATE ANY DIRECTORY */
                                         -178  /* DROP ANY DIRECTORY */)
                  )
      );

CREATE OR REPLACE FORCE VIEW "ALL_ERRORS"("OWNER",
select u.name, o.name,
decode(o.type#, 4, 'VIEW', 7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE',
               11, 'PACKAGE BODY', 12, 'TRIGGER', 13, 'TYPE', 14, 'TYPE BODY',
               22, 'LIBRARY', 28, 'JAVA SOURCE', 29, 'JAVA CLASS',
               43, 'DIMENSION', 'UNDEFINED'),
  e.sequence#, e.line, e.position#, e.text,
   decode(e.property, 0,'ERROR', 1, 'WARNING', 'UNDEFINED'), e.error#
from sys.obj$ o, sys.error$ e, sys.user$ u
where o.obj# = e.obj#
  and o.owner# = u.user#
  and o.type# in (4, 7, 8, 9, 11, 12, 13, 14, 22, 28, 29, 43)
  and
  (
    o.owner# in (userenv('SCHEMAID'), 1 /* PUBLIC */)
    or
    (
      (
        (
          (o.type# = 7 or o.type# = 8 or o.type# = 9 or o.type# = 13 or
           o.type# = 28 or o.type# = 29)
          and
          o.obj# in (select obj# from sys.objauth$
                     where grantee# in (select kzsrorol from x$kzsro)
                       and privilege#  = 12 /* EXECUTE */)
        )
        or
        (
          o.type# = 4
          and
          o.obj# in (select obj# from sys.objauth$
                     where grantee# in (select kzsrorol from x$kzsro)
                       and privilege# in (3 /* DELETE */,   6 /* INSERT */,
                                          7 /* LOCK */,     9 /* SELECT */,
                                          10 /* UPDATE */))
        )
        or
        exists
        (
          select null from sys.sysauth$
          where grantee# in (select kzsrorol from x$kzsro)
          and
          (
            (
              /* procedure */
              (o.type# = 7 or o.type# = 8 or o.type# = 9 or
               o.type# = 28 or o.type# = 29)
              and
              (
                privilege# = -144 /* EXECUTE ANY PROCEDURE */
                or
                privilege# = -141 /* CREATE ANY PROCEDURE */
              )
            )
            or
            (
              /* trigger */
              o.type# = 12 and
              privilege# = -152 /* CREATE ANY TRIGGER */
            )
            or
            (
              /* package body */
              o.type# = 11 and
              privilege# = -141 /* CREATE ANY PROCEDURE */
            )
            or
            (
              /* dimension */
              o.type# = 11 and
              privilege# = -215 /* CREATE ANY DIMENSION */
            )
            or
            (
              /* view */
              o.type# = 4
              and
              (
                privilege# in     ( -91 /* CREATE ANY VIEW */,
                                    -45 /* LOCK ANY TABLE */,
                                    -47 /* SELECT ANY TABLE */,
                                    -48 /* INSERT ANY TABLE */,
                                    -49 /* UPDATE ANY TABLE */,
                                    -50 /* DELETE ANY TABLE */)
              )
            )
            or
            (
              /* type */
              o.type# = 13
              and
              (
                privilege# = -184 /* EXECUTE ANY TYPE */
                or
                privilege# = -181 /* CREATE ANY TYPE */
              )
            )
            or
            (
              /* type body */
              o.type# = 14 and
              privilege# = -181 /* CREATE ANY TYPE */
            )
          )
        )
      )
    )
  );

CREATE OR REPLACE FORCE VIEW "ALL_EVALUATION_CONTEXTS"("EVALUATION_CONTEXT_OWNER",
SELECT /*+ all_rows */
       u.name, o.name, ec.eval_func, ec.ec_comment
FROM   rule_ec$ ec, obj$ o, user$ u
WHERE  ec.obj# = o.obj# and
       (o.owner# in (USERENV('SCHEMAID'), 1 /* PUBLIC */) or
        o.obj# in (select oa.obj# from sys.objauth$ oa
                   where grantee# in (select kzsrorol from x$kzsro)) or
        exists (select null from v$enabledprivs where priv_number in (
                 -246, /* create any evaluation context */
                 -247, /* alter any evaluation context */
                 -248, /* drop any evaluation context */
                 -249  /* execute any evaluation context */))) and
       o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "ALL_EVALUATION_CONTEXT_TABLES"("EVALUATION_CONTEXT_OWNER",
SELECT /*+ all_rows */
       u.name, o.name, ect.tab_alias, ect.tab_name
FROM   rec_tab$ ect, obj$ o, user$ u
WHERE  ect.ec_obj# = o.obj# and
       (o.owner# in (USERENV('SCHEMAID'), 1 /* PUBLIC */) or
        o.obj# in (select oa.obj# from sys.objauth$ oa
                   where grantee# in (select kzsrorol from x$kzsro)) or
        exists (select null from v$enabledprivs where priv_number in (
                 -246, /* create any evaluation context */
                 -247, /* alter any evaluation context */
                 -248, /* drop any evaluation context */
                 -249  /* execute any evaluation context */))) and
       o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "ALL_EVALUATION_CONTEXT_VARS"("EVALUATION_CONTEXT_OWNER",
SELECT /*+ all_rows */
       u.name, o.name, ecv.var_name, ecv.var_type, ecv.var_val_func,
       ecv.var_mthd_func
FROM   rec_var$ ecv, obj$ o, user$ u
WHERE  ecv.ec_obj# = o.obj# and
       (o.owner# in (USERENV('SCHEMAID'), 1 /* PUBLIC */) or
        o.obj# in (select oa.obj# from sys.objauth$ oa
                   where grantee# in (select kzsrorol from x$kzsro)) or
        exists (select null from v$enabledprivs where priv_number in (
                 -246, /* create any evaluation context */
                 -247, /* alter any evaluation context */
                 -248, /* drop any evaluation context */
                 -249  /* execute any evaluation context */))) and
       o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "ALL_EXTERNAL_LOCATIONS"("OWNER",
select u.name, o.name, xl.name, 'SYS', nvl(xl.dir, xt.default_dir)
from sys.external_location$ xl, sys.user$ u, sys.obj$ o, sys.external_tab$ xt
where o.owner# = u.user#
  and o.obj#   = xl.obj#
  and o.obj#   = xt.obj#
  and ( o.owner# = userenv('SCHEMAID')
        or o.obj# in
        ( select oa.obj# from sys.objauth$ oa
          where grantee# in (select kzsrorol from x$kzsro)
        )
        or    /* user has system privileges */
          exists ( select null from v$enabledprivs
                   where priv_number in (-45 /* LOCK ANY TABLE */,
                                         -47 /* SELECT ANY TABLE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_EXTERNAL_TABLES"("OWNER",
select u.name, o.name, 'SYS', xt.type$, 'SYS', xt.default_dir,
       decode(xt.reject_limit, 2147483647, 'UNLIMITED', xt.reject_limit),
       decode(xt.par_type, 1, 'BLOB', 2, 'CLOB',       'UNKNOWN'),
       decode(xt.par_type, 1, NULL,   2, xt.param_clob, NULL),
       decode(xt.property, 2, 'REFERENCED', 1, 'ALL',     'UNKNOWN')
from sys.external_tab$ xt, sys.obj$ o, sys.user$ u
where o.owner# = u.user#
  and o.obj#   = xt.obj#
  and ( o.owner# = userenv('SCHEMAID')
        or o.obj# in
            ( select oa.obj# from sys.objauth$ oa
              where grantee# in (select kzsrorol from x$kzsro)
            )
        or    /* user has system privileges */
          exists ( select null from v$enabledprivs
                   where priv_number in (-45 /* LOCK ANY TABLE */,
                                         -47 /* SELECT ANY TABLE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_INDEXES"("OWNER",
select u.name, o.name,
       decode(bitand(i.property, 16), 0, '', 'FUNCTION-BASED ') ||
        decode(i.type#, 1, 'NORMAL'||
                          decode(bitand(i.property, 4), 0, '', 4, '/REV'),
                      2, 'BITMAP', 3, 'CLUSTER', 4, 'IOT - TOP',
                      5, 'IOT - NESTED', 6, 'SECONDARY', 7, 'ANSI', 8, 'LOB',
                      9, 'DOMAIN'),
       iu.name, io.name, 'TABLE',
       decode(bitand(i.property, 1), 0, 'NONUNIQUE', 1, 'UNIQUE', 'UNDEFINED'),
       decode(bitand(i.flags, 32), 0, 'DISABLED', 32, 'ENABLED', null),
       i.spare2,
       decode(bitand(i.property, 34), 0,
           decode(i.type#, 9, null, ts.name), null),
       decode(bitand(i.property, 2),0, i.initrans, null),
       decode(bitand(i.property, 2),0, i.maxtrans, null),
       s.iniexts * ts.blocksize,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
                             s.extsize * ts.blocksize),
       s.minexts, s.maxexts,
        decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                     s.extpct),
       decode(i.type#, 4, mod(i.pctthres$,256), NULL), i.trunccnt,
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
         decode(bitand(o.flags, 2), 2, 1, decode(s.lists, 0, 1, s.lists))),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
         decode(bitand(o.flags, 2), 2, 1, decode(s.groups, 0, 1, s.groups))),
       decode(bitand(i.property, 2),0,i.pctfree$,null),
       decode(bitand(i.property, 2), 2, NULL,
                decode(bitand(i.flags, 4), 0, 'YES', 'NO')),
       i.blevel, i.leafcnt, i.distkey, i.lblkkey, i.dblkkey, i.clufac,
       decode(bitand(i.property, 2), 2,
                   decode(i.type#, 9, decode(bitand(i.flags, 8),
                                        8, 'INPROGRS', 'VALID'), 'N/A'),
                     decode(bitand(i.flags, 1), 1, 'UNUSABLE',
                            decode(bitand(i.flags, 8), 8, 'INRPOGRS',
                                                            'VALID'))),
       rowcnt, samplesize, analyzetime,
       decode(i.degree, 32767, 'DEFAULT', nvl(i.degree,1)),
       decode(i.instances, 32767, 'DEFAULT', nvl(i.instances,1)),
       decode(bitand(i.property, 2), 2, 'YES', 'NO'),
       decode(bitand(o.flags, 2), 0, 'N', 2, 'Y', 'N'),
       decode(bitand(o.flags, 4), 0, 'N', 4, 'Y', 'N'),
       decode(bitand(o.flags, 16), 0, 'N', 16, 'Y', 'N'),
       decode(bitand(o.flags, 2), 2, 'DEFAULT',
             decode(s.cachehint, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL)),
       decode(bitand(i.flags, 64), 0, 'NO', 'YES'),
       decode(bitand(o.flags, 2), 0, NULL,
           decode(bitand(i.property, 64), 64, 'SYS$SESSION', 'SYS$TRANSACTION')),
       decode(bitand(i.flags, 128), 128, mod(trunc(i.pctthres$/256),256),
              decode(i.type#, 4, mod(trunc(i.pctthres$/256),256), NULL)),
       itu.name, ito.name, i.spare4,
       decode(bitand(i.flags, 2048), 0, 'NO', 'YES'),
       decode(i.type#, 9, decode(o.status, 5, 'IDXTYP_INVLD',
                                           1, 'VALID'),  ''),
       decode(i.type#, 9, decode(bitand(i.flags, 16), 16, 'FAILED', 'VALID'), ''),
       decode(bitand(i.property, 16), 0, '',
              decode(bitand(i.flags, 1024), 0, 'ENABLED', 'DISABLED')),
       decode(bitand(i.property, 1024), 1024, 'YES', 'NO'),
       decode(bitand(i.property, 16384), 16384, 'YES', 'NO'),
       decode(bitand(o.flags, 128), 128, 'YES', 'NO')
from sys.ts$ ts, sys.seg$ s, sys.user$ iu, sys.obj$ io,
     sys.user$ u, sys.ind$ i, sys.obj$ o, sys.user$ itu, sys.obj$ ito
where u.user# = o.owner#
  and o.obj# = i.obj#
  and i.bo# = io.obj#
  and io.owner# = iu.user#
  and io.type# = 2 /* tables */
  and bitand(i.flags, 4096) = 0
  and bitand(o.flags, 128) = 0
  and i.ts# = ts.ts# (+)
  and i.file# = s.file# (+)
  and i.block# = s.block# (+)
  and i.ts# = s.ts# (+)
  and i.type# in (1, 2, 3, 4, 6, 7, 9)
  and i.indmethod# = ito.obj# (+)
  and ito.owner# = itu.user# (+)
  and (io.owner# = userenv('SCHEMAID')
        or
       io.obj# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                        from x$kzsro
                                      )
                   )
        or
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
       );

CREATE OR REPLACE FORCE VIEW "ALL_INDEXTYPES"("OWNER",
select u.name, o.name, u1.name, o1.name, i.interface_version#, t.version#,
io.opcount, decode(bitand(i.property, 48), 0, 'NONE', 16, 'RANGE', 32, 'HASH', 48, 'HASH,RANGE'),
decode(bitand(i.property, 2), 0, 'NO', 2, 'YES')
from sys.indtypes$ i, sys.user$ u, sys.obj$ o,
sys.user$ u1, (select it.obj#, count(*) opcount from
sys.indop$ io1, sys.indtypes$ it where
io1.obj# = it.obj# and bitand(io1.property, 4) != 4
group by it.obj#) io, sys.obj$ o1,
sys.type$ t
where i.obj# = o.obj# and o.owner# = u.user# and
u1.user# = o.owner# and io.obj# = i.obj# and
o1.obj# = i.implobj# and o1.oid$ = t.toid and
( o.owner# = userenv ('SCHEMAID')
    or
    o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or exists (select null from v$enabledprivs
                  where priv_number in (-205 /* CREATE INDEXTYPE */,
                                        -206 /* CREATE ANY INDEXTYPE */,
                                        -207 /* ALTER ANY INDEXTYPE */,
                                        -208 /* DROP ANY INDEXTYPE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_INDEXTYPE_ARRAYTYPES"("OWNER",
select indtypu.name, indtypo.name,
decode(i.type, 121, (select baseu.name from user$ baseu
       where baseo.owner#=baseu.user#), null),
decode(i.type, 121, baseo.name, null),
decode(i.type,  /* DATA_TYPE */
0, null,
1, 'VARCHAR2',
2, 'NUMBER',
3, 'NATIVE INTEGER',
8, 'LONG',
9, 'VARCHAR',
11, 'ROWID',
12, 'DATE',
23, 'RAW',
24, 'LONG RAW',
29, 'BINARY_INTEGER',
69, 'ROWID',
96, 'CHAR',
100, 'BINARY_FLOAT',
101, 'BINARY_DOUBLE',
102, 'REF CURSOR',
104, 'UROWID',
105, 'MLSLABEL',
106, 'MLSLABEL',
110, 'REF',
111, 'REF',
112, 'CLOB',
113, 'BLOB', 114, 'BFILE', 115, 'CFILE',
121, 'OBJECT',
122, 'TABLE',
123, 'VARRAY',
178, 'TIME',
179, 'TIME WITH TIME ZONE',
180, 'TIMESTAMP',
181, 'TIMESTAMP WITH TIME ZONE',
231, 'TIMESTAMP WITH LOCAL TIME ZONE',
182, 'INTERVAL YEAR TO MONTH',
183, 'INTERVAL DAY TO SECOND',
250, 'PL/SQL RECORD',
251, 'PL/SQL TABLE',
252, 'PL/SQL BOOLEAN',
'UNDEFINED'),
arrayu.name, arrayo.name
from sys.user$ indtypu, sys.indarraytype$ i, sys.obj$ indtypo,
sys.obj$ baseo, sys.obj$ arrayo, sys.user$ arrayu
where i.obj# = indtypo.obj# and  indtypu.user# = indtypo.owner# and
      i.basetypeobj# = baseo.obj#(+) and i.arraytypeobj# = arrayo.obj# and
      arrayu.user# = arrayo.owner# and
      ( indtypo.owner# = userenv ('SCHEMAID')
        or
        indtypo.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
        or exists (select null from v$enabledprivs
                   where priv_number in (-205 /* CREATE INDEXTYPE */,
                                        -206 /* CREATE ANY INDEXTYPE */,
                                        -207 /* ALTER ANY INDEXTYPE */,
                                        -208 /* DROP ANY INDEXTYPE */)
                  )
      );

CREATE OR REPLACE FORCE VIEW "ALL_INDEXTYPE_COMMENTS"("OWNER",
select  u.name, o.name, c.comment$
from    sys.obj$ o, sys.user$ u, sys.indtypes$ i, sys.com$ c
where   o.obj# = i.obj# and u.user# = o.owner# and c.obj# = i.obj# and
( o.owner# = userenv ('SCHEMAID')
    or
    o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or exists (select null from v$enabledprivs
                  where priv_number in (-205 /* CREATE INDEXTYPE */,
                                        -206 /* CREATE ANY INDEXTYPE */,
                                        -207 /* ALTER ANY INDEXTYPE */,
                                        -208 /* DROP ANY INDEXTYPE */)
                 )
 );

CREATE OR REPLACE FORCE VIEW "ALL_INDEXTYPE_OPERATORS"("OWNER",
select u.name, o.name, u1.name, op.name, i.bind#
from sys.user$ u, sys.indop$ i, sys.obj$ o,
sys.obj$ op, sys.user$ u1
where i.obj# = o.obj# and i.oper# = op.obj# and
      u.user# = o.owner# and bitand(i.property, 4) != 4 and u1.user#=op.owner# and
      ( o.owner# = userenv ('SCHEMAID')
      or
      o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or exists (select null from v$enabledprivs
                  where priv_number in (-205 /* CREATE INDEXTYPE */,
                                        -206 /* CREATE ANY INDEXTYPE */,
                                        -207 /* ALTER ANY INDEXTYPE */,
                                        -208 /* DROP ANY INDEXTYPE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_IND_COLUMNS"("INDEX_OWNER",
select io.name, idx.name, bo.name, base.name,
       decode(bitand(c.property, 1024), 1024,
              (select decode(bitand(tc.property, 1), 1, ac.name, tc.name)
              from sys.col$ tc, attrcol$ ac
              where tc.intcol# = c.intcol#-1
                and tc.obj# = c.obj#
                and tc.obj# = ac.obj#(+)
                and tc.intcol# = ac.intcol#(+)),
              decode(ac.name, null, c.name, ac.name)),
       ic.pos#, c.length, c.spare3,
       decode(bitand(c.property, 131072), 131072, 'DESC', 'ASC')
from sys.col$ c, sys.obj$ idx, sys.obj$ base, sys.icol$ ic,
     sys.user$ io, sys.user$ bo, sys.ind$ i, sys.attrcol$ ac
where ic.bo# = c.obj#
  and decode(bitand(i.property,1024),0,ic.intcol#,ic.spare2) = c.intcol#
  and ic.bo# = base.obj#
  and io.user# = idx.owner#
  and bo.user# = base.owner#
  and ic.obj# = idx.obj#
  and idx.obj# = i.obj#
  and i.type# in (1, 2, 3, 4, 6, 7, 9)
  and c.obj# = ac.obj#(+)
  and c.intcol# = ac.intcol#(+)
  and (idx.owner# = userenv('SCHEMAID') or
       base.owner# = userenv('SCHEMAID')
       or
       base.obj# in ( select obj#
                     from sys.objauth$
                     where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                   )
        or
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
       );

CREATE OR REPLACE FORCE VIEW "ALL_IND_EXPRESSIONS"("INDEX_OWNER",
select io.name, idx.name, bo.name, base.name, c.default$, ic.pos#
from sys.col$ c, sys.obj$ idx, sys.obj$ base, sys.icol$ ic,
     sys.user$ io, sys.user$ bo, sys.ind$ i
where bitand(ic.spare1,1) = 1       /* an expression */
  and (bitand(i.property,1024) = 0) /* not bmji */
  and ic.bo# = c.obj#
  and ic.intcol# = c.intcol#
  and ic.bo# = base.obj#
  and io.user# = idx.owner#
  and bo.user# = base.owner#
  and ic.obj# = idx.obj#
  and idx.obj# = i.obj#
  and i.type# in (1, 2, 3, 4, 6, 7, 9)
  and (idx.owner# = userenv('SCHEMAID') or
       base.owner# = userenv('SCHEMAID')
       or
       base.obj# in ( select obj#
                     from sys.objauth$
                     where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                   )
        or
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
       );

CREATE OR REPLACE FORCE VIEW "ALL_IND_PARTITIONS"("INDEX_OWNER",
select u.name, io.name, 'NO', io.subname, 0,
       ip.hiboundval, ip.hiboundlen, ip.part#,
       decode(bitand(ip.flags, 1), 1, 'UNUSABLE', 'USABLE'),ts.name,
       ip.pctfree$, ip.initrans, ip.maxtrans, s.iniexts * ts.blocksize,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
                               s.extsize * ts.blocksize),
       s.minexts, s.maxexts,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                      s.extpct),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
          decode(s.lists, 0, 1, s.lists)),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
          decode(s.groups, 0, 1, s.groups)),
       decode(mod(trunc(ip.flags / 4), 2), 0, 'YES', 'NO'),
       decode(bitand(ip.flags, 1024), 0, 'DISABLED', 1024, 'ENABLED', null),
       ip.blevel, ip.leafcnt, ip.distkey, ip.lblkkey, ip.dblkkey,
       ip.clufac, ip.rowcnt, ip.samplesize, ip.analyzetime,
       decode(s.cachehint, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL),
       decode(bitand(ip.flags, 8), 0, 'NO', 'YES'), ip.pctthres$,
       decode(bitand(ip.flags, 16), 0, 'NO', 'YES'), '',''
from obj$ io, indpartv$ ip, ts$ ts, sys.seg$ s, ind$ i, sys.user$ u
where io.obj# = ip.obj# and ts.ts# = ip.ts# and ip.file#=s.file# and
      ip.block#=s.block# and ip.ts#=s.ts# and io.owner# = u.user# and
      i.obj# = ip.bo# and
      i.type# != 8 and      /* not LOB index */
        (io.owner# = userenv('SCHEMAID')
        or
        i.bo# in (select obj#
                    from objauth$
                    where grantee# in ( select kzsrorol
                                        from x$kzsro
                                      )
                   )
        or
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
       )
union all
select u.name, io.name, 'YES', io.subname, icp.subpartcnt,
       icp.hiboundval, icp.hiboundlen, icp.part#, 'N/A', ts.name,
       icp.defpctfree, icp.definitrans, icp.defmaxtrans,
       icp.definiexts, icp.defextsize, icp.defminexts, icp.defmaxexts,
       icp.defextpct, icp.deflists, icp.defgroups,
       decode(icp.deflogging, 0, 'NONE', 1, 'YES', 2, 'NO', 'UNKNOWN'),
       decode(bitand(icp.flags, 1024), 0, 'DISABLED', 1024, 'ENABLED', null),
       icp.blevel, icp.leafcnt, icp.distkey, icp.lblkkey, icp.dblkkey,
       icp.clufac, icp.rowcnt, icp.samplesize, icp.analyzetime,
       decode(icp.defbufpool, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL),
       decode(bitand(icp.flags, 8), 0, 'NO', 'YES'), TO_NUMBER(NULL),
       decode(bitand(icp.flags, 16), 0, 'NO', 'YES'), '',''
from   obj$ io, indcompartv$ icp, ts$ ts, ind$ i, user$ u
where  io.obj# = icp.obj# and icp.defts# = ts.ts# (+) and io.owner# = u.user# and
       i.obj# = icp.bo# and
       i.type# != 8 and      /* not LOB index */
       (io.owner# = userenv('SCHEMAID')
        or
        i.bo# in (select oa.obj#
                 from sys.objauth$ oa
                    where grantee# in ( select kzsrorol
                                        from x$kzsro
                                      )
                   )
        or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
union all
select u.name, io.name, 'NO', io.subname, 0,
       ip.hiboundval, ip.hiboundlen, ip.part#,
       decode(bitand(ip.flags, 1), 1, 'UNUSABLE',
               decode(bitand(ip.flags, 4096), 4096, 'INPROGRS', 'USABLE')),
       null, ip.pctfree$, ip.initrans, ip.maxtrans,
       0, 0, 0, 0, 0, 0, 0,
       decode(mod(trunc(ip.flags / 4), 2), 0, 'YES', 'NO'),
       decode(bitand(ip.flags, 1024), 0, 'DISABLED', 1024, 'ENABLED', null),
       ip.blevel, ip.leafcnt, ip.distkey, ip.lblkkey, ip.dblkkey,
       ip.clufac, ip.rowcnt, ip.samplesize, ip.analyzetime,
       'DEFAULT',
       decode(bitand(ip.flags, 8), 0, 'NO', 'YES'), ip.pctthres$,
       decode(bitand(ip.flags, 16), 0, 'NO', 'YES'),
       decode(i.type#,
             9, decode(bitand(ip.flags, 8192), 8192, 'FAILED', 'VALID'),
             ''),
       ipp.parameters
from obj$ io, indpartv$ ip, ind$ i, sys.user$ u, indpart_param$ ipp
where io.obj# = ip.obj# and io.owner# = u.user# and
      i.obj# = ip.bo# and ip.obj# = ipp.obj# and
        (io.owner# = userenv('SCHEMAID')
        or
        i.bo# in (select obj#
                    from objauth$
                    where grantee# in ( select kzsrorol
                                        from x$kzsro
                                      )
                   )
        or
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
       );

CREATE OR REPLACE FORCE VIEW "ALL_IND_STATISTICS"("OWNER",
SELECT
    u.name, o.name, NULL,NULL, NULL, NULL, 'INDEX',
    i.blevel, i.leafcnt, i.distkey, i.lblkkey, i.dblkkey, i.clufac, i.rowcnt,
    ins.cachedblk, ins.cachehit, i.samplesize, i.analyzetime,
    decode(bitand(i.flags, 2048), 0, 'NO', 'YES'),
    decode(bitand(i.flags, 64), 0, 'NO', 'YES')
  FROM
    sys.user$ u, sys.ind$ i, sys.obj$ o, sys.ind_stats$ ins
  WHERE
      u.user# = o.owner#
  and o.obj# = i.obj#
  and bitand(i.flags, 4096) = 0
  and i.type# in (1, 2, 3, 4, 6, 7, 8, 9)
  and i.obj# = ins.obj# (+)
  and (o.owner# = userenv('SCHEMAID')
        or
       o.obj# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                        from x$kzsro
                                      )
                   )
        or
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
       )
  UNION ALL
  SELECT
    u.name, io.name, io.subname, ip.part#, NULL, NULL, 'PARTITION',
    ip.blevel, ip.leafcnt, ip.distkey, ip.lblkkey, ip.dblkkey,
    ip.clufac, ip.rowcnt, ins.cachedblk, ins.cachehit,
    ip.samplesize, ip.analyzetime,
    decode(bitand(ip.flags, 16), 0, 'NO', 'YES'),
    decode(bitand(ip.flags, 8), 0, 'NO', 'YES')
  FROM
    sys.obj$ io, sys.indpartv$ ip, sys.ind$ i,
    sys.user$ u, sys.ind_stats$ ins
  WHERE
      io.obj# = ip.obj#
  and ip.file# > 0
  and ip.block# > 0
  and ip.bo# = i.obj#
  and io.owner# = u.user#
  and ip.obj# = ins.obj# (+)
  and (io.owner# = userenv('SCHEMAID')
        or
        i.bo# in (select obj#
                    from objauth$
                    where grantee# in ( select kzsrorol
                                        from x$kzsro
                                      )
                   )
        or
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
       )
  UNION ALL
  SELECT
    u.name, io.name, io.subname, icp.part#, NULL, NULL, 'PARTITION',
    icp.blevel, icp.leafcnt, icp.distkey, icp.lblkkey, icp.dblkkey,
    icp.clufac, icp.rowcnt, ins.cachedblk, ins.cachehit,
    icp.samplesize, icp.analyzetime,
    decode(bitand(icp.flags, 16), 0, 'NO', 'YES'),
    decode(bitand(icp.flags, 8), 0, 'NO', 'YES')
  FROM
    obj$ io, indcompartv$ icp, ind$ i, user$ u, sys.ind_stats$ ins
  WHERE
      io.obj# = icp.obj#
  and io.owner# = u.user#
  and icp.obj# = ins.obj# (+)
  and i.obj# = icp.bo#
  and (io.owner# = userenv('SCHEMAID')
        or
        i.bo# in (select oa.obj#
                  from sys.objauth$ oa
                    where grantee# in ( select kzsrorol
                                        from x$kzsro
                                      )
                   )
        or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
  UNION ALL
  SELECT
    u.name, io.name, io.subname, ip.part#, NULL, NULL, 'PARTITION',
    ip.blevel, ip.leafcnt, ip.distkey, ip.lblkkey, ip.dblkkey,
    ip.clufac, ip.rowcnt, ins.cachedblk, ins.cachehit,
    ip.samplesize, ip.analyzetime,
    decode(bitand(ip.flags, 16), 0, 'NO', 'YES'),
    decode(bitand(ip.flags, 8), 0, 'NO', 'YES')
  FROM
    obj$ io, indpartv$ ip, sys.user$ u, indpart_param$ ipp, sys.ind$ i,
    sys.ind_stats$ ins
  WHERE
      io.obj# = ip.obj#
  and io.owner# = u.user#
  and ip.obj# = ipp.obj#
  and ip.bo# = i.obj#
  and ip.obj# = ins.obj# (+)
  and (io.owner# = userenv('SCHEMAID')
        or
        i.bo# in (select obj#
                    from objauth$
                    where grantee# in ( select kzsrorol
                                        from x$kzsro
                                      )
                   )
        or
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
       )
  UNION ALL
  SELECT
    u.name, po.name, po.subname, icp.part#, so.subname, isp.subpart#,
    'SUBPARTITION',
    isp.blevel, isp.leafcnt, isp.distkey, isp.lblkkey, isp.dblkkey,
    isp.clufac, isp.rowcnt, ins.cachedblk, ins.cachehit,
    isp.samplesize, isp.analyzetime,
    decode(bitand(isp.flags, 16), 0, 'NO', 'YES'),
    decode(bitand(isp.flags, 8), 0, 'NO', 'YES')
  FROM
    obj$ so, sys.obj$ po, ind$ i, indcompartv$ icp, indsubpartv$ isp,
    user$ u,  sys.ind_stats$ ins
  WHERE
      so.obj# = isp.obj#
  and po.obj# = icp.obj#
  and icp.obj# = isp.pobj#
  and icp.bo# = i.obj#
  and isp.file# > 0
  and isp.block# > 0
  and u.user# = po.owner#
  and isp.obj# = ins.obj# (+)
  and (po.owner# = userenv('SCHEMAID')
        or i.bo# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
        or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_IND_SUBPARTITIONS"("INDEX_OWNER",
select u.name, po.name, po.subname, so.subname,
       isp.hiboundval, isp.hiboundlen, isp.subpart#,
       decode(bitand(isp.flags, 1), 1, 'UNUSABLE', 'USABLE'), ts.name,
       isp.pctfree$, isp.initrans, isp.maxtrans,
       s.iniexts * ts.blocksize,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                      s.extsize * ts.blocksize),
       s.minexts, s.maxexts,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                      s.extpct),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
          decode(s.lists, 0, 1, s.lists)),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
          decode(s.groups, 0, 1, s.groups)),
       decode(mod(trunc(isp.flags / 4), 2), 0, 'YES', 'NO'),
       decode(bitand(isp.flags, 1024), 0, 'DISABLED', 1024, 'ENABLED', null),
       isp.blevel, isp.leafcnt, isp.distkey, isp.lblkkey, isp.dblkkey,
       isp.clufac, isp.rowcnt, isp.samplesize, isp.analyzetime,
       decode(s.cachehint, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL),
       decode(bitand(isp.flags, 8), 0, 'NO', 'YES'),
       decode(bitand(isp.flags, 16), 0, 'NO', 'YES')
from   obj$ so, sys.obj$ po, ind$ i, indcompartv$ icp, indsubpartv$ isp,
       ts$ ts, seg$ s, user$ u
where  so.obj# = isp.obj# and po.obj# = icp.obj# and icp.obj# = isp.pobj# and
       i.obj# = icp.bo# and ts.ts# = isp.ts# and isp.file# = s.file# and
       isp.block# = s.block# and isp.ts# = s.ts# and u.user# = po.owner# and
       i.type# != 8 and      /* not LOB index */
       (po.owner# = userenv('SCHEMAID')
        or i.bo# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
        or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_INTERNAL_TRIGGERS"("TABLE_NAME",
select o.name, 'DEFERRED RPC QUEUE'
from sys.tab$ t, sys.obj$ o
where t.obj# = o.obj#
      and bitand(t.trigflag,1) = 1
      and (o.owner# = userenv('SCHEMAID')
           or o.obj# in
                (select oa.obj#
                 from sys.objauth$ oa
                 where grantee# in ( select kzsrorol
                                     from x$kzsro
                                   )
                )
           or /* user has system privileges */
             exists (select null from v$enabledprivs
                     where priv_number in (-45 /* LOCK ANY TABLE */,
                                               -47 /* SELECT ANY TABLE */,
                                           -48 /* INSERT ANY TABLE */,
                                           -49 /* UPDATE ANY TABLE */,
                                           -50 /* DELETE ANY TABLE */)
                     )
          )
union
select o.name, 'MVIEW LOG'
from sys.tab$ t, sys.obj$ o
where t.obj# = o.obj#
      and bitand(t.trigflag,2) = 2
      and (o.owner# = userenv('SCHEMAID')
           or o.obj# in
                (select oa.obj#
                 from sys.objauth$ oa
                 where grantee# in ( select kzsrorol
                                     from x$kzsro
                                   )
                )
           or /* user has system privileges */
             exists (select null from v$enabledprivs
                     where priv_number in (-45 /* LOCK ANY TABLE */,
                                               -47 /* SELECT ANY TABLE */,
                                           -48 /* INSERT ANY TABLE */,
                                           -49 /* UPDATE ANY TABLE */,
                                           -50 /* DELETE ANY TABLE */)
                     )
          )
union
select o.name, 'UPDATABLE MVIEW LOG'
from sys.tab$ t, sys.obj$ o
where t.obj# = o.obj#
      and bitand(t.trigflag,4) = 4
      and (o.owner# = userenv('SCHEMAID')
           or o.obj# in
                (select oa.obj#
                 from sys.objauth$ oa
                 where grantee# in ( select kzsrorol
                                     from x$kzsro
                                   )
                )
           or /* user has system privileges */
             exists (select null from v$enabledprivs
                     where priv_number in (-45 /* LOCK ANY TABLE */,
                                               -47 /* SELECT ANY TABLE */,
                                           -48 /* INSERT ANY TABLE */,
                                           -49 /* UPDATE ANY TABLE */,
                                           -50 /* DELETE ANY TABLE */)
                     )
          )
union
select o.name, 'CONTEXT'
from sys.tab$ t, sys.obj$ o
where t.obj# = o.obj#
      and bitand(t.trigflag,8) = 8
      and (o.owner# = userenv('SCHEMAID')
           or o.obj# in
                (select oa.obj#
                 from sys.objauth$ oa
                 where grantee# in ( select kzsrorol
                                     from x$kzsro
                                   )
                )
           or /* user has system privileges */
             exists (select null from v$enabledprivs
                     where priv_number in (-45 /* LOCK ANY TABLE */,
                                               -47 /* SELECT ANY TABLE */,
                                           -48 /* INSERT ANY TABLE */,
                                           -49 /* UPDATE ANY TABLE */,
                                           -50 /* DELETE ANY TABLE */)
                     )
          );

CREATE OR REPLACE FORCE VIEW "ALL_JAVA_ARGUMENTS"("OWNER",
select u.name, m.kln, m.mix, m.mnm, m.aix,
       m.aad,
       decode(m.abt, 10, 'int',
                     11, 'long',
                     6, 'float',
                     7, 'double',
                     4, 'boolean',
                     8, 'byte',
                     5, 'char',
                     9, 'short',
                     2, 'class',
                     NULL),
       m.aln
from sys.obj$ o, sys.x$joxfm m, sys.user$ u
where o.obj# = m.obn
  and o.type# = 29
  and o.owner# = u.user#
  and
  (
    o.owner# in (userenv('SCHEMAID'), 1 /* PUBLIC */)
    or
    (
      (
        (
          o.obj# in (select obj# from sys.objauth$
                     where grantee# in (select kzsrorol from x$kzsro)
                       and privilege#  = 12 /* EXECUTE */)
        )
        or
        exists
        (
          select null from sys.sysauth$
          where grantee# in (select kzsrorol from x$kzsro)
          and
          (
            (
              /* procedure */
              (
                privilege# = -144 /* EXECUTE ANY PROCEDURE */
                or
                privilege# = -141 /* CREATE ANY PROCEDURE */
              )
            )
          )
        )
      )
    )
  );

CREATE OR REPLACE FORCE VIEW "ALL_JAVA_CLASSES"("OWNER",
select u.name, m.kln, m.maj, m.min,
       decode(BITAND(m.acc, 512), 512, 'CLASS',
                                  0, 'INTERFACE'),
       decode(BITAND(m.acc, 1), 1, 'PUBLIC',
                                0, NULL),
       decode(BITAND(m.acc, 131072), 131072, 'YES',
                                     0, 'NO'),
       decode(BITAND(m.acc, 1024), 1024, 'YES',
                                   0, 'NO'),
       decode(BITAND(m.acc, 16), 16, 'YES',
                                 0, 'NO'),
       decode(m.dbg, 1, 'YES',
                     0, 'NO'),
       m.src, m.spl, m.oln
from sys.obj$ o, sys.x$joxfm m, sys.user$ u
where o.obj# = m.obn
  and o.type# = 29
  and o.owner# = u.user#
  and
  (
    o.owner# in (userenv('SCHEMAID'), 1 /* PUBLIC */)
    or
    (
      (
        (
          o.obj# in (select obj# from sys.objauth$
                     where grantee# in (select kzsrorol from x$kzsro)
                       and privilege#  = 12 /* EXECUTE */)
        )
        or
        exists
        (
          select null from sys.sysauth$
          where grantee# in (select kzsrorol from x$kzsro)
          and
          (
            (
              /* procedure */
              (
                privilege# = -144 /* EXECUTE ANY PROCEDURE */
                or
                privilege# = -141 /* CREATE ANY PROCEDURE */
              )
            )
          )
        )
      )
    )
  );

CREATE OR REPLACE FORCE VIEW "ALL_JAVA_DERIVATIONS"("OWNER",
select u.name,
       dbms_java.longname(t.joxftderivedfrom),
       t.joxftderivedclassnumber,
       dbms_java.longname(t.joxftderivedclassname),
       t.joxftderivedresourcenumber,
       dbms_java.longname(t.joxftderivedresourcename)
from sys.obj$ o, sys.x$joxft t, sys.user$ u
where o.obj# = t.joxftobn
  and o.type# = 29
  and o.owner# = u.user#
  and t.joxftderivedfrom IS NOT NULL
  and
  (
    o.owner# in (userenv('SCHEMAID'), 1 /* PUBLIC */)
    or
    (
      (
        (
          o.obj# in (select obj# from sys.objauth$
                     where grantee# in (select kzsrorol from x$kzsro)
                       and privilege#  = 12 /* EXECUTE */)
        )
        or
        exists
        (
          select null from sys.sysauth$
          where grantee# in (select kzsrorol from x$kzsro)
          and
          (
            (
              /* procedure */
              (
                privilege# = -144 /* EXECUTE ANY PROCEDURE */
                or
                privilege# = -141 /* CREATE ANY PROCEDURE */
              )
            )
          )
        )
      )
    )
  );

CREATE OR REPLACE FORCE VIEW "ALL_JAVA_FIELDS"("OWNER",
select u.name, m.kln, m.fix, m.fnm,
       decode(BITAND(m.fac, 7), 1, 'PUBLIC',
                                2, 'PRIVATE',
                                4, 'PROTECTED',
                                NULL),
       decode(BITAND(m.fac, 8), 8, 'YES',
                                0, 'NO'),
       decode(BITAND(m.fac, 16), 16, 'YES',
                                 0, 'NO'),
       decode(BITAND(m.fac, 64), 64, 'YES',
                                 0, 'NO'),
       decode(BITAND(m.fac, 128), 128, 'YES',
                                  0, 'NO'),
       m.fad,
       decode(m.fbt, 10, 'int',
                     11, 'long',
                     6, 'float',
                     7, 'double',
                     4, 'boolean',
                     8, 'byte',
                     5, 'char',
                     9, 'short',
                     2, 'class',
                     NULL),
       m.fln
from sys.obj$ o, sys.x$joxfm m, sys.user$ u
where o.obj# = m.obn
  and o.type# = 29
  and o.owner# = u.user#
  and
  (
    o.owner# in (userenv('SCHEMAID'), 1 /* PUBLIC */)
    or
    (
      (
        (
          o.obj# in (select obj# from sys.objauth$
                     where grantee# in (select kzsrorol from x$kzsro)
                       and privilege#  = 12 /* EXECUTE */)
        )
        or
        exists
        (
          select null from sys.sysauth$
          where grantee# in (select kzsrorol from x$kzsro)
          and
          (
            (
              /* procedure */
              (
                privilege# = -144 /* EXECUTE ANY PROCEDURE */
                or
                privilege# = -141 /* CREATE ANY PROCEDURE */
              )
            )
          )
        )
      )
    )
  );

CREATE OR REPLACE FORCE VIEW "ALL_JAVA_IMPLEMENTS"("OWNER",
select u.name, m.kln, m.ifx, m.iln
from sys.obj$ o, sys.x$joxfm m, sys.user$ u
where o.obj# = m.obn
  and o.type# = 29
  and o.owner# = u.user#
  and
  (
    o.owner# in (userenv('SCHEMAID'), 1 /* PUBLIC */)
    or
    (
      (
        (
          o.obj# in (select obj# from sys.objauth$
                     where grantee# in (select kzsrorol from x$kzsro)
                       and privilege#  = 12 /* EXECUTE */)
        )
        or
        exists
        (
          select null from sys.sysauth$
          where grantee# in (select kzsrorol from x$kzsro)
          and
          (
            (
              /* procedure */
              (
                privilege# = -144 /* EXECUTE ANY PROCEDURE */
                or
                privilege# = -141 /* CREATE ANY PROCEDURE */
              )
            )
          )
        )
      )
    )
  );

CREATE OR REPLACE FORCE VIEW "ALL_JAVA_INNERS"("OWNER",
select u.name, m.kln, m.nix, m.nsm, m.nln,
       decode(BITAND(m.oac, 7), 1, 'PUBLIC',
                                2, 'PRIVATE',
                                4, 'PROTECTED',
                                NULL),
       decode(BITAND(m.acc, 8), 8, 'YES',
                                0, 'NO'),
       decode(BITAND(m.acc, 16), 16, 'YES',
                                 0, 'NO'),
       decode(BITAND(m.acc, 1024), 1024, 'YES',
                                   0, 'NO'),
       decode(BITAND(m.acc, 512), 512, 'YES',
                                  0, 'NO')
from sys.obj$ o, sys.x$joxfm m, sys.user$ u
where o.obj# = m.obn
  and o.type# = 29
  and o.owner# = u.user#
  and
  (
    o.owner# in (userenv('SCHEMAID'), 1 /* PUBLIC */)
    or
    (
      (
        (
          o.obj# in (select obj# from sys.objauth$
                     where grantee# in (select kzsrorol from x$kzsro)
                       and privilege#  = 12 /* EXECUTE */)
        )
        or
        exists
        (
          select null from sys.sysauth$
          where grantee# in (select kzsrorol from x$kzsro)
          and
          (
            (
              /* procedure */
              (
                privilege# = -144 /* EXECUTE ANY PROCEDURE */
                or
                privilege# = -141 /* CREATE ANY PROCEDURE */
              )
            )
          )
        )
      )
    )
  );

CREATE OR REPLACE FORCE VIEW "ALL_JAVA_LAYOUTS"("OWNER",
select u.name, m.kln, m.lic, m.lnc,
              m.lfc, m.lsf,
              m.lmc, m.lsm, m.jnc
from sys.obj$ o, sys.x$joxfm m, sys.user$ u
where o.obj# = m.obn
  and o.type# = 29
  and o.owner# = u.user#
  and
  (
    o.owner# in (userenv('SCHEMAID'), 1 /* PUBLIC */)
    or
    (
      (
        (
          o.obj# in (select obj# from sys.objauth$
                     where grantee# in (select kzsrorol from x$kzsro)
                       and privilege#  = 12 /* EXECUTE */)
        )
        or
        exists
        (
          select null from sys.sysauth$
          where grantee# in (select kzsrorol from x$kzsro)
          and
          (
            (
              /* procedure */
              (
                privilege# = -144 /* EXECUTE ANY PROCEDURE */
                or
                privilege# = -141 /* CREATE ANY PROCEDURE */
              )
            )
          )
        )
      )
    )
  );

CREATE OR REPLACE FORCE VIEW "ALL_JAVA_METHODS"("OWNER",
select u.name, m.kln, m.mix, m.mnm,
       decode(BITAND(m.mac, 7), 1, 'PUBLIC',
                                2, 'PRIVATE',
                                4, 'PROTECTED',
                                NULL),
       decode(BITAND(m.mac, 8), 8, 'YES',
                                0, 'NO'),
       decode(BITAND(m.mac, 16), 16, 'YES',
                                 0, 'NO'),
       decode(BITAND(m.mac, 32), 32, 'YES',
                                 0, 'NO'),
       decode(BITAND(m.mac, 256), 256, 'YES',
                                  0, 'NO'),
       decode(BITAND(m.mac, 1024), 1024, 'YES',
                                   0, 'NO'),
       decode(BITAND(m.mac, 2048), 2048, 'YES',
                                   0, 'NO'),
       m.agc, m.exc, m.rad,
       decode(m.rbt, 10, 'int',
                     11, 'long',
                     6,  'float',
                     7,  'double',
                     4,  'boolean',
                     8,  'byte',
                     5,  'char',
                     9,  'short',
                     2,  'class',
                     12, 'void',
                     NULL),
       m.rln
from sys.obj$ o, sys.x$joxfm m, sys.user$ u
where o.obj# = m.obn
  and o.type# = 29
  and o.owner# = u.user#
  and
  (
    o.owner# in (userenv('SCHEMAID'), 1 /* PUBLIC */)
    or
    (
      (
        (
          o.obj# in (select obj# from sys.objauth$
                     where grantee# in (select kzsrorol from x$kzsro)
                       and privilege#  = 12 /* EXECUTE */)
        )
        or
        exists
        (
          select null from sys.sysauth$
          where grantee# in (select kzsrorol from x$kzsro)
          and
          (
            (
              /* procedure */
              (
                privilege# = -144 /* EXECUTE ANY PROCEDURE */
                or
                privilege# = -141 /* CREATE ANY PROCEDURE */
              )
            )
          )
        )
      )
    )
  );

CREATE OR REPLACE FORCE VIEW "ALL_JAVA_NCOMPS"("OWNER",
select u.name,
       dbms_java.longname(o.name),
       t.joxftncompsource,
       t.joxftncompinitializer,
       t.joxftncomplibraryfile,
       t.joxftncomplibrary
from sys.obj$ o, sys.x$joxft t, sys.user$ u
where o.obj# = t.joxftobn
  and o.type# = 29
  and o.owner# = u.user#
  and
  (
    o.owner# in (userenv('SCHEMAID'), 1 /* PUBLIC */)
    or
    (
      (
        (
          o.obj# in (select obj# from sys.objauth$
                     where grantee# in (select kzsrorol from x$kzsro)
                       and privilege#  = 12 /* EXECUTE */)
        )
        or
        exists
        (
          select null from sys.sysauth$
          where grantee# in (select kzsrorol from x$kzsro)
          and
          (
            (
              /* procedure */
              (
                privilege# = -144 /* EXECUTE ANY PROCEDURE */
                or
                privilege# = -141 /* CREATE ANY PROCEDURE */
              )
            )
          )
        )
      )
    )
  );

CREATE OR REPLACE FORCE VIEW "ALL_JAVA_RESOLVERS"("OWNER",
select u.name,
       dbms_java.longname(o.name),
       t.joxftresolvertermnumber,
       t.joxftresolvertermpattern,
       t.joxftresolvertermschema
from sys.obj$ o, sys.x$joxft t, sys.user$ u
where o.obj# = t.joxftobn
  and o.type# = 29
  and o.owner# = u.user#
  and
  (
    o.owner# in (userenv('SCHEMAID'), 1 /* PUBLIC */)
    or
    (
      (
        (
          o.obj# in (select obj# from sys.objauth$
                     where grantee# in (select kzsrorol from x$kzsro)
                       and privilege#  = 12 /* EXECUTE */)
        )
        or
        exists
        (
          select null from sys.sysauth$
          where grantee# in (select kzsrorol from x$kzsro)
          and
          (
            (
              /* procedure */
              (
                privilege# = -144 /* EXECUTE ANY PROCEDURE */
                or
                privilege# = -141 /* CREATE ANY PROCEDURE */
              )
            )
          )
        )
      )
    )
  );

CREATE OR REPLACE FORCE VIEW "ALL_JAVA_THROWS"("OWNER",
select u.name, m.kln, m.mix, m.mnm, m.xix, m.xln
from sys.obj$ o, sys.x$joxfm m, sys.user$ u
where o.obj# = m.obn
  and o.type# = 29
  and o.owner# = u.user#
  and
  (
    o.owner# in (userenv('SCHEMAID'), 1 /* PUBLIC */)
    or
    (
      (
        (
          o.obj# in (select obj# from sys.objauth$
                     where grantee# in (select kzsrorol from x$kzsro)
                       and privilege#  = 12 /* EXECUTE */)
        )
        or
        exists
        (
          select null from sys.sysauth$
          where grantee# in (select kzsrorol from x$kzsro)
          and
          (
            (
              /* procedure */
              (
                privilege# = -144 /* EXECUTE ANY PROCEDURE */
                or
                privilege# = -141 /* CREATE ANY PROCEDURE */
              )
            )
          )
        )
      )
    )
  );

CREATE OR REPLACE FORCE VIEW "ALL_JOIN_IND_COLUMNS"("INDEX_OWNER",
select
  ui.name, oi.name,
  uti.name, oti.name, ci.name,
  uto.name, oto.name, co.name
from
  sys.user$ ui, sys.user$ uti, sys.user$ uto,
  sys.obj$ oi, sys.obj$ oti, sys.obj$ oto,
  sys.col$ ci, sys.col$ co,
  sys.jijoin$ ji
where ji.obj# = oi.obj#
  and oi.owner# = ui.user#
  and ji.tab1obj# = oti.obj#
  and oti.owner# = uti.user#
  and ci.obj# = oti.obj#
  and ji.tab1col# = ci.intcol#
  and ji.tab2obj# = oto.obj#
  and oto.owner# = uto.user#
  and co.obj# = oto.obj#
  and ji.tab2col# = co.intcol#
  and (oi.owner# = userenv('SCHEMAID')
        or
       oti.owner# = userenv('SCHEMAID')
        or
       oto.owner# = userenv('SCHEMAID')
        or
       oti.obj# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                        from x$kzsro
                                      )
                   )
        or
       oto.obj# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                        from x$kzsro
                                      )
                   )
        or
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
       );

CREATE OR REPLACE FORCE VIEW "ALL_LIBRARIES"("OWNER",
select u.name,
       o.name,
       l.filespec,
       decode(bitand(l.property, 1), 0, 'Y', 1, 'N', NULL),
       decode(o.status, 0, 'N/A', 1, 'VALID', 'INVALID')
from sys.obj$ o, sys.library$ l, sys.user$ u
where o.owner# = u.user#
  and o.obj# = l.obj#
  and (o.owner# in (userenv('SCHEMAID'), 1 /* PUBLIC */)
       or o.obj# in
          ( select oa.obj#
            from sys.objauth$ oa
            where grantee# in (select kzsrorol from x$kzsro)
          )
       or (
            exists (select NULL from v$enabledprivs
                    where priv_number in (
                                      -189 /* CREATE ANY LIBRARY */,
                                      -190 /* ALTER ANY LIBRARY */,
                                      -191 /* DROP ANY LIBRARY */,
                                      -192 /* EXECUTE ANY LIBRARY */
                                         )
                   )
          )
      );

CREATE OR REPLACE FORCE VIEW "ALL_LOBS"("OWNER",
select u.name, o.name,
       decode(bitand(c.property, 1), 1, ac.name, c.name), lo.name,
       decode(bitand(l.property, 8), 8, ts1.name, ts.name),
       io.name,
       l.chunk * decode(bitand(l.property, 8), 8, ts1.blocksize,
                        ts.blocksize),
       decode(l.pctversion$, 101, to_number(NULL), 102, to_number(NULL),
                                   l.pctversion$),
       decode(l.retention, -1, to_number(NULL), l.retention),
       decode(l.freepools, 0, to_number(NULL), 65534, to_number(NULL),
              65535, to_number(NULL), l.freepools),
       decode(bitand(l.flags, 27), 1, 'NO', 2, 'NO', 8, 'CACHEREADS',
                                   16, 'CACHEREADS', 'YES'),
       decode(bitand(l.flags, 18), 2, 'NO', 16, 'NO', 'YES'),
       decode(bitand(l.property, 2), 2, 'YES', 'NO'),
       decode(c.type#, 113, 'NOT APPLICABLE ',
              decode(bitand(l.property, 512), 512,
                     'ENDIAN SPECIFIC', 'ENDIAN NEUTRAL ')),
       decode(bitand(ta.property, 32), 32, 'YES', 'NO')
from sys.obj$ o, sys.col$ c, sys.attrcol$ ac, sys.tab$ ta, sys.lob$ l,
     sys.obj$ lo, sys.obj$ io, sys.user$ u, sys.ts$ ts, sys.ts$ ts1
where o.owner# = u.user#
  and o.obj# = c.obj#
  and c.obj# = l.obj#
  and c.intcol# = l.intcol#
  and l.lobj# = lo.obj#
  and l.ind# = io.obj#
  and l.ts# = ts.ts#(+)
  and u.tempts# = ts1.ts#
  and c.obj# = ac.obj#(+)
  and c.intcol# = ac.intcol#(+)
  and bitand(c.property,32768) != 32768           /* not unused column */
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                 )
      )
  and o.obj# = ta.obj#
  and bitand(ta.property, 32) != 32    /* not partitioned table */
union all
select u.name, o.name,
       decode(bitand(c.property, 1), 1, ac.name, c.name),
       lo.name,
       decode(null, plob.defts#, ts2.name, ts1.name),
       io.name,
       plob.defchunk * (decode(null, plob.defts#,
                               ts2.blocksize, ts1.blocksize)),
       decode(plob.defpctver$, 101, to_number(NULL), 102, to_number(NULL),
                               plob.defpctver$),
       decode(l.retention, -1, to_number(NULL), l.retention),
       decode(l.freepools, 0, to_number(NULL), 65534, to_number(NULL),
              65535, to_number(NULL), l.freepools),
       decode(bitand(plob.defflags, 27), 1, 'NO', 2, 'NO', 8, 'CACHEREADS',
                                         16, 'CACHEREADS', 'YES'),
       decode(bitand(plob.defflags,22), 0,'NONE', 4,'YES', 2,'NO',
                                        16,'NO', 'UNKNOWN'),
       decode(bitand(plob.defpro, 2), 2, 'YES', 'NO'),
       decode(c.type#, 113, 'NOT APPLICABLE ',
              decode(bitand(l.property, 512), 512,
                     'ENDIAN SPECIFIC', 'ENDIAN NEUTRAL ')),
       decode(bitand(ta.property, 32), 32, 'YES', 'NO')
from sys.obj$ o, sys.col$ c, sys.attrcol$ ac, sys.partlob$ plob,
     sys.lob$ l, sys.obj$ lo, sys.obj$ io, sys.ts$ ts1, sys.tab$ ta,
     sys.partobj$ po, sys.ts$ ts2, sys.user$ u
where o.owner# = u.user#
  and o.obj# = c.obj#
  and c.obj# = l.obj#
  and c.intcol# = l.intcol#
  and l.lobj# = lo.obj#
  and l.ind# = io.obj#
  and l.lobj# = plob.lobj#
  and plob.defts# = ts1.ts# (+)
  and c.obj# = ac.obj#(+)
  and c.intcol# = ac.intcol#(+)
  and bitand(c.property,32768) != 32768           /* not unused column */
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                 )
      )
  and o.obj# = ta.obj#
  and bitand(ta.property, 32) = 32         /* partitioned table */
  and o.obj# = po.obj#
  and po.defts# = ts2.ts#;

CREATE OR REPLACE FORCE VIEW "ALL_LOB_PARTITIONS"("TABLE_OWNER",
select u.name,
       o.name,
       decode(bitand(c.property, 1), 1, a.name, c.name),
       lo.name,
       po.subname,
       lpo.subname,
       lipo.subname,
       lf.frag#,
       'NO',
       lf.chunk * ts.blocksize,
       lf.pctversion$,
       decode(bitand(lf.fragflags,27), 1, 'NO', 2, 'NO', 8, 'CACHEREADS',
                                       16, 'CACHEREADS', 'YES'),
       decode(lf.fragpro, 0, 'NO', 'YES'),
       ts.name,
       to_char(s.iniexts * ts.blocksize),
       to_char(decode(bitand(ts.flags, 3), 1, to_number(NULL),
            s.extsize * ts.blocksize)),
       to_char(s.minexts),
       to_char(s.maxexts),
       to_char(decode(bitand(ts.flags, 3), 1, to_number(NULL),s.extpct)),
       to_char(decode(s.lists, 0, 1, s.lists)),
       to_char(decode(s.groups, 0, 1, s.groups)),
       decode(bitand(lf.fragflags, 18), 2, 'NO', 16, 'NO', 'YES'),
       decode(s.cachehint, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL)
from   sys.obj$ o, sys.col$ c,
       sys.lob$ l, sys.obj$ lo,
       sys.lobfragv$ lf, sys.obj$ lpo,
       sys.obj$ po, sys.obj$ lipo,
       sys.partobj$ pobj,
       sys.ts$ ts, sys.seg$ s, sys.user$ u, attrcol$ a
where o.owner# = u.user#
  and pobj.obj# = o.obj#
  and mod(pobj.spare2, 256) = 0
  and o.obj# = c.obj#
  and c.obj# = l.obj#
  and c.intcol# = l.intcol#
  and l.lobj# = lo.obj#
  and l.lobj# = lf.parentobj#
  and lf.tabfragobj# = po.obj#
  and lf.fragobj# = lpo.obj#
  and lf.indfragobj# = lipo.obj#
  and lf.ts# = s.ts#
  and lf.file# = s.file#
  and lf.block# = s.block#
  and lf.ts# = ts.ts#
  and bitand(c.property,32768) != 32768           /* not unused column */
  and c.obj# = a.obj#(+) and c.intcol# = a.intcol#(+)
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                 )
      )
union all
select u.name,
       o.name,
       decode(bitand(c.property, 1), 1, a.name, c.name),
       lo.name,
       po.subname,
       lpo.subname,
       lipo.subname,
       lcp.part#,
       'YES',
       lcp.defchunk,
       lcp.defpctver$,
       decode(bitand(lcp.defflags, 27), 1, 'NO', 2, 'NO', 8, 'CACHEREADS',
                                       16, 'CACHEREADS', 'YES'),
       decode(lcp.defpro, 0, 'NO', 'YES'),
       ts.name,
       decode(lcp.definiexts, NULL, 'DEFAULT', lcp.definiexts),
       decode(lcp.defextsize, NULL, 'DEFAULT', lcp.defextsize),
       decode(lcp.defminexts, NULL, 'DEFAULT', lcp.defminexts),
       decode(lcp.defmaxexts, NULL, 'DEFAULT', lcp.defmaxexts),
       decode(lcp.defextpct,  NULL, 'DEFAULT', lcp.defextpct),
       decode(lcp.deflists,   NULL, 'DEFAULT', lcp.deflists),
       decode(lcp.defgroups,  NULL, 'DEFAULT', lcp.defgroups),
       decode(bitand(lcp.defflags,22), 0,'NONE', 4,'YES', 2,'NO', 16,'NO', 'UNKNOWN'),
       decode(lcp.defbufpool, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL)
from   sys.obj$ o, sys.col$ c,
       sys.lob$ l, sys.obj$ lo,
       sys.lobcomppartv$ lcp, sys.obj$ lpo,
       sys.obj$ po, sys.obj$ lipo,
       sys.ts$ ts, partobj$ pobj, sys.user$ u, attrcol$ a
where o.owner# = u.user#
  and pobj.obj# = o.obj#
  and mod(pobj.spare2, 256) != 0
  and o.obj# = c.obj#
  and c.obj# = l.obj#
  and c.intcol# = l.intcol#
  and l.lobj# = lo.obj#
  and l.lobj# = lcp.lobj#
  and lcp.tabpartobj# = po.obj#
  and lcp.partobj# = lpo.obj#
  and lcp.indpartobj# = lipo.obj#
  and lcp.defts# = ts.ts# (+)
  and bitand(c.property,32768) != 32768           /* not unused column */
  and c.obj# = a.obj#(+) and c.intcol# = a.intcol#(+)
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_LOB_SUBPARTITIONS"("TABLE_OWNER",
select u.name,
       o.name,
       decode(bitand(c.property, 1), 1, a.name, c.name),
       lo.name,
       lpo.subname,
       spo.subname,
       lspo.subname,
       lispo.subname,
       lf.frag#,
       lf.chunk * ts.blocksize,
       lf.pctversion$,
       decode(bitand(lf.fragflags,27), 1, 'NO', 2, 'NO', 8, 'CACHEREADS',
                                       16, 'CACHEREADS', 'YES'),
       decode(lf.fragpro, 0, 'NO', 'YES'),
       ts.name,
       s.iniexts * ts.blocksize,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
            s.extsize * ts.blocksize),
       s.minexts,
       s.maxexts,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),s.extpct),
       decode(s.lists, 0, 1, s.lists),
       decode(s.groups, 0, 1, s.groups),
       decode(bitand(lf.fragflags, 18), 2, 'NO', 16, 'NO', 'YES'),
       decode(s.cachehint, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL)
from   sys.obj$ o, sys.col$ c,
       sys.lob$ l, sys.obj$ lo,
       sys.lobcomppartv$ lcp, sys.obj$ lpo,
       sys.lobfragv$ lf, sys.obj$ lspo,
       sys.obj$ spo, sys.obj$ lispo,
       sys.partobj$ pobj,
       sys.ts$ ts, sys.seg$ s, sys.user$ u, attrcol$ a
where o.owner# = u.user#
  and pobj.obj# = o.obj#
  and mod(pobj.spare2, 256) != 0
  and o.obj# = c.obj#
  and c.obj# = l.obj#
  and c.intcol# = l.intcol#
  and l.lobj# = lo.obj#
  and l.lobj# = lcp.lobj#
  and lcp.partobj# = lpo.obj#
  and lf.parentobj# = lcp.partobj#
  and lf.tabfragobj# = spo.obj#
  and lf.fragobj# = lspo.obj#
  and lf.indfragobj# = lispo.obj#
  and lf.ts# = s.ts#
  and lf.file# = s.file#
  and lf.block# = s.block#
  and lf.ts# = ts.ts#
  and bitand(c.property,32768) != 32768           /* not unused column */
  and c.obj# = a.obj#(+) and c.intcol# = a.intcol#(+)
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_LOB_TEMPLATES"("USER_NAME",
select u.name, o.name, decode(bitand(c.property, 1), 1, ac.name, c.name),
       st.spart_name, lst.lob_spart_name, ts.name
from sys.obj$ o, sys.defsubpart$ st, sys.defsubpartlob$ lst, sys.ts$ ts,
     sys.col$ c, sys.attrcol$ ac, sys.user$ u
where o.obj# = lst.bo# and st.bo# = lst.bo# and
      st.spart_position =  lst.spart_position and
      lst.lob_spart_ts# = ts.ts#(+) and c.obj# = lst.bo# and
      c.intcol# = lst.intcol# and lst.intcol# = ac.intcol#(+) and
      o.owner# = u.user# and
      (o.owner# = userenv('SCHEMAID') or
       o.obj# in (select oa.obj# from sys.objauth$ oa
                  where grantee# in ( select kzsrorol from x$kzsro )) or
       exists (select null from v$enabledprivs
               where priv_number in (-45 /* LOCK ANY TABLE */,
                                     -47 /* SELECT ANY TABLE */,
                                     -48 /* INSERT ANY TABLE */,
                                     -49 /* UPDATE ANY TABLE */,
                                     -50 /* DELETE ANY TABLE */)));

CREATE OR REPLACE FORCE VIEW "ALL_LOG_GROUPS"("OWNER",
select ou.name, oc.name, o.name,
       case c.type# when 14 then 'PRIMARY KEY LOGGING'
                    when 15 then 'UNIQUE KEY LOGGING'
                    when 16 then 'FOREIGN KEY LOGGING'
                    when 17 then 'ALL COLUMN LOGGING'
                    else 'USER LOG GROUP'
       end,
       case bitand(c.defer,64) when 64 then 'ALWAYS'
                               else  'CONDITIONAL'
       end,
       case bitand(c.defer,8) when 8 then 'GENERATED NAME'
                              else  'USER NAME'
       end
from sys.con$ oc,  sys.user$ ou,
     sys.obj$ o, sys.cdef$ c
where oc.owner# = ou.user#
  and oc.con# = c.con#
  and c.obj# = o.obj#
  and
  (c.type# = 12 or c.type# = 14 or
   c.type# = 15 or c.type# = 16 or
   c.type# = 17)
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in (select obj#
                     from sys.objauth$
                     where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                    )
        or /* user has system privileges */
          exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                  )
      );

CREATE OR REPLACE FORCE VIEW "ALL_LOG_GROUP_COLUMNS"("OWNER",
select u.name, c.name, o.name,
       decode(ac.name, null, col.name, ac.name), cc.pos#,
       decode(cc.spare1, 1, 'NO LOG', 'LOG')
from sys.user$ u, sys.con$ c, sys.col$ col, sys.ccol$ cc, sys.cdef$ cd,
     sys.obj$ o, sys.attrcol$ ac
where c.owner# = u.user#
  and c.con# = cd.con#
  and cd.type# = 12
  and cd.con# = cc.con#
  and cc.obj# = col.obj#
  and cc.intcol# = col.intcol#
  and cc.obj# = o.obj#
  and (c.owner# = userenv('SCHEMAID')
       or cd.obj# in (select obj#
                      from sys.objauth$
                      where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                     )
        or /* user has system privileges */
          exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                  )
      )
  and col.obj# = ac.obj#(+)
  and col.intcol# = ac.intcol#(+);

CREATE OR REPLACE FORCE VIEW "ALL_METHOD_PARAMS"("OWNER",
select u.name, o.name, m.name, m.method#,
       p.name, p.parameter#,
       decode(bitand(p.properties, 768), 768, 'IN OUT',
              decode(bitand(p.properties, 256), 256, 'IN',
                     decode(bitand(p.properties, 512), 512, 'OUT'))),
       decode(bitand(p.properties, 32768), 32768, 'REF',
              decode(bitand(p.properties, 16384), 16384, 'POINTER')),
       decode(bitand(pt.properties, 64), 64, null, pu.name),
       decode(pt.typecode,
              52, decode(p.charsetform, 2, 'NVARCHAR2', po.name),
              53, decode(p.charsetform, 2, 'NCHAR', po.name),
              54, decode(p.charsetform, 2, 'NCHAR VARYING', po.name),
              61, decode(p.charsetform, 2, 'NCLOB', po.name),
              po.name),
       decode(p.charsetform, 1, 'CHAR_CS',
                             2, 'NCHAR_CS',
                             3, NLS_CHARSET_NAME(p.charsetid),
                             4, 'ARG:'||p.charsetid)
from sys.user$ u, sys.obj$ o, sys.method$ m, sys.parameter$ p,
     sys.obj$ po, sys.user$ pu, sys.type$ pt
where o.owner# = u.user#
  and o.type# <> 10 -- must not be invalid
  and o.oid$ = m.toid
  and o.subname IS NULL -- get the latest version only
  and m.toid = p.toid
  and m.version# = p.version#
  and m.method# = p.method#
  and p.param_toid = po.oid$
  and po.owner# = pu.user#
  and p.param_toid = pt.toid
  and p.param_version# = pt.version#
  and (o.owner# = userenv('SCHEMAID')
       or
       o.obj# in (select oa.obj#
                  from sys.objauth$ oa
                  where grantee# in (select kzsrorol
                                     from x$kzsro))
       or /* user has system privileges */
       exists (select null from v$enabledprivs
               where priv_number in (-184 /* EXECUTE ANY TYPE */,
                                     -181 /* CREATE ANY TYPE */)));

CREATE OR REPLACE FORCE VIEW "ALL_METHOD_RESULTS"("OWNER",
select u.name, o.name, m.name, m.method#,
       decode(bitand(r.properties, 32768), 32768, 'REF',
              decode(bitand(r.properties, 16384), 16384, 'POINTER')),
       decode(bitand(rt.properties, 64), 64, null, ru.name),
       decode(rt.typecode,
              52, decode(r.charsetform, 2, 'NVARCHAR2', ro.name),
              53, decode(r.charsetform, 2, 'NCHAR', ro.name),
              54, decode(r.charsetform, 2, 'NCHAR VARYING', ro.name),
              61, decode(r.charsetform, 2, 'NCLOB', ro.name),
              ro.name),
       decode(r.charsetform, 1, 'CHAR_CS',
                             2, 'NCHAR_CS',
                             3, NLS_CHARSET_NAME(r.charsetid),
                             4, 'ARG:'||r.charsetid)
from sys.user$ u, sys.obj$ o, sys.method$ m, sys.result$ r,
     sys.obj$ ro, sys.user$ ru, sys.type$ rt
where o.owner# = u.user#
  and o.type# <> 10 -- must not be invalid
  and o.oid$ = m.toid
  and o.subname IS NULL -- get the latest version only
  and m.toid = r.toid
  and m.version# = r.version#
  and m.method# = r.method#
  and r.result_toid = ro.oid$
  and ro.owner# = ru.user#
  and r.result_toid = rt.toid
  and r.result_version# = rt.version#
  and (o.owner# = userenv('SCHEMAID')
       or
       o.obj# in (select oa.obj#
                  from sys.objauth$ oa
                  where grantee# in (select kzsrorol
                                     from x$kzsro))
       or /* user has system privileges */
       exists (select null from v$enabledprivs
               where priv_number in (-184 /* EXECUTE ANY TYPE */,
                                     -181 /* CREATE ANY TYPE */)));

CREATE OR REPLACE FORCE VIEW "ALL_MVIEWS"("OWNER",
select m."OWNER",m."MVIEW_NAME",m."CONTAINER_NAME",m."QUERY",m."QUERY_LEN",m."UPDATABLE",m."UPDATE_LOG",m."MASTER_ROLLBACK_SEG",m."MASTER_LINK",m."REWRITE_ENABLED",m."REWRITE_CAPABILITY",m."REFRESH_MODE",m."REFRESH_METHOD",m."BUILD_MODE",m."FAST_REFRESHABLE",m."LAST_REFRESH_TYPE",m."LAST_REFRESH_DATE",m."STALENESS",m."AFTER_FAST_REFRESH",m."UNKNOWN_PREBUILT",m."UNKNOWN_PLSQL_FUNC",m."UNKNOWN_EXTERNAL_TABLE",m."UNKNOWN_CONSIDER_FRESH",m."UNKNOWN_IMPORT",m."UNKNOWN_TRUSTED_FD",m."COMPILE_STATE",m."USE_NO_INDEX",m."STALE_SINCE" from dba_mviews m, sys.obj$ o, sys.user$ u
where o.owner#     = u.user#
  and m.mview_name = o.name
  and u.name       = m.owner
  and o.type#      = 2                     /* table */
  and ( u.user# in (userenv('SCHEMAID'), 1)
        or
        o.obj# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                        from x$kzsro
                                      )
                  )
        or /* user has system privileges */
        exists ( select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
               )
      );

CREATE OR REPLACE FORCE VIEW "ALL_MVIEW_AGGREGATES"("OWNER",
select u.name, o.name, sa.sumcolpos#, c.name,
       decode(sa.aggfunction, 15, 'AVG', 16, 'SUM', 17, 'COUNT',
                              18, 'MIN', 19, 'MAX',
                              97, 'VARIANCE', 98, 'STDDEV',
                              440, 'USER'),
       decode(sa.flags, 0, 'N', 'Y'),
       sa.aggtext
from sys.sumagg$ sa, sys.obj$ o, sys.user$ u, sys.sum$ s, sys.col$ c
where sa.sumobj# = o.obj#
  AND o.owner# = u.user#
  AND sa.sumobj# = s.obj#
  AND c.obj# = s.containerobj#
  AND c.col# = sa.containercol#
  AND (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
  AND bitand(s.xpflags, 8388608) = 0 /* NOT REWRITE EQUIVALENCE SUMMARY */;

CREATE OR REPLACE FORCE VIEW "ALL_MVIEW_ANALYSIS"("OWNER",
select u.name, o.name, u.name, s.containernam,
       s.lastrefreshscn, s.lastrefreshdate,
       decode (s.refreshmode, 0, 'NEVER', 1, 'FORCE', 2, 'FAST', 3,'COMPLETE'),
       decode(bitand(s.pflags, 25165824), 25165824, 'N', 'Y'),
       s.fullrefreshtim, s.increfreshtim,
       decode(bitand(s.pflags, 48), 0, 'N', 'Y'),
       decode(bitand(s.mflags, 64), 0, 'N', 'Y'), /* QSMQSUM_UNUSABLE */
       decode(bitand(s.pflags, 1294319), 0, 'Y', 'N'),
       decode(bitand(s.pflags, 236879743), 0, 'Y', 'N'),
       decode(bitand(s.mflags, 1), 0, 'N', 'Y'), /* QSMQSUM_KNOWNSTL */
       decode(o.status, 5, 'Y', 'N'),
       decode(bitand(s.mflags, 4), 0, 'Y', 'N'), /* QSMQSUM_DISABLED */
       s.sumtextlen,s.sumtext,
       s.metaversion/* Metadata revision number */
from sys.user$ u, sys.sum$ s, sys.obj$ o
where o.owner# = u.user#
  and o.obj# = s.obj#
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
  and bitand(s.xpflags, 8388608) = 0 /* NOT REWRITE EQUIVALENCE SUMMARY */;

CREATE OR REPLACE FORCE VIEW "ALL_MVIEW_COMMENTS"("OWNER",
select u.name, o.name, c.comment$
from sys.obj$ o, sys.user$ u, sys.com$ c, sys.tab$ t
  where o.owner# = u.user# AND o.type# = 2
  and (bitand(t.property, 67108864) = 67108864)         /*mv container table */
  and o.obj# = c.obj#(+)
  and c.col#(+) is NULL
  and o.obj# = t.obj#
  and (o.owner# = userenv('SCHEMAID')
        or
        o.obj# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                  )
        or /* user has system privileges */
          exists (select null from v$enabledprivs
                  where priv_number in (-173 /* CREATE ANY MV */,
                                        -174 /* ALTER ANY MV */,
                                        -175 /* DROP ANY MV */)
                  )
      );

CREATE OR REPLACE FORCE VIEW "ALL_MVIEW_DETAIL_RELATIONS"("OWNER",
select u.name, o.name, du.name,  do.name,
       decode (sd.detailobjtype, 1, 'TABLE', 2, 'VIEW',
                                3, 'SNAPSHOT', 4, 'CONTAINER', 'UNDEFINED'),
       sd.detailalias
from sys.user$ u, sys.sumdetail$ sd, sys.obj$ o, sys.obj$ do,
sys.user$ du, sys.sum$ s
where o.owner# = u.user#
  and o.obj# = sd.sumobj#
  and do.obj# = sd.detailobj#
  and do.owner# = du.user#
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
  AND s.obj# = sd.sumobj#
  AND bitand(s.xpflags, 8388608) = 0 /* NOT REWRITE EQUIVALENCE SUMMARY */;

CREATE OR REPLACE FORCE VIEW "ALL_MVIEW_JOINS"("OWNER",
select u.name, o.name,
       u1.name, o1.name, c1.name, '=',
       decode(sj.flags, 0, 'I', 1, 'L', 2, 'R'),
       u2.name, o2.name, c2.name
from sys.sumjoin$ sj, sys.obj$ o, sys.user$ u,
     sys.obj$ o1, sys.user$ u1, sys.col$ c1,
     sys.obj$ o2, sys.user$ u2, sys.col$ c2,
     sys.sum$ s
where sj.sumobj# = o.obj#
  AND o.owner# = u.user#
  AND sj.tab1obj# = o1.obj#
  AND o1.owner# = u1.user#
  AND sj.tab1obj# = c1.obj#
  AND sj.tab1col# = c1.intcol#
  AND sj.tab2obj# = o2.obj#
  AND o2.owner# = u2.user#
  AND sj.tab2obj# = c2.obj#
  AND sj.tab2col# = c2.intcol#
  AND (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
  AND s.obj# = sj.sumobj#
  AND bitand(s.xpflags, 8388608) = 0 /* NOT REWRITE EQUIVALENCE SUMMARY */;

CREATE OR REPLACE FORCE VIEW "ALL_MVIEW_KEYS"("OWNER",
select u1.name, o1.name, sk.sumcolpos#, c1.name,
       u2.name, o2.name, sd.detailalias,
       decode(sk.detailobjtype, 1, 'TABLE', 2, 'VIEW'), c2.name
from sys.sumkey$ sk, sys.obj$ o1, sys.user$ u1, sys.col$ c1, sys.sum$ s,
     sys.sumdetail$ sd, sys.obj$ o2, sys.user$ u2, sys.col$ c2
where sk.sumobj# = o1.obj#
  AND o1.owner# = u1.user#
  AND sk.sumobj# = s.obj#
  AND s.containerobj# = c1.obj#
  AND c1.col# = sk.containercol#
  AND sk.detailobj# = o2.obj#
  AND o2.owner# = u2.user#
  AND sk.sumobj# = sd.sumobj#
  AND sk.detailobj# = sd.detailobj#
  AND sk.detailobj# = c2.obj#
  AND sk.detailcol# = c2.intcol#
  AND (o1.owner# = userenv('SCHEMAID')
       or o1.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
  AND bitand(s.xpflags, 8388608) = 0 /* NOT REWRITE EQUIVALENCE SUMMARY */;

CREATE OR REPLACE FORCE VIEW "ALL_MVIEW_LOGS"("LOG_OWNER",
select s."LOG_OWNER",s."MASTER",s."LOG_TABLE",s."LOG_TRIGGER",s."ROWIDS",s."PRIMARY_KEY",s."OBJECT_ID",s."FILTER_COLUMNS",s."SEQUENCE",s."INCLUDE_NEW_VALUES" from dba_mview_logs s, sys.obj$ o, sys.user$ u
where o.owner#     = u.user#
  and s.log_table = o.name
  and u.name       = s.log_owner
  and o.type#      = 2                     /* table */
  and ( u.user# in (userenv('SCHEMAID'), 1)
        or
        o.obj# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                        from x$kzsro
                                      )
                  )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_MVIEW_REFRESH_TIMES"("OWNER",
select s."OWNER",s."NAME",s."MASTER_OWNER",s."MASTER",s."LAST_REFRESH" from dba_mview_refresh_times s, all_mviews a
where s.owner = a.owner
and   s.name  = a.mview_name;

CREATE OR REPLACE FORCE VIEW "ALL_NESTED_TABLES"("OWNER",
select u.name, o.name,
       nvl2(ct.synobj#, (select u.name from user$ u, obj$ o
            where o.owner#=u.user# and o.obj#=ct.synobj#), ut.name),
       nvl2(ct.synobj#, (select o.name from obj$ o
            where o.obj#=ct.synobj#), ot.name),
       op.name, ac.name,
       lpad(decode(bitand(ct.flags, 64), 64, 'USER_SPECIFIED', 'DEFAULT'), 30),
       lpad(decode(bitand(ct.flags, 32), 32, 'LOCATOR', 'VALUE'), 20),
       lpad((case when bitand(ct.flags, 5120)=0 and bitand(t.properties, 8)= 8
       then 'Y' else 'N' end), 25)
from sys.ntab$ n, sys.obj$ o, sys.obj$ op, sys.obj$ ot,
  sys.col$ c, sys.coltype$ ct, sys.user$ u, sys.user$ ut, sys.attrcol$ ac,
  sys.type$ t, sys.collection$ cl
where o.owner# = u.user#
  and op.owner# = u.user#
  and n.obj# = op.obj#
  and n.ntab# = o.obj#
  and c.obj# = op.obj#
  and n.intcol# = c.intcol#
  and c.obj# = ac.obj#
  and c.intcol# = ac.intcol#
  and op.obj# = ct.obj#
  and ct.toid = ot.oid$
  and ct.intcol#=n.intcol#
  and ot.owner# = ut.user#
  and ct.toid=cl.toid
  and cl.elem_toid=t.tvoid
  and bitand(ct.flags,4)=4
  and bitand(c.property,32768) != 32768           /* not unused column */
  and (op.owner# = userenv('SCHEMAID')
       or op.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
union all
select u.name, o.name,
       nvl2(ct.synobj#, (select u.name from user$ u, obj$ o
            where o.owner#=u.user# and o.obj#=ct.synobj#), ut.name),
       nvl2(ct.synobj#, (select o.name from obj$ o
            where o.obj#=ct.synobj#), ot.name),
       op.name, c.name,
       lpad(decode(bitand(ct.flags, 64), 64, 'USER_SPECIFIED', 'DEFAULT'), 30),
       lpad(decode(bitand(ct.flags, 32), 32, 'LOCATOR', 'VALUE'), 20),
       lpad((case when bitand(ct.flags, 5120)=0 and bitand(t.properties, 8)= 8
       then 'Y' else 'N' end), 25)
from sys.ntab$ n, sys.obj$ o, sys.obj$ op, sys.obj$ ot, sys.col$ c,
  sys.coltype$ ct, sys.user$ u, sys.user$ ut, sys.type$ t, sys.collection$ cl
where o.owner# = u.user#
  and op.owner# = u.user#
  and n.obj# = op.obj#
  and n.ntab# = o.obj#
  and c.obj# = op.obj#
  and n.intcol# = c.intcol#
  and bitand(c.property,1)=0
  and op.obj# = ct.obj#
  and ct.toid = ot.oid$
  and ct.intcol#=n.intcol#
  and ot.owner# = ut.user#
  and ct.toid=cl.toid
  and cl.elem_toid=t.tvoid
  and bitand(ct.flags,4)=4
  and bitand(c.property,32768) != 32768           /* not unused column */
  and (op.owner# = userenv('SCHEMAID')
       or op.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_NESTED_TABLE_COLS"("OWNER",
select u.name, o.name,
       c.name,
       decode(c.type#, 1, decode(c.charsetform, 2, 'NVARCHAR2', 'VARCHAR2'),
                       2, decode(c.scale, null,
                                 decode(c.precision#, null, 'NUMBER', 'FLOAT'),
                                 'NUMBER'),
                       8, 'LONG',
                       9, decode(c.charsetform, 2, 'NCHAR VARYING', 'VARCHAR'),
                       12, 'DATE',
                       23, 'RAW', 24, 'LONG RAW',
                       58, nvl2(ac.synobj#, (select o.name from obj$ o
                                where o.obj#=ac.synobj#), ot.name),
                       69, 'ROWID',
                       96, decode(c.charsetform, 2, 'NCHAR', 'CHAR'),
                       100, 'BINARY_FLOAT',
                       101, 'BINARY_DOUBLE',
                       105, 'MLSLABEL',
                       106, 'MLSLABEL',
                       111, nvl2(ac.synobj#, (select o.name from obj$ o
                                 where o.obj#=ac.synobj#), ot.name),
                       112, decode(c.charsetform, 2, 'NCLOB', 'CLOB'),
                       113, 'BLOB', 114, 'BFILE', 115, 'CFILE',
                       121, nvl2(ac.synobj#, (select o.name from obj$ o
                                 where o.obj#=ac.synobj#), ot.name),
                       122, nvl2(ac.synobj#, (select o.name from obj$ o
                                 where o.obj#=ac.synobj#), ot.name),
                       123, nvl2(ac.synobj#, (select o.name from obj$ o
                                 where o.obj#=ac.synobj#), ot.name),
                       178, 'TIME(' ||c.scale|| ')',
                       179, 'TIME(' ||c.scale|| ')' || ' WITH TIME ZONE',
                       180, 'TIMESTAMP(' ||c.scale|| ')',
                       181, 'TIMESTAMP(' ||c.scale|| ')' || ' WITH TIME ZONE',
                       231, 'TIMESTAMP(' ||c.scale|| ')' || ' WITH LOCAL TIME ZONE',
                       182, 'INTERVAL YEAR(' ||c.precision#||') TO MONTH',
                       183, 'INTERVAL DAY(' ||c.precision#||') TO SECOND(' ||
                             c.scale || ')',
                       208, 'UROWID',
                       'UNDEFINED'),
       decode(c.type#, 111, 'REF'),
       nvl2(ac.synobj#, (select u.name from user$ u, obj$ o
            where o.owner#=u.user# and o.obj#=ac.synobj#), ut.name),
       c.length, c.precision#, c.scale,
       decode(sign(c.null$),-1,'D', 0, 'Y', 'N'),
       decode(c.col#, 0, to_number(null), c.col#), c.deflength,
       c.default$, h.distcnt, h.lowval, h.hival, h.density, h.null_cnt,
       case when h.bucket_cnt > 255 then h.row_cnt else
         decode(h.row_cnt, h.distcnt, h.row_cnt, h.bucket_cnt)
       end,
       h.timestamp#, h.sample_size,
       decode(c.charsetform, 1, 'CHAR_CS',
                             2, 'NCHAR_CS',
                             3, NLS_CHARSET_NAME(c.charsetid),
                             4, 'ARG:'||c.charsetid),
       decode(c.charsetid, 0, to_number(NULL),
                           nls_charset_decl_len(c.length, c.charsetid)),
       decode(bitand(h.spare2, 2), 2, 'YES', 'NO'),
       decode(bitand(h.spare2, 1), 1, 'YES', 'NO'),
       h.avgcln,
       c.spare3,
       decode(c.type#, 1, decode(bitand(c.property, 8388608), 0, 'B', 'C'),
                      96, decode(bitand(c.property, 8388608), 0, 'B', 'C'),
                      null),
       decode(bitand(ac.flags, 128), 128, 'YES', 'NO'),
       decode(o.status, 1, decode(bitand(ac.flags, 256), 256, 'NO', 'YES'),
                        decode(bitand(ac.flags, 2), 2, 'NO',
                               decode(bitand(ac.flags, 4), 4, 'NO',
                                      decode(bitand(ac.flags, 8), 8, 'NO',
                                             'N/A')))),
       decode(c.property, 0, 'NO', decode(bitand(c.property, 32), 32, 'YES',
                                          'NO')),
       decode(c.property, 0, 'NO', decode(bitand(c.property, 8), 8, 'YES',
                                          'NO')),
       decode(c.segcol#, 0, to_number(null), c.segcol#), c.intcol#,
       case when h.bucket_cnt > 255 then 'FREQUENCY' else
         decode(nvl(h.row_cnt, 0), 0, 'NONE',
                                   h.distcnt, 'FREQUENCY', 'HEIGHT BALANCED')
       end,
       decode(bitand(c.property, 1024), 1024,
              (select decode(bitand(cl.property, 1), 1, rc.name, cl.name)
               from sys.col$ cl, attrcol$ rc where cl.intcol# = c.intcol#-1
               and cl.obj# = c.obj# and c.obj# = rc.obj#(+) and
               cl.intcol# = rc.intcol#(+)),
              decode(bitand(c.property, 1), 0, c.name,
                     (select tc.name from sys.attrcol$ tc
                      where c.obj# = tc.obj# and c.intcol# = tc.intcol#)))
from sys.col$ c, sys.obj$ o, sys.hist_head$ h, sys.user$ u,
     sys.coltype$ ac, sys.obj$ ot, sys.user$ ut, sys.tab$ t
where o.obj# = c.obj#
  and o.owner# = u.user#
  and c.obj# = h.obj#(+) and c.intcol# = h.intcol#(+)
  and c.obj# = ac.obj#(+) and c.intcol# = ac.intcol#(+)
  and ac.toid = ot.oid$(+)
  and ot.type#(+) = 13
  and ot.owner# = ut.user#(+)
  and o.obj# = t.obj#
  and bitand(t.property, 8192) = 8192        /* nested tables */
  and (o.owner# = userenv('SCHEMAID')
        or
        o.obj# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                  )
        or /* user has system privileges */
          exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                  )
       );

CREATE OR REPLACE FORCE VIEW "ALL_OBJECTS"("OWNER",
select u.name, o.name, o.subname, o.obj#, o.dataobj#,
       decode(o.type#, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE',
                      7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE',
                      11, 'PACKAGE BODY', 12, 'TRIGGER',
                      13, 'TYPE', 14, 'TYPE BODY',
                      19, 'TABLE PARTITION', 20, 'INDEX PARTITION', 21, 'LOB',
                      22, 'LIBRARY', 23, 'DIRECTORY', 24, 'QUEUE',
                      28, 'JAVA SOURCE', 29, 'JAVA CLASS', 30, 'JAVA RESOURCE',
                      32, 'INDEXTYPE', 33, 'OPERATOR',
                      34, 'TABLE SUBPARTITION', 35, 'INDEX SUBPARTITION',
                      40, 'LOB PARTITION', 41, 'LOB SUBPARTITION',
                      42, NVL((SELECT distinct 'REWRITE EQUIVALENCE'
                               FROM sum$ s
                               WHERE s.obj#=o.obj#
                                     and bitand(s.xpflags, 8388608) = 8388608),
                              'MATERIALIZED VIEW'),
                      43, 'DIMENSION',
                      44, 'CONTEXT', 46, 'RULE SET', 47, 'RESOURCE PLAN',
                      48, 'CONSUMER GROUP',
                      55, 'XML SCHEMA', 56, 'JAVA DATA',
                      57, 'SECURITY PROFILE', 59, 'RULE',
                      60, 'CAPTURE', 61, 'APPLY',
                      62, 'EVALUATION CONTEXT',
                      66, 'JOB', 67, 'PROGRAM', 68, 'JOB CLASS', 69, 'WINDOW',
                      72, 'WINDOW GROUP', 74, 'SCHEDULE',
                     'UNDEFINED'),
       o.ctime, o.mtime,
       to_char(o.stime, 'YYYY-MM-DD:HH24:MI:SS'),
       decode(o.status, 0, 'N/A', 1, 'VALID', 'INVALID'),
       decode(bitand(o.flags, 2), 0, 'N', 2, 'Y', 'N'),
       decode(bitand(o.flags, 4), 0, 'N', 4, 'Y', 'N'),
       decode(bitand(o.flags, 16), 0, 'N', 16, 'Y', 'N')
from sys.obj$ o, sys.user$ u
where o.owner# = u.user#
  and o.linkname is null
  and (o.type# not in (1  /* INDEX - handled below */,
                      10 /* NON-EXISTENT */)
       or
       (o.type# = 1 and 1 = (select 1
                             from sys.ind$ i
                            where i.obj# = o.obj#
                              and i.type# in (1, 2, 3, 4, 6, 7, 9))))
  and o.name != '_NEXT_OBJECT'
  and o.name != '_default_auditing_options_'
  and
  (
    o.owner# in (userenv('SCHEMAID'), 1 /* PUBLIC */)
    or
    (
      /* EXECUTE privilege does not let user see package/type body */
      o.type# != 11 and o.type# != 14
      and
      o.obj# in (select obj# from sys.objauth$
                 where grantee# in (select kzsrorol from x$kzsro)
                   and privilege# in (3 /* DELETE */,   6 /* INSERT */,
                                      7 /* LOCK */,     9 /* SELECT */,
                                      10 /* UPDATE */, 12 /* EXECUTE */,
                                      11 /* USAGE */,  16 /* CREATE */,
                                      17 /* READ */,   18 /* WRITE  */ ))
    )
    or
    (
       o.type# in (7, 8, 9, 28, 29, 30, 56) /* prc, fcn, pkg */
       and
       exists (select null from v$enabledprivs
               where priv_number in (
                                      -144 /* EXECUTE ANY PROCEDURE */,
                                      -141 /* CREATE ANY PROCEDURE */
                                    )
              )
    )
    or
    (
       o.type# in (12) /* trigger */
       and
       exists (select null from v$enabledprivs
               where priv_number in (
                                      -152 /* CREATE ANY TRIGGER */
                                    )
              )
    )
    or
    (
       o.type# = 11 /* pkg body */
       and
       exists (select null from v$enabledprivs
               where priv_number =   -141 /* CREATE ANY PROCEDURE */
              )
    )
    or
    (
       o.type# in (22) /* library */
       and
       exists (select null from v$enabledprivs
               where priv_number in (
                                      -189 /* CREATE ANY LIBRARY */,
                                      -190 /* ALTER ANY LIBRARY */,
                                      -191 /* DROP ANY LIBRARY */,
                                      -192 /* EXECUTE ANY LIBRARY */
                                    )
              )
    )
    or
    (
       /* index, table, view, synonym, table partn, indx partn, */
       /* table subpartn, index subpartn, cluster               */
       o.type# in (1, 2, 3, 4, 5, 19, 20, 34, 35)
       and
       exists (select null from v$enabledprivs
               where priv_number in (-45 /* LOCK ANY TABLE */,
                                     -47 /* SELECT ANY TABLE */,
                                     -48 /* INSERT ANY TABLE */,
                                     -49 /* UPDATE ANY TABLE */,
                                     -50 /* DELETE ANY TABLE */)
               )
    )
    or
    ( o.type# = 6 /* sequence */
      and
      exists (select null from v$enabledprivs
              where priv_number = -109 /* SELECT ANY SEQUENCE */)
    )
    or
    ( o.type# = 13 /* type */
      and
      exists (select null from v$enabledprivs
              where priv_number in (-184 /* EXECUTE ANY TYPE */,
                                    -181 /* CREATE ANY TYPE */))
    )
    or
    (
      o.type# = 14 /* type body */
      and
      exists (select null from v$enabledprivs
              where priv_number = -181 /* CREATE ANY TYPE */)
    )
    or
    (
       o.type# = 23 /* directory */
       and
       exists (select null from v$enabledprivs
               where priv_number in (
                                      -177 /* CREATE ANY DIRECTORY */,
                                      -178 /* DROP ANY DIRECTORY */
                                    )
              )
    )
    or
    (
       o.type# = 42 /* summary jjf table privs have to change to summary */
       and
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
    )
    or
    (
      o.type# = 32   /* indextype */
      and
      exists (select null from v$enabledprivs
               where priv_number in (
                                      -205  /* CREATE INDEXTYPE */ ,
                                      -206  /* CREATE ANY INDEXTYPE */ ,
                                      -207  /* ALTER ANY INDEXTYPE */ ,
                                      -208  /* DROP ANY INDEXTYPE */
                                    )
             )
    )
    or
    (
      o.type# = 33   /* operator */
      and
      exists (select null from v$enabledprivs
               where priv_number in (
                                      -200  /* CREATE OPERATOR */ ,
                                      -201  /* CREATE ANY OPERATOR */ ,
                                      -202  /* ALTER ANY OPERATOR */ ,
                                      -203  /* DROP ANY OPERATOR */ ,
                                      -204  /* EXECUTE OPERATOR */
                                    )
             )
    )
    or
    (
      o.type# = 44   /* context */
      and
      exists (select null from v$enabledprivs
               where priv_number in (
                                      -222  /* CREATE ANY CONTEXT */,
                                      -223  /* DROP ANY CONTEXT */
                                    )
             )
    )
    or
    (
      o.type# = 48  /* resource consumer group */
      and
      exists (select null from v$enabledprivs
              where priv_number in (12)  /* switch consumer group privilege */
             )
    )
    or
    (
      o.type# = 46 /* rule set */
      and
      exists (select null from v$enabledprivs
               where priv_number in (
                                      -251, /* create any rule set */
                                      -252, /* alter any rule set */
                                      -253, /* drop any rule set */
                                      -254  /* execute any rule set */
                                    )
             )
    )
    or
    (
      o.type# = 55 /* XML schema */
      and
      1 = (select /*+ NO_MERGE */ xml_schema_name_present.is_schema_present(o.name, u2.id2) id1 from (select /*+ NO_MERGE */ userenv('SCHEMAID') id2 from dual) u2)
      /* we need a sub-query instead of the directy invoking
       * xml_schema_name_present, because inside a view even the function
       * arguments are evaluated as definers rights.
       */
    )
    or
    (
      o.type# = 59 /* rule */
      and
      exists (select null from v$enabledprivs
               where priv_number in (
                                      -258, /* create any rule */
                                      -259, /* alter any rule */
                                      -260, /* drop any rule */
                                      -261  /* execute any rule */
                                    )
             )
    )
    or
    (
      o.type# = 62 /* evaluation context */
      and
      exists (select null from v$enabledprivs
               where priv_number in (
                                      -246, /* create any evaluation context */
                                      -247, /* alter any evaluation context */
                                      -248, /* drop any evaluation context */
                                      -249 /* execute any evaluation context */
                                    )
             )
    )
    or
    (
      o.type# = 66 /* scheduler job */
      and
      exists (select null from v$enabledprivs
               where priv_number = -265 /* create any job */
             )
    )
    or
    (
      o.type# = 67 /* scheduler program */
      and
      exists (select null from v$enabledprivs
               where priv_number in (
                                      -265, /* create any job */
                                      -266 /* execute any program */
                                    )
             )
    )
    or
    (
      o.type# = 68 /* scheduler job class */
      and
      exists (select null from v$enabledprivs
               where priv_number in (
                                      -268, /* manage scheduler */
                                      -267 /* execute any class */
                                    )
             )
    )
    or o.type# in (69, 72, 74)
    /* scheduler windows, window groups and schedules */
    /* no privileges are needed to view these objects */
  );

CREATE OR REPLACE FORCE VIEW "ALL_OBJECT_TABLES"("OWNER",
select u.name, o.name, decode(bitand(t.property, 2151678048), 0, ts.name, null),
       decode(bitand(t.property, 1024), 0, null, co.name),
       decode((bitand(t.property, 512)+bitand(t.flags, 536870912)),
              0, null, co.name),
       decode(bitand(t.property, 32+64), 0, mod(t.pctfree$, 100), 64, 0, null),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
          decode(bitand(t.property, 32+64), 0, t.pctused$, 64, 0, null)),
       decode(bitand(t.property, 32), 0, t.initrans, null),
       decode(bitand(t.property, 32), 0, t.maxtrans, null),
       s.iniexts * ts.blocksize,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                      s.extsize * ts.blocksize),
       s.minexts, s.maxexts,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                      s.extpct),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
         decode(bitand(o.flags, 2), 2, 1, decode(s.lists, 0, 1, s.lists))),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
         decode(bitand(o.flags, 2), 2, 1, decode(s.groups, 0, 1, s.groups))),
       decode(bitand(t.property, 32), 32, null,
                decode(bitand(t.flags, 32), 0, 'YES', 'NO')),
       decode(bitand(t.flags,1), 0, 'Y', 1, 'N', '?'),
       t.rowcnt,
       decode(bitand(t.property, 64), 0, t.blkcnt, null),
       decode(bitand(t.property, 64), 0, t.empcnt, null),
       t.avgspc, t.chncnt, t.avgrln, t.avgspc_flb,
       decode(bitand(t.property, 64), 0, t.flbcnt, null),
       lpad(decode(t.degree, 32767, 'DEFAULT', nvl(t.degree,1)),10),
       lpad(decode(t.instances, 32767, 'DEFAULT', nvl(t.instances,1)),10),
       lpad(decode(bitand(t.flags, 8), 8, 'Y', 'N'),5),
       decode(bitand(t.flags, 6), 0, 'ENABLED', 'DISABLED'),
       t.samplesize, t.analyzetime,
       decode(bitand(t.property, 32), 32, 'YES', 'NO'),
       decode(bitand(t.property, 64), 64, 'IOT',
               decode(bitand(t.property, 512), 512, 'IOT_OVERFLOW',
               decode(bitand(t.flags, 536870912), 536870912, 'IOT_MAPPING', null))),
       decode(bitand(t.property, 4096), 4096, 'USER-DEFINED',
                                              'SYSTEM GENERATED'),
       nvl2(ac.synobj#, su.name, tu.name),
       nvl2(ac.synobj#, so.name, ty.name),
       decode(bitand(o.flags, 2), 0, 'N', 2, 'Y', 'N'),
       decode(bitand(o.flags, 16), 0, 'N', 16, 'Y', 'N'),
       decode(bitand(t.property, 8192), 8192, 'YES', 'NO'),
       decode(bitand(o.flags, 2), 2, 'DEFAULT',
             decode(s.cachehint, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL)),
       decode(bitand(t.flags, 131072), 131072, 'ENABLED', 'DISABLED'),
       decode(bitand(t.flags, 512), 0, 'NO', 'YES'),
       decode(bitand(t.flags, 256), 0, 'NO', 'YES'),
       decode(bitand(o.flags, 2), 0, NULL,
          decode(bitand(t.property, 8388608), 8388608,
                 'SYS$SESSION', 'SYS$TRANSACTION')),
       decode(bitand(t.flags, 1024), 1024, 'ENABLED', 'DISABLED'),
       decode(bitand(o.flags, 2), 2, 'NO',
           decode(bitand(t.property, 2147483648), 2147483648, 'NO',
              decode(ksppcv.ksppstvl, 'TRUE', 'YES', 'NO'))),
       decode(bitand(t.property, 1024), 0, null, cu.name),
       decode(bitand(t.flags, 8388608), 8388608, 'ENABLED', 'DISABLED'),
       decode(bitand(t.property, 32), 32, null,
                decode(bitand(s.spare1, 2048), 2048, 'ENABLED', 'DISABLED')),
       decode(bitand(o.flags, 128), 128, 'YES', 'NO')
from sys.user$ u, sys.ts$ ts, sys.seg$ s, sys.obj$ co, sys.tab$ t, sys.obj$ o,
     sys.coltype$ ac, sys.obj$ ty, sys.user$ tu, sys.col$ tc,
     sys.obj$ cx, sys.user$ cu, sys.obj$ so, sys.user$ su,
     x$ksppcv ksppcv, x$ksppi ksppi
where o.owner# = u.user#
  and o.obj# = t.obj#
  and bitand(t.property, 1) = 1
  and bitand(o.flags, 128) = 0
  and t.obj# = tc.obj#
  and tc.name = 'SYS_NC_ROWINFO$'
  and tc.obj# = ac.obj#
  and tc.intcol# = ac.intcol#
  and ac.toid = ty.oid$
  and ty.type# <> 10
  and ty.owner# = tu.user#
  and t.bobj# = co.obj# (+)
  and t.ts# = ts.ts#
  and t.file# = s.file# (+)
  and t.block# = s.block# (+)
  and t.ts# = s.ts# (+)
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
  and t.dataobj# = cx.obj# (+)
  and cx.owner# = cu.user# (+)
  and ac.synobj# = so.obj# (+)
  and so.owner# = su.user# (+)
  and ksppi.indx = ksppcv.indx
  and ksppi.ksppinm = '_dml_monitoring_enabled';

CREATE OR REPLACE FORCE VIEW "ALL_OBJ_COLATTRS"("OWNER",
select u.name, o.name, c.name,
  lpad(decode(bitand(ct.flags, 512), 512, 'Y', 'N'), 15)
from sys.coltype$ ct, sys.obj$ o, sys.col$ c, sys.user$ u
where o.owner# = u.user#
  and bitand(ct.flags, 2) = 2                                 /* ADT column */
  and o.obj#=ct.obj#
  and o.obj#=c.obj#
  and c.intcol#=ct.intcol#
  and bitand(c.property,32768) != 32768                 /* not unused column */
  and not exists (select null                   /* Doesn't exist in attrcol$ */
                  from sys.attrcol$ ac
                  where ac.intcol#=ct.intcol#
                        and ac.obj#=ct.obj#)
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
union all
select u.name, o.name, ac.name,
  lpad(decode(bitand(ct.flags, 512), 512, 'Y', 'N'), 15)
from sys.coltype$ ct, sys.obj$ o, sys.attrcol$ ac, sys.user$ u, col$ c
where o.owner# = u.user#
  and bitand(ct.flags, 2) = 2                                /* ADT column */
  and o.obj#=ct.obj#
  and o.obj#=c.obj#
  and o.obj#=ac.obj#
  and c.intcol#=ct.intcol#
  and c.intcol#=ac.intcol#
  and bitand(c.property,32768) != 32768               /* not unused column */
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_OPANCILLARY"("OWNER",
select distinct u.name, o.name, a.bind#, u1.name, o1.name, a1.primbind#
from   sys.user$ u, sys.obj$ o, sys.opancillary$ a, sys.user$ u1, sys.obj$ o1,
       sys.opancillary$ a1
where  a.obj#=o.obj# and o.owner#=u.user#   AND
       a1.primop#=o1.obj# and o1.owner#=u1.user# and a.obj#=a1.obj#
  and ( o.owner# = userenv ('SCHEMAID')
    or
    o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or exists (select null from v$enabledprivs
                  where priv_number in (-200 /* CREATE OPERATOR */,
                                        -201 /* CREATE ANY OPERATOR */,
                                        -202 /* ALTER ANY OPERATOR */,
                                        -203 /* DROP ANY OPERATOR */,
                                        -204 /* EXECUTE OPERATOR */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_OPARGUMENTS"("OWNER",
select  c.name, b.name, a.bind#, a.position, a.type
  from  sys.oparg$ a, sys.obj$ b, sys.user$ c
  where a.obj# = b.obj# and b.owner# = c.user#
  and  (b.owner# = userenv ('SCHEMAID')
        or
        b.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
           or exists (select null from v$enabledprivs
                  where priv_number in (-200 /* CREATE OPERATOR */,
                                        -201 /* CREATE ANY OPERATOR */,
                                        -202 /* ALTER ANY OPERATOR */,
                                        -203 /* DROP ANY OPERATOR */,
                                        -204 /* EXECUTE OPERATOR */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_OPBINDINGS"("OWNER",
select   c.name, b.name, a.bind#, a.functionname, a.returnschema,
         a.returntype, a.impschema, a.imptype,
        decode(bitand(a.property,31), 1, 'WITH INDEX CONTEXT',
               3 , 'COMPUTE ANCILLARY DATA', 4 , 'ANCILLARY TO' ,
               16 , 'WITH COLUMN CONTEXT' ,
               17,  'WITH INDEX, COLUMN CONTEXT',
               19, 'COMPUTE ANCILLARY DATA, WITH COLUMN CONTEXT')
   from  sys.opbinding$ a, sys.obj$ b, sys.user$ c where
  a.obj# = b.obj# and b.owner# = c.user#
  and ( b.owner# = userenv ('SCHEMAID')
    or
    b.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or exists (select null from v$enabledprivs
                  where priv_number in (-200 /* CREATE OPERATOR */,
                                        -201 /* CREATE ANY OPERATOR */,
                                        -202 /* ALTER ANY OPERATOR */,
                                        -203 /* DROP ANY OPERATOR */,
                                        -204 /* EXECUTE OPERATOR */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_OPERATORS"("OWNER",
select c.name, b.name, a.numbind from
  sys.operator$ a, sys.obj$ b, sys.user$ c where
  a.obj# = b.obj# and b.owner# = c.user# and
  ( b.owner# = userenv ('SCHEMAID')
    or
    b.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or exists (select null from v$enabledprivs
                  where priv_number in (-200 /* CREATE OPERATOR */,
                                        -201 /* CREATE ANY OPERATOR */,
                                        -202 /* ALTER ANY OPERATOR */,
                                        -203 /* DROP ANY OPERATOR */,
                                        -204 /* EXECUTE OPERATOR */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_OPERATOR_COMMENTS"("OWNER",
select u.name, o.name, c.comment$
from   sys.obj$ o, sys.operator$ op, sys.com$ c, sys.user$ u
where  o.obj# = op.obj# and c.obj# = op.obj# and u.user# = o.owner#
       and
       ( o.owner# = userenv('SCHEMAID')
         or
         o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
         or exists (select null from v$enabledprivs
                    where priv_number in (-200 /* CREATE OPERATOR */,
                                        -201 /* CREATE ANY OPERATOR */,
                                        -202 /* ALTER ANY OPERATOR */,
                                        -203 /* DROP ANY OPERATOR */,
                                        -204 /* EXECUTE OPERATOR */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_PARTIAL_DROP_TABS"("OWNER",
select u.name, o.name
from sys.user$ u, sys.obj$ o, sys.tab$ t
where o.owner# = u.user#
  and o.obj# = t.obj#
  and bitand(t.flags,32768) = 32768
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                 )
      )
  group by u.name, o.name;

CREATE OR REPLACE FORCE VIEW "ALL_PART_COL_STATISTICS"("OWNER",
select u.name, o.name, o.subname, tp.cname, h.distcnt, h.lowval, h.hival,
       h.density, h.null_cnt,
       case when h.bucket_cnt > 255 then h.row_cnt else
         decode(h.row_cnt, h.distcnt, h.row_cnt, h.bucket_cnt)
       end,
       h.sample_size, h.timestamp#,
       decode(bitand(h.spare2, 2), 2, 'YES', 'NO'),
       decode(bitand(h.spare2, 1), 1, 'YES', 'NO'),
       h.avgcln,
       case when h.bucket_cnt > 255 then 'FREQUENCY' else
         decode(nvl(h.row_cnt, 0), 0, 'NONE',
                                   h.distcnt, 'FREQUENCY', 'HEIGHT BALANCED')
       end
from sys.obj$ o, sys.hist_head$ h, tp$ tp, user$ u
where o.obj# = tp.obj# and o.owner# = u.user#
  and tp.obj# = h.obj#(+) and tp.intcol# = h.intcol#(+)
  and o.type# = 19 /* TABLE PARTITION */
  and (o.owner# = userenv('SCHEMAID')
        or tp.bo# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
        or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_PART_HISTOGRAMS"("OWNER",
select u.name,
       o.name, o.subname,
       tp.cname,
       h.bucket,
       h.endpoint,
       h.epvalue
from sys.obj$ o, sys.histgrm$ h, sys.user$ u, tp$ tp
where o.obj# = tp.obj# and tp.obj# = h.obj#
      and tp.intcol# = h.intcol#
      and o.type# = 19 /* TABLE PARTITION */
      and o.owner# = u.user# and
      (o.owner# = userenv('SCHEMAID')
        or
        tp.bo# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                  )
        or /* user has system privileges */
          exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                  )
       )
union
select u.name,
       o.name, o.subname,
       tp.cname,
       0,
       h.minimum,
       null
from sys.obj$ o, sys.hist_head$ h, sys.user$ u, tp$ tp
where o.obj# = tp.obj# and tp.obj# = h.obj#
      and tp.intcol# = h.intcol#
      and o.type# = 19 /* TABLE PARTITION */
      and h.bucket_cnt = 1
      and o.owner# = u.user# and
      (o.owner# = userenv('SCHEMAID')
        or
        tp.bo# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                  )
        or /* user has system privileges */
          exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                  )
       )
union
select u.name,
       o.name, o.subname,
       tp.cname,
       1,
       h.maximum,
       null
from sys.obj$ o, sys.hist_head$ h, sys.user$ u, tp$ tp
where o.obj# = tp.obj# and tp.obj# = h.obj#
      and tp.intcol# = h.intcol#
      and o.type# = 19 /* TABLE PARTITION */
      and h.bucket_cnt = 1
      and o.owner# = u.user# and
      (o.owner# = userenv('SCHEMAID')
        or
        tp.bo# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                  )
        or /* user has system privileges */
          exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                  )
       );

CREATE OR REPLACE FORCE VIEW "ALL_PART_INDEXES"("OWNER",
select u.name, io.name, o.name,
       decode(po.parttype, 1, 'RANGE', 2, 'HASH', 3, 'SYSTEM', 4, 'LIST',
                                                                  'UNKNOWN'),
       decode(mod(po.spare2, 256), 0, 'NONE', 2, 'HASH', 3, 'SYSTEM',
                                      4, 'LIST', 'UNKNOWN'),
       po.partcnt, mod(trunc(po.spare2/65536), 65536),
       po.partkeycols, mod(trunc(po.spare2/256), 256),
       decode(bitand(po.flags, 1), 1, 'LOCAL',    'GLOBAL'),
       decode(po.partkeycols, 0, 'NONE', decode(bitand(po.flags,2), 2, 'PREFIXED', 'NON_PREFIXED')),
       ts.name, po.defpctfree, po.definitrans,
       po.defmaxtrans,
       decode(po.deftiniexts, NULL, 'DEFAULT', po.deftiniexts),
       decode(po.defextsize, NULL, 'DEFAULT', po.defextsize),
       decode(po.defminexts, NULL, 'DEFAULT', po.defminexts),
       decode(po.defmaxexts, NULL, 'DEFAULT', po.defmaxexts),
       decode(po.defextpct, NULL, 'DEFAULT', po.defextpct),
       po.deflists, po.defgroups,
       decode(po.deflogging, 0, 'NONE', 1, 'YES', 2, 'NO', 'UNKNOWN'),
       decode(po.spare1, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL),
       po.parameters
from   sys.obj$ io, sys.obj$ o, sys.partobj$ po, sys.ts$ ts, sys.ind$ i,
       sys.user$ u
where  io.obj# = po.obj# and po.defts# = ts.ts# (+) and
       i.obj# = io.obj# and o.obj# = i.bo# and u.user# = io.owner# and
       i.type# != 8 and      /* not LOB index */
       (io.owner# = userenv('SCHEMAID')
        or
        i.bo# in ( select obj#
                    from objauth$
                    where grantee# in ( select kzsrorol
                                        from x$kzsro
                                      )
                   )
        or
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
       );

CREATE OR REPLACE FORCE VIEW "ALL_PART_KEY_COLUMNS"("OWNER",
select u.name, o.name, 'TABLE',
  decode(bitand(c.property, 1), 1, a.name, c.name), pc.pos#
from partcol$ pc, obj$ o, col$ c, user$ u, attrcol$ a
where pc.obj# = o.obj# and pc.obj# = c.obj# and c.intcol# = pc.intcol# and
      c.obj#    = a.obj#(+) and c.intcol# = a.intcol#(+) and
      u.user# = o.owner# and
      (o.owner# = userenv('SCHEMAID')
       or pc.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
union
select u.name, io.name, 'INDEX',
  decode(bitand(c.property, 1), 1, a.name, c.name), pc.pos#
from partcol$ pc, obj$ io, col$ c, user$ u, ind$ i, attrcol$ a
where pc.obj# = i.obj# and i.obj# = io.obj# and i.bo# = c.obj# and
     c.intcol# = pc.intcol# and u.user# = io.owner# and
     c.obj# = a.obj#(+) and c.intcol# = a.intcol#(+) and
      (io.owner# = userenv('SCHEMAID')
       or i.bo# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_PART_LOBS"("TABLE_OWNER",
select u.name,
       o.name,
       decode(bitand(c.property, 1), 1, a.name, c.name),
       lo.name,
       io.name,
       plob.defchunk,
       plob.defpctver$,
       decode(bitand(plob.defflags, 27), 1, 'NO', 2, 'NO', 8, 'CACHEREADS',
                                         16, 'CACHEREADS', 'YES'),
       decode(plob.defpro, 0, 'NO', 'YES'),
       ts.name,
       decode(plob.definiexts, NULL, 'DEFAULT', plob.definiexts),
       decode(plob.defextsize, NULL, 'DEFAULT', plob.defextsize),
       decode(plob.defminexts, NULL, 'DEFAULT', plob.defminexts),
       decode(plob.defmaxexts, NULL, 'DEFAULT', plob.defmaxexts),
       decode(plob.defextpct,  NULL, 'DEFAULT', plob.defextpct),
       decode(plob.deflists,   NULL, 'DEFAULT', plob.deflists),
       decode(plob.defgroups,  NULL, 'DEFAULT', plob.defgroups),
       decode(bitand(plob.defflags,22), 0,'NONE', 4,'YES', 2,'NO',
                                        16,'NO', 'UNKNOWN'),
       decode(plob.defbufpool, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL)
from   sys.obj$ o, sys.col$ c, sys.lob$ l, sys.partlob$ plob,
       sys.obj$ lo, sys.obj$ io, sys.ts$ ts, sys.user$ u, attrcol$ a
where o.owner# = u.user#
  and o.obj# = c.obj#
  and c.obj# = l.obj#
  and c.intcol# = l.intcol#
  and l.lobj# = lo.obj#
  and l.ind# = io.obj#
  and l.lobj# = plob.lobj#
  and plob.defts# = ts.ts# (+)
  and bitand(c.property,32768) != 32768           /* not unused column */
  and c.obj# = a.obj#(+) and c.intcol# = a.intcol#(+)
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_PART_TABLES"("OWNER",
select u.name, o.name,
       decode(po.parttype, 1, 'RANGE', 2, 'HASH', 3, 'SYSTEM', 4, 'LIST',
                                                                  'UNKNOWN'),
       decode(mod(po.spare2, 256), 0, 'NONE', 2, 'HASH', 3, 'SYSTEM',
                                      4, 'LIST', 'UNKNOWN'),
       po.partcnt, mod(trunc(po.spare2/65536), 65536), po.partkeycols,
       mod(trunc(po.spare2/256), 256),
       ts.name, po.defpctfree,
       decode(bitand(ts.flags, 32), 32, to_number(NULL), po.defpctused),
       po.definitrans,
       po.defmaxtrans,
       decode(po.deftiniexts, NULL, 'DEFAULT', po.deftiniexts),
       decode(po.defextsize, NULL, 'DEFAULT', po.defextsize),
       decode(po.defminexts, NULL, 'DEFAULT', po.defminexts),
       decode(po.defmaxexts, NULL, 'DEFAULT', po.defmaxexts),
       decode(po.defextpct, NULL, 'DEFAULT', po.defextpct),
       decode(bitand(ts.flags, 32), 32, to_number(NULL), po.deflists),
       decode(bitand(ts.flags, 32), 32,  to_number(NULL),po.defgroups),
       decode(po.deflogging, 0, 'NONE', 1, 'YES', 2, 'NO', 'UNKNOWN'),
       decode(mod(trunc(po.spare2/4294967296),256), 0, 'NONE', 1, 'ENABLED',
                     2, 'DISABLED', 'UNKNOWN'),
       decode(po.spare1, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL)
from   sys.obj$ o, sys.partobj$ po, sys.ts$ ts, sys.tab$ t, sys.user$ u
where  o.obj# = po.obj# and po.defts# = ts.ts# and t.obj# = o.obj# and
       o.owner# = u.user# and
       bitand(t.property, 64 + 128) = 0 and
       (o.owner# = userenv('SCHEMAID')
        or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
        or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
union all -- NON-IOT and IOT
select u.name, o.name,
       decode(po.parttype, 1, 'RANGE', 2, 'HASH', 3, 'SYSTEM', 4, 'LIST',
                                                                  'UNKNOWN'),
       decode(mod(po.spare2, 256), 0, 'NONE', 2, 'HASH', 3, 'SYSTEM',
                                      4, 'LIST', 'UNKNOWN'),
       po.partcnt, mod(trunc(po.spare2/65536), 65536), po.partkeycols,
       mod(trunc(po.spare2/256), 256),
       NULL, TO_NUMBER(NULL),TO_NUMBER(NULL),TO_NUMBER(NULL),TO_NUMBER(NULL),
       NULL,--decode(po.deftiniexts, NULL, 'DEFAULT', po.deftiniexts),
       NULL,--decode(po.defextsize, NULL, 'DEFAULT', po.defextsize),
       NULL,--decode(po.defminexts, NULL, 'DEFAULT', po.defminexts),
       NULL,--decode(po.defmaxexts, NULL, 'DEFAULT', po.defmaxexts),
       NULL,--decode(po.defextpct, NULL, 'DEFAULT', po.defextpct),
       TO_NUMBER(NULL),TO_NUMBER(NULL),--po.deflists, po.defgroups,
       decode(po.deflogging, 0, 'NONE', 1, 'YES', 2, 'NO', 'UNKNOWN'),
       'N/A',
       decode(po.spare1, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL)
from   sys.obj$ o, sys.partobj$ po, sys.tab$ t, sys.user$ u
where  o.obj# = po.obj# and t.obj# = o.obj# and
       o.owner# = u.user# and
       bitand(t.property, 64 + 128) != 0 and
       (o.owner# = userenv('SCHEMAID')
        or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
        or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_PENDING_CONV_TABLES"("OWNER",
select u.name, o.name
from sys.obj$ o, user$ u
  where o.type# = 2 and o.status = 5
  and bitand(o.flags, 4096) = 4096  /* type evolved flg */
  and o.owner# = u.user#
  and (o.owner# = userenv('SCHEMAID')
       or
       o.obj# in (select oa.obj#
                  from sys.objauth$ oa
                  where grantee# in (select kzsrorol
                                     from x$kzsro))
       or /* user has system privileges */
       exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)));

CREATE OR REPLACE FORCE VIEW "ALL_PLSQL_OBJECT_SETTINGS"("OWNER",
select u.name, o.name,
decode(o.type#, 7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE',
                11, 'PACKAGE BODY', 12, 'TRIGGER',
                13, 'TYPE', 14, 'TYPE BODY', 'UNDEFINED'),
(select to_number(value) from settings$ s
  where s.obj# = o.obj# and param = 'plsql_optimize_level'),
(select value from settings$ s
  where s.obj# = o.obj# and param = 'plsql_code_type'),
(select value from settings$ s
  where s.obj# = o.obj# and param = 'plsql_debug'),
(select value from settings$ s
  where s.obj# = o.obj# and param = 'plsql_warnings'),
(select value from settings$ s
  where s.obj# = o.obj# and param = 'nls_length_semantics')
from sys.obj$ o, sys.user$ u
where o.owner# = u.user#
  and o.type# in (7, 8, 9, 11, 12, 13, 14)
  and
  (
    o.owner# in (userenv('SCHEMAID'), 1 /* PUBLIC */)
    or
    (
      /* EXECUTE privilege does not let user see package or type body */
      o.type# in (7, 8, 9, 12, 13)
      and
      o.obj# in (select obj# from sys.objauth$
                 where grantee# in (select kzsrorol from x$kzsro)
                   and privilege# = 12 /* EXECUTE */
                )
    )
    or
    (
       o.type# in (7, 8, 9) /* procedure, function, package */
       and
       exists (select null from v$enabledprivs
               where priv_number in (
                                      -144 /* EXECUTE ANY PROCEDURE */,
                                      -141 /* CREATE ANY PROCEDURE */
                                    )
              )
    )
    or
    (
      o.type# = 11 /* package body */
      and
      exists (select null from v$enabledprivs
              where priv_number = -141 /* CREATE ANY PROCEDURE */)
    )
    or
    (
       o.type# = 12 /* trigger */
       and
       exists (select null from v$enabledprivs
               where priv_number = -152 /* CREATE ANY TRIGGER */)
    )
    or
    (
      o.type# = 13 /* type */
      and
      exists (select null from v$enabledprivs
              where priv_number in (-184 /* EXECUTE ANY TYPE */,
                                    -181 /* CREATE ANY TYPE */))
    )
    or
    (
      o.type# = 14 /* type body */
      and
      exists (select null from v$enabledprivs
              where priv_number = -181 /* CREATE ANY TYPE */)
    )
  );

CREATE OR REPLACE FORCE VIEW "ALL_POLICIES"("OBJECT_OWNER",
SELECT OBJECT_OWNER, OBJECT_NAME, POLICY_GROUP, POLICY_NAME, PF_OWNER,
PACKAGE, FUNCTION, SEL, INS, UPD, DEL, IDX, CHK_OPTION, ENABLE, STATIC_POLICY,
POLICY_TYPE, LONG_PREDICATE
FROM DBA_POLICIES, ALL_TABLES t
WHERE
(OBJECT_OWNER = t.OWNER AND OBJECT_NAME = t.TABLE_NAME)
union all
SELECT OBJECT_OWNER, OBJECT_NAME, POLICY_GROUP, POLICY_NAME, PF_OWNER,
PACKAGE, FUNCTION, SEL, INS, UPD, DEL, IDX, CHK_OPTION, ENABLE, STATIC_POLICY,
POLICY_TYPE, LONG_PREDICATE
FROM DBA_POLICIES, ALL_VIEWS v
WHERE
(OBJECT_OWNER = v.OWNER AND OBJECT_NAME = v.VIEW_NAME )
union all
SELECT OBJECT_OWNER, OBJECT_NAME, POLICY_GROUP, POLICY_NAME, PF_OWNER,
PACKAGE, FUNCTION, SEL, INS, UPD, DEL, IDX, CHK_OPTION, ENABLE, STATIC_POLICY,
POLICY_TYPE, LONG_PREDICATE
FROM DBA_POLICIES, ALL_SYNONYMS s
WHERE
(OBJECT_OWNER = s.OWNER AND OBJECT_NAME = s.SYNONYM_NAME);

CREATE OR REPLACE FORCE VIEW "ALL_POLICY_CONTEXTS"("OBJECT_OWNER",
SELECT OBJECT_OWNER, OBJECT_NAME,NAMESPACE,ATTRIBUTE
FROM DBA_POLICY_CONTEXTS, ALL_TABLES t
WHERE
(OBJECT_OWNER = t.OWNER AND OBJECT_NAME = t.TABLE_NAME)
union all
SELECT OBJECT_OWNER, OBJECT_NAME,NAMESPACE,ATTRIBUTE
FROM DBA_POLICY_CONTEXTS, ALL_VIEWS v
WHERE
(OBJECT_OWNER = v.OWNER AND OBJECT_NAME = v.VIEW_NAME )
union all
SELECT OBJECT_OWNER, OBJECT_NAME,NAMESPACE,ATTRIBUTE
FROM DBA_POLICY_CONTEXTS, ALL_SYNONYMS s
WHERE
(OBJECT_OWNER = s.OWNER AND OBJECT_NAME = s.SYNONYM_NAME );

CREATE OR REPLACE FORCE VIEW "ALL_POLICY_GROUPS"("OBJECT_OWNER",
SELECT OBJECT_OWNER, OBJECT_NAME, POLICY_GROUP
FROM DBA_POLICY_GROUPS, ALL_TABLES t
WHERE
(OBJECT_OWNER = t.OWNER AND OBJECT_NAME = t.TABLE_NAME)
union all
SELECT OBJECT_OWNER, OBJECT_NAME, POLICY_GROUP
FROM DBA_POLICY_GROUPS, ALL_VIEWS v
WHERE
(OBJECT_OWNER = v.OWNER AND OBJECT_NAME = v.VIEW_NAME )
union all
SELECT OBJECT_OWNER, OBJECT_NAME, POLICY_GROUP
FROM DBA_POLICY_GROUPS, ALL_SYNONYMS s
WHERE
(OBJECT_OWNER = s.OWNER AND OBJECT_NAME = s.SYNONYM_NAME);

CREATE OR REPLACE FORCE VIEW "ALL_PROBE_OBJECTS"("OWNER",
SELECT DISTINCT all_objects."OWNER",all_objects."OBJECT_NAME",all_objects."SUBOBJECT_NAME",all_objects."OBJECT_ID",all_objects."DATA_OBJECT_ID",all_objects."OBJECT_TYPE",all_objects."CREATED",all_objects."LAST_DDL_TIME",all_objects."TIMESTAMP",all_objects."STATUS",all_objects."TEMPORARY",all_objects."GENERATED",all_objects."SECONDARY",
                   decode(idl_char$.part,null,'F',0,'F','T') debuginfo
   FROM   idl_char$, all_objects
   WHERE  all_objects.object_id = idl_char$.obj# (+)
   AND    (idl_char$.part IS NULL OR
            (idl_char$.part = 0         -- Diana
              AND NOT EXISTS (SELECT *
                              FROM   idl_char$
                              WHERE  all_objects.object_id = idl_char$.obj#
                              AND    idl_char$.part = 1))
           OR idl_char$.part = 1        -- PCode
           );

CREATE OR REPLACE FORCE VIEW "ALL_PROCEDURES"("OWNER",
select u.name, o.name, pi.procedurename,
decode(bitand(pi.properties,8),8,'YES','NO'),
decode(bitand(pi.properties,16),16,'YES','NO'),
u2.name, o2.name,
  decode(bitand(pi.properties,32),32,'YES','NO'),
  decode(bitand(pi.properties,512),512,'YES','NO'),
decode(bitand(pi.properties,256),256,'YES','NO'),
decode(bitand(pi.properties,1024),1024,'CURRENT_USER','DEFINER')
from obj$ o, user$ u, procedureinfo$ pi, obj$ o2, user$ u2
where u.user# = o.owner# and o.obj# = pi.obj#
and pi.itypeobj# = o2.obj# (+) and o2.owner#  = u2.user# (+)
and (o.owner# = userenv('SCHEMAID')
     or exists
      (select null from v$enabledprivs where priv_number in (-144,-141))
     or o.obj# in (select obj# from sys.objauth$ where grantee# in
      (select kzsrorol from x$kzsro) and privilege# = 12));

CREATE OR REPLACE FORCE VIEW "ALL_PROPAGATION"("PROPAGATION_NAME",
SELECT p.propagation_name, p.source_queue_schema, p.source_queue,
       p.destination_queue_schema, p.destination_queue, p.destination_dblink,
       p.ruleset_schema, p.ruleset, p.negative_ruleset_schema,
        p.negative_ruleset
FROM   sys.streams$_propagation_process p, all_queues q
WHERE p.source_queue_schema = q.owner
   AND p.source_queue = q.name
   AND ((p.ruleset_schema IS NULL and p.ruleset IS NULL) OR
        ((p.ruleset_schema, p.ruleset) IN
          (SELECT r.rule_set_owner, r.rule_set_name
             FROM all_rule_sets r)))
   AND ((p.negative_ruleset_schema IS NULL AND
         p.negative_ruleset IS NULL) OR
        ((p.negative_ruleset_schema, p.negative_ruleset) IN
          (SELECT r.rule_set_owner, r.rule_set_name
             FROM all_rule_sets r)));

CREATE OR REPLACE FORCE VIEW "ALL_PUBLISHED_COLUMNS"("CHANGE_SET_NAME",
SELECT
   s.change_set_name, s.obj#, s.source_schema_name, s.source_table_name,
   c.column_name, c.data_type, c.data_length, c.data_precision, c.data_scale,
   c.nullable
  FROM sys.cdc_change_tables$ s, all_tables t, all_tab_columns c
  WHERE s.change_table_schema=t.owner AND
        s.change_table_name=t.table_name AND
        c.owner=s.change_table_schema AND
        c.table_name=s.change_table_name AND
        c.column_name NOT LIKE '%$';

CREATE OR REPLACE FORCE VIEW "ALL_QUEUES"("OWNER",
select u.name OWNER, q.name NAME, t.name QUEUE_TABLE, q.eventid QID,
       decode(q.usage, 1, 'EXCEPTION_QUEUE', 2, 'NON_PERSISTENT_QUEUE',
              'NORMAL_QUEUE') QUEUE_TYPE,
       q.max_retries MAX_RETRIES, q.retry_delay RETRY_DELAY,
       decode(bitand(q.enable_flag, 1), 1 , '  YES  ', '  NO  ')ENQUEUE_ENABLED,
       decode(bitand(q.enable_flag, 2), 2 , '  YES  ', '  NO  ')DEQUEUE_ENABLED,
       decode(q.ret_time, -1, ' FOREVER', q.ret_time) RETENTION,
       substr(q.queue_comment, 1, 50) USER_COMMENT
from system.aq$_queues q, system.aq$_queue_tables t, sys.user$ u, sys.obj$ ro
where u.name  = t.schema
and   q.table_objno = t.objno
and   ro.owner# = u.user#
and   ro.obj# = q.eventid
and  (ro.owner# = userenv('SCHEMAID')
      or ro.obj# in
           (select oa.obj#
            from sys.objauth$ oa
            where grantee# in (select kzsrorol from x$kzsro))
      or exists (select null from v$enabledprivs
                 where priv_number in (-218 /* MANAGE ANY QUEUE */,
                                       -219 /* ENQUEUE ANY QUEUE */,
                                       -220 /* DEQUEUE ANY QUEUE */))
      or ro.obj# in
           (select q.eventid from system.aq$_queues q,
                                  system.aq$_queue_tables t
              where q.table_objno = t.objno
              and bitand(t.flags, 8) = 0
              and exists (select null from sys.objauth$ oa, sys.obj$ o
                          where oa.obj# = o.obj#
                          and (o.name = 'DBMS_AQ' or o.name = 'DBMS_AQADM')
                          and o.type# = 9
                          and oa.grantee# = userenv('SCHEMAID')))
     );

CREATE OR REPLACE FORCE VIEW "ALL_QUEUE_PUBLISHERS"("QUEUE_OWNER",
select t.schema QUEUE_OWNER, q.name QUEUE_NAME,
        p.p_name PUBLISHER_NAME, p.p_address PUBLISHER_ADDRESS,
        p.p_protocol PUBLISHER_PROTOCOL, p.p_rule PUBLISHER_RULE,
        p.p_rule_name PUBLISHER_RULE_NAME, p.p_ruleset PUBLISHER_RULESET,
        p.p_transformation PUBLISHER_TRANSFORMATION
from
 system.aq$_queue_tables t,  system.aq$_queues q,
 sys.aq$_publisher p, sys.user$ u
where
 u.user# = USERENV('SCHEMAID') and
 u.name = t.schema and q.table_objno = t.objno
 and q.eventid = p.queue_id;

CREATE OR REPLACE FORCE VIEW "ALL_QUEUE_TABLES"("OWNER",
select t.schema OWNER, t.name QUEUE_TABLE,
     decode(t.udata_type, 1 , 'OBJECT', 2, 'VARIANT', 3, 'RAW') TYPE,
     u.name || '.' || o.name OBJECT_TYPE,
     decode(t.sort_cols, 0, 'NONE', 1, 'PRIORITY', 2, 'ENQUEUE_TIME',
                               3, 'PRIORITY, ENQUEUE_TIME',
                               7, 'ENQUEUE_TIME, PRIORITY') SORT_ORDER,
     decode(bitand(t.flags, 1), 1, 'MULTIPLE', 0, 'SINGLE') RECIPIENTS,
     decode(bitand(t.flags, 2), 2, 'TRANSACTIONAL', 0, 'NONE')MESSAGE_GROUPING,
     decode(bitand(t.flags, 8), 8, '8.1.3', 0, '8.0.3')COMPATIBLE,
     aft.primary_instance PRIMARY_INSTANCE,
     aft.secondary_instance SECONDARY_INSTANCE,
     aft.owner_instance OWNER_INSTANCE,
     substr(t.table_comment, 1, 50) USER_COMMENT,
     decode(bitand(t.flags, 4096), 4096, 'YES', 0, 'NO') SECURE
from system.aq$_queue_tables t, sys.col$ c, sys.coltype$ ct, sys.obj$ o,
sys.user$ u, sys.aq$_queue_table_affinities aft
where c.intcol# = ct.intcol#
and c.obj# = ct.obj#
and c.name = 'USER_DATA'
and t.objno = c.obj#
and o.oid$ = ct.toid
and o.type# = 13
and o.owner# = u.user#
and t.objno = aft.table_objno
and t.objno in
(select q.table_objno
 from system.aq$_queues q, sys.obj$ ro
 where ro.obj# = q.eventid
 and (ro.owner# = userenv('SCHEMAID')
      or ro.obj# in
           (select oa.obj#
            from sys.objauth$ oa
            where grantee# in (select kzsrorol from x$kzsro))
      or exists (select null from v$enabledprivs
                 where priv_number in (-218 /* MANAGE ANY QUEUE */,
                                       -219 /* ENQUEUE ANY QUEUE */,
                                       -220 /* DEQUEUE ANY QUEUE */))
      or ro.obj# in
           (select q.eventid from system.aq$_queues q,
                                  system.aq$_queue_tables t
              where q.table_objno = t.objno
              and bitand(t.flags, 8) = 0
              and exists (select null from sys.objauth$ oa, sys.obj$ o
                          where oa.obj# = o.obj#
                          and (o.name = 'DBMS_AQ' or o.name = 'DBMS_AQADM')
                          and o.type# = 9
                          and oa.grantee# = userenv('SCHEMAID')))
     )
)
union
select t.schema OWNER, t.name QUEUE_TABLE,
     decode(t.udata_type, 1 , 'OBJECT', 2, 'VARIANT', 3, 'RAW') TYPE,
     null OBJECT_TYPE,
     decode(t.sort_cols, 0, 'NONE', 1, 'PRIORITY', 2, 'ENQUEUE_TIME',
                               3, 'PRIORITY, ENQUEUE_TIME',
                               7, 'ENQUEUE_TIME, PRIORITY') SORT_ORDER,
     decode(bitand(t.flags, 1), 1, 'MULTIPLE', 0, 'SINGLE') RECIPIENTS,
     decode(bitand(t.flags, 2), 2, 'TRANSACTIONAL', 0, 'NONE')MESSAGE_GROUPING,
     decode(bitand(t.flags, 8), 8, '8.1.3', 0, '8.0.3')COMPATIBLE,
     aft.primary_instance PRIMARY_INSTANCE,
     aft.secondary_instance SECONDARY_INSTANCE,
     aft.owner_instance OWNER_INSTANCE,
     substr(t.table_comment, 1, 50) USER_COMMENT,
     decode(bitand(t.flags, 4096), 4096, 'YES', 0, 'NO') SECURE
from system.aq$_queue_tables t, sys.aq$_queue_table_affinities aft
where (t.udata_type = 2
or t.udata_type = 3)
and t.objno = aft.table_objno
and t.objno in
(select q.table_objno
 from system.aq$_queues q, sys.obj$ ro
 where ro.obj# = q.eventid
 and (ro.owner# = userenv('SCHEMAID')
      or ro.obj# in
           (select oa.obj#
            from sys.objauth$ oa
            where grantee# in (select kzsrorol from x$kzsro))
      or exists (select null from v$enabledprivs
                 where priv_number in (-218 /* MANAGE ANY QUEUE */,
                                       -219 /* ENQUEUE ANY QUEUE */,
                                       -220 /* DEQUEUE ANY QUEUE */))
      or ro.obj# in
           (select q.eventid from system.aq$_queues q,
                                  system.aq$_queue_tables t
              where q.table_objno = t.objno
              and bitand(t.flags, 8) = 0
              and exists (select null from sys.objauth$ oa, sys.obj$ o
                          where oa.obj# = o.obj#
                          and (o.name = 'DBMS_AQ' or o.name = 'DBMS_AQADM')
                          and o.type# = 9
                          and oa.grantee# = userenv('SCHEMAID')))
     )
);

CREATE OR REPLACE FORCE VIEW "ALL_REFRESH"("ROWNER",
select "ROWNER",
  ( rowner = (select name from sys.user$ where user# = userenv('SCHEMAID')))
  or userenv('SCHEMAID') = 0 or exists
  (select kzsrorol
     from x$kzsro x, sys.system_privilege_map m, sys.sysauth$ s
     where x.kzsrorol = s.grantee# and
           s.privilege# = m.privilege and
           m.name = 'ALTER ANY MATERIALIZED VIEW');

CREATE OR REPLACE FORCE VIEW "ALL_REFRESH_CHILDREN"("OWNER",
select "OWNER",
 ( rowner = (select name from sys.user$ where user# = userenv('SCHEMAID')))
  or userenv('SCHEMAID') = 0 or exists
  (select kzsrorol
     from x$kzsro x, sys.system_privilege_map m, sys.sysauth$ s
     where x.kzsrorol = s.grantee# and
           s.privilege# = m.privilege and
           m.name = 'ALTER ANY MATERIALIZED VIEW');

CREATE OR REPLACE FORCE VIEW "ALL_REFRESH_DEPENDENCIES"("OWNER",
select u.name, o.name, 'MATERIALIZED VIEW', dep.lastrefreshscn,
       dep.lastrefreshdate
from (select dt.obj#,
             min(dt.lastrefreshscn) as lastrefreshscn,
             min(dt.lastrefreshdate) as lastrefreshdate
      from
           (select d.p_obj# as obj#, s.lastrefreshscn, s.lastrefreshdate
            from sumdep$ d, sum$ s, obj$ do
            where d.sumobj# = s.obj#
              and d.sumobj# = do.obj#
              and do.type# IN (4, 42)
            union
            select sl.tableobj# as obj#,
                   decode(0, 1, 2, NULL) as lastrefreshscn,
                   sl.oldest  as lastrefreshdate
            from snap_loadertime$ sl) dt
      group by dt.obj#) dep, obj$ o, user$ u
where o.obj# = dep.obj#
  and o.owner# = u.user#
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in (select oa.obj# from sys.objauth$ oa
                     where grantee# in (select kzsrorol from x$kzsro)
                    )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
       );

CREATE OR REPLACE FORCE VIEW "ALL_REFS"("OWNER",
select distinct u.name, o.name,
       decode(bitand(c.property, 1), 1, ac.name, c.name),
       decode(bitand(rc.reftyp, 2), 2, 'YES', 'NO'),
       decode(bitand(rc.reftyp, 1), 1, 'YES', 'NO'),
       su.name, so.name,
       case
         when bitand(reftyp,4) = 4 then 'USER-DEFINED'
         when bitand(reftyp, 8) = 8 then 'SYSTEM GENERATED AND USER-DEFINED'
         else 'SYSTEM GENERATED'
       end
from sys.user$ u, sys.obj$ o, sys.col$ c, sys.refcon$ rc, sys.obj$ so,
     sys.user$ su, sys.attrcol$ ac
where o.owner# = u.user#
  and o.obj# = c.obj#
  and c.obj# = rc.obj#
  and c.col# = rc.col#
  and c.intcol# = rc.intcol#
  and rc.stabid = so.oid$(+)
  and so.owner# = su.user#(+)
  and c.obj# = ac.obj#(+)
  and c.intcol# = ac.intcol#(+)
  and bitand(c.property,32768) != 32768           /* not unused column */
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_REGISTERED_MVIEWS"("OWNER",
select  "OWNER",
where exists (select a.mview_id from all_base_table_mviews a
                             where  s.mview_id = a.mview_id)
or  userenv('SCHEMAID') = 1
or  exists (select null from v$enabledprivs
            where priv_number  in (-45 /* LOCK ANY TABLE */,
                                   -47 /* SELECT ANY TABLE */,
                                   -48 /* INSERT ANY TABLE  */,
                                   -49 /* UPDATE ANY TABLE */,
                                   -50 /* DELETE ANY TABLE */)
            );

CREATE OR REPLACE FORCE VIEW "ALL_REGISTERED_SNAPSHOTS"("OWNER",
select  "OWNER",
where exists (select a.snapshot_id from  all_snapshot_logs a
                             where  s.snapshot_id = a.snapshot_id)
or  userenv('SCHEMAID') = 1
or  exists (select null from v$enabledprivs
            where priv_number  in (-45 /* LOCK ANY TABLE */,
                                   -47 /* SELECT ANY TABLE */,
                                   -48 /* INSERT ANY TABLE  */,
                                   -49 /* UPDATE ANY TABLE */,
                                   -50 /* DELETE ANY TABLE */)
            );

CREATE OR REPLACE FORCE VIEW "ALL_REGISTRY_BANNERS"("BANNER") AS 
SELECT banner FROM registry$
WHERE status = 1;

CREATE OR REPLACE FORCE VIEW "ALL_REPAUDIT_ATTRIBUTE"("ATTRIBUTE",
select
    attribute,
    decode(data_type_id,
           1, 'NUMBER',
           2, 'VARCHAR2',
           3, 'DATE',
           4, 'CHAR',
           5, 'RAW',
           6, 'NVARCHAR2',
           7, 'NCHAR',
           'UNDEFINED'),
    data_length,
    source
from  system.repcat$_audit_attribute;

CREATE OR REPLACE FORCE VIEW "ALL_REPAUDIT_COLUMN"("SNAME",
select
    sname,
    oname,
    column_name,
    base_sname,
    base_oname,
    decode(base_conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    base_reference_name,
    attribute
from  system.repcat$_audit_column,
     sys.user$ u, sys.obj$ o
where sname = u.name
  and oname = o.name
  and o.owner# = u.user#
  and o.type# = 2 /* tables */
  and (o.owner# = userenv('SCHEMAID')
        or
       o.obj# in ( select obj#
                   from objauth$
                   where grantee# in ( select kzsrorol
                                       from x$kzsro
                                     )
                  )
        or
	 exists (select null from v$enabledprivs
	         where priv_number in (-45 /* LOCK ANY TABLE */,
				       -47 /* SELECT ANY TABLE */,
				       -48 /* INSERT ANY TABLE */,
				       -49 /* UPDATE ANY TABLE */,
				       -50 /* DELETE ANY TABLE */)
                 )
       );

CREATE OR REPLACE FORCE VIEW "ALL_REPCAT"("SNAME",
select "SNAME",

CREATE OR REPLACE FORCE VIEW "ALL_REPCATLOG"("ID",
select r.id, r.source, r.userid, r.timestamp, r.role, r.master, r.sname,
  r.request, r.oname, r.type, r.status, r.message, r.errnum, r.gname
from repcat_repcatlog r, all_objects o
where (r.sname = 'PUBLIC' or r.sname in (select u.username from all_users u))
  and r.sname = o.owner
  and r.oname = o.object_name
  and r.type = o.object_type
union
select r.id, r.source, r.userid, r.timestamp, r.role, r.master, r.sname,
  r.request, r.oname, r.type, r.status, r.message, r.errnum, r.gname
from user_repcatlog r;

CREATE OR REPLACE FORCE VIEW "ALL_REPCAT_REFRESH_TEMPLATES"("REFRESH_TEMPLATE_NAME",
select refresh_template_name,owner,refresh_group_name,template_comment,
 nvl(public_template,'N') public_template
from system.repcat$_refresh_templates rt,
  system.repcat$_template_types tt
where public_template = 'Y'
and rt.template_type_id = tt.template_type_id
and bitand(rawtohex(tt.flags),1) = 1
union
select refresh_template_name,owner,refresh_group_name,template_comment,
 nvl(public_template,'N') public_template
from system.repcat$_refresh_templates rt,
  system.repcat$_user_authorizations at,
  sys.all_users au,
  system.repcat$_template_types tt
where at.refresh_template_id = rt.refresh_template_id
and rt.template_type_id = tt.template_type_id
and bitand(rawtohex(tt.flags),1) = 1
and au.user_id = at.user_id
and nvl(rt.public_template,'N') = 'N'
and au.user_id = userenv('SCHEMAID')
union
select refresh_template_name,owner,refresh_group_name,template_comment,
 nvl(public_template,'N') public_template
from system.repcat$_refresh_templates rt,
  system.repcat$_template_types tt
where nvl(rt.public_template,'N') = 'N'
and rt.template_type_id = tt.template_type_id
and bitand(rawtohex(tt.flags),1) = 1
and exists
  (select 1 from v$enabledprivs
   where priv_number in (-174 /* alter any snapshot */))
union
select refresh_template_name,owner,refresh_group_name,template_comment,
 nvl(public_template,'N') public_template
from system.repcat$_refresh_templates rt,
  system.repcat$_template_types tt, sys.user$ u
where  nvl(rt.public_template,'N') = 'N'
and rt.template_type_id = tt.template_type_id
and bitand(rawtohex(tt.flags),1) = 1
and rt.owner = u.name
and u.user# = userenv('SCHEMAID');

CREATE OR REPLACE FORCE VIEW "ALL_REPCAT_TEMPLATE_OBJECTS"("REFRESH_TEMPLATE_NAME",
select rt.refresh_template_name,
t.object_name, ot.object_type_name object_type,
t.ddl_num, t.ddl_text,t.master_rollback_seg,
t.derived_from_sname,t.derived_from_oname,t.flavor_id
from system.repcat$_refresh_templates rt,
  system.repcat$_template_objects t,
  system.repcat$_object_types ot,
  system.repcat$_template_types tt
where t.refresh_template_id = rt.refresh_template_id
and  ot.object_type_id = t.object_type
and rt.template_type_id = tt.template_type_id
and bitand(rawtohex(tt.flags),1) = 1
and rt.refresh_template_id in
  (select rt.refresh_template_id
  from system.repcat$_refresh_templates
  where public_template = 'Y'
  union
  select rt.refresh_template_id
  from system.repcat$_refresh_templates rt,
  system.repcat$_user_authorizations at,
  sys.all_users au
  where at.refresh_template_id = rt.refresh_template_id
  and au.user_id = at.user_id
  and nvl(rt.public_template,'N') = 'N'
  and au.user_id = userenv('SCHEMAID')
  union
  select rt.refresh_template_id
  from system.repcat$_refresh_templates rt
  where nvl(rt.public_template,'N') = 'N'
  and exists
    (select 1 from v$enabledprivs
     where priv_number in (-174 /* alter any snapshot */))
  union
  select rt.refresh_template_id
  from system.repcat$_refresh_templates rt, sys.user$ u
  where  nvl(rt.public_template,'N') = 'N'
  and rt.owner =  u.name
  and u.user#  = userenv('SCHEMAID'));

CREATE OR REPLACE FORCE VIEW "ALL_REPCAT_TEMPLATE_PARMS"("REFRESH_TEMPLATE_NAME",
select rt.refresh_template_name,rt.owner,
rt.refresh_group_name,rt.template_comment,
nvl(rt.public_template,'N'),tp.parameter_name,
tp.default_parm_value, tp.prompt_string, tp.user_override
from system.repcat$_refresh_templates rt,
  system.repcat$_template_parms tp,
  system.repcat$_template_types tt
where tp.refresh_template_id = rt.refresh_template_id
and rt.template_type_id = tt.template_type_id
and bitand(rawtohex(tt.flags),1) = 1
and rt.refresh_template_id in
  (select rt.refresh_template_id
  from system.repcat$_refresh_templates
  where public_template = 'Y'
  union
  select rt.refresh_template_id
  from system.repcat$_refresh_templates rt,
  system.repcat$_user_authorizations at,
  sys.all_users au
  where at.refresh_template_id = rt.refresh_template_id
  and au.user_id = at.user_id
  and nvl(rt.public_template,'N') = 'N'
  and au.user_id = userenv('SCHEMAID')
  union
  select rt.refresh_template_id
  from system.repcat$_refresh_templates rt
  where nvl(rt.public_template,'N') = 'N'
  and exists
    (select 1 from v$enabledprivs
     where priv_number in (-174 /* alter any snapshot */))
  union
  select rt.refresh_template_id
  from system.repcat$_refresh_templates rt, sys.user$ u
  where  nvl(rt.public_template,'N') = 'N'
  and rt.owner = u.name
  and u.user#  = userenv('SCHEMAID') );

CREATE OR REPLACE FORCE VIEW "ALL_REPCAT_TEMPLATE_SITES"("REFRESH_TEMPLATE_NAME",
select ts.refresh_template_name, ts.refresh_group_name, ts.template_owner,
  ts.user_name,ts.site_name,ss.site_name,
  decode(status,-1,'DELETED',0,'INSTALLING',1,'INSTALLED','UNDEFINED'),
  instantiation_date
from system.repcat$_template_sites ts,
  sys.snap_site$ ss,
  system.repcat$_refresh_templates rt,
  system.repcat$_template_types tt
where ts.repapi_site_id = ss.site_id (+)
and ts.status != -100
and rt.refresh_template_name = ts.refresh_template_name
and rt.template_type_id = tt.template_type_id
and bitand(rawtohex(tt.flags),1) = 1
and rt.refresh_template_id in
  (select rt.refresh_template_id
  from system.repcat$_refresh_templates
  where public_template = 'Y'
  union
  select rt.refresh_template_id
  from system.repcat$_refresh_templates rt,
  system.repcat$_user_authorizations at,
  sys.all_users au
  where at.refresh_template_id = rt.refresh_template_id
  and au.user_id = at.user_id
  and nvl(rt.public_template,'N') = 'N'
  and au.user_id = userenv('SCHEMAID')
  union
  select rt.refresh_template_id
  from system.repcat$_refresh_templates rt
  where nvl(rt.public_template,'N') = 'N'
  and exists
    (select 1 from v$enabledprivs
     where priv_number in (-174 /* alter any snapshot */))
  union
  select rt.refresh_template_id
  from system.repcat$_refresh_templates rt, sys.user$ u
  where  nvl(rt.public_template,'N') = 'N'
  and rt.owner =  u.name
  and u.user#  = userenv('SCHEMAID'));

CREATE OR REPLACE FORCE VIEW "ALL_REPCAT_USER_AUTHORIZATIONS"("REFRESH_TEMPLATE_NAME",
select rt.refresh_template_name,rt.owner,rt.refresh_group_name,
rt.template_comment, nvl(rt.public_template,'N'),
u.username
from system.repcat$_refresh_templates rt,
  all_users u,
  system.repcat$_user_authorizations ra,
  system.repcat$_template_types tt
where u.user_id = ra.user_id
and ra.refresh_template_id = rt.refresh_template_id
and rt.template_type_id = tt.template_type_id
and bitand(rawtohex(tt.flags),1) = 1
and rt.refresh_template_id in
  (select rt.refresh_template_id
  from system.repcat$_refresh_templates
  where public_template = 'Y'
  union
  select rt.refresh_template_id
  from system.repcat$_refresh_templates rt,
  system.repcat$_user_authorizations at,
  sys.all_users au
  where at.refresh_template_id = rt.refresh_template_id
  and au.user_id = at.user_id
  and nvl(rt.public_template,'N') = 'N'
  and au.user_id = userenv('SCHEMAID')
  union
  select rt.refresh_template_id
  from system.repcat$_refresh_templates rt
  where nvl(rt.public_template,'N') = 'N'
  and exists
    (select 1 from v$enabledprivs
     where priv_number in (-174 /* alter any snapshot */))
  union
  select rt.refresh_template_id
  from system.repcat$_refresh_templates rt, sys.user$ u
  where  nvl(rt.public_template,'N') = 'N'
  and rt.owner =  u.name
  and u.user#  =  userenv('SCHEMAID'));

CREATE OR REPLACE FORCE VIEW "ALL_REPCAT_USER_PARM_VALUES"("REFRESH_TEMPLATE_NAME",
select rt.refresh_template_name,rt.owner,
rt.refresh_group_name,rt.template_comment,
nvl(rt.public_template,'N'),tp.parameter_name,
tp.default_parm_value, tp.prompt_string, sp.parm_value,
u.username
from system.repcat$_refresh_templates rt,
  system.repcat$_template_parms tp,
  system.repcat$_user_parm_values sp,
  dba_users  u,
  system.repcat$_template_types tt
where tp.refresh_template_id = rt.refresh_template_id
and tp.template_parameter_id = sp.template_parameter_id
and rt.template_type_id = tt.template_type_id
and bitand(rawtohex(tt.flags),1) = 1
and sp.user_id = u.user_id
and rt.refresh_template_id in
  (select rt.refresh_template_id
  from system.repcat$_refresh_templates
  where public_template = 'Y'
  union
  select rt.refresh_template_id
  from system.repcat$_refresh_templates rt,
  system.repcat$_user_authorizations at,
  sys.all_users au
  where at.refresh_template_id = rt.refresh_template_id
  and au.user_id = at.user_id
  and nvl(rt.public_template,'N') = 'N'
  and au.user_id = userenv('SCHEMAID')
  union
  select rt.refresh_template_id
  from system.repcat$_refresh_templates rt
  where nvl(rt.public_template,'N') = 'N'
  and exists
    (select 1 from v$enabledprivs
     where priv_number in (-174 /* alter any snapshot */))
  union
  select rt.refresh_template_id
  from system.repcat$_refresh_templates rt, sys.user$ u
  where  nvl(rt.public_template,'N') = 'N'
  and rt.owner =  u.name
  and u.user#  = userenv('SCHEMAID'));

CREATE OR REPLACE FORCE VIEW "ALL_REPCOLUMN"("SNAME",
select
 r.sname, r.oname, r.type, r.cname, r.id, r.pos, r.compare_old_on_delete,
 r.compare_old_on_update, r.send_old_on_delete, r.send_old_on_update,
 r.ctype, r.ctype_toid, r.ctype_owner, r.ctype_hashcode,
 r.ctype_mod, r.data_length, r.data_precision, r.data_scale, r.nullable,
 r.character_set_name, r.top, r.char_length, r.char_used
from all_tab_columns tc, sys.dba_repcolumn r
where r.sname = tc.owner
  and r.oname = tc.table_name
  and ((r.top IS NOT NULL AND r.top = tc.column_name) OR
       (r.top IS NULL AND r.cname = tc.column_name))
union
select
 r.sname, r.oname, r.type, r.cname, r.id, r.pos, r.compare_old_on_delete,
 r.compare_old_on_update, r.send_old_on_delete, r.send_old_on_update,
 r.ctype, r.ctype_toid, r.ctype_owner, r.ctype_hashcode,
 r.ctype_mod, r.data_length, r.data_precision, r.data_scale, r.nullable,
 r.character_set_name, r.top, r.char_length, r.char_used
from  "_ALL_REPL_NESTED_TABLE_NAMES" nt, sys.dba_repcolumn r
where r.sname = nt.owner
  and r.oname = nt.table_name;

CREATE OR REPLACE FORCE VIEW "ALL_REPCOLUMN_GROUP"("SNAME",
select
    c.sname,
    c.oname,
    c.group_name,
    c.group_comment
from system.repcat$_column_group c, all_repobject o
  where c.sname = o.sname and c.oname = o.oname
    and o.type in ('TABLE', 'SNAPSHOT');

CREATE OR REPLACE FORCE VIEW "ALL_REPCONFLICT"("SNAME",
select
    sname,
    oname,
    decode(conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    reference_name
from  system.repcat$_conflict,
      sys.user$ u, sys.obj$ o
where sname = u.name
  and oname = o.name
  and o.owner# = u.user#
  and o.type# = 2 /* tables */
  and (o.owner# = userenv('SCHEMAID')
        or
       o.obj# in ( select obj#
                   from objauth$
                   where grantee# in ( select kzsrorol
                                       from x$kzsro
                                     )
                  )
        or
	 exists (select null from v$enabledprivs
	         where priv_number in (-45 /* LOCK ANY TABLE */,
				       -47 /* SELECT ANY TABLE */,
				       -48 /* INSERT ANY TABLE */,
				       -49 /* UPDATE ANY TABLE */,
				       -50 /* DELETE ANY TABLE */)
                 )
       );

CREATE OR REPLACE FORCE VIEW "ALL_REPDDL"("LOG_ID",
select r.log_id, r.source, r.role, r.master, r.line, r.text, r.ddl_num
from system.repcat$_ddl r, all_repcatlog u
where r.log_id = u.id
  and r.source = u.source;

CREATE OR REPLACE FORCE VIEW "ALL_REPFLAVORS"("FLAVOR_ID",
select f.flavor_id, f.gname, f.fname, f.creation_date, u.name, f.published,
       f.gowner
from system.repcat$_flavors f, user$ u
where f.created_by = u.user# (+);

CREATE OR REPLACE FORCE VIEW "ALL_REPFLAVOR_COLUMNS"("FNAME",
SELECT fc.fname, fc.gname, fc.sname, fc.oname, fc.cname, fc.type, fc.pos,
         fc.group_owner, fc.type_toid, fc.type_owner,
         fc.type_hashcode, fc.type_mod, fc.top
    FROM dba_repflavor_columns fc, all_tab_columns tc
    WHERE fc.sname = tc.owner
      AND fc.oname = tc.table_name
      AND ((fc.top IS NOT NULL AND fc.top = tc.column_name) OR
           (fc.top IS NULL AND fc.cname = tc.column_name))
UNION
  SELECT fc.fname, fc.gname, fc.sname, fc.oname, fc.cname, fc.type, fc.pos,
         fc.group_owner, fc.type_toid, fc.type_owner,
         fc.type_hashcode, fc.type_mod, fc.top
    FROM dba_repflavor_columns fc, "_ALL_REPL_NESTED_TABLE_NAMES" nt
    WHERE fc.sname = nt.owner
      AND fc.oname = nt.table_name;

CREATE OR REPLACE FORCE VIEW "ALL_REPFLAVOR_OBJECTS"("FNAME",
SELECT UNIQUE fo.fname, fo.gname, fo.sname, fo.oname,
       fo.type, fo.group_owner
from dba_repflavor_objects fo, all_objects o
where fo.sname = o.owner
  and fo.oname = o.object_name
  and (fo.type = o.object_type OR
       fo.type = 'SNAPSHOT' and o.object_type IN ('VIEW', 'TABLE'));

CREATE OR REPLACE FORCE VIEW "ALL_REPGENERATED"("SNAME",
select r.sname, r.oname, r.type, r.base_sname, r.base_oname, r.base_type,
  r.package_prefix, r.procedure_prefix, r.distributed, r.reason
from repcat_generated r, all_users u, all_objects o
where r.base_sname = u.username
  and r.base_sname = o.owner
  and r.base_oname = o.object_name
  and (r.base_type = o.object_type
       or (r.base_type = 'SNAPSHOT'
           and o.object_type IN ('VIEW','TABLE')))
  and ((r.reason  = 'PROCEDURAL REPLICATION WRAPPER' and r.type != 'SYNONYM')
     or r.reason != 'PROCEDURAL REPLICATION WRAPPER')
union
select r.sname, r.oname, r.type, r.base_sname, r.base_oname, r.base_type,
  r.package_prefix, r.procedure_prefix, r.distributed, r.reason
from user_repgenerated r
union
select r.sname, r.oname, r.type, r.base_sname, r.base_oname,
		r.base_type, r.package_prefix, r.procedure_prefix,
		r.distributed, r.reason
from repcat_generated r, all_users u, repcat_repobject ro
where r.base_sname = u.username
and ((r.reason  = 'PROCEDURAL REPLICATION WRAPPER'
		and r.type != 'SYNONYM')
or r.reason != 'PROCEDURAL REPLICATION WRAPPER')
and r.sname = ro.sname
and r.oname = ro.oname
and r.type = ro.type
and (ro.gname, ro.gowner) in
(select nvl(rp.gname,ro.gname), nvl(rp.owner, ro.gowner)
	from user_repgroup_privileges rp
	where rp.proxy_snapadmin='Y');

CREATE OR REPLACE FORCE VIEW "ALL_REPGENOBJECTS"("SNAME",
select r.sname, r.oname, r.type, r.base_sname, r.base_oname, r.base_type,
  r.package_prefix, r.procedure_prefix, r.distributed, r.reason
from repcat_generated r, all_users u, all_objects o
where r.base_sname = u.username
  and r.base_sname = o.owner
  and r.base_oname = o.object_name
  and (r.base_type = o.object_type
       or (r.base_type = 'SNAPSHOT'
           and o.object_type IN ('VIEW','TABLE')))
union
select r.sname, r.oname, r.type, r.base_sname, r.base_oname, r.base_type,
  r.package_prefix, r.procedure_prefix, r.distributed, r.reason
from user_repgenobjects r
union
select r.sname, r.oname, r.type, r.base_sname, r.base_oname,
		r.base_type, r.package_prefix, r.procedure_prefix,
		r.distributed, r.reason
from repcat_generated r, all_users u, repcat_repobject ro
where r.base_sname = u.username
and r.base_sname = ro.sname
and r.base_oname = ro.oname
and r.base_type = ro.type
and (ro.gname, ro.gowner) in
(select nvl(rp.gname,ro.gname), nvl(rp.owner, ro.gowner)
	from user_repgroup_privileges rp
	where rp.proxy_snapadmin='Y');

CREATE OR REPLACE FORCE VIEW "ALL_REPGROUP"("SNAME",
select r.sname, r.master, r.status, r.schema_comment, r.sname, r.fname,
       r.rpc_processing_disabled, r.gowner
from repcat_repcat r;

CREATE OR REPLACE FORCE VIEW "ALL_REPGROUPED_COLUMN"("SNAME",
select
    g.sname,
    g.oname,
    g.group_name,
    g.column_name
from all_tab_columns tc, sys.dba_repgrouped_column g
where g.sname = tc.owner
  and g.oname = tc.table_name
  and g.column_name = tc.column_name
union
select
    g.sname,
    g.oname,
    g.group_name,
    g.column_name
from "_ALL_REPL_NESTED_TABLE_NAMES" nt, sys.dba_repgrouped_column g
where g.sname = nt.owner
  and g.oname = nt.table_name;

CREATE OR REPLACE FORCE VIEW "ALL_REPGROUP_PRIVILEGES"("USERNAME",
select u.username, rp.gname, rp.created,
       decode(bitand(rp.privilege, 1), 1, 'Y', 'N'),
       decode(bitand(rp.privilege, 2), 2, 'Y', 'N'),
       rp.gowner
from  system.repcat$_repgroup_privs rp, all_users u
where rp.username = u.username
  and u.user_id = userenv('SCHEMAID');

CREATE OR REPLACE FORCE VIEW "ALL_REPKEY_COLUMNS"("SNAME",
select r.sname, r.oname, r.col
from sys.dba_repkey_columns r, all_repobject ro
where r.sname = ro.sname
  and r.oname = ro.oname
  and ro.type IN ('TABLE', 'SNAPSHOT');

CREATE OR REPLACE FORCE VIEW "ALL_REPOBJECT"("SNAME",
select r.sname, r.oname, r.type, r.status, r.generation_status, r.id,
       r.object_comment, r.gname, r.min_communication,
       r.trigflag replication_trigger_exists, r.internal_package_exists,
       r.gowner, r.nested_table
from repcat_repobject r, all_objects o
where (r.sname = 'PUBLIC' or r.sname in (select u.username from all_users u))
  and r.sname = o.owner
  and r.oname = o.object_name
  and r.type != 'INTERNAL PACKAGE'
  and (r.type = o.object_type
       or (r.type = 'SNAPSHOT'
           and o.object_type IN ('VIEW','TABLE')))
union
select r.sname, r.oname, r.type, r.status, r.generation_status, r.id,
       r.object_comment, r.gname, r.min_communication,
       r.replication_trigger_exists, r.internal_package_exists, r.group_owner,
       r.nested_table
from user_repobject r
union
select r.sname, r.oname, r.type, r.status, r.generation_status,
       r.id, r.object_comment, r.gname, r.min_communication,
       r.trigflag replication_trigger_exists, r.internal_package_exists,
       r.gowner, r.nested_table
from repcat_repobject r
where (r.sname = 'PUBLIC' or r.sname in
        (select u.username from all_users u))
and (r.gname, r.gowner) in
(select nvl(rp.gname,r.gname), nvl(rp.owner, r.gowner)
	from user_repgroup_privileges rp
	where rp.proxy_snapadmin='Y');

CREATE OR REPLACE FORCE VIEW "ALL_REPPARAMETER_COLUMN"("SNAME",
select
    p.sname,
    p.oname,
    decode(p.conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    p.reference_name,
    p.sequence_no,
    r.method_name,
    r.function_name,
    r.priority_group,
    p.parameter_table_name,
    decode(method_name, 'USER FUNCTION', NVL(rc.top, rc.lcname),
                        'USER FLAVOR FUNCTION', NVL(rc.top, rc.lcname),
           rc.lcname),
    p.parameter_sequence_no
from  system.repcat$_parameter_column p,
      system.repcat$_resolution r,
      system.repcat$_repcolumn rc,
      all_tab_columns tc
where p.sname = r.sname
and   p.oname = r.oname
and   p.conflict_type_id = r.conflict_type_id
and   p.reference_name = r.reference_name
and   p.sequence_no = r.sequence_no
and   p.oname = p.parameter_table_name
and   p.attribute_sequence_no = 1
and   p.sname = rc.sname
and   p.oname = rc.oname
and   p.column_pos = rc.pos
and   p.sname = tc.owner
and   p.oname = tc.table_name
and   ((rc.top is null and rc.lcname = tc.column_name) or
       (rc.top is not null and rc.top = tc.column_name))
union
  select p.sname, p.oname, p.conflict_type, p.reference_name, p.sequence_no,
         p.method_name, p.function_name, p.priority_group,
         p.parameter_table_name, p.parameter_column_name,
         p.parameter_sequence_no
from  "_ALL_REPL_NESTED_TABLE_NAMES" nt, dba_repparameter_column p
where p.sname = nt.owner
  and p.parameter_table_name = nt.table_name
  and p.oname = p.parameter_table_name;

CREATE OR REPLACE FORCE VIEW "ALL_REPPRIORITY"("SNAME",
select
    p.sname,
    p.priority_group,
    v.priority,
    decode(p.data_type_id,
           1, 'NUMBER',
           2, 'VARCHAR2',
           3, 'DATE',
           4, 'CHAR',
           5, 'RAW',
           6, 'NVARCHAR2',
           7, 'NCHAR',
           'UNDEFINED'),
    p.fixed_data_length,
    v.char_value,
    v.varchar2_value,
    v.number_value,
    v.date_value,
    v.raw_value,
    p.sname,
    v.nchar_value,
    v.nvarchar2_value,
    v.large_char_value
from  system.repcat$_priority v,
      system.repcat$_priority_group p
where v.sname = p.sname
and   v.priority_group = p.priority_group;

CREATE OR REPLACE FORCE VIEW "ALL_REPPRIORITY_GROUP"("SNAME",
select
    sname,
    priority_group,
    decode(data_type_id,
           1, 'NUMBER',
           2, 'VARCHAR2',
           3, 'DATE',
           4, 'CHAR',
           5, 'RAW',
           6, 'NVARCHAR2',
           7, 'NCHAR',
           'UNDEFINED'),
    fixed_data_length,
    priority_comment,
    sname
from  system.repcat$_priority_group;

CREATE OR REPLACE FORCE VIEW "ALL_REPPROP"("SNAME",
select r.sname, r.oname, r.type, r.dblink, r.how, r.propagate_comment
from repcat_repprop r, all_users u, all_repobject ro
where r.sname = u.username
  and r.sname = ro.sname
  and r.oname = ro.oname
  and r.type = ro.type
  and ro.type in ('PROCEDURE', 'PACKAGE', 'PACKAGE BODY', 'TABLE', 'SNAPSHOT');

CREATE OR REPLACE FORCE VIEW "ALL_REPRESOLUTION"("SNAME",
select
    sname,
    oname,
    decode(conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    reference_name,
    sequence_no,
    method_name,
    function_name,
    priority_group,
    resolution_comment
from  system.repcat$_resolution,
      sys.user$ u, sys.obj$ o
where sname = u.name
  and oname = o.name
  and o.owner# = u.user#
  and o.type# = 2 /* tables */
  and (o.owner# = userenv('SCHEMAID')
        or
       o.obj# in ( select obj#
                   from objauth$
                   where grantee# in ( select kzsrorol
                                       from x$kzsro
                                     )
                  )
        or
	 exists (select null from v$enabledprivs
	         where priv_number in (-45 /* LOCK ANY TABLE */,
				       -47 /* SELECT ANY TABLE */,
				       -48 /* INSERT ANY TABLE */,
				       -49 /* UPDATE ANY TABLE */,
				       -50 /* DELETE ANY TABLE */)
                 )
       );

CREATE OR REPLACE FORCE VIEW "ALL_REPRESOLUTION_METHOD"("CONFLICT_TYPE",
select
    decode(conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    method_name
from  system.repcat$_resolution_method;

CREATE OR REPLACE FORCE VIEW "ALL_REPRESOLUTION_STATISTICS"("SNAME",
select
    sname,
    oname,
    decode(conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    reference_name,
    method_name,
    decode(method_name,
           'USER FUNCTION', function_name,
           'USER FLAVOR FUNCTION', function_name,
           NULL),
    priority_group,
    resolved_date,
    primary_key_value
from  system.repcat$_resolution_statistics,
      sys.user$ u, sys.obj$ o
where sname = u.name
  and oname = o.name
  and o.owner# = u.user#
  and o.type# = 2 /* tables */
  and (o.owner# = userenv('SCHEMAID')
        or
       o.obj# in ( select obj#
                   from objauth$
                   where grantee# in ( select kzsrorol
                                       from x$kzsro
                                     )
                  )
        or
	 exists (select null from v$enabledprivs
	         where priv_number in (-45 /* LOCK ANY TABLE */,
				       -47 /* SELECT ANY TABLE */,
				       -48 /* INSERT ANY TABLE */,
				       -49 /* UPDATE ANY TABLE */,
				       -50 /* DELETE ANY TABLE */)
                 )
       );

CREATE OR REPLACE FORCE VIEW "ALL_REPRESOL_STATS_CONTROL"("SNAME",
select
    c.sname,
    c.oname,
    c.created,
    decode(c.status,
           1, 'ACTIVE',
           2, 'CANCELLED',
           'UNDEFINED'),
    c.status_update_date,
    c.purged_date,
    c.last_purge_start_date,
    c.last_purge_end_date
from  system.repcat$_resol_stats_control c,
      sys.user$ u, sys.obj$ o
where c.sname = u.name
  and c.oname = o.name
  and o.owner# = u.user#
  and o.type# = 2 /* tables */
  and (o.owner# = userenv('SCHEMAID')
        or
       o.obj# in ( select obj#
                   from objauth$
                   where grantee# in ( select kzsrorol
                                       from x$kzsro
                                     )
                  )
        or
	 exists (select null from v$enabledprivs
	         where priv_number in (-45 /* LOCK ANY TABLE */,
				       -47 /* SELECT ANY TABLE */,
				       -48 /* INSERT ANY TABLE */,
				       -49 /* UPDATE ANY TABLE */,
				       -50 /* DELETE ANY TABLE */)
                 )
       );

CREATE OR REPLACE FORCE VIEW "ALL_REPSCHEMA"("SNAME",
select r.sname, r.dblink, r.masterdef, r.snapmaster, r.master_comment, r.sname,
       r.master, r.gowner
from repcat_repschema r;

CREATE OR REPLACE FORCE VIEW "ALL_REPSITES"("GNAME",
select r.sname, r.dblink, r.masterdef, r.snapmaster, r.master_comment,
       r.master, r.gowner
from repcat_repschema r;

CREATE OR REPLACE FORCE VIEW "ALL_REWRITE_EQUIVALENCES"("OWNER",
select m."OWNER",m."NAME",m."SOURCE_STMT",m."DESTINATION_STMT",m."REWRITE_MODE" from dba_rewrite_equivalences m, sys.obj$ o, sys.user$ u
where o.owner# = u.user#
  and m.name   = o.name
  and u.name   = m.owner
  and ( o.owner# = userenv('SCHEMAID')
        or
        o.obj# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                        from x$kzsro
                                      )
                  )
        or /* user has system privileges */
        exists ( select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
               )
      );

CREATE OR REPLACE FORCE VIEW "ALL_RULES"("RULE_OWNER",
SELECT /*+ all_rows */
       u.name, o.name, r.condition, bu.name, bo.name, r.r_action, r.r_comment
FROM   rule$ r, obj$ o, user$ u, obj$ bo, user$ bu
WHERE  r.obj# = o.obj# and
       (o.owner# in (USERENV('SCHEMAID'), 1 /* PUBLIC */) or
        o.obj# in (select oa.obj# from sys.objauth$ oa
                   where grantee# in (select kzsrorol from x$kzsro)) or
        exists (select null from v$enabledprivs where priv_number in (
                 -258, /* create any rule */
                 -259, /* alter any rule */
                 -260, /* drop any rule */
                 -261  /* execute any rule set */))) and
       o.owner# = u.user# and r.ectx# = bo.obj#(+) and bo.owner# = bu.user#(+);

CREATE OR REPLACE FORCE VIEW "ALL_RULESETS"("OWNER",
SELECT rule_set_owner, rule_set_name, NULL,
       decode(rule_set_eval_context_owner, NULL, NULL,
              rule_set_eval_context_owner||'.'||rule_set_eval_context_name),
       rule_set_comment
FROM   all_rule_sets;

CREATE OR REPLACE FORCE VIEW "ALL_RULE_SETS"("RULE_SET_OWNER",
SELECT /*+ all_rows */
       u.name, o.name, bu.name, bo.name, r.rs_comment
FROM   rule_set$ r, obj$ o, user$ u, obj$ bo, user$ bu
WHERE  r.obj# = o.obj# and
       (o.owner# in (USERENV('SCHEMAID'), 1 /* PUBLIC */) or
        o.obj# in (select oa.obj# from sys.objauth$ oa
                   where grantee# in (select kzsrorol from x$kzsro)) or
        exists (select null from v$enabledprivs where priv_number in (
                 -251, /* create any rule set */
                 -252, /* alter any rule set */
                 -253, /* drop any rule set */
                 -254  /* execute any rule set */))) and
       u.user# = o.owner# and
       r.ectx# = bo.obj#(+) and bo.owner# = bu.user#(+);

CREATE OR REPLACE FORCE VIEW "ALL_RULE_SET_RULES"("RULE_SET_OWNER",
SELECT /*+ all_rows */
       u.name, o.name, ru.name, ro.name,
       decode(bitand(rm.property, 1), 1, 'DISABLED', 'ENABLED'),
       eu.name, eo.name, rm.rm_comment
FROM   rule_map$ rm, obj$ o, user$ u, obj$ ro, user$ ru, obj$ eo, user$ eu
WHERE  rm.rs_obj# = o.obj# and
       (o.owner# in (USERENV('SCHEMAID'), 1 /* PUBLIC */) or
        o.obj# in (select oa.obj# from sys.objauth$ oa
                   where grantee# in (select kzsrorol from x$kzsro)) or
        exists (select null from v$enabledprivs where priv_number in (
                 -251, /* create any rule set */
                 -252, /* alter any rule set */
                 -253, /* drop any rule set */
                 -254  /* execute any rule set */))) and
       o.owner# = u.user# and rm.r_obj# = ro.obj# and ro.owner# = ru.user#
       and rm.ectx# = eo.obj#(+) and eo.owner# = eu.user#(+);

CREATE OR REPLACE FORCE VIEW "ALL_SCHEDULER_GLOBAL_ATTRIBUTE"("ATTRIBUTE_NAME",
SELECT o.name, a.value
 FROM sys.obj$ o, sys.scheduler$_global_attribute a
 WHERE o.obj# = a.obj#;

CREATE OR REPLACE FORCE VIEW "ALL_SCHEDULER_JOBS"("OWNER",
SELECT ju.name, jo.name, j.creator, j.client_id, j.guid,
    DECODE(bitand(j.flags,4194304),4194304,
      substr(j.program_action,1,instr(j.program_action,'"')-1),NULL),
    DECODE(bitand(j.flags,4194304),4194304,
      substr(j.program_action,instr(j.program_action,'"')+1,
        length(j.program_action)-instr(j.program_action,'"')) ,NULL),
    DECODE(BITAND(j.flags,131072+262144+2097152),
      131072, 'PLSQL_BLOCK', 262144, 'STORED_PROCEDURE',
      2097152, 'EXECUTABLE', 524288, 'JOB_CHAIN', NULL),
    DECODE(bitand(j.flags,4194304),0,j.program_action,NULL), j.number_of_args,
    DECODE(bitand(j.flags,1024+4096),0,NULL,
      substr(j.schedule_expr,1,instr(j.schedule_expr,'"')-1)),
    DECODE(bitand(j.flags,1024+4096),0,NULL,
      substr(j.schedule_expr,instr(j.schedule_expr,'"') + 1,
        length(j.schedule_expr)-instr(j.schedule_expr,'"'))),
    j.start_date,
    DECODE(BITAND(j.flags,1024+4096), 0, j.schedule_expr, NULL),
    j.end_date, co.name,
    DECODE(BITAND(j.job_status,1+8388608),0,'FALSE','TRUE'),
    DECODE(BITAND(j.flags,32768),0,'TRUE','FALSE'),
    DECODE(BITAND(j.flags,65536),0,'FALSE','TRUE'),
    DECODE(BITAND(j.job_status,1+2+4+8+16+32+128),0,'DISABLED',1,
      (CASE WHEN j.retry_count>0 THEN 'RETRY SCHEDULED' ELSE 'SCHEDULED' END),
      2,'RUNNING',3,'RUNNING',4,'COMPLETED',8,'BROKEN',16,'FAILED',32,'SUCCEEDED'
      ,128,'REMOTE',NULL),
    j.priority, j.run_count, j.max_runs, j.failure_count, j.max_failures,
    j.retry_count,
    j.last_start_date,
    (CASE WHEN j.last_end_date>j.last_start_date THEN j.last_end_date-j.last_start_date
       ELSE NULL END), j.next_run_date,
    j.schedule_limit, j.max_run_duration,
    DECODE(BITAND(j.flags,32+64+128+256),32,'OFF',64,'RUNS',128,'',
      256,'FULL',NULL),
    DECODE(BITAND(j.flags,8),0,'FALSE','TRUE'),
    DECODE(BITAND(j.flags,16),0,'FALSE','TRUE'),
    DECODE(BITAND(j.flags,16777216),0,'FALSE','TRUE'),
    j.job_weight, j.nls_env,
    j.source, j.destination, j.comments, j.flags
  FROM obj$ jo, user$ ju, sys.scheduler$_job j, obj$ co
  WHERE j.obj# = jo.obj# AND jo.owner# = ju.user# AND
    j.class_oid = co.obj#(+) AND
    (jo.owner# = userenv('SCHEMAID')
       or jo.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         (exists (select null from v$enabledprivs
                 where priv_number = -265 /* CREATE ANY JOB */
                 )
          and jo.owner#!=0)
       );

CREATE OR REPLACE FORCE VIEW "ALL_SCHEDULER_JOB_ARGS"("OWNER",
SELECT u.name, o.name, b.name, t.position,
  CASE WHEN (b.user_type_num IS NULL) THEN
    DECODE(b.type_number,
0, null,
1, decode(b.flags, 512, 'NVARCHAR2', 'VARCHAR2'),
2, decode(b.flags, 512, 'FLOAT', 'NUMBER'),
3, 'NATIVE INTEGER',
8, 'LONG',
9, decode(b.flags, 512, 'NCHAR VARYING', 'VARCHAR'),
11, 'ROWID',
12, 'DATE',
23, 'RAW',
24, 'LONG RAW',
29, 'BINARY_INTEGER',
69, 'ROWID',
96, decode(b.flags, 512, 'NCHAR', 'CHAR'),
100, 'BINARY_FLOAT',
101, 'BINARY_DOUBLE',
102, 'REF CURSOR',
104, 'UROWID',
105, 'MLSLABEL',
106, 'MLSLABEL',
110, 'REF',
111, 'REF',
112, decode(b.flags, 512, 'NCLOB', 'CLOB'),
113, 'BLOB', 114, 'BFILE', 115, 'CFILE',
121, 'OBJECT',
122, 'TABLE',
123, 'VARRAY',
178, 'TIME',
179, 'TIME WITH TIME ZONE',
180, 'TIMESTAMP',
181, 'TIMESTAMP WITH TIME ZONE',
231, 'TIMESTAMP WITH LOCAL TIME ZONE',
182, 'INTERVAL YEAR TO MONTH',
183, 'INTERVAL DAY TO SECOND',
250, 'PL/SQL RECORD',
251, 'PL/SQL TABLE',
252, 'PL/SQL BOOLEAN',
'UNDEFINED')
    ELSE t_u.name ||'.'|| t_o.name END,
  dbms_scheduler.get_varchar2_value(t.value), t.value,
  DECODE(BITAND(b.flags,1),0,'FALSE',1,'TRUE')
  FROM obj$ t_o, user$ t_u,
    sys.scheduler$_program_argument b, obj$ o, user$ u,
    (SELECT a.oid job_oid, a.position position,
      j.program_oid program_oid, a.value value
    FROM sys.scheduler$_job j, sys.scheduler$_job_argument a
    WHERE a.oid = j.obj#) t
  WHERE t.job_oid = o.obj# AND u.user# = o.owner#
    AND b.user_type_num = t_o.obj#(+) AND t_o.owner# = t_u.user#(+)
    AND t.program_oid=b.oid(+) AND t.position=b.position(+) AND
    (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         (exists (select null from v$enabledprivs
                 where priv_number = -265 /* CREATE ANY JOB */
                 )
          and o.owner#!=0)
      );

CREATE OR REPLACE FORCE VIEW "ALL_SCHEDULER_JOB_CLASSES"("JOB_CLASS_NAME",
SELECT co.name, c.res_grp_name,
    c.affinity ,
    DECODE(BITAND(c.flags,32+64+128+256),32,'OFF',64,'RUNS',128,'',
      256,'FULL',NULL),
    c.log_history, c.comments
  FROM obj$ co, sys.scheduler$_class c
  WHERE c.obj# = co.obj# AND
    (co.obj# in
         (select oa.obj#
          from sys.objauth$ oa
          where grantee# in ( select kzsrorol
                              from x$kzsro
                            )
         )
     or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-267, /* EXECUTE ANY CLASS */
                                       -268  /* MANAGE SCHEDULER */ )
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_SCHEDULER_JOB_LOG"("LOG_ID",
(SELECT
        e.LOG_ID, e.LOG_DATE, e.OWNER, e.NAME, co.NAME, OPERATION, e.STATUS,
        e.USER_NAME, e.CLIENT_ID, e.GUID, e.ADDITIONAL_INFO
   FROM scheduler$_event_log e, obj$ co
   WHERE e.type# = 66 and e.class_id = co.obj#(+)
   AND ( e.owner = SYS_CONTEXT('USERENV','CURRENT_SCHEMA')
         or  /* user has object privileges */
            ( select jo.obj# from obj$ jo, user$ ju where  e.name = jo.name
                and e.owner = ju.name and jo.owner# = ju.user#
            ) in
            ( select oa.obj#
                from sys.objauth$ oa
                where grantee# in ( select kzsrorol from x$kzsro )
            )
         or /* user has system privileges */
            (exists ( select null from v$enabledprivs
                       where priv_number = -265 /* CREATE ANY JOB */
                   )
             and e.owner!='SYS')
        )
  );

CREATE OR REPLACE FORCE VIEW "ALL_SCHEDULER_JOB_RUN_DETAILS"("LOG_ID",
(SELECT
        j.LOG_ID, j.LOG_DATE, e.OWNER, e.NAME, e.STATUS, j.ERROR#,
        j.REQ_START_DATE, j.START_DATE, j.RUN_DURATION, j.INSTANCE_ID,
        j.SESSION_ID, j.SLAVE_PID, j.CPU_USED, j.ADDITIONAL_INFO
   FROM scheduler$_job_run_details j, scheduler$_event_log e
   WHERE j.log_id = e.log_id
   AND e.type# = 66
   AND ( e.owner = SYS_CONTEXT('USERENV','CURRENT_SCHEMA')
         or  /* user has object privileges */
            ( select jo.obj# from obj$ jo, user$ ju where  e.name = jo.name
                and e.owner = ju.name and jo.owner# = ju.user#
            ) in
            ( select oa.obj#
                from sys.objauth$ oa
                where grantee# in ( select kzsrorol from x$kzsro )
            )
         or /* user has system privileges */
            (exists ( select null from v$enabledprivs
                       where priv_number = -265 /* CREATE ANY JOB */
                   )
             and e.owner!='SYS')
        )
  );

CREATE OR REPLACE FORCE VIEW "ALL_SCHEDULER_PROGRAMS"("OWNER",
SELECT u.name, o.name,
  DECODE(bitand(p.flags,2+4+8+16+32), 2,'PLSQL_BLOCK',
         4,'STORED_PROCEDURE', 32, 'EXECUTABLE', ''),
  p.action, p.number_of_args, DECODE(BITAND(p.flags,1),0,'FALSE',1,'TRUE'),
  p.comments
  FROM obj$ o, user$ u, sys.scheduler$_program p
  WHERE p.obj# = o.obj# AND u.user# = o.owner# AND
    (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         (exists (select null from v$enabledprivs
                 where priv_number in (-265 /* CREATE ANY JOB */,
                                       -266 /* EXECUTE ANY PROGRAM */ )
                 )
          and o.owner#!=0)
      );

CREATE OR REPLACE FORCE VIEW "ALL_SCHEDULER_PROGRAM_ARGS"("OWNER",
SELECT u.name, o.name, a.name, a.position,
  CASE WHEN (a.user_type_num IS NULL) THEN
    DECODE(a.type_number,
0, null,
1, decode(a.flags, 512, 'NVARCHAR2', 'VARCHAR2'),
2, decode(a.flags, 512, 'FLOAT', 'NUMBER'),
3, 'NATIVE INTEGER',
8, 'LONG',
9, decode(a.flags, 512, 'NCHAR VARYING', 'VARCHAR'),
11, 'ROWID',
12, 'DATE',
23, 'RAW',
24, 'LONG RAW',
29, 'BINARY_INTEGER',
69, 'ROWID',
96, decode(a.flags, 512, 'NCHAR', 'CHAR'),
100, 'BINARY_FLOAT',
101, 'BINARY_DOUBLE',
102, 'REF CURSOR',
104, 'UROWID',
105, 'MLSLABEL',
106, 'MLSLABEL',
110, 'REF',
111, 'REF',
112, decode(a.flags, 512, 'NCLOB', 'CLOB'),
113, 'BLOB', 114, 'BFILE', 115, 'CFILE',
121, 'OBJECT',
122, 'TABLE',
123, 'VARRAY',
178, 'TIME',
179, 'TIME WITH TIME ZONE',
180, 'TIMESTAMP',
181, 'TIMESTAMP WITH TIME ZONE',
231, 'TIMESTAMP WITH LOCAL TIME ZONE',
182, 'INTERVAL YEAR TO MONTH',
183, 'INTERVAL DAY TO SECOND',
250, 'PL/SQL RECORD',
251, 'PL/SQL TABLE',
252, 'PL/SQL BOOLEAN',
'UNDEFINED')
    ELSE t_u.name ||'.'|| t_o.name END,
  DECODE(bitand(a.flags,2+4+64+128+256), 2,'JOB_NAME',4,'JOB_OWNER',
         64, 'JOB_START', 128, 'WINDOW_START',
         256, 'WINDOW_END', ''),
  dbms_scheduler.get_varchar2_value(a.value), a.value,
  DECODE(BITAND(a.flags,1),0,'FALSE',1,'TRUE')
  FROM obj$ o, user$ u, sys.scheduler$_program_argument a, obj$ t_o, user$ t_u
  WHERE a.oid = o.obj# AND u.user# = o.owner# AND
    a.user_type_num = t_o.obj#(+) AND t_o.owner# = t_u.user#(+) AND
    (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         (exists (select null from v$enabledprivs
                 where priv_number in (-265 /* CREATE ANY JOB */,
                                       -266 /* EXECUTE ANY PROGRAM */ )
                 )
          and o.owner#!=0)
      );

CREATE OR REPLACE FORCE VIEW "ALL_SCHEDULER_RUNNING_JOBS"("OWNER",
SELECT ju.name, jo.name, rj.session_id, rj.process_id, rj.inst_id,
      vse.resource_consumer_group,
      CAST (systimestamp-j.last_start_date AS INTERVAL DAY(3) TO SECOND(2)),
      rj.session_stat_cpu
  FROM
        sys.scheduler$_job j,
        obj$ jo,
        user$ ju,
        gv$scheduler_running_jobs rj,
        gv$session vse
  WHERE
      j.obj# = jo.obj#
  AND rj.job_id = j.obj#
  AND jo.owner# = ju.user#
  AND (jo.owner# = userenv('SCHEMAID')
       or jo.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         (exists (select null from v$enabledprivs
                 where priv_number  = -265 /* CREATE ANY JOB */
                )
          and jo.owner#!=0)
      )
  AND vse.sid = rj.session_id
  AND vse.serial# = rj.session_serial_num;

CREATE OR REPLACE FORCE VIEW "ALL_SCHEDULER_SCHEDULES"("OWNER",
SELECT "OWNER",

CREATE OR REPLACE FORCE VIEW "ALL_SCHEDULER_WINDOWS"("WINDOW_NAME",
SELECT "WINDOW_NAME",

CREATE OR REPLACE FORCE VIEW "ALL_SCHEDULER_WINDOW_DETAILS"("LOG_ID",
SELECT "LOG_ID",

CREATE OR REPLACE FORCE VIEW "ALL_SCHEDULER_WINDOW_GROUPS"("WINDOW_GROUP_NAME",
SELECT "WINDOW_GROUP_NAME",

CREATE OR REPLACE FORCE VIEW "ALL_SCHEDULER_WINDOW_LOG"("LOG_ID",
SELECT "LOG_ID",

CREATE OR REPLACE FORCE VIEW "ALL_SCHEDULER_WINGROUP_MEMBERS"("WINDOW_GROUP_NAME",
SELECT "WINDOW_GROUP_NAME",

CREATE OR REPLACE FORCE VIEW "ALL_SECONDARY_OBJECTS"("INDEX_OWNER",
select u.name, o.name, u1.name, o1.name
from   sys.user$ u, sys.obj$ o, sys.user$ u1, sys.obj$ o1, sys.secobj$ s
where  s.obj# = o.obj# and o.owner# = u.user# and
       s.secobj# = o1.obj#  and  o1.owner# = u1.user# and
       ( o.owner# = userenv('SCHEMAID')
         or
         o.obj# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                        from x$kzsro
                                      )
                   )
         or
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
       );

CREATE OR REPLACE FORCE VIEW "ALL_SEC_RELEVANT_COLS"("OBJECT_OWNER",
SELECT OBJECT_OWNER, OBJECT_NAME, POLICY_GROUP, POLICY_NAME,
       SEC_REL_COLUMN, COLUMN_OPTION
from DBA_SEC_RELEVANT_COLS, ALL_TABLES t
WHERE
(OBJECT_OWNER = t.OWNER AND OBJECT_NAME = t.TABLE_NAME)
union all
SELECT OBJECT_OWNER, OBJECT_NAME, POLICY_GROUP, POLICY_NAME,
       SEC_REL_COLUMN, COLUMN_OPTION
from DBA_SEC_RELEVANT_COLS, ALL_VIEWS v
WHERE
(OBJECT_OWNER = v.OWNER AND OBJECT_NAME = v.VIEW_NAME );

CREATE OR REPLACE FORCE VIEW "ALL_SEQUENCES"("SEQUENCE_OWNER",
select u.name, o.name,
      s.minvalue, s.maxvalue, s.increment$,
      decode (s.cycle#, 0, 'N', 1, 'Y'),
      decode (s.order$, 0, 'N', 1, 'Y'),
      s.cache, s.highwater
from sys.seq$ s, sys.obj$ o, sys.user$ u
where u.user# = o.owner#
  and o.obj# = s.obj#
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
        or
         exists (select null from v$enabledprivs
                 where priv_number = -109 /* SELECT ANY SEQUENCE */
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_SERVICES"("SERVICE_ID",
select "SERVICE_ID",

CREATE OR REPLACE FORCE VIEW "ALL_SNAPSHOTS"("OWNER",
select s."OWNER",s."NAME",s."TABLE_NAME",s."MASTER_VIEW",s."MASTER_OWNER",s."MASTER",s."MASTER_LINK",s."CAN_USE_LOG",s."UPDATABLE",s."REFRESH_METHOD",s."LAST_REFRESH",s."ERROR",s."FR_OPERATIONS",s."CR_OPERATIONS",s."TYPE",s."NEXT",s."START_WITH",s."REFRESH_GROUP",s."UPDATE_TRIG",s."UPDATE_LOG",s."QUERY",s."MASTER_ROLLBACK_SEG",s."STATUS",s."REFRESH_MODE",s."PREBUILT" from dba_snapshots s, sys.obj$ o, sys.user$ u
where o.owner#     = u.user#
  and s.table_name = o.name
  and u.name       = s.owner
  and o.type#      = 2                     /* table */
  and ( u.user# in (userenv('SCHEMAID'), 1)
        or
        o.obj# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                        from x$kzsro
                                      )
                  )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_SNAPSHOT_LOGS"("LOG_OWNER",
select s."LOG_OWNER",s."MASTER",s."LOG_TABLE",s."LOG_TRIGGER",s."ROWIDS",s."PRIMARY_KEY",s."OBJECT_ID",s."FILTER_COLUMNS",s."SEQUENCE",s."INCLUDE_NEW_VALUES",s."CURRENT_SNAPSHOTS",s."SNAPSHOT_ID" from dba_snapshot_logs s, sys.obj$ o, sys.user$ u
where o.owner#     = u.user#
  and s.log_table = o.name
  and u.name       = s.log_owner
  and o.type#      = 2                     /* table */
  and ( u.user# in (userenv('SCHEMAID'), 1)
        or
        o.obj# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                        from x$kzsro
                                      )
                  )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_SOURCE"("OWNER",
select u.name, o.name,
decode(o.type#, 7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE',
                11, 'PACKAGE BODY', 12, 'TRIGGER', 13, 'TYPE', 14, 'TYPE BODY',
                'UNDEFINED'),
s.line, s.source
from sys.obj$ o, sys.source$ s, sys.user$ u
where o.obj# = s.obj#
  and o.owner# = u.user#
  and ( o.type# in (7, 8, 9, 11, 12, 14) OR
       ( o.type# = 13 AND o.subname is null))
  and
  (
    o.owner# in (userenv('SCHEMAID'), 1 /* PUBLIC */)
    or
    (
      (
         (
          (o.type# in (7 /* proc */, 8 /* func */, 9 /* pkg */, 13 /* type */))
          and
          o.obj# in (select obj# from sys.objauth$
                     where grantee# in (select kzsrorol from x$kzsro)
                       and privilege# in (12 /* EXECUTE */, 26 /* DEBUG */))
        )
        or
        (
          (o.type# in (11 /* package body */, 14 /* type body */))
          and
          exists
          (
            select null from sys.obj$ specobj, sys.objauth$ oa
            where specobj.owner# = o.owner#
              and specobj.name = o.name
              and specobj.type# = decode(o.type#,
                                         11 /* pkg body */, 9 /* pkg */,
                                         14 /* type body */, 13 /* type */,
                                         null)
              and oa.obj# = specobj.obj#
              and oa.grantee# in (select kzsrorol from x$kzsro)
              and oa.privilege# = 26 /* DEBUG */)
        )
        or
        (
          (o.type# = 12 /* trigger */)
          and
          exists
          (
            select null from sys.trigger$ t, sys.obj$ tabobj, sys.objauth$ oa
            where t.obj# = o.obj#
              and tabobj.obj# = t.baseobject
              and tabobj.owner# = o.owner#
              and oa.obj# = tabobj.obj#
              and oa.grantee# in (select kzsrorol from x$kzsro)
              and oa.privilege# = 26 /* DEBUG */)
        )
        or
        exists
        (
          select null from sys.sysauth$
          where grantee# in (select kzsrorol from x$kzsro)
          and
          (
            (
              /* procedure */
              (o.type# = 7 or o.type# = 8 or o.type# = 9)
              and
              (
                privilege# = -144 /* EXECUTE ANY PROCEDURE */
                or
                privilege# = -141 /* CREATE ANY PROCEDURE */
                or
                privilege# = -241 /* DEBUG ANY PROCEDURE */
              )
            )
            or
            (
              /* package body */
              o.type# = 11 and
              (
                privilege# = -141 /* CREATE ANY PROCEDURE */
                or
                privilege# = -241 /* DEBUG ANY PROCEDURE */
              )
            )
            or
            (
              /* type */
              o.type# = 13
              and
              (
                privilege# = -184 /* EXECUTE ANY TYPE */
                or
                privilege# = -181 /* CREATE ANY TYPE */
                or
                privilege# = -241 /* DEBUG ANY PROCEDURE */
              )
            )
            or
            (
              /* type body */
              o.type# = 14 and
              (
                privilege# = -181 /* CREATE ANY TYPE */
                or
                privilege# = -241 /* DEBUG ANY PROCEDURE */
              )
            )
            or
            (
              /* triggers */
              o.type# = 12 and
              (
                privilege# = -152 /* CREATE ANY TRIGGER */
                or
                privilege# = -241 /* DEBUG ANY PROCEDURE */
              )
            )
          )
        )
      )
    )
  )
union all
select u.name, o.name, 'JAVA SOURCE', s.joxftlno, s.joxftsrc
from sys.obj$ o, x$joxfs s, sys.user$ u
where o.obj# = s.joxftobn
  and o.owner# = u.user#
  and o.type# = 28
  and
  (
    o.owner# in (userenv('SCHEMAID'), 1 /* PUBLIC */)
    or
    (
      (
        (
          o.obj# in (select obj# from sys.objauth$
                     where grantee# in (select kzsrorol from x$kzsro)
                       and privilege# in (12 /* EXECUTE */, 26 /* DEBUG */))
        )
        or
        exists
        (
          select null from sys.sysauth$
          where grantee# in (select kzsrorol from x$kzsro)
          and
          (
            (
              /* procedure */
              (
                privilege# = -144 /* EXECUTE ANY PROCEDURE */
                or
                privilege# = -141 /* CREATE ANY PROCEDURE */
                or
                privilege# = -241 /* DEBUG ANY PROCEDURE */
              )
            )
          )
        )
      )
    )
  );

CREATE OR REPLACE FORCE VIEW "ALL_SOURCE_TABLES"("SOURCE_SCHEMA_NAME",
SELECT DISTINCT
   s.source_schema_name, s.source_table_name
  FROM sys.cdc_change_tables$ s, all_tables t
  WHERE s.change_table_schema=t.owner AND
        s.change_table_name=t.table_name;

CREATE OR REPLACE FORCE VIEW "ALL_SQLJ_TYPES"("OWNER",
select decode(bitand(t.properties, 64), 64, null, u.name), o.name, t.toid,
       t.externname,
       decode(t.externtype, 1, 'SQLData',
                            2, 'CustomDatum',
                            3, 'Serializable',
                            4, 'Serializable Internal',
                            5, 'ORAData',
                            'unknown'),
       decode(t.typecode, 108, 'OBJECT',
                          122, 'COLLECTION',
                          o.name),
       t.attributes, t.methods,
       decode(bitand(t.properties, 16), 16, 'YES', 0, 'NO'),
       decode(bitand(t.properties, 256), 256, 'YES', 0, 'NO'),
       decode(bitand(t.properties, 8), 8, 'NO', 'YES'),
       decode(bitand(t.properties, 65536), 65536, 'NO', 'YES'),
       su.name, so.name, t.local_attrs, t.local_methods
from sys.user$ u, sys.type$ t, sys.obj$ o, sys.obj$ so, sys.user$ su
where o.owner# = u.user#
  and o.oid$ = t.tvoid
  and o.subname IS NULL -- only latest version
  and o.type# <> 10 -- must not be invalid
  and bitand(t.properties, 2048) = 0 -- not system-generated
  and t.supertoid = so.oid$ (+) and so.owner# = su.user# (+)
  and t.externtype < 5
  and (o.owner# = userenv('SCHEMAID')
       or
       o.obj# in (select oa.obj#
                  from sys.objauth$ oa
                  where grantee# in (select kzsrorol
                                     from x$kzsro))
       or /* user has system privileges */
       exists (select null from v$enabledprivs
               where priv_number in (-184 /* EXECUTE ANY TYPE */,
                                     -181 /* CREATE ANY TYPE */)));

CREATE OR REPLACE FORCE VIEW "ALL_SQLJ_TYPE_ATTRS"("OWNER",
select decode(bitand(t.properties, 64), 64, null, u.name),
       o.name, a.name, a.externname,
       decode(bitand(a.properties, 32768), 32768, 'REF',
              decode(bitand(a.properties, 16384), 16384, 'POINTER')),
       decode(bitand(at.properties, 64), 64, null, au.name),
       decode(at.typecode,
              52, decode(a.charsetform, 2, 'NVARCHAR2', ao.name),
              53, decode(a.charsetform, 2, 'NCHAR', ao.name),
              54, decode(a.charsetform, 2, 'NCHAR VARYING', ao.name),
              61, decode(a.charsetform, 2, 'NCLOB', ao.name),
              ao.name),
       a.length, a.precision#, a.scale,
       decode(a.charsetform, 1, 'CHAR_CS',
                             2, 'NCHAR_CS',
                             3, NLS_CHARSET_NAME(a.charsetid),
                             4, 'ARG:'||a.charsetid),
       a.attribute#, decode(bitand(nvl(a.xflags,0), 1), 1, 'YES', 'NO')
from sys.user$ u, sys.obj$ o, sys.type$ t, sys.attribute$ a,
     sys.obj$ ao, sys.user$ au, sys.type$ at
where o.owner# = u.user#
  and o.oid$ = t.toid
  and o.subname IS NULL -- get the latest version only
  and o.type# <> 10 -- must not be invalid
  and bitand(t.properties, 2048) = 0 -- not system-generated
  and t.toid = a.toid
  and t.version# = a.version#
  and a.attr_toid = ao.oid$
  and ao.owner# = au.user#
  and a.attr_toid = at.tvoid
  and a.attr_version# = at.version#
  and t.externtype < 5
  and (o.owner# = userenv('SCHEMAID')
       or
       o.obj# in (select oa.obj#
                  from sys.objauth$ oa
                  where grantee# in (select kzsrorol
                                     from x$kzsro))
       or /* user has system privileges */
       exists (select null from v$enabledprivs
               where priv_number in (-184 /* EXECUTE ANY TYPE */,
                                     -181 /* CREATE ANY TYPE */)));

CREATE OR REPLACE FORCE VIEW "ALL_SQLJ_TYPE_METHODS"("OWNER",
select u.name, o.name, m.name, m.externVarName, m.method#,
       decode(bitand(m.properties, 512), 512, 'MAP',
              decode(bitand(m.properties, 2048), 2048, 'ORDER', 'PUBLIC')),
       m.parameters#, m.results,
       decode(bitand(m.properties, 8), 8, 'NO', 'YES'),
       decode(bitand(m.properties, 65536), 65536, 'NO', 'YES'),
       decode(bitand(m.properties, 131072), 131072, 'YES', 'NO'),
       decode(bitand(nvl(m.xflags,0), 1), 1, 'YES', 'NO')
from sys.user$ u, sys.obj$ o, sys.type$ t, sys.method$ m
where o.owner# = u.user#
  and o.oid$ = m.toid
  and o.subname IS NULL -- get the latest version only
  and o.type# <> 10 -- must not be invalid
  and bitand(t.properties, 2048) = 0 -- not system-generated
  and t.toid = m.toid
  and t.version# = m.version#
  and t.externtype < 5
  and (o.owner# = userenv('SCHEMAID')
       or
       o.obj# in (select oa.obj#
                  from sys.objauth$ oa
                  where grantee# in (select kzsrorol
                                     from x$kzsro))
       or /* user has system privileges */
       exists (select null from v$enabledprivs
               where priv_number in (-184 /* EXECUTE ANY TYPE */,
                                     -181 /* CREATE ANY TYPE */)));

CREATE OR REPLACE FORCE VIEW "ALL_STORED_SETTINGS"("OWNER",
SELECT u.name, o.name, o.obj#,
DECODE(o.type#,
        7, 'PROCEDURE',
        8, 'FUNCTION',
        9, 'PACKAGE',
       11, 'PACKAGE BODY',
       12, 'TRIGGER',
       13, 'TYPE',
       14, 'TYPE BODY',
       'UNDEFINED'),
p.param, p.value
FROM sys.obj$ o, sys.user$ u, sys.settings$ p
WHERE o.owner# = u.user#
AND o.linkname is null
AND p.obj# = o.obj#
AND (
    o.owner# in (userenv('SCHEMAID'), 1 /* PUBLIC */)
    or
    (
      (
         (
          (o.type# = 7 or o.type# = 8 or o.type# = 9 or o.type# = 13)
          and
          o.obj# in (select obj# from sys.objauth$
                     where grantee# in (select kzsrorol from x$kzsro)
                       and privilege#  = 12 /* EXECUTE */)
        )
        or
        exists
        (
          select null from sys.sysauth$
          where grantee# in (select kzsrorol from x$kzsro)
          and
          (
            (
              /* procedure */
              (o.type# = 7 or o.type# = 8 or o.type# = 9)
              and
              (
                privilege# = -144 /* EXECUTE ANY PROCEDURE */
                or
                privilege# = -141 /* CREATE ANY PROCEDURE */
              )
            )
            or
            (
              /* package body */
              o.type# = 11 and
              privilege# = -141 /* CREATE ANY PROCEDURE */
            )
            or
            (
              /* type */
              o.type# = 13
              and
              (
                privilege# = -184 /* EXECUTE ANY TYPE */
                or
                privilege# = -181 /* CREATE ANY TYPE */
              )
            )
            or
            (
              /* type body */
              o.type# = 14 and
              privilege# = -181 /* CREATE ANY TYPE */
            )
          )
        )
      )
    )
  );

CREATE OR REPLACE FORCE VIEW "ALL_STREAMS_GLOBAL_RULES"("STREAMS_NAME",
select r.streams_name, r.streams_type, r.rule_type, r.include_tagged_lcr,
       r.source_database, r.rule_name, r.rule_owner, r.rule_condition
 from  dba_streams_global_rules r, "_ALL_STREAMS_PROCESSES" p, all_rules ar
 where r.streams_name = p.streams_name
   and r.streams_type = p.streams_type
   and ar.rule_owner = r.rule_owner
   and ar.rule_name = r.rule_name;

CREATE OR REPLACE FORCE VIEW "ALL_STREAMS_MESSAGE_CONSUMERS"("STREAMS_NAME",
select c."STREAMS_NAME",c."QUEUE_NAME",c."QUEUE_OWNER",c."RULE_SET_NAME",c."RULE_SET_OWNER",c."NEGATIVE_RULE_SET_NAME",c."NEGATIVE_RULE_SET_OWNER",c."NOTIFICATION_TYPE",c."NOTIFICATION_ACTION",c."NOTIFICATION_CONTEXT"
  from dba_streams_message_consumers c, all_queues q
 where c.queue_name = q.name
   and c.queue_owner = q.owner
   and ((c.rule_set_owner is null and c.rule_set_name is null) or
        ((c.rule_set_owner, c.rule_set_name) in
          (select r.rule_set_owner, r.rule_set_name
             from all_rule_sets r)))
   and ((c.negative_rule_set_owner is null and
         c.negative_rule_set_name is null) or
        ((c.negative_rule_set_owner, c.negative_rule_set_name) in
          (select r.rule_set_owner, r.rule_set_name
             from all_rule_sets r)));

CREATE OR REPLACE FORCE VIEW "ALL_STREAMS_MESSAGE_RULES"("STREAMS_NAME",
select mr."STREAMS_NAME",mr."STREAMS_TYPE",mr."MESSAGE_TYPE_NAME",mr."MESSAGE_TYPE_OWNER",mr."MESSAGE_RULE_VARIABLE",mr."RULE_NAME",mr."RULE_OWNER",mr."RULE_CONDITION"
  from dba_streams_message_rules mr, "_ALL_STREAMS_PROCESSES" p, all_rules ar
 where mr.rule_owner = ar.rule_owner
   and mr.rule_name  = ar.rule_name
   and mr.streams_name = p.streams_name
   and mr.streams_type = p.streams_type;

CREATE OR REPLACE FORCE VIEW "ALL_STREAMS_NEWLY_SUPPORTED"("OWNER",
select s."OWNER",s."TABLE_NAME",s."REASON",s."COMPATIBLE" from dba_streams_newly_supported s, all_objects a
    where s.owner = a.owner
      and s.table_name = a.object_name
      and a.object_type = 'TABLE';

CREATE OR REPLACE FORCE VIEW "ALL_STREAMS_RULES"("STREAMS_TYPE",
select r."STREAMS_TYPE",r."STREAMS_NAME",r."RULE_SET_OWNER",r."RULE_SET_NAME",r."RULE_OWNER",r."RULE_NAME",r."RULE_CONDITION",r."RULE_SET_TYPE",r."STREAMS_RULE_TYPE",r."SCHEMA_NAME",r."OBJECT_NAME",r."SUBSETTING_OPERATION",r."DML_CONDITION",r."INCLUDE_TAGGED_LCR",r."SOURCE_DATABASE",r."RULE_TYPE",r."MESSAGE_TYPE_OWNER",r."MESSAGE_TYPE_NAME",r."MESSAGE_RULE_VARIABLE",r."ORIGINAL_RULE_CONDITION",r."SAME_RULE_CONDITION"
  from dba_streams_rules r, "_ALL_STREAMS_PROCESSES" p
where r.streams_type = p.streams_type
  and r.streams_name = p.streams_name;

CREATE OR REPLACE FORCE VIEW "ALL_STREAMS_SCHEMA_RULES"("STREAMS_NAME",
select sr.streams_name, sr.streams_type, sr.schema_name, sr.rule_type,
       sr.include_tagged_lcr, sr.source_database, sr.rule_name, sr.rule_owner,
       sr.rule_condition
  from dba_streams_schema_rules sr, "_ALL_STREAMS_PROCESSES" p, all_rules r
 where sr.rule_owner = r.rule_owner
   and sr.rule_name = r.rule_name
   and sr.streams_name = p.streams_name
   and sr.streams_type = p.streams_type;

CREATE OR REPLACE FORCE VIEW "ALL_STREAMS_TABLE_RULES"("STREAMS_NAME",
select tr.streams_name, tr.streams_type, tr.table_owner, tr.table_name,
       tr.rule_type, tr.dml_condition, tr.subsetting_operation,
       tr.include_tagged_lcr, tr.source_database, tr.rule_name,
       tr.rule_owner, tr.rule_condition
  from dba_streams_table_rules tr, "_ALL_STREAMS_PROCESSES" p, all_rules ar
 where tr.rule_owner = ar.rule_owner
   and tr.rule_name = ar.rule_name
   and tr.streams_name = p.streams_name
   and tr.streams_type = p.streams_type;

CREATE OR REPLACE FORCE VIEW "ALL_STREAMS_TRANSFORM_FUNCTION"("RULE_OWNER",
select tf."RULE_OWNER",tf."RULE_NAME",tf."VALUE_TYPE",tf."TRANSFORM_FUNCTION_NAME"
from   DBA_STREAMS_TRANSFORM_FUNCTION tf, ALL_RULES r
where  tf.rule_owner = r.rule_owner
and    tf.rule_name = r.rule_name;

CREATE OR REPLACE FORCE VIEW "ALL_STREAMS_UNSUPPORTED"("OWNER",
select s."OWNER",s."TABLE_NAME",s."REASON",s."AUTO_FILTERED" from DBA_STREAMS_UNSUPPORTED s, ALL_OBJECTS a
   where s.owner = a.owner
     and s.table_name = a.object_name
     and a.object_type = 'TABLE';

CREATE OR REPLACE FORCE VIEW "ALL_SUBPARTITION_TEMPLATES"("USER_NAME",
select u.name, o.name, st.spart_name, st.spart_position + 1, ts.name,
       st.hiboundval
from sys.obj$ o, sys.defsubpart$ st, sys.ts$ ts, sys.user$ u
where st.bo# = o.obj# and st.ts# = ts.ts#(+) and o.owner# = u.user# and
      (o.owner# = userenv('SCHEMAID') or
       o.obj# in (select oa.obj# from sys.objauth$ oa
                  where grantee# in ( select kzsrorol from x$kzsro )) or
       exists (select null from v$enabledprivs
               where priv_number in (-45 /* LOCK ANY TABLE */,
                                     -47 /* SELECT ANY TABLE */,
                                     -48 /* INSERT ANY TABLE */,
                                     -49 /* UPDATE ANY TABLE */,
                                     -50 /* DELETE ANY TABLE */)));

CREATE OR REPLACE FORCE VIEW "ALL_SUBPART_COL_STATISTICS"("OWNER",
select u.name, o.name, o.subname, tsp.cname, h.distcnt, h.lowval, h.hival,
       h.density, h.null_cnt,
       case when h.bucket_cnt > 255 then h.row_cnt else
         decode(h.row_cnt, h.distcnt, h.row_cnt, h.bucket_cnt)
       end,
       h.sample_size, h.timestamp#,
       decode(bitand(h.spare2, 2), 2, 'YES', 'NO'),
       decode(bitand(h.spare2, 1), 1, 'YES', 'NO'),
       h.avgcln,
       case when h.bucket_cnt > 255 then 'FREQUENCY' else
         decode(nvl(h.row_cnt, 0), 0, 'NONE',
                                   h.distcnt, 'FREQUENCY', 'HEIGHT BALANCED')
       end
from sys.obj$ o, sys.hist_head$ h, tsp$ tsp, user$ u
where o.obj# = tsp.obj# and tsp.obj# = h.obj#(+)
  and tsp.intcol# = h.intcol#(+)
  and o.type# = 34 /* TABLE SUBPARTITION */
  and o.owner# = u.user#
  and (o.owner# = userenv('SCHEMAID')
        or tsp.bo# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
        or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_SUBPART_HISTOGRAMS"("OWNER",
select u.name,
       o.name, o.subname,
       tsp.cname,
       h.bucket,
       h.endpoint,
       h.epvalue
from sys.obj$ o, sys.histgrm$ h, sys.user$ u, tsp$ tsp
where o.obj# = tsp.obj# and tsp.obj# = h.obj#
  and tsp.intcol# = h.intcol#
  and o.type# = 34 /* TABLE SUBPARTITION */
  and o.owner# = u.user#
  and (o.owner# = userenv('SCHEMAID')
        or
        tsp.bo# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                  )
        or /* user has system privileges */
          exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                  )
       )
union
select u.name,
       o.name, o.subname,
       tsp.cname,
       0,
       h.minimum,
       null
from sys.obj$ o, sys.hist_head$ h, sys.user$ u, tsp$ tsp
where o.obj# = tsp.obj# and tsp.obj# = h.obj#
  and tsp.intcol# = h.intcol#
  and o.type# = 34 /* TABLE SUBPARTITION */
  and h.bucket_cnt = 1
  and o.owner# = u.user#
  and (o.owner# = userenv('SCHEMAID')
        or
        tsp.bo# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                  )
        or /* user has system privileges */
          exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                  )
       )
union
select u.name,
       o.name, o.subname,
       tsp.cname,
       1,
       h.maximum,
       null
from sys.obj$ o, sys.hist_head$ h, sys.user$ u, tsp$ tsp
where o.obj# = tsp.obj# and tsp.obj# = h.obj#
  and tsp.intcol# = h.intcol#
  and o.type# = 34 /* TABLE SUBPARTITION */
  and h.bucket_cnt = 1
  and o.owner# = u.user#
  and (o.owner# = userenv('SCHEMAID')
        or
        tsp.bo# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                  )
        or /* user has system privileges */
          exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                  )
       );

CREATE OR REPLACE FORCE VIEW "ALL_SUBPART_KEY_COLUMNS"("OWNER",
select u.name, o.name, 'TABLE',
  decode(bitand(c.property, 1), 1, a.name, c.name), spc.pos#
from   obj$ o, subpartcol$ spc, col$ c, user$ u, attrcol$ a
where  spc.obj# = o.obj# and spc.obj# = c.obj#
       and c.intcol# = spc.intcol#
       and u.user# = o.owner# and
       c.obj# = a.obj#(+) and c.intcol# = a.intcol#(+) and
      (o.owner# = userenv('SCHEMAID')
       or spc.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
union
select u.name, o.name, 'INDEX',
  decode(bitand(c.property, 1), 1, a.name, c.name), spc.pos#
from   obj$ o, subpartcol$ spc, col$ c, user$ u, ind$ i, attrcol$ a
where spc.obj# = i.obj# and i.obj# = o.obj# and i.bo# = c.obj#
      and c.intcol# = spc.intcol#
      and u.user# = o.owner# and
      c.obj# = a.obj#(+) and c.intcol# = a.intcol#(+) and
      (o.owner# = userenv('SCHEMAID')
       or i.bo# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_SUBSCRIBED_COLUMNS"("HANDLE",
SELECT
   sc.handle, t.source_schema_name, t.source_table_name, sc.column_name,
   s.subscription_name
  FROM sys.cdc_subscribed_columns$ sc, sys.cdc_change_tables$ t,
       sys.cdc_subscribers$ s
  WHERE sc.change_table_obj#=t.obj# AND
        s.handle = sc.handle;

CREATE OR REPLACE FORCE VIEW "ALL_SUBSCRIBED_TABLES"("HANDLE",
SELECT
   st.handle, t.source_schema_name, t.source_table_name, st.view_name,
   t.change_set_name, s.subscription_name
  FROM sys.cdc_subscribed_tables$ st, sys.cdc_change_tables$ t,
       sys.cdc_subscribers$ s, sys.user$ u
  WHERE st.change_table_obj#=t.obj# AND
        s.handle = st.handle AND
        s.username = u.name AND
        u.user# = userenv('SCHEMAID');

CREATE OR REPLACE FORCE VIEW "ALL_SUBSCRIPTIONS"("HANDLE",
SELECT
   s.handle, s.set_name, s.username, s.created, s.status, s.earliest_scn,
   s.latest_scn, s.description, s.last_purged, s.last_extended,
   s.subscription_name
  FROM sys.cdc_subscribers$ s, sys.user$ u
  WHERE s.username = u.name AND
        u.user# = userenv('SCHEMAID');

CREATE OR REPLACE FORCE VIEW "ALL_SUMDELTA"("TABLEOBJ#",
select s.TABLEOBJ#, s.PARTITIONOBJ#, s.DMLOPERATION, s.SCN,
          s.TIMESTAMP, s.LOWROWID, s.HIGHROWID, s.SEQUENCE
from  sys.obj$ o, sys.user$ u, sys.sumdelta$ s
where o.type# = 2
  and o.owner# = u.user#
  and s.tableobj# = o.obj#
  and (o.owner# = userenv('SCHEMAID')
    or o.obj# in
      (select oa.obj#
         from sys.objauth$ oa
         where grantee# in ( select kzsrorol from x$kzsro)
      )
    or /* user has system privileges */
      exists (select null from v$enabledprivs
        where priv_number in (-45 /* LOCK ANY TABLE */,
                              -47 /* SELECT ANY TABLE */,
                              -48 /* INSERT ANY TABLE */,
                              -49 /* UPDATE ANY TABLE */,
                              -50 /* DELETE ANY TABLE */)
              )
      );

CREATE OR REPLACE FORCE VIEW "ALL_SUMMARIES"("OWNER",
select u.name, o.name, u.name, s.containernam,
       s.lastrefreshscn, s.lastrefreshdate,
       decode (s.refreshmode, 0, 'NONE', 1, 'ANY', 2, 'INCREMENTAL', 3,'FULL'),
       decode(bitand(s.pflags, 25165824), 25165824, 'N', 'Y'),
       s.fullrefreshtim, s.increfreshtim,
       decode(bitand(s.pflags, 48), 0, 'N', 'Y'),
       decode(bitand(s.mflags, 64), 0, 'N', 'Y'), /* QSMQSUM_UNUSABLE */
       decode(bitand(s.pflags, 1294319), 0, 'Y', 'N'),
       decode(bitand(s.pflags, 236879743), 0, 'Y', 'N'),
       decode(bitand(s.mflags, 1), 0, 'N', 'Y'), /* QSMQSUM_KNOWNSTL */
       s.sumtextlen,s.sumtext
from sys.user$ u, sys.sum$ s, sys.obj$ o
where o.owner# = u.user#
  and o.obj# = s.obj#
  and bitand(s.xpflags, 8388608) = 0 /* NOT REWRITE EQUIVALENCE SUMMARY */
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_SUMMARY_AGGREGATES"("OWNER",
select u.name, o.name, sa.sumcolpos#, c.name,
       decode(sa.aggfunction, 15, 'AVG', 16, 'SUM', 17, 'COUNT',
                              18, 'MIN', 19, 'MAX',
                              97, 'VARIANCE', 98, 'STDDEV',
                              440, 'USER'),
       decode(sa.flags, 0, 'N', 'Y'),
       sa.aggtext
from sys.sumagg$ sa, sys.obj$ o, sys.user$ u, sys.sum$ s, sys.col$ c
where sa.sumobj# = o.obj#
  AND o.owner# = u.user#
  AND sa.sumobj# = s.obj#
  AND c.obj# = s.containerobj#
  AND c.col# = sa.containercol#
  AND (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
  AND bitand(s.xpflags, 8388608) = 0 /* NOT REWRITE EQUIVALENCE SUMMARY */;

CREATE OR REPLACE FORCE VIEW "ALL_SUMMARY_DETAIL_TABLES"("OWNER",
select u.name, o.name, du.name,  do.name,
       decode (sd.detailobjtype, 1, 'TABLE', 2, 'VIEW',
                                3, 'SNAPSHOT', 4, 'CONTAINER', 'UNDEFINED'),
       sd.detailalias
from sys.user$ u, sys.sumdetail$ sd, sys.obj$ o, sys.obj$ do,
sys.user$ du, sys.sum$ s
where o.owner# = u.user#
  and o.obj# = sd.sumobj#
  and do.obj# = sd.detailobj#
  and do.owner# = du.user#
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
  and s.obj# = sd.sumobj#
  and bitand(s.xpflags, 8388608) = 0 /* NOT REWRITE EQUIVALENCE SUMMARY */;

CREATE OR REPLACE FORCE VIEW "ALL_SUMMARY_JOINS"("OWNER",
select u.name, o.name,
       u1.name, o1.name, c1.name, '=',
       u2.name, o2.name, c2.name
from sys.sumjoin$ sj, sys.obj$ o, sys.user$ u,
     sys.obj$ o1, sys.user$ u1, sys.col$ c1,
     sys.obj$ o2, sys.user$ u2, sys.col$ c2,
     sys.sum$ s
where sj.sumobj# = o.obj#
  AND o.owner# = u.user#
  AND sj.tab1obj# = o1.obj#
  AND o1.owner# = u1.user#
  AND sj.tab1obj# = c1.obj#
  AND sj.tab1col# = c1.intcol#
  AND sj.tab2obj# = o2.obj#
  AND o2.owner# = u2.user#
  AND sj.tab2obj# = c2.obj#
  AND sj.tab2col# = c2.intcol#
  AND (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
  AND s.obj# = sj.sumobj#
  AND bitand(s.xpflags, 8388608) = 0 /* NOT REWRITE EQUIVALENCE SUMMARY */;

CREATE OR REPLACE FORCE VIEW "ALL_SUMMARY_KEYS"("OWNER",
select u1.name, o1.name, sk.sumcolpos#, c1.name,
       u2.name, o2.name, sd.detailalias,
       decode(sk.detailobjtype, 1, 'TABLE', 2, 'VIEW'), c2.name
from sys.sumkey$ sk, sys.obj$ o1, sys.user$ u1, sys.col$ c1, sys.sum$ s,
     sys.sumdetail$ sd, sys.obj$ o2, sys.user$ u2, sys.col$ c2
where sk.sumobj# = o1.obj#
  AND o1.owner# = u1.user#
  AND sk.sumobj# = s.obj#
  AND s.containerobj# = c1.obj#
  AND c1.col# = sk.containercol#
  AND sk.detailobj# = o2.obj#
  AND o2.owner# = u2.user#
  AND sk.sumobj# = sd.sumobj#
  AND sk.detailobj# = sd.detailobj#
  AND sk.detailobj# = c2.obj#
  AND sk.detailcol# = c2.intcol#
  AND (o1.owner# = userenv('SCHEMAID')
       or o1.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
  AND bitand(s.xpflags, 8388608) = 0 /* NOT REWRITE EQUIVALENCE SUMMARY */;

CREATE OR REPLACE FORCE VIEW "ALL_SYNONYMS"("OWNER",
select u.name, o.name, s.owner, s.name, s.node
from sys.user$ u, sys.syn$ s, sys.obj$ o
where o.obj# = s.obj#
  and o.type# = 5
  and o.owner# = u.user#
  and (
       o.owner# in (USERENV('SCHEMAID'), 1 /* PUBLIC */)  /* user's private, any public */
       or /* user has any privs on base object */
        exists
        (select null from sys.objauth$ ba, sys.obj$ bo, sys.user$ bu
         where bu.name = s.owner
           and bo.name = s.name
           and bu.user# = bo.owner#
           and ba.obj# = bo.obj#
           and (   ba.grantee# in (select kzsrorol from x$kzsro)
                or ba.grantor# = USERENV('SCHEMAID')
                )
        )
        or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
       );

CREATE OR REPLACE FORCE VIEW "ALL_TABLES"("OWNER",
select u.name, o.name,decode(bitand(t.property, 2151678048), 0, ts.name, null),
       decode(bitand(t.property, 1024), 0, null, co.name),
       decode((bitand(t.property, 512)+bitand(t.flags, 536870912)),
              0, null, co.name),
       decode(bitand(t.property, 32+64), 0, mod(t.pctfree$, 100), 64, 0, null),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
          decode(bitand(t.property, 32+64), 0, t.pctused$, 64, 0, null)),
       decode(bitand(t.property, 32), 0, t.initrans, null),
       decode(bitand(t.property, 32), 0, t.maxtrans, null),
       s.iniexts * ts.blocksize,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                      s.extsize * ts.blocksize),
       s.minexts, s.maxexts,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                      s.extpct),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
         decode(bitand(o.flags, 2), 2, 1, decode(s.lists, 0, 1, s.lists))),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
         decode(bitand(o.flags, 2), 2, 1, decode(s.groups, 0, 1, s.groups))),
       decode(bitand(t.property, 32+64), 0,
                decode(bitand(t.flags, 32), 0, 'YES', 'NO'), null),
       decode(bitand(t.flags,1), 0, 'Y', 1, 'N', '?'),
       t.rowcnt,
       decode(bitand(t.property, 64), 0, t.blkcnt, null),
       decode(bitand(t.property, 64), 0, t.empcnt, null),
       decode(bitand(t.property, 64), 0, t.avgspc, null),
       t.chncnt, t.avgrln, t.avgspc_flb,
       decode(bitand(t.property, 64), 0, t.flbcnt, null),
       lpad(decode(t.degree, 32767, 'DEFAULT', nvl(t.degree,1)),10),
       lpad(decode(t.instances, 32767, 'DEFAULT', nvl(t.instances,1)),10),
       lpad(decode(bitand(t.flags, 8), 8, 'Y', 'N'),5),
       decode(bitand(t.flags, 6), 0, 'ENABLED', 'DISABLED'),
       t.samplesize, t.analyzetime,
       decode(bitand(t.property, 32), 32, 'YES', 'NO'),
       decode(bitand(t.property, 64), 64, 'IOT',
               decode(bitand(t.property, 512), 512, 'IOT_OVERFLOW',
               decode(bitand(t.flags, 536870912), 536870912, 'IOT_MAPPING', null))),
       decode(bitand(o.flags, 2), 0, 'N', 2, 'Y', 'N'),
       decode(bitand(o.flags, 16), 0, 'N', 16, 'Y', 'N'),
       decode(bitand(t.property, 8192), 8192, 'YES',
              decode(bitand(t.property, 1), 0, 'NO', 'YES')),
       decode(bitand(o.flags, 2), 2, 'DEFAULT',
             decode(s.cachehint, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL)),
       decode(bitand(t.flags, 131072), 131072, 'ENABLED', 'DISABLED'),
       decode(bitand(t.flags, 512), 0, 'NO', 'YES'),
       decode(bitand(t.flags, 256), 0, 'NO', 'YES'),
       decode(bitand(o.flags, 2), 0, NULL,
          decode(bitand(t.property, 8388608), 8388608,
                 'SYS$SESSION', 'SYS$TRANSACTION')),
       decode(bitand(t.flags, 1024), 1024, 'ENABLED', 'DISABLED'),
       decode(bitand(o.flags, 2), 2, 'NO',
           decode(bitand(t.property, 2147483648), 2147483648, 'NO',
              decode(ksppcv.ksppstvl, 'TRUE', 'YES', 'NO'))),
       decode(bitand(t.property, 1024), 0, null, cu.name),
       decode(bitand(t.flags, 8388608), 8388608, 'ENABLED', 'DISABLED'),
       decode(bitand(t.property, 32), 32, null,
                decode(bitand(s.spare1, 2048), 2048, 'ENABLED', 'DISABLED')),
       decode(bitand(o.flags, 128), 128, 'YES', 'NO')
from sys.user$ u, sys.ts$ ts, sys.seg$ s, sys.obj$ co, sys.tab$ t, sys.obj$ o,
     sys.obj$ cx, sys.user$ cu, x$ksppcv ksppcv, x$ksppi ksppi
where o.owner# = u.user#
  and o.obj# = t.obj#
  and bitand(t.property, 1) = 0
  and bitand(o.flags, 128) = 0
  and t.bobj# = co.obj# (+)
  and t.ts# = ts.ts#
  and t.file# = s.file# (+)
  and t.block# = s.block# (+)
  and t.ts# = s.ts# (+)
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
  and t.dataobj# = cx.obj# (+)
  and cx.owner# = cu.user# (+)
  and ksppi.indx = ksppcv.indx
  and ksppi.ksppinm = '_dml_monitoring_enabled';

CREATE OR REPLACE FORCE VIEW "ALL_TAB_COLS"("OWNER",
select u.name, o.name,
       c.name,
       decode(c.type#, 1, decode(c.charsetform, 2, 'NVARCHAR2', 'VARCHAR2'),
                       2, decode(c.scale, null,
                                 decode(c.precision#, null, 'NUMBER', 'FLOAT'),
                                 'NUMBER'),
                       8, 'LONG',
                       9, decode(c.charsetform, 2, 'NCHAR VARYING', 'VARCHAR'),
                       12, 'DATE',
                       23, 'RAW', 24, 'LONG RAW',
                       58, nvl2(ac.synobj#, (select o.name from obj$ o
                                where o.obj#=ac.synobj#), ot.name),
                       69, 'ROWID',
                       96, decode(c.charsetform, 2, 'NCHAR', 'CHAR'),
                       100, 'BINARY_FLOAT',
                       101, 'BINARY_DOUBLE',
                       105, 'MLSLABEL',
                       106, 'MLSLABEL',
                       111, nvl2(ac.synobj#, (select o.name from obj$ o
                                 where o.obj#=ac.synobj#), ot.name),
                       112, decode(c.charsetform, 2, 'NCLOB', 'CLOB'),
                       113, 'BLOB', 114, 'BFILE', 115, 'CFILE',
                       121, nvl2(ac.synobj#, (select o.name from obj$ o
                                 where o.obj#=ac.synobj#), ot.name),
                       122, nvl2(ac.synobj#, (select o.name from obj$ o
                                 where o.obj#=ac.synobj#), ot.name),
                       123, nvl2(ac.synobj#, (select o.name from obj$ o
                                 where o.obj#=ac.synobj#), ot.name),
                       178, 'TIME(' ||c.scale|| ')',
                       179, 'TIME(' ||c.scale|| ')' || ' WITH TIME ZONE',
                       180, 'TIMESTAMP(' ||c.scale|| ')',
                       181, 'TIMESTAMP(' ||c.scale|| ')' || ' WITH TIME ZONE',
                       231, 'TIMESTAMP(' ||c.scale|| ')' || ' WITH LOCAL TIME ZONE',
                       182, 'INTERVAL YEAR(' ||c.precision#||') TO MONTH',
                       183, 'INTERVAL DAY(' ||c.precision#||') TO SECOND(' ||
                             c.scale || ')',
                       208, 'UROWID',
                       'UNDEFINED'),
       decode(c.type#, 111, 'REF'),
       nvl2(ac.synobj#, (select u.name from user$ u, obj$ o
            where o.owner#=u.user# and o.obj#=ac.synobj#), ut.name),
       c.length, c.precision#, c.scale,
       decode(sign(c.null$),-1,'D', 0, 'Y', 'N'),
       decode(c.col#, 0, to_number(null), c.col#), c.deflength,
       c.default$, h.distcnt, h.lowval, h.hival, h.density, h.null_cnt,
       case when h.bucket_cnt > 255 then h.row_cnt else
         decode(h.row_cnt, h.distcnt, h.row_cnt, h.bucket_cnt)
       end,
       h.timestamp#, h.sample_size,
       decode(c.charsetform, 1, 'CHAR_CS',
                             2, 'NCHAR_CS',
                             3, NLS_CHARSET_NAME(c.charsetid),
                             4, 'ARG:'||c.charsetid),
       decode(c.charsetid, 0, to_number(NULL),
                           nls_charset_decl_len(c.length, c.charsetid)),
       decode(bitand(h.spare2, 2), 2, 'YES', 'NO'),
       decode(bitand(h.spare2, 1), 1, 'YES', 'NO'),
       h.avgcln,
       c.spare3,
       decode(c.type#, 1, decode(bitand(c.property, 8388608), 0, 'B', 'C'),
                      96, decode(bitand(c.property, 8388608), 0, 'B', 'C'),
                      null),
       decode(bitand(ac.flags, 128), 128, 'YES', 'NO'),
       decode(o.status, 1, decode(bitand(ac.flags, 256), 256, 'NO', 'YES'),
                        decode(bitand(ac.flags, 2), 2, 'NO',
                               decode(bitand(ac.flags, 4), 4, 'NO',
                                      decode(bitand(ac.flags, 8), 8, 'NO',
                                             'N/A')))),
       decode(c.property, 0, 'NO', decode(bitand(c.property, 32), 32, 'YES',
                                          'NO')),
       decode(c.property, 0, 'NO', decode(bitand(c.property, 8), 8, 'YES',
                                          'NO')),
       decode(c.segcol#, 0, to_number(null), c.segcol#), c.intcol#,
       case when h.bucket_cnt > 255 then 'FREQUENCY' else
         decode(nvl(h.row_cnt, 0), 0, 'NONE',
                                   h.distcnt, 'FREQUENCY', 'HEIGHT BALANCED')
       end,
       decode(bitand(c.property, 1024), 1024,
              (select decode(bitand(cl.property, 1), 1, rc.name, cl.name)
               from sys.col$ cl, attrcol$ rc where cl.intcol# = c.intcol#-1
               and cl.obj# = c.obj# and c.obj# = rc.obj#(+) and
               cl.intcol# = rc.intcol#(+)),
              decode(bitand(c.property, 1), 0, c.name,
                     (select tc.name from sys.attrcol$ tc
                      where c.obj# = tc.obj# and c.intcol# = tc.intcol#)))
from sys.col$ c, sys.obj$ o, sys.hist_head$ h, sys.user$ u,
     sys.coltype$ ac, sys.obj$ ot, sys.user$ ut
where o.obj# = c.obj#
  and o.owner# = u.user#
  and c.obj# = h.obj#(+) and c.intcol# = h.intcol#(+)
  and c.obj# = ac.obj#(+) and c.intcol# = ac.intcol#(+)
  and ac.toid = ot.oid$(+)
  and ot.type#(+) = 13
  and ot.owner# = ut.user#(+)
  and (o.type# in (3, 4)                                     /* cluster, view */
       or
       (o.type# = 2     /* tables, excluding iot - overflow and nested tables */
        and
        not exists (select null
                      from sys.tab$ t
                     where t.obj# = o.obj#
                       and (bitand(t.property, 512) = 512 or
                            bitand(t.property, 8192) = 8192))))
  and (o.owner# = userenv('SCHEMAID')
        or
        o.obj# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                  )
        or /* user has system privileges */
          exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                  )
       );

CREATE OR REPLACE FORCE VIEW "ALL_TAB_COLUMNS"("OWNER",
select /*+ rule */ OWNER, TABLE_NAME,
       COLUMN_NAME, DATA_TYPE, DATA_TYPE_MOD, DATA_TYPE_OWNER,
       DATA_LENGTH, DATA_PRECISION, DATA_SCALE, NULLABLE, COLUMN_ID,
       DEFAULT_LENGTH, DATA_DEFAULT, NUM_DISTINCT, LOW_VALUE, HIGH_VALUE,
       DENSITY, NUM_NULLS, NUM_BUCKETS, LAST_ANALYZED, SAMPLE_SIZE,
       CHARACTER_SET_NAME, CHAR_COL_DECL_LENGTH,
       GLOBAL_STATS, USER_STATS, AVG_COL_LEN, CHAR_LENGTH, CHAR_USED,
       V80_FMT_IMAGE, DATA_UPGRADED, HISTOGRAM
  from ALL_TAB_COLS
 where HIDDEN_COLUMN = 'NO';

CREATE OR REPLACE FORCE VIEW "ALL_TAB_COL_STATISTICS"("OWNER",
select owner, table_name, column_name, num_distinct, low_value, high_value,
       density, num_nulls, num_buckets, last_analyzed, sample_size,
       global_stats, user_stats, avg_col_len, HISTOGRAM
from all_tab_columns
where last_analyzed is not null
union all
select /* fixed table column stats */
       'SYS', ft.kqftanam, c.kqfconam,
       h.distcnt, h.lowval, h.hival,
       h.density, h.null_cnt,
       case when h.bucket_cnt > 255 then h.row_cnt else
         decode(h.row_cnt, h.distcnt, h.row_cnt, h.bucket_cnt)
       end,
       h.timestamp#, h.sample_size,
       decode(bitand(h.spare2, 2), 2, 'YES', 'NO'),
       decode(bitand(h.spare2, 1), 1, 'YES', 'NO'),
       h.avgcln,
       case when h.bucket_cnt > 255 then 'FREQUENCY' else
         decode(nvl(h.row_cnt, 0), 0, 'NONE',
                                   h.distcnt, 'FREQUENCY', 'HEIGHT BALANCED')
       end
from   sys.x$kqfta ft, sys.fixed_obj$ fobj,
         sys.x$kqfco c, sys.hist_head$ h
where
       ft.kqftaobj = fobj. obj#
       and c.kqfcotob = ft.kqftaobj
       and h.obj# = ft.kqftaobj
       and h.intcol# = c.kqfcocno
       /*
        * if fobj and st are not in sync (happens when db open read only
        * after upgrade), do not display stats.
        */
       and ft.kqftaver =
             fobj.timestamp - to_date('01-01-1991', 'DD-MM-YYYY')
       and h.timestamp# is not null
       and (userenv('SCHEMAID') = 0  /* SYS */
            or /* user has system privileges */
            exists (select null from v$enabledprivs
                    where priv_number in (-237 /* SELECT ANY DICTIONARY */)
                   )
           );

CREATE OR REPLACE FORCE VIEW "ALL_TAB_COMMENTS"("OWNER",
select u.name, o.name,
       decode(o.type#, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 'UNDEFINED'),
       c.comment$
from sys.obj$ o, sys.user$ u, sys.com$ c
where o.owner# = u.user#
  and o.obj# = c.obj#(+)
  and c.col#(+) is null
  and (o.type# in (4)                                                /* view */
       or
       (o.type# = 2                                                /* tables */
        AND         /* excluding iot-overflow, nested or mv container tables */
        not exists (select null
                      from sys.tab$ t
                     where t.obj# = o.obj#
                       and (bitand(t.property, 512) = 512 or
                            bitand(t.property, 8192) = 8192 OR
                            bitand(t.property, 67108864) = 67108864))))
  and (o.owner# = userenv('SCHEMAID')
        or
        o.obj# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                  )
        or /* user has system privileges */
          exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                  )
       );

CREATE OR REPLACE FORCE VIEW "ALL_TAB_HISTOGRAMS"("OWNER",
select /*+ ordered */ u.name,
       o.name,
       decode(bitand(c.property, 1), 1, a.name, c.name),
       h.bucket,
       h.endpoint,
       h.epvalue
from sys.user$ u, sys.obj$ o, sys.col$ c, sys.histgrm$ h, sys.attrcol$ a
where o.obj# = c.obj#
  and (o.owner# = userenv('SCHEMAID')
        or
        o.obj# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                  )
        or /* user has system privileges */
          exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                  )
       )
  and o.owner# = u.user#
  and c.obj# = h.obj# and c.intcol# = h.intcol#
  and (o.type# in (3, 4)                                     /* cluster, view */
       or
       (o.type# = 2     /* tables, excluding iot - overflow and nested tables */
        and
        not exists (select null
                      from sys.tab$ t
                     where t.obj# = o.obj#
                       and (bitand(t.property, 512) = 512 or
                            bitand(t.property, 8192) = 8192))))
  and c.obj# = a.obj#(+)
  and c.intcol# = a.intcol#(+)
union all
select /*+ ordered */ u.name,
       o.name,
       decode(bitand(c.property, 1), 1, a.name, c.name),
       0,
       h.minimum,
       null
from sys.user$ u, sys.obj$ o, sys.col$ c, sys.hist_head$ h, sys.attrcol$ a
where o.obj# = c.obj#
  and (o.owner# = userenv('SCHEMAID')
        or
        o.obj# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                  )
        or /* user has system privileges */
          exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                  )
       )
  and o.owner# = u.user#
  and c.obj# = h.obj# and c.intcol# = h.intcol#
  and (o.type# in (3, 4)                                     /* cluster, view */
       or
       (o.type# = 2     /* tables, excluding iot - overflow and nested tables */
        and
        not exists (select null
                      from sys.tab$ t
                     where t.obj# = o.obj#
                       and (bitand(t.property, 512) = 512 or
                            bitand(t.property, 8192) = 8192))))
  and h.bucket_cnt = 1
  and c.obj# = a.obj#(+)
  and c.intcol# = a.intcol#(+)
union all
select /*+ ordered */ u.name,
       o.name,
       decode(bitand(c.property, 1), 1, a.name, c.name),
       1,
       h.maximum,
       null
from sys.user$ u, sys.obj$ o, sys.col$ c, sys.hist_head$ h, sys.attrcol$ a
where o.obj# = c.obj#
  and (o.owner# = userenv('SCHEMAID')
        or
        o.obj# in ( select obj#
                    from sys.objauth$
                    where grantee# in ( select kzsrorol
                                         from x$kzsro
                                       )
                  )
        or /* user has system privileges */
          exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                  )
       )
  and o.owner# = u.user#
  and c.obj# = h.obj# and c.intcol# = h.intcol#
  and (o.type# in (3, 4)                                     /* cluster, view */
       or
       (o.type# = 2     /* tables, excluding iot - overflow and nested tables */
        and
        not exists (select null
                      from sys.tab$ t
                     where t.obj# = o.obj#
                       and (bitand(t.property, 512) = 512 or
                            bitand(t.property, 8192) = 8192))))
  and h.bucket_cnt = 1
  and c.obj# = a.obj#(+)
  and c.intcol# = a.intcol#(+)
union all
select /*+ ordered */
       'SYS',
       ft.kqftanam,
       c.kqfconam,
       h.bucket,
       h.endpoint,
       h.epvalue
from   sys.x$kqfta ft, sys.fixed_obj$ fobj, sys.x$kqfco c, sys.histgrm$ h
where  ft.kqftaobj = fobj. obj#
  and c.kqfcotob = ft.kqftaobj
  and h.obj# = ft.kqftaobj
  and h.intcol# = c.kqfcocno
  /*
   * if fobj and st are not in sync (happens when db open read only
   * after upgrade), do not display stats.
   */
  and ft.kqftaver =
         fobj.timestamp - to_date('01-01-1991', 'DD-MM-YYYY')
  and (userenv('SCHEMAID') = 0  /* SYS */
       or /* user has system privileges */
       exists (select null from v$enabledprivs
               where priv_number in (-237 /* SELECT ANY DICTIONARY */)
              )
      );

CREATE OR REPLACE FORCE VIEW "ALL_TAB_MODIFICATIONS"("TABLE_OWNER",
select u.name, o.name, null, null,
       m.inserts, m.updates, m.deletes, m.timestamp,
       decode(bitand(m.flags,1),1,'YES','NO'),
       m.drop_segments
from sys.mon_mods$ m, sys.obj$ o, sys.tab$ t, sys.user$ u
where o.obj# = m.obj# and o.obj# = t.obj# and o.owner# = u.user#
      and (o.owner# = userenv('SCHEMAID')
           or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in (select kzsrorol from x$kzsro))
           or /* user has system privileges */
             exists (select null from v$enabledprivs
                       where priv_number in (-45 /* LOCK ANY TABLE */,
                                             -47 /* SELECT ANY TABLE */,
                                             -48 /* INSERT ANY TABLE */,
                                             -49 /* UPDATE ANY TABLE */,
                                             -50 /* DELETE ANY TABLE */,
                                             -165/* ANALYZE ANY */))
          )
union all
select u.name, o.name, o.subname, null,
       m.inserts, m.updates, m.deletes, m.timestamp,
       decode(bitand(m.flags,1),1,'YES','NO'),
       m.drop_segments
from sys.mon_mods$ m, sys.obj$ o, sys.user$ u
where o.owner# = u.user# and o.obj# = m.obj# and o.type#=19
      and (o.owner# = userenv('SCHEMAID')
           or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in (select kzsrorol from x$kzsro))
           or /* user has system privileges */
             exists (select null from v$enabledprivs
                       where priv_number in (-45 /* LOCK ANY TABLE */,
                                             -47 /* SELECT ANY TABLE */,
                                             -48 /* INSERT ANY TABLE */,
                                             -49 /* UPDATE ANY TABLE */,
                                             -50 /* DELETE ANY TABLE */,
                                             -165/* ANALYZE ANY */))
          )
union all
select u.name, o.name, o2.subname, o.subname,
       m.inserts, m.updates, m.deletes, m.timestamp,
       decode(bitand(m.flags,1),1,'YES','NO'),
       m.drop_segments
from sys.mon_mods$ m, sys.obj$ o, sys.tabsubpart$ tsp, sys.obj$ o2,
     sys.user$ u
where o.obj# = m.obj# and o.owner# = u.user# and
      o.obj# = tsp.obj# and o2.obj# = tsp.pobj#
      and (o.owner# = userenv('SCHEMAID')
           or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in (select kzsrorol from x$kzsro))
           or /* user has system privileges */
             exists (select null from v$enabledprivs
                       where priv_number in (-45 /* LOCK ANY TABLE */,
                                             -47 /* SELECT ANY TABLE */,
                                             -48 /* INSERT ANY TABLE */,
                                             -49 /* UPDATE ANY TABLE */,
                                             -50 /* DELETE ANY TABLE */,
                                             -165/* ANALYZE ANY */))
          );

CREATE OR REPLACE FORCE VIEW "ALL_TAB_PARTITIONS"("TABLE_OWNER",
select u.name, o.name, 'NO', o.subname, 0,
       tp.hiboundval, tp.hiboundlen, tp.part#, ts.name,
       tp.pctfree$,
       decode(bitand(ts.flags, 32), 32, to_number(NULL), tp.pctused$),
             initrans, maxtrans, s.iniexts * ts.blocksize,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
                               s.extsize * ts.blocksize),
       s.minexts, s.maxexts,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                      s.extpct),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
          decode(s.lists, 0, 1, s.lists)),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
          decode(s.groups, 0, 1, s.groups)),
       decode(mod(trunc(tp.flags / 4), 2), 0, 'YES', 'NO'),
       decode(bitand(s.spare1, 2048), 2048, 'ENABLED', 'DISABLED'),
       tp.rowcnt, tp.blkcnt, tp.empcnt, tp.avgspc, tp.chncnt, tp.avgrln,
       tp.samplesize, tp.analyzetime,
       decode(s.cachehint, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL),
       decode(bitand(tp.flags, 16), 0, 'NO', 'YES'),
       decode(bitand(tp.flags, 8), 0, 'NO', 'YES')
from   obj$ o, tabpartv$ tp, ts$ ts, sys.seg$ s, user$ u
where  o.obj# = tp.obj# and ts.ts# = tp.ts# and u.user# = o.owner# and
       tp.file#=s.file# and tp.block#=s.block# and tp.ts#=s.ts# and
       (o.owner# = userenv('SCHEMAID')
        or tp.bo# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
        or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
union all -- IOT Partitions
select u.name, o.name, 'NO', o.subname, 0,
       tp.hiboundval, tp.hiboundlen, tp.part#, NULL,
       TO_NUMBER(NULL),TO_NUMBER(NULL),TO_NUMBER(NULL),TO_NUMBER(NULL),
       TO_NUMBER(NULL),
       TO_NUMBER(NULL),TO_NUMBER(NULL),TO_NUMBER(NULL),TO_NUMBER(NULL),
       TO_NUMBER(NULL),TO_NUMBER(NULL),
       NULL,
       'N/A',
       tp.rowcnt, TO_NUMBER(NULL), TO_NUMBER(NULL), 0, tp.chncnt, tp.avgrln,
       tp.samplesize, tp.analyzetime, NULL,
       decode(bitand(tp.flags, 16), 0, 'NO', 'YES'),
       decode(bitand(tp.flags, 8), 0, 'NO', 'YES')
from   obj$ o, tabpartv$ tp, user$ u
where  o.obj# = tp.obj# and o.owner# = u.user# and
       tp.file#=0 and tp.block#=0 and
       (o.owner# = userenv('SCHEMAID')
        or tp.bo# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
        or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
union all -- Composite Partitions
select u.name, o.name, 'YES', o.subname, tcp.subpartcnt,
       tcp.hiboundval, tcp.hiboundlen, tcp.part#, ts.name,
       tcp.defpctfree,
       decode(bitand(ts.flags, 32), 32, to_number(NULL), tcp.defpctused),
       tcp.definitrans, tcp.defmaxtrans,
       tcp.definiexts, tcp.defextsize, tcp.defminexts, tcp.defmaxexts,
       tcp.defextpct,
       decode(bitand(ts.flags, 32), 32, to_number(NULL), tcp.deflists),
       decode(bitand(ts.flags, 32), 32, to_number(NULL), tcp.defgroups),
       decode(tcp.deflogging, 0, 'NONE', 1, 'YES', 2, 'NO', 'UNKNOWN'),
       decode(mod(tcp.spare2,256), 0, 'NONE', 1, 'ENABLED', 2, 'DISABLED',
                                   'UNKNOWN'),
       tcp.rowcnt, tcp.blkcnt, tcp.empcnt, tcp.avgspc, tcp.chncnt, tcp.avgrln,
       tcp.samplesize, tcp.analyzetime,
       decode(tcp.defbufpool, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL),
       decode(bitand(tcp.flags, 16), 0, 'NO', 'YES'),
       decode(bitand(tcp.flags, 8), 0, 'NO', 'YES')
from   obj$ o, tabcompartv$ tcp, ts$ ts, user$ u
where  o.obj# = tcp.obj# and tcp.defts# = ts.ts#  and u.user# = o.owner# and
       (o.owner# = userenv('SCHEMAID')
        or tcp.bo# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
        or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_TAB_PRIVS"("GRANTOR",
select ur.name, ue.name, u.name, o.name, tpm.name,
       decode(mod(oa.option$,2), 1, 'YES', 'NO'),
       decode(bitand(oa.option$,2), 2, 'YES', 'NO')
from sys.objauth$ oa, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue,
     table_privilege_map tpm
where oa.obj# = o.obj#
  and oa.grantor# = ur.user#
  and oa.grantee# = ue.user#
  and oa.col# is null
  and u.user# = o.owner#
  and oa.privilege# = tpm.privilege
  and (oa.grantor# = userenv('SCHEMAID') or
       oa.grantee# in (select kzsrorol from x$kzsro) or
       o.owner# = userenv('SCHEMAID'));

CREATE OR REPLACE FORCE VIEW "ALL_TAB_PRIVS_MADE"("GRANTEE",
select ue.name, u.name, o.name, ur.name, tpm.name,
       decode(mod(oa.option$,2), 1, 'YES', 'NO'),
       decode(bitand(oa.option$,2), 2, 'YES', 'NO')
from sys.objauth$ oa, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue,
     table_privilege_map tpm
where oa.obj# = o.obj#
  and oa.grantor# = ur.user#
  and oa.grantee# = ue.user#
  and u.user# = o.owner#
  and oa.col# is null
  and oa.privilege# = tpm.privilege
  and userenv('SCHEMAID') in (o.owner#, oa.grantor#);

CREATE OR REPLACE FORCE VIEW "ALL_TAB_PRIVS_RECD"("GRANTEE",
select ue.name, u.name, o.name, ur.name, tpm.name,
       decode(mod(oa.option$,2), 1, 'YES', 'NO'),
       decode(bitand(oa.option$,2), 2, 'YES', 'NO')
from sys.objauth$ oa, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue,
     table_privilege_map tpm
where oa.obj# = o.obj#
  and oa.grantor# = ur.user#
  and oa.grantee# = ue.user#
  and u.user# = o.owner#
  and oa.col# is null
  and oa.privilege# = tpm.privilege
  and oa.grantee# in (select kzsrorol from x$kzsro);

CREATE OR REPLACE FORCE VIEW "ALL_TAB_STATISTICS"("OWNER",
SELECT /* TABLES */
    u.name, o.name, NULL, NULL, NULL, NULL, 'TABLE', t.rowcnt,
    decode(bitand(t.property, 64), 0, t.blkcnt, TO_NUMBER(NULL)),
    decode(bitand(t.property, 64), 0, t.empcnt, TO_NUMBER(NULL)),
    decode(bitand(t.property, 64), 0, t.avgspc, TO_NUMBER(NULL)),
    t.chncnt, t.avgrln, t.avgspc_flb,
    decode(bitand(t.property, 64), 0, t.flbcnt, TO_NUMBER(NULL)),
    ts.cachedblk, ts.cachehit, t.samplesize, t.analyzetime,
    decode(bitand(t.flags, 512), 0, 'NO', 'YES'),
    decode(bitand(t.flags, 256), 0, 'NO', 'YES'),
    decode(bitand(t.trigflag, 67108864) + bitand(t.trigflag, 134217728),
           0, NULL, 67108864, 'DATA', 134217728, 'CACHE', 'ALL')
  FROM
    sys.user$ u, sys.obj$ o, sys.tab$ t, sys.tab_stats$ ts
  WHERE
        o.owner# = u.user#
    and o.obj# = t.obj#
    and bitand(t.property, 1) = 0 /* not a typed table */
    and o.obj# = ts.obj# (+)
    and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
  UNION ALL
  SELECT /* PARTITIONS,  NOT IOT */
    u.name, o.name, o.subname, tp.part#, NULL, NULL, 'PARTITION',
    tp.rowcnt, tp.blkcnt, tp.empcnt, tp.avgspc,
    tp.chncnt, tp.avgrln, TO_NUMBER(NULL), TO_NUMBER(NULL),
    ts.cachedblk, ts.cachehit, tp.samplesize, tp.analyzetime,
    decode(bitand(tp.flags, 16), 0, 'NO', 'YES'),
    decode(bitand(tp.flags, 8), 0, 'NO', 'YES'),
    decode(bitand(tab.trigflag, 67108864) + bitand(tab.trigflag, 134217728),
           0, NULL, 67108864, 'DATA', 134217728, 'CACHE', 'ALL')
  FROM
    sys.user$ u, sys.obj$ o, sys.tabpartv$ tp, sys.tab_stats$ ts, sys.tab$ tab
  WHERE
        o.owner# = u.user#
    and o.obj# = tp.obj#
    and tp.bo# = tab.obj#
    and tp.file# > 0
    and tp.block# > 0
    and o.obj# = ts.obj# (+)
    and (o.owner# = userenv('SCHEMAID')
        or tp.bo# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
        or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
  UNION ALL
  SELECT /* IOT Partitions */
    u.name, o.name, o.subname, tp.part#, NULL, NULL, 'PARTITION',
    tp.rowcnt, TO_NUMBER(NULL), TO_NUMBER(NULL), TO_NUMBER(NULL),
    tp.chncnt, tp.avgrln, TO_NUMBER(NULL), TO_NUMBER(NULL),
    TO_NUMBER(NULL), TO_NUMBER(NULL), tp.samplesize, tp.analyzetime,
    decode(bitand(tp.flags, 16), 0, 'NO', 'YES'),
    decode(bitand(tp.flags, 8), 0, 'NO', 'YES'),
    decode(bitand(tab.trigflag, 67108864) + bitand(tab.trigflag, 134217728),
           0, NULL, 67108864, 'DATA', 134217728, 'CACHE', 'ALL')
  FROM
    sys.user$ u, sys.obj$ o, sys.tabpartv$ tp, sys.tab$ tab
  WHERE
        o.owner# = u.user#
    and o.obj# = tp.obj#
    and tp.bo# = tab.obj#
    and tp.file# = 0
    and tp.block# = 0
    and (o.owner# = userenv('SCHEMAID')
        or tp.bo# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
        or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
  UNION ALL
  SELECT /* COMPOSITE PARTITIONS */
    u.name, o.name, o.subname, tcp.part#, NULL, NULL, 'PARTITION',
    tcp.rowcnt, tcp.blkcnt, tcp.empcnt, tcp.avgspc,
    tcp.chncnt, tcp.avgrln, NULL, NULL, ts.cachedblk, ts.cachehit,
    tcp.samplesize, tcp.analyzetime,
    decode(bitand(tcp.flags, 16), 0, 'NO', 'YES'),
    decode(bitand(tcp.flags, 8), 0, 'NO', 'YES'),
    decode(bitand(tab.trigflag, 67108864) + bitand(tab.trigflag, 134217728),
           0, NULL, 67108864, 'DATA', 134217728, 'CACHE', 'ALL')
  FROM
    sys.user$ u, sys.obj$ o, sys.tabcompartv$ tcp,
    sys.tab_stats$ ts, sys.tab$ tab
  WHERE
        o.owner# = u.user#
    and o.obj# = tcp.obj#
    and tcp.bo# = tab.obj#
    and o.obj# = ts.obj# (+)
    and (o.owner# = userenv('SCHEMAID')
        or tcp.bo# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
        or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
  UNION ALL
  SELECT /* SUBPARTITIONS */
    u.name, po.name, po.subname, tcp.part#,  so.subname, tsp.subpart#,
   'SUBPARTITION', tsp.rowcnt,
    tsp.blkcnt, tsp.empcnt, tsp.avgspc,
    tsp.chncnt, tsp.avgrln, NULL, NULL,
    ts.cachedblk, ts.cachehit, tsp.samplesize, tsp.analyzetime,
    decode(bitand(tsp.flags, 16), 0, 'NO', 'YES'),
    decode(bitand(tsp.flags, 8), 0, 'NO', 'YES'),
    decode(bitand(tab.trigflag, 67108864) + bitand(tab.trigflag, 134217728),
           0, NULL, 67108864, 'DATA', 134217728, 'CACHE', 'ALL')
  FROM
    sys.user$ u, sys.obj$ po, sys.obj$ so, sys.tabcompartv$ tcp,
    sys.tabsubpartv$ tsp,  sys.tab_stats$ ts, sys.tab$ tab
  WHERE
        so.obj# = tsp.obj#
    and po.obj# = tcp.obj#
    and tcp.obj# = tsp.pobj#
    and tcp.bo# = tab.obj#
    and u.user# = po.owner#
    and tsp.file# > 0
    and tsp.block# > 0
    and so.obj# = ts.obj# (+)
    and (po.owner# = userenv('SCHEMAID')
         or tcp.bo# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
        or /* user has system privileges */
          exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                 )
       )
  UNION ALL
  SELECT /* FIXED TABLES */
    'SYS', t.kqftanam, NULL, NULL, NULL, NULL, 'FIXED TABLE',
    decode(nvl(fobj.obj#, 0), 0, TO_NUMBER(NULL), st.rowcnt),
    TO_NUMBER(NULL), TO_NUMBER(NULL), TO_NUMBER(NULL), TO_NUMBER(NULL),
    decode(nvl(fobj.obj#, 0), 0, TO_NUMBER(NULL), st.avgrln),
    TO_NUMBER(NULL), TO_NUMBER(NULL), TO_NUMBER(NULL), TO_NUMBER(NULL),
    decode(nvl(fobj.obj#, 0), 0, TO_NUMBER(NULL), st.samplesize),
    decode(nvl(fobj.obj#, 0), 0, TO_DATE(NULL), st.analyzetime),
    decode(nvl(fobj.obj#, 0), 0, NULL,
           decode(nvl(st.obj#, 0), 0, NULL, 'YES')),
    decode(nvl(fobj.obj#, 0), 0, NULL,
           decode(nvl(st.obj#, 0), 0, NULL,
                  decode(bitand(st.flags, 1), 0, 'NO', 'YES'))),
    decode(nvl(fobj.obj#, 0), 0, NULL,
           decode (bitand(fobj.flags, 67108864) +
                     bitand(fobj.flags, 134217728),
                   0, NULL, 67108864, 'DATA', 134217728, 'CACHE', 'ALL'))
    from sys.x$kqfta t, sys.fixed_obj$ fobj, sys.tab_stats$ st
    where
    t.kqftaobj = fobj.obj#(+)
    /*
     * if fobj and st are not in sync (happens when db open read only
     * after upgrade), do not display stats.
     */
    and t.kqftaver = fobj.timestamp (+) - to_date('01-01-1991', 'DD-MM-YYYY')
    and t.kqftaobj = st.obj#(+)
    and (userenv('SCHEMAID') = 0  /* SYS */
         or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-237 /* SELECT ANY DICTIONARY */)
                 )
        );

CREATE OR REPLACE FORCE VIEW "ALL_TAB_STATS_HISTORY"("OWNER",
select /*+ rule */ u.name, o.name, null, null, h.savtime
  from sys.user$ u, sys.obj$ o, sys.wri$_optstat_tab_history h
  where  h.obj# = o.obj# and o.type# = 2 and o.owner# = u.user#
    and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
  union all
  -- partitions
  select u.name, o.name, o.subname, null, h.savtime
  from  sys.user$ u, sys.obj$ o, sys.obj$ ot,
        sys.wri$_optstat_tab_history h
  where h.obj# = o.obj# and o.type# = 19 and o.owner# = u.user#
        and ot.name = o.name and ot.type# = 2 and ot.owner# = u.user#
        and (ot.owner# = userenv('SCHEMAID')
        or ot.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
        or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                )
        )
  union all
  -- sub partitions
  select u.name, osp.name, ocp.subname, osp.subname, h.savtime
  from  sys.user$ u, sys.obj$ osp, obj$ ocp,  sys.obj$ ot,
        sys.tabsubpart$ tsp, sys.wri$_optstat_tab_history h
  where h.obj# = osp.obj# and osp.type# = 34 and osp.obj# = tsp.obj# and
        tsp.pobj# = ocp.obj# and osp.owner# = u.user#
        and ot.name = ocp.name and ot.type# = 2 and ot.owner# = u.user#
        and  (ot.owner# = userenv('SCHEMAID')
        or ot.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
        or /* user has system privileges */
          exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                 )
        )
  union all
  -- fixed tables
  select 'SYS', t.kqftanam, null, null, h.savtime
  from  sys.x$kqfta t, sys.wri$_optstat_tab_history h
  where
  t.kqftaobj = h.obj#
    and (userenv('SCHEMAID') = 0  /* SYS */
         or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-237 /* SELECT ANY DICTIONARY */)
                 )
        );

CREATE OR REPLACE FORCE VIEW "ALL_TAB_SUBPARTITIONS"("TABLE_OWNER",
select u.name, po.name, po.subname, so.subname,
       tsp.hiboundval, tsp.hiboundlen, tsp.subpart#,
       ts.name, tsp.pctfree$,
       decode(bitand(ts.flags, 32), 32, to_number(NULL), tsp.pctused$),
       tsp.initrans, tsp.maxtrans, s.iniexts * ts.blocksize,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
                               s.extsize * ts.blocksize),
       s.minexts, s.maxexts,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                      s.extpct),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
           decode(s.lists, 0, 1, s.lists)),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
           decode(s.groups, 0, 1, s.groups)),
       decode(mod(trunc(tsp.flags / 4), 2), 0, 'YES', 'NO'),
       decode(bitand(s.spare1, 2048), 2048, 'ENABLED', 'DISABLED'),
       tsp.rowcnt, tsp.blkcnt, tsp.empcnt, tsp.avgspc, tsp.chncnt,
       tsp.avgrln, tsp.samplesize, tsp.analyzetime,
       decode(s.cachehint, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL),
       decode(bitand(tsp.flags, 16), 0, 'NO', 'YES'),
       decode(bitand(tsp.flags, 8), 0, 'NO', 'YES')
from   obj$ po, obj$ so, tabcompartv$ tcp, tabsubpartv$ tsp, ts$ ts,
       sys.seg$ s, user$ u
where  so.obj# = tsp.obj# and po.obj# = tcp.obj# and tcp.obj# = tsp.pobj# and
       ts.ts# = tsp.ts# and u.user# = po.owner# and tsp.file#=s.file# and
       tsp.block#=s.block# and tsp.ts#=s.ts# and
       (po.owner# = userenv('SCHEMAID')
        or tcp.bo# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
        or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_TRIGGERS"("OWNER",
select triguser.name, trigobj.name,
decode(t.type#, 0, 'BEFORE STATEMENT',
                1, 'BEFORE EACH ROW',
                2, 'AFTER STATEMENT',
                3, 'AFTER EACH ROW',
                4, 'INSTEAD OF',
                   'UNDEFINED'),
decode(t.insert$*100 + t.update$*10 + t.delete$,
                 100, 'INSERT',
                 010, 'UPDATE',
                 001, 'DELETE',
                 110, 'INSERT OR UPDATE',
                 101, 'INSERT OR DELETE',
                 011, 'UPDATE OR DELETE',
                 111, 'INSERT OR UPDATE OR DELETE', 'ERROR'),
tabuser.name,
decode(bitand(t.property, 1), 1, 'VIEW',
                              0, 'TABLE',
                                 'UNDEFINED'),
tabobj.name, NULL,
'REFERENCING NEW AS '||t.refnewname||' OLD AS '||t.refoldname,
t.whenclause,decode(t.enabled, 0, 'DISABLED', 1, 'ENABLED', 'ERROR'),
t.definition,
decode(bitand(t.property, 2), 2, 'CALL',
                                 'PL/SQL     '),
t.action#
from sys.obj$ trigobj, sys.obj$ tabobj, sys.trigger$ t, sys.user$ tabuser,
     sys.user$ triguser
where (trigobj.obj#   = t.obj# and
       tabobj.obj#    = t.baseobject and
       trigobj.owner# = triguser.user# and
       tabobj.owner#  = tabuser.user# and
       bitand(t.property, 63)    < 8  and
       (
        trigobj.owner# = userenv('SCHEMAID') or
        tabobj.owner# = userenv('SCHEMAID') or
        tabobj.obj# in
          (select oa1.obj# from sys.objauth$ oa1 where grantee# in
             (select kzsrorol from x$kzsro)) or
        exists (select null from v$enabledprivs
                where priv_number = -152 /* CREATE ANY TRIGGER */)))
union all
select triguser.name, trigobj.name,
decode(t.type#, 0, 'BEFORE EVENT',
                2, 'AFTER EVENT',
                   'UNDEFINED'),
decode(bitand(t.sys_evts, 1), 1, 'STARTUP ') ||
decode(bitand(t.sys_evts, 2), 2,
       decode(sign(bitand(t.sys_evts, 1)), 1, 'OR SHUTDOWN ',
                                               'SHUTDOWN ')) ||
decode(bitand(t.sys_evts, 4), 4,
       decode(sign(bitand(t.sys_evts, 3)), 1, 'OR ERROR ',
                                              'ERROR ')) ||
decode(bitand(t.sys_evts, 8), 8,
       decode(sign(bitand(t.sys_evts, 7)), 1, 'OR LOGON ',
                                              'LOGON ')) ||
decode(bitand(t.sys_evts, 16), 16,
       decode(sign(bitand(t.sys_evts, 15)), 1, 'OR LOGOFF ',
                                               'LOGOFF ')) ||
decode(bitand(t.sys_evts, 262176), 32,
       decode(sign(bitand(t.sys_evts, 31)), 1, 'OR CREATE ',
                                               'CREATE ')) ||
decode(bitand(t.sys_evts, 262208), 64,
       decode(sign(bitand(t.sys_evts, 63)), 1, 'OR ALTER ',
                                               'ALTER ')) ||
decode(bitand(t.sys_evts, 262272), 128,
       decode(sign(bitand(t.sys_evts, 127)), 1, 'OR DROP ',
                                                'DROP ')) ||
decode (bitand(t.sys_evts, 262400), 256,
        decode(sign(bitand(t.sys_evts, 255)), 1, 'OR ANALYZE ',
                                                 'ANALYZE ')) ||
decode (bitand(t.sys_evts, 262656), 512,
        decode(sign(bitand(t.sys_evts, 511)), 1, 'OR COMMENT ',
                                                 'COMMENT ')) ||
decode (bitand(t.sys_evts, 263168), 1024,
        decode(sign(bitand(t.sys_evts, 1023)), 1, 'OR GRANT ',
                                                  'GRANT ')) ||
decode (bitand(t.sys_evts, 264192), 2048,
        decode(sign(bitand(t.sys_evts, 2047)), 1, 'OR REVOKE ',
                                                  'REVOKE ')) ||
decode (bitand(t.sys_evts, 266240), 4096,
        decode(sign(bitand(t.sys_evts, 4095)), 1, 'OR TRUNCATE ',
                                                  'TRUNCATE ')) ||
decode (bitand(t.sys_evts, 270336), 8192,
        decode(sign(bitand(t.sys_evts, 8191)), 1, 'OR RENAME ',
                                                  'RENAME ')) ||
decode (bitand(t.sys_evts, 278528), 16384,
        decode(sign(bitand(t.sys_evts, 16383)), 1, 'OR ASSOCIATE STATISTICS ',
                                                   'ASSOCIATE STATISTICS ')) ||
decode (bitand(t.sys_evts, 294912), 32768,
        decode(sign(bitand(t.sys_evts, 32767)), 1, 'OR AUDIT ',
                                                   'AUDIT ')) ||
decode (bitand(t.sys_evts, 327680), 65536,
        decode(sign(bitand(t.sys_evts, 65535)), 1,
               'OR DISASSOCIATE STATISTICS ', 'DISASSOCIATE STATISTICS ')) ||
decode (bitand(t.sys_evts, 393216), 131072,
        decode(sign(bitand(t.sys_evts, 131071)), 1, 'OR NOAUDIT ',
                                                    'NOAUDIT ')) ||
decode (bitand(t.sys_evts, 262144), 262144,
        decode(sign(bitand(t.sys_evts, 31)), 1, 'OR DDL ',
                                                   'DDL ')) ||
decode (bitand(t.sys_evts, 8388608), 8388608,
        decode(sign(bitand(t.sys_evts, 8388607)), 1, 'OR SUSPEND ',
                                                     'SUSPEND ')),
'SYS',
'DATABASE        ',
NULL,
NULL,
'REFERENCING NEW AS '||t.refnewname||' OLD AS '||t.refoldname,
t.whenclause,decode(t.enabled, 0, 'DISABLED', 1, 'ENABLED', 'ERROR'),
t.definition,
decode(bitand(t.property, 2), 2, 'CALL',
                                 'PL/SQL     '),
t.action#
from sys.obj$ trigobj, sys.trigger$ t, sys.user$ triguser
where (trigobj.obj#    = t.obj# and
       trigobj.owner#  = triguser.user# and
       bitand(t.property, 63)     >= 8  and  bitand(t.property, 63) < 16 and
       (
        trigobj.owner# = userenv('SCHEMAID') or
        exists (select null from v$enabledprivs
                where priv_number = -152 /* CREATE ANY TRIGGER */)))
union all
select triguser.name, trigobj.name,
decode(t.type#, 0, 'BEFORE EVENT',
                2, 'AFTER EVENT',
                   'UNDEFINED'),
decode(bitand(t.sys_evts, 1), 1, 'STARTUP ') ||
decode(bitand(t.sys_evts, 2), 2,
       decode(sign(bitand(t.sys_evts, 1)), 1, 'OR SHUTDOWN ',
                                               'SHUTDOWN ')) ||
decode(bitand(t.sys_evts, 4), 4,
       decode(sign(bitand(t.sys_evts, 3)), 1, 'OR ERROR ',
                                              'ERROR ')) ||
decode(bitand(t.sys_evts, 8), 8,
       decode(sign(bitand(t.sys_evts, 7)), 1, 'OR LOGON ',
                                              'LOGON ')) ||
decode(bitand(t.sys_evts, 16), 16,
       decode(sign(bitand(t.sys_evts, 15)), 1, 'OR LOGOFF ',
                                               'LOGOFF ')) ||
decode(bitand(t.sys_evts, 262176), 32,
       decode(sign(bitand(t.sys_evts, 31)), 1, 'OR CREATE ',
                                               'CREATE ')) ||
decode(bitand(t.sys_evts, 262208), 64,
       decode(sign(bitand(t.sys_evts, 63)), 1, 'OR ALTER ',
                                               'ALTER ')) ||
decode(bitand(t.sys_evts, 262272), 128,
       decode(sign(bitand(t.sys_evts, 127)), 1, 'OR DROP ',
                                                'DROP ')) ||
decode (bitand(t.sys_evts, 262400), 256,
        decode(sign(bitand(t.sys_evts, 255)), 1, 'OR ANALYZE ',
                                                 'ANALYZE ')) ||
decode (bitand(t.sys_evts, 262656), 512,
        decode(sign(bitand(t.sys_evts, 511)), 1, 'OR COMMENT ',
                                                 'COMMENT ')) ||
decode (bitand(t.sys_evts, 263168), 1024,
        decode(sign(bitand(t.sys_evts, 1023)), 1, 'OR GRANT ',
                                                  'GRANT ')) ||
decode (bitand(t.sys_evts, 264192), 2048,
        decode(sign(bitand(t.sys_evts, 2047)), 1, 'OR REVOKE ',
                                                  'REVOKE ')) ||
decode (bitand(t.sys_evts, 266240), 4096,
        decode(sign(bitand(t.sys_evts, 4095)), 1, 'OR TRUNCATE ',
                                                  'TRUNCATE ')) ||
decode (bitand(t.sys_evts, 270336), 8192,
        decode(sign(bitand(t.sys_evts, 8191)), 1, 'OR RENAME ',
                                                  'RENAME ')) ||
decode (bitand(t.sys_evts, 278528), 16384,
        decode(sign(bitand(t.sys_evts, 16383)), 1, 'OR ASSOCIATE STATISTICS ',
                                                   'ASSOCIATE STATISTICS ')) ||
decode (bitand(t.sys_evts, 294912), 32768,
        decode(sign(bitand(t.sys_evts, 32767)), 1, 'OR AUDIT ',
                                                   'AUDIT ')) ||
decode (bitand(t.sys_evts, 327680), 65536,
        decode(sign(bitand(t.sys_evts, 65535)), 1,
               'OR DISASSOCIATE STATISTICS ', 'DISASSOCIATE STATISTICS ')) ||
decode (bitand(t.sys_evts, 393216), 131072,
        decode(sign(bitand(t.sys_evts, 131071)), 1, 'OR NOAUDIT ',
                                                    'NOAUDIT ')) ||
decode (bitand(t.sys_evts, 262144), 262144,
        decode(sign(bitand(t.sys_evts, 31)), 1, 'OR DDL ',
                                                   'DDL ')) ||
decode (bitand(t.sys_evts, 8388608), 8388608,
        decode(sign(bitand(t.sys_evts, 8388607)), 1, 'OR SUSPEND ',
                                                     'SUSPEND ')),
tabuser.name,
'SCHEMA',
NULL,
NULL,
'REFERENCING NEW AS '||t.refnewname||' OLD AS '||t.refoldname,
t.whenclause,decode(t.enabled, 0, 'DISABLED', 1, 'ENABLED', 'ERROR'),
t.definition,
decode(bitand(t.property, 2), 2, 'CALL',
                                 'PL/SQL     '),
t.action#
from sys.obj$ trigobj, sys.trigger$ t, sys.user$ tabuser, sys.user$ triguser
where (trigobj.obj#    = t.obj# and
       trigobj.owner#  = triguser.user# and
       tabuser.user#   = t.baseobject and
       bitand(t.property, 63)     >= 16 and bitand(t.property, 63) < 32 and
       (
         trigobj.owner# = userenv('SCHEMAID') or
        tabuser.user#  = userenv('SCHEMAID') or
        t.baseobject in
          (select oa2.obj# from sys.objauth$ oa2 where grantee# in
             (select kzsrorol from x$kzsro)) or
        exists (select null from v$enabledprivs
                where priv_number = -152 /* CREATE ANY TRIGGER */)))
union all
select triguser.name, trigobj.name,
decode(t.type#, 0, 'BEFORE STATEMENT',
               1, 'BEFORE EACH ROW',
               2, 'AFTER STATEMENT',
               3, 'AFTER EACH ROW',
               4, 'INSTEAD OF',
               'UNDEFINED'),
decode(t.insert$*100 + t.update$*10 + t.delete$,
                 100, 'INSERT',
                 010, 'UPDATE',
                 001, 'DELETE',
                 110, 'INSERT OR UPDATE',
                 101, 'INSERT OR DELETE',
                 011, 'UPDATE OR DELETE',
                 111, 'INSERT OR UPDATE OR DELETE', 'ERROR'),
tabuser.name,
decode(bitand(t.property, 1), 1, 'VIEW',
                              0, 'TABLE',
                                 'UNDEFINED'),
tabobj.name, ntcol.name,
'REFERENCING NEW AS '||t.refnewname||' OLD AS '||t.refoldname ||
  ' PARENT AS ' || t.refprtname,
t.whenclause,decode(t.enabled, 0, 'DISABLED', 1, 'ENABLED', 'ERROR'),
t.definition,
decode(bitand(t.property, 2), 2, 'CALL',
                                 'PL/SQL     '),
t.action#
from sys.obj$ trigobj, sys.obj$ tabobj, sys.trigger$ t, sys.user$ tabuser,
     sys.user$ triguser, sys.viewtrcol$ ntcol
where (trigobj.obj#   = t.obj# and
       tabobj.obj#    = t.baseobject and
       trigobj.owner# = triguser.user# and
       tabobj.owner#  = tabuser.user# and
       bitand(t.property, 63)    >=  32  and
       t.nttrigcol = ntcol.intcol# and
       t.nttrigatt = ntcol.attribute# and
       t.baseobject = ntcol.obj# and
       (
        trigobj.owner# = userenv('SCHEMAID') or
        tabobj.owner# = userenv('SCHEMAID') or
        tabobj.obj# in
          (select oa3.obj# from sys.objauth$ oa3 where grantee# in
             (select kzsrorol from x$kzsro)) or
        exists (select null from v$enabledprivs
                where priv_number = -152 /* CREATE ANY TRIGGER */)));

CREATE OR REPLACE FORCE VIEW "ALL_TRIGGER_COLS"("TRIGGER_OWNER",
select /*+ ORDERED NOCOST */ u.name, o.name, u2.name, o2.name, c.name,
   max(decode(tc.type#,0,'YES','NO')) COLUMN_LIST,
   decode(sum(decode(tc.type#, 5,  1, -- one occurrence of new in
                              6,  2, -- one occurrence of old in
                              9,  4, -- one occurrence of new out
                             10,  8, -- one occurrence of old out (impossible)
                             13,  5, -- one occurrence of new in out
                             14, 10, -- one occurrence of old in out (imp.)
                             20, 16, -- one occurrence of parent in
                             24, 32, -- one occurrence of parent out (imp)
                             28, 64, -- one occurrence of parent in out (imp)
                              null)
                ), -- result in the following combinations across occurrences
           1, 'NEW IN',
           2, 'OLD IN',
           3, 'NEW IN OLD IN',
           4, 'NEW OUT',
           5, 'NEW IN OUT',
           6, 'NEW OUT OLD IN',
           7, 'NEW IN OUT OLD IN',
          16, 'PARENT IN',
          'NONE')
from sys.trigger$ t, sys.obj$ o, sys.user$ u, sys.user$ u2,
     sys.col$ c, sys.obj$ o2, sys.triggercol$ tc
where t.obj# = tc.obj#                -- find corresponding trigger definition
  and o.obj# = t.obj#                --    and corresponding trigger name
  and c.obj# = t.baseobject         -- and corresponding row in COL$ of
  and c.intcol# = tc.intcol#        --    the referenced column
  and bitand(c.property,32768) != 32768   -- not unused columns
  and o2.obj# = t.baseobject        -- and name of the table containing the trigger
  and u2.user# = o2.owner#        -- and name of the user who owns the table
  and u.user# = o.owner#        -- and name of user who owns the trigger
  and bitand(c.property,1) <> 1  -- and the col is not an ADT column
  and (bitand(t.property,32) <> 32 -- and it is not a nested table col
       or
      bitand(tc.type#,16) = 16) -- or it is a PARENT type column
  and
  ( o.owner# = userenv('SCHEMAID') or o2.owner# = userenv('SCHEMAID')
    or
    exists    -- an enabled role (or current user) with CREATE ANY TRIGGER priv
     ( select null from sys.sysauth$ sa    -- does
       where privilege# = -152             -- CREATE ANY TRIGGER privilege exist
       and (grantee# in                    -- for current user or public
            (select kzsrorol from x$kzsro) -- currently enabled role
           )
      )
   )
group by u.name, o.name, u2.name, o2.name,c.name
union all
select /*+ ORDERED NOCOST */ u.name, o.name, u2.name, o2.name,ac.name,
   max(decode(tc.type#,0,'YES','NO')) COLUMN_LIST,
   decode(sum(decode(tc.type#, 5,  1, -- one occurrence of new in
                              6,  2, -- one occurrence of old in
                              9,  4, -- one occurrence of new out
                             10,  8, -- one occurrence of old out (impossible)
                             13,  5, -- one occurrence of new in out
                             14, 10, -- one occurrence of old in out (imp.)
                             20, 16, -- one occurrence of parent in
                             24, 32, -- one occurrence of parent out (imp)
                             28, 64, -- one occurrence of parent in out (imp)
                              null)
                ), -- result in the following combinations across occurrences
           1, 'NEW IN',
           2, 'OLD IN',
           3, 'NEW IN OLD IN',
           4, 'NEW OUT',
           5, 'NEW IN OUT',
           6, 'NEW OUT OLD IN',
           7, 'NEW IN OUT OLD IN',
          16, 'PARENT IN',
          'NONE')
from sys.trigger$ t, sys.obj$ o, sys.user$ u, sys.user$ u2,
     sys.col$ c, sys.obj$ o2, sys.triggercol$ tc, sys.attrcol$ ac
where t.obj# = tc.obj#                -- find corresponding trigger definition
  and o.obj# = t.obj#                --    and corresponding trigger name
  and c.obj# = t.baseobject         -- and corresponding row in COL$ of
  and c.intcol# = tc.intcol#        --    the referenced column
  and bitand(c.property,32768) != 32768   -- not unused columns
  and o2.obj# = t.baseobject        -- and name of the table containing the trigger
  and u2.user# = o2.owner#        -- and name of the user who owns the table
  and u.user# = o.owner#        -- and name of user who owns the trigger
  and bitand(c.property,1) = 1  -- and it is an ADT attribute
  and ac.intcol# = c.intcol#    -- and the attribute name
  and (bitand(t.property,32) <> 32 -- and it is not a nested table col
       or
      bitand(tc.type#,16) = 16) -- or it is a PARENT type column
  and
  ( o.owner# = userenv('SCHEMAID') or o2.owner# = userenv('SCHEMAID')
    or
    exists    -- an enabled role (or current user) with CREATE ANY TRIGGER priv
     ( select null from sys.sysauth$ sa    -- does
       where privilege# = -152             -- CREATE ANY TRIGGER privilege exist
       and (grantee# in                    -- for current user or public
            (select kzsrorol from x$kzsro) -- currently enabled role
           )
      )
   )
group by u.name, o.name, u2.name, o2.name,ac.name
union all
select /*+ ORDERED NOCOST */ u.name, o.name, u2.name, o2.name,attr.name,
   max(decode(tc.type#,0,'YES','NO')) COLUMN_LIST,
   decode(sum(decode(tc.type#, 5,  1, -- one occurrence of new in
                              6,  2, -- one occurrence of old in
                              9,  4, -- one occurrence of new out
                             10,  8, -- one occurrence of old out (impossible)
                             13,  5, -- one occurrence of new in out
                             14, 10, -- one occurrence of old in out (imp.)
                              null)
                ), -- result in the following combinations across occurrences
           1, 'NEW IN',
           2, 'OLD IN',
           3, 'NEW IN OLD IN',
           4, 'NEW OUT',
           5, 'NEW IN OUT',
           6, 'NEW OUT OLD IN',
           7, 'NEW IN OUT OLD IN',
          'NONE')
from sys.trigger$ t, sys.obj$ o, sys.user$ u, sys.user$ u2,
     sys.obj$ o2, sys.triggercol$ tc,
     sys.collection$ coll, sys.coltype$ ctyp, sys.attribute$ attr
where t.obj# = tc.obj#                -- find corresponding trigger definition
  and o.obj# = t.obj#                --    and corresponding trigger name
  and o2.obj# = t.baseobject        -- and name of the table containing the trigger
  and u2.user# = o2.owner#        -- and name of the user who owns the table
  and u.user# = o.owner#        -- and name of user who owns the trigger
  and bitand(t.property,32) = 32 -- and it is a nested table col
  and bitand(tc.type#,16) <> 16  -- and it is not a PARENT type column
  and ctyp.obj# = t.baseobject   -- find corresponding column type definition
  and ctyp.intcol# = t.nttrigcol -- and get the column type for the nested table
  and ctyp.toid = coll.toid      -- get the collection toid
  and ctyp.version# = coll.version# -- get the collection version
  and attr.attribute# = tc.intcol#  -- get the attribute number
  and attr.toid  = coll.elem_toid  -- get the attribute toid
  and attr.version# = coll.version#  -- get the attribute version
  and
  ( o.owner# = userenv('SCHEMAID') or o2.owner# = userenv('SCHEMAID')
    or
    exists    -- an enabled role (or current user) with CREATE ANY TRIGGER priv
     ( select null from sys.sysauth$ sa    -- does
       where privilege# = -152             -- CREATE ANY TRIGGER privilege exist
       and (grantee# in                    -- for current user or public
            (select kzsrorol from x$kzsro) -- currently enabled role
           )
      )
   )
group by u.name, o.name, u2.name, o2.name,attr.name
union all
select /*+ ORDERED NOCOST */ u.name, o.name, u2.name, o2.name,'COLUMN_VALUE',
   max(decode(tc.type#,0,'YES','NO')) COLUMN_LIST,
   decode(sum(decode(tc.type#, 5,  1, -- one occurrence of new in
                              6,  2, -- one occurrence of old in
                              9,  4, -- one occurrence of new out
                             10,  8, -- one occurrence of old out (impossible)
                             13,  5, -- one occurrence of new in out
                             14, 10, -- one occurrence of old in out (imp.)
                              null)
                ), -- result in the following combinations across occurrences
           1, 'NEW IN',
           2, 'OLD IN',
           3, 'NEW IN OLD IN',
           4, 'NEW OUT',
           5, 'NEW IN OUT',
           6, 'NEW OUT OLD IN',
           7, 'NEW IN OUT OLD IN',
          'NONE')
from sys.trigger$ t, sys.obj$ o, sys.user$ u, sys.user$ u2,
     sys.obj$ o2, sys.triggercol$ tc
where t.obj# = tc.obj#                -- find corresponding trigger definition
  and o.obj# = t.obj#                --    and corresponding trigger name
  and o2.obj# = t.baseobject        -- and name of the table containing the trigger
  and u2.user# = o2.owner#        -- and name of the user who owns the table
  and u.user# = o.owner#        -- and name of user who owns the trigger
  and bitand(t.property,32) = 32 -- and it is not a nested table col
  and bitand(tc.type#,16) <> 16  -- and it is not a PARENT type column
  and tc.intcol# = 0
  and
  ( o.owner# = userenv('SCHEMAID') or o2.owner# = userenv('SCHEMAID')
    or
    exists    -- an enabled role (or current user) with CREATE ANY TRIGGER priv
     ( select null from sys.sysauth$ sa    -- does
       where privilege# = -152             -- CREATE ANY TRIGGER privilege exist
       and (grantee# in                    -- for current user or public
            (select kzsrorol from x$kzsro) -- currently enabled role
           )
      )
   )
group by u.name, o.name, u2.name, o2.name,'COLUMN_VALUE';

CREATE OR REPLACE FORCE VIEW "ALL_TYPES"("OWNER",
select decode(bitand(t.properties, 64), 64, null, u.name), o.name, t.toid,
       decode(t.typecode, 108, 'OBJECT',
                          122, 'COLLECTION',
                          o.name),
       t.attributes, t.methods,
       decode(bitand(t.properties, 16), 16, 'YES', 0, 'NO'),
       decode(bitand(t.properties, 256), 256, 'YES', 0, 'NO'),
       decode(bitand(t.properties, 8), 8, 'NO', 'YES'),
       decode(bitand(t.properties, 65536), 65536, 'NO', 'YES'),
       su.name, so.name, t.local_attrs, t.local_methods, t.typeid
from sys.user$ u, sys.type$ t, sys.obj$ o, sys.obj$ so, sys.user$ su
where o.owner# = u.user#
  and o.oid$ = t.tvoid
  and o.subname IS NULL -- only the most recent version
  and o.type# <> 10 -- must not be invalid
  and bitand(t.properties, 2048) = 0 -- not system-generated
  and t.supertoid = so.oid$ (+) and so.owner# = su.user# (+)
  and (o.owner# = userenv('SCHEMAID')
       or
       o.obj# in (select oa.obj#
                  from sys.objauth$ oa
                  where grantee# in (select kzsrorol
                                     from x$kzsro))
       or /* user has system privileges */
       exists (select null from v$enabledprivs
               where priv_number in (-184 /* EXECUTE ANY TYPE */,
                                     -181 /* CREATE ANY TYPE */)));

CREATE OR REPLACE FORCE VIEW "ALL_TYPE_ATTRS"("OWNER",
select u.name , o.name, a.name,
       decode(bitand(a.properties, 32768), 32768, 'REF',
              decode(bitand(a.properties, 16384), 16384, 'POINTER')),
       nvl2(a.synobj#, (select u.name from user$ u, obj$ o
            where o.owner#=u.user# and o.obj#=a.synobj#),
            decode(bitand(at.properties, 64), 64, null, au.name)),
       nvl2(a.synobj#, (select o.name from obj$ o where o.obj#=a.synobj#),
            decode(at.typecode,
                   52, decode(a.charsetform, 2, 'NVARCHAR2', ao.name),
                   53, decode(a.charsetform, 2, 'NCHAR', ao.name),
                   54, decode(a.charsetform, 2, 'NCHAR VARYING', ao.name),
                   61, decode(a.charsetform, 2, 'NCLOB', ao.name),
                   ao.name)),
       a.length, a.precision#, a.scale,
       decode(a.charsetform, 1, 'CHAR_CS',
                             2, 'NCHAR_CS',
                             3, NLS_CHARSET_NAME(a.charsetid),
                             4, 'ARG:'||a.charsetid),
       a.attribute#, decode(bitand(nvl(a.xflags,0), 1), 1, 'YES', 'NO')
from sys.user$ u, sys.obj$ o, sys.type$ t, sys.attribute$ a,
     sys.obj$ ao, sys.user$ au, sys.type$ at
where bitand(t.properties, 64) != 64 -- u.name
  and o.owner# = u.user#
  and o.oid$ = t.toid
  and o.subname IS NULL -- get the latest version only
  and o.type# <> 10 -- must not be invalid
  and bitand(t.properties, 2048) = 0 -- not system-generated
  and t.toid = a.toid
  and t.version# = a.version#
  and a.attr_toid = ao.oid$
  and ao.owner# = au.user#
  and a.attr_toid = at.tvoid
  and a.attr_version# = at.version#
  and (o.owner# = userenv('SCHEMAID')
       or
       o.obj# in (select oa.obj#
                  from sys.objauth$ oa
                  where grantee# in (select kzsrorol
                                     from x$kzsro))
       or /* user has system privileges */
       exists (select null from v$enabledprivs
               where priv_number in (-184 /* EXECUTE ANY TYPE */,
                                     -181 /* CREATE ANY TYPE */)))
UNION ALL
select null, o.name, a.name,
       decode(bitand(a.properties, 32768), 32768, 'REF',
              decode(bitand(a.properties, 16384), 16384, 'POINTER')),
       nvl2(a.synobj#, (select u.name from user$ u, obj$ o
            where o.owner#=u.user# and o.obj#=a.synobj#),
            decode(bitand(at.properties, 64), 64, null, au.name)),
       nvl2(a.synobj#, (select o.name from obj$ o where o.obj#=a.synobj#),
            decode(at.typecode,
                   52, decode(a.charsetform, 2, 'NVARCHAR2', ao.name),
                   53, decode(a.charsetform, 2, 'NCHAR', ao.name),
                   54, decode(a.charsetform, 2, 'NCHAR VARYING', ao.name),
                   61, decode(a.charsetform, 2, 'NCLOB', ao.name),
                   ao.name)),
       a.length, a.precision#, a.scale,
       decode(a.charsetform, 1, 'CHAR_CS',
                             2, 'NCHAR_CS',
                             3, NLS_CHARSET_NAME(a.charsetid),
                             4, 'ARG:'||a.charsetid),
       a.attribute#, decode(bitand(nvl(a.xflags,0), 1), 1, 'YES', 'NO')
from sys.user$ u, sys.obj$ o, sys.type$ t, sys.attribute$ a,
     sys.obj$ ao, sys.user$ au, sys.type$ at
where bitand(t.properties, 64) = 64  -- u.name is null
  and o.oid$ = t.toid
  and o.subname IS NULL -- get the latest version only
  and o.type# <> 10 -- must not be invalid
  and bitand(t.properties, 2048) = 0 -- not system-generated
  and t.toid = a.toid
  and t.version# = a.version#
  and a.attr_toid = ao.oid$
  and ao.owner# = au.user#
  and a.attr_toid = at.tvoid
  and a.attr_version# = at.version#
  and (o.owner# = userenv('SCHEMAID')
       or
       o.obj# in (select oa.obj#
                  from sys.objauth$ oa
                  where grantee# in (select kzsrorol
                                     from x$kzsro))
       or /* user has system privileges */
       exists (select null from v$enabledprivs
               where priv_number in (-184 /* EXECUTE ANY TYPE */,
                                     -181 /* CREATE ANY TYPE */)));

CREATE OR REPLACE FORCE VIEW "ALL_TYPE_METHODS"("OWNER",
select u.name, o.name, m.name, m.method#,
       decode(bitand(m.properties, 512), 512, 'MAP',
              decode(bitand(m.properties, 2048), 2048, 'ORDER', 'PUBLIC')),
       m.parameters#, m.results,
       decode(bitand(m.properties, 8), 8, 'NO', 'YES'),
       decode(bitand(m.properties, 65536), 65536, 'NO', 'YES'),
       decode(bitand(m.properties, 131072), 131072, 'YES', 'NO'),
       decode(bitand(nvl(m.xflags,0), 1), 1, 'YES', 'NO')
from sys.user$ u, sys.obj$ o, sys.method$ m
where o.owner# = u.user#
  and o.type# <> 10 -- must not be invalid
  and o.oid$ = m.toid
  and o.subname IS NULL -- get the latest version only
  and (o.owner# = userenv('SCHEMAID')
       or
       o.obj# in (select oa.obj#
                  from sys.objauth$ oa
                  where grantee# in (select kzsrorol
                                     from x$kzsro))
       or /* user has system privileges */
       exists (select null from v$enabledprivs
               where priv_number in (-184 /* EXECUTE ANY TYPE */,
                                     -181 /* CREATE ANY TYPE */)));

CREATE OR REPLACE FORCE VIEW "ALL_TYPE_VERSIONS"("OWNER",
select u.name, o.name, t.version#,
       decode(t.typecode, 108, 'OBJECT',
                          122, 'COLLECTION',
                          o.name),
       decode(o.status, 0, 'N/A', 1, 'VALID', 'INVALID'),
       s.line, s.source,
       t.hashcode
from sys.obj$ o, sys.source$ s, sys.type$ t, user$ u
  where o.obj# = s.obj# and o.oid$ = t.tvoid and o.type# = 13
  and o.owner# = u.user#
  and (o.owner# = userenv('SCHEMAID')
       or
       o.obj# in (select oa.obj#
                  from sys.objauth$ oa
                  where grantee# in (select kzsrorol
                                     from x$kzsro))
       or /* user has system privileges */
       exists (select null from v$enabledprivs
               where priv_number in (-184 /* EXECUTE ANY TYPE */,
                                     -181 /* CREATE ANY TYPE */)));

CREATE OR REPLACE FORCE VIEW "ALL_UNUSED_COL_TABS"("OWNER",
select u.name, o.name, count(*)
from sys.user$ u, sys.obj$ o, sys.col$ c
where o.owner# = u.user#
  and o.obj# = c.obj#
  and bitand(c.property,32768) = 32768              -- is unused column
  and bitand(c.property, 1) != 1                    -- not ADT attribute col
  and bitand(c.property, 1024) != 1024              -- not NTAB's setid col
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                 )
      )
  group by u.name, o.name;

CREATE OR REPLACE FORCE VIEW "ALL_UPDATABLE_COLUMNS"("OWNER",
select u.name, o.name, c.name,
       decode(bitand(c.fixedstorage,2),
              2, decode(bitand(v.flags,8192), 8192, 'YES', 'NO'),
              decode(bitand(c.property,4096),4096,'NO','YES')),
       decode(bitand(c.fixedstorage,2),
              2, decode(bitand(v.flags,4096), 4096, 'YES', 'NO'),
              decode(bitand(c.property,2048),2048,'NO','YES')),
       decode(bitand(c.fixedstorage,2),
              2, decode(bitand(v.flags,16384), 16384, 'YES', 'NO'),
              decode(bitand(c.property,8192),8192,'NO','YES'))
from sys.obj$ o, sys.user$ u, sys.col$ c, sys.view$ v
where o.owner# = u.user#
  and o.obj#  = c.obj#
  and c.obj#  = v.obj#(+)
  and bitand(c.property, 32) = 0 /* not hidden column */
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_USERS"("USERNAME",
select u.name, u.user#, u.ctime
from sys.user$ u, sys.ts$ dts, sys.ts$ tts
where u.datats# = dts.ts#
  and u.tempts# = tts.ts#
  and u.type# = 1;

CREATE OR REPLACE FORCE VIEW "ALL_USTATS"("OBJECT_OWNER",
select u.name, o.name, o.subname,
         decode (bitand(s.property, 3), 1, 'INDEX', 2, 'COLUMN'),
         decode (bitand(s.property, 12), 8, 'DIRECT', 4, 'IMPLICIT'),
         c.name, u1.name, o1.name, s.statistics
  from   sys.user$ u, sys.obj$ o, sys.col$ c, sys.ustats$ s,
         sys.user$ u1, sys.obj$ o1
  where  bitand(s.property, 3)=2 and s.obj#=o.obj# and o.owner#=u.user#
  and    s.intcol#=c.intcol# and s.statstype#=o1.obj#
  and    o1.owner#=u1.user# and c.obj#=s.obj#
  and    ( o.owner#=userenv('SCHEMAID')
           or
        o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or
       ( o.type# in (2)  /* table */
         and
         exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */,
                                        -42 /* ALTER ANY TABLE */)
                 )
       )
    )
union all    -- partition case
  select u.name, o.name, o.subname,
         decode (bitand(s.property, 3), 1, 'INDEX', 2, 'COLUMN'),
         decode (bitand(s.property, 12), 8, 'DIRECT', 4, 'IMPLICIT'),
         c.name, u1.name, o1.name, s.statistics
  from   sys.user$ u, sys.user$ u1, sys.obj$ o, sys.obj$ o1, sys.col$ c,
         sys.ustats$ s, sys.tabpart$ t, sys.obj$ o2
  where  bitand(s.property, 3)=2 and s.obj# = o.obj#
  and    s.obj# = t.obj# and t.bo# = o2.obj# and o2.owner# = u.user#
  and    s.intcol# = c.intcol# and s.statstype#=o1.obj# and o1.owner#=u1.user#
  and    t.bo#=c.obj#
  and    ( o.owner#=userenv('SCHEMAID')
           or
        o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or
       ( o.type# in (2)  /* table */
         and
         exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */,
                                        -42 /* ALTER ANY TABLE */)
                 )
       )
    )
union all
  select u.name, o.name, o.subname,
         decode (bitand(s.property, 3), 1, 'INDEX', 2, 'COLUMN'),
         decode (bitand(s.property, 12), 8, 'DIRECT', 4, 'IMPLICIT'),
          NULL, u1.name, o1.name, s.statistics
  from   sys.user$ u, sys.obj$ o, sys.ustats$ s,
         sys.user$ u1, sys.obj$ o1
  where  bitand(s.property, 3)=1 and s.obj#=o.obj# and o.owner#=u.user#
  and    s.statstype#=o1.obj# and o1.owner#=u1.user# and o.type#=1
  and    ( o.owner#=userenv('SCHEMAID')
           or
        o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or
       ( o.type# in (1)  /* index */
         and
         exists (select null from v$enabledprivs
                  where priv_number in (-71 /* CREATE ANY INDEX */,
                                        -72 /* ALTER ANY INDEX */,
                                        -73 /* DROP ANY INDEX */)
                 )
       )
    )
union all -- index partition
  select u.name, o.name, o.subname,
         decode (bitand(s.property, 3), 1, 'INDEX', 2, 'COLUMN'),
         decode (bitand(s.property, 12), 8, 'DIRECT', 4, 'IMPLICIT'),
         NULL, u1.name, o1.name, s.statistics
  from   sys.user$ u, sys.user$ u1, sys.obj$ o, sys.obj$ o1,
         sys.ustats$ s, sys.indpart$ i, sys.obj$ o2
  where  bitand(s.property, 3)=1 and s.obj# = o.obj#
  and    s.obj# = i.obj# and i.bo# = o2.obj# and o2.owner# = u.user#
  and    s.statstype#=o1.obj# and o1.owner#=u1.user#
  and    ( o.owner#=userenv('SCHEMAID')
           or
        o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or
       ( o.type# in (1)  /* index */
         and
         exists (select null from v$enabledprivs
                  where priv_number in (-71 /* CREATE ANY INDEX */,
                                        -72 /* ALTER ANY INDEX */,
                                        -73 /* DROP ANY INDEX */)
                 )
       )
    );

CREATE OR REPLACE FORCE VIEW "ALL_VARRAYS"("OWNER",
select u.name, op.name, ac.name,
       nvl2(ct.synobj#, (select u.name from user$ u, obj$ o
            where o.owner#=u.user# and o.obj#=ct.synobj#), ut.name),
       nvl2(ct.synobj#, (select o.name from obj$ o
            where o.obj#=ct.synobj#), ot.name),
       NULL,
       lpad(decode(bitand(ct.flags, 64), 64, 'USER_SPECIFIED', 'DEFAULT'), 30),
       lpad(decode(bitand(ct.flags, 32), 32, 'LOCATOR', 'VALUE'), 20),
       lpad((case when bitand(ct.flags, 5120)=0 and bitand(t.properties, 8)= 8
       then 'Y' else 'N' end), 25)
from sys.obj$ op, sys.obj$ ot, sys.col$ c, sys.coltype$ ct, sys.user$ u,
  sys.user$ ut, sys.attrcol$ ac, sys.type$ t, sys.collection$ cl
where op.owner# = u.user#
  and c.obj# = op.obj#
  and c.obj# = ac.obj#
  and c.intcol# = ac.intcol#
  and op.obj# = ct.obj#
  and ct.toid = ot.oid$
  and ct.intcol#=c.intcol#
  and ot.owner# = ut.user#
  and ct.toid=cl.toid
  and cl.elem_toid=t.tvoid
  and bitand(ct.flags,8)=8
  and bitand(c.property, 128) != 128
  and bitand(c.property,32768) != 32768           /* not unused column */
  and (op.owner# = userenv('SCHEMAID')
       or op.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
union all
select u.name, op.name, ac.name,
       nvl2(ct.synobj#, (select u.name from user$ u, obj$ o
            where o.owner#=u.user# and o.obj#=ct.synobj#), ut.name),
       nvl2(ct.synobj#, (select o.name from obj$ o
            where o.obj#=ct.synobj#), ot.name),
       o.name,
       lpad(decode(bitand(ct.flags, 64), 64, 'USER_SPECIFIED', 'DEFAULT'), 30),
       lpad(decode(bitand(ct.flags, 32), 32, 'LOCATOR', 'VALUE'), 20),
       lpad((case when bitand(ct.flags, 5120)=0 and bitand(t.properties, 8)= 8
       then 'Y' else 'N' end), 25)
from sys.lob$ l, sys.obj$ o, sys.obj$ op, sys.obj$ ot, sys.col$ c,
  sys.coltype$ ct, sys.user$ u, sys.user$ ut, sys.attrcol$ ac, sys.type$ t,
  sys.collection$ cl
where o.owner# = u.user#
  and l.obj# = op.obj#
  and l.lobj# = o.obj#
  and c.obj# = op.obj#
  and l.intcol# = c.intcol#
  and c.obj# = ac.obj#
  and c.intcol# = ac.intcol#
  and op.obj# = ct.obj#
  and ct.toid = ot.oid$
  and ct.intcol#=l.intcol#
  and ot.owner# = ut.user#
  and ct.toid=cl.toid
  and cl.elem_toid=t.tvoid
  and bitand(ct.flags,8)=8
  and bitand(c.property, 128) = 128
  and bitand(c.property,32768) != 32768           /* not unused column */
  and (op.owner# = userenv('SCHEMAID')
       or op.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
union all
select u.name, op.name, c.name,
       nvl2(ct.synobj#, (select u.name from user$ u, obj$ o
            where o.owner#=u.user# and o.obj#=ct.synobj#), ut.name),
       nvl2(ct.synobj#, (select o.name from obj$ o
            where o.obj#=ct.synobj#), ot.name),
       NULL,
       lpad(decode(bitand(ct.flags, 64), 64, 'USER_SPECIFIED', 'DEFAULT'), 30),
       lpad(decode(bitand(ct.flags, 32), 32, 'LOCATOR', 'VALUE'), 20),
       lpad((case when bitand(ct.flags, 5120)=0 and bitand(t.properties, 8)= 8
       then 'Y' else 'N' end), 25)
from sys.obj$ op, sys.obj$ ot, sys.col$ c, sys.coltype$ ct, sys.user$ u,
  sys.user$ ut, sys.type$ t, sys.collection$ cl
where op.owner# = u.user#
  and c.obj# = op.obj#
  and bitand(c.property,1)=0
  and op.obj# = ct.obj#
  and ct.toid = ot.oid$
  and ct.intcol#=c.intcol#
  and ot.owner# = ut.user#
  and ct.toid=cl.toid
  and cl.elem_toid=t.tvoid
  and bitand(ct.flags,8)=8
  and bitand(c.property, 128) != 128
  and bitand(c.property,32768) != 32768           /* not unused column */
  and (op.owner# = userenv('SCHEMAID')
       or op.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
union all
select u.name, op.name, c.name,
       nvl2(ct.synobj#, (select u.name from user$ u, obj$ o
            where o.owner#=u.user# and o.obj#=ct.synobj#), ut.name),
       nvl2(ct.synobj#, (select o.name from obj$ o
            where o.obj#=ct.synobj#), ot.name),
       o.name,
       lpad(decode(bitand(ct.flags, 64), 64, 'USER_SPECIFIED', 'DEFAULT'), 30),
       lpad(decode(bitand(ct.flags, 32), 32, 'LOCATOR', 'VALUE'), 20),
       lpad((case when bitand(ct.flags, 5120)=0 and bitand(t.properties, 8)= 8
       then 'Y' else 'N' end), 25)
from sys.lob$ l, sys.obj$ o, sys.obj$ op, sys.obj$ ot, sys.col$ c,
  sys.coltype$ ct, sys.user$ u, sys.user$ ut, sys.type$ t, sys.collection$ cl
where o.owner# = u.user#
  and l.obj# = op.obj#
  and l.lobj# = o.obj#
  and c.obj# = op.obj#
  and l.intcol# = c.intcol#
  and bitand(c.property,1)=0
  and op.obj# = ct.obj#
  and ct.toid = ot.oid$
  and ct.intcol#=l.intcol#
  and ot.owner# = ut.user#
  and ct.toid=cl.toid
  and cl.elem_toid=t.tvoid
  and bitand(ct.flags,8)=8
  and bitand(c.property, 128) = 128
  and bitand(c.property,32768) != 32768           /* not unused column */
  and (op.owner# = userenv('SCHEMAID')
       or op.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_VIEWS"("OWNER",
select u.name, o.name, v.textlength, v.text, t.typetextlength, t.typetext,
       t.oidtextlength, t.oidtext, t.typeowner, t.typename,
       decode(bitand(v.property, 134217728), 134217728,
              (select sv.name from superobj$ h, obj$ sv
              where h.subobj# = o.obj# and h.superobj# = sv.obj#), null)
from sys.obj$ o, sys.view$ v, sys.user$ u, sys.typed_view$ t
where o.obj# = v.obj#
  and o.obj# = t.obj#(+)
  and o.owner# = u.user#
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where oa.grantee# in ( select kzsrorol
                                         from x$kzsro
                                  )
            )
        or /* user has system privileges */
          exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                  )
      );

CREATE OR REPLACE FORCE VIEW "ALL_WARNING_SETTINGS"("OWNER",
SELECT u.name, o.name, o.obj#,
         DECODE(o.type#,
                 7, 'PROCEDURE',
                 8, 'FUNCTION',
                 9, 'PACKAGE',
                11, 'PACKAGE BODY',
                12, 'TRIGGER',
                13, 'TYPE',
                14, 'TYPE BODY',
                    'UNDEFINED'),
         DECODE(w.warning,
                -1, 'INFORMATIONAL',
                -2, 'PERFORMANCE',
                -3, 'SEVERE',
                -4, 'ALL',
                w.warning),
         DECODE(w.setting,
                0, 'DISABLE',
                1, 'ENABLE',
                2, 'ERROR',
                   'INVALID')
    FROM sys.obj$ o, sys.user$ u,
    TABLE(dbms_warning_internal.show_warning_settings(o.obj#)) w
    WHERE o.owner# = u.user#
    AND o.linkname IS NULL
    AND o.type# IN (7, 8, 9, 11, 12, 13, 14)
    AND w.obj_no = o.obj#
    AND
    (
      o.owner# IN (userenv('SCHEMAID'), 1 /* PUBLIC */)
      OR
      (
        (
          (
            (o.type# = 7 OR o.type# = 8 OR o.type# = 9 OR o.type# = 13)
             and
             o.obj# in (select obj# from sys.objauth$
             where grantee# in (select kzsrorol from x$kzsro)
                   and privilege#  = 12 /* EXECUTE */)
           )
           or
           exists
           (
              select null from sys.sysauth$
                where grantee# in (select kzsrorol from x$kzsro)
                      and
                      (
                        (
                          /* procedure */
                          (o.type# = 7 or o.type# = 8 or o.type# = 9)
                          and
                          (
                             privilege# = -144 /* EXECUTE ANY PROCEDURE */
                             or
                             privilege# = -141 /* CREATE ANY PROCEDURE */
                          )
                        )
                        or
                        (
                          /* package body */
                          o.type# = 11 and
                          privilege# = -141 /* CREATE ANY PROCEDURE */
                        )
                        or
                        (
                          /* type */
                          o.type# = 13
                          and
                          (
                             privilege# = -184 /* EXECUTE ANY TYPE */
                             or
                             privilege# = -181 /* CREATE ANY TYPE */
                          )
                        )
                        or
                        (
                          /* type body */
                          o.type# = 14 and
                          privilege# = -181 /* CREATE ANY TYPE */
                        )
                      )
           )
        )
      )
    );

CREATE OR REPLACE FORCE VIEW "ALL_WORKSPACES"("WORKSPACE",
select asp.workspace, asp.parent_workspace, ssp.savepoint parent_savepoint,
       asp.owner, asp.createTime, asp.description,
       decode(asp.freeze_status,'LOCKED','FROZEN',
                              'UNLOCKED','UNFROZEN') freeze_status,
       decode(asp.oper_status, null, asp.freeze_mode,'INTERNAL') freeze_mode,
       decode(asp.freeze_mode, '1WRITER_SESSION', s.username, asp.freeze_writer) freeze_writer,
       decode(asp.session_duration, 0, asp.freeze_owner, s.username) freeze_owner,
       decode(asp.freeze_status, 'UNLOCKED', null, decode(asp.session_duration, 1, 'YES', 'NO')) session_duration,
       decode(asp.session_duration, 1,
                     decode((select 1 from dual
                             where s.sid=sys_context('lt_ctx', 'cid') and s.serial#=sys_context('lt_ctx', 'serial#')),
                           1, 'YES', 'NO'),
             null) current_session,
       decode(rst.workspace,null,'INACTIVE','ACTIVE') resolve_status,
       rst.resolve_user,
       decode(asp.isRefreshed, 1, 'YES', 'NO') continually_refreshed,
       decode(substr(asp.wm_lockmode, 1, 1),
              'S', 'SHARED',
              'E', 'EXCLUSIVE',
              'C', 'CARRY', NULL) workspace_lockmode,
       decode(substr(asp.wm_lockmode, 3, 1), 'Y', 'YES', 'N', 'NO', NULL) workspace_lockmode_override,
       mp_root mp_root_workspace
from   wmsys.all_workspaces_internal asp, wmsys.wm$workspace_savepoints_table ssp,
       wmsys.wm$resolve_workspaces_table  rst, v$session s
where  ((ssp.position is null) or ( ssp.position =
	(select min(position) from wmsys.wm$workspace_savepoints_table where version=ssp.version) )) and
       asp.parent_version  = ssp.version (+) and
       asp.workspace = rst.workspace (+) and
       to_char(s.sid(+)) = substr(asp.freeze_owner, 1, instr(asp.freeze_owner, ',')-1)  and
       to_char(s.serial#(+)) = substr(asp.freeze_owner, instr(asp.freeze_owner, ',')+1)
WITH READ ONLY;

CREATE OR REPLACE FORCE VIEW "ALL_XML_SCHEMAS"("OWNER",
select u.name, s.xmldata.schema_url,
          case when bitand(to_number(s.xmldata.flags,'xxxxxxxx'), 16) = 16
               then 'NO' else 'YES' end,
          value(s),
          xdb.xdb$Extname2Intname(s.xmldata.schema_url,s.xmldata.schema_owner),
          case when bitand(to_number(s.xmldata.flags,'xxxxxxxx'), 16) = 16
               then s.xmldata.schema_url
               else 'http://xmlns.oracle.com/xdb/schemas/' ||
                    s.xmldata.schema_owner || '/' ||
                    case when substr(s.xmldata.schema_url, 1, 7) = 'http://'
                         then substr(s.xmldata.schema_url, 8)
                         else s.xmldata.schema_url
                    end
          end
    from user$ u, xdb.xdb$schema s
    where u.user# = userenv('SCHEMAID')
    and   u.name  = s.xmldata.schema_owner
    union all
    select s.xmldata.schema_owner, s.xmldata.schema_url, 'NO', value(s),
          xdb.xdb$Extname2Intname(s.xmldata.schema_url,s.xmldata.schema_owner),
          s.xmldata.schema_url
    from xdb.xdb$schema s
    where bitand(to_number(s.xmldata.flags,'xxxxxxxx'), 16) = 16
    and s.xmldata.schema_url
       not in (select s2.xmldata.schema_url
               from xdb.xdb$schema s2, user$ u2
               where u2.user# = userenv('SCHEMAID')
               and   u2.name  = s.xmldata.schema_owner);

CREATE OR REPLACE FORCE VIEW "ALL_XML_SCHEMAS2"("OWNER",
select u.name, s.xmldata.schema_url,
          case when bitand(to_number(s.xmldata.flags,'xxxxxxxx'), 16) = 16
               then 'NO' else 'YES' end,
          xdb.xdb$Extname2Intname(s.xmldata.schema_url,s.xmldata.schema_owner),
          case when bitand(to_number(s.xmldata.flags,'xxxxxxxx'), 16) = 16
               then s.xmldata.schema_url
               else 'http://xmlns.oracle.com/xdb/schemas/' ||
                    s.xmldata.schema_owner || '/' ||
                    case when substr(s.xmldata.schema_url, 1, 7) = 'http://'
                         then substr(s.xmldata.schema_url, 8)
                         else s.xmldata.schema_url
                    end
          end
    from user$ u, xdb.xdb$schema s
    where u.user# = userenv('SCHEMAID')
    and   u.name  = s.xmldata.schema_owner
    union all
    select s.xmldata.schema_owner, s.xmldata.schema_url, 'NO',
          xdb.xdb$Extname2Intname(s.xmldata.schema_url,s.xmldata.schema_owner),
          s.xmldata.schema_url
    from xdb.xdb$schema s
    where bitand(to_number(s.xmldata.flags,'xxxxxxxx'), 16) = 16
    and s.xmldata.schema_url
       not in (select s2.xmldata.schema_url
               from xdb.xdb$schema s2, user$ u2
               where u2.user# = userenv('SCHEMAID')
               and   u2.name  = s.xmldata.schema_owner);

CREATE OR REPLACE FORCE VIEW "ALL_XML_TABLES"("OWNER",
select u.name, o.name, null, null, null,
    decode(bitand(opq.flags,5),1,'OBJECT-RELATIONAL','CLOB')
 from sys.opqtype$ opq, sys.tab$ t, sys.user$ u, sys.obj$ o,
      sys.coltype$ ac, sys.col$ tc
 where o.owner# = u.user#
  and o.obj# = t.obj#
  and bitand(t.property, 1) = 1
  and t.obj# = tc.obj#
  and tc.name = 'SYS_NC_ROWINFO$'
  and tc.obj# = ac.obj#
  and tc.intcol# = ac.intcol#
  and ac.toid = '00000000000000000000000000020100'
  and tc.intcol# =  opq.intcol#
  and tc.obj# =  opq.obj#
  and bitand(opq.flags,2) = 0
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
 union all
 select u.name, o.name, schm.xmldata.schema_url, schm.xmldata.schema_owner,
 decode(xel.xmldata.property.name, null,
        xel.xmldata.property.propref_name.name, xel.xmldata.property.name),
  decode(bitand(opq.flags,5),1,'OBJECT-RELATIONAL','CLOB')
from xdb.xdb$element xel, xdb.xdb$schema schm, sys.opqtype$ opq,
      sys.tab$ t, sys.user$ u, sys.obj$ o, sys.coltype$ ac, sys.col$ tc
where o.owner# = u.user#
  and o.obj# = t.obj#
  and bitand(t.property, 1) = 1
  and t.obj# = tc.obj#
  and tc.name = 'SYS_NC_ROWINFO$'
  and tc.obj# = ac.obj#
  and tc.intcol# = ac.intcol#
  and ac.toid = '00000000000000000000000000020100'
  and tc.intcol# =  opq.intcol#
  and tc.obj# =  opq.obj#
  and opq.schemaoid =  schm.sys_nc_oid$
  and bitand(opq.flags,2) = 2
  and ref(schm) =  xel.xmldata.property.parent_schema
  and opq.elemnum =  xel.xmldata.property.prop_number
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_XML_TAB_COLS"("OWNER",
select u.name, o.name,
   decode(bitand(tc.property, 1), 1, attr.name, tc.name),null,null,null,
   decode(bitand(opq.flags,5),1,'OBJECT-RELATIONAL','CLOB')
from  sys.opqtype$ opq,
      sys.tab$ t, sys.user$ u, sys.obj$ o, sys.coltype$ ac, sys.col$ tc,
      sys.attrcol$ attr
where o.owner# = u.user#
  and o.obj# = t.obj#
  and t.obj# = tc.obj#
  and tc.obj# = ac.obj#
  and tc.intcol# = ac.intcol#
  and ac.toid = '00000000000000000000000000020100'
  and tc.intcol# = opq.intcol#
  and tc.obj# =  opq.obj#
  and tc.obj#    = attr.obj#(+)
  and tc.intcol# = attr.intcol#(+)
  and bitand(opq.flags,2) = 0
  and tc.name != 'SYS_NC_ROWINFO$'
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
  union all
 select u.name, o.name,
  decode(bitand(tc.property, 1), 1, attr.name, tc.name),
  schm.xmldata.schema_url, schm.xmldata.schema_owner,
decode(xel.xmldata.property.name, null,
        xel.xmldata.property.propref_name.name, xel.xmldata.property.name),
    decode(bitand(opq.flags,5),1,'OBJECT-RELATIONAL','CLOB')
 from xdb.xdb$element xel, xdb.xdb$schema schm, sys.opqtype$ opq,
      sys.tab$ t, sys.user$ u, sys.obj$ o, sys.coltype$ ac, sys.col$ tc,
      sys.attrcol$ attr
 where o.owner# = u.user#
  and o.obj# = t.obj#
  and t.obj# = tc.obj#
  and tc.obj# = ac.obj#
  and tc.intcol# = ac.intcol#
  and ac.toid = '00000000000000000000000000020100'
  and tc.intcol# = opq.intcol#
  and tc.obj# =  opq.obj#
  and tc.obj#    = attr.obj#(+)
  and tc.intcol# = attr.intcol#(+)
  and tc.name != 'SYS_NC_ROWINFO$'
  and opq.schemaoid =  schm.sys_nc_oid$
  and ref(schm) =  xel.xmldata.property.parent_schema
  and opq.elemnum =  xel.xmldata.property.prop_number
  and bitand(opq.flags,2) = 2
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_XML_VIEWS"("OWNER",
select u.name, o.name, null, null, null
 from sys.opqtype$ opq,
      sys.view$ v, sys.user$ u, sys.obj$ o, sys.coltype$ ac, sys.col$ tc
 where o.owner# = u.user#
  and o.obj# = v.obj#
  and bitand(v.property, 1) = 1
  and v.obj# = tc.obj#
  and tc.name = 'SYS_NC_ROWINFO$'
  and tc.obj# = ac.obj#
  and tc.intcol# = ac.intcol#
  and ac.toid = '00000000000000000000000000020100'
  and tc.intcol# =  opq.intcol#
  and tc.obj# =  opq.obj#
  and bitand(opq.flags,2) = 0
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      )
 union all
 select u.name, o.name, schm.xmldata.schema_url, schm.xmldata.schema_owner,
   decode(xel.xmldata.property.name, null,
        xel.xmldata.property.propref_name.name, xel.xmldata.property.name)
 from xdb.xdb$element xel, xdb.xdb$schema schm, sys.opqtype$ opq,
      sys.view$ v, sys.user$ u, sys.obj$ o, sys.coltype$ ac, sys.col$ tc
 where o.owner# = u.user#
  and o.obj# = v.obj#
  and bitand(v.property, 1) = 1
  and v.obj# = tc.obj#
  and tc.name = 'SYS_NC_ROWINFO$'
  and tc.obj# = ac.obj#
  and tc.intcol# = ac.intcol#
  and ac.toid = '00000000000000000000000000020100'
  and tc.intcol# =  opq.intcol#
  and tc.obj# =  opq.obj#
  and opq.schemaoid =  schm.sys_nc_oid$
  and ref(schm) =  xel.xmldata.property.parent_schema
  and opq.elemnum =  xel.xmldata.property.prop_number
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY TABLE */,
                                       -47 /* SELECT ANY TABLE */,
                                       -48 /* INSERT ANY TABLE */,
                                       -49 /* UPDATE ANY TABLE */,
                                       -50 /* DELETE ANY TABLE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "ALL_XML_VIEW_COLS"("OWNER",
select u.name, o.name,
  decode(bitand(tc.property, 1), 1, attr.name, tc.name),
  null, null, null
from sys.opqtype$ opq,
      sys.view$ v, sys.user$ u, sys.obj$ o, sys.coltype$ ac, sys.col$ tc,
      sys.attrcol$ attr
where o.owner# = u.user#
  and o.obj# = v.obj#
  and bitand(v.property, 1) = 1
  and v.obj# = tc.obj#
  and tc.obj# = ac.obj#
  and tc.intcol# = ac.intcol#
  and ac.toid = '00000000000000000000000000020100'
  and tc.intcol# = opq.intcol#
  and tc.obj# =  opq.obj#
  and tc.obj#    = attr.obj#(+)
  and tc.intcol# = attr.intcol#(+)
  and bitand(opq.flags,2) = 0
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY VIEWLE */,
                                       -47 /* SELECT ANY VIEWLE */,
                                       -48 /* INSERT ANY VIEWLE */,
                                       -49 /* UPDATE ANY VIEWLE */,
                                       -50 /* DELETE ANY VIEWLE */)
                 )
      )
union all
select u.name, o.name,
  decode(bitand(tc.property, 1), 1, attr.name, tc.name),
  schm.xmldata.schema_url, schm.xmldata.schema_owner,
decode(xel.xmldata.property.name, null,
        xel.xmldata.property.propref_name.name, xel.xmldata.property.name)
from xdb.xdb$element xel, xdb.xdb$schema schm, sys.opqtype$ opq,
      sys.view$ v, sys.user$ u, sys.obj$ o, sys.coltype$ ac, sys.col$ tc,
      sys.attrcol$ attr
where o.owner# = u.user#
  and o.obj# = v.obj#
  and bitand(v.property, 1) = 1
  and v.obj# = tc.obj#
  and tc.obj# = ac.obj#
  and tc.intcol# = ac.intcol#
  and ac.toid = '00000000000000000000000000020100'
  and tc.intcol# = opq.intcol#
  and tc.obj# =  opq.obj#
  and tc.obj#    = attr.obj#(+)
  and tc.intcol# = attr.intcol#(+)
  and opq.schemaoid =  schm.sys_nc_oid$
  and ref(schm) =  xel.xmldata.property.parent_schema
  and opq.elemnum =  xel.xmldata.property.prop_number
  and (o.owner# = userenv('SCHEMAID')
       or o.obj# in
            (select oa.obj#
             from sys.objauth$ oa
             where grantee# in ( select kzsrorol
                                 from x$kzsro
                               )
            )
       or /* user has system privileges */
         exists (select null from v$enabledprivs
                 where priv_number in (-45 /* LOCK ANY VIEWLE */,
                                       -47 /* SELECT ANY VIEWLE */,
                                       -48 /* INSERT ANY VIEWLE */,
                                       -49 /* UPDATE ANY VIEWLE */,
                                       -50 /* DELETE ANY VIEWLE */)
                 )
      );

CREATE OR REPLACE FORCE VIEW "AQ$ALERT_QT"("QUEUE",
SELECT  q_name QUEUE, qt.msgid MSG_ID, corrid CORR_ID,  priority MSG_PRIORITY,  decode(h.dequeue_time, NULL,	  
			      (decode(state, 0,   'READY',	     
                              		     1,   'WAIT',	     
					     2,   'PROCESSED',	     
                                             3,   'EXPIRED',
                                             8,   'DEFERRED')),      
  			      (decode(h.transaction_id,     
				      NULL, 'UNDELIVERABLE',	  
				      'PROCESSED'))) MSG_STATE,  cast(FROM_TZ(qt.delay, '-06:00')
                 at time zone sessiontimezone as date) delay,  delay DELAY_TIMESTAMP, expiration,  cast(FROM_TZ(qt.enq_time, '-06:00')
                 at time zone sessiontimezone as date) enq_time,  cast(FROM_TZ(qt.enq_time, '-06:00')
                 at time zone sessiontimezone as timestamp)
                 enq_timestamp,   enq_uid ENQ_USER_ID,  enq_tid ENQ_TXN_ID,  decode(h.transaction_id, NULL, TO_DATE(NULL), 	  
                        cast(FROM_TZ(h.dequeue_time, '-06:00')
                 at time zone sessiontimezone as date)) DEQ_TIME,  decode(h.transaction_id, NULL, TO_TIMESTAMP(NULL), 	  
                        cast(FROM_TZ(h.dequeue_time, '-06:00')
                 at time zone sessiontimezone as timestamp))
                 DEQ_TIMESTAMP,  h.dequeue_user DEQ_USER_ID,  h.transaction_id DEQ_TXN_ID,  h.retry_count retry_count,  decode (state, 0, exception_qschema, 
                                1, exception_qschema, 
                                2, exception_qschema,  
                                NULL) EXCEPTION_QUEUE_OWNER,  decode (state, 0, exception_queue, 
                                1, exception_queue, 
                                2, exception_queue,  
                                NULL) EXCEPTION_QUEUE,  user_data,  h.propagated_msgid PROPAGATED_MSGID,  sender_name  SENDER_NAME, sender_address  SENDER_ADDRESS, sender_protocol  SENDER_PROTOCOL, dequeue_msgid ORIGINAL_MSGID,  decode (h.dequeue_time, NULL, 
                   decode (state, 3, exception_queue, NULL),
                   decode (h.transaction_id, NULL, NULL, exception_queue)) 
                                ORIGINAL_QUEUE_NAME,  decode (h.dequeue_time, NULL, 
                   decode (state, 3, exception_qschema, NULL),
                   decode (h.transaction_id, NULL, NULL, exception_qschema)) 
                                ORIGINAL_QUEUE_OWNER,  decode(h.dequeue_time, NULL, 
                   decode(state, 3, 
                     decode(h.transaction_id, NULL, 'TIME_EXPIRATION',
                            'INVALID_TRANSACTION', NULL,
                            'MAX_RETRY_EXCEEDED'), NULL),
                   decode(h.transaction_id, NULL, 'PROPAGATION_FAILURE',
                          NULL)) EXPIRATION_REASON,  decode(h.subscriber#, 0, decode(h.name, '0', NULL,
							        h.name),
					  s.name) CONSUMER_NAME,  s.address ADDRESS,  s.protocol PROTOCOL  FROM "ALERT_QT" qt, "AQ$_ALERT_QT_H" h, "AQ$_ALERT_QT_S" s  WHERE qt.msgid = h.msgid AND  ((h.subscriber# != 0 AND h.subscriber# = s.subscriber_id)  OR (h.subscriber# = 0 AND h.address# = s.subscriber_id)) AND qt.state != 7 WITH READ ONLY;

CREATE OR REPLACE FORCE VIEW "AQ$ALERT_QT_R"("QUEUE",
SELECT queue_name QUEUE, s.name NAME , address ADDRESS , protocol PROTOCOL, rule_condition RULE, ruleset_name RULE_SET, trans_name TRANSFORMATION  FROM "AQ$_ALERT_QT_S" s , sys.all_rules r WHERE (bitand(s.subscriber_type, 1) = 1) AND s.rule_name = r.rule_name and r.rule_owner = 'SYS'  WITH READ ONLY;

CREATE OR REPLACE FORCE VIEW "AQ$ALERT_QT_S"("QUEUE",
SELECT queue_name QUEUE, name NAME , address ADDRESS , protocol PROTOCOL, trans_name TRANSFORMATION  FROM "AQ$_ALERT_QT_S" s  WHERE (bitand(s.subscriber_type, 1) = 1)  WITH READ ONLY;

CREATE OR REPLACE FORCE VIEW "AQ$AQ$_MEM_MC"("QUEUE",
SELECT  q_name QUEUE, qt.msgid MSG_ID, corrid CORR_ID,  priority MSG_PRIORITY,  decode(h.dequeue_time, NULL,	  
			      (decode(state, 0,   'READY',	     
                              		     1,   'WAIT',	     
					     2,   'PROCESSED',	     
                                             3,   'EXPIRED',
                                             8,   'DEFERRED')),      
  			      (decode(h.transaction_id,     
				      NULL, 'UNDELIVERABLE',	  
				      'PROCESSED'))) MSG_STATE,  cast(FROM_TZ(qt.delay, '-06:00')
                 at time zone sessiontimezone as date) delay,  delay DELAY_TIMESTAMP, expiration,  cast(FROM_TZ(qt.enq_time, '-06:00')
                 at time zone sessiontimezone as date) enq_time,  cast(FROM_TZ(qt.enq_time, '-06:00')
                 at time zone sessiontimezone as timestamp)
                 enq_timestamp,   enq_uid ENQ_USER_ID,  enq_tid ENQ_TXN_ID,  decode(h.transaction_id, NULL, TO_DATE(NULL), 	  
                        cast(FROM_TZ(h.dequeue_time, '-06:00')
                 at time zone sessiontimezone as date)) DEQ_TIME,  decode(h.transaction_id, NULL, TO_TIMESTAMP(NULL), 	  
                        cast(FROM_TZ(h.dequeue_time, '-06:00')
                 at time zone sessiontimezone as timestamp))
                 DEQ_TIMESTAMP,  h.dequeue_user DEQ_USER_ID,  h.transaction_id DEQ_TXN_ID,  h.retry_count retry_count,  decode (state, 0, exception_qschema, 
                                1, exception_qschema, 
                                2, exception_qschema,  
                                NULL) EXCEPTION_QUEUE_OWNER,  decode (state, 0, exception_queue, 
                                1, exception_queue, 
                                2, exception_queue,  
                                NULL) EXCEPTION_QUEUE,  user_data,  h.propagated_msgid PROPAGATED_MSGID,  sender_name  SENDER_NAME, sender_address  SENDER_ADDRESS, sender_protocol  SENDER_PROTOCOL, dequeue_msgid ORIGINAL_MSGID,  decode (h.dequeue_time, NULL, 
                   decode (state, 3, exception_queue, NULL),
                   decode (h.transaction_id, NULL, NULL, exception_queue)) 
                                ORIGINAL_QUEUE_NAME,  decode (h.dequeue_time, NULL, 
                   decode (state, 3, exception_qschema, NULL),
                   decode (h.transaction_id, NULL, NULL, exception_qschema)) 
                                ORIGINAL_QUEUE_OWNER,  decode(h.dequeue_time, NULL, 
                   decode(state, 3, 
                     decode(h.transaction_id, NULL, 'TIME_EXPIRATION',
                            'INVALID_TRANSACTION', NULL,
                            'MAX_RETRY_EXCEEDED'), NULL),
                   decode(h.transaction_id, NULL, 'PROPAGATION_FAILURE',
                          NULL)) EXPIRATION_REASON,  decode(h.subscriber#, 0, decode(h.name, '0', NULL,
							        h.name),
					  s.name) CONSUMER_NAME,  s.address ADDRESS,  s.protocol PROTOCOL  FROM "AQ$_MEM_MC" qt, "AQ$_AQ$_MEM_MC_H" h, "AQ$_AQ$_MEM_MC_S" s  WHERE qt.msgid = h.msgid AND  ((h.subscriber# != 0 AND h.subscriber# = s.subscriber_id)  OR (h.subscriber# = 0 AND h.address# = s.subscriber_id)) AND qt.state != 7 WITH READ ONLY;

CREATE OR REPLACE FORCE VIEW "AQ$AQ$_MEM_MC_S"("QUEUE",
SELECT queue_name QUEUE, name NAME , address ADDRESS , protocol PROTOCOL, trans_name TRANSFORMATION  FROM "AQ$_AQ$_MEM_MC_S" s  WHERE (bitand(s.subscriber_type, 1) = 1)  WITH READ ONLY;

CREATE OR REPLACE FORCE VIEW "AQ$AQ_EVENT_TABLE"("QUEUE",
SELECT q_name QUEUE, msgid MSG_ID, corrid CORR_ID, priority MSG_PRIORITY, decode(state, 0,   'READY',
                                1,   'WAIT',
                                2,   'PROCESSED',
                                3,   'EXPIRED') MSG_STATE, cast(FROM_TZ(delay, '-06:00')
                  at time zone sessiontimezone as date) DELAY, delay DELAY_TIMESTAMP, expiration, cast(FROM_TZ(enq_time, '-06:00')
                  at time zone sessiontimezone as date) ENQ_TIME, cast(FROM_TZ(enq_time, '-06:00')
                  at time zone sessiontimezone as timestamp) 
                  ENQ_TIMESTAMP, enq_uid ENQ_USER_ID, enq_tid ENQ_TXN_ID, cast(FROM_TZ(deq_time, '-06:00')
                  at time zone sessiontimezone as date) DEQ_TIME, cast(FROM_TZ(deq_time, '-06:00')
                  at time zone sessiontimezone as timestamp) 
                  DEQ_TIMESTAMP, deq_uid DEQ_USER_ID, deq_tid DEQ_TXN_ID, retry_count,  decode (state, 0, exception_qschema, 
                                  1, exception_qschema, 
                                  2, exception_qschema,  
                                  NULL) EXCEPTION_QUEUE_OWNER,  decode (state, 0, exception_queue, 
                                  1, exception_queue, 
                                  2, exception_queue,  
                                  NULL) EXCEPTION_QUEUE,  user_data,  decode (state, 3, 
                     decode (deq_tid, 'INVALID_TRANSACTION', NULL, 
                             exception_queue), NULL)
                                ORIGINAL_QUEUE_NAME,  decode (state, 3, 
                     decode (deq_tid, 'INVALID_TRANSACTION', NULL, 
                             exception_qschema), NULL)
                                ORIGINAL_QUEUE_OWNER,  decode(state, 3, 
                     decode(deq_time, NULL, 
                       decode(deq_tid, NULL, 'TIME_EXPIRATION',
                              'INVALID_TRANSACTION', NULL,
                              'MAX_RETRY_EXCEEDED'), NULL), NULL) 
                             EXPIRATION_REASON  FROM "AQ_EVENT_TABLE" WHERE state != 7 AND   state != 9 WITH READ ONLY;

CREATE OR REPLACE FORCE VIEW "AQ$AQ_SRVNTFN_TABLE"("QUEUE",
SELECT q_name QUEUE, msgid MSG_ID, corrid CORR_ID, priority MSG_PRIORITY, decode(state, 0,   'READY',
                                1,   'WAIT',
                                2,   'PROCESSED',
                                3,   'EXPIRED') MSG_STATE, cast(FROM_TZ(delay, '-06:00')
                  at time zone sessiontimezone as date) DELAY, delay DELAY_TIMESTAMP, expiration, cast(FROM_TZ(enq_time, '-06:00')
                  at time zone sessiontimezone as date) ENQ_TIME, cast(FROM_TZ(enq_time, '-06:00')
                  at time zone sessiontimezone as timestamp) 
                  ENQ_TIMESTAMP, enq_uid ENQ_USER_ID, enq_tid ENQ_TXN_ID, cast(FROM_TZ(deq_time, '-06:00')
                  at time zone sessiontimezone as date) DEQ_TIME, cast(FROM_TZ(deq_time, '-06:00')
                  at time zone sessiontimezone as timestamp) 
                  DEQ_TIMESTAMP, deq_uid DEQ_USER_ID, deq_tid DEQ_TXN_ID, retry_count,  decode (state, 0, exception_qschema, 
                                  1, exception_qschema, 
                                  2, exception_qschema,  
                                  NULL) EXCEPTION_QUEUE_OWNER,  decode (state, 0, exception_queue, 
                                  1, exception_queue, 
                                  2, exception_queue,  
                                  NULL) EXCEPTION_QUEUE,  user_data,  decode (state, 3, 
                     decode (deq_tid, 'INVALID_TRANSACTION', NULL, 
                             exception_queue), NULL)
                                ORIGINAL_QUEUE_NAME,  decode (state, 3, 
                     decode (deq_tid, 'INVALID_TRANSACTION', NULL, 
                             exception_qschema), NULL)
                                ORIGINAL_QUEUE_OWNER,  decode(state, 3, 
                     decode(deq_time, NULL, 
                       decode(deq_tid, NULL, 'TIME_EXPIRATION',
                              'INVALID_TRANSACTION', NULL,
                              'MAX_RETRY_EXCEEDED'), NULL), NULL) 
                             EXPIRATION_REASON , sender_name SENDER_NAME, sender_address SENDER_ADDRESS, sender_protocol SENDER_PROTOCOL, dequeue_msgid ORIGINAL_MSGID  FROM "AQ_SRVNTFN_TABLE" WHERE state != 7 AND   state != 9 WITH READ ONLY;

CREATE OR REPLACE FORCE VIEW "AQ$DIR$CLUSTER_DIR_TABLE"("QUEUE",
SELECT  q_name QUEUE, qt.msgid MSG_ID, corrid CORR_ID,  priority MSG_PRIORITY,  decode(h.dequeue_time, NULL,	  
			      (decode(state, 0,   'READY',	     
                              		     1,   'WAIT',	     
					     2,   'PROCESSED',	     
                                             3,   'EXPIRED',
                                             8,   'DEFERRED')),      
  			      (decode(h.transaction_id,     
				      NULL, 'UNDELIVERABLE',	  
				      'PROCESSED'))) MSG_STATE,  cast(FROM_TZ(qt.delay, '-06:00')
                 at time zone sessiontimezone as date) delay,  delay DELAY_TIMESTAMP, expiration,  cast(FROM_TZ(qt.enq_time, '-06:00')
                 at time zone sessiontimezone as date) enq_time,  cast(FROM_TZ(qt.enq_time, '-06:00')
                 at time zone sessiontimezone as timestamp)
                 enq_timestamp,   enq_uid ENQ_USER_ID,  enq_tid ENQ_TXN_ID,  decode(h.transaction_id, NULL, TO_DATE(NULL), 	  
                        cast(FROM_TZ(h.dequeue_time, '-06:00')
                 at time zone sessiontimezone as date)) DEQ_TIME,  decode(h.transaction_id, NULL, TO_TIMESTAMP(NULL), 	  
                        cast(FROM_TZ(h.dequeue_time, '-06:00')
                 at time zone sessiontimezone as timestamp))
                 DEQ_TIMESTAMP,  h.dequeue_user DEQ_USER_ID,  h.transaction_id DEQ_TXN_ID,  h.retry_count retry_count,  decode (state, 0, exception_qschema, 
                                1, exception_qschema, 
                                2, exception_qschema,  
                                NULL) EXCEPTION_QUEUE_OWNER,  decode (state, 0, exception_queue, 
                                1, exception_queue, 
                                2, exception_queue,  
                                NULL) EXCEPTION_QUEUE,  user_data,  h.propagated_msgid PROPAGATED_MSGID,  sender_name  SENDER_NAME, sender_address  SENDER_ADDRESS, sender_protocol  SENDER_PROTOCOL, dequeue_msgid ORIGINAL_MSGID,  decode (h.dequeue_time, NULL, 
                   decode (state, 3, exception_queue, NULL),
                   decode (h.transaction_id, NULL, NULL, exception_queue)) 
                                ORIGINAL_QUEUE_NAME,  decode (h.dequeue_time, NULL, 
                   decode (state, 3, exception_qschema, NULL),
                   decode (h.transaction_id, NULL, NULL, exception_qschema)) 
                                ORIGINAL_QUEUE_OWNER,  decode(h.dequeue_time, NULL, 
                   decode(state, 3, 
                     decode(h.transaction_id, NULL, 'TIME_EXPIRATION',
                            'INVALID_TRANSACTION', NULL,
                            'MAX_RETRY_EXCEEDED'), NULL),
                   decode(h.transaction_id, NULL, 'PROPAGATION_FAILURE',
                          NULL)) EXPIRATION_REASON,  decode(h.subscriber#, 0, decode(h.name, '0', NULL,
							        h.name),
					  s.name) CONSUMER_NAME,  s.address ADDRESS,  s.protocol PROTOCOL  FROM "DIR$CLUSTER_DIR_TABLE" qt, "AQ$_DIR$CLUSTER_DIR_TABLE_H" h, "AQ$_DIR$CLUSTER_DIR_TABLE_S" s  WHERE qt.msgid = h.msgid AND  ((h.subscriber# != 0 AND h.subscriber# = s.subscriber_id)  OR (h.subscriber# = 0 AND h.address# = s.subscriber_id)) AND qt.state != 7 WITH READ ONLY;

CREATE OR REPLACE FORCE VIEW "AQ$DIR$CLUSTER_DIR_TABLE_R"("QUEUE",
SELECT queue_name QUEUE, s.name NAME , address ADDRESS , protocol PROTOCOL, rule_condition RULE, ruleset_name RULE_SET, trans_name TRANSFORMATION  FROM "AQ$_DIR$CLUSTER_DIR_TABLE_S" s , sys.all_rules r WHERE (bitand(s.subscriber_type, 1) = 1) AND s.rule_name = r.rule_name and r.rule_owner = 'SYS'  WITH READ ONLY;

CREATE OR REPLACE FORCE VIEW "AQ$DIR$CLUSTER_DIR_TABLE_S"("QUEUE",
SELECT queue_name QUEUE, name NAME , address ADDRESS , protocol PROTOCOL, trans_name TRANSFORMATION  FROM "AQ$_DIR$CLUSTER_DIR_TABLE_S" s  WHERE (bitand(s.subscriber_type, 1) = 1)  WITH READ ONLY;

CREATE OR REPLACE FORCE VIEW "AQ$DIR$EVENT_TABLE"("QUEUE",
SELECT  q_name QUEUE, qt.msgid MSG_ID, corrid CORR_ID,  priority MSG_PRIORITY,  decode(h.dequeue_time, NULL,	  
			      (decode(state, 0,   'READY',	     
                              		     1,   'WAIT',	     
					     2,   'PROCESSED',	     
                                             3,   'EXPIRED',
                                             8,   'DEFERRED')),      
  			      (decode(h.transaction_id,     
				      NULL, 'UNDELIVERABLE',	  
				      'PROCESSED'))) MSG_STATE,  cast(FROM_TZ(qt.delay, '-06:00')
                 at time zone sessiontimezone as date) delay,  delay DELAY_TIMESTAMP, expiration,  cast(FROM_TZ(qt.enq_time, '-06:00')
                 at time zone sessiontimezone as date) enq_time,  cast(FROM_TZ(qt.enq_time, '-06:00')
                 at time zone sessiontimezone as timestamp)
                 enq_timestamp,   enq_uid ENQ_USER_ID,  enq_tid ENQ_TXN_ID,  decode(h.transaction_id, NULL, TO_DATE(NULL), 	  
                        cast(FROM_TZ(h.dequeue_time, '-06:00')
                 at time zone sessiontimezone as date)) DEQ_TIME,  decode(h.transaction_id, NULL, TO_TIMESTAMP(NULL), 	  
                        cast(FROM_TZ(h.dequeue_time, '-06:00')
                 at time zone sessiontimezone as timestamp))
                 DEQ_TIMESTAMP,  h.dequeue_user DEQ_USER_ID,  h.transaction_id DEQ_TXN_ID,  h.retry_count retry_count,  decode (state, 0, exception_qschema, 
                                1, exception_qschema, 
                                2, exception_qschema,  
                                NULL) EXCEPTION_QUEUE_OWNER,  decode (state, 0, exception_queue, 
                                1, exception_queue, 
                                2, exception_queue,  
                                NULL) EXCEPTION_QUEUE,  user_data,  h.propagated_msgid PROPAGATED_MSGID,  sender_name  SENDER_NAME, sender_address  SENDER_ADDRESS, sender_protocol  SENDER_PROTOCOL, dequeue_msgid ORIGINAL_MSGID,  decode (h.dequeue_time, NULL, 
                   decode (state, 3, exception_queue, NULL),
                   decode (h.transaction_id, NULL, NULL, exception_queue)) 
                                ORIGINAL_QUEUE_NAME,  decode (h.dequeue_time, NULL, 
                   decode (state, 3, exception_qschema, NULL),
                   decode (h.transaction_id, NULL, NULL, exception_qschema)) 
                                ORIGINAL_QUEUE_OWNER,  decode(h.dequeue_time, NULL, 
                   decode(state, 3, 
                     decode(h.transaction_id, NULL, 'TIME_EXPIRATION',
                            'INVALID_TRANSACTION', NULL,
                            'MAX_RETRY_EXCEEDED'), NULL),
                   decode(h.transaction_id, NULL, 'PROPAGATION_FAILURE',
                          NULL)) EXPIRATION_REASON,  decode(h.subscriber#, 0, decode(h.name, '0', NULL,
							        h.name),
					  s.name) CONSUMER_NAME,  s.address ADDRESS,  s.protocol PROTOCOL  FROM "DIR$EVENT_TABLE" qt, "AQ$_DIR$EVENT_TABLE_H" h, "AQ$_DIR$EVENT_TABLE_S" s  WHERE qt.msgid = h.msgid AND  ((h.subscriber# != 0 AND h.subscriber# = s.subscriber_id)  OR (h.subscriber# = 0 AND h.address# = s.subscriber_id)) AND qt.state != 7 WITH READ ONLY;

CREATE OR REPLACE FORCE VIEW "AQ$DIR$EVENT_TABLE_R"("QUEUE",
SELECT queue_name QUEUE, s.name NAME , address ADDRESS , protocol PROTOCOL, rule_condition RULE, ruleset_name RULE_SET, trans_name TRANSFORMATION  FROM "AQ$_DIR$EVENT_TABLE_S" s , sys.all_rules r WHERE (bitand(s.subscriber_type, 1) = 1) AND s.rule_name = r.rule_name and r.rule_owner = 'SYS'  WITH READ ONLY;

CREATE OR REPLACE FORCE VIEW "AQ$DIR$EVENT_TABLE_S"("QUEUE",
SELECT queue_name QUEUE, name NAME , address ADDRESS , protocol PROTOCOL, trans_name TRANSFORMATION  FROM "AQ$_DIR$EVENT_TABLE_S" s  WHERE (bitand(s.subscriber_type, 1) = 1)  WITH READ ONLY;

CREATE OR REPLACE FORCE VIEW "AQ$INTERNET_USERS"("AGENT_NAME",
(SELECT t.agent_name, t.db_username, decode(bitand(u.protocol, 1), 0, 'NO  ', 1, 'YES ') http_enabled, decode(bitand(u.protocol, 2), 0, 'NO  ', 2, 'YES ') smtp_enabled, decode(bitand(u.protocol, 4), 0, 'NO  ', 4, 'YES ') ftp_enabled FROM SYSTEM.AQ$_Internet_Agent_Privs t, SYSTEM.AQ$_Internet_Agents u WHERE t.agent_name = u.agent_name UNION (SELECT x.agent_name, NULL, decode(bitand(x.protocol, 1), 0, 'NO  ', 1, 'YES ') http_enabled, decode(bitand(x.protocol, 2), 0, 'NO  ', 2, 'YES ') smtp_enabled, decode(bitand(x.protocol, 4), 0, 'NO  ', 4, 'YES ') ftp_enabled FROM SYSTEM.AQ$_Internet_Agents x WHERE (x.agent_name NOT IN (SELECT y.agent_name FROM SYSTEM.AQ$_Internet_Agent_Privs y))));

CREATE OR REPLACE FORCE VIEW "AQ$KUPC$DATAPUMP_QUETAB"("QUEUE",
SELECT  q_name QUEUE, qt.msgid MSG_ID, corrid CORR_ID,  priority MSG_PRIORITY,  decode(h.dequeue_time, NULL,	  
			      (decode(state, 0,   'READY',	     
                              		     1,   'WAIT',	     
					     2,   'PROCESSED',	     
                                             3,   'EXPIRED',
                                             8,   'DEFERRED')),      
  			      (decode(h.transaction_id,     
				      NULL, 'UNDELIVERABLE',	  
				      'PROCESSED'))) MSG_STATE,  cast(FROM_TZ(qt.delay, '-06:00')
                 at time zone sessiontimezone as date) delay,  delay DELAY_TIMESTAMP, expiration,  cast(FROM_TZ(qt.enq_time, '-06:00')
                 at time zone sessiontimezone as date) enq_time,  cast(FROM_TZ(qt.enq_time, '-06:00')
                 at time zone sessiontimezone as timestamp)
                 enq_timestamp,   enq_uid ENQ_USER_ID,  enq_tid ENQ_TXN_ID,  decode(h.transaction_id, NULL, TO_DATE(NULL), 	  
                        cast(FROM_TZ(h.dequeue_time, '-06:00')
                 at time zone sessiontimezone as date)) DEQ_TIME,  decode(h.transaction_id, NULL, TO_TIMESTAMP(NULL), 	  
                        cast(FROM_TZ(h.dequeue_time, '-06:00')
                 at time zone sessiontimezone as timestamp))
                 DEQ_TIMESTAMP,  h.dequeue_user DEQ_USER_ID,  h.transaction_id DEQ_TXN_ID,  h.retry_count retry_count,  decode (state, 0, exception_qschema, 
                                1, exception_qschema, 
                                2, exception_qschema,  
                                NULL) EXCEPTION_QUEUE_OWNER,  decode (state, 0, exception_queue, 
                                1, exception_queue, 
                                2, exception_queue,  
                                NULL) EXCEPTION_QUEUE,  user_data,  h.propagated_msgid PROPAGATED_MSGID,  sender_name  SENDER_NAME, sender_address  SENDER_ADDRESS, sender_protocol  SENDER_PROTOCOL, dequeue_msgid ORIGINAL_MSGID,  decode (h.dequeue_time, NULL, 
                   decode (state, 3, exception_queue, NULL),
                   decode (h.transaction_id, NULL, NULL, exception_queue)) 
                                ORIGINAL_QUEUE_NAME,  decode (h.dequeue_time, NULL, 
                   decode (state, 3, exception_qschema, NULL),
                   decode (h.transaction_id, NULL, NULL, exception_qschema)) 
                                ORIGINAL_QUEUE_OWNER,  decode(h.dequeue_time, NULL, 
                   decode(state, 3, 
                     decode(h.transaction_id, NULL, 'TIME_EXPIRATION',
                            'INVALID_TRANSACTION', NULL,
                            'MAX_RETRY_EXCEEDED'), NULL),
                   decode(h.transaction_id, NULL, 'PROPAGATION_FAILURE',
                          NULL)) EXPIRATION_REASON,  decode(h.subscriber#, 0, decode(h.name, '0', NULL,
							        h.name),
					  s.name) CONSUMER_NAME,  s.address ADDRESS,  s.protocol PROTOCOL  FROM "KUPC$DATAPUMP_QUETAB" qt, "AQ$_KUPC$DATAPUMP_QUETAB_H" h, "AQ$_KUPC$DATAPUMP_QUETAB_S" s  WHERE qt.msgid = h.msgid AND  ((h.subscriber# != 0 AND h.subscriber# = s.subscriber_id)  OR (h.subscriber# = 0 AND h.address# = s.subscriber_id)) AND qt.state != 7 UNION ALL SELECT q.name QUEUE, b.msg_id MSG_ID, b.corr_id CORR_ID, b.msg_priority MSG_PRIORITY, decode (b.msg_state, 0, 'IN MEMORY',
                                        1, 'DEFERRED',
                                        NULL) MSG_STATE, null DELAY, null DELAY_TIMESTAMP, b.expiration EXPIRATION, cast(FROM_TZ(b.enq_time, '-06:00')
                   at time zone sessiontimezone as date) ENQ_TIME, cast(FROM_TZ(b.enq_time, '-06:00')
                   at time zone sessiontimezone as timestamp)
                   ENQ_TIMESTAMP, b.enq_user_id ENQ_USER_ID, null ENQ_TXN_ID, null DEQ_TIME, null DEQ_TIMESTAMP, null DEQ_USER_ID, null DEQ_TXN_ID, null RETRY_COUNT, null EXCEPTION_QUEUE_OWNER, null EXCEPTION_QUEUE, sys.dbms_aq_bqview.get_adt_payload(b.queue_id, b.msg_num, SYS.KUPC$_MESSAGE(NULL, NULL)) USER_DATA, null PROPAGATED_MSGID, b.sender_name SENDER_NAME, b.sender_address SENDER_ADDRESS, b.sender_protocol SENDER_PROTOCOL, b.original_msgid ORIGINAL_MSGID, null ORIGINAL_QUEUE_NAME, null ORIGINAL_QUEUE_OWNER, null EXPIRATION_REASON, s.name CONSUMER_NAME, s.address ADDRESS, s.protocol PROTOCOL FROM SYS.qt6612_BUFFER b, all_queues q, "AQ$_KUPC$DATAPUMP_QUETAB_S" s WHERE s.subscriber_id = b.subscriber_id AND bitand(s.subscriber_type, 8) != 8 AND bitand(b.msg_state,2) = 0 AND q.qid = b.queue_id UNION ALL SELECT p.q_name QUEUE, p.msgid MSG_ID, p.corrid CORR_ID, p.priority MSG_PRIORITY, decode (b.msg_state, 2, 'SPILLED',
                                        3, 'DEFERRED SPILLED',
                                        NULL) MSG_STATE, cast(FROM_TZ(p.delay, '-06:00')
                   at time zone sessiontimezone as date) DELAY, p.delay DELAY_TIMESTAMP, p.expiration EXPIRATION, cast(FROM_TZ(p.enq_time, '-06:00')
                   at time zone sessiontimezone as date) ENQ_TIME, cast(FROM_TZ(p.enq_time, '-06:00')
                   at time zone sessiontimezone as timestamp)
                   ENQ_TIMESTAMP, p.enq_uid ENQ_USER_ID, p.enq_tid ENQ_TXN_ID, cast(FROM_TZ(p.deq_time, '-06:00')
                   at time zone sessiontimezone as date) DEQ_TIME, cast(FROM_TZ(p.deq_time, '-06:00')
                   at time zone sessiontimezone as timestamp)
                   DEQ_TIMESTAMP, p.deq_uid DEQ_USER_ID, p.deq_tid DEQ_TXN_ID, p.retry_count RETRY_COUNT, p.exception_qschema EXCEPTION_QUEUE_OWNER, p.exception_queue EXCEPTION_QUEUE, p.user_data USER_DATA, null PROPAGATED_MSGID, p.sender_name SENDER_NAME, p.sender_address SENDER_ADDRESS, p.sender_protocol SENDER_PROTOCOL, null ORIGINAL_MSGID, null ORIGINAL_QUEUE_NAME, null ORIGINAL_QUEUE_OWNER, null EXPIRATION_REASON, s.name CONSUMER_NAME, s.address ADDRESS, s.protocol PROTOCOL FROM "AQ$_KUPC$DATAPUMP_QUETAB_P" p, SYS.qt6612_BUFFER b, "AQ$_KUPC$DATAPUMP_QUETAB_S" s WHERE b.subscriber_id = s.subscriber_id AND bitand(s.subscriber_type, 8) != 8 AND bitand(b.msg_state,2) = 2 AND p.msgid = b.msg_id WITH READ ONLY;

CREATE OR REPLACE FORCE VIEW "AQ$KUPC$DATAPUMP_QUETAB_R"("QUEUE",
SELECT queue_name QUEUE, s.name NAME , address ADDRESS , protocol PROTOCOL, rule_condition RULE, ruleset_name RULE_SET, trans_name TRANSFORMATION  FROM "AQ$_KUPC$DATAPUMP_QUETAB_S" s , sys.all_rules r WHERE (bitand(s.subscriber_type, 1) = 1) AND s.rule_name = r.rule_name and r.rule_owner = 'SYS'  WITH READ ONLY;

CREATE OR REPLACE FORCE VIEW "AQ$KUPC$DATAPUMP_QUETAB_S"("QUEUE",
SELECT queue_name QUEUE, name NAME , address ADDRESS , protocol PROTOCOL, trans_name TRANSFORMATION  FROM "AQ$_KUPC$DATAPUMP_QUETAB_S" s  WHERE (bitand(s.subscriber_type, 1) = 1)  WITH READ ONLY;

CREATE OR REPLACE FORCE VIEW "AQ$SCHEDULER$_JOBQTAB"("QUEUE",
SELECT  q_name QUEUE, qt.msgid MSG_ID, corrid CORR_ID,  priority MSG_PRIORITY,  decode(h.dequeue_time, NULL,	  
			      (decode(state, 0,   'READY',	     
                              		     1,   'WAIT',	     
					     2,   'PROCESSED',	     
                                             3,   'EXPIRED',
                                             8,   'DEFERRED')),      
  			      (decode(h.transaction_id,     
				      NULL, 'UNDELIVERABLE',	  
				      'PROCESSED'))) MSG_STATE,  cast(FROM_TZ(qt.delay, '-06:00')
                 at time zone sessiontimezone as date) delay,  delay DELAY_TIMESTAMP, expiration,  cast(FROM_TZ(qt.enq_time, '-06:00')
                 at time zone sessiontimezone as date) enq_time,  cast(FROM_TZ(qt.enq_time, '-06:00')
                 at time zone sessiontimezone as timestamp)
                 enq_timestamp,   enq_uid ENQ_USER_ID,  enq_tid ENQ_TXN_ID,  decode(h.transaction_id, NULL, TO_DATE(NULL), 	  
                        cast(FROM_TZ(h.dequeue_time, '-06:00')
                 at time zone sessiontimezone as date)) DEQ_TIME,  decode(h.transaction_id, NULL, TO_TIMESTAMP(NULL), 	  
                        cast(FROM_TZ(h.dequeue_time, '-06:00')
                 at time zone sessiontimezone as timestamp))
                 DEQ_TIMESTAMP,  h.dequeue_user DEQ_USER_ID,  h.transaction_id DEQ_TXN_ID,  h.retry_count retry_count,  decode (state, 0, exception_qschema, 
                                1, exception_qschema, 
                                2, exception_qschema,  
                                NULL) EXCEPTION_QUEUE_OWNER,  decode (state, 0, exception_queue, 
                                1, exception_queue, 
                                2, exception_queue,  
                                NULL) EXCEPTION_QUEUE,  user_data,  h.propagated_msgid PROPAGATED_MSGID,  sender_name  SENDER_NAME, sender_address  SENDER_ADDRESS, sender_protocol  SENDER_PROTOCOL, dequeue_msgid ORIGINAL_MSGID,  decode (h.dequeue_time, NULL, 
                   decode (state, 3, exception_queue, NULL),
                   decode (h.transaction_id, NULL, NULL, exception_queue)) 
                                ORIGINAL_QUEUE_NAME,  decode (h.dequeue_time, NULL, 
                   decode (state, 3, exception_qschema, NULL),
                   decode (h.transaction_id, NULL, NULL, exception_qschema)) 
                                ORIGINAL_QUEUE_OWNER,  decode(h.dequeue_time, NULL, 
                   decode(state, 3, 
                     decode(h.transaction_id, NULL, 'TIME_EXPIRATION',
                            'INVALID_TRANSACTION', NULL,
                            'MAX_RETRY_EXCEEDED'), NULL),
                   decode(h.transaction_id, NULL, 'PROPAGATION_FAILURE',
                          NULL)) EXPIRATION_REASON,  decode(h.subscriber#, 0, decode(h.name, '0', NULL,
							        h.name),
					  s.name) CONSUMER_NAME,  s.address ADDRESS,  s.protocol PROTOCOL  FROM "SCHEDULER$_JOBQTAB" qt, "AQ$_SCHEDULER$_JOBQTAB_H" h, "AQ$_SCHEDULER$_JOBQTAB_S" s  WHERE qt.msgid = h.msgid AND  ((h.subscriber# != 0 AND h.subscriber# = s.subscriber_id)  OR (h.subscriber# = 0 AND h.address# = s.subscriber_id)) AND qt.state != 7 WITH READ ONLY;

CREATE OR REPLACE FORCE VIEW "AQ$SCHEDULER$_JOBQTAB_R"("QUEUE",
SELECT queue_name QUEUE, s.name NAME , address ADDRESS , protocol PROTOCOL, rule_condition RULE, ruleset_name RULE_SET, trans_name TRANSFORMATION  FROM "AQ$_SCHEDULER$_JOBQTAB_S" s , sys.all_rules r WHERE (bitand(s.subscriber_type, 1) = 1) AND s.rule_name = r.rule_name and r.rule_owner = 'SYS'  WITH READ ONLY;

CREATE OR REPLACE FORCE VIEW "AQ$SCHEDULER$_JOBQTAB_S"("QUEUE",
SELECT queue_name QUEUE, name NAME , address ADDRESS , protocol PROTOCOL, trans_name TRANSFORMATION  FROM "AQ$_SCHEDULER$_JOBQTAB_S" s  WHERE (bitand(s.subscriber_type, 1) = 1)  WITH READ ONLY;

CREATE OR REPLACE FORCE VIEW "CATALOG"("TNAME",
select tname, creator, tabletype, remarks
  from  syscatalog_
  where creatorid not in (select user# from sys.user$ where name in
        ('SYS','SYSTEM'));

CREATE OR REPLACE FORCE VIEW "CHANGE_SETS"("SET_NAME",
SELECT
   s.set_name, s.change_source_name, s.begin_date, s.end_date, s.begin_scn,
   s.end_scn, s.freshness_date, s.freshness_scn, s.advance_enabled,
   s.ignore_ddl, s.created, s.rollback_segment_name, s.advancing, s.purging,
   s.lowest_scn, s.tablespace, s.capture_enabled, s.stop_on_ddl,
   s.capture_error, s.capture_name, s.queue_name, s.queue_table_name,
   s.apply_name, s.set_description, s.publisher
  FROM sys.cdc_change_sets$ s;

CREATE OR REPLACE FORCE VIEW "CHANGE_SOURCES"("SOURCE_NAME",
SELECT
   s.source_name, s.dbid, s.logfile_location, s.logfile_suffix,
   s.source_description, s.created,
   decode(s.source_type, 2, 'AUTOLOG',
                         3, 'HOTLOG',
                         4, 'SYNCHRONOUS',
                            'UNKNOWN'),
   s.source_database, s.first_scn, s.publisher
  FROM sys.cdc_change_sources$ s;

CREATE OR REPLACE FORCE VIEW "CHANGE_TABLES"("CHANGE_TABLE_SCHEMA",
SELECT
   s.change_table_schema, s.change_table_name, s.change_set_name,
   s.source_schema_name, s.source_table_name, s.created, s.created_scn,
   s.captured_values, s.obj#
  FROM sys.cdc_change_tables$ s;

CREATE OR REPLACE FORCE VIEW "CODE_PIECES"("OBJ#",
select i.obj#, i.length
  from sys.idl_ub1$ i
  where i.part in (1,2)
union all
  select i.obj#, i.length
  from sys.idl_ub2$ i
  where i.part in (1,2)
union all
  select i.obj#, i.length
  from sys.idl_sb4$ i
  where i.part in (1,2)
union all
  select i.obj#, i.length
  from sys.idl_char$ i
  where i.part in (1,2);

CREATE OR REPLACE FORCE VIEW "CODE_SIZE"("OBJ#",
select c.obj#, sum(c.bytes)
  from sys.code_pieces c
  group by c.obj#;

CREATE OR REPLACE FORCE VIEW "COL"("TNAME",
select t.name, c.col#, c.name,
         decode(c.type#, 1, decode(c.charsetform, 2, 'NVARCHAR2', 'VARCHAR2'),
                         2, decode(c.scale, null,
                                   decode(c.precision#, null, 'NUMBER', 'FLOAT'),
                                  'NUMBER'),
                         8, 'LONG',
                         9, decode(c.charsetform, 2, 'NCHAR VARYING', 'VARCHAR'),
                         12, 'DATE',
                         23, 'RAW', 24, 'LONG RAW',
                         69, 'ROWID',
                         96, decode(c.charsetform, 2, 'NCHAR', 'CHAR'),
                         100, 'BINARY_FLOAT',
                         101, 'BINARY_DOUBLE',
                         105, 'MLSLABEL',
                         106, 'MLSLABEL',
                         111, 'REF '||'"'||ut.name||'"'||'.'||'"'||ot.name||'"',
                         112, decode(c.charsetform, 2, 'NCLOB', 'CLOB'),
                         113, 'BLOB', 114, 'BFILE', 115, 'CFILE',
                         121, '"'||ut.name||'"'||'.'||'"'||ot.name||'"',
                         122, '"'||ut.name||'"'||'.'||'"'||ot.name||'"',
                         123, '"'||ut.name||'"'||'.'||'"'||ot.name||'"',
                         178, 'TIME(' ||c.scale|| ')',
                         179, 'TIME(' ||c.scale|| ')' || ' WITH TIME ZONE',
                         180, 'TIMESTAMP(' ||c.scale|| ')',
                         181, 'TIMESTAMP(' ||c.scale|| ')'||' WITH TIME ZONE',
                         231, 'TIMESTAMP(' ||c.scale|| ')'||' WITH LOCAL TIME ZONE',
                         182, 'INTERVAL YEAR(' ||c.precision#||') TO MONTH',
                         183, 'INTERVAL DAY(' ||c.precision#||') TO SECOND(' ||
                               c.scale || ')',
                         208, 'UROWID',
                         'UNDEFINED'),
         c.length, c.scale, c.precision#,
         decode(sign(c.null$),-1,'NOT NULL - DISABLED', 0, 'NULL',
        'NOT NULL'), c.default$,
         decode(c.charsetform, 1, 'CHAR_CS',
                               2, 'NCHAR_CS',
                               3, NLS_CHARSET_NAME(c.charsetid),
                               4, 'ARG:'||c.charsetid)
  from  sys.col$ c, sys.obj$ t, sys.coltype$ ac, sys.obj$ ot, sys.user$ ut
  where t.obj# = c.obj#
  and   t.type# in (2, 3, 4)
  and   t.owner# = userenv('SCHEMAID')
  and   bitand(c.property, 32) = 0 /* not hidden column */
  and   c.obj# = ac.obj#(+)
  and   c.intcol# = ac.intcol#(+)
  and   ac.toid = ot.oid$(+)
  and   ot.owner# = ut.user#(+);

CREATE OR REPLACE FORCE VIEW "COLUMN_PRIVILEGES"("GRANTEE",
select ue.name, u.name, o.name, c.name, ur.name,
    decode(substr(lpad(sum(power(10, privilege#*2) +
      decode(mod(option$,2), 1, power(10, privilege#*2 + 1), 0)), 26, '0'), 13, 2),
      '00', 'N', '01', 'Y', '11', 'G', 'N'),
    decode(substr(lpad(sum(power(10, privilege#*2) +
      decode(mod(option$,2), 1, power(10, privilege#*2 + 1), 0)), 26, '0'), 5, 2),
      '00', 'N', '01', 'Y', '11', 'G', 'N'),
    decode(substr(lpad(sum(power(10, privilege#*2) +
      decode(mod(option$,2), 1, power(10, privilege#*2 + 1), 0)), 26, '0'), 3, 2),
      '00', 'N', '01', 'Y', '11', 'G', 'N'), min(null)
from sys.objauth$ oa, sys.col$ c,sys.obj$ o, sys.user$ ue, sys.user$ ur,
     sys.user$ u
where oa.col# is not null
  and oa.obj# = c.obj#
  and oa.col# = c.col#
  and bitand(c.property, 32) = 0 /* not hidden column */
  and oa.obj# = o.obj#
  and oa.grantor# = ur.user#
  and oa.grantee# = ue.user#
  and u.user# = o.owner#
  and (oa.grantor# = userenv('SCHEMAID') or
       oa.grantee# in (select kzsrorol from x$kzsro) or
       o.owner# = userenv('SCHEMAID'))
  group by u.name, o.name, c.name, ur.name, ue.name;

CREATE OR REPLACE FORCE VIEW "DATABASE_COMPATIBLE_LEVEL"("VALUE",
select value,description
from v$parameter
where name = 'compatible';

CREATE OR REPLACE FORCE VIEW "DATABASE_EXPORT_OBJECTS"("OBJECT_PATH",
select OBJECT_PATH, COMMENTS, NAMED
    from dba_export_objects
    where het_type='DATABASE_EXPORT';

CREATE OR REPLACE FORCE VIEW "DATABASE_PROPERTIES"("PROPERTY_NAME",
select name, value$, comment$
  from props$;

CREATE OR REPLACE FORCE VIEW "DATABASE_SERVICES"("INSTANCE_NUMBER",
select i.instance_number instance_number,
         i.instance_name instance_name,
         s.name service_name
    from gv$active_services s, gv$instance i
    where s.inst_id = i.inst_id
  union all
  select i.instance_number instance_number,
         i.instance_name instance_name,
         '' service_name
    from gv$instance i;

CREATE OR REPLACE FORCE VIEW "DATAPUMP_DDL_TRANSFORM_PARAMS"("OBJECT_TYPE",
select  type, param
from    sys.metaxslparam$
where   model='ORACLE' and
        transform='DDL' and
        param!='DUMMY' and
        param not like 'PRS_%' and
        type!='*';

CREATE OR REPLACE FORCE VIEW "DATAPUMP_OBJECT_CONNECT"("OBJECT_TYPE",
select unique a.type, decode(bitand(a.properties,8+16+128),
                24,  'PROC',
                8,   'SOFT',
                16,  'HARD', 'NONE'),
       decode(bitand(a.properties,64), 64, 1, 0),
       decode(bitand(a.properties,128), 128, 1, 0)
from sys.metaview$ a
where bitand(a.properties,2+4)=0;

CREATE OR REPLACE FORCE VIEW "DATAPUMP_PATHMAP"("HET_TYPE",
select htype,name
 from sys.metapathmap$;

CREATE OR REPLACE FORCE VIEW "DATAPUMP_PATHS"("HET_TYPE",
select m.htype,m.name,m.seq#,
 (select m2.name from sys.metanametrans$ m2
  where m2.seq#=m.seq#
    and m2.htype=m.htype
    and bitand(m2.properties,1)=1)
 from sys.metanametrans$ m;

CREATE OR REPLACE FORCE VIEW "DATAPUMP_REMAP_OBJECTS"("PARAM",
select param,type
 from sys.metaxslparam$
 where model='ORACLE' and transform='MODIFY'
 and param like 'REMAP_%';

CREATE OR REPLACE FORCE VIEW "DATAPUMP_TABLE_DATA"("HET_TYPE",
select htype,name,seq#
 from sys.metanametrans$
 where properties!=0
 and name like '%/TABLE_DATA'
 and name not like '%INDEX%';

CREATE OR REPLACE FORCE VIEW "DBA_2PC_NEIGHBORS"("LOCAL_TRAN_ID",
select  local_tran_id, 'in', parent_db, db_user, interface, parent_dbid,
        session_id, rawtohex(branch_id)
from    sys.ps1$
union all
select  local_tran_id, 'out', dblink, owner_name, interface, dbid,
        session_id, to_char(sub_session_id)
from    sys.pss1$;

CREATE OR REPLACE FORCE VIEW "DBA_2PC_PENDING"("LOCAL_TRAN_ID",
select  local_tran_id,
        nvl(global_oracle_id, global_tran_fmt||'.'||global_foreign_id),
        state, decode(status,'D','yes','no'), heuristic_dflt, tran_comment,
        fail_time, heuristic_time, reco_time,
        top_os_user, top_os_terminal, top_os_host, top_db_user, global_commit#
from    sys.pending_trans$;

CREATE OR REPLACE FORCE VIEW "DBA_ADVISOR_ACTIONS"("OWNER",
select b.owner_name as owner,
             a.task_id as task_id,
             b.name as task_name,
             d.rec_id as rec_id,
             a.id as action_id,
             a.obj_id as object_id,
             c.command_name as command,
             a.command as command_id,
             a.flags as flags,
             a.attr1 as attr1,
             a.attr2 as attr2,
             a.attr3 as attr3,
             a.attr4 as attr4,
             a.attr5 as attr5,
             a.attr6 as attr6,
             a.num_attr1 as num_attr1,
             a.num_attr2 as num_attr2,
             a.num_attr3 as num_attr3,
             a.num_attr4 as num_attr4,
             a.num_attr5 as num_attr5,
             dbms_advisor.format_message_group(a.msg_id) as message
      from wri$_adv_actions a, wri$_adv_tasks b, x$keacmdn c,
           wri$_adv_rec_actions d
      where a.task_id = b.id
        and a.command = c.indx
        and d.task_id = a.task_id
        and d.act_id = a.id
        and bitand(b.property,6) = 4
        and ((b.advisor_id = 2 and bitand(a.flags,2048) = 0) or
             (b.advisor_id <> 2));

CREATE OR REPLACE FORCE VIEW "DBA_ADVISOR_COMMANDS"("COMMAND_ID",
select a.indx as command_id,
             a.command_name as command_name
      from x$keacmdn a;

CREATE OR REPLACE FORCE VIEW "DBA_ADVISOR_DEFINITIONS"("ADVISOR_ID",
select id as advisor_id,
             name as advisor_name,
             property as property
      from wri$_adv_definitions
      where id > 0;

CREATE OR REPLACE FORCE VIEW "DBA_ADVISOR_DEF_PARAMETERS"("ADVISOR_NAME",
select b.name as advisor_name,
             a.name as parameter_name,
             a.value as parameter_value,
             decode(a.datatype, 1, 'NUMBER',
                                2, 'STRING',
                                3, 'STRINGLIST',
                                4, 'TABLE',
                                5, 'TABLELIST',
                                'UNKNOWN')
                 as parameter_type,
             decode(bitand(a.flags,2), 0, 'Y', 'N') as is_default,
             decode(bitand(a.flags,4), 0, 'N', 'Y') as is_output,
             decode(bitand(a.flags,8), 0, 'N', 'Y') as is_modifiable_anytime
      from wri$_adv_def_parameters a, wri$_adv_definitions b
      where a.advisor_id = b.id
        and bitand(a.flags,1) = 0;

CREATE OR REPLACE FORCE VIEW "DBA_ADVISOR_DIRECTIVES"("OWNER",
select b.owner_name as owner,
             a.task_id as task_id,
             b.name as task_name,
             a.src_task_id as source_task_id,
             a.id as directive_id,
             a.obj_owner as rec_obj_owner,
             a.obj_name as rec_obj_name,
             a.rec_id as rec_id,
             a.rec_action_id as rec_action_id,
             c.command_name as command,
             a.attr1 as attr1,
             a.attr2 as attr2,
             a.attr3 as attr3,
             a.attr4 as attr4,
             a.attr5 as attr5
      from wri$_adv_directives a, wri$_adv_tasks b, x$keacmdn c
      where a.task_id = b.id
        and a.command = c.indx
        and bitand(b.property,6) = 4;

CREATE OR REPLACE FORCE VIEW "DBA_ADVISOR_FINDINGS"("OWNER",
select b.owner_name as owner,
            a.task_id as task_id,
            b.name as task_name,
            a.id as finding_id,
            decode (a.type, 1, 'PROBLEM',
                            2, 'SYMPTOM',
                            3, 'ERROR',
                            4, 'INFORMATION')  as type,
            a.parent as parent,
            a.obj_id as object_id,
            dbms_advisor.format_message_group(a.impact_msg_id) as impact_type,
            a.impact_val as impact,
            dbms_advisor.format_message_group(a.msg_id) as message,
            dbms_advisor.format_message_group(a.more_info_id) as more_info
    from wri$_adv_findings a, wri$_adv_tasks b
    where a.task_id = b.id
        and bitand(b.property,6) = 4;

CREATE OR REPLACE FORCE VIEW "DBA_ADVISOR_JOURNAL"("OWNER",
select b.owner_name as owner,
             a.task_id as task_id,
             b.name as task_name,
             a.seq_id as journal_entry_seq,
             decode(a.type, 1, 'INFORMATION',
                            2, 'WARNING',
                            3, 'ERROR',
                            4, 'FATAL',
                            5, 'DEBUG1',
                            6, 'DEBUG2',
                            7, 'DEBUG3',
                            8, 'DEBUG4',
                            9, 'DEBUG5') as journal_entry_type,
             dbms_advisor.format_message_group(a.msg_id) as journal_entry
      from wri$_adv_journal a, wri$_adv_tasks b
      where a.task_id = b.id
        and bitand(b.property,4) = 4;

CREATE OR REPLACE FORCE VIEW "DBA_ADVISOR_LOG"("OWNER",
select a.owner_name as owner,
         a.id as task_id,
         a.name as task_name,
         a.exec_start as execution_start,
         a.exec_end as execution_end,
         decode(a.status, 1, 'INITIAL',
                          2, 'EXECUTING',
                          3, 'COMPLETED',
                          4, 'INTERRUPTED',
                          5, 'CANCELLED',
                          6, 'FATAL ERROR') as status,
         dbms_advisor.format_message_group(a.status_msg_id) as status_message,
         a.pct_completion_time as pct_completion_time,
         a.progress_metric as progess_metric,
         a.metric_units as metric_units,
         a.activity_counter as activity_counter,
         a.rec_count as recommendation_count,
         dbms_advisor.format_message_group(a.error_msg#) as error_message
  from wri$_adv_tasks a
  where bitand(a.property,6) = 4;

CREATE OR REPLACE FORCE VIEW "DBA_ADVISOR_OBJECTS"("OWNER",
select b.owner_name as owner,
            a.id as object_id,
            d.object_type as type,
            a.type as type_id,
            a.task_id as task_id,
            b.name as task_name,
            a.attr1 as attr1,
            a.attr2 as attr2,
            a.attr3 as attr3,
            a.attr4 as attr4,
            a.attr5 as attr5
      from wri$_adv_objects a, wri$_adv_tasks b,x$keaobjt d
      where a.task_id = b.id
        and d.indx = a.type;

CREATE OR REPLACE FORCE VIEW "DBA_ADVISOR_OBJECT_TYPES"("OBJECT_TYPE_ID",
select a.indx as object_type_id,
             a.object_type as object_type
      from x$keaobjt a;

CREATE OR REPLACE FORCE VIEW "DBA_ADVISOR_PARAMETERS"("OWNER",
select b.owner_name as owner,
             a.task_id as task_id,
             b.name as task_name,
             a.name as parameter_name,
             a.value as parameter_value,
             decode(a.datatype, 1, 'NUMBER',
                                2, 'STRING',
                                3, 'STRINGLIST',
                                4, 'TABLE',
                                5, 'TABLELIST',
                                'UNKNOWN')
                 as parameter_type,
             decode(bitand(a.flags,2), 0, 'Y', 'N') as is_default,
             decode(bitand(a.flags,4), 0, 'N', 'Y') as is_output,
             decode(bitand(a.flags,8), 0, 'N', 'Y') as is_modifiable_anytime
      from wri$_adv_parameters a, wri$_adv_tasks b
      where a.task_id = b.id
        and bitand(b.property,4) = 4
        and bitand(a.flags,1) = 0;

CREATE OR REPLACE FORCE VIEW "DBA_ADVISOR_PARAMETERS_PROJ"("TASK_ID",
select a.task_id as task_id,
             a.name as parameter_name,
             a.value as parameter_value,
             decode(a.datatype, 1, 'NUMBER',
                                2, 'STRING',
                                3, 'STRINGLIST',
                                4, 'TABLE',
                                5, 'TABLELIST',
                                'UNKNOWN')
                 as parameter_type,
             decode(bitand(a.flags,2), 0, 'Y', 'N') as is_default,
             decode(bitand(a.flags,4), 0, 'N', 'Y') as is_output,
             decode(bitand(a.flags,8), 0, 'N', 'Y') as is_modifiable_anytime
      from wri$_adv_parameters a;

CREATE OR REPLACE FORCE VIEW "DBA_ADVISOR_RATIONALE"("OWNER",
select b.owner_name as owner,
             a.task_id as task_id,
             b.name as task_name,
             a.rec_id as rec_id,
             a.id as rationale_id,
             dbms_advisor.format_message_group(a.impact_msg_id) as impact_type,
             a.impact_val as impact,
             dbms_advisor.format_message_group(a.msg_id) as message,
             a.obj_id as object_id,
             a.type,
             a.attr1 as attr1,
             a.attr2 as attr2,
             a.attr3 as attr3,
             a.attr4 as attr4,
             a.attr5 as attr5
      from wri$_adv_rationale a, wri$_adv_tasks b
      where a.task_id = b.id
        and bitand(b.property,6) = 4;

CREATE OR REPLACE FORCE VIEW "DBA_ADVISOR_RECOMMENDATIONS"("OWNER",
select b.owner_name as owner,
            a.id as rec_id,
            a.task_id as task_id,
            b.name as task_name,
            a.finding_id as finding_id,
            a.type,
            a.rank as rank,
            a.parent_recs as parent_rec_ids,
            dbms_advisor.format_message_group(a.benefit_msg_id) as benefit_type,
            a.benefit_val as benefit,
            decode(annotation, 1, 'ACCEPT',
                               2, 'REJECT',
                               3, 'IGNORE',
                               4, 'IMPLEMENTED') as annotation_status
     from wri$_adv_recommendations a, wri$_adv_tasks b
     where a.task_id = b.id and
          bitand(b.property,6) = 4;

CREATE OR REPLACE FORCE VIEW "DBA_ADVISOR_SQLA_REC_SUM"("OWNER",
select max(b.owner_name) as owner,
             max(a.task_id) as task_id,
             max(b.name) as task_name,
             max(a.rec_id) as rec_id,
             count(*) as total_stmts,
             sum(a.pre_cost) as total_precost,
             sum(a.post_cost) as total_postcost
      from wri$_adv_sqla_stmts a, wri$_adv_tasks b
      where a.task_id = b.id
        and bitand(b.property,2) = 0
      group by a.task_id, a.rec_id;

CREATE OR REPLACE FORCE VIEW "DBA_ADVISOR_SQLA_WK_MAP"("OWNER",
select b.owner_name as owner,
             a.task_id as task_id,
             b.name as task_name,
             a.workload_id as workload_id,
             d.name as workload_name
      from wri$_adv_sqla_map a, wri$_adv_tasks b,wri$_adv_tasks d
      where a.task_id = b.id
        and d.id = a.workload_id;

CREATE OR REPLACE FORCE VIEW "DBA_ADVISOR_SQLA_WK_STMTS"("OWNER",
select a.owner_name as owner,
             c.task_id as task_id,
             a.name as task_name,
             b.workload_id as workload_id,
             e.name as workload_name,
             b.sql_id as sql_id,
             b.hash_value as hash_value,
             b.username as username,
             b.module as module,
             b.action as action,
             b.cpu_time as cpu_time,
             b.buffer_gets as buffer_gets,
             b.disk_reads as disk_reads,
             b.elapsed_time as elapsed_time,
             b.rows_processed as rows_processed,
             b.executions as executions,
             c.pre_cost as precost,
             c.post_cost as postcost,
             b.last_execution_date as last_execution_date,
             b.priority as priority,
             b.command_type as command_type,
             b.stat_period as stat_period,
             b.sql_text as sql_text,
             c.imp as importance,
             c.rec_id as rec_id
      from wri$_adv_tasks a, wri$_adv_sqlw_stmts b,
           wri$_adv_sqla_stmts c, wri$_adv_tasks e
      where a.id = c.task_id
        and b.workload_id = c.workload_id
        and e.id = b.workload_id
        and c.sql_id = b.sql_id
        and bitand(a.property,2) = 0;

CREATE OR REPLACE FORCE VIEW "DBA_ADVISOR_SQLW_COLVOL"("OWNER",
select c.owner_name as owner,
             b.workload_id as workload_id,
             c.name as workload_name,
             e.owner_name as table_owner,
             e.table_name as table_name,
             d.name as column_name,
             b.upd_freq as update_freq,
             b.upd_rows as updated_rows
      from wri$_adv_sqlw_colvol b, wri$_adv_tasks c, sys.col$ d,
           wri$_adv_sqlw_tabvol e
      where c.id = b.workload_id
        and d.col# = b.col#
        and e.table# = b.table#
        and bitand(c.property,2) = 0
        and c.advisor_id = 6;

CREATE OR REPLACE FORCE VIEW "DBA_ADVISOR_SQLW_JOURNAL"("OWNER",
select b.owner_name as owner,
             a.task_id as workload_id,
             b.name as workload_name,
             a.seq_id as journal_entry_seq,
             decode(a.type,1,'INFORMATIONAL',2,'WARNING',3,'ERROR',
                           4,'FATAL',5,'DEBUG1',6,'DEBUG2',7,'DEBUG3',
                           8,'DEBUG4',9,'DEBUG5') as journal_entry_type,
             dbms_advisor.format_message_group(a.msg_id) as journal_entry
      from wri$_adv_journal a, wri$_adv_tasks b
      where a.task_id = b.id
        and b.advisor_id = 6;

CREATE OR REPLACE FORCE VIEW "DBA_ADVISOR_SQLW_PARAMETERS"("OWNER",
select b.owner_name as owner,
             a.task_id as workload_id,
             b.name as workload_name,
             a.name as parameter_name,
             a.value as parameter_value,
             decode(a.datatype,1,'NUMBER',2,'STRING',3,'STRINGLIST',
                               4,'TABLE',5,'TABLELIST','UNKNOWN')
                 as parameter_type
      from wri$_adv_parameters a, wri$_adv_tasks b
      where a.task_id = b.id
        and b.advisor_id = 6
        and bitand(a.flags,1) = 0;

CREATE OR REPLACE FORCE VIEW "DBA_ADVISOR_SQLW_STMTS"("OWNER",
select c.owner_name as owner,
             b.workload_id as workload_id,
             c.name as workload_name,
             b.sql_id as sql_id,
             b.hash_value as hash_value,
             b.username as username,
             b.module as module,
             b.action as action,
             b.cpu_time as cpu_time,
             b.buffer_gets as buffer_gets,
             b.disk_reads as disk_reads,
             b.elapsed_time as elapsed_time,
             b.rows_processed as rows_processed,
             b.executions as executions,
             b.optimizer_cost as optimizer_cost,
             b.last_execution_date as last_execution_date,
             b.priority as priority,
             b.command_type as command_type,
             b.stat_period as stat_period,
             b.sql_text as sql_text,
             b.valid as valid
      from wri$_adv_sqlw_stmts b,wri$_adv_tasks c
      where b.workload_id = c.id
        and bitand(c.property,2) = 0
        and c.advisor_id = 6;

CREATE OR REPLACE FORCE VIEW "DBA_ADVISOR_SQLW_SUM"("OWNER",
select b.owner_name as owner,
             b.id as workload_id,
             b.name as workload_name,
             b.description as description,
             b.ctime as create_date,
             b.mtime as modify_date,
             a.num_select as num_select_stmt,
             a.num_update as num_update_stmt,
             a.num_delete as num_delete_stmt,
             a.num_insert as num_insert_stmt,
             a.num_merge as num_merge_stmt,
             b.source as source,
             b.how_created as how_created,
             a.data_source as data_source,
             decode(bitand(b.property,1),1,'TRUE','FALSE') as read_only
      from wri$_adv_sqlw_sum a, wri$_adv_tasks b
      where a.workload_id = b.id
        and bitand(b.property,2) = 0
        and b.advisor_id = 6;

CREATE OR REPLACE FORCE VIEW "DBA_ADVISOR_SQLW_TABLES"("OWNER",
select d.owner_name as owner,
             b.workload_id as workload_id,
             d.name as workload_name,
             b.sql_id as sql_id,
             b.table_owner  as table_owner,
             b.table_name as table_name
      from wri$_adv_sqlw_tables b, wri$_adv_tasks d
      where d.id = b.workload_id
        and bitand(d.property,2) = 0
        and d.advisor_id = 6;

CREATE OR REPLACE FORCE VIEW "DBA_ADVISOR_SQLW_TABVOL"("OWNER",
select c.owner_name as owner,
             b.workload_id as workload_id,
             c.name as workload_name,
             b.owner_name as table_owner,
             b.table_name as table_name,
             b.upd_freq as update_freq,
             b.ins_freq as insert_freq,
             b.del_freq as delete_freq,
             b.dir_freq as direct_load_freq,
             b.upd_rows as updated_rows,
             b.ins_rows as inserted_rows,
             b.del_rows as deleted_rows,
             b.dir_rows as direct_load_rows
      from wri$_adv_sqlw_tabvol b, wri$_adv_tasks c
      where c.id = b.workload_id
        and bitand(c.property,2) = 0
        and c.advisor_id = 6;

CREATE OR REPLACE FORCE VIEW "DBA_ADVISOR_SQLW_TEMPLATES"("OWNER",
select b.owner_name as owner,
             b.id as workload_id,
             b.name as workload_name,
             b.description as description,
             b.ctime as create_date,
             b.mtime as modify_date,
             b.source as source,
             decode(bitand(b.property,1),1,'TRUE','FALSE') as read_only
      from wri$_adv_sqlw_sum a, wri$_adv_tasks b
      where a.workload_id = b.id
        and bitand(b.property,2) = 2
        and b.advisor_id = 6;

CREATE OR REPLACE FORCE VIEW "DBA_ADVISOR_TASKS"("OWNER",
select a.owner_name as owner,
             a.id as task_id,
             a.name as task_name,
             a.description as description,
             a.advisor_name as advisor_name,
             a.ctime as created,
             a.mtime as last_modified,
             a.parent_id as parent_task_id,
             a.parent_rec_id as parent_rec_id,
             a.exec_start as execution_start,
             a.exec_end as execution_end,
             decode(a.status, 1, 'INITIAL',
                              2, 'EXECUTING',
                              3, 'COMPLETED',
                              4, 'INTERRUPTED',
                              5, 'CANCELLED',
                              6, 'FATAL ERROR') as status,
             dbms_advisor.format_message_group(a.status_msg_id) as status_message,
             a.pct_completion_time as pct_completion_time,
             a.progress_metric as progess_metric,
             a.metric_units as metric_units,
             a.activity_counter as activity_counter,
             a.rec_count as recommendation_count,
             dbms_advisor.format_message_group(a.error_msg#) as error_message,
             a.source as source,
             a.how_created as how_created,
             decode(bitand(a.property,1), 1, 'TRUE', 'FALSE') as read_only,
             a.advisor_id as advisor_id
      from wri$_adv_tasks a
      where bitand(a.property,6) = 4;

CREATE OR REPLACE FORCE VIEW "DBA_ADVISOR_TEMPLATES"("OWNER",
select a.owner_name as owner,
             a.id as task_id,
             a.name as task_name,
             a.description as description,
             a.advisor_name as advisor_name,
             a.ctime as created,
             a.mtime as last_modified,
             a.source as source,
             decode(bitand(a.property,1), 1, 'TRUE', 'FALSE') as read_only
      from wri$_adv_tasks a
      where bitand(a.property,6) = 6;

CREATE OR REPLACE FORCE VIEW "DBA_ADVISOR_USAGE"("ADVISOR_ID",
select a.advisor_id,
            a.last_exec_time,
            a.num_execs
     from sys.wri$_adv_usage a
     where a.advisor_id > 0 ;

CREATE OR REPLACE FORCE VIEW "DBA_ALERT_ARGUMENTS"("SEQUENCE_ID",
SELECT sequence_id,
            mid_keltsd AS reason_message_id,
            npm_keltsd AS reason_argument_count,
            reason_argument_1,
            reason_argument_2,
            reason_argument_3,
            reason_argument_4,
            reason_argument_5,
            amid_keltsd AS action_message_id,
            anpm_keltsd AS action_argument_count,
            action_argument_1,
            action_argument_2,
            action_argument_3,
            action_argument_4,
            action_argument_5
    FROM wri$_alert_outstanding, X$KELTSD
    WHERE reason_id = rid_keltsd;

CREATE OR REPLACE FORCE VIEW "DBA_ALERT_HISTORY"("SEQUENCE_ID",
select sequence_id,
            reason_id,
            owner,
            object_name,
            subobject_name,
            typnam_keltosd AS object_type,
            dbms_server_alert.expand_message(userenv('LANGUAGE'),
                                             mid_keltsd,
                                             reason_argument_1,
                                             reason_argument_2,
                                             reason_argument_3,
                                             reason_argument_4,
                                             reason_argument_5) AS reason,
            time_suggested,
            creation_time,
            dbms_server_alert.expand_message(userenv('LANGUAGE'),
                                             amid_keltsd,
                                             action_argument_1,
                                             action_argument_2,
                                             action_argument_3,
                                             action_argument_4,
                                             action_argument_5)
              AS suggested_action,
            advisor_name,
            metric_value,
            decode(message_level, 32, 'Notification', 'Warning')
              AS message_type,
            nam_keltgsd AS message_group,
            message_level,
            hosting_client_id,
            mdid_keltsd AS module_id,
            process_id,
            host_id,
            host_nw_addr,
            instance_name,
            instance_number,
            user_id,
            execution_context_id,
            error_instance_id,
            decode(resolution, 1, 'cleared', 'N/A') AS resolution
  FROM wri$_alert_history, X$KELTSD, X$KELTOSD, X$KELTGSD,
       dba_advisor_definitions
  WHERE reason_id = rid_keltsd
    AND otyp_keltsd = typid_keltosd
    AND grp_keltsd = id_keltgsd
    AND aid_keltsd = advisor_id(+);

CREATE OR REPLACE FORCE VIEW "DBA_ALL_TABLES"("OWNER",
select OWNER, TABLE_NAME, TABLESPACE_NAME, CLUSTER_NAME, IOT_NAME,
     PCT_FREE, PCT_USED,
     INI_TRANS, MAX_TRANS,
     INITIAL_EXTENT, NEXT_EXTENT,
     MIN_EXTENTS, MAX_EXTENTS, PCT_INCREASE,
     FREELISTS, FREELIST_GROUPS, LOGGING,
     BACKED_UP, NUM_ROWS, BLOCKS, EMPTY_BLOCKS,
     AVG_SPACE, CHAIN_CNT, AVG_ROW_LEN,
     AVG_SPACE_FREELIST_BLOCKS, NUM_FREELIST_BLOCKS,
     DEGREE, INSTANCES, CACHE, TABLE_LOCK,
     SAMPLE_SIZE, LAST_ANALYZED, PARTITIONED,
     IOT_TYPE, NULL, NULL, NULL, TEMPORARY, SECONDARY, NESTED,
     BUFFER_POOL, ROW_MOVEMENT,
     GLOBAL_STATS, USER_STATS, DURATION, SKIP_CORRUPT, MONITORING,
     CLUSTER_OWNER, DEPENDENCIES, COMPRESSION, DROPPED
from dba_tables
union all
select "OWNER",

CREATE OR REPLACE FORCE VIEW "DBA_ANALYZE_OBJECTS"("OWNER",
select u.name, o.name, decode(o.type#, 2, 'TABLE', 3, 'CLUSTER')
       from sys.user$ u, sys.obj$ o, sys.tab$ t
       where o.owner# = u.user#
       and   o.obj# = t.obj# (+)
       and   t.bobj# is null
       and   o.type# in (2,3)
       and   o.linkname is null;

CREATE OR REPLACE FORCE VIEW "DBA_APPLICATION_ROLES"("ROLE",
select u.name, schema, package  from
user$ u, approle$ a
where  u.user# = a.role#;

CREATE OR REPLACE FORCE VIEW "DBA_APPLY"("APPLY_NAME",
select ap.apply_name, ap.queue_name, ap.queue_owner,
       decode(bitand(ap.flags, 1), 1, 'YES',
                                   0, 'NO'),
       ap.ruleset_name, ap.ruleset_owner,
       u.name, ap.apply_dblink, ap.apply_tag, ap.ddl_handler,
       ap.precommit_handler, ap.message_handler,
       decode(ap.status, 1, 'DISABLED',
                         2, 'ENABLED',
                         4, 'ABORTED', 'UNKNOWN'),
       ap.spare1,
       ap.negative_ruleset_name, ap.negative_ruleset_owner,
       ap.status_change_time, ap.error_number, ap.error_message
  from "_DBA_APPLY" ap, sys.user$ u
 where  ap.apply_userid = u.user# (+);

CREATE OR REPLACE FORCE VIEW "DBA_APPLY_CONFLICT_COLUMNS"("OBJECT_OWNER",
select u.username, o.name, eh.method_name, eh.resolution_column,
       ac.column_name, NULL
  from sys.obj$ o, "_DBA_APPLY_CONF_HDLR_COLUMNS" ac,
       "_DBA_APPLY_ERROR_HANDLER" eh, dba_users u
 where o.obj# = ac.object_number
   and o.obj# = eh.object_number
   and ac.resolution_id = eh.resolution_id
   and u.user_id = o.owner#
   and o.remoteowner is NULL
union
select o.remoteowner, o.name, eh.method_name, eh.resolution_column,
       ac.column_name, o.linkname
  from sys.obj$ o, apply$_conf_hdlr_columns ac, apply$_error_handler eh
 where o.obj# = ac.object_number
   and o.obj# = eh.object_number
   and ac.resolution_id = eh.resolution_id
   and o.remoteowner is not NULL;

CREATE OR REPLACE FORCE VIEW "DBA_APPLY_DML_HANDLERS"("OBJECT_OWNER",
select sname, oname,
       decode(do.apply_operation, 0, 'DEFAULT',
                                  1, 'INSERT',
                                  2, 'UPDATE',
                                  3, 'DELETE',
                                  4, 'LOB_UPDATE',
                                  5, 'ASSEMBLE_LOBS', 'UNKNOWN'),
       do.user_apply_procedure,
       do.error_handler, o.linkname, do.apply_name
  from sys.obj$ o, apply$_dest_obj_ops do
 where do.object_number = o.obj# (+);

CREATE OR REPLACE FORCE VIEW "DBA_APPLY_ENQUEUE"("RULE_OWNER",
select r.rule_owner, r.rule_name, sys.anydata.AccessVarchar2(ctx.nvn_value)
from DBA_RULES r, table(r.rule_action_context.actx_list) ctx
where ctx.nvn_name = 'APPLY$_ENQUEUE';

CREATE OR REPLACE FORCE VIEW "DBA_APPLY_ERROR"("APPLY_NAME",
select p.apply_name, e.queue_name, e.queue_owner, e.local_transaction_id,
       e.source_database, e.source_transaction_id,
       e.source_commit_scn, e.message_number, e.error_number,
       e.error_message, e.recipient_id, e.recipient_name, e.message_count
  from "_DBA_APPLY_ERROR" e, sys.streams$_apply_process p
 where e.apply# = p.apply#(+);

CREATE OR REPLACE FORCE VIEW "DBA_APPLY_EXECUTE"("RULE_OWNER",
select r.rule_owner, r.rule_name,
  decode(sys.anydata.AccessVarchar2(ctx.nvn_value), 'NO', 'NO', NULL)
from DBA_RULES r, table(r.rule_action_context.actx_list) ctx
where ctx.nvn_name = 'APPLY$_EXECUTE';

CREATE OR REPLACE FORCE VIEW "DBA_APPLY_INSTANTIATED_GLOBAL"("SOURCE_DATABASE",
select source_db_name, inst_scn, dblink
  from "_DBA_APPLY_SOURCE_SCHEMA"
 where global_flag = 1;

CREATE OR REPLACE FORCE VIEW "DBA_APPLY_INSTANTIATED_OBJECTS"("SOURCE_DATABASE",
select source_db_name, owner, name,
       type, inst_scn, ignore_scn, dblink
  from "_DBA_APPLY_SOURCE_OBJ";

CREATE OR REPLACE FORCE VIEW "DBA_APPLY_INSTANTIATED_SCHEMAS"("SOURCE_DATABASE",
select source_db_name, name, inst_scn, dblink
  from "_DBA_APPLY_SOURCE_SCHEMA"
 where global_flag = 0;

CREATE OR REPLACE FORCE VIEW "DBA_APPLY_KEY_COLUMNS"("OBJECT_OWNER",
select sname, oname, cname, dblink
  from sys.streams$_key_columns;

CREATE OR REPLACE FORCE VIEW "DBA_APPLY_PARAMETERS"("APPLY_NAME",
select ap.apply_name, pp.name, pp.value,
       decode(pp.user_changed_flag, 1, 'YES', 'NO')
  from sys.streams$_process_params pp, sys.streams$_apply_process ap
 where pp.process_type = 1
   and pp.process# = ap.apply#
   and /* display internal parameters if the user changed them */
       (pp.internal_flag = 0
        or
        (pp.internal_flag = 1 and pp.user_changed_flag = 1)
       );

CREATE OR REPLACE FORCE VIEW "DBA_APPLY_PROGRESS"("APPLY_NAME",
select ap.apply_name, am.source_db_name, am.commit_scn, am.oldest_scn,
       apply_time, applied_message_create_time
  from streams$_apply_process ap, "_DBA_APPLY_MILESTONE" am
 where ap.apply# = am.apply#;

CREATE OR REPLACE FORCE VIEW "DBA_APPLY_TABLE_COLUMNS"("OBJECT_OWNER",
(select daoc.object_owner, daoc.object_name, daoc.column_name,
       decode(bitand(ac.property, 1), 1, 'NO', 0, 'YES'),
       decode(bitand(ac.property, 2), 2, 'NO', 0, 'YES'),
       daoc.apply_database_link
  from "_DBA_APPLY_TABLE_COLUMNS_H" daoc, "_DBA_APPLY_OBJECTS" ac
 where daoc.object_owner = ac.object_owner
   and daoc.object_name  = ac.object_name
union
select u.name, o.name, doc.column_name,
       decode(bitand(doc.flag, 1), 1, 'NO', 0, 'YES'),
       decode(bitand(doc.flag, 2), 2, 'NO', 0, 'YES'),
       null
  from sys.streams$_dest_obj_cols doc, sys.obj$ o, sys.user$ u
 where o.obj# = doc.object_number
   and o.owner# = u.user#
   and o.linkname is null
   and doc.dblink is null
   and o.remoteowner is null
union
select o.remoteowner, o.name, doc.column_name,
       decode(bitand(doc.flag, 1), 1, 'NO', 0, 'YES'),
       decode(bitand(doc.flag, 2), 2, 'NO', 0, 'YES'),
       doc.dblink
  from sys.streams$_dest_obj_cols doc, sys.obj$ o
 where o.obj# = doc.object_number
   and o.linkname = doc.dblink
   and o.remoteowner is not null);

CREATE OR REPLACE FORCE VIEW "DBA_AQ_AGENTS"("AGENT_NAME",
SELECT u.agent_name, decode(bitand(u.protocol, 1), 0, 'NO  ', 1, 'YES ') http_enabled, decode(bitand(u.protocol, 2), 0, 'NO  ', 2, 'YES ') smtp_enabled FROM SYSTEM.AQ$_Internet_Agents u;

CREATE OR REPLACE FORCE VIEW "DBA_AQ_AGENT_PRIVS"("AGENT_NAME",
(SELECT u.agent_name, t.db_username, decode(bitand(u.protocol, 1), 0, 'NO  ', 1, 'YES ') http_enabled, decode(bitand(u.protocol, 2), 0, 'NO  ', 2, 'YES ') smtp_enabled FROM SYSTEM.AQ$_Internet_Agent_Privs t RIGHT OUTER JOIN  SYSTEM.AQ$_Internet_Agents u ON t.agent_name = u.agent_name);

CREATE OR REPLACE FORCE VIEW "DBA_ASSOCIATIONS"("OBJECT_OWNER",
select u.name, o.name, c.name,
         decode(a.property, 1, 'COLUMN', 2, 'TYPE', 3, 'PACKAGE', 4,
                'FUNCTION', 5, 'INDEX', 6, 'INDEXTYPE', 'INVALID'),
         u1.name, o1.name,a.default_selectivity,
         a.default_cpu_cost, a.default_io_cost, a.default_net_cost,
         a.interface_version#
   from  sys.association$ a, sys.obj$ o, sys.user$ u,
         sys.obj$ o1, sys.user$ u1, sys.col$ c
   where a.obj#=o.obj# and o.owner#=u.user#
   AND   a.statstype#=o1.obj# (+) and o1.owner#=u1.user# (+)
   AND   a.obj# = c.obj#  (+)  and a.intcol# = c.intcol# (+);

CREATE OR REPLACE FORCE VIEW "DBA_ATTRIBUTE_TRANSFORMATIONS"("TRANSFORMATION_ID",
SELECT t.transformation_id, u.name, t.name,
       t.from_schema||'.'||t.from_type, t.to_schema||'.'||t.to_type,
       at.attribute_number,
       at.sql_expression
FROM transformations$ t, attribute_transformations$ at, sys.user$ u
WHERE  u.name = t.owner and t.transformation_id = at.transformation_id;

CREATE OR REPLACE FORCE VIEW "DBA_AUDIT_EXISTS"("OS_USERNAME",
select os_username, username, userhost, terminal, timestamp,
         owner, obj_name,
         action_name,
         new_owner,
         new_name,
         obj_privilege, sys_privilege, grantee,
         sessionid, entryid, statementid, returncode, client_id, session_cpu,
         extended_timestamp, proxy_sessionid, global_uid, instance_number,
         os_process, transactionid, scn, sql_bind, sql_text
  from dba_audit_trail
  where returncode in
  (942, 943, 959, 1418, 1432, 1434, 1435, 1534, 1917, 1918, 1919, 2019,
   2024, 2289,
   4042, 4043, 4080, 1, 951, 955, 957, 1430, 1433, 1452, 1471, 1535, 1543,
   1758, 1920, 1921, 1922, 2239, 2264, 2266, 2273, 2292, 2297, 2378, 2379,
   2382, 4081, 12006, 12325);

CREATE OR REPLACE FORCE VIEW "DBA_AUDIT_OBJECT"("OS_USERNAME",
select OS_USERNAME, USERNAME, USERHOST, TERMINAL, TIMESTAMP,
       OWNER, OBJ_NAME, ACTION_NAME, NEW_OWNER, NEW_NAME,
       SES_ACTIONS, COMMENT_TEXT, SESSIONID, ENTRYID, STATEMENTID,
       RETURNCODE, PRIV_USED, CLIENT_ID, SESSION_CPU,
       EXTENDED_TIMESTAMP, PROXY_SESSIONID, GLOBAL_UID, INSTANCE_NUMBER,
       OS_PROCESS, TRANSACTIONID, SCN, SQL_BIND, SQL_TEXT
from dba_audit_trail
where (action between 1 and 16)
   or (action between 19 and 29)
   or (action between 32 and 41)
   or (action = 43)
   or (action between 51 and 99)
   or (action = 103)
   or (action between 110 and 113)
   or (action between 116 and 121)
   or (action between 123 and 128)
   or (action between 160 and 162);

CREATE OR REPLACE FORCE VIEW "DBA_AUDIT_POLICIES"("OBJECT_SCHEMA",
select u.name, o.name, f.pname, f.ptxt, f.pcol, f.pfschma, f.ppname, f.pfname,
       decode(f.enable_flag, 0, 'NO', 1, 'YES', 'NO'),
       decode(bitand(f.stmt_type,1), 0, 'NO', 'YES'),
       decode(bitand(f.stmt_type,2), 0, 'NO', 'YES'),
       decode(bitand(f.stmt_type,4), 0, 'NO', 'YES'),
       decode(bitand(f.stmt_type,8), 0, 'NO', 'YES'),
       decode(bitand(f.stmt_type,64), 0, 'DB_EXTENDED', 'DB'),
       decode(bitand(f.stmt_type, 128), 0, 'ANY_COLUMNS', 'ALL_COLUMNS')
from user$ u, obj$ o, fga$ f
where u.user# = o.owner#
and f.obj# = o.obj#;

CREATE OR REPLACE FORCE VIEW "DBA_AUDIT_POLICY_COLUMNS"("OBJECT_SCHEMA",
select u.name, o.name, f.pname, c.name
from user$ u, obj$ o, fga$ f, fgacol$ fc, col$ c
where u.user# = o.owner#
 and  f.obj#  = o.obj#
 and  f.obj#  = fc.obj# and  f.pname = fc.pname
 and  c.obj#  = fc.obj# and  c.intcol#   = fc.intcol#;

CREATE OR REPLACE FORCE VIEW "DBA_AUDIT_SESSION"("OS_USERNAME",
select os_username,  username, userhost, terminal, timestamp, action_name,
       logoff_time, logoff_lread, logoff_pread, logoff_lwrite, logoff_dlock,
       sessionid, returncode, client_id, session_cpu, extended_timestamp,
       proxy_sessionid, global_uid, instance_number, os_process
from dba_audit_trail
where action between 100 and 102;

CREATE OR REPLACE FORCE VIEW "DBA_AUDIT_STATEMENT"("OS_USERNAME",
select OS_USERNAME, USERNAME, USERHOST, TERMINAL, TIMESTAMP,
       OWNER, OBJ_NAME, ACTION_NAME, NEW_NAME,
       OBJ_PRIVILEGE, SYS_PRIVILEGE, ADMIN_OPTION, GRANTEE, AUDIT_OPTION,
       SES_ACTIONS, COMMENT_TEXT,  SESSIONID, ENTRYID, STATEMENTID,
       RETURNCODE, PRIV_USED, CLIENT_ID, SESSION_CPU,
       EXTENDED_TIMESTAMP, PROXY_SESSIONID, GLOBAL_UID, INSTANCE_NUMBER,
       OS_PROCESS, TRANSACTIONID, SCN, SQL_BIND, SQL_TEXT
from dba_audit_trail
where action in (        17 /* GRANT OBJECT  */,
                         18 /* REVOKE OBJECT */,
                         30 /* AUDIT OBJECT */,
                         31 /* NOAUDIT OBJECT */,
                         49 /* ALTER SYSTEM */,
                        104 /* SYSTEM AUDIT */,
                        105 /* SYSTEM NOAUDIT */,
                        106 /* AUDIT DEFAULT */,
                        107 /* NOAUDIT DEFAULT */,
                        108 /* SYSTEM GRANT */,
                        109 /* SYSTEM REVOKE */,
                        114 /* GRANT ROLE */,
                        115 /* REVOKE ROLE */ );

CREATE OR REPLACE FORCE VIEW "DBA_AUDIT_TRAIL"("OS_USERNAME",
select spare1           /* OS_USERNAME */,
       userid           /* USERNAME */,
       userhost         /* USERHOST */,
       terminal         /* TERMINAL */,
       cast (           /* TIMESTAMP */
           (from_tz(ntimestamp#,'00:00') at local) as date),
       obj$creator      /* OWNER */,
       obj$name         /* OBJECT_NAME */,
       aud.action#      /* ACTION */,
       act.name         /* ACTION_NAME */,
       new$owner        /* NEW_OWNER */,
       new$name         /* NEW_NAME */,
       decode(aud.action#,
              108 /* grant  sys_priv */, null,
              109 /* revoke sys_priv */, null,
              114 /* grant  role */, null,
              115 /* revoke role */, null,
              auth$privileges)
                        /* OBJ_PRIVILEGE */,
       decode(aud.action#,
              108 /* grant  sys_priv */, spm.name,
              109 /* revoke sys_priv */, spm.name,
              null)
                        /* SYS_PRIVILEGE */,
       decode(aud.action#,
              108 /* grant  sys_priv */, substr(auth$privileges,1,1),
              109 /* revoke sys_priv */, substr(auth$privileges,1,1),
              114 /* grant  role */, substr(auth$privileges,1,1),
              115 /* revoke role */, substr(auth$privileges,1,1),
              null)
                        /* ADMIN_OPTION */,
       auth$grantee     /* GRANTEE */,
       decode(aud.action#,
              104 /* audit   */, aom.name,
              105 /* noaudit */, aom.name,
              null)
                        /* AUDIT_OPTION  */,
       ses$actions      /* SES_ACTIONS   */,
       logoff$time      /* LOGOFF_TIME   */,
       logoff$lread     /* LOGOFF_LREAD  */,
       logoff$pread     /* LOGOFF_PREAD  */,
       logoff$lwrite    /* LOGOFF_LWRITE */,
       decode(aud.action#,
              104 /* audit   */, null,
              105 /* noaudit */, null,
              108 /* grant  sys_priv */, null,
              109 /* revoke sys_priv */, null,
              114 /* grant  role */, null,
              115 /* revoke role */, null,
              aud.logoff$dead)
                         /* LOGOFF_DLOCK */,
       comment$text      /* COMMENT_TEXT */,
       sessionid         /* SESSIONID */,
       entryid           /* ENTRYID */,
       statement         /* STATEMENTID */,
       returncode        /* RETURNCODE */,
       spx.name          /* PRIVILEGE */,
       clientid          /* CLIENT_ID */,
       sessioncpu        /* SESSION_CPU */,
       from_tz(ntimestamp#,'00:00') at local,
                                   /* EXTENDED_TIMESTAMP */
       proxy$sid                      /* PROXY_SESSIONID */,
       user$guid                           /* GLOBAL_UID */,
       instance#                      /* INSTANCE_NUMBER */,
       process#                            /* OS_PROCESS */,
       xid                              /* TRANSACTIONID */,
       scn                                        /* SCN */,
       to_nchar(sqlbind)                     /* SQL_BIND */,
       to_nchar(sqltext)                     /* SQL_TEXT */
from sys.aud$ aud, system_privilege_map spm, system_privilege_map spx,
     STMT_AUDIT_OPTION_MAP aom, audit_actions act
where   aud.action#     = act.action    (+)
  and - aud.logoff$dead = spm.privilege (+)
  and   aud.logoff$dead = aom.option#   (+)
  and - aud.priv$used   = spx.privilege (+);

CREATE OR REPLACE FORCE VIEW "DBA_AWS"("OWNER",
SELECT u.name, a.awseq#, a.awname,
       max(decode(a.version, 0, '9.1', 1, '10.1', NULL)),
       count(unique(p.psnumber)), count(unique(p.psgen))
FROM aw$ a, ps$ p, user$ u
WHERE   a.owner#=u.user# and a.awseq#=p.awseq#
group by a.awseq#, a.awname, u.name;

CREATE OR REPLACE FORCE VIEW "DBA_AW_PS"("OWNER",
SELECT u.name, a.awseq#, a.awname, p.psnumber, count(unique(p.psgen)), max(p.maxpages)
FROM aw$ a, ps$ p, user$ u
WHERE   a.owner#=u.user# and a.awseq#=p.awseq#
group by a.awseq#, a.awname, u.name, p.psnumber;

CREATE OR REPLACE FORCE VIEW "DBA_BASE_TABLE_MVIEWS"("OWNER",
select s.mowner, s.master, s.snaptime, s.snapid
from sys.slog$ s;

CREATE OR REPLACE FORCE VIEW "DBA_BLOCKERS"("HOLDING_SESSION") AS 
select /*+ordered */ distinct s.ksusenum holding_session
  from v$session_wait w, x$ksqrs r, v$_lock l, x$ksuse s
 where w.wait_Time = 0
   and w.event like 'enq:%'
   and r.ksqrsid1 = w.p2
   and r.ksqrsid2 = w.p3
   and r.ksqrsidt = chr(bitand(p1,-16777216)/16777215)||
                   chr(bitand(p1,16711680)/65535)
   and l.block = 1
   and l.saddr = s.addr
   and l.raddr = r.addr
   and s.inst_id = userenv('Instance');

CREATE OR REPLACE FORCE VIEW "DBA_CACHEABLE_NONTABLE_OBJECTS"("OWNER",
SELECT u.username owner, u.username object_name, 'USER'
FROM   dba_users u
WHERE  u.username NOT IN ('SYS', 'SYSTEM', 'OUTLN', 'ORDSYS', 'CTXSYS',
                          'MDSYS', 'ORDPLUGINS', 'PUBLIC','DBSNMP',
                          'AURORA$JIS$UTILITY$', 'AURORA$ORB$UNAUTHENTICATED',
                          'LBACSYS', 'OSE$HTTP$ADMIN', 'ICPB', 'TRACESVR',
                          'XDB', 'PERFSTAT', 'RMAIL')
UNION ALL
SELECT o.owner, o.object_name, o.object_type
FROM   dba_objects o
WHERE  owner NOT IN ('SYS', 'SYSTEM', 'OUTLN', 'ORDSYS', 'CTXSYS',
                     'MDSYS', 'ORDPLUGINS', 'PUBLIC','DBSNMP',
                          'AURORA$JIS$UTILITY$', 'AURORA$ORB$UNAUTHENTICATED',
                          'LBACSYS', 'OSE$HTTP$ADMIN', 'ICPB', 'TRACESVR',
                          'XDB', 'PERFSTAT', 'RMAIL')
        AND
        ((object_type = 'VIEW'
            AND NOT EXISTS (SELECT 1 FROM dba_snapshots s
                            WHERE  s.owner = o.owner
                            AND    s.name  = o.object_name))
        OR
        (object_type IN ('TYPE', 'PACKAGE', 'PROCEDURE', 'FUNCTION', 'SEQUENCE')))
MINUS
SELECT r.sname, r.oname, r.type
 FROM  dba_repgenerated r;

CREATE OR REPLACE FORCE VIEW "DBA_CACHEABLE_OBJECTS"("OWNER",
SELECT "OWNER",
WHERE o.object_type != 'TYPE'
UNION ALL
SELECT t.owner, t.table_name object_name,
       decode(t.temporary, 'Y', 'TEMP TABLE', 'TABLE')
FROM   dba_cacheable_tables_base t
WHERE  /* Exclude the following tables
                  - * 0x00000001    typed tables
                  - * 0x00000002    having ADT cols
                  - * 0x00000004    having nested table columns
                  - * 0x00000008    having REF cols
                  - * 0x00000010    having array cols
                  - * 0x00002000    nested table
                  - * 0x01000000    user-defined REF columns
         */
     bitand(t.property,16785439) = 0;

CREATE OR REPLACE FORCE VIEW "DBA_CACHEABLE_OBJECTS_BASE"("OWNER",
SELECT OWNER, OBJECT_NAME, OBJECT_TYPE
FROM   dba_cacheable_nontable_objects
UNION ALL
SELECT t.owner, t.table_name object_name,
       decode(t.temporary, 'Y', 'TEMP TABLE', 'TABLE')
FROM   dba_cacheable_tables_base t;

CREATE OR REPLACE FORCE VIEW "DBA_CACHEABLE_TABLES"("OWNER",
SELECT t.owner, t.table_name
   FROM   dba_cacheable_tables_base t
   WHERE  temporary = 'N'
          /* Exclude the following tables
                  - * 0x00000001    typed tables
                  - * 0x00000002    having ADT cols
                  - * 0x00000004    having nested table columns
                  - * 0x00000008    having REF cols
                  - * 0x00000010    having array cols
                  - * 0x00002000    nested table
                  - * 0x01000000    user-defined REF columns
         */
    AND   bitand(t.property,16785439) = 0;

CREATE OR REPLACE FORCE VIEW "DBA_CACHEABLE_TABLES_BASE"("OWNER",
SELECT u.name, o.name, decode(bitand(o.flags, 2), 0, 'N', 2, 'Y', 'N'),
         tab.property
   FROM   sys.user$ u,
          sys.obj$ o,
          (SELECT t.obj#, t.property
           FROM   sys.tab$ t
           WHERE  /* Exclude the following tables
                   * 0x00008000    FILE columns
                   * 0x00020000    AQ table
                   * 0x08000000    sub-object
                   */
                  bitand(t.property,134381568) = 0
             AND
                  /* Exclude tables with LONG columns */
                  NOT EXISTS (SELECT 1 FROM   sys.col$ c
                              WHERE  t.obj# = c.obj#
                              AND  c.type# IN (8, 24) /* DTYLNG,DTYLBI */)) tab
   WHERE  o.owner# = u.user#
     AND  o.obj#   = tab.obj#
     AND
          /* Exclude SYS,SYSTEM,ORDSYS,CTXSYS,MDSYS,ORDPLUGINS,OUTLN tables */
          u.name NOT IN ('SYS', 'SYSTEM', 'ORDSYS', 'CTXSYS', 'MDSYS',
                         'ORDPLUGINS', 'OUTLN', 'DBSNMP','AURORA$JIS$UTILITY$',
                          'AURORA$ORB$UNAUTHENTICATED',
                          'LBACSYS', 'OSE$HTTP$ADMIN', 'ICPB', 'TRACESVR',
                          'XDB', 'PERFSTAT', 'RMAIL')
     AND
          /* Exclude snapshot and updatable snapshot log container tables */
          NOT EXISTS (SELECT 1 FROM sys.snap$ s
                      WHERE  s.sowner = u.name
                        AND ((s.tname = o.name) OR (s.uslog = o.name)))
     AND
          /* Exclude snapshot log container tables */
          NOT EXISTS (SELECT 1 from sys.mlog$ m
                      WHERE  m.mowner = u.name
                        AND  m.log    = o.name);

CREATE OR REPLACE FORCE VIEW "DBA_CAPTURE"("CAPTURE_NAME",
select cp.capture_name, cp.queue_name, cp.queue_owner, cp.ruleset_name,
       cp.ruleset_owner, u.name, cp.start_scn,
       decode(cp.status, 1, 'DISABLED',
                         2, 'ENABLED',
                         4, 'ABORTED', 'UNKNOWN'),
       cp.spare1, cp.spare2,
       decode(cp.use_dblink, 1, 'YES', 'NO'),
       cp.first_scn, cp.source_dbname, dl.source_dbid, dl.source_resetlogs_scn,
       dl.source_resetlogs_time, cp.logmnr_sid, cp.negative_ruleset_name,
       cp.negative_ruleset_owner, nvl(dl.checkpoint_scn, 0),
       least(nvl(cp.spare2,0), dbms_logrep_util.get_req_ckpt_scn(dl.id)),
       decode(bitand(cp.flags, 4), 4, 'IMPLICIT', 'EXPLICIT'),
       cp.status_change_time, cp.error_number,
       cp.error_message, cp.version,
       decode(bitand(cp.flags, 64), 64, 'DOWNSTREAM', 'LOCAL')
  from "_DBA_CAPTURE" cp,
       dba_logmnr_session dl,
       sys.user$ u
 where dl.id = cp.logmnr_sid
   and cp.capture_userid = u.user# (+);

CREATE OR REPLACE FORCE VIEW "DBA_CAPTURE_EXTRA_ATTRIBUTES"("CAPTURE_NAME",
select q.capture_name, a.name, substr(a.include, 1, 3),
       decode(bitand(a.flag, 1), 1, 'YES', 0, 'NO'),
       decode(bitand(a.flag, 2), 2, 'YES', 0, 'NO')
  from sys.streams$_extra_attrs a, sys.streams$_capture_process q
 where a.process# = q.capture#;

CREATE OR REPLACE FORCE VIEW "DBA_CAPTURE_PARAMETERS"("CAPTURE_NAME",
select q.capture_name, p.name, p.value,
       decode(p.user_changed_flag, 1, 'YES', 'NO')
  from sys.streams$_process_params p, sys.streams$_capture_process q
 where p.process_type = 2
   and p.process# = q.capture#
   and /* display internal parameters if the user changed them */
       (p.internal_flag = 0
        or
        (p.internal_flag = 1 and p.user_changed_flag = 1)
       );

CREATE OR REPLACE FORCE VIEW "DBA_CAPTURE_PREPARED_DATABASE"("TIMESTAMP") AS 
select timestamp from streams$_prepare_ddl
 where usrid is NULL
   and global_flag = 1;

CREATE OR REPLACE FORCE VIEW "DBA_CAPTURE_PREPARED_SCHEMAS"("SCHEMA_NAME",
select u.username, pd.timestamp
  from streams$_prepare_ddl pd, dba_users u
 where u.user_id = pd.usrid;

CREATE OR REPLACE FORCE VIEW "DBA_CAPTURE_PREPARED_TABLES"("TABLE_OWNER",
select u.name, o.name, co.ignore_scn, co.timestamp
  from obj$ o, user$ u, streams$_prepare_object co
  where o.obj# = co.obj# and o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "DBA_CATALOG"("OWNER",
select u.name, o.name,
       decode(o.type#, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 'UNDEFINED')
from sys.user$ u, sys.obj$ o
where o.owner# = u.user#
  and o.linkname is null
  and ((o.type# in (4, 5, 6))
       or
       (o.type# = 2     /* tables, excluding iot - overflow and nested tables */
        and
        not exists (select null
                      from sys.tab$ t
                     where t.obj# = o.obj#
                       and (bitand(t.property, 512) = 512 or
                            bitand(t.property, 8192) = 8192))));

CREATE OR REPLACE FORCE VIEW "DBA_CLUSTERS"("OWNER",
select u.name, o.name, ts.name,
          mod(c.pctfree$, 100),
          decode(bitand(ts.flags, 32), 32, to_number(NULL), c.pctused$),
          c.size$,c.initrans,c.maxtrans,
          s.iniexts * ts.blocksize,
          decode(bitand(ts.flags, 3), 1, to_number(NULL),
                               s.extsize * ts.blocksize),
          s.minexts, s.maxexts,
          decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                      s.extpct),
          decode(bitand(ts.flags, 32), 32, to_number(NULL),
            decode(s.lists, 0, 1, s.lists)),
          decode(bitand(ts.flags, 32), 32, to_number(NULL),
            decode(s.groups, 0, 1, s.groups)),
          c.avgchn, decode(c.hashkeys, 0, 'INDEX', 'HASH'),
          decode(c.hashkeys, 0, NULL,
                 decode(c.func, 0, 'COLUMN', 1, 'DEFAULT',
                                2, 'HASH EXPRESSION', 3, 'DEFAULT2', NULL)),
          c.hashkeys,
          lpad(decode(c.degree, 32767, 'DEFAULT', nvl(c.degree,1)),10),
          lpad(decode(c.instances, 32767, 'DEFAULT', nvl(c.instances,1)),10),
          lpad(decode(bitand(c.flags, 8), 8, 'Y', 'N'), 5),
          decode(s.cachehint, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL),
          lpad(decode(bitand(c.flags, 65536), 65536, 'Y', 'N'), 5),
          decode(bitand(c.flags, 8388608), 8388608, 'ENABLED', 'DISABLED')
from sys.user$ u, sys.ts$ ts, sys.seg$ s, sys.clu$ c, sys.obj$ o
where o.owner# = u.user#
  and o.obj# = c.obj#
  and c.ts# = ts.ts#
  and c.ts# = s.ts#
  and c.file# = s.file#
  and c.block# = s.block#;

CREATE OR REPLACE FORCE VIEW "DBA_CLUSTER_HASH_EXPRESSIONS"("OWNER",
select us.name, o.name, c.condition
from sys.cdef$ c, sys.user$ us, sys.obj$ o
where c.type# = 8
and c.obj#   = o.obj#
and us.user# = o.owner#;

CREATE OR REPLACE FORCE VIEW "DBA_CLU_COLUMNS"("OWNER",
select u.name, oc.name, cc.name, ot.name,
       decode(bitand(tc.property, 1), 1, ac.name, tc.name)
from sys.user$ u, sys.obj$ oc, sys.col$ cc, sys.obj$ ot, sys.col$ tc,
     sys.tab$ t, sys.attrcol$ ac
where oc.owner#  = u.user#
  and oc.obj#    = cc.obj#
  and t.bobj#    = oc.obj#
  and t.obj#     = tc.obj#
  and tc.segcol# = cc.segcol#
  and t.obj#     = ot.obj#
  and oc.type#   = 3
  and tc.obj#    = ac.obj#(+)
  and tc.intcol# = ac.intcol#(+);

CREATE OR REPLACE FORCE VIEW "DBA_CL_DIR_INSTANCE_ACTIONS"("JOB_NAME",
select job_name, alert_name,
         decode(job_type,
                0, 'START',
                1, 'STOP') job_type,
         database_name, instance_name,
         node_name, priority, submit_time, start_time, end_time,
         decode(status,
                0, 'SCHEDULED',
                1, 'WAITING',
                2, 'COMPLETED',
                3, 'FAILED',
                4, 'ABORTED') status,
         error_message
  from sys.dir$resonate_operations;

CREATE OR REPLACE FORCE VIEW "DBA_COLL_TYPES"("OWNER",
select u.name, o.name, co.name, c.upper_bound,
       decode(bitand(c.properties, 32768), 32768, 'REF',
              decode(bitand(c.properties, 16384), 16384, 'POINTER')),
       nvl2(c.synobj#, (select u.name from user$ u, obj$ o
            where o.owner#=u.user# and o.obj#=c.synobj#),
            decode(bitand(et.properties, 64), 64, null, eu.name)),
       nvl2(c.synobj#, (select o.name from obj$ o where o.obj#=c.synobj#),
            decode(et.typecode,
                   52, decode(c.charsetform, 2, 'NVARCHAR2', eo.name),
                   53, decode(c.charsetform, 2, 'NCHAR', eo.name),
                   54, decode(c.charsetform, 2, 'NCHAR VARYING', eo.name),
                   61, decode(c.charsetform, 2, 'NCLOB', eo.name),
                   eo.name)),
       c.length, c.precision, c.scale,
       decode(c.charsetform, 1, 'CHAR_CS',
                             2, 'NCHAR_CS',
                             3, NLS_CHARSET_NAME(c.charsetid),
                             4, 'ARG:'||c.charsetid),
       decode(bitand(c.properties, 131072), 131072, 'FIXED',
              decode(bitand(c.properties, 262144), 262144, 'VARYING')),
       decode(bitand(c.properties, 65536), 65536, 'NO', 'YES')
from sys.user$ u, sys.obj$ o, sys.collection$ c, sys.obj$ co,
     sys.obj$ eo, sys.user$ eu, sys.type$ et
where o.owner# = u.user#
  and o.oid$ = c.toid
  and o.subname IS NULL -- only the most recent version
  and o.type# <> 10 -- must not be invalid
  and c.coll_toid = co.oid$
  and c.elem_toid = eo.oid$
  and eo.owner# = eu.user#
  and c.elem_toid = et.tvoid;

CREATE OR REPLACE FORCE VIEW "DBA_COL_COMMENTS"("OWNER",
select u.name, o.name, c.name, co.comment$
from sys.obj$ o, sys.col$ c, sys.user$ u, sys.com$ co
where o.owner# = u.user#
  and o.type# in (2, 4)
  and o.obj# = c.obj#
  and c.obj# = co.obj#(+)
  and c.intcol# = co.col#(+)
  and bitand(c.property, 32) = 0 /* not hidden column */;

CREATE OR REPLACE FORCE VIEW "DBA_COL_PRIVS"("GRANTEE",
select ue.name, u.name, o.name, c.name, ur.name, tpm.name,
       decode(mod(oa.option$,2), 1, 'YES', 'NO')
from sys.objauth$ oa, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue,
     sys.col$ c, table_privilege_map tpm
where oa.obj# = o.obj#
  and oa.grantor# = ur.user#
  and oa.grantee# = ue.user#
  and oa.obj# = c.obj#
  and oa.col# = c.col#
  and bitand(c.property, 32) = 0 /* not hidden column */
  and oa.col# is not null
  and oa.privilege# = tpm.privilege
  and u.user# = o.owner#;

CREATE OR REPLACE FORCE VIEW "DBA_COMMON_AUDIT_TRAIL"("AUDIT_TYPE",
select 'Standard Audit', SESSIONID,
    PROXY_SESSIONID, STATEMENTID, ENTRYID, EXTENDED_TIMESTAMP, GLOBAL_UID,
    USERNAME, CLIENT_ID, Null, OS_USERNAME, USERHOST, OS_PROCESS, TERMINAL,
    INSTANCE_NUMBER, OWNER, OBJ_NAME, Null, NEW_OWNER,
    NEW_NAME, ACTION, ACTION_NAME, AUDIT_OPTION, TRANSACTIONID, RETURNCODE,
    SCN, COMMENT_TEXT, SQL_BIND, SQL_TEXT,
    OBJ_PRIVILEGE, SYS_PRIVILEGE, ADMIN_OPTION, GRANTEE, PRIV_USED,
    SES_ACTIONS, LOGOFF_TIME, LOGOFF_LREAD, LOGOFF_PREAD, LOGOFF_LWRITE,
    LOGOFF_DLOCK, SESSION_CPU
  from DBA_AUDIT_TRAIL
UNION ALL
select 'Fine Grained Audit', SESSION_ID,
    PROXY_SESSIONID, STATEMENTID, ENTRYID, EXTENDED_TIMESTAMP, GLOBAL_UID,
    DB_USER, CLIENT_ID, EXT_NAME, OS_USER, USERHOST, OS_PROCESS, Null,
    INSTANCE_NUMBER, OBJECT_SCHEMA, OBJECT_NAME, POLICY_NAME, Null,
    Null, Null, STATEMENT_TYPE, Null, TRANSACTIONID, Null,
    SCN, COMMENT$TEXT, SQL_BIND, SQL_TEXT,
    Null, Null, Null, Null, Null,
    Null, Null, Null, Null, Null,
    Null, Null
  from DBA_FGA_AUDIT_TRAIL;

CREATE OR REPLACE FORCE VIEW "DBA_CONSTRAINTS"("OWNER",
select ou.name, oc.name,
       decode(c.type#, 1, 'C', 2, 'P', 3, 'U',
              4, 'R', 5, 'V', 6, 'O', 7,'C', '?'),
       o.name, c.condition, ru.name, rc.name,
       decode(c.type#, 4,
              decode(c.refact, 1, 'CASCADE', 2, 'SET NULL', 'NO ACTION'),
              NULL),
       decode(c.type#, 5, 'ENABLED',
              decode(c.enabled, NULL, 'DISABLED', 'ENABLED')),
       decode(bitand(c.defer, 1), 1, 'DEFERRABLE', 'NOT DEFERRABLE'),
       decode(bitand(c.defer, 2), 2, 'DEFERRED', 'IMMEDIATE'),
       decode(bitand(c.defer, 4), 4, 'VALIDATED', 'NOT VALIDATED'),
       decode(bitand(c.defer, 8), 8, 'GENERATED NAME', 'USER NAME'),
       decode(bitand(c.defer,16),16, 'BAD', null),
       decode(bitand(c.defer,32),32, 'RELY', null),
       c.mtime,
       decode(c.type#, 2, ui.name, 3, ui.name, null),
       decode(c.type#, 2, oi.name, 3, oi.name, null),
       decode(bitand(c.defer, 256), 256,
              decode(c.type#, 4,
                     case when (bitand(c.defer, 128) = 128
                                or o.status in (3, 5)
                                or ro.status in (3, 5)) then 'INVALID'
                          else null end,
                     case when (bitand(c.defer, 128) = 128
                                or o.status in (3, 5)) then 'INVALID'
                          else null end
                    ),
              null),
       decode(bitand(c.defer, 256), 256, 'DEPEND ON VIEW', null)
from sys.con$ oc, sys.con$ rc, sys.user$ ou, sys.user$ ru, sys.obj$ ro,
     sys.obj$ o, sys.cdef$ c, sys.obj$ oi, sys.user$ ui
where oc.owner# = ou.user#
  and oc.con# = c.con#
  and c.obj# = o.obj#
  and c.type# != 8        /* don't include hash expressions */
  and c.type# != 12       /* don't include log groups */
  and c.rcon# = rc.con#(+)
  and c.enabled = oi.obj#(+)
  and oi.owner# = ui.user#(+)
  and rc.owner# = ru.user#(+)
  and c.robj# = ro.obj#(+);

CREATE OR REPLACE FORCE VIEW "DBA_CONS_COLUMNS"("OWNER",
select u.name, c.name, o.name,
       decode(ac.name, null, col.name, ac.name), cc.pos#
from sys.user$ u, sys.con$ c, sys.col$ col, sys.ccol$ cc, sys.cdef$ cd,
     sys.obj$ o, sys.attrcol$ ac
where c.owner# = u.user#
  and c.con# = cd.con#
  and cd.type# != 12       /* don't include log groups */
  and cd.con# = cc.con#
  and cc.obj# = col.obj#
  and cc.intcol# = col.intcol#
  and cc.obj# = o.obj#
  and col.obj# = ac.obj#(+)
  and col.intcol# = ac.intcol#(+);

CREATE OR REPLACE FORCE VIEW "DBA_CONS_OBJ_COLUMNS"("OWNER",
select uc.name, oc.name, c.name, ut.name, ot.name,
       lpad(decode(bitand(sc.flags, 2), 2, 'Y', 'N'), 15)
from sys.user$ uc, sys.obj$ oc, sys.col$ c, sys.user$ ut, sys.obj$ ot,
     sys.subcoltype$ sc
where oc.owner# = uc.user#
  and bitand(sc.flags, 1) = 1      /* Type is specified in the IS OF clause */
  and oc.obj#=sc.obj#
  and oc.obj#=c.obj#
  and c.intcol#=sc.intcol#
  and sc.toid=ot.oid$
  and ot.owner#=ut.user#
  and bitand(c.property,32768) != 32768                /* not unused column */
  and not exists (select null                  /* Doesn't exist in attrcol$ */
                  from sys.attrcol$ ac
                  where ac.intcol#=sc.intcol#
                        and ac.obj#=sc.obj#)
union all
select uc.name, oc.name, ac.name, ut.name, ot.name,
       lpad(decode(bitand(sc.flags, 2), 2, 'Y', 'N'), 15)
from sys.user$ uc, sys.obj$ oc, sys.col$ c, sys.user$ ut, sys.obj$ ot,
     sys.subcoltype$ sc, sys.attrcol$ ac
where oc.owner# = uc.user#
  and bitand(sc.flags, 1) = 1      /* Type is specified in the IS OF clause */
  and oc.obj#=sc.obj#
  and oc.obj#=c.obj#
  and oc.obj#=ac.obj#
  and c.intcol#=sc.intcol#
  and ac.intcol#=sc.intcol#
  and sc.toid=ot.oid$
  and ot.owner#=ut.user#
  and bitand(c.property,32768) != 32768                /* not unused column */;

CREATE OR REPLACE FORCE VIEW "DBA_CONTEXT"("NAMESPACE",
select o.name, c.schema, c.package,
DECODE( c.flags,0,'ACCESSED LOCALLY',1,'INITIALIZED EXTERNALLY',2,'ACCESSED GLOBALLY',4,'INITIALIZED GLOBALLY')
from  context$ c, obj$ o
where c.obj# = o.obj#
and o.type# = 44;

CREATE OR REPLACE FORCE VIEW "DBA_DATAPUMP_JOBS"("OWNER_NAME",
SELECT  j.owner_name, j.job_name, j.operation, j.job_mode, j.state,
                j.workers,
                NVL((SELECT    COUNT(*)
                     FROM      SYS.GV$DATAPUMP_SESSION s
                     WHERE     j.job_id = s.job_id
                     GROUP BY  s.job_id), 0)
        FROM    SYS.GV$DATAPUMP_JOB j
      UNION ALL                               /* Not Running - Master Tables */
        SELECT u.name, o.name,
               SUBSTR (c.comment$, 24, 30), SUBSTR (c.comment$, 55, 30),
               'NOT RUNNING', 0, 0
        FROM sys.obj$ o, sys.user$ u, sys.com$ c
        WHERE SUBSTR (c.comment$, 1, 22) = 'Data Pump Master Table' AND
              RTRIM (SUBSTR (c.comment$, 24, 30)) IN
                ('EXPORT','ESTIMATE','IMPORT','SQL_FILE','NETWORK') AND
              RTRIM (SUBSTR (c.comment$, 55, 30)) IN
                ('FULL','SCHEMA','TABLE','TABLESPACE','TRANSPORTABLE') AND
              o.obj# = c.obj# AND
              o.type# = 2 AND
              u.user# = o.owner# AND
              NOT EXISTS (SELECT 1
                          FROM   SYS.GV$DATAPUMP_JOB
                          WHERE  owner_name = u.name AND
                                 job_name = o.name);

CREATE OR REPLACE FORCE VIEW "DBA_DATAPUMP_SESSIONS"("OWNER_NAME",
SELECT  j.owner_name, j.job_name, s.saddr
        FROM    SYS.GV$DATAPUMP_JOB j, SYS.GV$DATAPUMP_SESSION s
        WHERE   j.job_id = s.job_id;

CREATE OR REPLACE FORCE VIEW "DBA_DATA_FILES"("FILE_NAME",
select v.name, f.file#, ts.name,
       ts.blocksize * f.blocks, f.blocks,
       decode(f.status$, 1, 'INVALID', 2, 'AVAILABLE', 'UNDEFINED'),
       f.relfile#, decode(f.inc, 0, 'NO', 'YES'),
       ts.blocksize * f.maxextend, f.maxextend, f.inc,
       ts.blocksize * (f.blocks - 1), f.blocks - 1
from sys.file$ f, sys.ts$ ts, sys.v$dbfile v
where v.file# = f.file#
  and f.spare1 is NULL
  and f.ts# = ts.ts#
union all
select
       v.name,f.file#, ts.name,
       decode(hc.ktfbhccval, 0, ts.blocksize * hc.ktfbhcsz, NULL),
       decode(hc.ktfbhccval, 0, hc.ktfbhcsz, NULL),
       decode(f.status$, 1, 'INVALID', 2, 'AVAILABLE', 'UNDEFINED'),
       f.relfile#,
       decode(hc.ktfbhccval, 0, decode(hc.ktfbhcinc, 0, 'NO', 'YES'), NULL),
       decode(hc.ktfbhccval, 0, ts.blocksize * hc.ktfbhcmaxsz, NULL),
       decode(hc.ktfbhccval, 0, hc.ktfbhcmaxsz, NULL),
       decode(hc.ktfbhccval, 0, hc.ktfbhcinc, NULL),
       decode(hc.ktfbhccval, 0, hc.ktfbhcusz * ts.blocksize, NULL),
       decode(hc.ktfbhccval, 0, hc.ktfbhcusz, NULL)
from sys.v$dbfile v, sys.file$ f, sys.x$ktfbhc hc, sys.ts$ ts
where v.file# = f.file#
  and f.spare1 is NOT NULL
  and v.file# = hc.ktfbhcafno
  and hc.ktfbhctsn = ts.ts#;

CREATE OR REPLACE FORCE VIEW "DBA_DB_DIR_ESCALATE_ACTIONS"("ESCALATION_NAME",
select escalation_id escalation_name, alert_seq_id,
         escalation escalation_type,
         instance_name, submit_time, start_time, end_time,
         decode(status,
                0, 'SCHEDULED',
                1, 'WAITING',
                2, 'COMPLETED',
                3, 'FAILED',
                4, 'ABORTED',
                5, 'RETRYING',
                6, 'CLEARED') status,
         retry_count, retry_time,
         error_message
  from sys.dir$escalate_operations;

CREATE OR REPLACE FORCE VIEW "DBA_DB_DIR_QUIESCE_ACTIONS"("JOB_NAME",
select job_name, alert_seq_id alert_sequence_id,
         decode(job_type,
                0, 'INITIATE',
                1, 'UNQUIESCE') job_type,
         instance_name, submit_time, start_time, end_time,
         decode(status,
                0, 'SCHEDULED',
                1, 'WAITING',
                2, 'COMPLETED',
                3, 'FAILED',
                4, 'ABORTED') status,
         error_message
  from sys.dir$quiesce_operations;

CREATE OR REPLACE FORCE VIEW "DBA_DB_DIR_SERVICE_ACTIONS"("JOB_NAME",
select job_name, alert_seq_id alert_sequence_id,
         decode(job_type,
                0, 'START',
                1, 'STOP') job_type,
         service_name, instance_name,
         submit_time, start_time, end_time,
         decode(status,
                0, 'SCHEDULED',
                1, 'WAITING',
                2, 'COMPLETED',
                3, 'FAILED',
                4, 'ABORTED') status,
         error_message
  from sys.dir$service_operations;

CREATE OR REPLACE FORCE VIEW "DBA_DB_DIR_SESSION_ACTIONS"("JOB_NAME",
select job_name, alert_seq_id alert_sequence_id, service_name,
         source_instance, dest_instance destination_instance, submit_time,
         start_time, end_time, session_count sessions_requested,
         actual_count sessions_migrated,
         decode(status,
                0, 'SCHEDULED',
                1, 'WAITING',
                2, 'COMPLETED',
                3, 'FAILED',
                4, 'ABORTED') status,
         error_message
  from sys.dir$migrate_operations;

CREATE OR REPLACE FORCE VIEW "DBA_DB_LINKS"("OWNER",
select u.name, l.name, l.userid, l.host, l.ctime
from sys.link$ l, sys.user$ u
where l.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "DBA_DDL_LOCKS"("SESSION_ID",
select  s.sid session_id,
          substr(ob.kglnaown,1,30) owner,
          substr(ob.kglnaobj,1,30) name,
    decode(ob.kglhdnsp, 0, 'Cursor', 1, 'Table/Procedure/Type', 2, 'Body',
           3, 'Trigger', 4, 'Index', 5, 'Cluster', 13, 'Java Source',
             14, 'Java Resource', 32, 'Java Data', to_char(ob.kglhdnsp)) type,
    decode(lk.kgllkmod, 0, 'None', 1, 'Null', 2, 'Share', 3, 'Exclusive',
	   'Unknown') mode_held,
    decode(lk.kgllkreq,  0, 'None', 1, 'Null', 2, 'Share', 3, 'Exclusive',
	   'Unknown') mode_requested
   from v$session s, x$kglob ob, x$kgllk lk
   where lk.kgllkhdl = ob.kglhdadr
   and   lk.kgllkuse = s.saddr
   and   ob.kglhdnsp != 0;

CREATE OR REPLACE FORCE VIEW "DBA_DEPENDENCIES"("OWNER",
select u.name, o.name,
       decode(o.type#, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 7, 'PROCEDURE',
                      8, 'FUNCTION', 9, 'PACKAGE', 10, 'NON-EXISTENT',
                      11, 'PACKAGE BODY', 12, 'TRIGGER',
                      13, 'TYPE', 14, 'TYPE BODY', 22, 'LIBRARY',
                      28, 'JAVA SOURCE', 29, 'JAVA CLASS',
                      32, 'INDEXTYPE', 33, 'OPERATOR',
                      42, 'MATERIALIZED VIEW', 43, 'DIMENSION',
                      46, 'RULE SET', 55, 'XML SCHEMA', 56, 'JAVA DATA',
                      59, 'RULE', 62, 'EVALUATION CONTXT',
                      'UNDEFINED'),
       decode(po.linkname, null, pu.name, po.remoteowner), po.name,
       decode(po.type#, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 7, 'PROCEDURE',
                      8, 'FUNCTION', 9, 'PACKAGE', 10, 'NON-EXISTENT',
                      11, 'PACKAGE BODY', 12, 'TRIGGER',
                      13, 'TYPE', 14, 'TYPE BODY', 22, 'LIBRARY',
                      28, 'JAVA SOURCE', 29, 'JAVA CLASS',
                      32, 'INDEXTYPE', 33, 'OPERATOR',
                      42, 'MATERIALIZED VIEW', 43, 'DIMENSION',
                      46, 'RULE SET', 55, 'XML SCHEMA', 56, 'JAVA DATA',
                      59, 'RULE', 62, 'EVALUATION CONTXT',
                      'UNDEFINED'),
       po.linkname,
       decode(bitand(d.property, 3), 2, 'REF', 'HARD')
from sys.obj$ o, sys.disk_and_fixed_objects po, sys.dependency$ d, sys.user$ u,
  sys.user$ pu
where o.obj# = d.d_obj#
  and o.owner# = u.user#
  and po.obj# = d.p_obj#
  and po.owner# = pu.user#;

CREATE OR REPLACE FORCE VIEW "DBA_DIMENSIONS"("OWNER",
select u.name, o.name,
       decode(o.status, 5, 'Y', 'N'),
       decode(o.status, 1, 'VALID', 5, 'NEEDS_COMPILE', 'ERROR'),
       1                  /* Metadata revision number */
from sys.dim$ d, sys.obj$ o, sys.user$ u
where o.owner# = u.user#
  and o.obj# = d.obj#;

CREATE OR REPLACE FORCE VIEW "DBA_DIM_ATTRIBUTES"("OWNER",
select u.name, o.name, da.attname, dl.levelname, c.name, 'N'
from sys.dimattr$ da, sys.obj$ o, sys.user$ u, sys.dimlevel$ dl, sys.col$ c
where da.dimobj# = o.obj#
  and o.owner# = u.user#
  and da.dimobj# = dl.dimobj#
  and da.levelid# = dl.levelid#
  and da.detailobj# = c.obj#
  and da.col# = c.intcol#;

CREATE OR REPLACE FORCE VIEW "DBA_DIM_CHILD_OF"("OWNER",
select u.name, o.name, h.hiername, chl.pos#,
       cdl.levelname,
       decode(phl.joinkeyid#, 0, NULL, phl.joinkeyid#),
       pdl.levelname
from sys.obj$ o, sys.user$ u, sys.hier$ h,
     sys.hierlevel$ phl, sys.hierlevel$ chl,
     sys.dimlevel$ pdl,  sys.dimlevel$ cdl
where phl.dimobj# = o.obj#
  and o.owner# = u.user#
  and phl.dimobj# = h.dimobj#
  and phl.hierid# = h.hierid#
  and phl.dimobj# = pdl.dimobj#
  and phl.levelid# = pdl.levelid#
  and phl.dimobj# = chl.dimobj#
  and phl.hierid# = chl.hierid#
  and phl.pos# = chl.pos# + 1
  and chl.dimobj# = cdl.dimobj#
  and chl.levelid# = cdl.levelid#;

CREATE OR REPLACE FORCE VIEW "DBA_DIM_HIERARCHIES"("OWNER",
select u.name, o.name, h.hiername
from sys.hier$ h, sys.obj$ o, sys.user$ u
where h.dimobj# = o.obj#
  and o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "DBA_DIM_JOIN_KEY"("OWNER",
select u.name, o.name, djk.joinkeyid#, dl.levelname,
       djk.keypos#, h.hiername, c.name
from sys.dimjoinkey$ djk, sys.obj$ o, sys.user$ u,
     sys.dimlevel$ dl, sys.hier$ h, sys.col$ c
where djk.dimobj# = o.obj#
  and o.owner# = u.user#
  and djk.dimobj# = dl.dimobj#
  and djk.levelid# = dl.levelid#
  and djk.dimobj# = h.dimobj#
  and djk.hierid# = h.hierid#
  and djk.detailobj# = c.obj#
  and djk.col# = c.intcol#;

CREATE OR REPLACE FORCE VIEW "DBA_DIM_LEVELS"("OWNER",
select u.name, o.name, dl.levelname,
       temp.num_col,
       u1.name, o1.name
from (select dlk.dimobj#, dlk.levelid#, dlk.detailobj#,
             COUNT(*) as num_col
      from sys.dimlevelkey$ dlk
      group by dlk.dimobj#, dlk.levelid#, dlk.detailobj#) temp,
      sys.dimlevel$ dl, sys.obj$ o, sys.user$ u,
      sys.obj$ o1, sys.user$ u1
where dl.dimobj# = o.obj#   and
      o.owner# = u.user#    and
      dl.dimobj# = temp.dimobj# and
      dl.levelid# = temp.levelid# and
      temp.detailobj# = o1.obj# and
      o1.owner# = u1.user#;

CREATE OR REPLACE FORCE VIEW "DBA_DIM_LEVEL_KEY"("OWNER",
select u.name, o.name, dl.levelname, dlk.keypos#, c.name
from sys.dimlevelkey$ dlk, sys.obj$ o, sys.user$ u, sys.dimlevel$ dl,
     sys.col$ c
where dlk.dimobj# = o.obj#
  and o.owner# = u.user#
  and dlk.dimobj# = dl.dimobj#
  and dlk.levelid# = dl.levelid#
  and dlk.detailobj# = c.obj#
  and dlk.col# = c.intcol#;

CREATE OR REPLACE FORCE VIEW "DBA_DIRECTORIES"("OWNER",
select u.name, o.name, d.os_path
from sys.user$ u, sys.obj$ o, sys.dir$ d
where u.user# = o.owner#
  and o.obj# = d.obj#;

CREATE OR REPLACE FORCE VIEW "DBA_DIR_DATABASE_ATTRIBUTES"("DATABASE_NAME",
select database_name, attribute_name, attribute_value
  from sys.dir$database_attributes;

CREATE OR REPLACE FORCE VIEW "DBA_DIR_VICTIM_POLICY"("USER_NAME",
select user_name, policy_function_name from sys.dir$victim_policy;

CREATE OR REPLACE FORCE VIEW "DBA_DML_LOCKS"("SESSION_ID",
select
	sid session_id,
        u.name owner,
        o.name,
	decode(lmode,
		0, 'None',           /* Mon Lock equivalent */
		1, 'Null',           /* N */
		2, 'Row-S (SS)',     /* L */
		3, 'Row-X (SX)',     /* R */
		4, 'Share',          /* S */
		5, 'S/Row-X (SSX)',  /* C */
		6, 'Exclusive',      /* X */
		'Invalid') mode_held,
         decode(request,
		0, 'None',           /* Mon Lock equivalent */
		1, 'Null',           /* N */
		2, 'Row-S (SS)',     /* L */
		3, 'Row-X (SX)',     /* R */
		4, 'Share',          /* S */
		5, 'S/Row-X (SSX)',  /* C */
		6, 'Exclusive',      /* X */
		'Invalid') mode_requested,
	 l.ctime last_convert,
	 decode(block,
	        0, 'Not Blocking',  /* Not blocking any other processes */
		1, 'Blocking',      /* This lock blocks other processes */
		2, 'Global',        /* This lock is global, so we can't tell */
		to_char(block)) blocking_others
      from (select l.laddr addr, l.kaddr kaddr,  /* 1040651: Defn for v$lock */
                   s.ksusenum sid, r.ksqrsidt type, r.ksqrsid1 id1,
                   r.ksqrsid2 id2, l.lmode lmode, l.request request,
                   l.ctime ctime, l.block block
              from v$_lock l, x$ksuse s, x$ksqrs r
              where l.saddr = s.addr and l.raddr = r.addr and
                    s.inst_id = USERENV('Instance')) l, obj$ o, user$ u
      where l.id1 = o.obj#
      and   o.owner# = u.user#
      and   l.type = 'TM';

CREATE OR REPLACE FORCE VIEW "DBA_DMT_FREE_SPACE"("TABLESPACE_ID",
select  ts#, file#, block#, length
from    fet$;

CREATE OR REPLACE FORCE VIEW "DBA_DMT_USED_EXTENTS"("SEGMENT_FILEID",
select  u.segfile#, u.segblock#, u.ts#,
        u.ext#, u.file#, u.block#, u.length
from    sys.uet$ u
where   not exists (select * from sys.recyclebin$ rb
                    where u.ts# = rb.ts#
                      and u.segfile# = rb.file#
                      and u.segblock# = rb.block#);

CREATE OR REPLACE FORCE VIEW "DBA_ENABLED_AGGREGATIONS"("AGGREGATION_TYPE",
select decode(trace_type, 1, 'CLIENT_ID', 3, 'SERVICE',
                 4, 'SERVICE_MODULE', 5, 'SERVICE_MODULE_ACTION', 'UNDEFINED'),
                 primary_id, qualifier_id1, qualifier_id2
  from WRI$_AGGREGATION_ENABLED;

CREATE OR REPLACE FORCE VIEW "DBA_ENABLED_TRACES"("TRACE_TYPE",
select decode(trace_type, 1, 'CLIENT_ID', 3, 'SERVICE',
                 4, 'SERVICE_MODULE', 5, 'SERVICE_MODULE_ACTION', 'UNDEFINED'),
                 primary_id, qualifier_id1, qualifier_id2,
                 decode(bitand(flags,8), 8, 'TRUE', 'FALSE'),
                 decode(bitand(flags,4), 4, 'TRUE', 'FALSE'),
                 instance_name
  from WRI$_TRACING_ENABLED;

CREATE OR REPLACE FORCE VIEW "DBA_ERRORS"("OWNER",
select u.name, o.name,
decode(o.type#, 4, 'VIEW', 7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE',
               11, 'PACKAGE BODY', 12, 'TRIGGER', 13, 'TYPE', 14, 'TYPE BODY',
               22, 'LIBRARY', 28, 'JAVA SOURCE', 29, 'JAVA CLASS',
               43, 'DIMENSION', 'UNDEFINED'),
  e.sequence#, e.line, e.position#, e.text,
  decode(e.property, 0,'ERROR', 1, 'WARNING', 'UNDEFINED'), e.error#
from sys.obj$ o, sys.error$ e, sys.user$ u
where o.obj# = e.obj#
  and o.owner# = u.user#
  and o.type# in (4, 7, 8, 9, 11, 12, 13, 14, 22, 28, 29, 43);

CREATE OR REPLACE FORCE VIEW "DBA_EVALUATION_CONTEXTS"("EVALUATION_CONTEXT_OWNER",
SELECT /*+ all_rows */
       u.name, o.name, ec.eval_func, ec.ec_comment
FROM   rule_ec$ ec, obj$ o, user$ u
WHERE  ec.obj# = o.obj# and o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "DBA_EVALUATION_CONTEXT_TABLES"("EVALUATION_CONTEXT_OWNER",
SELECT /*+ all_rows */
       u.name, o.name, ect.tab_alias, ect.tab_name
FROM   rec_tab$ ect, obj$ o, user$ u
WHERE  ect.ec_obj# = o.obj# and o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "DBA_EVALUATION_CONTEXT_VARS"("EVALUATION_CONTEXT_OWNER",
SELECT /*+ all_rows */
       u.name, o.name, ecv.var_name, ecv.var_type, ecv.var_val_func,
       ecv.var_mthd_func
FROM   rec_var$ ecv, obj$ o, user$ u
WHERE  ecv.ec_obj# = o.obj# and o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "DBA_EXPORT_OBJECTS"("HET_TYPE",
select a.htype,a.name,a.descrip,
 (select 'Y' from dual
  where exists (select 1 from sys.metafilter$ f
                 where f.filter='NAME' and f.type=a.name))
 from sys.metanametrans$ a
 where a.descrip is not null order by a.htype,a.name;

CREATE OR REPLACE FORCE VIEW "DBA_EXP_FILES"("EXP_VERSION",
select o.expid, decode(o.exptype, 'X', 'COMPLETE', 'C', 'CUMULATIVE',
                                  'I', 'INCREMENTAL', 'UNDEFINED'),
       o.expfile, o.expuser, o.expdate
from sys.incfil o;

CREATE OR REPLACE FORCE VIEW "DBA_EXP_OBJECTS"("OWNER",
select u.name, o.name,
       decode(o.type#, 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 7, 'PROCEDURE',
                      8, 'FUNCTION', 9, 'PACKAGE', 11, 'PACKAGE BODY',
                      12, 'TRIGGER', 13, 'TYPE', 14, 'TYPE BODY',
                      22, 'LIBRARY', 28, 'JAVA SOURCE', 29, 'JAVA CLASS',
                      30, 'JAVA RESOURCE', 'UNDEFINED'),
       o.ctime, o.itime, o.expid
from sys.incexp o, sys.user$ u
where o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "DBA_EXP_VERSION"("EXP_VERSION") AS 
select o.expid
from sys.incvid o;

CREATE OR REPLACE FORCE VIEW "DBA_EXTENTS"("OWNER",
select ds.owner, ds.segment_name, ds.partition_name, ds.segment_type,
       ds.tablespace_name,
       e.ext#, f.file#, e.block#, e.length * ds.blocksize, e.length, e.file#
from sys.uet$ e, sys.sys_dba_segs ds, sys.file$ f
where e.segfile# = ds.relative_fno
  and e.segblock# = ds.header_block
  and e.ts# = ds.tablespace_id
  and e.ts# = f.ts#
  and e.file# = f.relfile#
  and bitand(NVL(ds.segment_flags,0), 1) = 0
  and bitand(NVL(ds.segment_flags,0), 65536) = 0
union all
select /*+ ordered use_nl(e) use_nl(f) */
       ds.owner, ds.segment_name, ds.partition_name, ds.segment_type,
       ds.tablespace_name,
       e.ktfbueextno, f.file#, e.ktfbuebno,
       e.ktfbueblks * ds.blocksize, e.ktfbueblks, e.ktfbuefno
from sys.sys_dba_segs ds, sys.x$ktfbue e, sys.file$ f
where e.ktfbuesegfno = ds.relative_fno
  and e.ktfbuesegbno = ds.header_block
  and e.ktfbuesegtsn = ds.tablespace_id
  and e.ktfbuesegtsn = f.ts#
  and e.ktfbuefno = f.relfile#
  and bitand(NVL(ds.segment_flags, 0), 1) = 1
  and bitand(NVL(ds.segment_flags,0), 65536) = 0;

CREATE OR REPLACE FORCE VIEW "DBA_EXTERNAL_LOCATIONS"("OWNER",
select u.name, o.name, xl.name, 'SYS', nvl(xl.dir, xt.default_dir)
from sys.external_location$ xl, sys.user$ u, sys.obj$ o, sys.external_tab$ xt
where o.owner# = u.user#
  and o.obj# = xl.obj#
  and o.obj# = xt.obj#;

CREATE OR REPLACE FORCE VIEW "DBA_EXTERNAL_TABLES"("OWNER",
select u.name, o.name, 'SYS', xt.type$, 'SYS', xt.default_dir,
       decode(xt.reject_limit, 2147483647, 'UNLIMITED', xt.reject_limit),
       decode(xt.par_type, 1, 'BLOB', 2, 'CLOB',       'UNKNOWN'),
       decode(xt.par_type, 1, NULL,   2, xt.param_clob, NULL),
       decode(xt.property, 2, 'REFERENCED', 1, 'ALL',     'UNKNOWN')
from sys.external_tab$ xt, sys.obj$ o, sys.user$ u
where o.owner# = u.user#
  and o.obj# = xt.obj#;

CREATE OR REPLACE FORCE VIEW "DBA_FEATURE_USAGE_STATISTICS"("DBID",
select samp.dbid, fu.name, samp.version, detected_usages, total_samples,
  decode(to_char(last_usage_date, 'MM/DD/YYYY, HH:MI:SS'),
         NULL, 'FALSE',
         to_char(last_sample_date, 'MM/DD/YYYY, HH:MI:SS'), 'TRUE',
         'FALSE')
  currently_used, first_usage_date, last_usage_date, aux_count,
  feature_info, last_sample_date, last_sample_period,
  sample_interval, mt.description
 from wri$_dbu_usage_sample samp, wri$_dbu_feature_usage fu,
      wri$_dbu_feature_metadata mt
 where
  samp.dbid    = fu.dbid and
  samp.version = fu.version and
  fu.name      = mt.name and
  fu.name not like '_DBFUS_TEST%' and   /* filter out test features */
  bitand(mt.usg_det_method, 4) != 4     /* filter out disabled features */;

CREATE OR REPLACE FORCE VIEW "DBA_FGA_AUDIT_TRAIL"("SESSION_ID",
select
      sessionid,
      CAST (
        (FROM_TZ(ntimestamp#,'00:00') AT LOCAL) AS DATE
      ),
      dbuid, osuid, oshst, clientid, extid,
      obj$schema, obj$name, policyname, scn, to_nchar(lsqltext),
      to_nchar(lsqlbind), comment$text,
      DECODE(stmt_type, 1, 'SELECT', 2, 'INSERT', 4, 'UPDATE', 8, 'DELETE',
             'INVALID'),
      FROM_TZ(ntimestamp#,'00:00') AT LOCAL,
      proxy$sid, user$guid, instance#, process#,
      xid, statement, entryid
from sys.fga_log$;

CREATE OR REPLACE FORCE VIEW "DBA_FREE_SPACE"("TABLESPACE_NAME",
select ts.name, fi.file#, f.block#,
       f.length * ts.blocksize, f.length, f.file#
from sys.ts$ ts, sys.fet$ f, sys.file$ fi
where ts.ts# = f.ts#
  and f.ts# = fi.ts#
  and f.file# = fi.relfile#
  and ts.bitmapped = 0
union all
select /*+ ordered use_nl(f) use_nl(fi) */
       ts.name, fi.file#, f.ktfbfebno,
       f.ktfbfeblks * ts.blocksize, f.ktfbfeblks, f.ktfbfefno
from sys.ts$ ts, sys.x$ktfbfe f, sys.file$ fi
where ts.ts# = f.ktfbfetsn
  and f.ktfbfetsn = fi.ts#
  and f.ktfbfefno = fi.relfile#
  and ts.bitmapped <> 0 and ts.online$ in (1,4) and ts.contents$ = 0
union all
select /*+ ordered use_nl(u) use_nl(fi) */
       ts.name, fi.file#, u.ktfbuebno,
       u.ktfbueblks * ts.blocksize, u.ktfbueblks, u.ktfbuefno
from sys.recyclebin$ rb, sys.ts$ ts, sys.x$ktfbue u, sys.file$ fi
where ts.ts# = rb.ts#
  and rb.ts# = fi.ts#
  and rb.file# = fi.relfile#
  and u.ktfbuesegtsn = rb.ts#
  and u.ktfbuesegfno = rb.file#
  and u.ktfbuesegbno = rb.block#
  and ts.bitmapped <> 0 and ts.online$ in (1,4) and ts.contents$ = 0
union all
select ts.name, fi.file#, u.block#,
       u.length * ts.blocksize, u.length, u.file#
from sys.ts$ ts, sys.uet$ u, sys.file$ fi, sys.recyclebin$ rb
where ts.ts# = u.ts#
  and u.ts# = fi.ts#
  and u.segfile# = fi.relfile#
  and u.ts# = rb.ts#
  and u.segfile# = rb.file#
  and u.segblock# = rb.block#
  and ts.bitmapped = 0;

CREATE OR REPLACE FORCE VIEW "DBA_FREE_SPACE_COALESCED"("TABLESPACE_NAME",
select name,total_extents, extents_coalesced,
       extents_coalesced/total_extents*100,total_blocks*c.blocksize,
       blocks_coalesced*c.blocksize, total_blocks, blocks_coalesced,
       blocks_coalesced/total_blocks*100
from DBA_FREE_SPACE_COALESCED_TMP1 a, DBA_FREE_SPACE_COALESCED_TMP2 b,
      sys.ts$ c
where a.ts#=b.ts# and a.ts#=c.ts#
union all
select name, total_extents, total_extents, 100, total_blocks*c.blocksize,
       total_blocks*c.blocksize, total_blocks, total_blocks, 100
from DBA_FREE_SPACE_COALESCED_TMP3 b, sys.ts$ c
where b.ts# = c.ts#;

CREATE OR REPLACE FORCE VIEW "DBA_FREE_SPACE_COALESCED_TMP1"("TS#",
select ts#, count(*) extents_coalesced, sum(length) blocks_coalesced
from sys.fet$ a
where not exists (
  select * from sys.fet$ b
  where b.ts#=a.ts# and
        b.file#=a.file# and
        a.block#=b.block#+b.length)
group by ts#;

CREATE OR REPLACE FORCE VIEW "DBA_FREE_SPACE_COALESCED_TMP2"("TS#",
select ts#, count(*), sum(length)
    from sys.fet$
  group by ts#;

CREATE OR REPLACE FORCE VIEW "DBA_FREE_SPACE_COALESCED_TMP3"("TS#",
select ktfbfetsn, count(*), sum(ktfbfeblks)
    from sys.x$ktfbfe
  group by ktfbfetsn;

CREATE OR REPLACE FORCE VIEW "DBA_GLOBAL_CONTEXT"("NAMESPACE",
select o.name, c.schema,c.package
from  context$ c, obj$ o
where c.obj# = o.obj#
and o.type# = 44
and c.flags= 2;

CREATE OR REPLACE FORCE VIEW "DBA_HIGH_WATER_MARK_STATISTICS"("DBID",
select dbid, hwm.name, version, highwater, last_value, description
 from wri$_dbu_high_water_mark hwm, wri$_dbu_hwm_metadata mt
 where hwm.name = mt.name and
       hwm.name not like '_HWM_TEST%' and             /* filter out test hwm */
       bitand(mt.method, 4) != 4                  /* filter out disabled hwm */;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_ACTIVE_SESS_HISTORY"("SNAP_ID",
select ash.snap_id, ash.dbid, ash.instance_number,
       sample_id, sample_time,
       session_id, session_serial#, user_id,
       sql_id, sql_child_number, sql_plan_hash_value,
       service_hash, session_type, sql_opcode, qc_session_id,
       qc_instance_id, current_obj#, current_file#, current_block#,
       seq#, event_id, p1, p2, p3, wait_time, time_waited, program,
       module, action, client_id
from WRM$_SNAPSHOT sn, WRH$_ACTIVE_SESSION_HISTORY ash
where      ash.snap_id          = sn.snap_id
      and  ash.dbid             = sn.dbid
      and  ash.instance_number  = sn.instance_number
      and  sn.status            = 0
      and  sn.bl_moved          = 0
union all
select ash.snap_id, ash.dbid, ash.instance_number,
       sample_id, sample_time,
       session_id, session_serial#, user_id,
       sql_id, sql_child_number, sql_plan_hash_value,
       service_hash, session_type, sql_opcode, qc_session_id,
       qc_instance_id, current_obj#, current_file#, current_block#,
       seq#, event_id, p1, p2, p3, wait_time, time_waited, program,
       module, action, client_id
from WRM$_SNAPSHOT sn, WRH$_ACTIVE_SESSION_HISTORY_BL ash
where      ash.snap_id          = sn.snap_id
      and  ash.dbid             = sn.dbid
      and  ash.instance_number  = sn.instance_number
      and  sn.status            = 0
      and  sn.bl_moved          = 1;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_BASELINE"("DBID",
select t1.dbid, t1.baseline_id,
       max(t1.baseline_name)     baseline_name,
       max(t1.start_snap_id)     start_snap_id,
       max(t1.start_snap_time)   start_snap_time,
       t1.end_snap_id            end_snap_id,
       max(s2.end_interval_time) end_snap_time
from
  (select bl.dbid, bl.baseline_id, max(bl.baseline_name) baseline_name,
          bl.start_snap_id, min(s1.end_interval_time) start_snap_time,
          max(bl.end_snap_id) end_snap_id
     from WRM$_BASELINE bl, WRM$_SNAPSHOT s1
    where bl.dbid = s1.dbid
      and bl.start_snap_id = s1.snap_id
    group by bl.dbid, baseline_id, start_snap_id) t1,
  WRM$_SNAPSHOT s2
where
  t1.dbid          = s2.dbid and
  t1.end_snap_id   = s2.snap_id
group by t1.dbid, baseline_id, end_snap_id;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_BG_EVENT_SUMMARY"("SNAP_ID",
select e.snap_id, e.dbid, e.instance_number,
       e.event_id, en.event_name, en.wait_class_id, en.wait_class,
       total_waits, total_timeouts, time_waited_micro
from WRM$_SNAPSHOT sn, WRH$_BG_EVENT_SUMMARY e, DBA_HIST_EVENT_NAME en
where     sn.snap_id         = e.snap_id
      and sn.dbid            = e.dbid
      and sn.instance_number = e.instance_number
      and sn.status          = 0
      and e.event_id         = en.event_id
      and e.dbid             = en.dbid;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_BUFFER_POOL_STAT"("SNAP_ID",
select bp.snap_id, bp.dbid, bp.instance_number,
       id, name, block_size, set_msize,
       cnum_repl, cnum_write, cnum_set, buf_got, sum_write, sum_scan,
       free_buffer_wait, write_complete_wait, buffer_busy_wait,
       free_buffer_inspected, dirty_buffers_inspected,
       db_block_change, db_block_gets, consistent_gets,
       physical_reads, physical_writes
  from WRM$_SNAPSHOT sn, WRH$_BUFFER_POOL_STATISTICS bp
  where     sn.snap_id         = bp.snap_id
        and sn.dbid            = bp.dbid
        and sn.instance_number = bp.instance_number
        and sn.status          = 0;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_CLASS_CACHE_TRANSFER"("SNAP_ID",
select cct.snap_id, cct.dbid, cct.instance_number,
       class, cr_transfer, current_transfer,
       x_2_null, x_2_null_forced_write, x_2_null_forced_stale,
       x_2_s,    x_2_s_forced_write,
       s_2_null, s_2_null_forced_stale,
       null_2_x, s_2_x, null_2_s
  from wrm$_snapshot sn, WRH$_CLASS_CACHE_TRANSFER cct
  where     sn.snap_id         = cct.snap_id
        and sn.dbid            = cct.dbid
        and sn.instance_number = cct.instance_number
        and sn.status          = 0
        and sn.bl_moved        = 0
union all
select cct.snap_id, cct.dbid, cct.instance_number,
       class, cr_transfer, current_transfer,
       x_2_null, x_2_null_forced_write, x_2_null_forced_stale,
       x_2_s,    x_2_s_forced_write,
       s_2_null, s_2_null_forced_stale,
       null_2_x, s_2_x, null_2_s
  from wrm$_snapshot sn, WRH$_CLASS_CACHE_TRANSFER_BL cct
  where     sn.snap_id         = cct.snap_id
        and sn.dbid            = cct.dbid
        and sn.instance_number = cct.instance_number
        and sn.status          = 0
        and sn.bl_moved        = 1;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_CR_BLOCK_SERVER"("SNAP_ID",
select crb.snap_id, crb.dbid, crb.instance_number,
       cr_requests, current_requests,
       data_requests, undo_requests, tx_requests,
       current_results, private_results, zero_results,
       disk_read_results, fail_results,
       fairness_down_converts, fairness_clears, free_gc_elements,
       flushes, flushes_queued, flush_queue_full, flush_max_time,
       light_works, errors
  from wrm$_snapshot sn, WRH$_CR_BLOCK_SERVER crb
  where     sn.snap_id         = crb.snap_id
        and sn.dbid            = crb.dbid
        and sn.instance_number = crb.instance_number
        and sn.status          = 0;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_CURRENT_BLOCK_SERVER"("SNAP_ID",
select cub.snap_id, cub.dbid, cub.instance_number,
       pin1,   pin10,   pin100,   pin1000,   pin10000,
       flush1, flush10, flush100, flush1000, flush10000,
       write1, write10, write100, write1000, write10000
  from wrm$_snapshot sn, WRH$_CURRENT_BLOCK_SERVER cub
  where     sn.snap_id         = cub.snap_id
        and sn.dbid            = cub.dbid
        and sn.instance_number = cub.instance_number
        and sn.status          = 0;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_DATABASE_INSTANCE"("DBID",
select dbid, instance_number, startup_time, parallel, version,
       db_name, instance_name, host_name, last_ash_sample_id
from WRM$_DATABASE_INSTANCE;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_DATAFILE"("DBID",
select dbid, file#, creation_change#,
       filename, ts#, tsname, block_size
from WRH$_DATAFILE;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_DB_CACHE_ADVICE"("SNAP_ID",
select db.snap_id, db.dbid, db.instance_number,
       bpid, buffers_for_estimate,
       name, block_size, advice_status, size_for_estimate,
       size_factor, physical_reads, base_physical_reads,
       actual_physical_reads
from WRM$_SNAPSHOT sn, WRH$_DB_CACHE_ADVICE db
where      db.snap_id          = sn.snap_id
      and  db.dbid             = sn.dbid
      and  db.instance_number  = sn.instance_number
      and  sn.status           = 0
      and  sn.bl_moved         = 0
union all
select db.snap_id, db.dbid, db.instance_number,
       bpid, buffers_for_estimate,
       name, block_size, advice_status, size_for_estimate,
       size_factor, physical_reads, base_physical_reads,
       actual_physical_reads
from WRM$_SNAPSHOT sn, WRH$_DB_CACHE_ADVICE_BL db
where      db.snap_id          = sn.snap_id
      and  db.dbid             = sn.dbid
      and  db.instance_number  = sn.instance_number
      and  sn.status           = 0
      and  sn.bl_moved         = 1;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_DLM_MISC"("SNAP_ID",
select dlm.snap_id, dlm.dbid, dlm.instance_number,
       statistic#, name, value
  from wrm$_snapshot sn, WRH$_DLM_MISC dlm
  where     sn.snap_id         = dlm.snap_id
        and sn.dbid            = dlm.dbid
        and sn.instance_number = dlm.instance_number
        and sn.status          = 0
        and sn.bl_moved        = 0
union all
select dlm.snap_id, dlm.dbid, dlm.instance_number,
       statistic#, name, value
  from wrm$_snapshot sn, WRH$_DLM_MISC_BL dlm
  where     sn.snap_id         = dlm.snap_id
        and sn.dbid            = dlm.dbid
        and sn.instance_number = dlm.instance_number
        and sn.status          = 0
        and sn.bl_moved        = 1;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_ENQUEUE_STAT"("SNAP_ID",
select eq.snap_id, eq.dbid, eq.instance_number,
       eq_type, req_reason, total_req#,
       total_wait#, succ_req#, failed_req#, cum_wait_time, event#
  from wrm$_snapshot sn, WRH$_ENQUEUE_STAT eq
  where     sn.snap_id         = eq.snap_id
        and sn.dbid            = eq.dbid
        and sn.instance_number = eq.instance_number
        and sn.status          = 0;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_EVENT_NAME"("DBID",
select dbid, event_id, event_name, wait_class_id, wait_class
  from WRH$_EVENT_NAME;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_FILEMETRIC_HISTORY"("SNAP_ID",
select fm.snap_id, fm.dbid, fm.instance_number,
       fileid, creationtime, begin_time,
       end_time, intsize, group_id, avgreadtime, avgwritetime,
       physicalread, physicalwrite, phyblkread, phyblkwrite
  from wrm$_snapshot sn, WRH$_FILEMETRIC_HISTORY fm
  where     sn.snap_id         = fm.snap_id
        and sn.dbid            = fm.dbid
        and sn.instance_number = fm.instance_number
        and sn.status          = 0;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_FILESTATXS"("SNAP_ID",
select f.snap_id, f.dbid, f.instance_number,
       f.file#, f.creation_change#, fn.filename,
       fn.ts#, fn.tsname, fn.block_size,
       phyrds, phywrts, singleblkrds, readtim, writetim,
       singleblkrdtim, phyblkrd, phyblkwrt, wait_count, time
from WRM$_SNAPSHOT sn, WRH$_FILESTATXS f, DBA_HIST_DATAFILE fn
where      f.dbid             = fn.dbid
      and  f.file#            = fn.file#
      and  f.creation_change# = fn.creation_change#
      and  f.snap_id          = sn.snap_id
      and  f.dbid             = sn.dbid
      and  f.instance_number  = sn.instance_number
      and  sn.status          = 0
      and  sn.bl_moved        = 0
union all
select f.snap_id, f.dbid, f.instance_number,
       f.file#, f.creation_change#, fn.filename,
       fn.ts#, fn.tsname, fn.block_size,
       phyrds, phywrts, singleblkrds, readtim, writetim,
       singleblkrdtim, phyblkrd, phyblkwrt, wait_count, time
from WRM$_SNAPSHOT sn, WRH$_FILESTATXS_BL f, DBA_HIST_DATAFILE fn
where      f.dbid              = fn.dbid
      and  f.file#             = fn.file#
      and  f.creation_change#  = fn.creation_change#
      and  f.snap_id           = sn.snap_id
      and  f.dbid              = sn.dbid
      and  f.instance_number   = sn.instance_number
      and  sn.status           = 0
      and  sn.bl_moved         = 1;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_INSTANCE_RECOVERY"("SNAP_ID",
select ir.snap_id, ir.dbid, ir.instance_number, recovery_estimated_ios,
       actual_redo_blks, target_redo_blks, log_file_size_redo_blks,
       log_chkpt_timeout_redo_blks, log_chkpt_interval_redo_blks,
       fast_start_io_target_redo_blks, target_mttr, estimated_mttr,
       ckpt_block_writes, optimal_logfile_size, estd_cluster_available_time,
       writes_mttr, writes_logfile_size, writes_log_checkpoint_settings,
       writes_other_settings, writes_autotune, writes_full_thread_ckpt
  from wrm$_snapshot sn, WRH$_INSTANCE_RECOVERY ir
  where     sn.snap_id         = ir.snap_id
        and sn.dbid            = ir.dbid
        and sn.instance_number = ir.instance_number
        and sn.status          = 0;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_JAVA_POOL_ADVICE"("SNAP_ID",
select jp.snap_id, jp.dbid, jp.instance_number,
       java_pool_size_for_estimate, java_pool_size_factor,
       estd_lc_size, estd_lc_memory_objects,
       estd_lc_time_saved, estd_lc_time_saved_factor,
       estd_lc_load_time, estd_lc_load_time_factor,
       estd_lc_memory_object_hits
  from wrm$_snapshot sn, WRH$_JAVA_POOL_ADVICE jp
  where     sn.snap_id         = jp.snap_id
        and sn.dbid            = jp.dbid
        and sn.instance_number = jp.instance_number
        and sn.status          = 0;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_LATCH"("SNAP_ID",
select l.snap_id, l.dbid, l.instance_number,
       l.latch_hash, ln.latch_name, level#,
       gets, misses, sleeps, immediate_gets, immediate_misses, spin_gets,
       sleep1, sleep2, sleep3, sleep4, wait_time
from WRM$_SNAPSHOT sn, WRH$_LATCH l, DBA_HIST_LATCH_NAME ln
where      l.latch_hash       = ln.latch_hash
      and  l.dbid             = ln.dbid
      and  l.snap_id          = sn.snap_id
      and  l.dbid             = sn.dbid
      and  l.instance_number  = sn.instance_number
      and  sn.status          = 0
      and  sn.bl_moved        = 0
union all
select l.snap_id, l.dbid, l.instance_number,
       l.latch_hash, ln.latch_name, level#,
       gets, misses, sleeps, immediate_gets, immediate_misses, spin_gets,
       sleep1, sleep2, sleep3, sleep4, wait_time
from WRM$_SNAPSHOT sn, WRH$_LATCH_BL l, DBA_HIST_LATCH_NAME ln
where      l.latch_hash        = ln.latch_hash
      and  l.dbid              = ln.dbid
      and  l.snap_id           = sn.snap_id
      and  l.dbid              = sn.dbid
      and  l.instance_number   = sn.instance_number
      and  sn.status           = 0
      and  sn.bl_moved         = 1;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_LATCH_CHILDREN"("SNAP_ID",
select l.snap_id, l.dbid, l.instance_number,
       l.latch_hash, ln.latch_name, child#,
       gets, misses, sleeps, immediate_gets, immediate_misses, spin_gets,
       sleep1, sleep2, sleep3, sleep4, wait_time
from WRM$_SNAPSHOT sn, WRH$_LATCH_CHILDREN l, DBA_HIST_LATCH_NAME ln
where      l.latch_hash       = ln.latch_hash
      and  l.dbid             = ln.dbid
      and  l.snap_id          = sn.snap_id
      and  l.dbid             = sn.dbid
      and  l.instance_number  = sn.instance_number
      and  sn.status          = 0
      and  sn.bl_moved        = 0
union all
select l.snap_id, l.dbid, l.instance_number,
       l.latch_hash, ln.latch_name, child#,
       gets, misses, sleeps, immediate_gets, immediate_misses, spin_gets,
       sleep1, sleep2, sleep3, sleep4, wait_time
from WRM$_SNAPSHOT sn, WRH$_LATCH_CHILDREN_BL l, DBA_HIST_LATCH_NAME ln
where      l.latch_hash        = ln.latch_hash
      and  l.dbid              = ln.dbid
      and  l.snap_id           = sn.snap_id
      and  l.dbid              = sn.dbid
      and  l.instance_number   = sn.instance_number
      and  sn.status           = 0
      and  sn.bl_moved         = 1;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_LATCH_MISSES_SUMMARY"("SNAP_ID",
select l.snap_id, l.dbid, l.instance_number, parent_name, where_in_code,
       nwfail_count, sleep_count, wtr_slp_count
from WRM$_SNAPSHOT sn, WRH$_LATCH_MISSES_SUMMARY l
where      l.snap_id          = sn.snap_id
      and  l.dbid             = sn.dbid
      and  l.instance_number  = sn.instance_number
      and  sn.status          = 0
      and  sn.bl_moved        = 0
union all
select l.snap_id, l.dbid, l.instance_number, parent_name, where_in_code,
       nwfail_count, sleep_count, wtr_slp_count
from WRM$_SNAPSHOT sn, WRH$_LATCH_MISSES_SUMMARY_BL l
where      l.snap_id          = sn.snap_id
      and  l.dbid             = sn.dbid
      and  l.instance_number  = sn.instance_number
      and  sn.status          = 0
      and  sn.bl_moved        = 1;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_LATCH_NAME"("DBID",
select dbid, latch_hash, latch_name
from WRH$_LATCH_NAME;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_LATCH_PARENT"("SNAP_ID",
select l.snap_id, l.dbid, l.instance_number,
       l.latch_hash, ln.latch_name, level#,
       gets, misses, sleeps, immediate_gets, immediate_misses, spin_gets,
       sleep1, sleep2, sleep3, sleep4, wait_time
from WRM$_SNAPSHOT sn, WRH$_LATCH_PARENT l, DBA_HIST_LATCH_NAME ln
where      l.latch_hash       = ln.latch_hash
      and  l.dbid             = ln.dbid
      and  l.snap_id          = sn.snap_id
      and  l.dbid             = sn.dbid
      and  l.instance_number  = sn.instance_number
      and  sn.status          = 0
      and  sn.bl_moved        = 0
union all
select l.snap_id, l.dbid, l.instance_number,
       l.latch_hash, ln.latch_name, level#,
       gets, misses, sleeps, immediate_gets, immediate_misses, spin_gets,
       sleep1, sleep2, sleep3, sleep4, wait_time
from WRM$_SNAPSHOT sn, WRH$_LATCH_PARENT_BL l, DBA_HIST_LATCH_NAME ln
where      l.latch_hash        = ln.latch_hash
      and  l.dbid              = ln.dbid
      and  l.snap_id           = sn.snap_id
      and  l.dbid              = sn.dbid
      and  l.instance_number   = sn.instance_number
      and  sn.status           = 0
      and  sn.bl_moved         = 1;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_LIBRARYCACHE"("SNAP_ID",
select lc.snap_id, lc.dbid, lc.instance_number, namespace, gets,
       gethits, pins, pinhits, reloads, invalidations,
       dlm_lock_requests, dlm_pin_requests, dlm_pin_releases,
       dlm_invalidation_requests, dlm_invalidations
  from wrm$_snapshot sn, WRH$_LIBRARYCACHE lc
  where     sn.snap_id         = lc.snap_id
        and sn.dbid            = lc.dbid
        and sn.instance_number = lc.instance_number
        and sn.status          = 0;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_LOG"("SNAP_ID",
select log.snap_id, log.dbid, log.instance_number,
       group#, thread#, sequence#, bytes, members,
       archived, log.status, first_change#, first_time
  from wrm$_snapshot sn, WRH$_LOG log
  where     sn.snap_id         = log.snap_id
        and sn.dbid            = log.dbid
        and sn.instance_number = log.instance_number
        and sn.status          = 0;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_METRIC_NAME"("DBID",
select dbid, group_id, group_name, metric_id, metric_name, metric_unit
from WRH$_METRIC_NAME;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_MTTR_TARGET_ADVICE"("SNAP_ID",
select mt.snap_id, mt.dbid, mt.instance_number, mttr_target_for_estimate,
       advice_status, dirty_limit,
       estd_cache_writes, estd_cache_write_factor,
       estd_total_writes, estd_total_write_factor,
       estd_total_ios, estd_total_io_factor
  from wrm$_snapshot sn, WRH$_MTTR_TARGET_ADVICE mt
  where     sn.snap_id         = mt.snap_id
        and sn.dbid            = mt.dbid
        and sn.instance_number = mt.instance_number
        and sn.status          = 0;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_OPTIMIZER_ENV"("DBID",
select dbid, optimizer_env_hash_value, optimizer_env
from WRH$_OPTIMIZER_ENV;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_OSSTAT"("SNAP_ID",
select s.snap_id, s.dbid, s.instance_number, s.stat_id,
       nm.stat_name, value
from WRM$_SNAPSHOT sn, WRH$_OSSTAT s, DBA_HIST_OSSTAT_NAME nm
where     s.stat_id          = nm.stat_id
      and s.dbid             = nm.dbid
      and s.snap_id          = sn.snap_id
      and s.dbid             = sn.dbid
      and s.instance_number  = sn.instance_number
      and sn.status          = 0
      and sn.bl_moved        = 0
union all
select s.snap_id, s.dbid, s.instance_number, s.stat_id,
       nm.stat_name, value
from WRM$_SNAPSHOT sn, WRH$_OSSTAT_BL s, DBA_HIST_OSSTAT_NAME nm
where     s.stat_id          = nm.stat_id
      and s.dbid             = nm.dbid
      and s.snap_id          = sn.snap_id
      and s.dbid             = sn.dbid
      and s.instance_number  = sn.instance_number
      and sn.status          = 0
      and sn.bl_moved        = 1;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_OSSTAT_NAME"("DBID",
select dbid, stat_id, stat_name
from WRH$_OSSTAT_NAME;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_PARAMETER"("SNAP_ID",
select p.snap_id, p.dbid, p.instance_number,
       p.parameter_hash, pn.parameter_name,
       value, isdefault, ismodified
from WRM$_SNAPSHOT sn, WRH$_PARAMETER p, WRH$_PARAMETER_NAME pn
where     p.parameter_hash   = pn.parameter_hash
      and p.dbid             = pn.dbid
      and p.snap_id          = sn.snap_id
      and p.dbid             = sn.dbid
      and p.instance_number  = sn.instance_number
      and sn.status          = 0
      and sn.bl_moved        = 0
union all
select p.snap_id, p.dbid, p.instance_number,
       p.parameter_hash, pn.parameter_name,
       value, isdefault, ismodified
from WRM$_SNAPSHOT sn, WRH$_PARAMETER_BL p, WRH$_PARAMETER_NAME pn
where     p.parameter_hash   = pn.parameter_hash
      and p.dbid             = pn.dbid
      and p.snap_id          = sn.snap_id
      and p.dbid             = sn.dbid
      and p.instance_number  = sn.instance_number
      and sn.status          = 0
      and sn.bl_moved        = 1;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_PARAMETER_NAME"("DBID",
select dbid, parameter_hash, parameter_name
from WRH$_PARAMETER_NAME
where (translate(parameter_name,'_','#') not like '#%');

CREATE OR REPLACE FORCE VIEW "DBA_HIST_PGASTAT"("SNAP_ID",
select pga.snap_id, pga.dbid, pga.instance_number, name, value
  from wrm$_snapshot sn, WRH$_PGASTAT pga
  where     sn.snap_id         = pga.snap_id
        and sn.dbid            = pga.dbid
        and sn.instance_number = pga.instance_number
        and sn.status          = 0;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_PGA_TARGET_ADVICE"("SNAP_ID",
select pga.snap_id, pga.dbid, pga.instance_number,
       pga_target_for_estimate,
       pga_target_factor, advice_status, bytes_processed,
       estd_extra_bytes_rw, estd_pga_cache_hit_percentage,
       estd_overalloc_count
  from wrm$_snapshot sn, WRH$_PGA_TARGET_ADVICE pga
  where     sn.snap_id         = pga.snap_id
        and sn.dbid            = pga.dbid
        and sn.instance_number = pga.instance_number
        and sn.status          = 0;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_RESOURCE_LIMIT"("SNAP_ID",
select rl.snap_id, rl.dbid, rl.instance_number, resource_name,
       current_utilization, max_utilization, initial_allocation,
       limit_value
  from wrm$_snapshot sn, WRH$_RESOURCE_LIMIT rl
  where     sn.snap_id         = rl.snap_id
        and sn.dbid            = rl.dbid
        and sn.instance_number = rl.instance_number
        and sn.status          = 0;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_ROWCACHE_SUMMARY"("SNAP_ID",
select rc.snap_id, rc.dbid, rc.instance_number,
       parameter, total_usage,
       usage, gets, getmisses, scans, scanmisses, scancompletes,
       modifications, flushes, dlm_requests, dlm_conflicts,
       dlm_releases
  from WRM$_SNAPSHOT sn, WRH$_ROWCACHE_SUMMARY rc
  where     sn.snap_id         = rc.snap_id
        and sn.dbid            = rc.dbid
        and sn.instance_number = rc.instance_number
        and sn.status          = 0
        and sn.bl_moved        = 0
union all
select rc.snap_id, rc.dbid, rc.instance_number,
       parameter, total_usage,
       usage, gets, getmisses, scans, scanmisses, scancompletes,
       modifications, flushes, dlm_requests, dlm_conflicts,
       dlm_releases
  from WRM$_SNAPSHOT sn, WRH$_ROWCACHE_SUMMARY_BL rc
  where     sn.snap_id         = rc.snap_id
        and sn.dbid            = rc.dbid
        and sn.instance_number = rc.instance_number
        and sn.status          = 0
        and sn.bl_moved        = 1;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_SEG_STAT"("SNAP_ID",
select seg.snap_id, seg.dbid, seg.instance_number, ts#, obj#, dataobj#,
       logical_reads_total, logical_reads_delta,
       buffer_busy_waits_total, buffer_busy_waits_delta,
       db_block_changes_total, db_block_changes_delta,
       physical_reads_total, physical_reads_delta,
       physical_writes_total, physical_writes_delta,
       physical_reads_direct_total, physical_reads_direct_delta,
       physical_writes_direct_total, physical_writes_direct_delta,
       itl_waits_total, itl_waits_delta,
       row_lock_waits_total, row_lock_waits_delta,
       gc_cr_blocks_served_total, gc_cr_blocks_served_delta,
       gc_cu_blocks_served_total, gc_cu_blocks_served_delta,
       space_used_total, space_used_delta,
       space_allocated_total, space_allocated_delta,
       table_scans_total, table_scans_delta
from WRM$_SNAPSHOT sn, WRH$_SEG_STAT seg
where     seg.snap_id         = sn.snap_id
      and seg.dbid            = sn.dbid
      and seg.instance_number = sn.instance_number
      and sn.status           = 0
      and sn.bl_moved         = 0
union all
select seg.snap_id, seg.dbid, seg.instance_number, ts#, obj#, dataobj#,
       logical_reads_total, logical_reads_delta,
       buffer_busy_waits_total, buffer_busy_waits_delta,
       db_block_changes_total, db_block_changes_delta,
       physical_reads_total, physical_reads_delta,
       physical_writes_total, physical_writes_delta,
       physical_reads_direct_total, physical_reads_direct_delta,
       physical_writes_direct_total, physical_writes_direct_delta,
       itl_waits_total, itl_waits_delta,
       row_lock_waits_total, row_lock_waits_delta,
       gc_cr_blocks_served_total, gc_cr_blocks_served_delta,
       gc_cu_blocks_served_total, gc_cu_blocks_served_delta,
       space_used_total, space_used_delta,
       space_allocated_total, space_allocated_delta,
       table_scans_total, table_scans_delta
from WRM$_SNAPSHOT sn, WRH$_SEG_STAT_BL seg
where     seg.snap_id          = sn.snap_id
      and seg.dbid             = sn.dbid
      and seg.instance_number  = sn.instance_number
      and sn.status            = 0
      and sn.bl_moved          = 1;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_SEG_STAT_OBJ"("DBID",
select dbid, ts#, obj#, dataobj#, owner, object_name,
       subobject_name, object_type, tablespace_name, partition_type
from WRH$_SEG_STAT_OBJ;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_SERVICE_NAME"("DBID",
select dbid, service_name_hash, service_name
  from WRH$_SERVICE_NAME sn;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_SERVICE_STAT"("SNAP_ID",
select st.snap_id, st.dbid, st.instance_number,
       st.service_name_hash, sv.service_name,
       nm.stat_id, nm.stat_name, value
  from WRM$_SNAPSHOT sn, WRH$_SERVICE_STAT st,
       WRH$_SERVICE_NAME sv, WRH$_STAT_NAME nm
  where    st.service_name_hash = sv.service_name_hash
      and  st.dbid              = sv.dbid
      and  st.stat_id           = nm.stat_id
      and  st.dbid              = nm.dbid
      and  st.snap_id           = sn.snap_id
      and  st.dbid              = sn.dbid
      and  st.instance_number   = sn.instance_number
      and  sn.status            = 0
      and  sn.bl_moved          = 0
union all
select st.snap_id, st.dbid, st.instance_number,
       st.service_name_hash, sv.service_name,
       nm.stat_id, nm.stat_name, value
  from WRM$_SNAPSHOT sn, WRH$_SERVICE_STAT_BL st,
       WRH$_SERVICE_NAME sv, WRH$_STAT_NAME nm
  where    st.service_name_hash = sv.service_name_hash
      and  st.dbid              = sv.dbid
      and  st.stat_id           = nm.stat_id
      and  st.dbid              = nm.dbid
      and  st.snap_id           = sn.snap_id
      and  st.dbid              = sn.dbid
      and  st.instance_number   = sn.instance_number
      and  sn.status            = 0
      and  sn.bl_moved          = 1;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_SERVICE_WAIT_CLASS"("SNAP_ID",
select st.snap_id, st.dbid, st.instance_number,
       st.service_name_hash, nm.service_name,
       wait_class_id, wait_class, total_waits, time_waited
  from WRM$_SNAPSHOT sn, WRH$_SERVICE_WAIT_CLASS st,
       WRH$_SERVICE_NAME nm
  where    st.service_name_hash = nm.service_name_hash
      and  st.dbid              = nm.dbid
      and  st.snap_id           = sn.snap_id
      and  st.dbid              = sn.dbid
      and  st.instance_number   = sn.instance_number
      and  sn.status            = 0
      and  sn.bl_moved          = 0
union all
select st.snap_id, st.dbid, st.instance_number,
       st.service_name_hash, nm.service_name,
       wait_class_id, wait_class, total_waits, time_waited
  from WRM$_SNAPSHOT sn, WRH$_SERVICE_WAIT_CLASS_BL st,
       WRH$_SERVICE_NAME nm
  where    st.service_name_hash = nm.service_name_hash
      and  st.dbid              = nm.dbid
      and  st.snap_id           = sn.snap_id
      and  st.dbid              = sn.dbid
      and  st.instance_number   = sn.instance_number
      and  sn.status            = 0
      and  sn.bl_moved          = 1;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_SESSMETRIC_HISTORY"("SNAP_ID",
select m.snap_id, m.dbid, m.instance_number, begin_time, end_time, sessid,
       serial#, intsize, m.group_id, m.metric_id, mn.metric_name,
       value, mn.metric_unit
  from wrm$_snapshot sn, WRH$_SESSMETRIC_HISTORY m, DBA_HIST_METRIC_NAME mn
  where     m.group_id         = mn.group_id
        and m.metric_id        = mn.metric_id
        and m.dbid             = mn.dbid
        and sn.snap_id         = m.snap_id
        and sn.dbid            = m.dbid
        and sn.instance_number = m.instance_number
        and sn.status          = 0;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_SGA"("SNAP_ID",
select sga.snap_id, sga.dbid, sga.instance_number, name, value
  from wrm$_snapshot sn, WRH$_SGA sga
  where     sn.snap_id         = sga.snap_id
        and sn.dbid            = sga.dbid
        and sn.instance_number = sga.instance_number
        and sn.status          = 0;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_SGASTAT"("SNAP_ID",
select sga.snap_id, sga.dbid, sga.instance_number, name, pool, bytes
  from wrm$_snapshot sn, WRH$_SGASTAT sga
  where     sn.snap_id         = sga.snap_id
        and sn.dbid            = sga.dbid
        and sn.instance_number = sga.instance_number
        and sn.status          = 0
        and sn.bl_moved        = 0
union all
select sga.snap_id, sga.dbid, sga.instance_number, name, pool, bytes
  from wrm$_snapshot sn, WRH$_SGASTAT_BL sga
  where     sn.snap_id         = sga.snap_id
        and sn.dbid            = sga.dbid
        and sn.instance_number = sga.instance_number
        and sn.status          = 0
        and sn.bl_moved        = 1;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_SHARED_POOL_ADVICE"("SNAP_ID",
select sp.snap_id, sp.dbid, sp.instance_number,
       shared_pool_size_for_estimate,
       shared_pool_size_factor, estd_lc_size, estd_lc_memory_objects,
       estd_lc_time_saved, estd_lc_time_saved_factor,
       estd_lc_load_time, estd_lc_load_time_factor,
       estd_lc_memory_object_hits
  from wrm$_snapshot sn, WRH$_SHARED_POOL_ADVICE sp
  where     sn.snap_id         = sp.snap_id
        and sn.dbid            = sp.dbid
        and sn.instance_number = sp.instance_number
        and sn.status          = 0;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_SNAPSHOT"("SNAP_ID",
select snap_id, dbid, instance_number, startup_time,
       begin_interval_time, end_interval_time,
       flush_elapsed, snap_level, error_count
from WRM$_SNAPSHOT
where status = 0;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_SNAP_ERROR"("SNAP_ID",
select snap_id, dbid, instance_number, table_name, error_number
  from wrm$_snap_error;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_SQLBIND"("SNAP_ID",
select sql.snap_id, sql.dbid, sql.instance_number,
       sql_id, child_number,
       name, position, dup_position, datatype, datatype_string,
       character_sid, precision, scale, max_length, was_captured,
       last_captured, value_string, value_anydata
  from wrm$_snapshot sn, WRH$_SQLBIND sql
  where     sn.snap_id         = sql.snap_id
        and sn.dbid            = sql.dbid
        and sn.instance_number = sql.instance_number
        and sn.status          = 0
        and sn.bl_moved        = 0
union all
select bl.snap_id, bl.dbid, bl.instance_number,
       sql_id, child_number,
       name, position, dup_position, datatype, datatype_string,
       character_sid, precision, scale, max_length, was_captured,
       last_captured, value_string, value_anydata
  from wrm$_snapshot sn, WRH$_SQLBIND_BL bl
  where     sn.snap_id         = bl.snap_id
        and sn.dbid            = bl.dbid
        and sn.instance_number = bl.instance_number
        and sn.status          = 0
        and sn.bl_moved        = 1;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_SQLSTAT"("SNAP_ID",
select sql.snap_id, sql.dbid, sql.instance_number,
       sql_id, plan_hash_value,
       optimizer_cost, optimizer_mode, optimizer_env_hash_value,
       sharable_mem, loaded_versions, version_count,
       module, action,
       sql_profile, parsing_schema_id,
       fetches_total, fetches_delta,
       end_of_fetch_count_total, end_of_fetch_count_delta,
       sorts_total, sorts_delta, executions_total,
       executions_delta, loads_total, loads_delta,
       invalidations_total, invalidations_delta,
       parse_calls_total, parse_calls_delta, disk_reads_total,
       disk_reads_delta, buffer_gets_total, buffer_gets_delta,
       rows_processed_total, rows_processed_delta, cpu_time_total,
       cpu_time_delta, elapsed_time_total, elapsed_time_delta,
       iowait_total, iowait_delta, clwait_total, clwait_delta,
       apwait_total, apwait_delta, ccwait_total, ccwait_delta,
       direct_writes_total, direct_writes_delta, plsexec_time_total,
       plsexec_time_delta, javexec_time_total, javexec_time_delta
from WRM$_SNAPSHOT sn, WRH$_SQLSTAT sql
  where     sn.snap_id         = sql.snap_id
        and sn.dbid            = sql.dbid
        and sn.instance_number = sql.instance_number
        and sn.status          = 0
        and sn.bl_moved        = 0
union all
select sql.snap_id, sql.dbid, sql.instance_number,
       sql_id, plan_hash_value,
       optimizer_cost, optimizer_mode, optimizer_env_hash_value,
       sharable_mem, loaded_versions, version_count,
       module, action,
       sql_profile, parsing_schema_id,
       fetches_total, fetches_delta,
       end_of_fetch_count_total, end_of_fetch_count_delta,
       sorts_total, sorts_delta, executions_total,
       executions_delta, loads_total, loads_delta,
       invalidations_total, invalidations_delta,
       parse_calls_total, parse_calls_delta, disk_reads_total,
       disk_reads_delta, buffer_gets_total, buffer_gets_delta,
       rows_processed_total, rows_processed_delta, cpu_time_total,
       cpu_time_delta, elapsed_time_total, elapsed_time_delta,
       iowait_total, iowait_delta, clwait_total, clwait_delta,
       apwait_total, apwait_delta, ccwait_total, ccwait_delta,
       direct_writes_total, direct_writes_delta, plsexec_time_total,
       plsexec_time_delta, javexec_time_total, javexec_time_delta
from WRM$_SNAPSHOT sn, WRH$_SQLSTAT_BL sql
  where     sn.snap_id         = sql.snap_id
        and sn.dbid            = sql.dbid
        and sn.instance_number = sql.instance_number
        and sn.status          = 0
        and sn.bl_moved        = 1;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_SQLTEXT"("DBID",
select dbid, sql_id, sql_text, command_type
from WRH$_SQLTEXT;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_SQL_PLAN"("DBID",
select dbid, sql_id, plan_hash_value, id, operation, options,
       object_node, object#, object_owner, object_name,
       object_alias, object_type, optimizer,
       parent_id, depth, position, search_columns, cost, cardinality,
       bytes, other_tag, partition_start, partition_stop, partition_id,
       other, distribution, cpu_cost, io_cost, temp_space,
       access_predicates, filter_predicates,
       projection, time, qblock_name, remarks
from WRH$_SQL_PLAN;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_SQL_SUMMARY"("SNAP_ID",
select ss.snap_id, ss.dbid, ss.instance_number,
       total_sql, total_sql_mem,
       single_use_sql, single_use_sql_mem
from WRM$_SNAPSHOT sn, WRH$_SQL_SUMMARY ss
where     sn.snap_id         = ss.snap_id
      and sn.dbid            = ss.dbid
      and sn.instance_number = ss.instance_number
      and sn.status          = 0;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_SQL_WORKAREA_HSTGRM"("SNAP_ID",
select swh.snap_id, swh.dbid, swh.instance_number, low_optimal_size,
       high_optimal_size, optimal_executions, onepass_executions,
       multipasses_executions, total_executions
  from wrm$_snapshot sn, WRH$_SQL_WORKAREA_HISTOGRAM swh
  where     sn.snap_id         = swh.snap_id
        and sn.dbid            = swh.dbid
        and sn.instance_number = swh.instance_number
        and sn.status          = 0;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_STAT_NAME"("DBID",
select dbid, stat_id, stat_name
from WRH$_STAT_NAME;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_SYSMETRIC_HISTORY"("SNAP_ID",
select m.snap_id, m.dbid, m.instance_number,
       begin_time, end_time, intsize,
       m.group_id, m.metric_id, mn.metric_name, value, mn.metric_unit
from wrm$_snapshot sn, WRH$_SYSMETRIC_HISTORY m, DBA_HIST_METRIC_NAME mn
where       m.group_id       = mn.group_id
      and   m.metric_id      = mn.metric_id
      and   m.dbid           = mn.dbid
      and   sn.snap_id       = m.snap_id
      and sn.dbid            = m.dbid
      and sn.instance_number = m.instance_number
      and sn.status          = 0;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_SYSMETRIC_SUMMARY"("SNAP_ID",
select m.snap_id, m.dbid, m.instance_number,
       begin_time, end_time, intsize,
       m.group_id, m.metric_id, mn.metric_name, mn.metric_unit,
       num_interval, minval, maxval, average, standard_deviation
  from wrm$_snapshot sn, WRH$_SYSMETRIC_SUMMARY m, DBA_HIST_METRIC_NAME mn
  where     m.group_id         = mn.group_id
        and m.metric_id        = mn.metric_id
        and m.dbid             = mn.dbid
        and sn.snap_id         = m.snap_id
        and sn.dbid            = m.dbid
        and sn.instance_number = m.instance_number
        and sn.status          = 0;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_SYSSTAT"("SNAP_ID",
select s.snap_id, s.dbid, s.instance_number,
       s.stat_id, nm.stat_name, value
from WRM$_SNAPSHOT sn, WRH$_SYSSTAT s, DBA_HIST_STAT_NAME nm
where      s.stat_id          = nm.stat_id
      and  s.dbid             = nm.dbid
      and  s.snap_id          = sn.snap_id
      and  s.dbid             = sn.dbid
      and  s.instance_number  = sn.instance_number
      and  sn.status          = 0
      and  sn.bl_moved        = 0
union all
select s.snap_id, s.dbid, s.instance_number,
       s.stat_id, nm.stat_name, value
from WRM$_SNAPSHOT sn, WRH$_SYSSTAT_BL s, DBA_HIST_STAT_NAME nm
where      s.stat_id           = nm.stat_id
      and  s.dbid              = nm.dbid
      and  s.snap_id           = sn.snap_id
      and  s.dbid              = sn.dbid
      and  s.instance_number   = sn.instance_number
      and  sn.status           = 0
      and  sn.bl_moved         = 1;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_SYSTEM_EVENT"("SNAP_ID",
select e.snap_id, e.dbid, e.instance_number,
       e.event_id, en.event_name, en.wait_class_id, en.wait_class,
       total_waits, total_timeouts, time_waited_micro
from WRM$_SNAPSHOT sn, WRH$_SYSTEM_EVENT e,
     DBA_HIST_EVENT_NAME en
where     e.event_id         = en.event_id
      and e.dbid             = en.dbid
      and e.snap_id          = sn.snap_id
      and e.dbid             = sn.dbid
      and e.instance_number  = sn.instance_number
      and sn.status          = 0
      and sn.bl_moved        = 0
union all
select e.snap_id, e.dbid, e.instance_number,
       e.event_id, en.event_name, en.wait_class_id, en.wait_class,
       total_waits, total_timeouts, time_waited_micro
from WRM$_SNAPSHOT sn, WRH$_SYSTEM_EVENT_BL e,
     DBA_HIST_EVENT_NAME en
where     e.event_id         = en.event_id
      and e.dbid             = en.dbid
      and e.snap_id          = sn.snap_id
      and e.dbid             = sn.dbid
      and e.instance_number  = sn.instance_number
      and sn.status          = 0
      and sn.bl_moved        = 1;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_SYS_TIME_MODEL"("SNAP_ID",
select s.snap_id, s.dbid, s.instance_number, s.stat_id,
       nm.stat_name, value
from WRM$_SNAPSHOT sn, WRH$_SYS_TIME_MODEL s, DBA_HIST_STAT_NAME nm
where      s.stat_id          = nm.stat_id
      and  s.dbid             = nm.dbid
      and  s.snap_id          = sn.snap_id
      and  s.dbid             = sn.dbid
      and  s.instance_number  = sn.instance_number
      and  sn.status          = 0
      and  sn.bl_moved        = 0
union all
select s.snap_id, s.dbid, s.instance_number, s.stat_id,
       nm.stat_name, value
from WRM$_SNAPSHOT sn, WRH$_SYS_TIME_MODEL_BL s, DBA_HIST_STAT_NAME nm
where      s.stat_id           = nm.stat_id
      and  s.dbid              = nm.dbid
      and  s.snap_id           = sn.snap_id
      and  s.dbid              = sn.dbid
      and  s.instance_number   = sn.instance_number
      and  sn.status           = 0
      and  sn.bl_moved         = 1;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_TABLESPACE_STAT"("SNAP_ID",
select tbs.snap_id, tbs.dbid, tbs.instance_number, ts#, tsname, contents,
       tbs.status, segment_space_management, extent_management,
       is_backup
from WRM$_SNAPSHOT sn, WRH$_TABLESPACE_STAT tbs
where      tbs.snap_id          = sn.snap_id
      and  tbs.dbid             = sn.dbid
      and  tbs.instance_number  = sn.instance_number
      and  sn.status            = 0
      and  sn.bl_moved          = 0
union all
select tbs.snap_id, tbs.dbid, tbs.instance_number, ts#, tsname, contents,
       tbs.status, segment_space_management, extent_management,
       is_backup
from WRM$_SNAPSHOT sn, WRH$_TABLESPACE_STAT_BL tbs
where      tbs.snap_id          = sn.snap_id
      and  tbs.dbid             = sn.dbid
      and  tbs.instance_number  = sn.instance_number
      and  sn.status            = 0
      and  sn.bl_moved          = 1;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_TBSPC_SPACE_USAGE"("SNAP_ID",
select tb.snap_id, tb.dbid, tablespace_id, tablespace_size,
       tablespace_maxsize, tablespace_usedsize, rtime
  from wrm$_snapshot sn, WRH$_TABLESPACE_SPACE_USAGE tb
  where     sn.snap_id         = tb.snap_id
        and sn.dbid            = tb.dbid
        and sn.status          = 0;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_TEMPFILE"("DBID",
select dbid, file#, creation_change#,
       filename, ts#, tsname, block_size
from WRH$_TEMPFILE;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_TEMPSTATXS"("SNAP_ID",
select t.snap_id, t.dbid, t.instance_number,
       t.file#, t.creation_change#, tn.filename,
       tn.ts#, tn.tsname, tn.block_size,
       phyrds, phywrts, singleblkrds, readtim, writetim,
       singleblkrdtim, phyblkrd, phyblkwrt, wait_count, time
from WRM$_SNAPSHOT sn, WRH$_TEMPSTATXS t, DBA_HIST_TEMPFILE tn
where     t.dbid             = tn.dbid
      and t.file#            = tn.file#
      and t.creation_change# = tn.creation_change#
      and sn.snap_id         = t.snap_id
      and sn.dbid            = t.dbid
      and sn.instance_number = t.instance_number
      and sn.status          = 0;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_THREAD"("SNAP_ID",
select th.snap_id, th.dbid, th.instance_number,
       thread#, thread_instance_number, th.status,
       open_time, current_group#, sequence#
  from wrm$_snapshot sn, WRH$_THREAD th
  where     sn.snap_id         = th.snap_id
        and sn.dbid            = th.dbid
        and sn.instance_number = th.instance_number
        and sn.status          = 0;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_UNDOSTAT"("BEGIN_TIME",
select begin_time, end_time, ud.dbid, ud.instance_number,
       ud.snap_id, undotsn,
       undoblks, txncount, maxquerylen, maxquerysqlid,
       maxconcurrency, unxpstealcnt, unxpblkrelcnt, unxpblkreucnt,
       expstealcnt, expblkrelcnt, expblkreucnt, ssolderrcnt,
       nospaceerrcnt, activeblks, unexpiredblks, expiredblks,
       tuned_undoretention
  from wrm$_snapshot sn, WRH$_UNDOSTAT ud
  where     sn.snap_id         = ud.snap_id
        and sn.dbid            = ud.dbid
        and sn.instance_number = ud.instance_number
        and sn.status          = 0;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_WAITCLASSMET_HISTORY"("SNAP_ID",
select em.snap_id, em.dbid, em.instance_number,
       em.wait_class_id, wn.wait_class, begin_time, end_time, intsize,
       group_id, average_waiter_count, dbtime_in_wait,
       time_waited, wait_count
  from wrm$_snapshot sn, WRH$_WAITCLASSMETRIC_HISTORY em,
       (select wait_class_id, wait_class from wrh$_event_name
        group by wait_class_id, wait_class) wn
  where     em.wait_class_id   = wn.wait_class_id
        and sn.snap_id         = em.snap_id
        and sn.dbid            = em.dbid
        and sn.instance_number = em.instance_number
        and sn.status          = 0;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_WAITSTAT"("SNAP_ID",
select wt.snap_id, wt.dbid, wt.instance_number,
       class, wait_count, time
  from wrm$_snapshot sn, WRH$_WAITSTAT wt
  where     sn.snap_id         = wt.snap_id
        and sn.dbid            = wt.dbid
        and sn.instance_number = wt.instance_number
        and sn.status          = 0
        and sn.bl_moved        = 0
union all
select bl.snap_id, bl.dbid, bl.instance_number, class,
       wait_count, time
  from wrm$_snapshot sn, WRH$_WAITSTAT_BL bl
  where     sn.snap_id         = bl.snap_id
        and sn.dbid            = bl.dbid
        and sn.instance_number = bl.instance_number
        and sn.status          = 0
        and sn.bl_moved        = 1;

CREATE OR REPLACE FORCE VIEW "DBA_HIST_WR_CONTROL"("DBID",
select dbid, snap_interval, retention
from WRM$_WR_CONTROL;

CREATE OR REPLACE FORCE VIEW "DBA_IAS_CONSTRAINT_EXP"("PKEXISTS",
select 1 pkexists, cd.obj# from sys.cdef$ cd
where cd.type# = 2;

CREATE OR REPLACE FORCE VIEW "DBA_IAS_GEN_STMTS"("IAS_TEMPLATE_NAME",
select rt.refresh_template_name ias_template_name,
  decode(ro.object_type, -1017, to_number(ro.object_name), 0) lineno, ddl_text
from system.repcat$_refresh_templates rt,
  system.repcat$_template_objects ro,
  system.repcat$_template_types tt
where rt.template_type_id = tt.template_type_id
and bitand(rawtohex(tt.flags),2) = 2
and rt.refresh_template_id = ro.refresh_template_id
and ro.object_type = -1017   -- object_type = dbms_ias_template.generated_ddl;

CREATE OR REPLACE FORCE VIEW "DBA_IAS_GEN_STMTS_EXP"("IAS_TEMPLATE_ID",
select ro.refresh_template_id ias_template_id,
  decode(ro.object_type, -1017, to_number(ro.object_name), 0) lineno, ddl_text
from system.repcat$_template_objects ro
where ro.object_type = -1017;

CREATE OR REPLACE FORCE VIEW "DBA_IAS_OBJECTS"("IAS_TEMPLATE_NAME",
select ro.ias_template_name,
  ro.schema_name,
  ro.object_name,
  ro.object_type,
  ro.derived_from_sname,
  ro.derived_from_oname
from sys.dba_ias_objects_base ro;

CREATE OR REPLACE FORCE VIEW "DBA_IAS_OBJECTS_BASE"("IAS_TEMPLATE_NAME",
select rt.refresh_template_name ias_template_name,
  ro.schema_name,
  ro.object_name,
  ro.object_type object_type_id,
  ot.object_type_name object_type,
  ro.derived_from_sname,
  ro.derived_from_oname
from system.repcat$_refresh_templates rt,
  system.repcat$_template_objects ro,
  system.repcat$_object_types ot,
  system.repcat$_template_types tt
where rt.refresh_template_id = ro.refresh_template_id
and ro.object_type = ot.object_type_id
and rt.template_type_id = tt.template_type_id
and bitand(rawtohex(tt.flags),2) = 2;

CREATE OR REPLACE FORCE VIEW "DBA_IAS_OBJECTS_EXP"("TEMPLATE_ID",
select ro.refresh_template_id template_id,
       ro.object_name,
       ro.schema_name,
       ot.object_type_name object_type
from system.repcat$_template_objects ro,
  system.repcat$_refresh_templates rt,
  system.repcat$_template_types tt,
  system.repcat$_object_types ot
where ro.refresh_template_id = rt.refresh_template_id
and ro.object_type = ot.object_type_id
and rt.template_type_id = tt.template_type_id
and bitand(rawtohex(tt.flags),2) = 2;

CREATE OR REPLACE FORCE VIEW "DBA_IAS_POSTGEN_STMTS"("IAS_TEMPLATE_ID",
select "IAS_TEMPLATE_ID",
  where gs.lineno > (select lineno from sys.dba_ias_gen_stmts_exp f
                       where to_char(f.ddl_text)='0'
                         and f.ias_template_id = gs.ias_template_id);

CREATE OR REPLACE FORCE VIEW "DBA_IAS_PREGEN_STMTS"("IAS_TEMPLATE_ID",
select "IAS_TEMPLATE_ID",
  where gs.lineno < (select lineno from sys.dba_ias_gen_stmts_exp f
                       where to_char(f.ddl_text)='0'
                         and f.ias_template_id = gs.ias_template_id);

CREATE OR REPLACE FORCE VIEW "DBA_IAS_SITES"("IAS_TEMPLATE_NAME",
select refresh_template_name, user_name, site_name
from system.repcat$_template_sites
where status = -100 /*secret code for IAS template sites? */;

CREATE OR REPLACE FORCE VIEW "DBA_IAS_TEMPLATES"("OWNER",
select owner, refresh_group_name,
  refresh_template_name ias_template_name,
  refresh_template_id   ias_template_id,
  template_comment
from system.repcat$_refresh_templates rt,
  system.repcat$_template_types tt
where rt.template_type_id = tt.template_type_id
and bitand(rawtohex(tt.flags),2) = 2;

CREATE OR REPLACE FORCE VIEW "DBA_INDEXES"("OWNER",
select u.name, o.name,
       decode(bitand(i.property, 16), 0, '', 'FUNCTION-BASED ') ||
        decode(i.type#, 1, 'NORMAL'||
                          decode(bitand(i.property, 4), 0, '', 4, '/REV'),
                      2, 'BITMAP', 3, 'CLUSTER', 4, 'IOT - TOP',
                      5, 'IOT - NESTED', 6, 'SECONDARY', 7, 'ANSI', 8, 'LOB',
                      9, 'DOMAIN'),
       iu.name, io.name,
       decode(io.type#, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                       4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE', 'UNDEFINED'),
       decode(bitand(i.property, 1), 0, 'NONUNIQUE', 1, 'UNIQUE', 'UNDEFINED'),
       decode(bitand(i.flags, 32), 0, 'DISABLED', 32, 'ENABLED', null),
       i.spare2,
       decode(bitand(i.property, 34), 0,
           decode(i.type#, 9, null, ts.name), null),
       decode(bitand(i.property, 2),0, i.initrans, null),
       decode(bitand(i.property, 2),0, i.maxtrans, null),
       s.iniexts * ts.blocksize,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
                             s.extsize * ts.blocksize),
       s.minexts, s.maxexts,
        decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                     s.extpct),
       decode(i.type#, 4, mod(i.pctthres$,256), NULL), i.trunccnt,
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
         decode(bitand(o.flags, 2), 2, 1, decode(s.lists, 0, 1, s.lists))),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
         decode(bitand(o.flags, 2), 2, 1, decode(s.groups, 0, 1, s.groups))),
       decode(bitand(i.property, 2),0,i.pctfree$,null),
       decode(bitand(i.property, 2), 2, NULL,
                decode(bitand(i.flags, 4), 0, 'YES', 'NO')),
       i.blevel, i.leafcnt, i.distkey, i.lblkkey, i.dblkkey, i.clufac,
       decode(bitand(i.property, 2), 2,
                   decode(i.type#, 9, decode(bitand(i.flags, 8),
                                        8, 'INPROGRS', 'VALID'), 'N/A'),
                     decode(bitand(i.flags, 1), 1, 'UNUSABLE',
                            decode(bitand(i.flags, 8), 8, 'INPROGRS',
                                                            'VALID'))),
       rowcnt, samplesize, analyzetime,
       decode(i.degree, 32767, 'DEFAULT', nvl(i.degree,1)),
       decode(i.instances, 32767, 'DEFAULT', nvl(i.instances,1)),
       decode(bitand(i.property, 2), 2, 'YES', 'NO'),
       decode(bitand(o.flags, 2), 0, 'N', 2, 'Y', 'N'),
       decode(bitand(o.flags, 4), 0, 'N', 4, 'Y', 'N'),
       decode(bitand(o.flags, 16), 0, 'N', 16, 'Y', 'N'),
       decode(bitand(o.flags, 2), 2, 'DEFAULT',
             decode(s.cachehint, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL)),
       decode(bitand(i.flags, 64), 0, 'NO', 'YES'),
       decode(bitand(o.flags, 2), 0, NULL,
           decode(bitand(i.property, 64), 64, 'SYS$SESSION', 'SYS$TRANSACTION')),
       decode(bitand(i.flags, 128), 128, mod(trunc(i.pctthres$/256),256),
              decode(i.type#, 4, mod(trunc(i.pctthres$/256),256), NULL)),
       itu.name, ito.name, i.spare4,
       decode(bitand(i.flags, 2048), 0, 'NO', 'YES'),
       decode(i.type#, 9, decode(o.status, 5, 'IDXTYP_INVLD',
                                           1, 'VALID'),  ''),
       decode(i.type#, 9, decode(bitand(i.flags, 16), 16, 'FAILED', 'VALID'), ''),
       decode(bitand(i.property, 16), 0, '',
              decode(bitand(i.flags, 1024), 0, 'ENABLED', 'DISABLED')),
       decode(bitand(i.property, 1024), 1024, 'YES', 'NO'),
       decode(bitand(i.property, 16384), 16384, 'YES', 'NO'),
       decode(bitand(o.flags, 128), 128, 'YES', 'NO')
from sys.ts$ ts, sys.seg$ s,
     sys.user$ iu, sys.obj$ io, sys.user$ u, sys.ind$ i, sys.obj$ o,
     sys.user$ itu, sys.obj$ ito
where u.user# = o.owner#
  and o.obj# = i.obj#
  and i.bo# = io.obj#
  and io.owner# = iu.user#
  and bitand(i.flags, 4096) = 0
  and bitand(o.flags, 128) = 0
  and i.ts# = ts.ts# (+)
  and i.file# = s.file# (+)
  and i.block# = s.block# (+)
  and i.ts# = s.ts# (+)
  and i.indmethod# = ito.obj# (+)
  and ito.owner# = itu.user# (+);

CREATE OR REPLACE FORCE VIEW "DBA_INDEXTYPES"("OWNER",
select u.name, o.name, u1.name, o1.name, i.interface_version#, t.version#,
io.opcount, decode(bitand(i.property, 48), 0, 'NONE', 16, 'RANGE', 32, 'HASH', 48, 'HASH,RANGE'),
decode(bitand(i.property, 2), 0, 'NO', 2, 'YES')
from sys.indtypes$ i, sys.user$ u, sys.obj$ o,
sys.user$ u1, (select it.obj#, count(*) opcount from
sys.indop$ io1, sys.indtypes$ it where
io1.obj# = it.obj# and bitand(io1.property, 4) != 4
group by it.obj#) io, sys.obj$ o1,
sys.type$ t
where i.obj# = o.obj# and o.owner# = u.user# and
u1.user# = o.owner# and io.obj# = i.obj# and
o1.obj# = i.implobj# and o1.oid$ = t.toid;

CREATE OR REPLACE FORCE VIEW "DBA_INDEXTYPE_ARRAYTYPES"("OWNER",
select indtypu.name, indtypo.name,
decode(i.type, 121, (select baseu.name from user$ baseu
       where baseo.owner#=baseu.user#), null),
decode(i.type, 121, baseo.name, null),
decode(i.type,  /* DATA_TYPE */
0, null,
1, 'VARCHAR2',
2, 'NUMBER',
3, 'NATIVE INTEGER',
8, 'LONG',
9, 'VARCHAR',
11, 'ROWID',
12, 'DATE',
23, 'RAW',
24, 'LONG RAW',
29, 'BINARY_INTEGER',
69, 'ROWID',
96, 'CHAR',
100, 'BINARY_FLOAT',
101, 'BINARY_DOUBLE',
102, 'REF CURSOR',
104, 'UROWID',
105, 'MLSLABEL',
106, 'MLSLABEL',
110, 'REF',
111, 'REF',
112, 'CLOB',
113, 'BLOB', 114, 'BFILE', 115, 'CFILE',
121, 'OBJECT',
122, 'TABLE',
123, 'VARRAY',
178, 'TIME',
179, 'TIME WITH TIME ZONE',
180, 'TIMESTAMP',
181, 'TIMESTAMP WITH TIME ZONE',
231, 'TIMESTAMP WITH LOCAL TIME ZONE',
182, 'INTERVAL YEAR TO MONTH',
183, 'INTERVAL DAY TO SECOND',
250, 'PL/SQL RECORD',
251, 'PL/SQL TABLE',
252, 'PL/SQL BOOLEAN',
'UNDEFINED'),
arrayu.name, arrayo.name
from sys.user$ indtypu, sys.indarraytype$ i, sys.obj$ indtypo,
sys.obj$ baseo, sys.obj$ arrayo, sys.user$ arrayu
where i.obj# = indtypo.obj# and  indtypu.user# = indtypo.owner# and
      i.basetypeobj# = baseo.obj#(+) and i.arraytypeobj# = arrayo.obj# and
      arrayu.user# = arrayo.owner#;

CREATE OR REPLACE FORCE VIEW "DBA_INDEXTYPE_COMMENTS"("OWNER",
select  u.name, o.name, c.comment$
from    sys.obj$ o, sys.user$ u, sys.indtypes$ i, sys.com$ c
where   o.obj# = i.obj# and u.user# = o.owner# and c.obj# = i.obj#;

CREATE OR REPLACE FORCE VIEW "DBA_INDEXTYPE_OPERATORS"("OWNER",
select u.name, o.name, u1.name, op.name, i.bind#
from sys.user$ u, sys.indop$ i, sys.obj$ o,
sys.obj$ op, sys.user$ u1
where i.obj# = o.obj# and i.oper# = op.obj# and
      u.user# = o.owner# and bitand(i.property, 4) != 4 and
      u1.user#=op.owner#;

CREATE OR REPLACE FORCE VIEW "DBA_IND_COLUMNS"("INDEX_OWNER",
select io.name, idx.name, bo.name, base.name,
       decode(bitand(c.property, 1024), 1024,
              (select decode(bitand(tc.property, 1), 1, ac.name, tc.name)
              from sys.col$ tc, attrcol$ ac
              where tc.intcol# = c.intcol#-1
                and tc.obj# = c.obj#
                and tc.obj# = ac.obj#(+)
                and tc.intcol# = ac.intcol#(+)),
              decode(ac.name, null, c.name, ac.name)),
       ic.pos#, c.length, c.spare3,
       decode(bitand(c.property, 131072), 131072, 'DESC', 'ASC')
from sys.col$ c, sys.obj$ idx, sys.obj$ base, sys.icol$ ic,
     sys.user$ io, sys.user$ bo, sys.ind$ i, sys.attrcol$ ac
where ic.bo# = c.obj#
  and decode(bitand(i.property,1024),0,ic.intcol#,ic.spare2) = c.intcol#
  and ic.bo# = base.obj#
  and io.user# = idx.owner#
  and bo.user# = base.owner#
  and ic.obj# = idx.obj#
  and idx.obj# = i.obj#
  and i.type# in (1, 2, 3, 4, 6, 7, 9)
  and c.obj# = ac.obj#(+)
  and c.intcol# = ac.intcol#(+);

CREATE OR REPLACE FORCE VIEW "DBA_IND_EXPRESSIONS"("INDEX_OWNER",
select io.name, idx.name, bo.name, base.name, c.default$, ic.pos#
from sys.col$ c, sys.obj$ idx, sys.obj$ base, sys.icol$ ic,
     sys.user$ io, sys.user$ bo, sys.ind$ i
where bitand(ic.spare1,1) = 1       /* an expression */
  and (bitand(i.property,1024) = 0) /* not bmji */
  and ic.bo# = c.obj#
  and ic.intcol# = c.intcol#
  and ic.bo# = base.obj#
  and io.user# = idx.owner#
  and bo.user# = base.owner#
  and ic.obj# = idx.obj#
  and idx.obj# = i.obj#
  and i.type# in (1, 2, 3, 4, 6, 7, 9);

CREATE OR REPLACE FORCE VIEW "DBA_IND_PARTITIONS"("INDEX_OWNER",
select u.name, io.name, 'NO', io.subname, 0,
       ip.hiboundval, ip.hiboundlen, ip.part#,
       decode(bitand(ip.flags, 1), 1, 'UNUSABLE', 'USABLE'), ts.name,
       ip.pctfree$,ip.initrans, ip.maxtrans, s.iniexts * ts.blocksize,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
                               s.extsize * ts.blocksize),
       s.minexts, s.maxexts,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                      s.extpct),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
         decode(s.lists, 0, 1, s.lists)),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
         decode(s.groups, 0, 1, s.groups)),
       decode(mod(trunc(ip.flags / 4), 2), 0, 'YES', 'NO'),
       decode(bitand(ip.flags, 1024), 0, 'DISABLED', 1024, 'ENABLED', null),
       ip.blevel, ip.leafcnt, ip.distkey, ip.lblkkey, ip.dblkkey,
       ip.clufac, ip.rowcnt, ip.samplesize, ip.analyzetime,
       decode(s.cachehint, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL),
       decode(bitand(ip.flags, 8), 0, 'NO', 'YES'), ip.pctthres$,
       decode(bitand(ip.flags, 16), 0, 'NO', 'YES'),'',''
from   obj$ io, indpartv$ ip, ts$ ts, sys.seg$ s, user$ u
where  io.obj# = ip.obj# and ts.ts# = ip.ts# and ip.file#=s.file# and
       ip.block#=s.block# and ip.ts#=s.ts# and io.owner# = u.user#
      union all
select u.name, io.name, 'YES', io.subname, icp.subpartcnt,
       icp.hiboundval, icp.hiboundlen, icp.part#, 'N/A', ts.name,
       icp.defpctfree, icp.definitrans, icp.defmaxtrans,
       icp.definiexts, icp.defextsize, icp.defminexts, icp.defmaxexts,
       icp.defextpct, icp.deflists, icp.defgroups,
       decode(icp.deflogging, 0, 'NONE', 1, 'YES', 2, 'NO', 'UNKNOWN'),
       decode(bitand(icp.flags, 1024), 0, 'DISABLED', 1024, 'ENABLED', null),
       icp.blevel, icp.leafcnt, icp.distkey, icp.lblkkey, icp.dblkkey,
       icp.clufac, icp.rowcnt, icp.samplesize, icp.analyzetime,
       decode(icp.defbufpool, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL),
       decode(bitand(icp.flags, 8), 0, 'NO', 'YES'), TO_NUMBER(NULL),
       decode(bitand(icp.flags, 16), 0, 'NO', 'YES'),'',''
from   obj$ io, indcompartv$ icp, ts$ ts, user$ u
where  io.obj# = icp.obj# and icp.defts# = ts.ts# (+) and u.user# = io.owner#
      union all
select u.name, io.name, 'NO', io.subname, 0,
       ip.hiboundval, ip.hiboundlen, ip.part#,
       decode(bitand(ip.flags, 1), 1, 'UNUSABLE',
                decode(bitand(ip.flags, 4096), 4096, 'INPROGRS', 'USABLE')),
       null, ip.pctfree$, ip.initrans, ip.maxtrans,
       0, 0, 0, 0, 0, 0, 0,
       decode(mod(trunc(ip.flags / 4), 2), 0, 'YES', 'NO'),
       decode(bitand(ip.flags, 1024), 0, 'DISABLED', 1024, 'ENABLED', null),
       ip.blevel, ip.leafcnt, ip.distkey, ip.lblkkey, ip.dblkkey,
       ip.clufac, ip.rowcnt, ip.samplesize, ip.analyzetime,
       'DEFAULT',
       decode(bitand(ip.flags, 8), 0, 'NO', 'YES'), ip.pctthres$,
       decode(bitand(ip.flags, 16), 0, 'NO', 'YES'),
       decode(i.type#,
             9, decode(bitand(ip.flags, 8192), 8192, 'FAILED', 'VALID'),
             ''),
       ipp.parameters
from   obj$ io, indpartv$ ip,  user$ u, ind$ i, indpart_param$ ipp
where  io.obj# = ip.obj# and io.owner# = u.user# and
       ip.bo# = i.obj# and ip.obj# = ipp.obj#;

CREATE OR REPLACE FORCE VIEW "DBA_IND_STATISTICS"("OWNER",
SELECT
    u.name, o.name, NULL,NULL, NULL, NULL, 'INDEX',
    i.blevel, i.leafcnt, i.distkey, i.lblkkey, i.dblkkey, i.clufac, i.rowcnt,
    ins.cachedblk, ins.cachehit, i.samplesize, i.analyzetime,
    decode(bitand(i.flags, 2048), 0, 'NO', 'YES'),
    decode(bitand(i.flags, 64), 0, 'NO', 'YES')
  FROM
    sys.user$ u, sys.ind$ i, sys.obj$ o, sys.ind_stats$ ins
  WHERE
      u.user# = o.owner#
  and o.obj# = i.obj#
  and bitand(i.flags, 4096) = 0
  and i.type# in (1, 2, 3, 4, 6, 7, 8, 9)
  and i.obj# = ins.obj# (+)
  UNION ALL
  SELECT
    u.name, io.name, io.subname, ip.part#, NULL, NULL, 'PARTITION',
    ip.blevel, ip.leafcnt, ip.distkey, ip.lblkkey, ip.dblkkey,
    ip.clufac, ip.rowcnt, ins.cachedblk, ins.cachehit,
    ip.samplesize, ip.analyzetime,
    decode(bitand(ip.flags, 16), 0, 'NO', 'YES'),
    decode(bitand(ip.flags, 8), 0, 'NO', 'YES')
  FROM
    sys.obj$ io, sys.indpartv$ ip,
    sys.user$ u, sys.ind_stats$ ins
  WHERE
      io.obj# = ip.obj#
  and ip.file# > 0
  and ip.block# > 0
  and io.owner# = u.user#
  and ip.obj# = ins.obj# (+)
  UNION ALL
  SELECT
    u.name, io.name, io.subname, icp.part#, NULL, NULL, 'PARTITION',
    icp.blevel, icp.leafcnt, icp.distkey, icp.lblkkey, icp.dblkkey,
    icp.clufac, icp.rowcnt, ins.cachedblk, ins.cachehit,
    icp.samplesize, icp.analyzetime,
    decode(bitand(icp.flags, 16), 0, 'NO', 'YES'),
    decode(bitand(icp.flags, 8), 0, 'NO', 'YES')
  FROM
    obj$ io, indcompartv$ icp, user$ u, sys.ind_stats$ ins
  WHERE
      io.obj# = icp.obj#
  and io.owner# = u.user#
  and icp.obj# = ins.obj# (+)
  UNION ALL
  SELECT
    u.name, io.name, io.subname, ip.part#, NULL, NULL, 'PARTITION',
    ip.blevel, ip.leafcnt, ip.distkey, ip.lblkkey, ip.dblkkey,
    ip.clufac, ip.rowcnt, ins.cachedblk, ins.cachehit,
    ip.samplesize, ip.analyzetime,
    decode(bitand(ip.flags, 16), 0, 'NO', 'YES'),
    decode(bitand(ip.flags, 8), 0, 'NO', 'YES')
  FROM
    obj$ io, indpartv$ ip, sys.user$ u, indpart_param$ ipp,
    sys.ind_stats$ ins
  WHERE
      io.obj# = ip.obj#
  and io.owner# = u.user#
  and ip.obj# = ipp.obj#
  and ip.obj# = ins.obj# (+)
  UNION ALL
  SELECT
    u.name, po.name, po.subname, icp.part#, so.subname, isp.subpart#,
    'SUBPARTITION',
    isp.blevel, isp.leafcnt, isp.distkey, isp.lblkkey, isp.dblkkey,
    isp.clufac, isp.rowcnt, ins.cachedblk, ins.cachehit,
    isp.samplesize, isp.analyzetime,
    decode(bitand(isp.flags, 16), 0, 'NO', 'YES'),
    decode(bitand(isp.flags, 8), 0, 'NO', 'YES')
  FROM
    obj$ so, sys.obj$ po, indcompartv$ icp, indsubpartv$ isp,
    user$ u,  sys.ind_stats$ ins
  WHERE
      so.obj# = isp.obj#
  and po.obj# = icp.obj#
  and icp.obj# = isp.pobj#
  and isp.file# > 0
  and isp.block# > 0
  and u.user# = po.owner#
  and isp.obj# = ins.obj# (+);

CREATE OR REPLACE FORCE VIEW "DBA_IND_SUBPARTITIONS"("INDEX_OWNER",
select u.name, po.name, po.subname, so.subname,
       isp.hiboundval, isp.hiboundlen, isp.subpart#,
       decode(bitand(isp.flags, 1), 1, 'UNUSABLE', 'USABLE'), ts.name,
       isp.pctfree$, isp.initrans, isp.maxtrans,
       s.iniexts * ts.blocksize,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                      s.extsize * ts.blocksize),
       s.minexts, s.maxexts,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                      s.extpct),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
         decode(s.lists, 0, 1, s.lists)),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
         decode(s.groups, 0, 1, s.groups)),
       decode(mod(trunc(isp.flags / 4), 2), 0, 'YES', 'NO'),
       decode(bitand(isp.flags, 1024), 0, 'DISABLED', 1024, 'ENABLED', null),
       isp.blevel, isp.leafcnt, isp.distkey, isp.lblkkey, isp.dblkkey,
       isp.clufac, isp.rowcnt, isp.samplesize, isp.analyzetime,
       decode(s.cachehint, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL),
       decode(bitand(isp.flags, 8), 0, 'NO', 'YES'),
       decode(bitand(isp.flags, 16), 0, 'NO', 'YES')
from   sys.obj$ so, sys.obj$ po, sys.indsubpartv$ isp, sys.ts$ ts,
       sys.seg$ s, sys.user$ u
where  so.obj# = isp.obj# and po.obj# = isp.pobj# and isp.ts# = ts.ts# and
       u.user# = po.owner# and isp.file# = s.file# and isp.block# = s.block# and
       isp.ts# = s.ts#;

CREATE OR REPLACE FORCE VIEW "DBA_INTERNAL_TRIGGERS"("TABLE_NAME",
select o.name, u.name, 'DEFERRED RPC QUEUE'
from sys.tab$ t, sys.obj$ o, sys.user$ u
where t.obj# = o.obj#
      and u.user# = o.owner#
      and bitand(t.trigflag,1) = 1
union
select o.name, u.name, 'MVIEW LOG'
from sys.tab$ t, sys.obj$ o, sys.user$ u
where t.obj# = o.obj#
      and u.user# = o.owner#
      and bitand(t.trigflag,2) = 2
union
select o.name, u.name, 'UPDATABLE MVIEW LOG'
from sys.tab$ t, sys.obj$ o, sys.user$ u
where t.obj# = o.obj#
      and u.user# = o.owner#
      and bitand(t.trigflag,4) = 4
union
select o.name, u.name, 'CONTEXT'
from sys.tab$ t, sys.obj$ o, sys.user$ u
where t.obj# = o.obj#
      and u.user# = o.owner#
      and bitand(t.trigflag,8) = 8;

CREATE OR REPLACE FORCE VIEW "DBA_JAVA_ARGUMENTS"("OWNER",
select u.name, m.kln, m.mix, m.mnm, m.aix,
       m.aad,
       decode(m.abt, 10, 'int',
                     11, 'long',
                     6, 'float',
                     7, 'double',
                     4, 'boolean',
                     8, 'byte',
                     5, 'char',
                     9, 'short',
                     2, 'class',
                     NULL),
       m.aln
from sys.obj$ o, sys.x$joxfm m, sys.user$ u
where o.obj# = m.obn
  and o.type# = 29
  and o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "DBA_JAVA_CLASSES"("OWNER",
select u.name, m.kln, m.maj, m.min,
       decode(BITAND(m.acc, 512), 512, 'CLASS',
                                  0, 'INTERFACE'),
       decode(BITAND(m.acc, 1), 1, 'PUBLIC',
                                0, NULL),
       decode(BITAND(m.acc, 131072), 131072, 'YES',
                                     0, 'NO'),
       decode(BITAND(m.acc, 1024), 1024, 'YES',
                                   0, 'NO'),
       decode(BITAND(m.acc, 16), 16, 'YES',
                                 0, 'NO'),
       decode(m.dbg, 1, 'YES',
                     0, 'NO'),
       m.src, m.spl, m.oln
from sys.obj$ o, sys.x$joxfm m, sys.user$ u
where o.obj# = m.obn
  and o.type# = 29
  and o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "DBA_JAVA_DERIVATIONS"("OWNER",
select u.name,
       dbms_java.longname(t.joxftderivedfrom),
       t.joxftderivedclassnumber,
       dbms_java.longname(t.joxftderivedclassname),
       t.joxftderivedresourcenumber,
       dbms_java.longname(t.joxftderivedresourcename)
from sys.obj$ o, sys.x$joxft t, sys.user$ u
where o.obj# = t.joxftobn
  and o.type# = 29
  and t.joxftderivedfrom IS NOT NULL
  and o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "DBA_JAVA_FIELDS"("OWNER",
select u.name, m.kln, m.fix, m.fnm,
       decode(BITAND(m.fac, 7), 1, 'PUBLIC',
                                2, 'PRIVATE',
                                4, 'PROTECTED',
                                NULL),
       decode(BITAND(m.fac, 8), 8, 'YES',
                                0, 'NO'),
       decode(BITAND(m.fac, 16), 16, 'YES',
                                 0, 'NO'),
       decode(BITAND(m.fac, 64), 64, 'YES',
                                 0, 'NO'),
       decode(BITAND(m.fac, 128), 128, 'YES',
                                  0, 'NO'),
       m.fad,
       decode(m.fbt, 10, 'int',
                     11, 'long',
                     6, 'float',
                     7, 'double',
                     4, 'boolean',
                     8, 'byte',
                     5, 'char',
                     9, 'short',
                     2, 'class',
                     NULL),
       m.fln
from sys.obj$ o, sys.x$joxfm m, sys.user$ u
where o.obj# = m.obn
  and o.type# = 29
  and o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "DBA_JAVA_IMPLEMENTS"("OWNER",
select u.name, m.kln, m.ifx, m.iln
from sys.obj$ o, sys.x$joxfm m, sys.user$ u
where o.obj# = m.obn
  and o.type# = 29
  and o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "DBA_JAVA_INNERS"("OWNER",
select u.name, m.kln, m.nix, m.nsm, m.nln,
       decode(BITAND(m.oac, 7), 1, 'PUBLIC',
                                2, 'PRIVATE',
                                4, 'PROTECTED',
                                NULL),
       decode(BITAND(m.acc, 8), 8, 'YES',
                                0, 'NO'),
       decode(BITAND(m.acc, 16), 16, 'YES',
                                 0, 'NO'),
       decode(BITAND(m.acc, 1024), 1024, 'YES',
                                   0, 'NO'),
       decode(BITAND(m.acc, 512), 512, 'YES',
                                  0, 'NO')
from sys.obj$ o, sys.x$joxfm m, sys.user$ u
where o.obj# = m.obn
  and o.type# = 29
  and o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "DBA_JAVA_LAYOUTS"("OWNER",
select u.name, m.kln, m.lic, m.lnc,
              m.lfc, m.lsf,
              m.lmc, m.lsm, m.jnc
from sys.obj$ o, sys.x$joxfm m, sys.user$ u
where o.obj# = m.obn
  and o.type# = 29
  and o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "DBA_JAVA_METHODS"("OWNER",
select u.name, m.kln, m.mix, m.mnm,
       decode(BITAND(m.mac, 7), 1, 'PUBLIC',
                                2, 'PRIVATE',
                                4, 'PROTECTED',
                                NULL),
       decode(BITAND(m.mac, 8), 8, 'YES',
                                0, 'NO'),
       decode(BITAND(m.mac, 16), 16, 'YES',
                                 0, 'NO'),
       decode(BITAND(m.mac, 32), 32, 'YES',
                                 0, 'NO'),
       decode(BITAND(m.mac, 256), 256, 'YES',
                                  0, 'NO'),
       decode(BITAND(m.mac, 1024), 1024, 'YES',
                                   0, 'NO'),
       decode(BITAND(m.mac, 2048), 2048, 'YES',
                                   0, 'NO'),
       m.agc, m.exc, m.rad,
       decode(m.rbt, 10, 'int',
                     11, 'long',
                     6,  'float',
                     7,  'double',
                     4,  'boolean',
                     8,  'byte',
                     5,  'char',
                     9,  'short',
                     2,  'class',
                     12, 'void',
                     NULL),
       m.rln
from sys.obj$ o, sys.x$joxfm m, sys.user$ u
where o.obj# = m.obn
  and o.type# = 29
  and o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "DBA_JAVA_NCOMPS"("OWNER",
select u.name,
       dbms_java.longname(o.name),
       t.joxftncompsource,
       t.joxftncompinitializer,
       t.joxftncomplibraryfile,
       t.joxftncomplibrary
from sys.obj$ o, sys.x$joxft t, sys.user$ u
where o.obj# = t.joxftobn
  and o.type# = 29
  and o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "DBA_JAVA_POLICY"("KIND",
select
   decode(jp.kind#, 0, 'GRANT', 1, 'RESTRICT'),
   u.name,
   ut.name,
   jp.type_name,
   jp.name,
   jp.action,
   decode(jp.status#, 2, 'ENABLED', 3, 'DISABLED'),
   jp.key
from
  java$policy$ jp, sys.user$ u, sys.user$ ut
where
  jp.grantee# = u.user# and jp.type_schema# = ut.user#
order by u.name, ut.name, jp.type_name, jp.name, jp.action;

CREATE OR REPLACE FORCE VIEW "DBA_JAVA_RESOLVERS"("OWNER",
select u.name,
       dbms_java.longname(o.name),
       t.joxftresolvertermnumber,
       t.joxftresolvertermpattern,
       t.joxftresolvertermschema
from sys.obj$ o, sys.x$joxft t, sys.user$ u
where o.obj# = t.joxftobn
  and o.type# = 29
  and o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "DBA_JAVA_THROWS"("OWNER",
select u.name, m.kln, m.mix, m.mnm, m.xix, m.xln
from sys.obj$ o, sys.x$joxfm m, sys.user$ u
where o.obj# = m.obn
  and o.type# = 29
  and o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "DBA_JOBS"("JOB",
select JOB, lowner LOG_USER, powner PRIV_USER, cowner SCHEMA_USER,
    LAST_DATE, substr(to_char(last_date,'HH24:MI:SS'),1,8) LAST_SEC,
    THIS_DATE, substr(to_char(this_date,'HH24:MI:SS'),1,8) THIS_SEC,
    NEXT_DATE, substr(to_char(next_date,'HH24:MI:SS'),1,8) NEXT_SEC,
    (total+(sysdate-nvl(this_date,sysdate)))*86400 TOTAL_TIME,
    decode(mod(FLAG,2),1,'Y',0,'N','?') BROKEN,
    INTERVAL# interval, FAILURES, WHAT,
    nlsenv NLS_ENV, env MISC_ENV, j.field1 INSTANCE
  from sys.job$ j;

CREATE OR REPLACE FORCE VIEW "DBA_JOBS_RUNNING"("SID",
select v.SID, v.id2 JOB, j.FAILURES,
    LAST_DATE, substr(to_char(last_date,'HH24:MI:SS'),1,8) LAST_SEC,
    THIS_DATE, substr(to_char(this_date,'HH24:MI:SS'),1,8) THIS_SEC,
    j.field1 INSTANCE
  from sys.job$ j, v$lock v
  where v.type = 'JQ' and j.job (+)= v.id2;

CREATE OR REPLACE FORCE VIEW "DBA_JOIN_IND_COLUMNS"("INDEX_OWNER",
select
  ui.name, oi.name,
  uti.name, oti.name, ci.name,
  uto.name, oto.name, co.name
from
  sys.user$ ui, sys.user$ uti, sys.user$ uto,
  sys.obj$ oi, sys.obj$ oti, sys.obj$ oto,
  sys.col$ ci, sys.col$ co,
  sys.jijoin$ ji
where ji.obj# = oi.obj#
  and oi.owner# = ui.user#
  and ji.tab1obj# = oti.obj#
  and oti.owner# = uti.user#
  and ci.obj# = oti.obj#
  and ji.tab1col# = ci.intcol#
  and ji.tab2obj# = oto.obj#
  and oto.owner# = uto.user#
  and co.obj# = oto.obj#
  and ji.tab2col# = co.intcol#;

CREATE OR REPLACE FORCE VIEW "DBA_KEEPSIZES"("TOTSIZE",
select trunc((sum(parsed_size)+sum(code_size))/1000),
         owner, name
  from dba_object_size
  where type in ('PACKAGE','PROCEDURE','FUNCTION','PACKAGE BODY','TRIGGER',
                 'JAVA SOURCE','JAVA CLASS','JAVA RESOURCE','JAVA DATA')
  group by owner, name;

CREATE OR REPLACE FORCE VIEW "DBA_KGLLOCK"("KGLLKUSE",
select kgllkuse, kgllkhdl, kgllkmod, kgllkreq, 'Lock' kgllktype from x$kgllk
 union all
  select kglpnuse, kglpnhdl, kglpnmod, kglpnreq, 'Pin'  kgllktype from x$kglpn;

CREATE OR REPLACE FORCE VIEW "DBA_LIBRARIES"("OWNER",
select u.name,
       o.name,
       l.filespec,
       decode(bitand(l.property, 1), 0, 'Y', 1, 'N', NULL),
       decode(o.status, 0, 'N/A', 1, 'VALID', 'INVALID')
from sys.obj$ o, sys.library$ l, sys.user$ u
where o.owner# = u.user#
  and o.obj# = l.obj#;

CREATE OR REPLACE FORCE VIEW "DBA_LMT_FREE_SPACE"("TABLESPACE_ID",
select  ktfbfetsn, ktfbfefno, ktfbfebno, ktfbfeblks
from    x$ktfbfe;

CREATE OR REPLACE FORCE VIEW "DBA_LMT_USED_EXTENTS"("SEGMENT_FILEID",
select  u.ktfbuesegfno, u.ktfbuesegbno, u.ktfbuesegtsn,
        u.ktfbueextno, u.ktfbuefno, u.ktfbuebno, u.ktfbueblks
from    sys.x$ktfbue u
where   not exists (select * from sys.recyclebin$ rb
                    where u.ktfbuesegtsn = rb.ts#
                      and u.ktfbuesegfno = rb.file#
                      and u.ktfbuesegbno = rb.block#);

CREATE OR REPLACE FORCE VIEW "DBA_LOBS"("OWNER",
select u.name, o.name,
       decode(bitand(c.property, 1), 1, ac.name, c.name), lo.name,
       decode(bitand(l.property, 8), 8, ts1.name, ts.name),
       io.name,
       l.chunk * decode(bitand(l.property, 8), 8, ts1.blocksize,
                        ts.blocksize),
       decode(l.pctversion$, 101, to_number(NULL), 102, to_number(NULL),
                                   l.pctversion$),
       decode(l.retention, -1, to_number(NULL), l.retention),
       decode(l.freepools, 0, to_number(NULL), 65534, to_number(NULL),
              65535, to_number(NULL), l.freepools),
       decode(bitand(l.flags, 27), 1, 'NO', 2, 'NO', 8, 'CACHEREADS',
                                   16, 'CACHEREADS', 'YES'),
       decode(bitand(l.flags, 18), 2, 'NO', 16, 'NO', 'YES'),
       decode(bitand(l.property, 2), 2, 'YES', 'NO'),
       decode(c.type#, 113, 'NOT APPLICABLE ',
              decode(bitand(l.property, 512), 512,
                     'ENDIAN SPECIFIC', 'ENDIAN NEUTRAL ')),
       decode(bitand(ta.property, 32), 32, 'YES', 'NO')
from sys.obj$ o, sys.col$ c, sys.attrcol$ ac, sys.tab$ ta, sys.lob$ l,
     sys.obj$ lo, sys.obj$ io, sys.user$ u, sys.ts$ ts, sys.ts$ ts1
where o.owner# = u.user#
  and o.obj# = c.obj#
  and c.obj# = l.obj#
  and c.intcol# = l.intcol#
  and l.lobj# = lo.obj#
  and l.ind# = io.obj#
  and l.ts# = ts.ts#(+)
  and u.tempts# = ts1.ts#
  and c.obj# = ac.obj#(+)
  and c.intcol# = ac.intcol#(+)
  and bitand(c.property,32768) != 32768           /* not unused column */
  and o.obj# = ta.obj#
  and bitand(ta.property, 32) != 32           /* not partitioned table */
union all
select u.name, o.name,
       decode(bitand(c.property, 1), 1, ac.name, c.name),
       lo.name,
       decode(null, plob.defts#, ts2.name, ts1.name),
       io.name,
       plob.defchunk * (decode(null, plob.defts#,
                               ts2.blocksize, ts1.blocksize)),
       decode(plob.defpctver$, 101, to_number(NULL), 102, to_number(NULL),
                                           plob.defpctver$),
       decode(l.retention, -1, to_number(NULL), l.retention),
       decode(l.freepools, 0, to_number(NULL), 65534, to_number(NULL),
              65535, to_number(NULL), l.freepools),
       decode(bitand(plob.defflags, 27), 1, 'NO', 2, 'NO', 8, 'CACHEREADS',
                                         16, 'CACHEREADS', 'YES'),
       decode(bitand(plob.defflags,22), 0,'NONE', 4,'YES', 2,'NO',
                                        16,'NO', 'UNKNOWN'),
       decode(bitand(plob.defpro, 2), 2, 'YES', 'NO'),
       decode(c.type#, 113, 'NOT APPLICABLE ',
              decode(bitand(l.property, 512), 512,
                     'ENDIAN SPECIFIC', 'ENDIAN NEUTRAL ')),
       decode(bitand(ta.property, 32), 32, 'YES', 'NO')
from sys.obj$ o, sys.col$ c, sys.attrcol$ ac, sys.partlob$ plob,
     sys.lob$ l, sys.obj$ lo, sys.obj$ io, sys.ts$ ts1, sys.tab$ ta,
     sys.partobj$ po, sys.ts$ ts2, sys.user$ u
where o.owner# = u.user#
  and o.obj# = c.obj#
  and c.obj# = l.obj#
  and c.intcol# = l.intcol#
  and l.lobj# = lo.obj#
  and l.ind# = io.obj#
  and l.lobj# = plob.lobj#
  and plob.defts# = ts1.ts# (+)
  and c.obj# = ac.obj#(+)
  and c.intcol# = ac.intcol#(+)
  and bitand(c.property,32768) != 32768           /* not unused column */
  and o.obj# = ta.obj#
  and bitand(ta.property, 32) = 32                /* partitioned table */
  and o.obj# = po.obj#
  and po.defts# = ts2.ts#;

CREATE OR REPLACE FORCE VIEW "DBA_LOB_PARTITIONS"("TABLE_OWNER",
select u.name,
       o.name,
       decode(bitand(c.property, 1), 1, a.name, c.name),
       lo.name,
       po.subname,
       lpo.subname,
       lipo.subname,
       lf.frag#,
       'NO',
       lf.chunk * ts.blocksize,
       lf.pctversion$,
       decode(bitand(lf.fragflags,27), 1, 'NO', 2, 'NO', 8, 'CACHEREADS',
                                       16, 'CACHEREADS', 'YES'),
       decode(lf.fragpro, 0, 'NO', 'YES'),
       ts.name,
       to_char(s.iniexts * ts.blocksize),
       to_char(decode(bitand(ts.flags, 3), 1, to_number(NULL),
            s.extsize * ts.blocksize)),
       to_char(s.minexts),
       to_char(s.maxexts),
       to_char(decode(bitand(ts.flags, 3), 1, to_number(NULL),s.extpct)),
       to_char(decode(s.lists, 0, 1, s.lists)),
       to_char(decode(s.groups, 0, 1, s.groups)),
       decode(bitand(lf.fragflags, 18), 2, 'NO', 16, 'NO', 'YES'),
       decode(s.cachehint, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL)
from   sys.obj$ o, sys.col$ c,
       sys.lob$ l, sys.obj$ lo,
       sys.lobfragv$ lf, sys.obj$ lpo,
       sys.obj$ po, sys.obj$ lipo,
       sys.partobj$ pobj,
       sys.ts$ ts, sys.seg$ s, sys.user$ u, attrcol$ a
where o.owner# = u.user#
  and pobj.obj# = o.obj#
  and mod(pobj.spare2, 256) = 0
  and o.obj# = c.obj#
  and c.obj# = l.obj#
  and c.intcol# = l.intcol#
  and l.lobj# = lo.obj#
  and l.lobj# = lf.parentobj#
  and lf.tabfragobj# = po.obj#
  and lf.fragobj# = lpo.obj#
  and lf.indfragobj# = lipo.obj#
  and lf.ts# = s.ts#
  and lf.file# = s.file#
  and lf.block# = s.block#
  and lf.ts# = ts.ts#
  and bitand(c.property,32768) != 32768           /* not unused column */
  and c.obj# = a.obj#(+) and c.intcol# = a.intcol#(+)
union all
select u.name,
       o.name,
       decode(bitand(c.property, 1), 1, a.name, c.name),
       lo.name,
       po.subname,
       lpo.subname,
       lipo.subname,
       lcp.part#,
       'YES',
       lcp.defchunk,
       lcp.defpctver$,
       decode(bitand(lcp.defflags, 27), 1, 'NO', 2, 'NO', 8, 'CACHEREADS',
                                       16, 'CACHEREADS', 'YES'),
       decode(lcp.defpro, 0, 'NO', 'YES'),
       ts.name,
       decode(lcp.definiexts, NULL, 'DEFAULT', lcp.definiexts),
       decode(lcp.defextsize, NULL, 'DEFAULT', lcp.defextsize),
       decode(lcp.defminexts, NULL, 'DEFAULT', lcp.defminexts),
       decode(lcp.defmaxexts, NULL, 'DEFAULT', lcp.defmaxexts),
       decode(lcp.defextpct,  NULL, 'DEFAULT', lcp.defextpct),
       decode(lcp.deflists,   NULL, 'DEFAULT', lcp.deflists),
       decode(lcp.defgroups,  NULL, 'DEFAULT', lcp.defgroups),
       decode(bitand(lcp.defflags,22), 0,'NONE', 4,'YES', 2,'NO', 16,'NO', 'UNKNOWN'),
       decode(lcp.defbufpool, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL)
from   sys.obj$ o, sys.col$ c,
       sys.lob$ l, sys.obj$ lo,
       sys.lobcomppartv$ lcp, sys.obj$ lpo,
       sys.obj$ po, sys.obj$ lipo,
       sys.ts$ ts, partobj$ pobj, sys.user$ u, attrcol$ a
where o.owner# = u.user#
  and pobj.obj# = o.obj#
  and mod(pobj.spare2, 256) != 0
  and o.obj# = c.obj#
  and c.obj# = l.obj#
  and c.intcol# = l.intcol#
  and l.lobj# = lo.obj#
  and l.lobj# = lcp.lobj#
  and lcp.tabpartobj# = po.obj#
  and lcp.partobj# = lpo.obj#
  and lcp.indpartobj# = lipo.obj#
  and lcp.defts# = ts.ts# (+)
  and bitand(c.property,32768) != 32768           /* not unused column */
  and c.obj# = a.obj#(+) and c.intcol# = a.intcol#(+);

CREATE OR REPLACE FORCE VIEW "DBA_LOB_SUBPARTITIONS"("TABLE_OWNER",
select u.name,
       o.name,
       decode(bitand(c.property, 1), 1, a.name, c.name),
       lo.name,
       lpo.subname,
       spo.subname,
       lspo.subname,
       lispo.subname,
       lf.frag#,
       lf.chunk * ts.blocksize,
       lf.pctversion$,
       decode(bitand(lf.fragflags,27), 1, 'NO', 2, 'NO', 8, 'CACHEREADS',
                                       16, 'CACHEREADS', 'YES'),
       decode(lf.fragpro, 0, 'NO', 'YES'),
       ts.name,
       s.iniexts * ts.blocksize,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
            s.extsize * ts.blocksize),
       s.minexts,
       s.maxexts,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),s.extpct),
       decode(s.lists, 0, 1, s.lists),
       decode(s.groups, 0, 1, s.groups),
       decode(bitand(lf.fragflags, 18), 2, 'NO', 16, 'NO', 'YES'),
       decode(s.cachehint, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL)
from   sys.obj$ o, sys.col$ c,
       sys.lob$ l, sys.obj$ lo,
       sys.lobcomppartv$ lcp, sys.obj$ lpo,
       sys.lobfragv$ lf, sys.obj$ lspo,
       sys.obj$ spo, sys.obj$ lispo,
       sys.partobj$ pobj,
       sys.ts$ ts, sys.seg$ s, sys.user$ u, attrcol$ a
where o.owner# = u.user#
  and pobj.obj# = o.obj#
  and mod(pobj.spare2, 256) != 0
  and o.obj# = c.obj#
  and c.obj# = l.obj#
  and c.intcol# = l.intcol#
  and l.lobj# = lo.obj#
  and l.lobj# = lcp.lobj#
  and lcp.partobj# = lpo.obj#
  and lf.parentobj# = lcp.partobj#
  and lf.tabfragobj# = spo.obj#
  and lf.fragobj# = lspo.obj#
  and lf.indfragobj# = lispo.obj#
  and lf.ts# = s.ts#
  and lf.file# = s.file#
  and lf.block# = s.block#
  and lf.ts# = ts.ts#
  and bitand(c.property,32768) != 32768           /* not unused column */
  and c.obj# = a.obj#(+) and c.intcol# = a.intcol#(+);

CREATE OR REPLACE FORCE VIEW "DBA_LOB_TEMPLATES"("USER_NAME",
select u.name, o.name, decode(bitand(c.property, 1), 1, ac.name, c.name),
       st.spart_name, lst.lob_spart_name, ts.name
from sys.obj$ o, sys.defsubpart$ st, sys.defsubpartlob$ lst, sys.ts$ ts,
     sys.col$ c, sys.attrcol$ ac, sys.user$ u
where o.obj# = lst.bo# and st.bo# = lst.bo# and
      st.spart_position =  lst.spart_position and
      lst.lob_spart_ts# = ts.ts#(+) and c.obj# = lst.bo# and
      c.intcol# = lst.intcol# and lst.intcol# = ac.intcol#(+) and
      o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "DBA_LOCK"("SESSION_ID",
select
	sid session_id,
	decode(type,
		'MR', 'Media Recovery',
		'RT', 'Redo Thread',
		'UN', 'User Name',
		'TX', 'Transaction',
		'TM', 'DML',
		'UL', 'PL/SQL User Lock',
		'DX', 'Distributed Xaction',
		'CF', 'Control File',
		'IS', 'Instance State',
		'FS', 'File Set',
		'IR', 'Instance Recovery',
		'ST', 'Disk Space Transaction',
		'TS', 'Temp Segment',
		'IV', 'Library Cache Invalidation',
		'LS', 'Log Start or Switch',
		'RW', 'Row Wait',
		'SQ', 'Sequence Number',
		'TE', 'Extend Table',
		'TT', 'Temp Table',
		type) lock_type,
	decode(lmode,
		0, 'None',           /* Mon Lock equivalent */
		1, 'Null',           /* N */
		2, 'Row-S (SS)',     /* L */
		3, 'Row-X (SX)',     /* R */
		4, 'Share',          /* S */
		5, 'S/Row-X (SSX)',  /* C */
		6, 'Exclusive',      /* X */
		to_char(lmode)) mode_held,
         decode(request,
		0, 'None',           /* Mon Lock equivalent */
		1, 'Null',           /* N */
		2, 'Row-S (SS)',     /* L */
		3, 'Row-X (SX)',     /* R */
		4, 'Share',          /* S */
		5, 'S/Row-X (SSX)',  /* C */
		6, 'Exclusive',      /* X */
		to_char(request)) mode_requested,
         to_char(id1) lock_id1, to_char(id2) lock_id2,
	 ctime last_convert,
	 decode(block,
	        0, 'Not Blocking',  /* Not blocking any other processes */
		1, 'Blocking',      /* This lock blocks other processes */
		2, 'Global',        /* This lock is global, so we can't tell */
		to_char(block)) blocking_others
      from v$lock;

CREATE OR REPLACE FORCE VIEW "DBA_LOCK_INTERNAL"("SESSION_ID",
select
	sid session_id,
	decode(type,
		'MR', 'Media Recovery',
		'RT', 'Redo Thread',
		'UN', 'User Name',
		'TX', 'Transaction',
		'TM', 'DML',
		'UL', 'PL/SQL User Lock',
		'DX', 'Distributed Xaction',
		'CF', 'Control File',
		'IS', 'Instance State',
		'FS', 'File Set',
		'IR', 'Instance Recovery',
		'ST', 'Disk Space Transaction',
		'TS', 'Temp Segment',
		'IV', 'Library Cache Invalidation',
		'LS', 'Log Start or Switch',
		'RW', 'Row Wait',
		'SQ', 'Sequence Number',
		'TE', 'Extend Table',
		'TT', 'Temp Table',
		type) lock_type,
	decode(lmode,
		0, 'None',           /* Mon Lock equivalent */
		1, 'Null',           /* N */
		2, 'Row-S (SS)',     /* L */
		3, 'Row-X (SX)',     /* R */
		4, 'Share',          /* S */
		5, 'S/Row-X (SSX)',  /* C */
		6, 'Exclusive',      /* X */
		to_char(lmode)) mode_held,
         decode(request,
		0, 'None',           /* Mon Lock equivalent */
		1, 'Null',           /* N */
		2, 'Row-S (SS)',     /* L */
		3, 'Row-X (SX)',     /* R */
		4, 'Share',          /* S */
		5, 'S/Row-X (SSX)',  /* C */
		6, 'Exclusive',      /* X */
		to_char(request)) mode_requested,
         to_char(id1) lock_id1, to_char(id2) lock_id2
      from v$lock                /* processes waiting on or holding enqueues */
 union all                                          /* procs holding latches */
  select s.sid, 'LATCH', 'Exclusive', 'None', rawtohex(laddr), ' '
    from v$process p, v$session s, v$latchholder h
   where h.pid  = p.pid                       /* 6 = exclusive, 0 = not held */
    and  p.addr = s.paddr
 union all                                         /* procs waiting on latch */
  select sid, 'LATCH', 'None', 'Exclusive', rawtohex(latchwait), ' '
     from v$session s, v$process p
    where latchwait is not null
     and  p.addr = s.paddr
 union all                                            /* library cache locks */
  select  s.sid,
    decode(ob.kglhdnsp, 0, 'Cursor', 1, 'Table/Procedure/Type', 2, 'Body',
	     3, 'trigger', 4, 'Index', 5, 'Cluster', 13, 'Java Source',
             14, 'Java Resource', 32, 'Java Data', to_char(ob.kglhdnsp))
	  || ' Definition ' || lk.kgllktype,
    decode(lk.kgllkmod, 0, 'None', 1, 'Null', 2, 'Share', 3, 'Exclusive',
	   to_char(lk.kgllkmod)),
    decode(lk.kgllkreq,  0, 'None', 1, 'Null', 2, 'Share', 3, 'Exclusive',
	   to_char(lk.kgllkreq)),
    decode(ob.kglnaown, null, '', ob.kglnaown || '.') || ob.kglnaobj ||
    decode(ob.kglnadlk, null, '', '@' || ob.kglnadlk),
    rawtohex(lk.kgllkhdl)
   from v$session s, x$kglob ob, dba_kgllock lk
     where lk.kgllkhdl = ob.kglhdadr
      and  lk.kgllkuse = s.saddr;

CREATE OR REPLACE FORCE VIEW "DBA_LOGMNR_LOG"("LOGMNR_SESSION_ID",
select
                  l.session#                    logmnr_session_id,
                  l.file_name                   name,
                  l.db_id                       dbid,
                  l.resetlogs_change#           resetlogs_scn,
                  l.reset_timestamp             resetlogs_time,
                  l.timestamp                   modified_time,
                  l.thread#                     thread#,
                  l.sequence#                   sequence#,
                  l.first_change#               first_scn,
                  l.next_change#                next_scn,
                  l.first_time                  first_time,
                  l.next_time                   next_time,
                  l.dict_begin                  dictionary_begin,
                  l.dict_end                    dictionary_end,
                  case
                  when (bitand(l.status, 2) = 2) then
                   'NO'
                  else
                   'YES'
                  end                           keep,
                  case
                  when (bitand(l.status, 4) = 4) then
                   'YES'
                  else
                   'N0'
                  end                           suspect

                from system.logmnr_log$ l;

CREATE OR REPLACE FORCE VIEW "DBA_LOGMNR_PURGED_LOG"("FILE_NAME") AS 
select distinct p.file_name from system.logmnr_log$ p
    where bitand(p.status, 2) = 2 and
    dbms_logmnr_internal.logmnr_krvicl(p.file_name) = 1
  minus
  select distinct q.file_name from system.logmnr_log$ q
    where bitand(q.status, 2) <> 2;

CREATE OR REPLACE FORCE VIEW "DBA_LOGMNR_SESSION"("ID",
select
        s.session#              id,
        s.session_name          name,
        s.global_db_name        source_database,
        s.db_id                 source_dbid,
        s.resetlogs_change#     source_resetlogs_scn,
        s.reset_timestamp       source_resetlogs_time,
        s.start_scn             first_scn,
        s.end_scn               end_scn,
        s.branch_scn            branch_scn,
        case
         when (bitand(s.session_attr, 16) = 16) then 'YES'
         else  'NO'
        end                     wait_for_log,
        case
          when (bitand(s.session_attr, 8388608) = 8388608) then 'YES'
         else  'NO'
        end                     hot_mine,
        /* safe_purge_scn is the scn below or at which it is safe to purge */
        /* pass this scn into dbms_logmnr_session.purge_session */
        case /* case#0 :streams or logical standby */
             /* KRVX_RESTART_CKPT_ENABLED = 268435456 */
          when (bitand(s.session_attr, 268435456) = 268435456) then
	    null
          else /* case #0 */
            s.spill_scn
          end    /* case #0 */
                                      safe_purge_scn,
        case /* case#0 :streams or logical standby */
          when (bitand(s.session_attr, 268435456) = 268435456) then
  	    get_max_checkpoint(s.session#)
          else
            null
          end
                                        checkpoint_scn
      from system.logmnr_session$ s;

CREATE OR REPLACE FORCE VIEW "DBA_LOGSTDBY_EVENTS"("EVENT_TIME",
select event_time, current_scn, commit_scn,
         xidusn, xidslt, xidsqn, full_event event,
         errval status_code, error status
  from system.logstdby$events;

CREATE OR REPLACE FORCE VIEW "DBA_LOGSTDBY_HISTORY"("STREAM_SEQUENCE#",
select stream_sequence#, decode(status, 1, 'Past', 2, 'Immediate Past', 3,
         'Current', 4, 'Immediate Future', 5, 'Future', 6, 'Canceled', 7,
         'Invalid') status, decode(source, 1, 'Rfs', 2, 'User', 3, 'Synch', 4,
         'Redo') source, dbid, first_change#, last_change#, first_time,
         last_time, dgname
  from system.logstdby$history;

CREATE OR REPLACE FORCE VIEW "DBA_LOGSTDBY_LOG"("THREAD#",
select thread#, sequence#, first_change#, next_change#,
         first_time, next_time, file_name, timestamp, dict_begin, dict_end,
    (case when l.next_change# < p.read_scn then 'YES'
          when l.first_change# < p.applied_scn then 'CURRENT'
          else 'NO' end) applied
  from system.logmnr_log$ l, dba_logstdby_progress p
  where session# =
        (select value from system.logstdby$parameters where name = 'LMNR_SID');

CREATE OR REPLACE FORCE VIEW "DBA_LOGSTDBY_NOT_UNIQUE"("OWNER",
select owner, name table_name,
         decode((select count(c.obj#)
                 from sys.col$ c
                 where c.obj# = l.obj#
                     and c.type# in (8,                              /* LONG */
                                     24,                         /* LONG RAW */
                                     112,                            /* CLOB */
                                     113)),                          /* BLOB */
                 0, 'N', 'Y') bad_column
  from logstdby_support l
  where generated_sby = 1
    and type# = 2
    and not exists                                    /* not null unique key */
       (select null
        from ind$ i, icol$ ic, col$ c
        where i.bo# = l.obj#
          and ic.obj# = i.obj#
          and c.col# = ic.col#
          and c.obj# = i.bo#
          and c.null$ > 0
          and i.type# = 1
          and bitand(i.property, 1) = 1)
    and not exists                            /* primary key rely constraint */
       (select null
        from cdef$ cd
        where cd.obj# = l.obj#
          and cd.type# = 2
          and bitand(cd.defer, 32) = 32);

CREATE OR REPLACE FORCE VIEW "DBA_LOGSTDBY_PARAMETERS"("NAME",
select name, value from system.logstdby$parameters
  where name != 'SHUTDOWN'
    and name != 'SEED_PRIMARY_DBID'
    and name != 'SEED_FIRST_SCN'
    and (type < 2 or type is null);

CREATE OR REPLACE FORCE VIEW "DBA_LOGSTDBY_PROGRESS"("APPLIED_SCN",
select
    applied_scn,
    /* thread# derived from applied_scn */
    (select min(thread#) from logstdby_log
     where sequence# =
       (select max(sequence#) from logstdby_log l
        where applied_scn >= first_change# and applied_scn <= next_change#)
    and applied_scn >= first_change#
    and applied_scn <= next_change#)
       applied_thread#,
    /* sequence# derived from applied_scn */
    (select max(sequence#) from logstdby_log l
     where applied_scn >= first_change# and applied_scn <= next_change#)
       applied_sequence#,
    /* estimated time derived from applied_scn */
    (select max(first_time +
        ((next_time - first_time) / (next_change# - first_change#) *
         (applied_scn - first_change#)))
     from logstdby_log l
     where applied_scn >= first_change# and applied_scn <= next_change#)
       applied_time,
    read_scn,
    /* thread# derived from read_scn */
    (select min(thread#) from logstdby_log
     where sequence# =
       (select max(sequence#) from logstdby_log l
        where read_scn >= first_change# and read_scn <= next_change#)
     and read_scn >= first_change#
     and read_scn <= next_change#)
       read_thread#,
    /* sequence# derived from read_scn */
    (select max(sequence#) from logstdby_log l
     where read_scn >= first_change# and read_scn <= next_change#)
       read_sequence#,
    /* estimated time derived from read_scn */
    (select min(first_time +
        ((next_time - first_time) / (next_change# - first_change#) *
         (read_scn - first_change#)))
     from logstdby_log l
     where read_scn >= first_change# and read_scn <= next_change#)
       read_time,
    newest_scn,
    /* thread# derived from newest_scn */
    (select min(thread#) from logstdby_log
     where sequence# =
       (select max(sequence#) from logstdby_log l
        where newest_scn >= first_change# and newest_scn <= next_change#)
     and newest_scn >= first_change#
     and newest_scn <= next_change#)
       newest_thread#,
    /* sequence# derived from newest_scn */
    (select max(sequence#) from logstdby_log l
     where newest_scn >= first_change# and newest_scn <= next_change#)
       newest_sequence#,
    /* estimated time derived from newest_scn */
    (select max(first_time +
        ((next_time - first_time) / (next_change# - first_change#) *
         (newest_scn - first_change#)))
     from logstdby_log l
     where newest_scn >= first_change# and newest_scn <= next_change#)
       newest_time
  from
    /* in-line view to calculate relavent scn values */
    (select /* APPLIED_SCN */
            greatest(nvl((select max(a.processed_scn) - 1
                          from system.logstdby$apply_milestone a),0),
                     nvl((select max(a.commit_scn)
                          from system.logstdby$apply_milestone a),0),
                     sx.start_scn) applied_scn,
            /* READ_SCN */
            greatest(nvl(sx.spill_scn,1), sx.start_scn) read_scn,
            /* NEWEST_SCN */
            nvl((select max(next_change#)-1 from logstdby_log),
                sx.start_scn) newest_scn
    from system.logmnr_session$ sx
    where sx.session# =
      (select value from system.logstdby$parameters where name = 'LMNR_SID')) x;

CREATE OR REPLACE FORCE VIEW "DBA_LOGSTDBY_SKIP"("ERROR",
select "ERROR",
     select decode(error, 1, 'Y', 'N') error,
           statement_opt, schema owner, name,
           decode(use_like, 0, 'N', 'Y') use_like, esc, proc
     from system.logstdby$skip
    union all
     select 'N' error,
           'INTERNAL SCHEMA' statement_opt, username owner, '%' name,
           'Y' use_like, null esc, null proc
     from (select username from dba_users u,
             ((select schema name from dba_server_registry d
               union all
               select s.name from system.logstdby$skip_support s
               where s.action = 0)
              minus
               select s.name from system.logstdby$skip_support s
               where s.action = -1) i
           where u.username = i.name));

CREATE OR REPLACE FORCE VIEW "DBA_LOGSTDBY_SKIP_TRANSACTION"("XIDUSN",
select xidusn, xidslt, xidsqn
  from system.logstdby$skip_transaction;

CREATE OR REPLACE FORCE VIEW "DBA_LOGSTDBY_UNSUPPORTED"("OWNER",
select c.owner, c.table_name, c.column_name, c.data_type,
    (case when bitand(tprop, 128) = 128
          then 'IOT with Overflow'
          when bitand(tprop, 262208) = 262208
          then 'IOT with LOB' /* user lob */
          when bitand(tflags, 536870912) = 536870912
          then 'Mapping table for physical rowid of IOT'
          when bitand(tprop, 2112) = 2112
          then 'IOT with LOB' /* internal lob */
          when (bitand(tprop, 64) = 64
           and bitand(tflags, 131072) = 131072)
          then 'IOT with row movement'
          when bitand(segspare1, 2048) = 2048
          then 'Table Compression'
          when bitand(tprop, 1) = 1
          then 'Object Table' /* typed table/object table */
          else null end) attributes, tprop, segspare1, tflags
  from
(select u.name owner, o.name table_name, c.name column_name, c.type#,
  o.obj#, t.property tprop, t.flags tflags, nvl(s.spare1,0) segspare1,
/* BEGIN SECTION 1 COMMON CODE: LOGSTDBY_SUPPORT - DBA_LOGSTDBY_UNSUPPORTED */
 (case
    /* The following are tables that are in an internal schema or
     * are tables like object not visible to the user or
     * are tables we support indirectly like an mv log or
     * are nested tables for which joining together column info eludes me. */
  when ((exists (select 1 from dba_server_registry d where d.schema = u.name)
         or
         exists (select 1 from system.logstdby$skip_support s
                 where s.name = u.name and action = 0))
        and not exists
               (select 1 from system.logstdby$skip_support s
                where s.name = u.name and action = -1))
    or bitand(o.flags,
                2                                       /* temporary object */
              + 4                                /* system generated object */
              + 16                                      /* secondary object */
              + 32                                  /* in-memory temp table */
              + 128                           /* dropped table (RecycleBin) */
             ) != 0
    or bitand(t.flags,
                262144     /* 0x00040000        Summary Container Table, MV */
              + 134217728  /* 0x08000000          in-memory temporary table */
             ) != 0
    or bitand(t.property,
                512        /* 0x00000200               iot OVeRflow segment */
              + 8192       /* 0x00002000                       nested table */
              + 131072     /* 0x00020000 table is used as an AQ queue table */
              + 4194304    /* 0x00400000             global temporary table */
              + 8388608    /* 0x00800000   session-specific temporary table */
              + 33554432   /* 0x02000000        Read Only Materialized View */
              + 67108864   /* 0x04000000            Materialized View table */
              + 134217728  /* 0x08000000                    Is a Sub object */
              + 2147483648 /* 0x80000000                     eXternal TaBle */
             ) != 0
    or exists                                                /* MVLOG table */
       (select 1
        from sys.mlog$ ml where ml.mowner = u.name and ml.log = o.name)
  then -1
    /* The following tables are user visible tables that we choose to
     * skip because of some unsupported attribute of the table or column */
  when bitand(t.property,
                  1        /* 0x00000001                        typed table */
              + 128        /* 0x00000080              IOT with row overflow */
              + 256        /* 0x00000100            IOT with row clustering */
             ) != 0
    or bitand(t.flags,
                536870912  /* 0x20000000  Mapping Tab for Phys rowid of IOT */
             ) != 0
    or bitand(t.property, 262208) = 262208   /* 0x40+0x40000 IOT + user LOB */
    or bitand(t.property, 2112) = 2112     /* 0x40+0x800 IOT + internal LOB */
    or                                           /* IOT with "Row Movement" */
       (bitand(t.property, 64) = 64 and bitand(t.flags, 131072) = 131072)
    or                                                       /* Compression */
       (bitand(nvl(s.spare1,0), 2048) = 2048 and bitand(t.property, 32) != 32)
    or o.oid$ is not null
/* END SECTION 1 COMMON CODE */
   or
/* BEGIN SECTION 2 COMMON CODE: LOGSTDBY_SUPPORT - DBA_LOGSTDBY_UNSUPPORTED */
 (c.type# not in (
                  1,                             /* VARCHAR2 */
                  2,                               /* NUMBER */
                  8,                                 /* LONG */
                  12,                                /* DATE */
                  24,                            /* LONG RAW */
                  96,                                /* CHAR */
                  100,                       /* BINARY FLOAT */
                  101,                      /* BINARY DOUBLE */
                  112,                     /* CLOB and NCLOB */
                  113,                               /* BLOB */
                  180,                     /* TIMESTAMP (..) */
                  181,       /* TIMESTAMP(..) WITH TIME ZONE */
                  182,         /* INTERVAL YEAR(..) TO MONTH */
                  183,     /* INTERVAL DAY(..) TO SECOND(..) */
                  231) /* TIMESTAMP(..) WITH LOCAL TIME ZONE */
  and (c.type# != 23                      /* RAW not RAW OID */
       or (c.type# = 23 and bitand(c.property, 2) = 2)))
/* END SECTION 2 COMMON CODE */
   then 0 else 1 end) gensby
 from sys.obj$ o, sys.user$ u, sys.tab$ t, sys.seg$ s, sys.col$ c
where o.owner# = u.user#
  and o.obj# = t.obj#
  and o.obj# = c.obj#
  and t.file# = s.file# (+)
  and t.ts# = s.ts# (+)
  and t.block# = s.block# (+)
  and t.obj# = o.obj#
  and bitand(c.property, 32) != 32                         /* Not hidden */
) l, dba_tab_columns c
  where l.owner = c.owner
    and l.table_name = c.table_name
    and l.column_name = c.column_name
    and l.gensby = 0;

CREATE OR REPLACE FORCE VIEW "DBA_LOG_GROUPS"("OWNER",
select ou.name, oc.name, o.name,
       case c.type# when 14 then 'PRIMARY KEY LOGGING'
                    when 15 then 'UNIQUE KEY LOGGING'
                    when 16 then 'FOREIGN KEY LOGGING'
                    when 17 then 'ALL COLUMN LOGGING'
                    else 'USER LOG GROUP'
       end,
       case bitand(c.defer,64) when 64 then 'ALWAYS'
                               else  'CONDITIONAL'
       end,
       case bitand(c.defer,8) when 8 then 'GENERATED NAME'
                              else  'USER NAME'
       end
from sys.con$ oc, sys.user$ ou, sys.obj$ o, sys.cdef$ c
where oc.owner# = ou.user#
  and oc.con# = c.con#
  and c.obj# = o.obj#
  and
  (c.type# = 12 or c.type# = 14 or
   c.type# = 15 or c.type# = 16 or
   c.type# = 17);

CREATE OR REPLACE FORCE VIEW "DBA_LOG_GROUP_COLUMNS"("OWNER",
select u.name, c.name, o.name,
       decode(ac.name, null, col.name, ac.name), cc.pos#,
       decode(cc.spare1, 1, 'NO LOG', 'LOG')
from sys.user$ u, sys.con$ c, sys.col$ col, sys.ccol$ cc, sys.cdef$ cd,
     sys.obj$ o, sys.attrcol$ ac
where c.owner# = u.user#
  and c.con# = cd.con#
  and cd.type# = 12
  and cd.con# = cc.con#
  and cc.obj# = col.obj#
  and cc.intcol# = col.intcol#
  and cc.obj# = o.obj#
  and col.obj# = ac.obj#(+)
  and col.intcol# = ac.intcol#(+);

CREATE OR REPLACE FORCE VIEW "DBA_METHOD_PARAMS"("OWNER",
select u.name, o.name, m.name, m.method#,
       p.name, p.parameter#,
       decode(bitand(p.properties, 768), 768, 'IN OUT',
              decode(bitand(p.properties, 256), 256, 'IN',
                     decode(bitand(p.properties, 512), 512, 'OUT'))),
       decode(bitand(p.properties, 32768), 32768, 'REF',
              decode(bitand(p.properties, 16384), 16384, 'POINTER')),
       decode(bitand(pt.properties, 64), 64, null, pu.name),
       decode(pt.typecode,
              52, decode(p.charsetform, 2, 'NVARCHAR2', po.name),
              53, decode(p.charsetform, 2, 'NCHAR', po.name),
              54, decode(p.charsetform, 2, 'NCHAR VARYING', po.name),
              61, decode(p.charsetform, 2, 'NCLOB', po.name),
              po.name),
       decode(p.charsetform, 1, 'CHAR_CS',
                             2, 'NCHAR_CS',
                             3, NLS_CHARSET_NAME(p.charsetid),
                             4, 'ARG:'||p.charsetid)
from sys.user$ u, sys.obj$ o, sys.method$ m, sys.parameter$ p,
     sys.obj$ po, sys.user$ pu, sys.type$ pt
where o.owner# = u.user#
  and o.type# <> 10 -- must not be invalid
  and o.oid$ = m.toid
  and o.subname IS NULL -- get the latest version only
  and m.toid = p.toid
  and m.version# = p.version#
  and m.method# = p.method#
  and p.param_toid = po.oid$
  and po.owner# = pu.user#
  and p.param_toid = pt.toid
  and p.param_version# = pt.version#;

CREATE OR REPLACE FORCE VIEW "DBA_METHOD_RESULTS"("OWNER",
select u.name, o.name, m.name, m.method#,
       decode(bitand(r.properties, 32768), 32768, 'REF',
              decode(bitand(r.properties, 16384), 16384, 'POINTER')),
       decode(bitand(rt.properties, 64), 64, null, ru.name),
       decode(rt.typecode,
              52, decode(r.charsetform, 2, 'NVARCHAR2', ro.name),
              53, decode(r.charsetform, 2, 'NCHAR', ro.name),
              54, decode(r.charsetform, 2, 'NCHAR VARYING', ro.name),
              61, decode(r.charsetform, 2, 'NCLOB', ro.name),
              ro.name),
       decode(r.charsetform, 1, 'CHAR_CS',
                             2, 'NCHAR_CS',
                             3, NLS_CHARSET_NAME(r.charsetid),
                             4, 'ARG:'||r.charsetid)
from sys.user$ u, sys.obj$ o, sys.method$ m, sys.result$ r,
     sys.obj$ ro, sys.user$ ru, sys.type$ rt
where o.owner# = u.user#
  and o.type# <> 10 -- must not be invalid
  and o.oid$ = m.toid
  and o.subname IS NULL -- get the latest version only
  and m.toid = r.toid
  and m.version# = r.version#
  and m.method# = r.method#
  and r.result_toid = ro.oid$
  and ro.owner# = ru.user#
  and r.result_toid = rt.toid
  and r.result_version# = rt.version#;

CREATE OR REPLACE FORCE VIEW "DBA_MVIEWS"("OWNER",
select s.sowner, s.vname, s.tname, s.query_txt, s.query_len,
       decode(bitand(s.flag,2), 0, 'N', 'Y'),  /* updatable */
       s.uslog, s.mas_roll_seg, s.mlink,
       decode(w.mflags,
              '', '',  /* missing summary */
              decode(bitand(w.mflags, 4), 4, 'N', 'Y')),
       /* rewrite capability
        *   KKQS_NOGR_PFLAGS:
        *     QSMG_SUM_PART_EXT_NAME + QSMG_SUM_CONNECT_BY +
        *     QSMG_SUM_RAW_OUTPUT + QSMG_SUM_SUBQUERY_HAVING +
        *     QSMG_SUM_SUBQUERY_WHERE + QSMG_SUM_SET_OPERATOR +
        *     QSMG_SUM_NESTED_CURSOR + QSMG_SUM_OUT_MISSING_GRPCOL +
        *     QSMG_SUM_AGGREGATE_NOT_TOP
        *
        *   KKQS_NOGR_XPFLAGS:
        *     QSMG_SUM_WCLS
        *
        *   QSMG_SUM_DATA_IGNORE - 2nd-class summary
        */
       decode(w.pflags,
              '', '',  /* missing summary */
              decode(bitand(w.pflags, 1073741824), /* 2nd-class summary */
                     1073741824, 'NONE',
                     /* 2152929292 = 2147483648 + 2048 + 4096 + 65536 + 131072 +
                      *              1048576 + 4194304 + 8 + 4
                      */
                     decode(bitand(w.pflags, 2152929292),
                            0, decode(bitand(w.xpflags, 8192),
                                      8192, 'TEXTMATCH',
                                      'GENERAL'),
                            'TEXTMATCH'))),
       decode(s.auto_fast,
              'N', 'NEVER',
              decode(bitand(s.flag, 32768), 0, 'DEMAND', 'COMMIT')),
       decode(s.auto_fast,   /* refresh method */
              'C',  'COMPLETE',
              'F',  'FAST',
              '?',  'FORCE',
              'N',  'NEVER',
              NULL, 'FORCE', 'ERROR'),
       decode(bitand(s.flag, 131072),  /* build mode */
              131072, 'PREBUILT',
              decode(bitand(s.flag, 524288), 0, 'IMMEDIATE', 'DEFERRED')),
       /* fast refreshable
        *     rowid+primary key+object id+subquery+complex+MAV+MJV+MAV1
        *     536900016 = 16+32+536870912+128+256+4096+8192+16384
        */
       decode(bitand(s.flag, 536900016),
              16,        'DML',  /* rowid */
              32,        'DML',  /* primary key */
              536870912, 'DML',  /* object id */
              160,       'DML',  /* subquery - has both the primary key     */
                                 /* bit and the subquery bit  (32+128)      */
              536871040, 'DML',  /* subquery - has both the object id bit   */
                                 /* and the subquery bit (536870912+128)    */
              256,       'NO',   /* complex */
              4096,   decode(bitand(s.flag2,23),            /* KKZFAGG_INSO */
                             0,
                             'DIRLOAD_DML',                  /* regular MAV */
                             'DIRLOAD_LIMITEDDML'),      /* insert only MAV */
              8192,      'DIRLOAD_DML', /* MJV */
              16384,     'DIRLOAD_DML', /* MAV1 */
              decode(bitand(s.flag2, 16384),
                     16384,   'DIRLOAD_DML', /* UNION_ALL MV */
                     'ERROR')),
       /* fixing bug 923186 */
       decode(w.mflags,                    /*last refresh type */
              '','',                       /*missing summary */
              decode(bitand(w.mflags,16384+32768+4194304),
                     0, 'NA',
                     16384, 'COMPLETE',
                     32768, 'FAST',
                     4194304, 'FAST_PCT',
                     'ERROR')),
       /* end fixing bug 923186 */
       /* the last refresh date should be of date type and not varchar,
       ** SO BE CAREFUL WITH CHANGES IN THE FOLLOWING DECODE
       */
       decode(w.lastrefreshdate,  /* last refresh date */
              NULL, to_date(NULL, 'DD-MON-YYYY'),  /* missing summary */
              decode(to_char(w.lastrefreshdate,'DD-MON-YYYY'),'01-JAN-1950',
              to_date(NULL, 'DD-MON-YYYY'), w.lastrefreshdate)),
       /* staleness */
        decode(NVL(s.mlink,'null'),  /* not null implies remote */
              'null', decode(bitand(s.status, 4),  /* snapshot-invalid */
                             4, 'UNUSABLE',
                             decode(o.status,
                                    1, decode(w.mflags,
                                         '', '',  /* missing summary */
                                         decode(bitand(w.mflags, 8388608),
                                                8388608, 'IMPORT',            /* mv imported */
                                                decode(bitand(w.mflags, 64),  /* wh-unusable */
                                                       64, 'UNUSABLE',        /* unusable */
                                                       decode(bitand(w.mflags, 32),
                                                              0,    /* unknown */
                                            /* known stale */  decode(bitand(w.mflags, 1),
                                                              0, 'FRESH',
                                                              'STALE'), 'UNKNOWN')))),
                                    2, 'AUTHORIZATION_ERROR',
                                    3, 'COMPILATION_ERROR',
                                    5, 'NEEDS_COMPILE',
                                    'ERROR')),
              'UNDEFINED'),  /* remote MV */
       /* after fast refresh */
       /* in the decode for after fast refresh, we only have to check
        * whether w.mflags is null once.  all of the other occurences
        * fall under the first check.  if the summary information is not
        * null, we need to check for the warehouse unusable condition
        * before we check to see if the MV is complex.  if the summary
        * information is null, we still need to check whether the MV
        * is complex.
        */
       decode(NVL(s.mlink,'null'),  /* remote */
              'null', decode(s.auto_fast,  /* never refresh */
                         'N', 'NA',
                         decode(bitand(s.flag, 32768),  /* on commit */
                             32768, 'NA',
                             decode(bitand(s.status, 4),  /* snap-invalid */
                                4, 'NA',
                                decode(w.mflags,  /* missing summary */
                                   '', decode(bitand(s.flag, 256), /* complex */
                                              256, 'NA',
                                              ''),
                                   decode(o.status,
                                      1, decode(bitand(w.mflags, 8388608),
                                            8388608, 'UNKNOWN',        /* imported */
                  /* warehouse unusable */  decode(bitand(w.mflags, 64),
                                               64, 'NA',
                                               decode(bitand(s.flag, 256), /*complex*/
                                                  256, 'NA',
                                 /* unknown */    decode(bitand(w.mflags,32),
                                                     32, 'UNKNOWN',
                                 /* known stale */   decode(bitand(w.mflags, 1),
                                                        0, 'FRESH',
                  /* stale states (on-demand only)
                   * (This decode is the default clause for the known-stale
                   * decode statement.  It should be indented there, but there
                   * isn't enough room.)
                   */
                   decode(bitand(s.flag, 176), /* ri+pk+sq  */
                                               /* 16+32+128 */
                          0, decode(bitand(s.flag, 28672), /* mjv+mav1+mav  */
                                                         /* 8192+16384+4096 */
                                      0, 'ERROR', /* no mv type */
                /* mjv/mav/mav1 MV */ decode(bitand(w.mflags, 1576832),
                           /* 1576832 = 128+256+512+1024+2048+524288+1048576*/
                                      /*si + su + lsi + lsu + sf + sp + spu */
                                             128, 'FRESH',     /* si */
                                             256, 'UNKNOWN',   /* su */
                                             512, 'STALE',     /* sf */
                                             1024, 'FRESH',    /* lsi */
                                             2048, 'UNKNOWN',  /* lsu */
                                             524288, 'FRESH',  /* sp */
                                             1048576, 'UNKNOWN', /* spu */
                            /* 128+1024 */   1152, 'FRESH',    /* si+lsi*/
                            /* 256+2048 */   2304, 'UNKNOWN',  /* su+lsu*/
                                             'ERROR')),
   /* ri or pk or sq MV */  decode(bitand(w.mflags, 1576832),
                             /* 1576832 = 128+256+512+1024+2048+524288+1048576 */
                                   128, 'STALE',     /* si */
                                   256, 'STALE',     /* su */
                                   512, 'STALE',     /* sf */
                                   1024, 'FRESH',    /* lsi */
                                   2048, 'UNKNOWN',  /* lsu */
                                   524288, 'FRESH',  /* sp */
                                   1048576, 'UNKNOWN', /* spu */
                  /* 128+1024 */   1152, 'STALE',    /* si+lsi*/
                  /* 256+2048 */   2304, 'STALE',    /* su+lsu*/
                                   'ERROR'))))))),
                      2, 'AUTHORIZATION_ERROR',
                      3, 'COMPILATION_ERROR',
                      5, 'NEEDS_COMPILE',
                      'ERROR'))))),
              'UNDEFINED'), /* remote mv */
       /* UNKNOWN_PREBUILT */
       decode(w.pflags,
              '','', /* missing summary */
              decode(bitand(s.flag, 131072),
                    131072, 'Y', 'N')),
       /* UNKNOWN_PLSQL_FUNC */
       decode(w.pflags,
              '','', /* missing summary */
              decode(bitand(w.pflags, 268435456),
                     268435456, 'Y', 'N')),
       /* UNKNOWN_EXTERNAL_TABLE */
       decode(w.xpflags,
              '','', /* missing summary */
              decode(bitand(w.xpflags, 32768),
                     32768, 'Y', 'N')),
       /* UNKNOWN_CONSIDER_FRESH */
       decode(w.mflags,
              '','', /* missing summary */
              decode(bitand(w.mflags, 8192),
                     8192, 'Y', 'N')),
       /* UNKNOWN_IMPORT */
       decode(w.mflags,
              '','', /* missing summary */
              decode(bitand(w.mflags, 8388608),
                     8388608, 'Y', 'N')),
       /* UNKNOWN_TRUSTED_FD */
       decode(w.mflags,
              '','', /* missing summary */
              decode(bitand(w.mflags, 33554432),
                     33554432, 'Y', 'N')),
       decode(o.status,
              1, 'VALID',
              2, 'AUTHORIZATION_ERROR',
              3, 'COMPILATION_ERROR',
              5, 'NEEDS_COMPILE', 'ERROR'),/* compile st*/
       decode(bitand(s.flag2,1024), 0, 'N', 'Y'), /* USE NO INDEX ? */
       (select min(TIME_DP) from sys.SMON_SCN_TIME
        where (SCN_WRP*4294967295+ SCN_BAS) >
              (select min(t.spare3)
               from tab$ t, dependency$ d
               where t.obj#= d.p_obj# and w.obj#=d.d_obj# and
                     t.spare3 > w.lastrefreshscn))
from sys.user$ u, sys.sum$ w, sys.obj$ o, sys.snap$ s
where w.containernam(+) = s.vname
  and o.obj#(+) = w.obj#
  and o.owner# = u.user#(+)
  and ((u.name = s.sowner) or (u.name IS NULL))
  and s.instsite = 0
  and not (bitand(s.flag, 268435456) > 0       /* MV with user-defined types */
           and bitand(s.objflag, 32) > 0)                    /* secondary MV */;

CREATE OR REPLACE FORCE VIEW "DBA_MVIEW_AGGREGATES"("OWNER",
select u.name, o.name, sa.sumcolpos#, c.name,
       decode(sa.aggfunction, 15, 'AVG', 16, 'SUM', 17, 'COUNT',
                              18, 'MIN', 19, 'MAX',
                              97, 'VARIANCE', 98, 'STDDEV',
                              440, 'USER'),
       decode(sa.flags, 0, 'N', 'Y'),
       sa.aggtext
from sys.sumagg$ sa, sys.obj$ o, sys.user$ u, sys.sum$ s, sys.col$ c
where sa.sumobj# = o.obj#
  AND o.owner# = u.user#
  AND sa.sumobj# = s.obj#
  AND c.obj# = s.containerobj#
  AND c.col# = sa.containercol#
  AND bitand(s.xpflags, 8388608) = 0 /* NOT REWRITE EQUIVALENCE SUMMARY */;

CREATE OR REPLACE FORCE VIEW "DBA_MVIEW_ANALYSIS"("OWNER",
select u.name, o.name, u.name, s.containernam,
       s.lastrefreshscn, s.lastrefreshdate,
       decode (s.refreshmode, 0, 'NEVER', 1, 'FORCE', 2, 'FAST', 3,'COMPLETE'),
       decode(bitand(s.pflags, 25165824), 25165824, 'N', 'Y'),
       s.fullrefreshtim, s.increfreshtim,
       decode(bitand(s.pflags, 48), 0, 'N', 'Y'),
       decode(bitand(s.mflags, 64), 0, 'N', 'Y'), /* QSMQSUM_UNUSABLE */
       decode(bitand(s.pflags, 1294319), 0, 'Y', 'N'),
       decode(bitand(s.pflags, 236879743), 0, 'Y', 'N'),
       decode(bitand(s.mflags, 1), 0, 'N', 'Y'), /* QSMQSUM_KNOWNSTL */
       decode(o.status, 5, 'Y', 'N'),
       decode(bitand(s.mflags, 4), 0, 'Y', 'N'), /* QSMQSUM_DISABLED */
       s.sumtextlen,s.sumtext,
       s.metaversion/* Metadata revision number */
from sys.user$ u, sys.sum$ s, sys.obj$ o
where o.owner# = u.user#
  and o.obj# = s.obj#
  and bitand(s.xpflags, 8388608) = 0 /* NOT REWRITE EQUIVALENCE SUMMARY */;

CREATE OR REPLACE FORCE VIEW "DBA_MVIEW_COMMENTS"("OWNER",
select u.name, o.name, c.comment$
from sys.obj$ o, sys.user$ u, sys.com$ c, sys.tab$ t
  where o.owner# = u.user# AND o.type# = 2
  and (bitand(t.property, 67108864) = 67108864)         /*mv container table */
  and o.obj# = c.obj#(+)
  and c.col#(+) is NULL
  and o.obj# = t.obj#;

CREATE OR REPLACE FORCE VIEW "DBA_MVIEW_DETAIL_RELATIONS"("OWNER",
select u.name, o.name, du.name,  do.name,
       decode (sd.detailobjtype, 1, 'TABLE', 2, 'VIEW',
                                3, 'SNAPSHOT', 4, 'CONTAINER', 'UNDEFINED'),
       sd.detailalias
from sys.user$ u, sys.sumdetail$ sd, sys.obj$ o, sys.obj$ do,
     sys.user$ du, sys.sum$ s
where o.owner# = u.user#
  and o.obj# = sd.sumobj#
  and do.obj# = sd.detailobj#
  and do.owner# = du.user#
  and s.obj# = sd.sumobj#
  and bitand(s.xpflags, 8388608) = 0 /* NOT REWRITE EQUIVALENCE SUMMARY */;

CREATE OR REPLACE FORCE VIEW "DBA_MVIEW_JOINS"("OWNER",
select u.name, o.name,
       u1.name, o1.name, c1.name, '=',
       decode(sj.flags, 0, 'I', 1, 'L', 2, 'R'),
       u2.name, o2.name, c2.name
from sys.sumjoin$ sj, sys.obj$ o, sys.user$ u,
     sys.obj$ o1, sys.user$ u1, sys.col$ c1,
     sys.obj$ o2, sys.user$ u2, sys.col$ c2,
     sys.sum$ s
where sj.sumobj# = o.obj#
  AND o.owner# = u.user#
  AND sj.tab1obj# = o1.obj#
  AND o1.owner# = u1.user#
  AND sj.tab1obj# = c1.obj#
  AND sj.tab1col# = c1.intcol#
  AND sj.tab2obj# = o2.obj#
  AND o2.owner# = u2.user#
  AND sj.tab2obj# = c2.obj#
  AND sj.tab2col# = c2.intcol#
  AND s.obj# = sj.sumobj#
  AND bitand(s.xpflags, 8388608) = 0 /* NOT REWRITE EQUIVALENCE SUMMARY */;

CREATE OR REPLACE FORCE VIEW "DBA_MVIEW_KEYS"("OWNER",
select u1.name, o1.name, sk.sumcolpos#, c1.name,
       u2.name, o2.name, sd.detailalias,
       decode(sk.detailobjtype, 1, 'TABLE', 2, 'VIEW'), c2.name
from sys.sumkey$ sk, sys.obj$ o1, sys.user$ u1, sys.col$ c1, sys.sum$ s,
     sys.sumdetail$ sd, sys.obj$ o2, sys.user$ u2, sys.col$ c2
where sk.sumobj# = o1.obj#
  AND o1.owner# = u1.user#
  AND sk.sumobj# = s.obj#
  AND s.containerobj# = c1.obj#
  AND c1.col# = sk.containercol#
  AND sk.detailobj# = o2.obj#
  AND o2.owner# = u2.user#
  AND sk.sumobj# = sd.sumobj#
  AND sk.detailobj# = sd.detailobj#
  AND sk.detailobj# = c2.obj#
  AND sk.detailcol# = c2.intcol#
  AND bitand(s.xpflags, 8388608) = 0 /* NOT REWRITE EQUIVALENCE SUMMARY */;

CREATE OR REPLACE FORCE VIEW "DBA_MVIEW_LOGS"("LOG_OWNER",
select m.mowner, m.master, m.log, m.trig,
       decode(bitand(m.flag,1), 0, 'NO', 'YES'),
       decode(bitand(m.flag,2), 0, 'NO', 'YES'),
       decode(bitand(m.flag,512), 0, 'NO', 'YES'),
       decode(bitand(m.flag,4), 0, 'NO', 'YES'),
       decode(bitand(m.flag,1024), 0, 'NO', 'YES'),
       decode(bitand(m.flag,16), 0, 'NO', 'YES')
from sys.mlog$ m
union
select ct.source_schema_name, ct.source_table_name, ct.change_table_name,
       ct.mvl_v7trigger,
       decode(bitand(ct.mvl_flag,1), 0, 'NO', 'YES'),
       decode(bitand(ct.mvl_flag,2), 0, 'NO', 'YES'),
       decode(bitand(ct.mvl_flag,512), 0, 'NO', 'YES'),
       decode(bitand(ct.mvl_flag,4), 0, 'NO', 'YES'),
       decode(bitand(ct.mvl_flag,1024), 0, 'NO', 'YES'),
       decode(bitand(ct.mvl_flag,16), 0, 'NO', 'YES')
from sys.cdc_change_tables$ ct
where bitand(ct.mvl_flag, 128) = 128;

CREATE OR REPLACE FORCE VIEW "DBA_MVIEW_LOG_FILTER_COLS"("OWNER",
select mowner, master, colname from sys.mlog_refcol$
union
select ct.source_schema_name, ct.source_table_name, cc.column_name
from sys.cdc_change_tables$ ct, sys.cdc_change_columns$ cc
where cc.change_table_obj# = ct.obj#
  and bitand(ct.mvl_flag, 128) = 128
  and cc.column_name not in
    ('RSID$','XIDUSN$','XIDSLT$','XIDSEQ$','OPERATION$',
     'CSCN$','COMMIT_TIMESTAMP$','SOURCE_COLMAP$','TARGET_COLMAP$',
     'USERNAME$', 'TIMESTAMP$', 'ROW_ID$','SYS_NC_OID$');

CREATE OR REPLACE FORCE VIEW "DBA_MVIEW_REFRESH_TIMES"("OWNER",
select sowner, vname, mowner, master, snaptime
from sys.snap_reftime$ t
where t.instsite = 0;

CREATE OR REPLACE FORCE VIEW "DBA_NESTED_TABLES"("OWNER",
select u.name, o.name,
       nvl2(ct.synobj#, (select u.name from user$ u, obj$ o
            where o.owner#=u.user# and o.obj#=ct.synobj#), ut.name),
       nvl2(ct.synobj#, (select o.name from obj$ o
            where o.obj#=ct.synobj#), ot.name),
       op.name, ac.name,
       lpad(decode(bitand(ct.flags, 64), 64, 'USER_SPECIFIED', 'DEFAULT'), 30),
       lpad(decode(bitand(ct.flags, 32), 32, 'LOCATOR', 'VALUE'), 20),
       lpad((case when bitand(ct.flags, 5120)=0 and bitand(t.properties, 8)= 8
       then 'Y' else 'N' end), 25)
from sys.ntab$ n, sys.obj$ o, sys.obj$ op, sys.obj$ ot,
  sys.col$ c, sys.coltype$ ct, sys.user$ u, sys.user$ ut, sys.attrcol$ ac,
  sys.type$ t, sys.collection$ cl
where o.owner# = u.user#
  and op.owner# = u.user#
  and n.obj# = op.obj#
  and n.ntab# = o.obj#
  and c.obj# = op.obj#
  and n.intcol# = c.intcol#
  and c.obj# = ac.obj#
  and c.intcol# = ac.intcol#
  and op.obj# = ct.obj#
  and ct.toid = ot.oid$
  and ct.intcol#=n.intcol#
  and ot.owner# = ut.user#
  and ct.toid=cl.toid
  and cl.elem_toid=t.tvoid
  and bitand(ct.flags,4)=4
  and bitand(c.property,32768) != 32768           /* not unused column */
union all
select u.name, o.name,
       nvl2(ct.synobj#, (select u.name from user$ u, obj$ o
            where o.owner#=u.user# and o.obj#=ct.synobj#), ut.name),
       nvl2(ct.synobj#, (select o.name from obj$ o
            where o.obj#=ct.synobj#), ot.name),
       op.name, c.name,
       lpad(decode(bitand(ct.flags, 64), 64, 'USER_SPECIFIED', 'DEFAULT'), 30),
       lpad(decode(bitand(ct.flags, 32), 32, 'LOCATOR', 'VALUE'), 20),
       lpad((case when bitand(ct.flags, 5120)=0 and bitand(t.properties, 8)= 8
       then 'Y' else 'N' end), 25)
from sys.ntab$ n, sys.obj$ o, sys.obj$ op, sys.obj$ ot, sys.col$ c,
  sys.coltype$ ct, sys.user$ u, sys.user$ ut, sys.type$ t, sys.collection$ cl
where o.owner# = u.user#
  and op.owner# = u.user#
  and n.obj# = op.obj#
  and n.ntab# = o.obj#
  and c.obj# = op.obj#
  and n.intcol# = c.intcol#
  and bitand(c.property,1)=0
  and op.obj# = ct.obj#
  and ct.toid = ot.oid$
  and ct.intcol#=n.intcol#
  and ot.owner# = ut.user#
  and ct.toid=cl.toid
  and cl.elem_toid=t.tvoid
  and bitand(ct.flags,4)=4
  and bitand(c.property,32768) != 32768           /* not unused column */;

CREATE OR REPLACE FORCE VIEW "DBA_NESTED_TABLE_COLS"("OWNER",
select u.name, o.name,
       c.name,
       decode(c.type#, 1, decode(c.charsetform, 2, 'NVARCHAR2', 'VARCHAR2'),
                       2, decode(c.scale, null,
                                 decode(c.precision#, null, 'NUMBER', 'FLOAT'),
                                 'NUMBER'),
                       8, 'LONG',
                       9, decode(c.charsetform, 2, 'NCHAR VARYING', 'VARCHAR'),
                       12, 'DATE',
                       23, 'RAW', 24, 'LONG RAW',
                       58, nvl2(ac.synobj#, (select o.name from obj$ o
                                where o.obj#=ac.synobj#), ot.name),
                       69, 'ROWID',
                       96, decode(c.charsetform, 2, 'NCHAR', 'CHAR'),
                       100, 'BINARY_FLOAT',
                       101, 'BINARY_DOUBLE',
                       105, 'MLSLABEL',
                       106, 'MLSLABEL',
                       111, nvl2(ac.synobj#, (select o.name from obj$ o
                                 where o.obj#=ac.synobj#), ot.name),
                       112, decode(c.charsetform, 2, 'NCLOB', 'CLOB'),
                       113, 'BLOB', 114, 'BFILE', 115, 'CFILE',
                       121, nvl2(ac.synobj#, (select o.name from obj$ o
                                 where o.obj#=ac.synobj#), ot.name),
                       122, nvl2(ac.synobj#, (select o.name from obj$ o
                                 where o.obj#=ac.synobj#), ot.name),
                       123, nvl2(ac.synobj#, (select o.name from obj$ o
                                 where o.obj#=ac.synobj#), ot.name),
                       178, 'TIME(' ||c.scale|| ')',
                       179, 'TIME(' ||c.scale|| ')' || ' WITH TIME ZONE',
                       180, 'TIMESTAMP(' ||c.scale|| ')',
                       181, 'TIMESTAMP(' ||c.scale|| ')' || ' WITH TIME ZONE',
                       231, 'TIMESTAMP(' ||c.scale|| ')' || ' WITH LOCAL TIME ZONE',
                       182, 'INTERVAL YEAR(' ||c.precision#||') TO MONTH',
                       183, 'INTERVAL DAY(' ||c.precision#||') TO SECOND(' ||
                             c.scale || ')',
                       208, 'UROWID',
                       'UNDEFINED'),
       decode(c.type#, 111, 'REF'),
       nvl2(ac.synobj#, (select u.name from user$ u, obj$ o
            where o.owner#=u.user# and o.obj#=ac.synobj#), ut.name),
       c.length, c.precision#, c.scale,
       decode(sign(c.null$),-1,'D', 0, 'Y', 'N'),
       decode(c.col#, 0, to_number(null), c.col#), c.deflength,
       c.default$, h.distcnt, h.lowval, h.hival, h.density, h.null_cnt,
       case when h.bucket_cnt > 255 then h.row_cnt else
         decode(h.row_cnt, h.distcnt, h.row_cnt, h.bucket_cnt)
       end,
       h.timestamp#, h.sample_size,
       decode(c.charsetform, 1, 'CHAR_CS',
                             2, 'NCHAR_CS',
                             3, NLS_CHARSET_NAME(c.charsetid),
                             4, 'ARG:'||c.charsetid),
       decode(c.charsetid, 0, to_number(NULL),
                           nls_charset_decl_len(c.length, c.charsetid)),
       decode(bitand(h.spare2, 2), 2, 'YES', 'NO'),
       decode(bitand(h.spare2, 1), 1, 'YES', 'NO'),
       h.avgcln,
       c.spare3,
       decode(c.type#, 1, decode(bitand(c.property, 8388608), 0, 'B', 'C'),
                      96, decode(bitand(c.property, 8388608), 0, 'B', 'C'),
                      null),
       decode(bitand(ac.flags, 128), 128, 'YES', 'NO'),
       decode(o.status, 1, decode(bitand(ac.flags, 256), 256, 'NO', 'YES'),
                        decode(bitand(ac.flags, 2), 2, 'NO',
                               decode(bitand(ac.flags, 4), 4, 'NO',
                                      decode(bitand(ac.flags, 8), 8, 'NO',
                                             'N/A')))),
       decode(c.property, 0, 'NO', decode(bitand(c.property, 32), 32, 'YES',
                                          'NO')),
       decode(c.property, 0, 'NO', decode(bitand(c.property, 8), 8, 'YES',
                                          'NO')),
       decode(c.segcol#, 0, to_number(null), c.segcol#), c.intcol#,
       case when h.bucket_cnt > 255 then 'FREQUENCY' else
         decode(nvl(h.row_cnt, 0), 0, 'NONE',
                                   h.distcnt, 'FREQUENCY', 'HEIGHT BALANCED')
       end,
       decode(bitand(c.property, 1024), 1024,
              (select decode(bitand(cl.property, 1), 1, rc.name, cl.name)
               from sys.col$ cl, attrcol$ rc where cl.intcol# = c.intcol#-1
               and cl.obj# = c.obj# and c.obj# = rc.obj#(+) and
               cl.intcol# = rc.intcol#(+)),
              decode(bitand(c.property, 1), 0, c.name,
                     (select tc.name from sys.attrcol$ tc
                      where c.obj# = tc.obj# and c.intcol# = tc.intcol#)))
from sys.col$ c, sys.obj$ o, sys.hist_head$ h, sys.user$ u,
     sys.coltype$ ac, sys.obj$ ot, sys.user$ ut, sys.tab$ t
where o.obj# = c.obj#
  and o.owner# = u.user#
  and c.obj# = h.obj#(+) and c.intcol# = h.intcol#(+)
  and c.obj# = ac.obj#(+) and c.intcol# = ac.intcol#(+)
  and ac.toid = ot.oid$(+)
  and ot.type#(+) = 13
  and ot.owner# = ut.user#(+)
  and o.obj# = t.obj#
  and bitand(t.property, 8192) = 8192            /* nested tables */;

CREATE OR REPLACE FORCE VIEW "DBA_OBJECTS"("OWNER",
select u.name, o.name, o.subname, o.obj#, o.dataobj#,
       decode(o.type#, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE',
                      7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE',
                      11, 'PACKAGE BODY', 12, 'TRIGGER',
                      13, 'TYPE', 14, 'TYPE BODY',
                      19, 'TABLE PARTITION', 20, 'INDEX PARTITION', 21, 'LOB',
                      22, 'LIBRARY', 23, 'DIRECTORY', 24, 'QUEUE',
                      28, 'JAVA SOURCE', 29, 'JAVA CLASS', 30, 'JAVA RESOURCE',
                      32, 'INDEXTYPE', 33, 'OPERATOR',
                      34, 'TABLE SUBPARTITION', 35, 'INDEX SUBPARTITION',
                      40, 'LOB PARTITION', 41, 'LOB SUBPARTITION',
                      42, NVL((SELECT distinct 'REWRITE EQUIVALENCE'
                               FROM sum$ s
                               WHERE s.obj#=o.obj#
                                     and bitand(s.xpflags, 8388608) = 8388608),
                              'MATERIALIZED VIEW'),
                      43, 'DIMENSION',
                      44, 'CONTEXT', 46, 'RULE SET', 47, 'RESOURCE PLAN',
                      48, 'CONSUMER GROUP',
                      51, 'SUBSCRIPTION', 52, 'LOCATION',
                      55, 'XML SCHEMA', 56, 'JAVA DATA',
                      57, 'SECURITY PROFILE', 59, 'RULE',
                      60, 'CAPTURE', 61, 'APPLY',
                      62, 'EVALUATION CONTEXT',
                      66, 'JOB', 67, 'PROGRAM', 68, 'JOB CLASS', 69, 'WINDOW',
                      72, 'WINDOW GROUP', 74, 'SCHEDULE',
                     'UNDEFINED'),
       o.ctime, o.mtime,
       to_char(o.stime, 'YYYY-MM-DD:HH24:MI:SS'),
       decode(o.status, 0, 'N/A', 1, 'VALID', 'INVALID'),
       decode(bitand(o.flags, 2), 0, 'N', 2, 'Y', 'N'),
       decode(bitand(o.flags, 4), 0, 'N', 4, 'Y', 'N'),
       decode(bitand(o.flags, 16), 0, 'N', 16, 'Y', 'N')
from sys.obj$ o, sys.user$ u
where o.owner# = u.user#
  and o.linkname is null
  and (o.type# not in (1  /* INDEX - handled below */,
                      10 /* NON-EXISTENT */)
       or
       (o.type# = 1 and 1 = (select 1
                              from sys.ind$ i
                             where i.obj# = o.obj#
                               and i.type# in (1, 2, 3, 4, 6, 7, 9))))
  and o.name != '_NEXT_OBJECT'
  and o.name != '_default_auditing_options_'
union all
select u.name, l.name, NULL, to_number(null), to_number(null),
       'DATABASE LINK',
       l.ctime, to_date(null), NULL, 'VALID','N','N', 'N'
from sys.link$ l, sys.user$ u
where l.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "DBA_OBJECT_SIZE"("OWNER",
select u.name, o.name,
  decode(o.type#, 2, 'TABLE', 4, 'VIEW', 5, 'SYNONYM', 6, 'SEQUENCE',
    7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE', 11, 'PACKAGE BODY',
    12, 'TRIGGER', 13, 'TYPE', 14, 'TYPE BODY',
    28, 'JAVA SOURCE', 29, 'JAVA CLASS', 30, 'JAVA RESOURCE', 56, 'JAVA DATA',
    'UNDEFINED'),
  nvl(s.bytes,0), nvl(p.bytes,0), nvl(c.bytes,0), nvl(e.bytes,0)
  from sys.obj$ o, sys.user$ u,
    sys.source_size s, sys.parsed_size p, sys.code_size c, sys.error_size e
  where o.type# in (2, 4, 5, 6, 7, 8, 9, 11, 12, 13, 14, 28, 29, 30, 56)
    and o.owner# = u.user#
    and o.obj# = s.obj# (+)
    and o.obj# = p.obj# (+)
    and o.obj# = c.obj# (+)
    and o.obj# = e.obj# (+)
    and nvl(s.bytes,0) + nvl(p.bytes,0) + nvl(c.bytes,0) + nvl(e.bytes,0) > 0;

CREATE OR REPLACE FORCE VIEW "DBA_OBJECT_TABLES"("OWNER",
select u.name, o.name, decode(bitand(t.property,2151678048), 0, ts.name, null),
       decode(bitand(t.property, 1024), 0, null, co.name),
       decode((bitand(t.property, 512)+bitand(t.flags, 536870912)),
              0, null, co.name),
       decode(bitand(t.property, 32+64), 0, mod(t.pctfree$, 100), 64, 0, null),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
          decode(bitand(t.property, 32+64), 0, t.pctused$, 64, 0, null)),
       decode(bitand(t.property, 32), 0, t.initrans, null),
       decode(bitand(t.property, 32), 0, t.maxtrans, null),
       s.iniexts * ts.blocksize,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                      s.extsize * ts.blocksize),
       s.minexts, s.maxexts,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                      s.extpct),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
         decode(bitand(o.flags, 2), 2, 1, decode(s.lists, 0, 1, s.lists))),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
         decode(bitand(o.flags, 2), 2, 1, decode(s.groups, 0, 1, s.groups))),
       decode(bitand(t.property, 32), 32, null,
                decode(bitand(t.flags, 32), 0, 'YES', 'NO')),
       decode(bitand(t.flags,1), 0, 'Y', 1, 'N', '?'),
       t.rowcnt,
       decode(bitand(t.property, 64), 0, t.blkcnt, null),
       decode(bitand(t.property, 64), 0, t.empcnt, null),
       t.avgspc, t.chncnt, t.avgrln, t.avgspc_flb,
       decode(bitand(t.property, 64), 0, t.flbcnt, null),
       lpad(decode(t.degree, 32767, 'DEFAULT', nvl(t.degree,1)),10),
       lpad(decode(t.instances, 32767, 'DEFAULT', nvl(t.instances,1)),10),
       lpad(decode(bitand(t.flags, 8), 8, 'Y', 'N'),5),
       decode(bitand(t.flags, 6), 0, 'ENABLED', 'DISABLED'),
       t.samplesize, t.analyzetime,
       decode(bitand(t.property, 32), 32, 'YES', 'NO'),
       decode(bitand(t.property, 64), 64, 'IOT',
               decode(bitand(t.property, 512), 512, 'IOT_OVERFLOW',
               decode(bitand(t.flags, 536870912), 536870912, 'IOT_MAPPING', null))),
       decode(bitand(t.property, 4096), 4096, 'USER-DEFINED',
                                              'SYSTEM GENERATED'),
       nvl2(ac.synobj#, su.name, tu.name),
       nvl2(ac.synobj#, so.name, ty.name),
       decode(bitand(o.flags, 2), 0, 'N', 2, 'Y', 'N'),
       decode(bitand(o.flags, 16), 0, 'N', 16, 'Y', 'N'),
       decode(bitand(t.property, 8192), 8192, 'YES', 'NO'),
       decode(bitand(o.flags, 2), 2, 'DEFAULT',
             decode(s.cachehint, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL)),
       decode(bitand(t.flags, 131072), 131072, 'ENABLED', 'DISABLED'),
       decode(bitand(t.flags, 512), 0, 'NO', 'YES'),
       decode(bitand(t.flags, 256), 0, 'NO', 'YES'),
       decode(bitand(o.flags, 2), 0, NULL,
          decode(bitand(t.property, 8388608), 8388608,
                 'SYS$SESSION', 'SYS$TRANSACTION')),
       decode(bitand(t.flags, 1024), 1024, 'ENABLED', 'DISABLED'),
       decode(bitand(o.flags, 2), 2, 'NO',
           decode(bitand(t.property, 2147483648), 2147483648, 'NO',
              decode(ksppcv.ksppstvl, 'TRUE', 'YES', 'NO'))),
       decode(bitand(t.property, 1024), 0, null, cu.name),
       decode(bitand(t.flags, 8388608), 8388608, 'ENABLED', 'DISABLED'),
       decode(bitand(t.property, 32), 32, null,
                decode(bitand(s.spare1, 2048), 2048, 'ENABLED', 'DISABLED')),
       decode(bitand(o.flags, 128), 128, 'YES', 'NO')
from sys.user$ u, sys.ts$ ts, sys.seg$ s, sys.obj$ co, sys.tab$ t, sys.obj$ o,
     sys.coltype$ ac, sys.obj$ ty, sys.user$ tu, sys.col$ tc,
     sys.obj$ cx, sys.user$ cu, sys.obj$ so, sys.user$ su,
     x$ksppcv ksppcv, x$ksppi ksppi
where o.owner# = u.user#
  and o.obj# = t.obj#
  and bitand(t.property, 1) = 1
  and bitand(o.flags, 128) = 0
  and t.obj# = tc.obj#
  and tc.name = 'SYS_NC_ROWINFO$'
  and tc.obj# = ac.obj#
  and tc.intcol# = ac.intcol#
  and ac.toid = ty.oid$
  and ty.owner# = tu.user#
  and ty.type# <> 10
  and t.bobj# = co.obj# (+)
  and t.ts# = ts.ts#
  and t.file# = s.file# (+)
  and t.block# = s.block# (+)
  and t.ts# = s.ts# (+)
  and t.dataobj# = cx.obj# (+)
  and cx.owner# = cu.user# (+)
  and ac.synobj# = so.obj# (+)
  and so.owner# = su.user# (+)
  and ksppi.indx = ksppcv.indx
  and ksppi.ksppinm = '_dml_monitoring_enabled';

CREATE OR REPLACE FORCE VIEW "DBA_OBJ_AUDIT_OPTS"("OWNER",
select u.name, o.name, 'TABLE',
       substr(t.audit$, 1, 1) || '/' || substr(t.audit$, 2, 1),
       substr(t.audit$, 3, 1) || '/' || substr(t.audit$, 4, 1),
       substr(t.audit$, 5, 1) || '/' || substr(t.audit$, 6, 1),
       substr(t.audit$, 7, 1) || '/' || substr(t.audit$, 8, 1),
       substr(t.audit$, 9, 1) || '/' || substr(t.audit$, 10, 1),
       substr(t.audit$, 11, 1) || '/' || substr(t.audit$, 12, 1),
       substr(t.audit$, 13, 1) || '/' || substr(t.audit$, 14, 1),
       substr(t.audit$, 15, 1) || '/' || substr(t.audit$, 16, 1),
       substr(t.audit$, 17, 1) || '/' || substr(t.audit$, 18, 1),
       substr(t.audit$, 19, 1) || '/' || substr(t.audit$, 20, 1),
       substr(t.audit$, 21, 1) || '/' || substr(t.audit$, 22, 1),
       '-/-',                                            /* dummy REF column */
       substr(t.audit$, 25, 1) || '/' || substr(t.audit$, 26, 1),
       substr(t.audit$, 27, 1) || '/' || substr(t.audit$, 28, 1),
       substr(t.audit$, 29, 1) || '/' || substr(t.audit$, 30, 1),
       substr(t.audit$, 31, 1) || '/' || substr(t.audit$, 32, 1),
       substr(t.audit$, 23, 1) || '/' || substr(t.audit$, 24, 1)
from sys.obj$ o, sys.user$ u, sys.tab$ t
where o.type# = 2
  and not (o.owner# = 0 and o.name = '_default_auditing_options_')
  and o.owner# = u.user#
  and o.obj# = t.obj#
union all
select u.name, o.name, 'VIEW',
       substr(v.audit$, 1, 1) || '/' || substr(v.audit$, 2, 1),
       substr(v.audit$, 3, 1) || '/' || substr(v.audit$, 4, 1),
       substr(v.audit$, 5, 1) || '/' || substr(v.audit$, 6, 1),
       substr(v.audit$, 7, 1) || '/' || substr(v.audit$, 8, 1),
       substr(v.audit$, 9, 1) || '/' || substr(v.audit$, 10, 1),
       substr(v.audit$, 11, 1) || '/' || substr(v.audit$, 12, 1),
       substr(v.audit$, 13, 1) || '/' || substr(v.audit$, 14, 1),
       substr(v.audit$, 15, 1) || '/' || substr(v.audit$, 16, 1),
       substr(v.audit$, 17, 1) || '/' || substr(v.audit$, 18, 1),
       substr(v.audit$, 19, 1) || '/' || substr(v.audit$, 20, 1),
       substr(v.audit$, 21, 1) || '/' || substr(v.audit$, 22, 1),
       '-/-',                                            /* dummy REF column */
       substr(v.audit$, 25, 1) || '/' || substr(v.audit$, 26, 1),
       substr(v.audit$, 27, 1) || '/' || substr(v.audit$, 28, 1),
       substr(v.audit$, 29, 1) || '/' || substr(v.audit$, 30, 1),
       substr(v.audit$, 31, 1) || '/' || substr(v.audit$, 32, 1),
       substr(v.audit$, 23, 1) || '/' || substr(v.audit$, 24, 1)
from sys.obj$ o, sys.user$ u, sys.view$ v
where o.type# = 4
  and o.owner# = u.user#
  and o.obj# = v.obj#
union all
select u.name, o.name, 'SEQUENCE',
       substr(s.audit$, 1, 1) || '/' || substr(s.audit$, 2, 1),
       substr(s.audit$, 3, 1) || '/' || substr(s.audit$, 4, 1),
       substr(s.audit$, 5, 1) || '/' || substr(s.audit$, 6, 1),
       substr(s.audit$, 7, 1) || '/' || substr(s.audit$, 8, 1),
       substr(s.audit$, 9, 1) || '/' || substr(s.audit$, 10, 1),
       substr(s.audit$, 11, 1) || '/' || substr(s.audit$, 12, 1),
       substr(s.audit$, 13, 1) || '/' || substr(s.audit$, 14, 1),
       substr(s.audit$, 15, 1) || '/' || substr(s.audit$, 16, 1),
       substr(s.audit$, 17, 1) || '/' || substr(s.audit$, 18, 1),
       substr(s.audit$, 19, 1) || '/' || substr(s.audit$, 20, 1),
       substr(s.audit$, 21, 1) || '/' || substr(s.audit$, 22, 1),
       '-/-',                                            /* dummy REF column */
       substr(s.audit$, 25, 1) || '/' || substr(s.audit$, 26, 1),
       substr(s.audit$, 27, 1) || '/' || substr(s.audit$, 28, 1),
       substr(s.audit$, 29, 1) || '/' || substr(s.audit$, 30, 1),
       substr(s.audit$, 31, 1) || '/' || substr(s.audit$, 32, 1),
       substr(s.audit$, 23, 1) || '/' || substr(s.audit$, 24, 1)
from sys.obj$ o, sys.user$ u, sys.seq$ s
where o.type# = 6
  and o.owner# = u.user#
  and o.obj# = s.obj#
union all
select u.name, o.name, 'PROCEDURE',
       substr(p.audit$, 1, 1) || '/' || substr(p.audit$, 2, 1),
       substr(p.audit$, 3, 1) || '/' || substr(p.audit$, 4, 1),
       substr(p.audit$, 5, 1) || '/' || substr(p.audit$, 6, 1),
       substr(p.audit$, 7, 1) || '/' || substr(p.audit$, 8, 1),
       substr(p.audit$, 9, 1) || '/' || substr(p.audit$, 10, 1),
       substr(p.audit$, 11, 1) || '/' || substr(p.audit$, 12, 1),
       substr(p.audit$, 13, 1) || '/' || substr(p.audit$, 14, 1),
       substr(p.audit$, 15, 1) || '/' || substr(p.audit$, 16, 1),
       substr(p.audit$, 17, 1) || '/' || substr(p.audit$, 18, 1),
       substr(p.audit$, 19, 1) || '/' || substr(p.audit$, 20, 1),
       substr(p.audit$, 21, 1) || '/' || substr(p.audit$, 22, 1),
       '-/-',                                            /* dummy REF column */
       substr(p.audit$, 25, 1) || '/' || substr(p.audit$, 26, 1),
       substr(p.audit$, 27, 1) || '/' || substr(p.audit$, 28, 1),
       substr(p.audit$, 29, 1) || '/' || substr(p.audit$, 30, 1),
       substr(p.audit$, 31, 1) || '/' || substr(p.audit$, 32, 1),
       substr(p.audit$, 23, 1) || '/' || substr(p.audit$, 24, 1)
from sys.obj$ o, sys.user$ u, sys.library$ p
where o.type# = 22
  and o.owner# = u.user#
  and o.obj# = p.obj#
union all
select u.name, o.name, 'PROCEDURE',
       substr(p.audit$, 1, 1) || '/' || substr(p.audit$, 2, 1),
       substr(p.audit$, 3, 1) || '/' || substr(p.audit$, 4, 1),
       substr(p.audit$, 5, 1) || '/' || substr(p.audit$, 6, 1),
       substr(p.audit$, 7, 1) || '/' || substr(p.audit$, 8, 1),
       substr(p.audit$, 9, 1) || '/' || substr(p.audit$, 10, 1),
       substr(p.audit$, 11, 1) || '/' || substr(p.audit$, 12, 1),
       substr(p.audit$, 13, 1) || '/' || substr(p.audit$, 14, 1),
       substr(p.audit$, 15, 1) || '/' || substr(p.audit$, 16, 1),
       substr(p.audit$, 17, 1) || '/' || substr(p.audit$, 18, 1),
       substr(p.audit$, 19, 1) || '/' || substr(p.audit$, 20, 1),
       substr(p.audit$, 21, 1) || '/' || substr(p.audit$, 22, 1),
       '-/-',                                            /* dummy REF column */
       substr(p.audit$, 25, 1) || '/' || substr(p.audit$, 26, 1),
       substr(p.audit$, 27, 1) || '/' || substr(p.audit$, 28, 1),
       substr(p.audit$, 29, 1) || '/' || substr(p.audit$, 30, 1),
       substr(p.audit$, 31, 1) || '/' || substr(p.audit$, 32, 1),
       substr(p.audit$, 23, 1) || '/' || substr(p.audit$, 24, 1)
from sys.obj$ o, sys.user$ u, sys.procedure$ p
where o.type# >= 7 and o.type# <= 9
  and o.owner# = u.user#
  and o.obj# = p.obj#
union all
select u.name, o.name, 'TYPE',
       substr(t.audit$, 1, 1) || '/' || substr(t.audit$, 2, 1),
       substr(t.audit$, 3, 1) || '/' || substr(t.audit$, 4, 1),
       substr(t.audit$, 5, 1) || '/' || substr(t.audit$, 6, 1),
       substr(t.audit$, 7, 1) || '/' || substr(t.audit$, 8, 1),
       substr(t.audit$, 9, 1) || '/' || substr(t.audit$, 10, 1),
       substr(t.audit$, 11, 1) || '/' || substr(t.audit$, 12, 1),
       substr(t.audit$, 13, 1) || '/' || substr(t.audit$, 14, 1),
       substr(t.audit$, 15, 1) || '/' || substr(t.audit$, 16, 1),
       substr(t.audit$, 17, 1) || '/' || substr(t.audit$, 18, 1),
       substr(t.audit$, 19, 1) || '/' || substr(t.audit$, 20, 1),
       substr(t.audit$, 21, 1) || '/' || substr(t.audit$, 22, 1),
       '-/-',                                            /* dummy REF column */
       substr(t.audit$, 25, 1) || '/' || substr(t.audit$, 26, 1),
       substr(t.audit$, 27, 1) || '/' || substr(t.audit$, 28, 1),
       substr(t.audit$, 29, 1) || '/' || substr(t.audit$, 30, 1),
       substr(t.audit$, 31, 1) || '/' || substr(t.audit$, 32, 1),
       substr(t.audit$, 23, 1) || '/' || substr(t.audit$, 24, 1)
from sys.obj$ o, sys.user$ u, sys.type_misc$ t
where o.type# = 13
  and o.owner# = u.user#
  and o.obj# = t.obj#
union all
select u.name, o.name, 'DIRECTORY',
       substr(t.audit$, 1, 1) || '/' || substr(t.audit$, 2, 1),
       substr(t.audit$, 3, 1) || '/' || substr(t.audit$, 4, 1),
       substr(t.audit$, 5, 1) || '/' || substr(t.audit$, 6, 1),
       substr(t.audit$, 7, 1) || '/' || substr(t.audit$, 8, 1),
       substr(t.audit$, 9, 1) || '/' || substr(t.audit$, 10, 1),
       substr(t.audit$, 11, 1) || '/' || substr(t.audit$, 12, 1),
       substr(t.audit$, 13, 1) || '/' || substr(t.audit$, 14, 1),
       substr(t.audit$, 15, 1) || '/' || substr(t.audit$, 16, 1),
       substr(t.audit$, 17, 1) || '/' || substr(t.audit$, 18, 1),
       substr(t.audit$, 19, 1) || '/' || substr(t.audit$, 20, 1),
       substr(t.audit$, 21, 1) || '/' || substr(t.audit$, 22, 1),
       '-/-',                                            /* dummy REF column */
       substr(t.audit$, 25, 1) || '/' || substr(t.audit$, 26, 1),
       substr(t.audit$, 27, 1) || '/' || substr(t.audit$, 28, 1),
       substr(t.audit$, 29, 1) || '/' || substr(t.audit$, 30, 1),
       substr(t.audit$, 31, 1) || '/' || substr(t.audit$, 32, 1),
       substr(t.audit$, 23, 1) || '/' || substr(t.audit$, 24, 1)
from sys.obj$ o, sys.user$ u, sys.dir$ t
where o.type# = 23
  and o.owner# = u.user#
  and o.obj# = t.obj#;

CREATE OR REPLACE FORCE VIEW "DBA_OBJ_COLATTRS"("OWNER",
select u.name, o.name, c.name,
  lpad(decode(bitand(ct.flags, 512), 512, 'Y', 'N'), 15)
from sys.coltype$ ct, sys.obj$ o, sys.col$ c, sys.user$ u
where o.owner# = u.user#
  and bitand(ct.flags, 2) = 2                                 /* ADT column */
  and o.obj#=ct.obj#
  and o.obj#=c.obj#
  and c.intcol#=ct.intcol#
  and bitand(c.property,32768) != 32768                 /* not unused column */
  and not exists (select null                   /* Doesn't exist in attrcol$ */
                  from sys.attrcol$ ac
                  where ac.intcol#=ct.intcol#
                        and ac.obj#=ct.obj#)
union all
select u.name, o.name, ac.name,
  lpad(decode(bitand(ct.flags, 512), 512, 'Y', 'N'), 15)
from sys.coltype$ ct, sys.obj$ o, sys.attrcol$ ac, sys.user$ u, col$ c
where o.owner# = u.user#
  and bitand(ct.flags, 2) = 2                                 /* ADT column */
  and o.obj#=ct.obj#
  and o.obj#=c.obj#
  and o.obj#=ac.obj#
  and c.intcol#=ct.intcol#
  and c.intcol#=ac.intcol#
  and bitand(c.property,32768) != 32768                /* not unused column */;

CREATE OR REPLACE FORCE VIEW "DBA_OPANCILLARY"("OWNER",
select distinct u.name, o.name, a.bind#, u1.name, o1.name, a1.primbind#
from   sys.user$ u, sys.obj$ o, sys.opancillary$ a, sys.user$ u1, sys.obj$ o1,
       sys.opancillary$ a1
where  a.obj#=o.obj# and o.owner#=u.user#  AND
       a1.primop#=o1.obj# and o1.owner#=u1.user# and a.obj#=a1.obj#;

CREATE OR REPLACE FORCE VIEW "DBA_OPARGUMENTS"("OWNER",
select  c.name, b.name, a.bind#, a.position, a.type
  from  sys.oparg$ a, sys.obj$ b, sys.user$ c
  where a.obj# = b.obj# and b.owner# = c.user#;

CREATE OR REPLACE FORCE VIEW "DBA_OPBINDINGS"("OWNER",
select c.name, b.name, a.bind#, a.functionname, a.returnschema,
        a.returntype, a.impschema, a.imptype,
        decode(bitand(a.property,31), 1, 'WITH INDEX CONTEXT',
               3 , 'COMPUTE ANCILLARY DATA', 4 , 'ANCILLARY TO' ,
               16 , 'WITH COLUMN CONTEXT' ,
               17,  'WITH INDEX, COLUMN CONTEXT',
               19, 'COMPUTE ANCILLARY DATA, WITH COLUMN CONTEXT')
  from  sys.opbinding$ a, sys.obj$ b, sys.user$ c
  where a.obj# = b.obj# and b.owner# = c.user#;

CREATE OR REPLACE FORCE VIEW "DBA_OPERATORS"("OWNER",
select c.name, b.name, a.numbind from
  sys.operator$ a, sys.obj$ b, sys.user$ c where
  a.obj# = b.obj# and b.owner# = c.user#;

CREATE OR REPLACE FORCE VIEW "DBA_OPERATOR_COMMENTS"("OWNER",
select u.name, o.name, c.comment$
from   sys.obj$ o, sys.operator$ op, sys.com$ c, sys.user$ u
where  o.obj# = op.obj# and c.obj# = op.obj# and u.user# = o.owner#;

CREATE OR REPLACE FORCE VIEW "DBA_OPTSTAT_OPERATIONS"("OPERATION",
select operation, target, start_time, end_time
  from sys.wri$_optstat_opr;

CREATE OR REPLACE FORCE VIEW "DBA_OUTLINES"("NAME",
select ol_name, creator, category,
  decode(bitand(flags, 1), 0, 'UNUSED', 1, 'USED'),
  timestamp, version, sql_text, signature,
  decode(bitand(flags, 2), 0, 'COMPATIBLE', 2, 'INCOMPATIBLE'),
  decode(bitand(flags, 4), 0, 'ENABLED', 4, 'DISABLED'),
  decode(bitand(flags, 8), 0, 'NORMAL', 8, 'LOCAL')
from outln.ol$;

CREATE OR REPLACE FORCE VIEW "DBA_OUTLINE_HINTS"("NAME",
select o.ol_name, o.creator, h.node#, h.stage#, h.table_pos, h.hint_text
from outln.ol$ o, outln.ol$hints h
where o.ol_name = h.ol_name;

CREATE OR REPLACE FORCE VIEW "DBA_OUTSTANDING_ALERTS"("SEQUENCE_ID",
SELECT sequence_id,
            reason_id,
            owner,
            object_name,
            subobject_name,
            typnam_keltosd AS object_type,
            dbms_server_alert.expand_message(userenv('LANGUAGE'),
                                             mid_keltsd,
                                             reason_argument_1,
                                             reason_argument_2,
                                             reason_argument_3,
                                             reason_argument_4,
                                             reason_argument_5) AS reason,
            time_suggested,
            creation_time,
            dbms_server_alert.expand_message(userenv('LANGUAGE'),
                                             amid_keltsd,
                                             action_argument_1,
                                             action_argument_2,
                                             action_argument_3,
                                             action_argument_4,
                                             action_argument_5)
              AS suggested_action,
            advisor_name,
            metric_value,
            decode(message_level, 32, 'Notification', 'Warning')
              AS message_type,
            nam_keltgsd AS message_group,
            message_level,
            hosting_client_id,
            mdid_keltsd AS module_id,
            process_id,
            host_id,
            host_nw_addr,
            instance_name,
            instance_number,
            user_id,
            execution_context_id,
            error_instance_id
  FROM wri$_alert_outstanding, X$KELTSD, X$KELTOSD, X$KELTGSD,
       dba_advisor_definitions
  WHERE reason_id = rid_keltsd
    AND otyp_keltsd = typid_keltosd
    AND grp_keltsd = id_keltgsd
    AND aid_keltsd = advisor_id(+);

CREATE OR REPLACE FORCE VIEW "DBA_PARTIAL_DROP_TABS"("OWNER",
select u.name, o.name
from sys.user$ u, sys.obj$ o, sys.tab$ t
where t.obj# = o.obj#
      and bitand(t.flags,32768) = 32768
      and u.user# = o.owner#
      group by u.name, o.name;

CREATE OR REPLACE FORCE VIEW "DBA_PART_COL_STATISTICS"("OWNER",
select u.name, o.name, o.subname, tp.cname, h.distcnt, h.lowval, h.hival,
       h.density, h.null_cnt,
       case when h.bucket_cnt > 255 then h.row_cnt else
         decode(h.row_cnt, h.distcnt, h.row_cnt, h.bucket_cnt)
       end,
       h.sample_size, h.timestamp#,
       decode(bitand(h.spare2, 2), 2, 'YES', 'NO'),
       decode(bitand(h.spare2, 1), 1, 'YES', 'NO'),
       h.avgcln,
       case when h.bucket_cnt > 255 then 'FREQUENCY' else
         decode(nvl(h.row_cnt, 0), 0, 'NONE',
                                   h.distcnt, 'FREQUENCY', 'HEIGHT BALANCED')
       end
from sys.obj$ o, sys.hist_head$ h, tp$ tp, user$ u
where o.obj# = tp.obj# and o.owner# = u.user#
  and tp.obj# = h.obj#(+) and tp.intcol# = h.intcol#(+)
  and o.type# = 19 /* TABLE PARTITION */;

CREATE OR REPLACE FORCE VIEW "DBA_PART_HISTOGRAMS"("OWNER",
select u.name,
       o.name, o.subname,
       tp.cname,
       h.bucket,
       h.endpoint,
       h.epvalue
from sys.obj$ o, sys.histgrm$ h, sys.user$ u, tp$ tp
where o.obj# = tp.obj# and tp.obj# = h.obj#
  and tp.intcol# = h.intcol#
  and o.type# = 19 /* TABLE PARTITION */
  and o.owner# = u.user#
union
select u.name,
       o.name, o.subname,
       tp.cname,
       0,
       h.minimum,
       null
from sys.obj$ o, sys.hist_head$ h, sys.user$ u, tp$ tp
where o.obj# = tp.obj# and tp.obj# = h.obj#
  and tp.intcol# = h.intcol#
  and o.type# = 19 /* TABLE PARTITION */
  and h.bucket_cnt = 1
  and o.owner# = u.user#
union
select u.name,
       o.name, o.subname,
       tp.cname,
       1,
       h.maximum,
       null
from sys.obj$ o, sys.hist_head$ h, sys.user$ u, tp$ tp
where o.obj# = tp.obj# and tp.obj# = h.obj#
  and tp.intcol# = h.intcol#
  and o.type# = 19 /* TABLE PARTITION */
  and h.bucket_cnt = 1
  and o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "DBA_PART_INDEXES"("OWNER",
select u.name, io.name, o.name,
       decode(po.parttype, 1, 'RANGE', 2, 'HASH', 3, 'SYSTEM', 4, 'LIST',
                                                                  'UNKNOWN'),
       decode(mod(po.spare2, 256), 0, 'NONE', 2, 'HASH', 3, 'SYSTEM',
                                      4, 'LIST', 'UNKNOWN'),
       po.partcnt, mod(trunc(po.spare2/65536), 65536), po.partkeycols,
       mod(trunc(po.spare2/256), 256), decode(bitand(po.flags, 1), 1, 'LOCAL',    'GLOBAL'),
       decode(po.partkeycols, 0, 'NONE', decode(bitand(po.flags,2), 2, 'PREFIXED', 'NON_PREFIXED')),
       ts.name, po.defpctfree, po.definitrans,
       po.defmaxtrans,
       decode(po.deftiniexts, NULL, 'DEFAULT', po.deftiniexts),
       decode(po.defextsize, NULL, 'DEFAULT', po.defextsize),
       decode(po.defminexts, NULL, 'DEFAULT', po.defminexts),
       decode(po.defmaxexts, NULL, 'DEFAULT', po.defmaxexts),
       decode(po.defextpct,  NULL, 'DEFAULT', po.defextpct),
       po.deflists, po.defgroups,
       decode(po.deflogging, 0, 'NONE', 1, 'YES', 2, 'NO', 'UNKNOWN'),
       decode(po.spare1, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL),
       po.parameters
from   sys.obj$ io, sys.obj$ o, sys.partobj$ po, sys.ts$ ts, sys.ind$ i,
       sys.user$ u
where  io.obj# = po.obj# and po.defts# = ts.ts# (+) and
       i.obj# = io.obj# and o.obj# = i.bo# and u.user# = io.owner#;

CREATE OR REPLACE FORCE VIEW "DBA_PART_KEY_COLUMNS"("OWNER",
select u.name, o.name, 'TABLE',
  decode(bitand(c.property, 1), 1, a.name, c.name), pc.pos#
from partcol$ pc, obj$ o, col$ c, user$ u, attrcol$ a
where pc.obj# = o.obj# and pc.obj# = c.obj# and c.intcol# = pc.intcol# and
      u.user# = o.owner# and c.obj# = a.obj#(+) and c.intcol# = a.intcol#(+)
union
select u.name, io.name, 'INDEX',
  decode(bitand(c.property, 1), 1, a.name, c.name), pc.pos#
from partcol$ pc, obj$ io, col$ c, user$ u, ind$ i, attrcol$ a
where pc.obj# = i.obj# and i.obj# = io.obj# and i.bo# = c.obj# and
        c.intcol# = pc.intcol# and u.user# = io.owner#
        and c.obj# = a.obj#(+) and c.intcol# = a.intcol#(+);

CREATE OR REPLACE FORCE VIEW "DBA_PART_LOBS"("TABLE_OWNER",
select u.name,
       o.name,
       decode(bitand(c.property, 1), 1, a.name, c.name),
       lo.name,
       io.name,
       plob.defchunk,
       plob.defpctver$,
       decode(bitand(plob.defflags, 27), 1, 'NO', 2, 'NO', 8, 'CACHEREADS',
                                         16, 'CACHEREADS', 'YES'),
       decode(plob.defpro, 0, 'NO', 'YES'),
       ts.name,
       decode(plob.definiexts, NULL, 'DEFAULT', plob.definiexts),
       decode(plob.defextsize, NULL, 'DEFAULT', plob.defextsize),
       decode(plob.defminexts, NULL, 'DEFAULT', plob.defminexts),
       decode(plob.defmaxexts, NULL, 'DEFAULT', plob.defmaxexts),
       decode(plob.defextpct,  NULL, 'DEFAULT', plob.defextpct),
       decode(plob.deflists,   NULL, 'DEFAULT', plob.deflists),
       decode(plob.defgroups,  NULL, 'DEFAULT', plob.defgroups),
       decode(bitand(plob.defflags,22), 0,'NONE', 4,'YES', 2,'NO',
                                        16,'NO', 'UNKNOWN'),
       decode(plob.defbufpool, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL)
from   sys.obj$ o, sys.col$ c, sys.lob$ l, sys.partlob$ plob,
       sys.obj$ lo, sys.obj$ io, sys.ts$ ts, sys.user$ u, attrcol$ a
where o.owner# = u.user#
  and o.obj# = c.obj#
  and c.obj# = l.obj#
  and c.intcol# = l.intcol#
  and l.lobj# = lo.obj#
  and l.ind# = io.obj#
  and l.lobj# = plob.lobj#
  and plob.defts# = ts.ts# (+)
  and bitand(c.property,32768) != 32768           /* not unused column */
  and c.obj# = a.obj#(+) and c.intcol# = a.intcol#(+);

CREATE OR REPLACE FORCE VIEW "DBA_PART_TABLES"("OWNER",
select u.name, o.name,
       decode(po.parttype, 1, 'RANGE', 2, 'HASH', 3, 'SYSTEM', 4, 'LIST',
                                                                  'UNKNOWN'),
       decode(mod(po.spare2, 256), 0, 'NONE', 2, 'HASH', 3, 'SYSTEM',
                                      4, 'LIST', 'UNKNOWN'),
       po.partcnt, mod(trunc(po.spare2/65536), 65536), po.partkeycols,
       mod(trunc(po.spare2/256), 256),
       ts.name, po.defpctfree,
       decode(bitand(ts.flags, 32), 32,  to_number(NULL),po.defpctused),
       po.definitrans,
       po.defmaxtrans,
       decode(po.deftiniexts, NULL, 'DEFAULT', po.deftiniexts),
       decode(po.defextsize, NULL, 'DEFAULT', po.defextsize),
       decode(po.defminexts, NULL, 'DEFAULT', po.defminexts),
       decode(po.defmaxexts, NULL, 'DEFAULT', po.defmaxexts),
       decode(po.defextpct, NULL, 'DEFAULT', po.defextpct),
       decode(bitand(ts.flags, 32), 32,  to_number(NULL),po.deflists),
       decode(bitand(ts.flags, 32), 32, to_number(NULL), po.defgroups),
       decode(po.deflogging, 0, 'NONE', 1, 'YES', 2, 'NO', 'UNKNOWN'),
       decode(mod(trunc(po.spare2/4294967296),256), 0, 'NONE', 1, 'ENABLED',
                     2, 'DISABLED', 'UNKNOWN'),
       decode(po.spare1, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL)
from   sys.obj$ o, sys.partobj$ po, sys.ts$ ts, sys.tab$ t, sys.user$ u
where  o.obj# = po.obj# and po.defts# = ts.ts# and t.obj# = o.obj# and
       o.owner# = u.user# and
       bitand(t.property, 64 + 128) = 0
union all -- NON-IOT and IOT
select u.name, o.name,
       decode(po.parttype, 1, 'RANGE', 2, 'HASH', 3, 'SYSTEM', 4, 'LIST',
                                                                  'UNKNOWN'),
       decode(mod(po.spare2, 256), 0, 'NONE', 2, 'HASH', 3, 'SYSTEM',
                                     4, 'LIST', 'UNKNOWN'),
       po.partcnt, mod(trunc(po.spare2/65536), 65536), po.partkeycols,
       mod(trunc(po.spare2/256), 256),
       NULL, TO_NUMBER(NULL),TO_NUMBER(NULL),TO_NUMBER(NULL),TO_NUMBER(NULL),
       NULL,--decode(po.deftiniexts, NULL, 'DEFAULT', po.deftiniexts),
       NULL,--decode(po.defextsize, NULL, 'DEFAULT', po.defextsize),
       NULL,--decode(po.defminexts, NULL, 'DEFAULT', po.defminexts),
       NULL,--decode(po.defmaxexts, NULL, 'DEFAULT', po.defmaxexts),
       NULL,--decode(po.defextpct, NULL, 'DEFAULT', po.defextpct),
       TO_NUMBER(NULL),TO_NUMBER(NULL),--po.deflists, po.defgroups,
       decode(po.deflogging, 0, 'NONE', 1, 'YES', 2, 'NO', 'UNKNOWN'),
       'N/A',
       decode(po.spare1, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL)
from   sys.obj$ o, sys.partobj$ po, sys.tab$ t, sys.user$ u
where  o.obj# = po.obj# and t.obj# = o.obj# and
       o.owner# = u.user# and
       bitand(t.property, 64 + 128) != 0;

CREATE OR REPLACE FORCE VIEW "DBA_PENDING_CONV_TABLES"("OWNER",
select u.name, o.name
from sys.obj$ o, user$ u
  where o.type# = 2 and o.status = 5
  and bitand(o.flags, 4096) = 4096  /* type evolved flg */
  and o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "DBA_PENDING_TRANSACTIONS"("FORMATID",
(((select formatid, globalid, branchid
   from   gv$global_transaction
   where  preparecount > 0 and refcount = preparecount)
 minus
  (select global_tran_fmt, global_foreign_id, branch_id
   from   sys.pending_trans$ tran, sys.pending_sessions$ sess
   where  tran.local_tran_id = sess.local_tran_id
     and  tran.state != 'collecting'
     and  dbms_utility.is_bit_set(tran.session_vector, sess.session_id)=1)
 )
 union
  (select global_tran_fmt, global_foreign_id, branch_id
   from   sys.pending_trans$ tran, sys.pending_sessions$ sess
   where  tran.local_tran_id = sess.local_tran_id
     and  tran.state != 'collecting'
     and  dbms_utility.is_bit_set(tran.session_vector, sess.session_id)=1)
);

CREATE OR REPLACE FORCE VIEW "DBA_PLSQL_OBJECT_SETTINGS"("OWNER",
select u.name, o.name,
decode(o.type#, 7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE',
                11, 'PACKAGE BODY', 12, 'TRIGGER',
                13, 'TYPE', 14, 'TYPE BODY', 'UNDEFINED'),
(select to_number(value) from settings$ s
  where s.obj# = o.obj# and param = 'plsql_optimize_level'),
(select value from settings$ s
  where s.obj# = o.obj# and param = 'plsql_code_type'),
(select value from settings$ s
  where s.obj# = o.obj# and param = 'plsql_debug'),
(select value from settings$ s
  where s.obj# = o.obj# and param = 'plsql_warnings'),
(select value from settings$ s
  where s.obj# = o.obj# and param = 'nls_length_semantics')
from sys.obj$ o, sys.user$ u
where o.owner# = u.user#
  and o.type# in (7, 8, 9, 11, 12, 13, 14);

CREATE OR REPLACE FORCE VIEW "DBA_POLICIES"("OBJECT_OWNER",
select u.name, o.name, r.gname, r.pname, r.pfschma, r.ppname, r.pfname,
       decode(bitand(r.stmt_type,1), 0, 'NO', 'YES'),
       decode(bitand(r.stmt_type,2), 0, 'NO', 'YES'),
       decode(bitand(r.stmt_type,4), 0, 'NO', 'YES'),
       decode(bitand(r.stmt_type,8), 0, 'NO', 'YES'),
       decode(bitand(r.stmt_type,2048), 0, 'NO', 'YES'),
       decode(r.check_opt, 0, 'NO', 'YES'),
       decode(r.enable_flag, 0, 'NO', 'YES'),
       decode(bitand(r.stmt_type,16), 0, 'NO', 'YES'),
       case bitand(r.stmt_type,16)+
            bitand(r.stmt_type,64)+
            bitand(r.stmt_type,128)+
            bitand(r.stmt_type,256)
         when 16 then 'STATIC'
         when 64 then 'SHARED_STATIC'
         when 128 then 'CONTEXT_SENSITIVE'
         when 256 then 'SHARED_CONTEXT_SENSITIVE'
         else 'DYNAMIC'
       end,
   decode(bitand(r.stmt_type,512), 0, 'YES', 'NO')
from user$ u, obj$ o, rls$ r
where u.user# = o.owner#
and r.obj# = o.obj#;

CREATE OR REPLACE FORCE VIEW "DBA_POLICY_CONTEXTS"("OBJECT_OWNER",
select u.name, o.name, c.ns, c.attr
from user$ u, obj$ o, rls_ctx$ c
where u.user# = o.owner#
and c.obj# = o.obj#;

CREATE OR REPLACE FORCE VIEW "DBA_POLICY_GROUPS"("OBJECT_OWNER",
select u.name, o.name, g.gname
from user$ u, obj$ o, rls_grp$ g
where u.user# = o.owner#
and g.obj# = o.obj#;

CREATE OR REPLACE FORCE VIEW "DBA_PRIV_AUDIT_OPTS"("USER_NAME",
select decode(aud.user#, 0 /* client operations through proxy */, 'ANY CLIENT',
                         1 /* System wide auditing*/, null,
                         client.name) /* USER_NAME */,
       proxy.name       /* PROXY_NAME */,
       prv.name         /* PRIVILEGE */,
       decode(aud.success, 1, 'BY SESSION', 2, 'BY ACCESS', 'NOT SET')
                        /* SUCCESS */,
       decode(aud.failure, 1, 'BY SESSION', 2, 'BY ACCESS', 'NOT SET')
                        /* FAILURE */
from sys.user$ client, sys.user$ proxy, system_privilege_map prv,
     sys.audit$ aud
where aud.option# = -prv.privilege
  and aud.user# = client.user#
  and aud.proxy# = proxy.user#(+);

CREATE OR REPLACE FORCE VIEW "DBA_PROCEDURES"("OWNER",
select u.name, o.name, pi.procedurename,
decode(bitand(pi.properties,8),8,'YES','NO'),
decode(bitand(pi.properties,16),16,'YES','NO'),
u2.name, o2.name,
  decode(bitand(pi.properties,32),32,'YES','NO'),
  decode(bitand(pi.properties,512),512,'YES','NO'),
decode(bitand(pi.properties,256),256,'YES','NO'),
decode(bitand(pi.properties,1024),1024,'CURRENT_USER','DEFINER')
from obj$ o, user$ u, procedureinfo$ pi, obj$ o2, user$ u2
where u.user# = o.owner# and o.obj# = pi.obj#
and pi.itypeobj# = o2.obj# (+) and o2.owner#  = u2.user# (+);

CREATE OR REPLACE FORCE VIEW "DBA_PROFILES"("PROFILE",
select
   n.name, m.name,
   decode(u.type#, 0, 'KERNEL', 1, 'PASSWORD', 'INVALID'),
   decode(u.limit#,
          0, 'DEFAULT',
          2147483647, decode(u.resource#,
                             4, decode(u.type#,
                                       1, 'NULL', 'UNLIMITED'),
                             'UNLIMITED'),
          decode(u.resource#,
                 4, decode(u.type#, 1, o.name, u.limit#),
                 decode(u.type#,
                        0, u.limit#,
                        decode(u.resource#,
                               1, trunc(u.limit#/86400, 4),
                               2, trunc(u.limit#/86400, 4),
                               5, trunc(u.limit#/86400, 4),
                               6, trunc(u.limit#/86400, 4),
                               u.limit#))))
  from sys.profile$ u, sys.profname$ n, sys.resource_map m, sys.obj$ o
  where u.resource# = m.resource#
  and u.type#=m.type#
  and o.obj# (+) = u.limit#
  and n.profile# = u.profile#;

CREATE OR REPLACE FORCE VIEW "DBA_PROPAGATION"("PROPAGATION_NAME",
SELECT p.propagation_name, p.source_queue_schema, p.source_queue,
       p.destination_queue_schema, p.destination_queue, p.destination_dblink,
       p.ruleset_schema, p.ruleset, p.negative_ruleset_schema,
       p.negative_ruleset
  FROM sys.streams$_propagation_process p;

CREATE OR REPLACE FORCE VIEW "DBA_PROXIES"("PROXY",
select u1.name,
       u2.name,
       decode(p.credential_type#, 0, 'NO',
                                  5, 'YES'),
       decode(p.flags, 0, null,
                       1, 'PROXY MAY ACTIVATE ALL CLIENT ROLES',
                       2, 'NO CLIENT ROLES MAY BE ACTIVATED',
                       4, 'PROXY MAY ACTIVATE ROLE',
                       5, 'PROXY MAY ACTIVATE ALL CLIENT ROLES',
                       8, 'PROXY MAY NOT ACTIVATE ROLE'),
       (select u.name from sys.user$ u where pr.role# = u.user#)
from sys.user$ u1, sys.user$ u2,
     sys.proxy_info$ p, sys.proxy_role_info$ pr
where u1.user#  = p.proxy#
  and u2.user#  = p.client#
  and p.proxy#  = pr.proxy#(+)
  and p.client# = pr.client#(+);

CREATE OR REPLACE FORCE VIEW "DBA_PUBLISHED_COLUMNS"("CHANGE_SET_NAME",
SELECT
   s.change_set_name, s.change_table_schema, s.change_table_name, s.obj#,
   s.source_schema_name, s.source_table_name, c.column_name,
   c.data_type, c.data_length, c.data_precision, c.data_scale, c.nullable
  FROM sys.cdc_change_tables$ s, all_tables t, all_tab_columns c
  WHERE s.change_table_schema=t.owner AND
        s.change_table_name=t.table_name AND
        c.owner=s.change_table_schema AND
        c.table_name=s.change_table_name AND
        c.column_name NOT LIKE '%$';

CREATE OR REPLACE FORCE VIEW "DBA_QUEUES"("OWNER",
select u.name OWNER, q.name NAME, t.name QUEUE_TABLE, q.eventid QID,
       decode(q.usage, 1, 'EXCEPTION_QUEUE', 2, 'NON_PERSISTENT_QUEUE',
              'NORMAL_QUEUE') QUEUE_TYPE,
       q.max_retries MAX_RETRIES, q.retry_delay RETRY_DELAY,
       decode(bitand(q.enable_flag, 1), 1 , '  YES  ', '  NO  ')ENQUEUE_ENABLED,
       decode(bitand(q.enable_flag, 2), 2 , '  YES  ', '  NO  ')DEQUEUE_ENABLED,
       decode(q.ret_time, -1, ' FOREVER', q.ret_time) RETENTION,
       substr(q.queue_comment, 1, 50) USER_COMMENT
from system.aq$_queues q, system.aq$_queue_tables t, sys.user$ u
where u.name  = t.schema
and   q.table_objno = t.objno;

CREATE OR REPLACE FORCE VIEW "DBA_QUEUE_PUBLISHERS"("QUEUE_OWNER",
select t.schema QUEUE_OWNER, q.name QUEUE_NAME,
        p.p_name PUBLISHER_NAME, p.p_address PUBLISHER_ADDRESS,
        p.p_protocol PUBLISHER_PROTOCOL, p.p_rule PUBLISHER_RULE,
        p.p_rule_name PUBLISHER_RULE_NAME, p.p_ruleset PUBLISHER_RULESET,
        p.p_transformation PUBLISHER_TRANSFORMATION
from
 system.aq$_queue_tables t,  system.aq$_queues q,
 sys.aq$_publisher p, sys.user$ u
where
 q.table_objno = t.objno and q.eventid = p.queue_id
 and u.name  = t.schema;

CREATE OR REPLACE FORCE VIEW "DBA_QUEUE_SCHEDULES"("SCHEMA",
select t.schema SCHEMA, q.name QNAME,
       s.destination DESTINATION, s.start_time START_DATE,
       substr(to_char(s.start_time,'HH24:MI:SS'),1,8) START_TIME,
       to_number(s.duration) PROPAGATION_WINDOW,
       s.next_time NEXT_TIME, to_number(s.latency) LATENCY,
       s.disabled SCHEDULE_DISABLED, s.process_name PROCESS_NAME,
       decode(s.sid, NULL, NULL,
         concat(to_char(s.sid), concat(', ',to_char(s.serial)))) SESSION_ID,
       s.instance INSTANCE, s.last_run LAST_RUN_DATE,
       substr(to_char(s.last_run,'HH24:MI:SS'),1,8) LAST_RUN_TIME,
       s.cur_start_time CURRENT_START_DATE,
       substr(to_char(s.cur_start_time,'HH24:MI:SS'),1,8) CURRENT_START_TIME,
       s.next_run NEXT_RUN_DATE,
       substr(to_char(s.next_run,'HH24:MI:SS'),1,8) NEXT_RUN_TIME,
       s.total_time TOTAL_TIME, s.total_msgs TOTAL_NUMBER,
       s.total_bytes TOTAL_BYTES,
       s.max_num_per_win MAX_NUMBER, s.max_size MAX_BYTES,
       s.total_msgs/decode(s.total_windows, 0, 1, s.total_windows) AVG_NUMBER,
       s.total_bytes/decode(s.total_msgs, 0, 1, s.total_msgs) AVG_SIZE,
       s.total_time/decode(s.total_msgs, 0, 1, s.total_msgs) AVG_TIME,
       s.failures FAILURES, s.error_time LAST_ERROR_DATE,
       substr(to_char(s.error_time,'HH24:MI:SS'),1,8) LAST_ERROR_TIME,
       s.last_error_msg LAST_ERROR_MSG
from system.aq$_queues q, system.aq$_queue_tables t,
     sys.aq$_schedules s
where s.oid  = q.oid
and   q.table_objno = t.objno;

CREATE OR REPLACE FORCE VIEW "DBA_QUEUE_TABLES"("OWNER",
select t.schema OWNER, t.name QUEUE_TABLE,
     decode(t.udata_type, 1 , 'OBJECT', 2, 'VARIANT', 3, 'RAW') TYPE,
     u.name || '.' || o.name OBJECT_TYPE,
     decode(t.sort_cols, 0, 'NONE', 1, 'PRIORITY', 2, 'ENQUEUE_TIME',
                               3, 'PRIORITY, ENQUEUE_TIME',
                               7, 'ENQUEUE_TIME, PRIORITY') SORT_ORDER,
     decode(bitand(t.flags, 1), 1, 'MULTIPLE', 0, 'SINGLE') RECIPIENTS,
     decode(bitand(t.flags, 2), 2, 'TRANSACTIONAL', 0, 'NONE')MESSAGE_GROUPING,
     decode(bitand(t.flags, 8), 8, '8.1.3', 0, '8.0.3')COMPATIBLE,
     aft.primary_instance PRIMARY_INSTANCE,
     aft.secondary_instance SECONDARY_INSTANCE,
     aft.owner_instance OWNER_INSTANCE,
     substr(t.table_comment, 1, 50) USER_COMMENT,
     decode(bitand(t.flags, 4096), 4096, 'YES', 0, 'NO') SECURE
from system.aq$_queue_tables t, sys.col$ c, sys.coltype$ ct, sys.obj$ o,
sys.user$ u, sys.aq$_queue_table_affinities aft
where c.intcol# = ct.intcol#
and c.obj# = ct.obj#
and c.name = 'USER_DATA'
and t.objno = c.obj#
and o.oid$ = ct.toid
and o.type# = 13
and o.owner# = u.user#
and t.objno = aft.table_objno
union
select t.schema OWNER, t.name QUEUE_TABLE,
     decode(t.udata_type, 1 , 'OBJECT', 2, 'VARIANT', 3, 'RAW') TYPE,
     null OBJECT_TYPE,
     decode(t.sort_cols, 0, 'NONE', 1, 'PRIORITY', 2, 'ENQUEUE_TIME',
                               3, 'PRIORITY, ENQUEUE_TIME',
                               7, 'ENQUEUE_TIME, PRIORITY') SORT_ORDER,
     decode(bitand(t.flags, 1), 1, 'MULTIPLE', 0, 'SINGLE') RECIPIENTS,
     decode(bitand(t.flags, 2), 2, 'TRANSACTIONAL', 0, 'NONE')MESSAGE_GROUPING,
     decode(bitand(t.flags, 8), 8, '8.1.3', 0, '8.0.3')COMPATIBLE,
     aft.primary_instance PRIMARY_INSTANCE,
     aft.secondary_instance SECONDARY_INSTANCE,
     aft.owner_instance OWNER_INSTANCE,
     substr(t.table_comment, 1, 50) USER_COMMENT,
     decode(bitand(t.flags, 4096), 4096, 'YES', 0, 'NO') SECURE
from system.aq$_queue_tables t, sys.aq$_queue_table_affinities aft
where (t.udata_type = 2
or t.udata_type = 3)
and t.objno = aft.table_objno;

CREATE OR REPLACE FORCE VIEW "DBA_RCHILD"("REFGROUP",
select REFGROUP, OWNER, NAME, TYPE# from rgchild$ r
   where r.instsite = 0;

CREATE OR REPLACE FORCE VIEW "DBA_RECYCLEBIN"("OWNER",
select u.name, o.name, r.original_name,
       decode(r.operation, 0, 'DROP', 1, 'TRUNCATE', 'UNDEFINED'),
       decode(r.type#, 1, 'TABLE', 2, 'INDEX', 3, 'INDEX',
                       4, 'NESTED TABLE', 5, 'LOB', 6, 'LOB INDEX',
                       7, 'DOMAIN INDEX', 8, 'IOT TOP INDEX',
                       9, 'IOT OVERFLOW SEGMENT', 10, 'IOT MAPPING TABLE',
                       11, 'TRIGGER', 12, 'CONSTRAINT', 13, 'Table Partition',
                       14, 'Table Composite Partition', 15, 'Index Partition',
                       16, 'Index Composite Partition', 17, 'LOB Partition',
                       18, 'LOB Composite Partition',
                       'UNDEFINED'),
       t.name,
       to_char(o.ctime, 'YYYY-MM-DD:HH24:MI:SS'),
       to_char(r.droptime, 'YYYY-MM-DD:HH24:MI:SS'),
       r.dropscn, r.partition_name,
       decode(bitand(r.flags, 4), 0, 'NO', 4, 'YES', 'NO'),
       decode(bitand(r.flags, 2), 0, 'NO', 2, 'YES', 'NO'),
       r.related, r.bo, r.purgeobj, r.space
from sys.obj$ o, sys.recyclebin$ r, sys.user$ u, sys.ts$ t
where o.obj# = r.obj#
  and r.owner# = u.user#
  and r.ts# = t.ts#(+);

CREATE OR REPLACE FORCE VIEW "DBA_REDEFINITION_ERRORS"("OBJECT_TYPE",
select decode(obj_type, 1, 'TABLE',
                        2, 'INDEX',
                        3, 'CONSTRAINT',
                        4, 'TRIGGER',
                        'UNKNOWN'),
       obj_owner, obj_name, bt_owner, bt_name, ddl_txt
from sys.redef_dep_error$;

CREATE OR REPLACE FORCE VIEW "DBA_REDEFINITION_OBJECTS"("OBJECT_TYPE",
select decode(obj_type, 1, 'TABLE',
                        2, 'INDEX',
                        3, 'CONSTRAINT',
                        4, 'TRIGGER',
                        'UNKNOWN'),
       obj_owner, obj_name, bt_owner, bt_name, int_obj_owner, int_obj_name
from sys.redef_object$;

CREATE OR REPLACE FORCE VIEW "DBA_REFRESH"("ROWNER",
select r.owner ROWNER, r.name RNAME, r.REFGROUP,
          decode(bitand(r.flag,1),1,'Y',0,'N','?') IMPLICIT_DESTROY,
          decode(bitand(r.flag,2),2,'Y',0,'N','?') PUSH_DEFERRED_RPC,
          decode(bitand(r.flag,4),4,'Y',0,'N','?') REFRESH_AFTER_ERRORS,
          r.rollback_seg ROLLBACK_SEG,
          j.JOB, j.NEXT_DATE, j.INTERVAL# interval,
          decode(bitand(j.flag,1),1,'Y',0,'N','?') BROKEN,
          r.purge_opt#   PURGE_OPTION,
          r.parallelism# PARALLELISM,
          r.heap_size#   HEAP_SIZE
  from rgroup$ r, job$ j
  where r.instsite = 0
  and   r.job = j.job(+);

CREATE OR REPLACE FORCE VIEW "DBA_REFRESH_CHILDREN"("OWNER",
select rc.owner OWNER, rc.name NAME, rc.TYPE# TYPE,
          r.owner ROWNER, r.name RNAME, r.REFGROUP,
          decode(bitand(r.flag,1),1,'Y',0,'N','?') IMPLICIT_DESTROY,
          decode(bitand(r.flag,2),2,'Y',0,'N','?') PUSH_DEFERRED_RPC,
          decode(bitand(r.flag,4),4,'Y',0,'N','?') REFRESH_AFTER_ERRORS,
          r.rollback_seg ROLLBACK_SEG,
          j.job, j.NEXT_DATE, j.INTERVAL# interval,
          decode(bitand(j.flag,1),1,'Y',0,'N','?') BROKEN,
          r.purge_opt#   PURGE_OPTION,
          r.parallelism# PARALLELISM,
          r.heap_size#   HEAP_SIZE
  from rgroup$ r, rgchild$ rc, job$ j
  where r.refgroup = rc.refgroup
    and r.instsite = 0
    and rc.instsite = 0
    and r.job = j.job (+);

CREATE OR REPLACE FORCE VIEW "DBA_REFS"("OWNER",
select distinct u.name, o.name,
       decode(bitand(c.property, 1), 1, ac.name, c.name),
       decode(bitand(rc.reftyp, 2), 2, 'YES', 'NO'),
       decode(bitand(rc.reftyp, 1), 1, 'YES', 'NO'),
       su.name, so.name,
       case
         when bitand(reftyp,4) = 4 then 'USER-DEFINED'
         when bitand(reftyp, 8) = 8 then 'SYSTEM GENERATED AND USER-DEFINED'
         else 'SYSTEM GENERATED'
       end
from sys.obj$ o, sys.col$ c, sys.user$ u, sys.refcon$ rc, sys.obj$ so,
     sys.user$ su, sys.attrcol$ ac
where o.owner# = u.user#
  and o.obj# = c.obj#
  and c.obj# = rc.obj#
  and c.col# = rc.col#
  and c.intcol# = rc.intcol#
  and rc.stabid = so.oid$(+)
  and so.owner# = su.user#(+)
  and c.obj# = ac.obj#(+)
  and c.intcol# = ac.intcol#(+)
  and bitand(c.property,32768) != 32768           /* not unused column */;

CREATE OR REPLACE FORCE VIEW "DBA_REGISTERED_ARCHIVED_LOG"("CONSUMER_NAME",
select cp.capture_name, cp.source_dbname,
       l.thread#, l.sequence#, l.first_change#,
       l.next_change#, l.first_time, l.next_time,
       l.file_name, l.timestamp,
       l.dict_begin, l.dict_end
  from system.logmnr_log$ l, sys.streams$_capture_process cp
  where l.session# = cp.logmnr_sid;

CREATE OR REPLACE FORCE VIEW "DBA_REGISTERED_MVIEWS"("OWNER",
select sowner, snapname, snapsite,
   decode(bitand(flag,1), 0 , 'NO', 'YES'),
   decode(bitand(flag,2), 0 , 'NO', 'YES'),
   decode(bitand(flag, 32),               32, 'PRIMARY KEY',
          decode(bitand(flag, 536870912), 536870912, 'OBJECT ID', 'ROWID')),
   snapshot_id,
   decode(rep_type, 1, 'ORACLE 7 MATERIALIZED VIEW',
                    2, 'ORACLE 8 MATERIALIZED VIEW',
                    3, 'REPAPI MATERIALIZED VIEW',
                       'UNKNOWN'),
   query_txt
from sys.reg_snap$;

CREATE OR REPLACE FORCE VIEW "DBA_REGISTERED_MVIEW_GROUPS"("NAME",
select s.gname, s.dblink, s.group_comment,
          decode(s.rep_type, 1, 'ORACLE 7',
                             2, 'ORACLE 8',
                             3, 'REPAPI',
                                'UNKNOWN'),
          f.fname, s.gowner
from system.repcat$_snapgroup s, system.repcat$_flavors f
  WHERE s.gname     = f.gname (+)
    AND s.flavor_id = f.flavor_id (+)
    AND s.gowner    = f.gowner (+);

CREATE OR REPLACE FORCE VIEW "DBA_REGISTERED_SNAPSHOTS"("OWNER",
select sowner, snapname, snapsite,
   decode(bitand(flag,1), 0 , 'NO', 'YES'),
   decode(bitand(flag,2), 0 , 'NO', 'YES'),
   decode(bitand(flag, 32),               32, 'PRIMARY KEY',
          decode(bitand(flag, 536870912), 536870912, 'OBJECT ID', 'ROWID')),
   snapshot_id,
   decode(rep_type, 1, 'ORACLE 7 SNAPSHOT',
                    2, 'ORACLE 8 SNAPSHOT',
                    3, 'REPAPI SNAPSHOT',
                       'UNKNOWN'),
   query_txt
from sys.reg_snap$;

CREATE OR REPLACE FORCE VIEW "DBA_REGISTERED_SNAPSHOT_GROUPS"("NAME",
select s.gname, s.dblink, s.group_comment,
          decode(s.rep_type, 1, 'ORACLE 7',
                             2, 'ORACLE 8',
                             3, 'REPAPI',
                                'UNKNOWN'),
          f.fname, s.gowner
from system.repcat$_snapgroup s, system.repcat$_flavors f
  WHERE s.gname     = f.gname (+)
    AND s.flavor_id = f.flavor_id (+)
    AND s.gowner    = f.gowner (+);

CREATE OR REPLACE FORCE VIEW "DBA_REGISTRY"("COMP_ID",
SELECT r.cid, r.cname, r.version,
       DECODE(r.status, 0, 'INVALID',
                        1, 'VALID',
                        2, 'LOADING',
                        3, 'LOADED',
                        4, 'UPGRADING',
                        5, 'UPGRADED',
                        6, 'DOWNGRADING',
                        7, 'DOWNGRADED',
                        8, 'REMOVING',
                        9, 'OPTION OFF',
                        10, 'NO SCRIPT',
                        99, 'REMOVED',
                        NULL),
       TO_CHAR(r.modified,'DD-MON-YYYY HH24:MI:SS'),
       r.namespace, i.name, s.name, r.vproc,
       DECODE(bitand(r.flags,1),1,'REQUIRED',NULL), r.pid
FROM registry$ r, user$ s, user$ i
WHERE r.schema# = s.user# AND r.invoker#=i.user#;

CREATE OR REPLACE FORCE VIEW "DBA_REGISTRY_HIERARCHY"("NAMESPACE",
SELECT namespace, LPAD(' ',2*(LEVEL-1)) || LEVEL || ' ' || cid, version,
       DECODE(status, 0, 'INVALID',
                      1, 'VALID',
                      2, 'LOADING',
                      3, 'LOADED',
                      4, 'UPGRADING',
                      5, 'UPGRADED',
                      6, 'DOWNGRADING',
                      7, 'DOWNGRADED',
                      8, 'REMOVING',
                      9, 'OPTION OFF',
                      10, 'NO SCRIPT',
                      99, 'REMOVED',
                      NULL),
       TO_CHAR(modified,'DD-MON-YYYY HH24:MI:SS')
FROM registry$
START WITH pid IS NULL
CONNECT BY PRIOR cid = pid and PRIOR namespace = namespace;

CREATE OR REPLACE FORCE VIEW "DBA_REPAUDIT_ATTRIBUTE"("ATTRIBUTE",
select
    attribute,
    decode(data_type_id,
           1, 'NUMBER',
           2, 'VARCHAR2',
           3, 'DATE',
           4, 'CHAR',
           5, 'RAW',
           6, 'NVARCHAR2',
           7, 'NCHAR',
           'UNDEFINED'),
    data_length,
    source
from  system.repcat$_audit_attribute;

CREATE OR REPLACE FORCE VIEW "DBA_REPAUDIT_COLUMN"("SNAME",
select
    sname,
    oname,
    column_name,
    base_sname,
    base_oname,
    decode(base_conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    base_reference_name,
    attribute
from  system.repcat$_audit_column;

CREATE OR REPLACE FORCE VIEW "DBA_REPCAT"("SNAME",
select "SNAME",

CREATE OR REPLACE FORCE VIEW "DBA_REPCATLOG"("ID",
select r.id, r.source, r.status, r.userid, r.timestamp, r.role, r.master,
  r.sname, r.request, r.oname, r.type, r.message, r.errnum, r.gname
from repcat_repcatlog r;

CREATE OR REPLACE FORCE VIEW "DBA_REPCAT_EXCEPTIONS"("EXCEPTION_ID",
select re.exception_id, re.user_name, re.request, re.job,
  re.error_date,re.error_number,re.error_message,re.line_number
from system.repcat$_exceptions re;

CREATE OR REPLACE FORCE VIEW "DBA_REPCAT_REFRESH_TEMPLATES"("REFRESH_TEMPLATE_NAME",
select refresh_template_name,owner,refresh_group_name,template_comment,
 nvl(public_template,'N') public_template
from system.repcat$_refresh_templates t,
  system.repcat$_template_types tt
where tt.template_type_id = t.template_type_id
and bitand(rawtohex(tt.flags),1) = 1;

CREATE OR REPLACE FORCE VIEW "DBA_REPCAT_TEMPLATE_OBJECTS"("REFRESH_TEMPLATE_NAME",
select rt.refresh_template_name,
t.object_name, ot.object_type_name object_type,
t.ddl_num,t.ddl_text,t.master_rollback_seg,
t.derived_from_sname,t.derived_from_oname,t.flavor_id
from system.repcat$_refresh_templates rt,
  system.repcat$_template_objects t,
  system.repcat$_object_types ot,
  system.repcat$_template_types tt
where t.refresh_template_id = rt.refresh_template_id
and ot.object_type_id = t.object_type
and rt.template_type_id = tt.template_type_id
and bitand(rawtohex(tt.flags),1) = 1;

CREATE OR REPLACE FORCE VIEW "DBA_REPCAT_TEMPLATE_PARMS"("REFRESH_TEMPLATE_NAME",
select rt.refresh_template_name,rt.owner,
  rt.refresh_group_name,rt.template_comment,
  nvl(rt.public_template,'N'),tp.parameter_name,
  tp.default_parm_value, tp.prompt_string, tp.user_override
from system.repcat$_refresh_templates rt,
  system.repcat$_template_parms tp,
  system.repcat$_template_types tt
where tp.refresh_template_id = rt.refresh_template_id
and rt.template_type_id = tt.template_type_id
and bitand(rawtohex(tt.flags),1) = 1;

CREATE OR REPLACE FORCE VIEW "DBA_REPCAT_TEMPLATE_SITES"("REFRESH_TEMPLATE_NAME",
select ts.refresh_template_name, ts.refresh_group_name, ts.template_owner,
  ts.user_name,ts.site_name,ss.site_name,
  decode(status,-1,'DELETED',0,'INSTALLING',1,'INSTALLED','UNDEFINED'),
  instantiation_date
from system.repcat$_template_sites ts,
  sys.snap_site$ ss
where ts.status != -100
and ts.repapi_site_id = ss.site_id (+);

CREATE OR REPLACE FORCE VIEW "DBA_REPCAT_USER_AUTHORIZATIONS"("REFRESH_TEMPLATE_NAME",
select rt.refresh_template_name,rt.owner,rt.refresh_group_name,
rt.template_comment, nvl(rt.public_template,'N'),
u.username
from system.repcat$_refresh_templates rt,
all_users u,
system.repcat$_user_authorizations ra,
system.repcat$_template_types tt
where u.user_id = ra.user_id
and ra.refresh_template_id = rt.refresh_template_id
and tt.template_type_id = rt.template_type_id
and bitand(rawtohex(tt.flags),1) = 1;

CREATE OR REPLACE FORCE VIEW "DBA_REPCAT_USER_PARM_VALUES"("REFRESH_TEMPLATE_NAME",
select rt.refresh_template_name,rt.owner,
  rt.refresh_group_name,rt.template_comment,
  nvl(rt.public_template,'N'),tp.parameter_name,
  tp.default_parm_value, tp.prompt_string, sp.parm_value,
  u.username
from system.repcat$_refresh_templates rt,
  system.repcat$_template_parms tp,
  system.repcat$_user_parm_values sp,
  dba_users  u,
  system.repcat$_template_types tt
where tp.refresh_template_id = rt.refresh_template_id
and tp.template_parameter_id = sp.template_parameter_id
and sp.user_id = u.user_id
and rt.template_type_id = tt.template_type_id
and bitand(rawtohex(tt.flags),1) = 1;

CREATE OR REPLACE FORCE VIEW "DBA_REPCOLUMN"("SNAME",
select sname, oname, type, cname, id, nvl(pos, lpos), compare_old_on_delete,
          compare_old_on_update, send_old_on_delete, send_old_on_update,
          ctype, ctype_toid, ctype_owner, ctype_hashcode, ctype_mod,
          data_length, data_precision, data_scale, nullable,
          character_set_name, top, char_length, char_used
from repcat_repcolumn_base;

CREATE OR REPLACE FORCE VIEW "DBA_REPCOLUMN_GROUP"("SNAME",
select
    sname,
    oname,
    group_name,
    group_comment
from  system.repcat$_column_group;

CREATE OR REPLACE FORCE VIEW "DBA_REPCONFLICT"("SNAME",
select
    sname,
    oname,
    decode(conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    reference_name
from  system.repcat$_conflict;

CREATE OR REPLACE FORCE VIEW "DBA_REPDDL"("LOG_ID",
select r.log_id, r.source, r.role, r.master, r.line, r.text, r.ddl_num
from system.repcat$_ddl r;

CREATE OR REPLACE FORCE VIEW "DBA_REPEXTENSIONS"("EXTENSION_ID",
select
  r.extension_id,
  DECODE(r.extension_code,
         0, 'ADD_NEW_MASTERS') request,
  r.masterdef,
  DECODE(export_required, 'Y', 'YES', 'N', 'NO') export_required,
  r.repcatlog_id,
  DECODE(r.extension_status,
         0, 'READY',
         1, 'STOPPING',
         2, 'EXPORTING',
         3, 'INSTANTIATING',
         4, 'ERROR') extension_status,
  r.flashback_scn,
  DECODE(r.push_to_mdef, 'Y', 'YES', 'N', 'NO') break_trans_to_masterdef,
  DECODE(r.push_to_new, 'Y', 'YES', 'N', 'NO') break_trans_to_new_masters,
  r.percentage_for_catchup_mdef,
  r.cycle_seconds_mdef,
  r.percentage_for_catchup_new,
  r.cycle_seconds_new
from system.repcat$_extension r;

CREATE OR REPLACE FORCE VIEW "DBA_REPFLAVORS"("FLAVOR_ID",
select f.flavor_id, f.gname, f.fname, f.creation_date, u.name, f.published,
       f.gowner
from system.repcat$_flavors f, user$ u
where f.created_by = u.user# (+);

CREATE OR REPLACE FORCE VIEW "DBA_REPFLAVOR_COLUMNS"("FNAME",
SELECT fname, gname, sname, oname, cname, type, pos, group_owner,
   type_toid, type_owner, type_hashcode, type_mod, top
  FROM repcat_repflavor_columns;

CREATE OR REPLACE FORCE VIEW "DBA_REPFLAVOR_OBJECTS"("FNAME",
SELECT fl.fname, fo.gname, fo.sname, fo.oname,
       DECODE (fo.type,
        -1, 'SNAPSHOT',
         1, 'INDEX',
         2, 'TABLE',
         4, 'VIEW',
         5, 'SYNONYM',
         6, 'SEQUENCE',
         7, 'PROCEDURE',
         8, 'FUNCTION',
         9, 'PACKAGE',
        11, 'PACKAGE BODY',
        12, 'TRIGGER',
        13, 'TYPE',
        14, 'TYPE BODY',
        32, 'INDEXTYPE',
        33, 'OPERATOR',
            'UNDEFINED'),
        fo.gowner
from system.repcat$_flavors fl, system.repcat$_flavor_objects fo
where fo.gname     = fl.gname
  and fo.flavor_id = fl.flavor_id
  and fo.gowner    = fl.gowner;

CREATE OR REPLACE FORCE VIEW "DBA_REPGENERATED"("SNAME",
select r.sname, r.oname, r.type, r.base_sname, r.base_oname, r.base_type,
  r.package_prefix, r.procedure_prefix, r.distributed, r.reason
from repcat_generated r
where ((r.reason  = 'PROCEDURAL REPLICATION WRAPPER' and r.type != 'SYNONYM')
     or r.reason != 'PROCEDURAL REPLICATION WRAPPER');

CREATE OR REPLACE FORCE VIEW "DBA_REPGENOBJECTS"("SNAME",
select r.sname, r.oname, r.type, r.base_sname, r.base_oname, r.base_type,
  r.package_prefix, r.procedure_prefix, r.distributed, r.reason
from repcat_generated r;

CREATE OR REPLACE FORCE VIEW "DBA_REPGROUP"("SNAME",
select r.sname, r.master, r.status, r.schema_comment, r.sname, r.fname,
       r.rpc_processing_disabled, r.gowner
from repcat_repcat r;

CREATE OR REPLACE FORCE VIEW "DBA_REPGROUPED_COLUMN"("SNAME",
select distinct
    gc.sname,
    gc.oname,
    gc.group_name,
    gc.column_name
from  system.repcat$_grouped_column gc;

CREATE OR REPLACE FORCE VIEW "DBA_REPGROUP_PRIVILEGES"("USERNAME",
select u.username, rp.gname, rp.created,
       decode(bitand(rp.privilege, 1), 1, 'Y', 'N'),
       decode(bitand(rp.privilege, 2), 2, 'Y', 'N'),
       rp.gowner
from system.repcat$_repgroup_privs rp, dba_users u
where rp.username = u.username;

CREATE OR REPLACE FORCE VIEW "DBA_REPKEY_COLUMNS"("SNAME",
select rk.sname, rk.oname, rc.lcname
from system.repcat$_key_columns rk, system.repcat$_repcolumn rc
where rk.sname   = rc.sname
  and rk.oname   = rc.oname
  and rk.col     = rc.cname  -- SYS column name;

CREATE OR REPLACE FORCE VIEW "DBA_REPOBJECT"("SNAME",
select r.sname, r.oname, r.type, r.status, r.generation_status, r.id,
       r.object_comment, r.gname, r.min_communication,
       r.trigflag replication_trigger_exists, r.internal_package_exists,
       r.gowner, r.nested_table
from repcat_repobject r
where r.type != 'INTERNAL PACKAGE';

CREATE OR REPLACE FORCE VIEW "DBA_REPPARAMETER_COLUMN"("SNAME",
select
    p.sname,
    p.oname,
    decode(p.conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    p.reference_name,
    p.sequence_no,
    r.method_name,
    r.function_name,
    r.priority_group,
    p.parameter_table_name,
    decode(method_name, 'USER FUNCTION', NVL(rc.top, rc.lcname),
                        'USER FLAVOR FUNCTION', NVL(rc.top, rc.lcname),
           rc.lcname),
    p.parameter_sequence_no
from  system.repcat$_parameter_column p,
      system.repcat$_resolution r,
      system.repcat$_repcolumn rc
where p.sname = r.sname
and   p.oname = r.oname
and   p.conflict_type_id = r.conflict_type_id
and   p.reference_name = r.reference_name
and   p.sequence_no = r.sequence_no
and   p.oname = p.parameter_table_name
and   p.attribute_sequence_no = 1
and   p.sname = rc.sname
and   p.oname = rc.oname
and   p.column_pos = rc.pos;

CREATE OR REPLACE FORCE VIEW "DBA_REPPRIORITY"("SNAME",
select
    p.sname,
    p.priority_group,
    v.priority,
    decode(p.data_type_id,
           1, 'NUMBER',
           2, 'VARCHAR2',
           3, 'DATE',
           4, 'CHAR',
           5, 'RAW',
           6, 'NVARCHAR2',
           7, 'NCHAR',
           'UNDEFINED'),
    p.fixed_data_length,
    v.char_value,
    v.varchar2_value,
    v.number_value,
    v.date_value,
    v.raw_value,
    p.sname,
    v.nchar_value,
    v.nvarchar2_value,
    v.large_char_value
from  system.repcat$_priority v,
      system.repcat$_priority_group p
where v.sname = p.sname
and   v.priority_group = p.priority_group;

CREATE OR REPLACE FORCE VIEW "DBA_REPPRIORITY_GROUP"("SNAME",
select
    sname,
    priority_group,
    decode(data_type_id,
           1, 'NUMBER',
           2, 'VARCHAR2',
           3, 'DATE',
           4, 'CHAR',
           5, 'RAW',
           6, 'NVARCHAR2',
           7, 'NCHAR',
           'UNDEFINED'),
    fixed_data_length,
    priority_comment,
    sname
from  system.repcat$_priority_group;

CREATE OR REPLACE FORCE VIEW "DBA_REPPROP"("SNAME",
select r.sname, r.oname, r.type, r.dblink, r.how, r.propagate_comment
from repcat_repprop r, repcat_repobject ro
where r.sname = ro.sname
  and r.oname = ro.oname
  and r.type = ro.type
  and ro.type in ('PROCEDURE', 'PACKAGE', 'PACKAGE BODY', 'TABLE', 'SNAPSHOT');

CREATE OR REPLACE FORCE VIEW "DBA_REPRESOLUTION"("SNAME",
select
    sname,
    oname,
    decode(conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    reference_name,
    sequence_no,
    method_name,
    function_name,
    priority_group,
    resolution_comment
from  system.repcat$_resolution;

CREATE OR REPLACE FORCE VIEW "DBA_REPRESOLUTION_METHOD"("CONFLICT_TYPE",
select
    decode(conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    method_name
from  system.repcat$_resolution_method;

CREATE OR REPLACE FORCE VIEW "DBA_REPRESOLUTION_STATISTICS"("SNAME",
select
    sname,
    oname,
    decode(conflict_type_id,
           1, 'UPDATE',
           2, 'UNIQUENESS',
           3, 'DELETE',
           'UNDEFINED'),
    reference_name,
    method_name,
    decode(method_name,
           'USER FUNCTION', function_name,
           'USER FLAVOR FUNCTION', function_name,
           NULL),
    priority_group,
    resolved_date,
    primary_key_value
from  system.repcat$_resolution_statistics;

CREATE OR REPLACE FORCE VIEW "DBA_REPRESOL_STATS_CONTROL"("SNAME",
select
    sname,
    oname,
    created,
    decode(status,
           1, 'ACTIVE',
           2, 'CANCELLED',
           'UNDEFINED'),
    status_update_date,
    purged_date,
    last_purge_start_date,
    last_purge_end_date
from  system.repcat$_resol_stats_control;

CREATE OR REPLACE FORCE VIEW "DBA_REPSCHEMA"("SNAME",
select r.sname, r.dblink, r.masterdef, r.snapmaster, r.master_comment,
  r.master, r.prop_updates, r.my_dblink, r.sname, r.gowner
from system.repcat$_repschema r;

CREATE OR REPLACE FORCE VIEW "DBA_REPSITES"("GNAME",
select r.sname, r.dblink, r.masterdef, r.snapmaster, r.master_comment,
  r.master, r.prop_updates, r.my_dblink, r.gowner
from system.repcat$_repschema r;

CREATE OR REPLACE FORCE VIEW "DBA_REPSITES_NEW"("EXTENSION_ID",
select
  r.extension_id,
  r.gowner,
  r.gname,
  r.dblink,
  r.full_instantiation,
  DECODE(r.master_status,
         0, 'READY',
         1, 'INSTANTIATING',
         2, 'INSTANTIATED',
         3, 'PREPARED') master_status
from system.repcat$_sites_new r;

CREATE OR REPLACE FORCE VIEW "DBA_RESUMABLE"("USER_ID",
select distinct S.USER# as USER_ID, R.SID as SESSION_ID,
       R.INST_ID as INSTANCE_ID, P.QCINST_ID, P.QCSID,
       R.STATUS, R.TIMEOUT, NVL(T.START_TIME, R.SUSPEND_TIME) as START_TIME,
       R.SUSPEND_TIME, R.RESUME_TIME, R.NAME, Q.SQL_TEXT, R.ERROR_NUMBER,
       R.ERROR_PARAMETER1, R.ERROR_PARAMETER2, R.ERROR_PARAMETER3,
       R.ERROR_PARAMETER4, R.ERROR_PARAMETER5, R.ERROR_MSG
from GV$RESUMABLE R, GV$SESSION S, GV$TRANSACTION T, GV$SQL Q, GV$PX_SESSION P
where S.SID=R.SID and S.INST_ID=R.INST_ID
      and S.SADDR=T.SES_ADDR(+) and S.INST_ID=T.INST_ID(+)
      and S.SQL_ADDRESS=Q.ADDRESS(+) and S.INST_ID=Q.INST_ID(+)
      and S.SADDR=P.SADDR(+) and S.INST_ID=P.INST_ID(+)
      and R.ENABLED='YES' and NVL(T.SPACE,'NO')='NO';

CREATE OR REPLACE FORCE VIEW "DBA_REWRITE_EQUIVALENCES"("OWNER",
select u.name, o.name, s.src_stmt, s.dest_stmt,
       decode(s.rw_mode, 0, 'DISABLED',
                         1, 'TEXT_MATCH',
                         2, 'GENERAL',
                         3, 'RECURSIVE',
                         4, 'TUNE_MVIEW',
                         'UNDEFINED')
from sum$ s, obj$ o, user$ u
  where o.obj# = s.obj# and
  bitand(s.xpflags, 8388608) > 0 and  /* REWRITE EQUIVALENCE SUMMARY */
  o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "DBA_RGROUP"("REFGROUP",
select REFGROUP, OWNER, NAME,
          decode(bitand(flag,1),1,'Y',0,'N','?') IMPLICIT_DESTROY,
          decode(bitand(flag,2),2,'Y',0,'N','?') PUSH_DEFERRED_RPC,
          decode(bitand(flag,4),4,'Y',0,'N','?') REFRESH_AFTER_ERRORS,
          ROLLBACK_SEG,
          JOB,
          purge_opt#   PURGE_OPTION,
          parallelism# PARALLELISM,
          heap_size#   HEAP_SIZE
  from rgroup$ r
   where r.instsite = 0;

CREATE OR REPLACE FORCE VIEW "DBA_ROLES"("ROLE",
select name, decode(password, null, 'NO', 'EXTERNAL', 'EXTERNAL',
                      'GLOBAL', 'GLOBAL', 'YES')
from  user$
where type# = 0 and name not in ('PUBLIC', '_NEXT_USER');

CREATE OR REPLACE FORCE VIEW "DBA_ROLE_PRIVS"("GRANTEE",
select /*+ ordered */ decode(sa.grantee#, 1, 'PUBLIC', u1.name), u2.name,
       decode(min(option$), 1, 'YES', 'NO'),
       decode(min(u1.defrole), 0, 'NO', 1, 'YES',
              2, decode(min(ud.role#),null,'NO','YES'),
              3, decode(min(ud.role#),null,'YES','NO'), 'NO')
from sysauth$ sa, user$ u1, user$ u2, defrole$ ud
where sa.grantee#=ud.user#(+)
  and sa.privilege#=ud.role#(+) and u1.user#=sa.grantee#
  and u2.user#=sa.privilege#
group by decode(sa.grantee#,1,'PUBLIC',u1.name),u2.name;

CREATE OR REPLACE FORCE VIEW "DBA_ROLLBACK_SEGS"("SEGMENT_NAME",
select un.name, decode(un.user#,1,'PUBLIC','SYS'),
       ts.name, un.us#, f.file#, un.block#,
       s.iniexts * ts.blocksize,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                      s.extsize * ts.blocksize),
       s.minexts, s.maxexts,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                      s.extpct),
       decode(un.status$, 2, 'OFFLINE', 3, 'ONLINE',
                          4, 'UNDEFINED', 5, 'NEEDS RECOVERY',
                          6, 'PARTLY AVAILABLE', 'UNDEFINED'),
       decode(un.inst#, 0, NULL, un.inst#), un.file#
from sys.undo$ un, sys.seg$ s, sys.ts$ ts, sys.file$ f
where un.status$ != 1
  and un.ts# = s.ts#
  and un.file# = s.file#
  and un.block# = s.block#
  and s.type# in (1, 10)
  and s.ts# = ts.ts#
  and un.ts# = f.ts#
  and un.file# = f.relfile#;

CREATE OR REPLACE FORCE VIEW "DBA_RSRC_CONSUMER_GROUPS"("CONSUMER_GROUP",
select name,cpu_method,description,status,decode(mandatory,1,'YES','NO')
from resource_consumer_group$;

CREATE OR REPLACE FORCE VIEW "DBA_RSRC_CONSUMER_GROUP_PRIVS"("GRANTEE",
select ue.name, g.name,
       decode(min(mod(o.option$,2)), 1, 'YES', 'NO'),
       decode(nvl(cgm.consumer_group, 'DEFAULT_CONSUMER_GROUP'),
              g.name, 'YES', 'NO')
from sys.user$ ue left outer join sys.resource_group_mapping$ cgm on
     (cgm.attribute = 'ORACLE_USER' and cgm.status = 'ACTIVE' and
      cgm.value = ue.name),
     sys.resource_consumer_group$ g, sys.objauth$ o
where o.obj# = g.obj# and o.grantee# = ue.user#
group by ue.name, g.name,
      decode(nvl(cgm.consumer_group, 'DEFAULT_CONSUMER_GROUP'),
             g.name, 'YES', 'NO');

CREATE OR REPLACE FORCE VIEW "DBA_RSRC_GROUP_MAPPINGS"("ATTRIBUTE",
select m.attribute, m.value, m.consumer_group, m.status
from sys.resource_group_mapping$ m
order by m.status,
         (select p.priority from sys.resource_mapping_priority$ p
          where m.status = p.status and m.attribute = p.attribute),
         m.consumer_group, m.value;

CREATE OR REPLACE FORCE VIEW "DBA_RSRC_MANAGER_SYSTEM_PRIVS"("GRANTEE",
select u.name,spm.name,decode(min(sa.option$),1,'YES','NO')
from sys.user$ u, system_privilege_map spm, sys.sysauth$ sa
where sa.grantee# = u.user# and sa.privilege# = spm.privilege
and sa.privilege# = -227 group by u.name, spm.name;

CREATE OR REPLACE FORCE VIEW "DBA_RSRC_MAPPING_PRIORITY"("ATTRIBUTE",
select attribute, priority, status
from sys.resource_mapping_priority$
where attribute <> 'CLIENT_ID'
order by status, priority;

CREATE OR REPLACE FORCE VIEW "DBA_RSRC_PLANS"("PLAN",
select name,num_plan_directives,cpu_method,mast_method,pdl_method,que_method,
description,status,decode(mandatory,1,'YES','NO') from resource_plan$;

CREATE OR REPLACE FORCE VIEW "DBA_RSRC_PLAN_DIRECTIVES"("PLAN",
select plan, group_or_subplan, decode(is_subplan, 1, 'PLAN', 'CONSUMER_GROUP'),
decode(cpu_p1, 4294967295, 0, cpu_p1),
decode(cpu_p2, 4294967295, 0, cpu_p2),
decode(cpu_p3, 4294967295, 0, cpu_p3),
decode(cpu_p4, 4294967295, 0, cpu_p4),
decode(cpu_p5, 4294967295, 0, cpu_p5),
decode(cpu_p6, 4294967295, 0, cpu_p6),
decode(cpu_p7, 4294967295, 0, cpu_p7),
decode(cpu_p8, 4294967295, 0, cpu_p8),
decode(active_sess_pool_p1, 4294967295, to_number(null), active_sess_pool_p1),
decode(queueing_p1, 4294967295, to_number(null), queueing_p1),
decode(parallel_degree_limit_p1,
       4294967295, to_number(null),
       parallel_degree_limit_p1),
switch_group,
case when (switch_time = 4294967295) then to_number(null)
     when (switch_back <> 0) then to_number(null)
     else switch_time end,
decode(switch_estimate, 4294967295, 'FALSE', 0, 'FALSE', 1, 'TRUE'),
decode(max_est_exec_time, 4294967295, to_number(null), max_est_exec_time),
decode(undo_pool, 4294967295, to_number(null), undo_pool),
decode(max_idle_time, 4294967295, to_number(null), max_idle_time),
decode(max_idle_blocker_time, 4294967295, to_number(null),
       max_idle_blocker_time),
case when (switch_time = 4294967295) then to_number(null)
     when (switch_back = 0) then to_number(null)
     else switch_time end,
description, status, decode(mandatory, 1, 'YES', 'NO')
from resource_plan_directive$;

CREATE OR REPLACE FORCE VIEW "DBA_RULES"("RULE_OWNER",
SELECT /*+ all_rows */
       u.name, o.name, r.condition, bu.name, bo.name, r.r_action, r.r_comment
FROM   rule$ r, obj$ o, user$ u, obj$ bo, user$ bu
WHERE  r.obj# = o.obj# and o.owner# = u.user# and
       r.ectx# = bo.obj#(+) and bo.owner# = bu.user#(+);

CREATE OR REPLACE FORCE VIEW "DBA_RULESETS"("OWNER",
SELECT rule_set_owner, rule_set_name, NULL,
       decode(rule_set_eval_context_owner, NULL, NULL,
              rule_set_eval_context_owner||'.'||rule_set_eval_context_name),
       rule_set_comment
FROM   dba_rule_sets;

CREATE OR REPLACE FORCE VIEW "DBA_RULE_SETS"("RULE_SET_OWNER",
SELECT /*+ all_rows */
       u.name, o.name, bu.name, bo.name, r.rs_comment
FROM   rule_set$ r, obj$ o, user$ u, obj$ bo, user$ bu
WHERE  r.obj# = o.obj# and u.user# = o.owner#
       and r.ectx# = bo.obj#(+) and bo.owner# = bu.user#(+);

CREATE OR REPLACE FORCE VIEW "DBA_RULE_SET_RULES"("RULE_SET_OWNER",
SELECT /*+ all_rows */
       u.name, o.name, ru.name, ro.name,
       decode(bitand(rm.property, 1), 1, 'DISABLED', 'ENABLED'),
       eu.name, eo.name, rm.rm_comment
FROM   rule_map$ rm, obj$ o, user$ u, obj$ ro, user$ ru, obj$ eo, user$ eu
WHERE  rm.rs_obj# = o.obj# and o.owner# = u.user# and rm.r_obj# = ro.obj# and
       ro.owner# = ru.user# and rm.ectx# = eo.obj#(+) and
       eo.owner# = eu.user#(+);

CREATE OR REPLACE FORCE VIEW "DBA_SCHEDULER_GLOBAL_ATTRIBUTE"("ATTRIBUTE_NAME",
SELECT o.name, a.value
 FROM sys.obj$ o, sys.scheduler$_global_attribute a
 WHERE o.obj# = a.obj#;

CREATE OR REPLACE FORCE VIEW "DBA_SCHEDULER_JOBS"("OWNER",
SELECT ju.name, jo.name, j.creator, j.client_id, j.guid,
    DECODE(bitand(j.flags,4194304),4194304,
      substr(j.program_action,1,instr(j.program_action,'"')-1),NULL),
    DECODE(bitand(j.flags,4194304),4194304,
      substr(j.program_action,instr(j.program_action,'"')+1,
        length(j.program_action)-instr(j.program_action,'"')) ,NULL),
    DECODE(BITAND(j.flags,131072+262144+2097152),
      131072, 'PLSQL_BLOCK', 262144, 'STORED_PROCEDURE',
      2097152, 'EXECUTABLE', 524288, 'JOB_CHAIN', NULL),
    DECODE(bitand(j.flags,4194304),0,j.program_action,NULL), j.number_of_args,
    DECODE(bitand(j.flags,1024+4096),0,NULL,
      substr(j.schedule_expr,1,instr(j.schedule_expr,'"')-1)),
    DECODE(bitand(j.flags,1024+4096),0,NULL,
      substr(j.schedule_expr,instr(j.schedule_expr,'"') + 1,
        length(j.schedule_expr)-instr(j.schedule_expr,'"'))),
    j.start_date,
    DECODE(BITAND(j.flags,1024+4096), 0, j.schedule_expr, NULL),
    j.end_date, co.name,
    DECODE(BITAND(j.job_status,1+8388608),0,'FALSE','TRUE'),
    DECODE(BITAND(j.flags,32768),0,'TRUE','FALSE'),
    DECODE(BITAND(j.flags,65536),0,'FALSE','TRUE'),
    DECODE(BITAND(j.job_status,1+2+4+8+16+32+128),0,'DISABLED',1,
      (CASE WHEN j.retry_count>0 THEN 'RETRY SCHEDULED' ELSE 'SCHEDULED' END),
      2,'RUNNING',3,'RUNNING',4,'COMPLETED',8,'BROKEN',16,'FAILED',32,'SUCCEEDED'
      ,128,'REMOTE',NULL),
    j.priority, j.run_count, j.max_runs, j.failure_count, j.max_failures,
    j.retry_count,
    j.last_start_date,
    (CASE WHEN j.last_end_date>j.last_start_date THEN j.last_end_date-j.last_start_date
       ELSE NULL END), j.next_run_date,
    j.schedule_limit, j.max_run_duration,
    DECODE(BITAND(j.flags,32+64+128+256),32,'OFF',64,'RUNS',128,'',
      256,'FULL',NULL),
    DECODE(BITAND(j.flags,8),0,'FALSE','TRUE'),
    DECODE(BITAND(j.flags,16),0,'FALSE','TRUE'),
    DECODE(BITAND(j.flags,16777216),0,'FALSE','TRUE'),
    j.job_weight, j.nls_env,
    j.source, j.destination, j.comments, j.flags
  FROM obj$ jo, user$ ju, obj$ co, sys.scheduler$_job j
  WHERE j.obj# = jo.obj# AND jo.owner# = ju.user# AND j.class_oid = co.obj#(+);

CREATE OR REPLACE FORCE VIEW "DBA_SCHEDULER_JOB_ARGS"("OWNER",
SELECT u.name, o.name, b.name, t.position,
  CASE WHEN (b.user_type_num IS NULL) THEN
    DECODE(b.type_number,
0, null,
1, decode(b.flags, 512, 'NVARCHAR2', 'VARCHAR2'),
2, decode(b.flags, 512, 'FLOAT', 'NUMBER'),
3, 'NATIVE INTEGER',
8, 'LONG',
9, decode(b.flags, 512, 'NCHAR VARYING', 'VARCHAR'),
11, 'ROWID',
12, 'DATE',
23, 'RAW',
24, 'LONG RAW',
29, 'BINARY_INTEGER',
69, 'ROWID',
96, decode(b.flags, 512, 'NCHAR', 'CHAR'),
100, 'BINARY_FLOAT',
101, 'BINARY_DOUBLE',
102, 'REF CURSOR',
104, 'UROWID',
105, 'MLSLABEL',
106, 'MLSLABEL',
110, 'REF',
111, 'REF',
112, decode(b.flags, 512, 'NCLOB', 'CLOB'),
113, 'BLOB', 114, 'BFILE', 115, 'CFILE',
121, 'OBJECT',
122, 'TABLE',
123, 'VARRAY',
178, 'TIME',
179, 'TIME WITH TIME ZONE',
180, 'TIMESTAMP',
181, 'TIMESTAMP WITH TIME ZONE',
231, 'TIMESTAMP WITH LOCAL TIME ZONE',
182, 'INTERVAL YEAR TO MONTH',
183, 'INTERVAL DAY TO SECOND',
250, 'PL/SQL RECORD',
251, 'PL/SQL TABLE',
252, 'PL/SQL BOOLEAN',
'UNDEFINED')
    ELSE t_u.name ||'.'|| t_o.name END,
  dbms_scheduler.get_varchar2_value(t.value), t.value,
  DECODE(BITAND(b.flags,1),0,'FALSE',1,'TRUE')
  FROM obj$ o, user$ u, (SELECT a.oid job_oid, a.position position,
      j.program_oid program_oid, a.value value
    FROM sys.scheduler$_job j, sys.scheduler$_job_argument a
    WHERE a.oid = j.obj#) t, obj$ t_o, user$ t_u,
    sys.scheduler$_program_argument b
  WHERE t.job_oid = o.obj# AND u.user# = o.owner#
    AND b.user_type_num = t_o.obj#(+) AND t_o.owner# = t_u.user#(+)
    AND t.program_oid=b.oid(+) AND t.position=b.position(+);

CREATE OR REPLACE FORCE VIEW "DBA_SCHEDULER_JOB_CLASSES"("JOB_CLASS_NAME",
SELECT co.name, c.res_grp_name,
    c.affinity ,
    DECODE(BITAND(c.flags,32+64+128+256),32,'OFF',64,'RUNS',128,'',
      256,'FULL',NULL),
    c.log_history, c.comments
  FROM obj$ co, sys.scheduler$_class c
  WHERE c.obj# = co.obj#;

CREATE OR REPLACE FORCE VIEW "DBA_SCHEDULER_JOB_LOG"("LOG_ID",
(SELECT
        LOG_ID, LOG_DATE, OWNER,e.NAME,co.NAME, OPERATION,e.STATUS, USER_NAME,
        CLIENT_ID, GUID, ADDITIONAL_INFO
  FROM scheduler$_event_log e, obj$ co
  WHERE e.type# = 66 and e.class_id = co.obj#(+));

CREATE OR REPLACE FORCE VIEW "DBA_SCHEDULER_JOB_RUN_DETAILS"("LOG_ID",
(SELECT
        j.LOG_ID, j.LOG_DATE, e.OWNER, e.NAME, e.STATUS, j.ERROR#,
        j.REQ_START_DATE, j.START_DATE, j.RUN_DURATION, j.INSTANCE_ID,
        j.SESSION_ID, j.SLAVE_PID, j.CPU_USED, j.ADDITIONAL_INFO
   FROM scheduler$_job_run_details j, scheduler$_event_log e
   WHERE j.log_id = e.log_id
   AND e.type# = 66);

CREATE OR REPLACE FORCE VIEW "DBA_SCHEDULER_PROGRAMS"("OWNER",
SELECT u.name, o.name,
  DECODE(bitand(p.flags,2+4+8+16+32), 2,'PLSQL_BLOCK',
         4,'STORED_PROCEDURE', 32, 'EXECUTABLE', ''),
  p.action, p.number_of_args, DECODE(BITAND(p.flags,1),0,'FALSE',1,'TRUE'),
  p.comments
  FROM obj$ o, user$ u, sys.scheduler$_program p
  WHERE p.obj# = o.obj# AND u.user# = o.owner#;

CREATE OR REPLACE FORCE VIEW "DBA_SCHEDULER_PROGRAM_ARGS"("OWNER",
SELECT u.name, o.name, a.name, a.position,
  CASE WHEN (a.user_type_num IS NULL) THEN
    DECODE(a.type_number,
0, null,
1, decode(a.flags, 512, 'NVARCHAR2', 'VARCHAR2'),
2, decode(a.flags, 512, 'FLOAT', 'NUMBER'),
3, 'NATIVE INTEGER',
8, 'LONG',
9, decode(a.flags, 512, 'NCHAR VARYING', 'VARCHAR'),
11, 'ROWID',
12, 'DATE',
23, 'RAW',
24, 'LONG RAW',
29, 'BINARY_INTEGER',
69, 'ROWID',
96, decode(a.flags, 512, 'NCHAR', 'CHAR'),
100, 'BINARY_FLOAT',
101, 'BINARY_DOUBLE',
102, 'REF CURSOR',
104, 'UROWID',
105, 'MLSLABEL',
106, 'MLSLABEL',
110, 'REF',
111, 'REF',
112, decode(a.flags, 512, 'NCLOB', 'CLOB'),
113, 'BLOB', 114, 'BFILE', 115, 'CFILE',
121, 'OBJECT',
122, 'TABLE',
123, 'VARRAY',
178, 'TIME',
179, 'TIME WITH TIME ZONE',
180, 'TIMESTAMP',
181, 'TIMESTAMP WITH TIME ZONE',
231, 'TIMESTAMP WITH LOCAL TIME ZONE',
182, 'INTERVAL YEAR TO MONTH',
183, 'INTERVAL DAY TO SECOND',
250, 'PL/SQL RECORD',
251, 'PL/SQL TABLE',
252, 'PL/SQL BOOLEAN',
'UNDEFINED')
    ELSE t_u.name ||'.'|| t_o.name END,
  DECODE(bitand(a.flags,2+4+64+128+256), 2,'JOB_NAME',4,'JOB_OWNER',
         64, 'JOB_START', 128, 'WINDOW_START',
         256, 'WINDOW_END', ''),
  dbms_scheduler.get_varchar2_value(a.value), a.value,
  DECODE(BITAND(a.flags,1),0,'FALSE',1,'TRUE')
  FROM obj$ o, user$ u, sys.scheduler$_program_argument a, obj$ t_o, user$ t_u
  WHERE a.oid = o.obj# AND u.user# = o.owner#
    AND a.user_type_num = t_o.obj#(+) AND t_o.owner# = t_u.user#(+);

CREATE OR REPLACE FORCE VIEW "DBA_SCHEDULER_RUNNING_JOBS"("OWNER",
SELECT ju.name, jo.name, rj.session_id, rj.process_id, rj.inst_id,
      vse.resource_consumer_group,
      CAST (systimestamp-j.last_start_date AS INTERVAL DAY(3) TO SECOND(2)),
      rj.session_stat_cpu
  FROM
        scheduler$_job j,
        obj$ jo,
        user$ ju,
        gv$scheduler_running_jobs rj,
        gv$session vse
  WHERE
      j.obj# = jo.obj#
  AND rj.job_id = j.obj#
  AND jo.owner# = ju.user#
  AND vse.sid = rj.session_id
  AND vse.serial# = rj.session_serial_num;

CREATE OR REPLACE FORCE VIEW "DBA_SCHEDULER_SCHEDULES"("OWNER",
SELECT su.name, so.name, s.reference_date, s.recurrence_expr,
    s.end_date, s.comments
  FROM obj$ so, user$ su, sys.scheduler$_schedule s
  WHERE s.obj# = so.obj# AND so.owner# = su.user#;

CREATE OR REPLACE FORCE VIEW "DBA_SCHEDULER_WINDOWS"("WINDOW_NAME",
SELECT wo.name, w.res_plan,
    DECODE(bitand(w.flags,16),16,
      substr(w.schedule_expr,1,instr(w.schedule_expr,'"')-1),NULL),
    DECODE(bitand(w.flags,16),16,
      substr(w.schedule_expr,instr(w.schedule_expr,'"')+1,
        length(w.schedule_expr)-instr(w.schedule_expr,'"')) ,NULL),
     w.start_date,
    DECODE(bitand(w.flags,16),0,w.schedule_expr,NULL), w.end_date, w.duration,
    DECODE(w.priority,1,'HIGH',2,'LOW',NULL), w.next_start_date,
    w.actual_start_date,
    DECODE(bitand(w.flags, 1),0,'FALSE',1,'TRUE'),
    DECODE(bitand(w.flags,1+2),2,'TRUE',3,'TRUE','FALSE'), w.comments
  FROM obj$ wo, sys.scheduler$_window w
  WHERE w.obj# = wo.obj#;

CREATE OR REPLACE FORCE VIEW "DBA_SCHEDULER_WINDOW_DETAILS"("LOG_ID",
(SELECT
        w.LOG_ID, w.LOG_DATE, e.NAME, w.REQ_START_DATE, w.START_DATE,
        w.DURATION, w.ACTUAL_DURATION, w.INSTANCE_ID, w.ADDITIONAL_INFO
  FROM scheduler$_window_details w, scheduler$_event_log e
  WHERE e.log_id = w.log_id
  AND e.type# = 69);

CREATE OR REPLACE FORCE VIEW "DBA_SCHEDULER_WINDOW_GROUPS"("WINDOW_GROUP_NAME",
SELECT o.name, DECODE(BITAND(w.flags,1),0,'FALSE',1,'TRUE'),
    (SELECT COUNT(*) FROM scheduler$_wingrp_member wg WHERE wg.oid = w.obj#),
    w.comments
  FROM obj$ o, scheduler$_window_group w WHERE o.obj# = w.obj#;

CREATE OR REPLACE FORCE VIEW "DBA_SCHEDULER_WINDOW_LOG"("LOG_ID",
(SELECT
        LOG_ID, LOG_DATE, NAME, OPERATION, STATUS, USER_NAME, CLIENT_ID,
        GUID, ADDITIONAL_INFO
  FROM scheduler$_event_log
  WHERE type# = 69);

CREATE OR REPLACE FORCE VIEW "DBA_SCHEDULER_WINGROUP_MEMBERS"("WINDOW_GROUP_NAME",
SELECT o.name, wmo.name
  FROM obj$ o, obj$ wmo, scheduler$_wingrp_member wg
  WHERE o.type# = 72 AND o.obj# = wg.oid AND wg.member_oid = wmo.obj#;

CREATE OR REPLACE FORCE VIEW "DBA_SECONDARY_OBJECTS"("INDEX_OWNER",
select u.name, o.name, u1.name, o1.name
from   sys.user$ u, sys.obj$ o, sys.user$ u1, sys.obj$ o1, sys.secobj$ s
where  s.obj# = o.obj# and o.owner# = u.user# and
       s.secobj# = o1.obj#  and  o1.owner# = u1.user#;

CREATE OR REPLACE FORCE VIEW "DBA_SEC_RELEVANT_COLS"("OBJECT_OWNER",
select u.name, o.name, r.gname, r.pname, c.name,
       decode(bitand(r.stmt_type, 4096), 0, 'NONE', 'ALL_ROWS')
from sys.rls$ r, sys.rls_sc$ sc, sys.user$ u, sys.obj$ o, sys.col$ c
where u.user# = o.owner#
  and r.obj# = o.obj#
  and r.obj# = sc.obj#
  and r.gname=sc.gname and r.pname=sc.pname
  and r.obj# = c.obj# and sc.intcol# = c.intcol#
  and bitand(c.property, 32) = 0;

CREATE OR REPLACE FORCE VIEW "DBA_SEGMENTS"("OWNER",
select owner, segment_name, partition_name, segment_type, tablespace_name,
       header_file, header_block,
       decode(bitand(segment_flags, 131072), 131072, blocks,
           (decode(bitand(segment_flags,1),1,
            dbms_space_admin.segment_number_blocks(tablespace_id, relative_fno,
            header_block, segment_type_id, buffer_pool_id, segment_flags,
            segment_objd, blocks), blocks)))*blocksize,
       decode(bitand(segment_flags, 131072), 131072, blocks,
           (decode(bitand(segment_flags,1),1,
            dbms_space_admin.segment_number_blocks(tablespace_id, relative_fno,
            header_block, segment_type_id, buffer_pool_id, segment_flags,
            segment_objd, blocks), blocks))),
       decode(bitand(segment_flags, 131072), 131072, extents,
           (decode(bitand(segment_flags,1),1,
           dbms_space_admin.segment_number_extents(tablespace_id, relative_fno,
           header_block, segment_type_id, buffer_pool_id, segment_flags,
           segment_objd, extents) , extents))),
       initial_extent, next_extent, min_extents, max_extents, pct_increase,
       freelists, freelist_groups, relative_fno,
       decode(buffer_pool_id, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL)
from sys_dba_segs;

CREATE OR REPLACE FORCE VIEW "DBA_SEGMENTS_OLD"("OWNER",
select owner, segment_name, partition_name, segment_type, tablespace_name,
       header_file, header_block,
       dbms_space_admin.segment_number_blocks(tablespace_id, relative_fno,
       header_block, segment_type_id, buffer_pool_id, segment_flags,
       segment_objd, blocks)*blocksize,
       dbms_space_admin.segment_number_blocks(tablespace_id, relative_fno,
       header_block, segment_type_id, buffer_pool_id, segment_flags,
       segment_objd, blocks),
       dbms_space_admin.segment_number_extents(tablespace_id, relative_fno,
       header_block, segment_type_id, buffer_pool_id, segment_flags,
       segment_objd, extents),
       initial_extent, next_extent, min_extents, max_extents, pct_increase,
       freelists, freelist_groups, relative_fno,
       decode(buffer_pool_id, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL)
from sys_dba_segs;

CREATE OR REPLACE FORCE VIEW "DBA_SEQUENCES"("SEQUENCE_OWNER",
select u.name, o.name,
      s.minvalue, s.maxvalue, s.increment$,
      decode (s.cycle#, 0, 'N', 1, 'Y'),
      decode (s.order$, 0, 'N', 1, 'Y'),
      s.cache, s.highwater
from sys.seq$ s, sys.obj$ o, sys.user$ u
where u.user# = o.owner#
  and o.obj# = s.obj#;

CREATE OR REPLACE FORCE VIEW "DBA_SERVER_REGISTRY"("COMP_ID",
SELECT comp_id, comp_name, version, status,
       modified, control, schema, procedure,
       startup, parent_id
FROM dba_registry
WHERE namespace='SERVER';

CREATE OR REPLACE FORCE VIEW "DBA_SERVICES"("SERVICE_ID",
select SERVICE_ID, NAME, NAME_HASH, NETWORK_NAME,
          CREATION_DATE, CREATION_DATE_HASH,
          FAILOVER_METHOD, FAILOVER_TYPE, FAILOVER_RETRIES, FAILOVER_DELAY
   from service$
where DELETION_DATE is null;

CREATE OR REPLACE FORCE VIEW "DBA_SNAPSHOTS"("OWNER",
select s.sowner, s.vname, tname, mview, t.mowner, t.master, mlink,
       decode(bitand(s.flag,1),  0, 'NO', 'YES'),
       decode(bitand(s.flag,2),  0, 'NO', 'YES'),
       decode(bitand(s.flag,16),             16, 'ROWID',
	      (decode(bitand(s.flag,32),     32, 'PRIMARY KEY',
	      (decode(bitand(s.flag,8192), 8192, 'JOIN VIEW',
	      (decode(bitand(s.flag,4096), 4096, 'AGGREGATE',
              (decode(bitand(s.flag,256),   256, 'COMPLEX',
              (decode(bitand(s.flag,536870912),   536870912, 'OBJECT ID',
                                                 'UNKNOWN'))))))))))),
       t.snaptime, s.error#,
       decode(bitand(s.status,1), 0, 'REGENERATE', 'VALID'),
       decode(bitand(s.status,2), 0, 'REGENERATE', 'VALID'),
       decode(s.auto_fast,
              'C',  'COMPLETE',
              'F',  'FAST',
              '?',  'FORCE',
              'N',  'NEVER',
              NULL, 'FORCE', 'ERROR'),
       s.auto_fun, s.auto_date, r.refgroup, s.ustrg, s.uslog,
       s.query_txt, s.mas_roll_seg,
       decode(bitand(s.status,4),         4, 'INVALID',
	      (decode(bitand(s.status,8), 8, 'UNKNOWN',
                                             'VALID'))),
       decode(NVL(s.auto_fun, 'null'),
              'null', decode(s.auto_fast,                  'N', 'NEVER',
                             (decode(bitand(s.flag, 32768),  0, 'DEMAND',
                                                                'COMMIT'))),
	      'PERIODIC'),
       decode(bitand(s.flag,131072), 0, 'NO', 'YES')
from sys.snap$ s, sys.rgchild$ r, sys.snap_reftime$ t
where t.sowner = s.sowner
and t.vname = s.vname
and t.instsite = 0
and s.instsite = 0
and not (bitand(s.flag, 268435456) > 0         /* MV with user-defined types */
         and bitand(s.objflag, 32) > 0)                      /* secondary MV */
and t.tablenum = 0
and t.sowner  = r.owner (+)
and t.vname = r.name (+)
and nvl(r.instsite,0) = 0
and r.type# (+) = 'SNAPSHOT';

CREATE OR REPLACE FORCE VIEW "DBA_SNAPSHOT_LOGS"("LOG_OWNER",
select m.mowner, m.master, m.log, m.trig,
       decode(bitand(m.flag,1), 0, 'NO', 'YES'),
       decode(bitand(m.flag,2), 0, 'NO', 'YES'),
       decode(bitand(m.flag,512), 0, 'NO', 'YES'),
       decode(bitand(m.flag,4), 0, 'NO', 'YES'),
       decode(bitand(m.flag,1024), 0, 'NO', 'YES'),
       decode(bitand(m.flag,16), 0, 'NO', 'YES'),
       s.snaptime, s.snapid
from sys.mlog$ m, sys.slog$ s
where s.mowner (+) = m.mowner
  and s.master (+) = m.master
union
select ct.source_schema_name, ct.source_table_name, ct.change_table_name,
       ct.mvl_v7trigger,
       decode(bitand(ct.mvl_flag,1), 0, 'NO', 'YES'),
       decode(bitand(ct.mvl_flag,2), 0, 'NO', 'YES'),
       decode(bitand(ct.mvl_flag,512), 0, 'NO', 'YES'),
       decode(bitand(ct.mvl_flag,4), 0, 'NO', 'YES'),
       decode(bitand(ct.mvl_flag,1024), 0, 'NO', 'YES'),
       decode(bitand(ct.mvl_flag,16), 0, 'NO', 'YES'),
       s.snaptime, s.snapid
from sys.cdc_change_tables$ ct, sys.slog$ s
where s.mowner (+) = ct.source_schema_name
  and s.master (+) = ct.source_table_name
  and bitand(ct.mvl_flag, 128) = 128;

CREATE OR REPLACE FORCE VIEW "DBA_SOURCE"("OWNER",
select u.name, o.name,
decode(o.type#, 7, 'PROCEDURE', 8, 'FUNCTION', 9, 'PACKAGE',
               11, 'PACKAGE BODY', 12, 'TRIGGER', 13, 'TYPE', 14, 'TYPE BODY',
               'UNDEFINED'),
s.line, s.source
from sys.obj$ o, sys.source$ s, sys.user$ u
where o.obj# = s.obj#
  and o.owner# = u.user#
  and ( o.type# in (7, 8, 9, 11, 12, 14) OR
       ( o.type# = 13 AND o.subname is null))
union all
select u.name, o.name, 'JAVA SOURCE', s.joxftlno, s.joxftsrc
from sys.obj$ o, x$joxfs s, sys.user$ u
where o.obj# = s.joxftobn
  and o.owner# = u.user#
  and o.type# = 28;

CREATE OR REPLACE FORCE VIEW "DBA_SOURCE_TABLES"("SOURCE_SCHEMA_NAME",
SELECT DISTINCT
   s.source_schema_name, s.source_table_name
  FROM sys.cdc_change_tables$ s, all_tables t
  WHERE s.change_table_schema=t.owner AND
        s.change_table_name=t.table_name;

CREATE OR REPLACE FORCE VIEW "DBA_SQLJ_TYPES"("OWNER",
select decode(bitand(t.properties, 64), 64, null, u.name), o.name, t.toid,
       t.externname,
       decode(t.externtype, 1, 'SQLData',
                            2, 'CustomDatum',
                            3, 'Serializable',
                            4, 'Serializable Internal',
                            5, 'ORAData',
                            'unknown'),
       decode(t.typecode, 108, 'OBJECT',
                          122, 'COLLECTION',
                          o.name),
       t.attributes, t.methods,
       decode(bitand(t.properties, 16), 16, 'YES', 0, 'NO'),
       decode(bitand(t.properties, 256), 256, 'YES', 0, 'NO'),
       decode(bitand(t.properties, 8), 8, 'NO', 'YES'),
       decode(bitand(t.properties, 65536), 65536, 'NO', 'YES'),
       su.name, so.name, t.local_attrs, t.local_methods
from sys.user$ u, sys.type$ t, sys.obj$ o, sys.obj$ so, sys.user$ su
where o.owner# = u.user#
  and o.oid$ = t.tvoid
  and o.subname IS NULL -- only the latest version
  and o.type# <> 10 -- must not be invalid
  and bitand(t.properties, 2048) = 0 -- not system-generated
  and t.supertoid = so.oid$ (+) and so.owner# = su.user# (+)
  and t.externtype < 5;

CREATE OR REPLACE FORCE VIEW "DBA_SQLJ_TYPE_ATTRS"("OWNER",
select decode(bitand(t.properties, 64), 64, null, u.name),
       o.name, a.name, a.externname,
       decode(bitand(a.properties, 32768), 32768, 'REF',
              decode(bitand(a.properties, 16384), 16384, 'POINTER')),
       decode(bitand(at.properties, 64), 64, null, au.name),
       decode(at.typecode,
              52, decode(a.charsetform, 2, 'NVARCHAR2', ao.name),
              53, decode(a.charsetform, 2, 'NCHAR', ao.name),
              54, decode(a.charsetform, 2, 'NCHAR VARYING', ao.name),
              61, decode(a.charsetform, 2, 'NCLOB', ao.name),
              ao.name),
       a.length, a.precision#, a.scale,
       decode(a.charsetform, 1, 'CHAR_CS',
                             2, 'NCHAR_CS',
                             3, NLS_CHARSET_NAME(a.charsetid),
                             4, 'ARG:'||a.charsetid),
       a.attribute#, decode(bitand(nvl(a.xflags,0), 1), 1, 'YES', 'NO')
from sys.user$ u, sys.obj$ o, sys.type$ t, sys.attribute$ a,
     sys.obj$ ao, sys.user$ au, sys.type$ at
where o.owner# = u.user#
  and o.oid$ = t.toid
  and o.subname IS NULL -- get the latest version only
  and o.type# <> 10 -- must not be invalid
  and bitand(t.properties, 2048) = 0 -- not system-generated
  and t.toid = a.toid
  and t.version# = a.version#
  and a.attr_toid = ao.oid$
  and ao.owner# = au.user#
  and a.attr_toid = at.tvoid
  and a.attr_version# = at.version#
  and t.externtype < 5;

CREATE OR REPLACE FORCE VIEW "DBA_SQLJ_TYPE_METHODS"("OWNER",
select u.name, o.name, m.name, m.externVarName, m.method#,
       decode(bitand(m.properties, 512), 512, 'MAP',
              decode(bitand(m.properties, 2048), 2048, 'ORDER', 'PUBLIC')),
       m.parameters#, m.results,
       decode(bitand(m.properties, 8), 8, 'NO', 'YES'),
       decode(bitand(m.properties, 65536), 65536, 'NO', 'YES'),
       decode(bitand(m.properties, 131072), 131072, 'YES', 'NO'),
       decode(bitand(nvl(m.xflags,0), 1), 1, 'YES', 'NO')
from sys.user$ u, sys.obj$ o, sys.type$ t, sys.method$ m
where o.owner# = u.user#
  and o.oid$ = m.toid
  and o.subname IS NULL -- get the latest version only
  and o.type# <> 10 -- must not be invalid
  and bitand(t.properties, 2048) = 0 -- not system-generated
  and t.toid = m.toid
  and t.version# = m.version#
  and t.externtype < 5;

CREATE OR REPLACE FORCE VIEW "DBA_SQLSET"("ID",
select ID, NAME, OWNER, DESCRIPTION, CREATED, LAST_MODIFIED, STATEMENT_COUNT
  from WRI$_SQLSET_DEFINITIONS;

CREATE OR REPLACE FORCE VIEW "DBA_SQLSET_BINDS"("SQLSET_ID",
select SQLSET_ID, SQL_ID, POSITION, VALUE
  from   WRI$_SQLSET_BINDS;

CREATE OR REPLACE FORCE VIEW "DBA_SQLSET_REFERENCES"("ID",
select id, sqlset_id, owner, created, description
  from WRI$_SQLSET_REFERENCES;

CREATE OR REPLACE FORCE VIEW "DBA_SQLSET_STATEMENTS"("SQLSET_ID",
select SQLSET_ID, s.SQL_ID, SQL_TEXT,
         PARSING_SCHEMA_ID, MODULE, ACTION, ELAPSED_TIME, CPU_TIME,
         BUFFER_GETS, DISK_READS, ROWS_PROCESSED, FETCHES, EXECUTIONS,
         END_OF_FETCH_COUNT, OPTIMIZER_COST,
         OPTIMIZER_ENV, PRIORITY, s.COMMAND_TYPE,
         STAT_PERIOD, ACTIVE_STAT_PERIOD
 from WRI$_SQLSET_STATEMENTS s, WRH$_SQLTEXT t, V$DATABASE d
 where s.sql_id = t.sql_id and  t.dbid = d.dbid;

CREATE OR REPLACE FORCE VIEW "DBA_SQLTUNE_BINDS"("TASK_ID",
SELECT task_id, object_id, position, value
  FROM   wri$_adv_sqlt_binds;

CREATE OR REPLACE FORCE VIEW "DBA_SQLTUNE_PLANS"("TASK_ID",
SELECT task_id,
         object_id,
         decode(attribute,
                0, 'Original',
                1, 'Original with adjusted cost',
                2, 'Using SQL profile',
                3, 'Using new indices') AS attribute,
         statement_id,
         plan_hash_value,
         plan_id,
         timestamp,
         remarks,
         operation,
         options,
         object_node,
         object_owner,
         object_name,
         object_alias,
         object_instance,
         object_type,
         optimizer,
         search_columns,
         id,
         parent_id,
         depth,
         position,
         cost,
         cardinality,
         bytes,
         other_tag,
         partition_start,
         partition_stop,
         partition_id,
         other,
         distribution,
         cpu_cost,
         io_cost,
         temp_space,
         access_predicates,
         filter_predicates,
         projection,
         time,
         qblock_name
  FROM wri$_adv_sqlt_plans;

CREATE OR REPLACE FORCE VIEW "DBA_SQLTUNE_RATIONALE_PLAN"("TASK_ID",
SELECT task_id, rtn_id AS rationale_id, object_id,
         operation_id,
         decode(plan_attr,
                0, 'Original',
                1, 'Original with adjusted cost',
                2, 'Using SQL profile',
                3, 'Using new indices') AS plan_attribute
  FROM WRI$_adv_sqlt_rtn_plan;

CREATE OR REPLACE FORCE VIEW "DBA_SQLTUNE_STATISTICS"("TASK_ID",
SELECT TASK_ID, OBJECT_ID, PARSING_SCHEMA_ID, MODULE, ACTION, ELAPSED_TIME,
         CPU_TIME, BUFFER_GETS, DISK_READS, ROWS_PROCESSED, FETCHES, EXECUTIONS,
         END_OF_FETCH_COUNT, OPTIMIZER_COST, OPTIMIZER_ENV, COMMAND_TYPE
  FROM   wri$_adv_sqlt_statistics;

CREATE OR REPLACE FORCE VIEW "DBA_SQL_PROFILES"("NAME",
select sp.sp_name, sp.category, sp.signature, st.sql_text, sp.created,
       sp.last_modified, sd.description,
       DECODE(sp.type, 1, 'MANUAL', 2, 'AUTO-TUNE', 'UNKNOWN'),
       DECODE(sp.status, 1, 'ENABLED', 2, 'DISABLED', 3, 'VOID', 'UNKNOWN')
from   sqlprof$ sp,
       sqlprof$desc sd,
       sql$text st
where sp.signature = st.signature
and sp.signature = sd.signature
and sp.category = sd.category;

CREATE OR REPLACE FORCE VIEW "DBA_STMT_AUDIT_OPTS"("USER_NAME",
select decode(aud.user#, 0 /* client operations through proxy */, 'ANY CLIENT',
                         1 /* System wide auditing*/, null,
                         client.name)
                        /* USER_NAME */,
       proxy.name       /* PROXY_NAME */,
       aom.name         /* AUDIT_OPTION */,
       decode(aud.success, 1, 'BY SESSION', 2, 'BY ACCESS', 'NOT SET')
                        /* SUCCESS */,
       decode(aud.failure, 1, 'BY SESSION', 2, 'BY ACCESS', 'NOT SET')
                        /* FAILURE */
from sys.user$ client, sys.user$ proxy, STMT_AUDIT_OPTION_MAP aom,
     sys.audit$ aud
where aud.option# = aom.option#
  and aud.user# = client.user#
  and aud.proxy# = proxy.user#(+);

CREATE OR REPLACE FORCE VIEW "DBA_STORED_SETTINGS"("OWNER",
SELECT u.name, o.name, o.obj#,
DECODE(o.type#,
        7, 'PROCEDURE',
        8, 'FUNCTION',
        9, 'PACKAGE',
       11, 'PACKAGE BODY',
       12, 'TRIGGER',
       13, 'TYPE',
       14, 'TYPE BODY',
       'UNDEFINED'),
p.param, p.value
FROM sys.obj$ o, sys.user$ u, sys.settings$ p
WHERE o.owner# = u.user#
AND o.linkname is null
AND p.obj# = o.obj#;

CREATE OR REPLACE FORCE VIEW "DBA_STREAMS_ADMINISTRATOR"("USERNAME",
select u.name, decode(bitand(pu.privs, 1), 0, 'NO', 'YES'),
       decode(bitand(pu.privs, 2), 0, 'NO', 'YES')
  from user$ u, "_DBA_STREAMS_PRIVILEGED_USER" pu
 where u.user# = pu.user# AND pu.privs != 0;

CREATE OR REPLACE FORCE VIEW "DBA_STREAMS_GLOBAL_RULES"("STREAMS_NAME",
select streams_name, decode(streams_type, 1, 'CAPTURE',
                                          2, 'PROPAGATION',
                                          3, 'APPLY',
                                          4, 'DEQUEUE', 'UNDEFINED'),
       decode(rule_type, 1, 'DML',
                         2, 'DDL', 'UNKNOWN'),
       decode(include_tagged_lcr, 0, 'NO',
                                  1, 'YES'),
       source_database, rule_name, rule_owner, rule_condition
  from "_DBA_STREAMS_RULES"
 where object_type = 3;

CREATE OR REPLACE FORCE VIEW "DBA_STREAMS_MESSAGE_CONSUMERS"("STREAMS_NAME",
select streams_name, queue_name, queue_owner, rule_set_name, rule_set_owner,
       negative_rule_set_name, negative_rule_set_owner, notification_type,
       notification_action,
       decode(context_type,
              0, sys.anydata.ConvertRaw(user_context),
              1, any_context)
  from sys."_DBA_STREAMS_MSG_NOTIFICATIONS";

CREATE OR REPLACE FORCE VIEW "DBA_STREAMS_MESSAGE_RULES"("STREAMS_NAME",
select streams_name, decode(streams_type, 2, 'PROPAGATION',
                                          3, 'APPLY',
                                          4, 'DEQUEUE', 'UNDEFINED'),
       msg_type_name, msg_type_owner, msg_rule_var, rule_name,
       rule_owner, rule_condition
  from "_DBA_STREAMS_MESSAGE_RULES";

CREATE OR REPLACE FORCE VIEW "DBA_STREAMS_NEWLY_SUPPORTED"("OWNER",
select owner, table_name, reason, compatible
    from "_DBA_STREAMS_NEWLY_SUPTED_10_1";

CREATE OR REPLACE FORCE VIEW "DBA_STREAMS_RULES"("STREAMS_TYPE",
select decode(r.streams_type, 1, 'CAPTURE',
                              2, 'PROPAGATION',
                              3, 'APPLY',
                              4, 'DEQUEUE') streams_type,
       r.streams_name, r.rule_set_owner, r.rule_set_name,
       r.rule_owner, r.rule_name, r.rule_condition, r.rule_set_type,
       decode(sr.object_type, 1, 'TABLE',
                              2, 'SCHEMA',
                              3, 'GLOBAL') streams_rule_type,
       sr.schema_name, sr.object_name,
       decode(sr.subsetting_operation, 1, 'INSERT',
                                       2, 'UPDATE',
                                       3, 'DELETE') subsetting_operation,
       sr.dml_condition,
       decode(sr.include_tagged_lcr, 0, 'NO',
                                     1, 'YES') include_tagged_lcr,
       sr.source_database,
       decode(sr.rule_type, 1, 'DML',
                            2, 'DDL') rule_type,
       smr.msg_type_owner message_type_owner,
       smr.msg_type_name message_type_name,
       smr.msg_rule_var message_rule_variable,
       NVL(sr.rule_condition, smr.rule_condition) original_rule_condition,
       decode(NVL(sr.rule_condition, smr.rule_condition),
              NULL, NULL,
              dbms_lob.substr(r.rule_condition), 'YES',
              decode(least(4001,dbms_lob.getlength(r.rule_condition)),
                     4001, NULL, 'NO')) same_rule_condition
  from "_DBA_STREAMS_RULES_H" r, streams$_rules sr, streams$_message_rules smr
  where r.rule_name = sr.rule_name(+)
    and r.rule_owner = sr.rule_owner(+)
    and r.streams_name = sr.streams_name(+)
    and r.streams_type = sr.streams_type(+)
    and r.rule_name = smr.rule_name(+)
    and r.rule_owner = smr.rule_owner(+)
    and r.streams_name = smr.streams_name(+)
    and r.streams_type = smr.streams_type(+);

CREATE OR REPLACE FORCE VIEW "DBA_STREAMS_SCHEMA_RULES"("STREAMS_NAME",
select streams_name, decode(streams_type, 1, 'CAPTURE',
                                          2, 'PROPAGATION',
                                          3, 'APPLY',
                                          4, 'DEQUEUE', 'UNDEFINED'),
       schema_name, decode(rule_type, 1, 'DML',
                                      2, 'DDL', 'UNKNOWN'),
       decode(include_tagged_lcr, 0, 'NO',
                                  1, 'YES'),
       source_database, rule_name, rule_owner, rule_condition
  from "_DBA_STREAMS_RULES"
 where object_type = 2;

CREATE OR REPLACE FORCE VIEW "DBA_STREAMS_TABLE_RULES"("STREAMS_NAME",
select streams_name, decode(streams_type, 1, 'CAPTURE',
                                          2, 'PROPAGATION',
                                          3, 'APPLY',
                                          4, 'DEQUEUE', 'UNDEFINED'),
       schema_name, object_name, decode(rule_type, 1, 'DML',
                                                   2, 'DDL', 'UNKNOWN'),
       dml_condition, decode(subsetting_operation, 1, 'INSERT',
                                                   2, 'UPDATE',
                                                   3, 'DELETE'),
       decode(include_tagged_lcr, 0, 'NO',
                                  1, 'YES'),
       source_database, rule_name, rule_owner, rule_condition
  from "_DBA_STREAMS_RULES"
 where object_type = 1;

CREATE OR REPLACE FORCE VIEW "DBA_STREAMS_TRANSFORM_FUNCTION"("RULE_OWNER",
select r.rule_owner, r.rule_name, SYS.ANYDATA.GetTypeName(ctx.nvn_value),
       DECODE(SYS.ANYDATA.GetTypeName(ctx.nvn_value),
              'SYS.VARCHAR2', SYS.ANYDATA.AccessVarchar2(ctx.nvn_value),
              NULL)
from   DBA_RULES r, table(r.rule_action_context.actx_list) ctx
where  ctx.nvn_name = 'STREAMS$_TRANSFORM_FUNCTION';

CREATE OR REPLACE FORCE VIEW "DBA_STREAMS_UNSUPPORTED"("OWNER",
select owner, table_name, reason, auto_filtered
   from (select * from "_DBA_STREAMS_UNSUPPORTED_9_2" union
         select * from "_DBA_STREAMS_UNSUPPORTED_10_1")
   where compatible = dbms_logrep_util.get_str_compat();

CREATE OR REPLACE FORCE VIEW "DBA_SUBPARTITION_TEMPLATES"("USER_NAME",
select u.name, o.name, st.spart_name, st.spart_position + 1, ts.name,
       st.hiboundval
from sys.obj$ o, sys.defsubpart$ st, sys.ts$ ts, sys.user$ u
where st.bo# = o.obj# and st.ts# = ts.ts#(+) and o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "DBA_SUBPART_COL_STATISTICS"("OWNER",
select u.name, o.name, o.subname, tsp.cname, h.distcnt, h.lowval, h.hival,
       h.density, h.null_cnt,
       case when h.bucket_cnt > 255 then h.row_cnt else
         decode(h.row_cnt, h.distcnt, h.row_cnt, h.bucket_cnt)
       end,
       h.sample_size, h.timestamp#,
       decode(bitand(h.spare2, 2), 2, 'YES', 'NO'),
       decode(bitand(h.spare2, 1), 1, 'YES', 'NO'),
       h.avgcln,
       case when h.bucket_cnt > 255 then 'FREQUENCY' else
         decode(nvl(h.row_cnt, 0), 0, 'NONE',
                                   h.distcnt, 'FREQUENCY', 'HEIGHT BALANCED')
       end
from sys.obj$ o, sys.hist_head$ h, tsp$ tsp, user$ u
where o.obj# = tsp.obj# and tsp.obj# = h.obj#(+)
  and tsp.intcol# = h.intcol#(+)
  and o.type# = 34 /* TABLE SUBPARTITION */
  and o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "DBA_SUBPART_HISTOGRAMS"("OWNER",
select u.name,
       o.name, o.subname,
       tsp.cname,
       h.bucket,
       h.endpoint,
       h.epvalue
from sys.obj$ o, sys.histgrm$ h, sys.user$ u, tsp$ tsp
where o.obj# = tsp.obj# and tsp.obj# = h.obj#
  and tsp.intcol# = h.intcol#
  and o.type# = 34 /* TABLE SUBPARTITION */
  and o.owner# = u.user#
union
select u.name,
       o.name, o.subname,
       tsp.cname,
       0,
       h.minimum,
       null
from sys.obj$ o, sys.hist_head$ h, sys.user$ u, tsp$ tsp
where o.obj# = tsp.obj# and tsp.obj# = h.obj#
  and tsp.intcol# = h.intcol#
  and o.type# = 34 /* TABLE SUBPARTITION */
  and h.bucket_cnt = 1
  and o.owner# = u.user#
union
select u.name,
       o.name, o.subname,
       tsp.cname,
       1,
       h.maximum,
       null
from sys.obj$ o, sys.hist_head$ h, sys.user$ u, tsp$ tsp
where o.obj# = tsp.obj# and tsp.obj# = h.obj#
  and tsp.intcol# = h.intcol#
  and o.type# = 34 /* TABLE SUBPARTITION */
  and h.bucket_cnt = 1
  and o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "DBA_SUBPART_KEY_COLUMNS"("OWNER",
select u.name, o.name, 'TABLE',
  decode(bitand(c.property, 1), 1, a.name, c.name), spc.pos#
from   obj$ o, subpartcol$ spc, col$ c, user$ u, attrcol$ a
where  spc.obj# = o.obj# and spc.obj# = c.obj#
       and c.intcol# = spc.intcol#
       and u.user# = o.owner#
       and c.obj# = a.obj#(+) and c.intcol# = a.intcol#(+)
union
select u.name, o.name, 'INDEX',
  decode(bitand(c.property, 1), 1, a.name, c.name), spc.pos#
from   obj$ o, subpartcol$ spc, col$ c, user$ u, ind$ i, attrcol$ a
where  spc.obj# = i.obj# and i.obj# = o.obj# and i.bo# = c.obj#
       and c.intcol# = spc.intcol#
       and u.user# = o.owner#
       and c.obj# = a.obj#(+) and c.intcol# = a.intcol#(+);

CREATE OR REPLACE FORCE VIEW "DBA_SUBSCRIBED_COLUMNS"("HANDLE",
SELECT
   sc.handle, t.source_schema_name, t.source_table_name, sc.column_name,
   s.subscription_name
  FROM sys.cdc_subscribed_columns$ sc, sys.cdc_change_tables$ t,
       sys.cdc_subscribers$ s, sys.user$ u
  WHERE sc.change_table_obj#=t.obj# AND
        s.handle = sc.handle AND
        s.username = u.name AND
        u.user# = userenv('SCHEMAID');

CREATE OR REPLACE FORCE VIEW "DBA_SUBSCRIBED_TABLES"("HANDLE",
SELECT
   st.handle, t.source_schema_name, t.source_table_name, st.view_name,
   t.change_set_name, s.subscription_name
  FROM sys.cdc_subscribed_tables$ st, sys.cdc_change_tables$ t,
       sys.cdc_subscribers$ s
  WHERE st.change_table_obj#=t.obj# AND
        s.handle = st.handle;

CREATE OR REPLACE FORCE VIEW "DBA_SUBSCRIPTIONS"("HANDLE",
SELECT
   s.handle, s.set_name, s.username, s.created, s.status, s.earliest_scn,
   s.latest_scn, s.description, s.last_purged, s.last_extended,
   s.subscription_name
  FROM sys.cdc_subscribers$ s;

CREATE OR REPLACE FORCE VIEW "DBA_SUMMARIES"("OWNER",
select u.name, o.name, u.name, s.containernam,
       s.lastrefreshscn, s.lastrefreshdate,
       decode (s.refreshmode, 0, 'NONE', 1, 'ANY', 2, 'INCREMENTAL', 3,'FULL'),
       decode(bitand(s.pflags, 25165824), 25165824, 'N', 'Y'),
       s.fullrefreshtim, s.increfreshtim,
       decode(bitand(s.pflags, 48), 0, 'N', 'Y'),
       decode(bitand(s.mflags, 64), 0, 'N', 'Y'), /* QSMQSUM_UNUSABLE */
       decode(bitand(s.pflags, 1294319), 0, 'Y', 'N'),
       decode(bitand(s.pflags, 236879743), 0, 'Y', 'N'),
       decode(bitand(s.mflags, 1), 0, 'N', 'Y'), /* QSMQSUM_KNOWNSTL */
       s.sumtextlen,s.sumtext
from sys.user$ u, sys.sum$ s, sys.obj$ o
where o.owner# = u.user#
  and o.obj# = s.obj#
  and bitand(s.xpflags, 8388608) = 0  /* NOT REWRITE EQUIVALENCE SUMMARY */;

CREATE OR REPLACE FORCE VIEW "DBA_SUMMARY_AGGREGATES"("OWNER",
select u.name, o.name, sa.sumcolpos#, c.name,
       decode(sa.aggfunction, 15, 'AVG', 16, 'SUM', 17, 'COUNT',
                              18, 'MIN', 19, 'MAX',
                              97, 'VARIANCE', 98, 'STDDEV',
                              440, 'USER'),
       decode(sa.flags, 0, 'N', 'Y'),
       sa.aggtext
from sys.sumagg$ sa, sys.obj$ o, sys.user$ u, sys.sum$ s, sys.col$ c
where sa.sumobj# = o.obj#
  AND o.owner# = u.user#
  AND sa.sumobj# = s.obj#
  AND c.obj# = s.containerobj#
  AND c.col# = sa.containercol#
  AND bitand(s.xpflags, 8388608) = 0 /* NOT REWRITE EQUIVALENCE SUMMARY */;

CREATE OR REPLACE FORCE VIEW "DBA_SUMMARY_DETAIL_TABLES"("OWNER",
select u.name, o.name, du.name,  do.name,
       decode (sd.detailobjtype, 1, 'TABLE', 2, 'VIEW',
                                3, 'SNAPSHOT', 4, 'CONTAINER', 'UNDEFINED'),
       sd.detailalias
from sys.user$ u, sys.sumdetail$ sd, sys.obj$ o, sys.obj$ do,
     sys.user$ du, sys.sum$ s
where o.owner# = u.user#
  and o.obj# = sd.sumobj#
  and do.obj# = sd.detailobj#
  and do.owner# = du.user#
  and s.obj# = sd.sumobj#
  and bitand(s.xpflags, 8388608) = 0 /* NOT REWRITE EQUIVALENCE SUMMARY */;

CREATE OR REPLACE FORCE VIEW "DBA_SUMMARY_JOINS"("OWNER",
select u.name, o.name,
       u1.name, o1.name, c1.name, '=',
       u2.name, o2.name, c2.name
from sys.sumjoin$ sj, sys.obj$ o, sys.user$ u,
     sys.obj$ o1, sys.user$ u1, sys.col$ c1,
     sys.obj$ o2, sys.user$ u2, sys.col$ c2,
     sys.sum$ s
where sj.sumobj# = o.obj#
  AND o.owner# = u.user#
  AND sj.tab1obj# = o1.obj#
  AND o1.owner# = u1.user#
  AND sj.tab1obj# = c1.obj#
  AND sj.tab1col# = c1.intcol#
  AND sj.tab2obj# = o2.obj#
  AND o2.owner# = u2.user#
  AND sj.tab2obj# = c2.obj#
  AND sj.tab2col# = c2.intcol#
  AND s.obj# = sj.sumobj#
  AND bitand(s.xpflags, 8388608) = 0 /* NOT REWRITE EQUIVALENCE SUMMARY */;

CREATE OR REPLACE FORCE VIEW "DBA_SUMMARY_KEYS"("OWNER",
select u1.name, o1.name, sk.sumcolpos#, c1.name,
       u2.name, o2.name, sd.detailalias,
       decode(sk.detailobjtype, 1, 'TABLE', 2, 'VIEW'), c2.name
from sys.sumkey$ sk, sys.obj$ o1, sys.user$ u1, sys.col$ c1, sys.sum$ s,
     sys.sumdetail$ sd, sys.obj$ o2, sys.user$ u2, sys.col$ c2
where sk.sumobj# = o1.obj#
  AND o1.owner# = u1.user#
  AND sk.sumobj# = s.obj#
  AND s.containerobj# = c1.obj#
  AND c1.col# = sk.containercol#
  AND sk.detailobj# = o2.obj#
  AND o2.owner# = u2.user#
  AND sk.sumobj# = sd.sumobj#
  AND sk.detailobj# = sd.detailobj#
  AND sk.detailobj# = c2.obj#
  AND sk.detailcol# = c2.intcol#
  AND bitand(s.xpflags, 8388608) = 0 /* NOT REWRITE EQUIVALENCE SUMMARY */;

CREATE OR REPLACE FORCE VIEW "DBA_SYNONYMS"("OWNER",
select u.name, o.name, s.owner, s.name, s.node
from sys.user$ u, sys.syn$ s, sys.obj$ o
where o.obj# = s.obj#
  and o.type# = 5
  and o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "DBA_SYS_PRIVS"("GRANTEE",
select u.name,spm.name,decode(min(option$),1,'YES','NO')
from  sys.system_privilege_map spm, sys.sysauth$ sa, user$ u
where sa.grantee#=u.user# and sa.privilege#=spm.privilege
group by u.name,spm.name;

CREATE OR REPLACE FORCE VIEW "DBA_TABLES"("OWNER",
select u.name, o.name, decode(bitand(t.property,2151678048), 0, ts.name, null),
       decode(bitand(t.property, 1024), 0, null, co.name),
       decode((bitand(t.property, 512)+bitand(t.flags, 536870912)),
              0, null, co.name),
       decode(bitand(t.property, 32+64), 0, mod(t.pctfree$, 100), 64, 0, null),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
          decode(bitand(t.property, 32+64), 0, t.pctused$, 64, 0, null)),
       decode(bitand(t.property, 32), 0, t.initrans, null),
       decode(bitand(t.property, 32), 0, t.maxtrans, null),
       s.iniexts * ts.blocksize,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                      s.extsize * ts.blocksize),
       s.minexts, s.maxexts,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                      s.extpct),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
         decode(bitand(o.flags, 2), 2, 1, decode(s.lists, 0, 1, s.lists))),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
         decode(bitand(o.flags, 2), 2, 1, decode(s.groups, 0, 1, s.groups))),
       decode(bitand(t.property, 32+64), 0,
                decode(bitand(t.flags, 32), 0, 'YES', 'NO'), null),
       decode(bitand(t.flags,1), 0, 'Y', 1, 'N', '?'),
       t.rowcnt,
       decode(bitand(t.property, 64), 0, t.blkcnt, null),
       decode(bitand(t.property, 64), 0, t.empcnt, null),
       t.avgspc, t.chncnt, t.avgrln, t.avgspc_flb,
       decode(bitand(t.property, 64), 0, t.flbcnt, null),
       lpad(decode(t.degree, 32767, 'DEFAULT', nvl(t.degree,1)),10),
       lpad(decode(t.instances, 32767, 'DEFAULT', nvl(t.instances,1)),10),
       lpad(decode(bitand(t.flags, 8), 8, 'Y', 'N'),5),
       decode(bitand(t.flags, 6), 0, 'ENABLED', 'DISABLED'),
       t.samplesize, t.analyzetime,
       decode(bitand(t.property, 32), 32, 'YES', 'NO'),
       decode(bitand(t.property, 64), 64, 'IOT',
               decode(bitand(t.property, 512), 512, 'IOT_OVERFLOW',
               decode(bitand(t.flags, 536870912), 536870912, 'IOT_MAPPING', null))),
       decode(bitand(o.flags, 2), 0, 'N', 2, 'Y', 'N'),
       decode(bitand(o.flags, 16), 0, 'N', 16, 'Y', 'N'),
       decode(bitand(t.property, 8192), 8192, 'YES',
              decode(bitand(t.property, 1), 0, 'NO', 'YES')),
       decode(bitand(o.flags, 2), 2, 'DEFAULT',
             decode(s.cachehint, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL)),
       decode(bitand(t.flags, 131072), 131072, 'ENABLED', 'DISABLED'),
       decode(bitand(t.flags, 512), 0, 'NO', 'YES'),
       decode(bitand(t.flags, 256), 0, 'NO', 'YES'),
       decode(bitand(o.flags, 2), 0, NULL,
          decode(bitand(t.property, 8388608), 8388608,
                 'SYS$SESSION', 'SYS$TRANSACTION')),
       decode(bitand(t.flags, 1024), 1024, 'ENABLED', 'DISABLED'),
       decode(bitand(o.flags, 2), 2, 'NO',
           decode(bitand(t.property, 2147483648), 2147483648, 'NO',
              decode(ksppcv.ksppstvl, 'TRUE', 'YES', 'NO'))),
       decode(bitand(t.property, 1024), 0, null, cu.name),
       decode(bitand(t.flags, 8388608), 8388608, 'ENABLED', 'DISABLED'),
       decode(bitand(t.property, 32), 32, null,
                decode(bitand(s.spare1, 2048), 2048, 'ENABLED', 'DISABLED')),
       decode(bitand(o.flags, 128), 128, 'YES', 'NO')
from sys.user$ u, sys.ts$ ts, sys.seg$ s, sys.obj$ co, sys.tab$ t, sys.obj$ o,
     sys.obj$ cx, sys.user$ cu, x$ksppcv ksppcv, x$ksppi ksppi
where o.owner# = u.user#
  and o.obj# = t.obj#
  and bitand(t.property, 1) = 0
  and bitand(o.flags, 128) = 0
  and t.bobj# = co.obj# (+)
  and t.ts# = ts.ts#
  and t.file# = s.file# (+)
  and t.block# = s.block# (+)
  and t.ts# = s.ts# (+)
  and t.dataobj# = cx.obj# (+)
  and cx.owner# = cu.user# (+)
  and ksppi.indx = ksppcv.indx
  and ksppi.ksppinm = '_dml_monitoring_enabled';

CREATE OR REPLACE FORCE VIEW "DBA_TABLESPACES"("TABLESPACE_NAME",
select ts.name, ts.blocksize, ts.blocksize * ts.dflinit,
          decode(bitand(ts.flags, 3), 1, to_number(NULL),
                 ts.blocksize * ts.dflincr),
          ts.dflminext,
          decode(ts.contents$, 1, to_number(NULL), ts.dflmaxext),
          decode(bitand(ts.flags, 3), 1, to_number(NULL), ts.dflextpct),
          ts.blocksize * ts.dflminlen,
          decode(ts.online$, 1, 'ONLINE', 2, 'OFFLINE',
                 4, 'READ ONLY', 'UNDEFINED'),
          decode(ts.contents$, 0, (decode(bitand(ts.flags, 16), 16, 'UNDO',
                 'PERMANENT')), 1, 'TEMPORARY'),
          decode(bitand(ts.dflogging, 1), 0, 'NOLOGGING', 1, 'LOGGING'),
          decode(bitand(ts.dflogging, 2), 0, 'NO', 2, 'YES'),
          decode(ts.bitmapped, 0, 'DICTIONARY', 'LOCAL'),
          decode(bitand(ts.flags, 3), 0, 'USER', 1, 'SYSTEM', 2, 'UNIFORM',
                 'UNDEFINED'),
          decode(ts.plugged, 0, 'NO', 'YES'),
          decode(bitand(ts.flags,32), 32,'AUTO', 'MANUAL'),
          decode(bitand(ts.flags,64), 64,'ENABLED', 'DISABLED'),
          decode(bitand(ts.flags,16), 16, (decode(bitand(ts.flags, 512), 512,
                 'GUARANTEE', 'NOGUARANTEE')), 'NOT APPLY'),
          decode(bitand(ts.flags,256), 256, 'YES', 'NO')
from sys.ts$ ts
where ts.online$ != 3
and bitand(flags,2048) != 2048;

CREATE OR REPLACE FORCE VIEW "DBA_TABLESPACE_GROUPS"("GROUP_NAME",
select ts2.name, ts.name
from ts$ ts, ts$ ts2
where ts.online$ != 3
and bitand(ts.flags,1024) = 1024
    and ts.dflmaxext  = ts2.ts#;

CREATE OR REPLACE FORCE VIEW "DBA_TABLESPACE_USAGE_METRICS"("TABLESPACE_NAME",
SELECT t.name, sum(f.allocated_space), sum(f.file_maxsize),
     (sum(f.allocated_space)/sum(f.file_maxsize))*100
     FROM sys.ts$ t, v$filespace_usage f
     WHERE
     t.online$ != 3 and
     t.bitmapped <> 0 and
     t.contents$ = 0 and
     bitand(t.flags, 16) <> 16 and
     t.ts# = f.tablespace_id
     GROUP BY t.name, f.tablespace_id
union
 SELECT t.name, sum(f.allocated_space), sum(f.file_maxsize),
     (sum(f.allocated_space)/sum(f.file_maxsize))*100
     FROM sys.ts$ t, v$filespace_usage f
     WHERE
     t.online$ != 3 and
     t.bitmapped <> 0 and
     t.contents$ <> 0 and
     f.flag = 6 and
     t.ts# = f.tablespace_id
     GROUP BY t.name, f.tablespace_id
union
 SELECT t.name, sum(f.allocated_space), sum(f.file_maxsize),
     (sum(f.allocated_space)/sum(f.file_maxsize))*100
     FROM sys.ts$ t, gv$filespace_usage f, gv$parameter param
     WHERE
     t.online$ != 3 and
     t.bitmapped <> 0 and
     f.inst_id = param.inst_id and
     param.name = 'undo_tablespace' and
     t.name = param.value and
     f.flag = 6 and
     t.ts# = f.tablespace_id
     GROUP BY t.name, f.tablespace_id;

CREATE OR REPLACE FORCE VIEW "DBA_TAB_COLS"("OWNER",
select u.name, o.name,
       c.name,
       decode(c.type#, 1, decode(c.charsetform, 2, 'NVARCHAR2', 'VARCHAR2'),
                       2, decode(c.scale, null,
                                 decode(c.precision#, null, 'NUMBER', 'FLOAT'),
                                 'NUMBER'),
                       8, 'LONG',
                       9, decode(c.charsetform, 2, 'NCHAR VARYING', 'VARCHAR'),
                       12, 'DATE',
                       23, 'RAW', 24, 'LONG RAW',
                       58, nvl2(ac.synobj#, (select o.name from obj$ o
                                where o.obj#=ac.synobj#), ot.name),
                       69, 'ROWID',
                       96, decode(c.charsetform, 2, 'NCHAR', 'CHAR'),
                       100, 'BINARY_FLOAT',
                       101, 'BINARY_DOUBLE',
                       105, 'MLSLABEL',
                       106, 'MLSLABEL',
                       111, nvl2(ac.synobj#, (select o.name from obj$ o
                                 where o.obj#=ac.synobj#), ot.name),
                       112, decode(c.charsetform, 2, 'NCLOB', 'CLOB'),
                       113, 'BLOB', 114, 'BFILE', 115, 'CFILE',
                       121, nvl2(ac.synobj#, (select o.name from obj$ o
                                 where o.obj#=ac.synobj#), ot.name),
                       122, nvl2(ac.synobj#, (select o.name from obj$ o
                                 where o.obj#=ac.synobj#), ot.name),
                       123, nvl2(ac.synobj#, (select o.name from obj$ o
                                 where o.obj#=ac.synobj#), ot.name),
                       178, 'TIME(' ||c.scale|| ')',
                       179, 'TIME(' ||c.scale|| ')' || ' WITH TIME ZONE',
                       180, 'TIMESTAMP(' ||c.scale|| ')',
                       181, 'TIMESTAMP(' ||c.scale|| ')' || ' WITH TIME ZONE',
                       231, 'TIMESTAMP(' ||c.scale|| ')' || ' WITH LOCAL TIME ZONE',
                       182, 'INTERVAL YEAR(' ||c.precision#||') TO MONTH',
                       183, 'INTERVAL DAY(' ||c.precision#||') TO SECOND(' ||
                             c.scale || ')',
                       208, 'UROWID',
                       'UNDEFINED'),
       decode(c.type#, 111, 'REF'),
       nvl2(ac.synobj#, (select u.name from user$ u, obj$ o
            where o.owner#=u.user# and o.obj#=ac.synobj#), ut.name),
       c.length, c.precision#, c.scale,
       decode(sign(c.null$),-1,'D', 0, 'Y', 'N'),
       decode(c.col#, 0, to_number(null), c.col#), c.deflength,
       c.default$, h.distcnt, h.lowval, h.hival, h.density, h.null_cnt,
       case when h.bucket_cnt > 255 then h.row_cnt else
         decode(h.row_cnt, h.distcnt, h.row_cnt, h.bucket_cnt)
       end,
       h.timestamp#, h.sample_size,
       decode(c.charsetform, 1, 'CHAR_CS',
                             2, 'NCHAR_CS',
                             3, NLS_CHARSET_NAME(c.charsetid),
                             4, 'ARG:'||c.charsetid),
       decode(c.charsetid, 0, to_number(NULL),
                           nls_charset_decl_len(c.length, c.charsetid)),
       decode(bitand(h.spare2, 2), 2, 'YES', 'NO'),
       decode(bitand(h.spare2, 1), 1, 'YES', 'NO'),
       h.avgcln,
       c.spare3,
       decode(c.type#, 1, decode(bitand(c.property, 8388608), 0, 'B', 'C'),
                      96, decode(bitand(c.property, 8388608), 0, 'B', 'C'),
                      null),
       decode(bitand(ac.flags, 128), 128, 'YES', 'NO'),
       decode(o.status, 1, decode(bitand(ac.flags, 256), 256, 'NO', 'YES'),
                        decode(bitand(ac.flags, 2), 2, 'NO',
                               decode(bitand(ac.flags, 4), 4, 'NO',
                                      decode(bitand(ac.flags, 8), 8, 'NO',
                                             'N/A')))),
       decode(c.property, 0, 'NO', decode(bitand(c.property, 32), 32, 'YES',
                                          'NO')),
       decode(c.property, 0, 'NO', decode(bitand(c.property, 8), 8, 'YES',
                                          'NO')),
       decode(c.segcol#, 0, to_number(null), c.segcol#), c.intcol#,
       case when h.bucket_cnt > 255 then 'FREQUENCY' else
         decode(nvl(h.row_cnt, 0), 0, 'NONE',
                                   h.distcnt, 'FREQUENCY', 'HEIGHT BALANCED')
       end,
       decode(bitand(c.property, 1024), 1024,
              (select decode(bitand(cl.property, 1), 1, rc.name, cl.name)
               from sys.col$ cl, attrcol$ rc where cl.intcol# = c.intcol#-1
               and cl.obj# = c.obj# and c.obj# = rc.obj#(+) and
               cl.intcol# = rc.intcol#(+)),
              decode(bitand(c.property, 1), 0, c.name,
                     (select tc.name from sys.attrcol$ tc
                      where c.obj# = tc.obj# and c.intcol# = tc.intcol#)))
from sys.col$ c, sys.obj$ o, sys.hist_head$ h, sys.user$ u,
     sys.coltype$ ac, sys.obj$ ot, sys.user$ ut
where o.obj# = c.obj#
  and o.owner# = u.user#
  and c.obj# = h.obj#(+) and c.intcol# = h.intcol#(+)
  and c.obj# = ac.obj#(+) and c.intcol# = ac.intcol#(+)
  and ac.toid = ot.oid$(+)
  and ot.type#(+) = 13
  and ot.owner# = ut.user#(+)
  and (o.type# in (3, 4)                                     /* cluster, view */
       or
       (o.type# = 2     /* tables, excluding iot - overflow and nested tables */
        and
        not exists (select null
                      from sys.tab$ t
                     where t.obj# = o.obj#
                       and (bitand(t.property, 512) = 512 or
                            bitand(t.property, 8192) = 8192))));

CREATE OR REPLACE FORCE VIEW "DBA_TAB_COLUMNS"("OWNER",
select OWNER, TABLE_NAME,
       COLUMN_NAME, DATA_TYPE, DATA_TYPE_MOD, DATA_TYPE_OWNER,
       DATA_LENGTH, DATA_PRECISION, DATA_SCALE, NULLABLE, COLUMN_ID,
       DEFAULT_LENGTH, DATA_DEFAULT, NUM_DISTINCT, LOW_VALUE, HIGH_VALUE,
       DENSITY, NUM_NULLS, NUM_BUCKETS, LAST_ANALYZED, SAMPLE_SIZE,
       CHARACTER_SET_NAME, CHAR_COL_DECL_LENGTH,
       GLOBAL_STATS, USER_STATS, AVG_COL_LEN, CHAR_LENGTH, CHAR_USED,
       V80_FMT_IMAGE, DATA_UPGRADED, HISTOGRAM
  from DBA_TAB_COLS
 where HIDDEN_COLUMN = 'NO';

CREATE OR REPLACE FORCE VIEW "DBA_TAB_COL_STATISTICS"("OWNER",
select owner, table_name, column_name, num_distinct, low_value, high_value,
       density, num_nulls, num_buckets, last_analyzed, sample_size,
       global_stats, user_stats, avg_col_len, HISTOGRAM
from dba_tab_columns
where last_analyzed is not null
union all
select /* fixed table column stats */
       'SYS', ft.kqftanam, c.kqfconam,
       h.distcnt, h.lowval, h.hival,
       h.density, h.null_cnt,
       case when h.bucket_cnt > 255 then h.row_cnt else
         decode(h.row_cnt, h.distcnt, h.row_cnt, h.bucket_cnt)
       end,
       h.timestamp#, h.sample_size,
       decode(bitand(h.spare2, 2), 2, 'YES', 'NO'),
       decode(bitand(h.spare2, 1), 1, 'YES', 'NO'),
       h.avgcln,
       case when h.bucket_cnt > 255 then 'FREQUENCY' else
         decode(nvl(h.row_cnt, 0), 0, 'NONE',
                                   h.distcnt, 'FREQUENCY', 'HEIGHT BALANCED')
       end
from   sys.x$kqfta ft, sys.fixed_obj$ fobj,
         sys.x$kqfco c, sys.hist_head$ h
where
       ft.kqftaobj = fobj. obj#
       and c.kqfcotob = ft.kqftaobj
       and h.obj# = ft.kqftaobj
       and h.intcol# = c.kqfcocno
       /*
        * if fobj and st are not in sync (happens when db open read only
        * after upgrade), do not display stats.
        */
       and ft.kqftaver =
             fobj.timestamp - to_date('01-01-1991', 'DD-MM-YYYY')
       and h.timestamp# is not null;

CREATE OR REPLACE FORCE VIEW "DBA_TAB_COMMENTS"("OWNER",
select u.name, o.name,
       decode(o.type#, 0, 'NEXT OBJECT', 1, 'INDEX', 2, 'TABLE', 3, 'CLUSTER',
                      4, 'VIEW', 5, 'SYNONYM', 'UNDEFINED'),
       c.comment$
from sys.obj$ o, sys.user$ u, sys.com$ c
where o.owner# = u.user#
  and (o.type# in (4)                                                /* view */
       or
       (o.type# = 2                                                /* tables */
        AND         /* excluding iot-overflow, nested or mv container tables */
        not exists (select null
                      from sys.tab$ t
                     where t.obj# = o.obj#
                       and (bitand(t.property, 512) = 512 or
                            bitand(t.property, 8192) = 8192 OR
                            bitand(t.property, 67108864) = 67108864))))
  and o.obj# = c.obj#(+)
  and c.col#(+) is null;

CREATE OR REPLACE FORCE VIEW "DBA_TAB_HISTOGRAMS"("OWNER",
select /*+ ordered */ u.name,
       o.name,
       decode(bitand(c.property, 1), 1, a.name, c.name),
       h.bucket,
       h.endpoint,
       h.epvalue
from sys.user$ u, sys.obj$ o, sys.col$ c, sys.histgrm$ h, sys.attrcol$ a
where o.obj# = c.obj#
  and o.owner# = u.user#
  and c.obj# = h.obj# and c.intcol# = h.intcol#
  and (o.type# in (3, 4)                                     /* cluster, view */
       or
       (o.type# = 2     /* tables, excluding iot - overflow and nested tables */
        and
        not exists (select null
                      from sys.tab$ t
                     where t.obj# = o.obj#
                       and (bitand(t.property, 512) = 512 or
                            bitand(t.property, 8192) = 8192))))
  and c.obj# = a.obj#(+)
  and c.intcol# = a.intcol#(+)
union all
select /*+ ordered */ u.name,
       o.name,
       decode(bitand(c.property, 1), 1, a.name, c.name),
       0,
       h.minimum,
       null
from sys.user$ u, sys.obj$ o, sys.col$ c, sys.hist_head$ h, sys.attrcol$ a
where o.obj# = c.obj#
  and o.owner# = u.user#
  and c.obj# = h.obj# and c.intcol# = h.intcol#
  and (o.type# in (3, 4)                                     /* cluster, view */
       or
       (o.type# = 2     /* tables, excluding iot - overflow and nested tables */
        and
        not exists (select null
                      from sys.tab$ t
                     where t.obj# = o.obj#
                       and (bitand(t.property, 512) = 512 or
                            bitand(t.property, 8192) = 8192))))
  and h.bucket_cnt = 1
  and c.obj# = a.obj#(+)
  and c.intcol# = a.intcol#(+)
union all
select /*+ ordered */ u.name,
       o.name,
       decode(bitand(c.property, 1), 1, a.name, c.name),
       1,
       h.maximum,
       null
from sys.user$ u, sys.obj$ o, sys.col$ c, sys.hist_head$ h, sys.attrcol$ a
where o.obj# = c.obj#
  and o.owner# = u.user#
  and c.obj# = h.obj# and c.intcol# = h.intcol#
  and (o.type# in (3, 4)                                     /* cluster, view */
       or
       (o.type# = 2     /* tables, excluding iot - overflow and nested tables */
        and
        not exists (select null
                      from sys.tab$ t
                     where t.obj# = o.obj#
                       and (bitand(t.property, 512) = 512 or
                            bitand(t.property, 8192) = 8192))))
  and h.bucket_cnt = 1
  and c.obj# = a.obj#(+)
  and c.intcol# = a.intcol#(+)
union all
select /*+ ordered */
       'SYS',
       ft.kqftanam,
       c.kqfconam,
       h.bucket,
       h.endpoint,
       h.epvalue
from   sys.x$kqfta ft, sys.fixed_obj$ fobj, sys.x$kqfco c, sys.histgrm$ h
where  ft.kqftaobj = fobj. obj#
  and c.kqfcotob = ft.kqftaobj
  and h.obj# = ft.kqftaobj
  and h.intcol# = c.kqfcocno
  /*
   * if fobj and st are not in sync (happens when db open read only
   * after upgrade), do not display stats.
   */
  and ft.kqftaver =
         fobj.timestamp - to_date('01-01-1991', 'DD-MM-YYYY');

CREATE OR REPLACE FORCE VIEW "DBA_TAB_MODIFICATIONS"("TABLE_OWNER",
select u.name, o.name, null, null,
       m.inserts, m.updates, m.deletes, m.timestamp,
       decode(bitand(m.flags,1),1,'YES','NO'),
       m.drop_segments
from sys.mon_mods$ m, sys.obj$ o, sys.tab$ t, sys.user$ u
where o.obj# = m.obj# and o.obj# = t.obj# and o.owner# = u.user#
union all
select u.name, o.name, o.subname, null,
       m.inserts, m.updates, m.deletes, m.timestamp,
       decode(bitand(m.flags,1),1,'YES','NO'),
       m.drop_segments
from sys.mon_mods$ m, sys.obj$ o, sys.user$ u
where o.owner# = u.user# and o.obj# = m.obj# and o.type#=19
union all
select u.name, o.name, o2.subname, o.subname,
       m.inserts, m.updates, m.deletes, m.timestamp,
       decode(bitand(m.flags,1),1,'YES','NO'),
       m.drop_segments
from sys.mon_mods$ m, sys.obj$ o, sys.tabsubpart$ tsp, sys.obj$ o2,
     sys.user$ u
where o.obj# = m.obj# and o.owner# = u.user# and
      o.obj# = tsp.obj# and o2.obj# = tsp.pobj#;

CREATE OR REPLACE FORCE VIEW "DBA_TAB_PARTITIONS"("TABLE_OWNER",
select u.name, o.name, 'NO', o.subname, 0,
       tp.hiboundval, tp.hiboundlen, tp.part#, ts.name,
       tp.pctfree$,
       decode(bitand(ts.flags, 32), 32, to_number(NULL), tp.pctused$),
       initrans, maxtrans, s.iniexts * ts.blocksize,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
                               s.extsize * ts.blocksize),
       s.minexts, s.maxexts,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                      s.extpct),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
          decode(s.lists, 0, 1, s.lists)),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
          decode(s.groups, 0, 1, s.groups)),
       decode(mod(trunc(tp.flags / 4), 2), 0, 'YES', 'NO'),
       decode(bitand(s.spare1, 2048), 2048, 'ENABLED', 'DISABLED'),
       tp.rowcnt, tp.blkcnt, tp.empcnt, tp.avgspc, tp.chncnt, tp.avgrln,
       tp.samplesize, tp.analyzetime,
       decode(s.cachehint, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL),
       decode(bitand(tp.flags, 16), 0, 'NO', 'YES'),
       decode(bitand(tp.flags, 8), 0, 'NO', 'YES')
from   obj$ o, tabpartv$ tp, ts$ ts, sys.seg$ s, user$ u
where  o.obj# = tp.obj# and ts.ts# = tp.ts# and u.user# = o.owner# and
       tp.file#=s.file# and tp.block#=s.block# and tp.ts#=s.ts#
union all -- IOT Partitions
select u.name, o.name, 'NO', o.subname, 0,
       tp.hiboundval, tp.hiboundlen, tp.part#, NULL,
       TO_NUMBER(NULL),TO_NUMBER(NULL),TO_NUMBER(NULL),TO_NUMBER(NULL),
       TO_NUMBER(NULL),
       TO_NUMBER(NULL),TO_NUMBER(NULL),TO_NUMBER(NULL),TO_NUMBER(NULL),
       TO_NUMBER(NULL),TO_NUMBER(NULL),
       NULL,
       'N/A',
       tp.rowcnt, TO_NUMBER(NULL), TO_NUMBER(NULL), 0, tp.chncnt, tp.avgrln,
       tp.samplesize, tp.analyzetime, NULL,
       decode(bitand(tp.flags, 16), 0, 'NO', 'YES'),
       decode(bitand(tp.flags, 8), 0, 'NO', 'YES')
from   obj$ o, tabpartv$ tp, user$ u
where  o.obj# = tp.obj# and o.owner# = u.user# and
       tp.file#=0 and tp.block#=0
union all -- Composite Partitions
select u.name, o.name, 'YES', o.subname, tcp.subpartcnt,
       tcp.hiboundval, tcp.hiboundlen, tcp.part#, ts.name,
       tcp.defpctfree, decode(bitand(ts.flags, 32), 32, to_number(NULL),
       tcp.defpctused),
       tcp.definitrans, tcp.defmaxtrans,
       tcp.definiexts, tcp.defextsize, tcp.defminexts, tcp.defmaxexts,
       tcp.defextpct,
       decode(bitand(ts.flags, 32), 32, to_number(NULL), tcp.deflists),
       decode(bitand(ts.flags, 32), 32, to_number(NULL), tcp.defgroups),
       decode(tcp.deflogging, 0, 'NONE', 1, 'YES', 2, 'NO', 'UNKNOWN'),
       decode(mod(tcp.spare2,256), 0, 'NONE', 1, 'ENABLED',  2, 'DISABLED',
                                   'UNKNOWN'),
       tcp.rowcnt, tcp.blkcnt, tcp.empcnt, tcp.avgspc, tcp.chncnt, tcp.avgrln,
       tcp.samplesize, tcp.analyzetime,
       decode(tcp.defbufpool, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL),
       decode(bitand(tcp.flags, 16), 0, 'NO', 'YES'),
       decode(bitand(tcp.flags, 8), 0, 'NO', 'YES')
from   obj$ o, tabcompartv$ tcp, ts$ ts, user$ u
where  o.obj# = tcp.obj# and tcp.defts# = ts.ts# and u.user# = o.owner#;

CREATE OR REPLACE FORCE VIEW "DBA_TAB_PRIVS"("GRANTEE",
select ue.name, u.name, o.name, ur.name, tpm.name,
       decode(mod(oa.option$,2), 1, 'YES', 'NO'),
       decode(bitand(oa.option$,2), 2, 'YES', 'NO')
from sys.objauth$ oa, sys.obj$ o, sys.user$ u, sys.user$ ur, sys.user$ ue,
     table_privilege_map tpm
where oa.obj# = o.obj#
  and oa.grantor# = ur.user#
  and oa.grantee# = ue.user#
  and oa.col# is null
  and oa.privilege# = tpm.privilege
  and u.user# = o.owner#;

CREATE OR REPLACE FORCE VIEW "DBA_TAB_STATISTICS"("OWNER",
SELECT /* TABLES */
    u.name, o.name, NULL, NULL, NULL, NULL, 'TABLE', t.rowcnt,
    decode(bitand(t.property, 64), 0, t.blkcnt, TO_NUMBER(NULL)),
    decode(bitand(t.property, 64), 0, t.empcnt, TO_NUMBER(NULL)),
    decode(bitand(t.property, 64), 0, t.avgspc, TO_NUMBER(NULL)),
    t.chncnt, t.avgrln, t.avgspc_flb,
    decode(bitand(t.property, 64), 0, t.flbcnt, TO_NUMBER(NULL)),
    ts.cachedblk, ts.cachehit, t.samplesize, t.analyzetime,
    decode(bitand(t.flags, 512), 0, 'NO', 'YES'),
    decode(bitand(t.flags, 256), 0, 'NO', 'YES'),
    decode(bitand(t.trigflag, 67108864) + bitand(t.trigflag, 134217728),
           0, NULL, 67108864, 'DATA', 134217728, 'CACHE', 'ALL')
  FROM
    sys.user$ u, sys.obj$ o, sys.tab$ t, sys.tab_stats$ ts
  WHERE
        o.owner# = u.user#
    and o.obj# = t.obj#
    and bitand(t.property, 1) = 0 /* not a typed table */
    and o.obj# = ts.obj# (+)
  UNION ALL
  SELECT /* PARTITIONS,  NOT IOT */
    u.name, o.name, o.subname, tp.part#, NULL, NULL, 'PARTITION',
    tp.rowcnt, tp.blkcnt, tp.empcnt, tp.avgspc,
    tp.chncnt, tp.avgrln, TO_NUMBER(NULL), TO_NUMBER(NULL),
    ts.cachedblk, ts.cachehit, tp.samplesize, tp.analyzetime,
    decode(bitand(tp.flags, 16), 0, 'NO', 'YES'),
    decode(bitand(tp.flags, 8), 0, 'NO', 'YES'),
    decode(bitand(tab.trigflag, 67108864) + bitand(tab.trigflag, 134217728),
           0, NULL, 67108864, 'DATA', 134217728, 'CACHE', 'ALL')
  FROM
    sys.user$ u, sys.obj$ o, sys.tabpartv$ tp, sys.tab_stats$ ts, sys.tab$ tab
  WHERE
        o.owner# = u.user#
    and o.obj# = tp.obj#
    and tp.bo# = tab.obj#
    and tp.file# > 0
    and tp.block# > 0
    and o.obj# = ts.obj# (+)
  UNION ALL
  SELECT /* IOT Partitions */
    u.name, o.name, o.subname, tp.part#, NULL, NULL, 'PARTITION',
    tp.rowcnt, TO_NUMBER(NULL), TO_NUMBER(NULL), TO_NUMBER(NULL),
    tp.chncnt, tp.avgrln, TO_NUMBER(NULL), TO_NUMBER(NULL),
    TO_NUMBER(NULL), TO_NUMBER(NULL), tp.samplesize, tp.analyzetime,
    decode(bitand(tp.flags, 16), 0, 'NO', 'YES'),
    decode(bitand(tp.flags, 8), 0, 'NO', 'YES'),
    decode(bitand(tab.trigflag, 67108864) + bitand(tab.trigflag, 134217728),
           0, NULL, 67108864, 'DATA', 134217728, 'CACHE', 'ALL')
  FROM
    sys.user$ u, sys.obj$ o, sys.tabpartv$ tp, sys.tab$ tab
  WHERE
        o.owner# = u.user#
    and o.obj# = tp.obj#
    and tp.bo# = tab.obj#
    and tp.file# = 0
    and tp.block# = 0
  UNION ALL
  SELECT /* COMPOSITE PARTITIONS */
    u.name, o.name, o.subname, tcp.part#, NULL, NULL, 'PARTITION',
    tcp.rowcnt, tcp.blkcnt, tcp.empcnt, tcp.avgspc,
    tcp.chncnt, tcp.avgrln, NULL, NULL, ts.cachedblk, ts.cachehit,
    tcp.samplesize, tcp.analyzetime,
    decode(bitand(tcp.flags, 16), 0, 'NO', 'YES'),
    decode(bitand(tcp.flags, 8), 0, 'NO', 'YES'),
    decode(bitand(tab.trigflag, 67108864) + bitand(tab.trigflag, 134217728),
           0, NULL, 67108864, 'DATA', 134217728, 'CACHE', 'ALL')
  FROM
    sys.user$ u, sys.obj$ o, sys.tabcompartv$ tcp,
    sys.tab_stats$ ts, sys.tab$ tab
  WHERE
        o.owner# = u.user#
    and o.obj# = tcp.obj#
    and tcp.bo# = tab.obj#
    and o.obj# = ts.obj# (+)
  UNION ALL
  SELECT /* SUBPARTITIONS */
    u.name, po.name, po.subname, tcp.part#,  so.subname, tsp.subpart#,
   'SUBPARTITION', tsp.rowcnt,
    tsp.blkcnt, tsp.empcnt, tsp.avgspc,
    tsp.chncnt, tsp.avgrln, NULL, NULL,
    ts.cachedblk, ts.cachehit, tsp.samplesize, tsp.analyzetime,
    decode(bitand(tsp.flags, 16), 0, 'NO', 'YES'),
    decode(bitand(tsp.flags, 8), 0, 'NO', 'YES'),
    decode(bitand(tab.trigflag, 67108864) + bitand(tab.trigflag, 134217728),
           0, NULL, 67108864, 'DATA', 134217728, 'CACHE', 'ALL')
  FROM
    sys.user$ u, sys.obj$ po, sys.obj$ so, sys.tabcompartv$ tcp,
    sys.tabsubpartv$ tsp,  sys.tab_stats$ ts, sys.tab$ tab
  WHERE
        so.obj# = tsp.obj#
    and po.obj# = tcp.obj#
    and tcp.obj# = tsp.pobj#
    and tcp.bo# = tab.obj#
    and u.user# = po.owner#
    and tsp.file# > 0
    and tsp.block# > 0
    and so.obj# = ts.obj# (+)
  UNION ALL
  SELECT /* FIXED TABLES */
    'SYS', t.kqftanam, NULL, NULL, NULL, NULL, 'FIXED TABLE',
    decode(nvl(fobj.obj#, 0), 0, TO_NUMBER(NULL), st.rowcnt),
    TO_NUMBER(NULL), TO_NUMBER(NULL), TO_NUMBER(NULL), TO_NUMBER(NULL),
    decode(nvl(fobj.obj#, 0), 0, TO_NUMBER(NULL), st.avgrln),
    TO_NUMBER(NULL), TO_NUMBER(NULL), TO_NUMBER(NULL), TO_NUMBER(NULL),
    decode(nvl(fobj.obj#, 0), 0, TO_NUMBER(NULL), st.samplesize),
    decode(nvl(fobj.obj#, 0), 0, TO_DATE(NULL), st.analyzetime),
    decode(nvl(fobj.obj#, 0), 0, NULL,
           decode(nvl(st.obj#, 0), 0, NULL, 'YES')),
    decode(nvl(fobj.obj#, 0), 0, NULL,
           decode(nvl(st.obj#, 0), 0, NULL,
                  decode(bitand(st.flags, 1), 0, 'NO', 'YES'))),
    decode(nvl(fobj.obj#, 0), 0, NULL,
           decode (bitand(fobj.flags, 67108864) +
                     bitand(fobj.flags, 134217728),
                   0, NULL, 67108864, 'DATA', 134217728, 'CACHE', 'ALL'))
    from sys.x$kqfta t, sys.fixed_obj$ fobj, sys.tab_stats$ st
    where
    t.kqftaobj = fobj.obj#(+)
    /*
     * if fobj and st are not in sync (happens when db open read only
     * after upgrade), do not display stats.
     */
    and t.kqftaver = fobj.timestamp (+) - to_date('01-01-1991', 'DD-MM-YYYY')
    and t.kqftaobj = st.obj#(+);

CREATE OR REPLACE FORCE VIEW "DBA_TAB_STATS_HISTORY"("OWNER",
select u.name, o.name, null, null, h.savtime
  from   sys.user$ u, sys.obj$ o, sys.wri$_optstat_tab_history h
  where  h.obj# = o.obj# and o.type# = 2 and o.owner# = u.user#
  union all
  -- partitions
  select u.name, o.name, o.subname, null, h.savtime
  from   sys.user$ u, sys.obj$ o, sys.wri$_optstat_tab_history h
  where  h.obj# = o.obj# and o.type# = 19 and o.owner# = u.user#
  union all
  -- sub partitions
  select u.name, osp.name, ocp.subname, osp.subname, h.savtime
  from  sys.user$ u,  sys.obj$ osp, obj$ ocp,  sys.tabsubpart$ tsp,
        sys.wri$_optstat_tab_history h
  where h.obj# = osp.obj# and osp.type# = 34 and osp.obj# = tsp.obj# and
        tsp.pobj# = ocp.obj# and osp.owner# = u.user#
  union all
  -- fixed tables
  select 'SYS', t.kqftanam, null, null, h.savtime
  from  sys.x$kqfta t, sys.wri$_optstat_tab_history h
  where
  t.kqftaobj = h.obj#;

CREATE OR REPLACE FORCE VIEW "DBA_TAB_SUBPARTITIONS"("TABLE_OWNER",
select u.name, po.name, po.subname, so.subname,
       tsp.hiboundval, tsp.hiboundlen, tsp.subpart#,
       ts.name,  tsp.pctfree$,
       decode(bitand(ts.flags, 32), 32, to_number(NULL), tsp.pctused$),
       tsp.initrans, tsp.maxtrans,
       s.iniexts * ts.blocksize,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
                               s.extsize * ts.blocksize),
       s.minexts, s.maxexts,
       decode(bitand(ts.flags, 3), 1, to_number(NULL),
                                      s.extpct),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
          decode(s.lists, 0, 1, s.lists)),
       decode(bitand(ts.flags, 32), 32, to_number(NULL),
          decode(s.groups, 0, 1, s.groups)),
       decode(mod(trunc(tsp.flags / 4), 2), 0, 'YES', 'NO'),
       decode(bitand(s.spare1, 2048), 2048, 'ENABLED', 'DISABLED'),
       tsp.rowcnt, tsp.blkcnt, tsp.empcnt, tsp.avgspc, tsp.chncnt,
       tsp.avgrln, tsp.samplesize, tsp.analyzetime,
       decode(s.cachehint, 0, 'DEFAULT', 1, 'KEEP', 2, 'RECYCLE', NULL),
       decode(bitand(tsp.flags, 16), 0, 'NO', 'YES'),
       decode(bitand(tsp.flags, 8), 0, 'NO', 'YES')
from   sys.obj$ so, sys.obj$ po, sys.tabsubpartv$ tsp, sys.ts$ ts,
       sys.seg$ s, sys.user$ u
where  so.obj# = tsp.obj# and po.obj# = tsp.pobj# and tsp.ts# = ts.ts# and
       u.user# = po.owner# and tsp.file# = s.file# and tsp.block# = s.block# and
       tsp.ts# = s.ts#;

CREATE OR REPLACE FORCE VIEW "DBA_TEMPLATE_REFGROUPS"("REFRESH_GROUP_ID",
select rg.refresh_group_id, rg.refresh_group_name, rt.refresh_template_id,
  rt.refresh_template_name, rg.rollback_seg, rg.start_date, rg.interval
from system.repcat$_refresh_templates rt,
  system.repcat$_template_refgroups rg,
  system.repcat$_template_types tt
where rt.refresh_template_id = rg.refresh_template_id
and rt.template_type_id = tt.template_type_id
and bitand(rawtohex(tt.flags),1) = 1;

CREATE OR REPLACE FORCE VIEW "DBA_TEMPLATE_TARGETS"("TEMPLATE_TARGET_ID",
select tt.template_target_id, tt.target_database, tt.target_comment,
       tt.connect_string
from system.repcat$_template_targets tt;

CREATE OR REPLACE FORCE VIEW "DBA_TEMP_FILES"("FILE_NAME",
select /*+ ordered use_nl(hc) */
       v.fnnam, hc.ktfthctfno, ts.name,
       decode(hc.ktfthccval, 0, ts.blocksize * hc.ktfthcsz, NULL),
       decode(hc.ktfthccval, 0, hc.ktfthcsz, NULL), 'AVAILABLE',
       decode(hc.ktfthccval, 0, hc.ktfthcfno, NULL),
       decode(hc.ktfthccval, 0, decode(hc.ktfthcinc, 0, 'NO', 'YES'), NULL),
       decode(hc.ktfthccval, 0, ts.blocksize * hc.ktfthcmaxsz, NULL),
       decode(hc.ktfthccval, 0, hc.ktfthcmaxsz, NULL),
       decode(hc.ktfthccval, 0, hc.ktfthcinc, NULL),
       decode(hc.ktfthccval, 0, hc.ktfthcusz * ts.blocksize, NULL),
       decode(hc.ktfthccval, 0, hc.ktfthcusz, NULL)
from sys.x$kccfn v, sys.x$ktfthc hc, sys.ts$ ts
where v.fntyp = 7 and v.fnnam is not null
  and v.fnfno = hc.ktfthctfno
  and hc.ktfthctsn = ts.ts#;

CREATE OR REPLACE FORCE VIEW "DBA_THRESHOLDS"("METRICS_NAME",
select m.name AS metrics_name,
            decode(a.warning_operator, 0, 'GT',
                                       1, 'EQ',
                                       2, 'LT',
                                       3, 'LE',
                                       4, 'GE',
                                       5, 'CONTAINS',
                                       6, 'NE',
                                       7, 'DO NOT CHECK',
                                          'NONE') AS warning_operator,
            a.warning_value AS warning_value,
            decode(a.critical_operator, 0, 'GT',
                                        1, 'EQ',
                                        2, 'LT',
                                        3, 'LE',
                                        4, 'GE',
                                        5, 'CONTAINS',
                                        6, 'NE',
                                        7, 'DO_NOT_CHECK',
                                           'NONE') AS critical_operator,
            a.critical_value AS critical_value,
            a.observation_period AS observation_period,
            a.consecutive_occurrences AS consecutive_occurrences,
            decode(a.metrics_id, 9000, null,
                                       instance_name) AS instance_name,
            o.typnam_keltosd AS object_type,
            a.object_name AS object_name,
            decode(a.flags, 1, 'VALID',
                            0, 'INVALID') AS status
  FROM table(dbms_server_alert.view_thresholds) a,
       X$KEWMDSM m,
       X$KELTOSD o
  WHERE a.object_type != 2
    AND m.metricid(+) = a.metrics_id
    AND a.object_type = o.typid_keltosd
  UNION
     select m.name AS metrics_name,
            decode(a.warning_operator, 0, 'GT',
                                       1, 'EQ',
                                       2, 'LT',
                                       3, 'LE',
                                       4, 'GE',
                                       5, 'CONTAINS',
                                       6, 'NE',
                                       7, 'DO_NOT_CHECK',
                                          'NONE') AS warning_operator,
            a.warning_value AS warning_value,
            decode(a.critical_operator, 0, 'GT',
                                        1, 'EQ',
                                        2, 'LT',
                                        3, 'LE',
                                        4, 'GE',
                                        5, 'CONTAINS',
                                        6, 'NE',
                                        7, 'DO NOT CHECK',
                                           'NONE') AS critical_operator,
            a.critical_value AS critical_value,
            a.observation_period AS observation_period,
            a.consecutive_occurrences AS consecutive_occurrences,
            a.instance_name AS instance_name,
            o.typnam_keltosd AS object_type,
            f.name AS object_name,
            decode(a.flags, 1, 'VALID',
                            0, 'INVALID') AS status
  FROM table(dbms_server_alert.view_thresholds) a,
       X$KEWMDSM m, sys.v$dbfile f, X$KELTOSD o
  WHERE a.object_type = 2
    AND m.metricid = a.metrics_id
    AND a.object_id = f.file#
    AND a.object_type = o.typid_keltosd;

CREATE OR REPLACE FORCE VIEW "DBA_TRANSFORMATIONS"("TRANSFORMATION_ID",
SELECT t.transformation_id, u.name, t.name,
       t.from_schema||'.'||t.from_type, t.to_schema||'.'||t.to_type
FROM transformations$ t, sys.user$ u
WHERE  u.name = t.owner;

CREATE OR REPLACE FORCE VIEW "DBA_TRIGGERS"("OWNER",
select trigusr.name, trigobj.name,
decode(t.type#, 0, 'BEFORE STATEMENT',
                1, 'BEFORE EACH ROW',
                2, 'AFTER STATEMENT',
                3, 'AFTER EACH ROW',
                4, 'INSTEAD OF',
                   'UNDEFINED'),
decode(t.insert$*100 + t.update$*10 + t.delete$,
                 100, 'INSERT',
                 010, 'UPDATE',
                 001, 'DELETE',
                 110, 'INSERT OR UPDATE',
                 101, 'INSERT OR DELETE',
                 011, 'UPDATE OR DELETE',
                 111, 'INSERT OR UPDATE OR DELETE', 'ERROR'),
tabusr.name,
decode(bitand(t.property, 1), 1, 'VIEW',
                              0, 'TABLE',
                                 'UNDEFINED'),
tabobj.name, NULL,
'REFERENCING NEW AS '||t.refnewname||' OLD AS '||t.refoldname,
t.whenclause,decode(t.enabled, 0, 'DISABLED', 1, 'ENABLED', 'ERROR'),
t.definition,
decode(bitand(t.property, 2), 2, 'CALL',
                                 'PL/SQL     '),
t.action#
from sys.obj$ trigobj, sys.obj$ tabobj, sys.trigger$ t,
     sys.user$ tabusr, sys.user$ trigusr
where (trigobj.obj#   = t.obj# and
       tabobj.obj#    = t.baseobject and
       tabobj.owner#  = tabusr.user# and
       trigobj.owner# = trigusr.user# and
       bitand(t.property, 63)     < 8 )
union all
select trigusr.name, trigobj.name,
decode(t.type#, 0, 'BEFORE EVENT',
                2, 'AFTER EVENT',
                   'UNDEFINED'),
decode(bitand(t.sys_evts, 1), 1, 'STARTUP ') ||
decode(bitand(t.sys_evts, 2), 2,
       decode(sign(bitand(t.sys_evts, 1)), 1, 'OR SHUTDOWN ',
                                               'SHUTDOWN ')) ||
decode(bitand(t.sys_evts, 4), 4,
       decode(sign(bitand(t.sys_evts, 3)), 1, 'OR ERROR ',
                                              'ERROR ')) ||
decode(bitand(t.sys_evts, 8), 8,
       decode(sign(bitand(t.sys_evts, 7)), 1, 'OR LOGON ',
                                              'LOGON ')) ||
decode(bitand(t.sys_evts, 16), 16,
       decode(sign(bitand(t.sys_evts, 15)), 1, 'OR LOGOFF ',
                                               'LOGOFF ')) ||
decode(bitand(t.sys_evts, 262176), 32,
       decode(sign(bitand(t.sys_evts, 31)), 1, 'OR CREATE ',
                                               'CREATE ')) ||
decode(bitand(t.sys_evts, 262208), 64,
       decode(sign(bitand(t.sys_evts, 63)), 1, 'OR ALTER ',
                                               'ALTER ')) ||
decode(bitand(t.sys_evts, 262272), 128,
       decode(sign(bitand(t.sys_evts, 127)), 1, 'OR DROP ',
                                                'DROP ')) ||
decode (bitand(t.sys_evts, 262400), 256,
        decode(sign(bitand(t.sys_evts, 255)), 1, 'OR ANALYZE ',
                                                 'ANALYZE ')) ||
decode (bitand(t.sys_evts, 262656), 512,
        decode(sign(bitand(t.sys_evts, 511)), 1, 'OR COMMENT ',
                                                 'COMMENT ')) ||
decode (bitand(t.sys_evts, 263168), 1024,
        decode(sign(bitand(t.sys_evts, 1023)), 1, 'OR GRANT ',
                                                  'GRANT ')) ||
decode (bitand(t.sys_evts, 264192), 2048,
        decode(sign(bitand(t.sys_evts, 2047)), 1, 'OR REVOKE ',
                                                  'REVOKE ')) ||
decode (bitand(t.sys_evts, 266240), 4096,
        decode(sign(bitand(t.sys_evts, 4095)), 1, 'OR TRUNCATE ',
                                                  'TRUNCATE ')) ||
decode (bitand(t.sys_evts, 270336), 8192,
        decode(sign(bitand(t.sys_evts, 8191)), 1, 'OR RENAME ',
                                                  'RENAME ')) ||
decode (bitand(t.sys_evts, 278528), 16384,
        decode(sign(bitand(t.sys_evts, 16383)), 1, 'OR ASSOCIATE STATISTICS ',
                                                   'ASSOCIATE STATISTICS ')) ||
decode (bitand(t.sys_evts, 294912), 32768,
        decode(sign(bitand(t.sys_evts, 32767)), 1, 'OR AUDIT ',
                                                   'AUDIT ')) ||
decode (bitand(t.sys_evts, 327680), 65536,
        decode(sign(bitand(t.sys_evts, 65535)), 1,
               'OR DISASSOCIATE STATISTICS ', 'DISASSOCIATE STATISTICS ')) ||
decode (bitand(t.sys_evts, 393216), 131072,
        decode(sign(bitand(t.sys_evts, 131071)), 1, 'OR NOAUDIT ',
                                                    'NOAUDIT ')) ||
decode (bitand(t.sys_evts, 262144), 262144,
        decode(sign(bitand(t.sys_evts, 31)), 1, 'OR DDL ',
                                                   'DDL ')) ||
decode (bitand(t.sys_evts, 8388608), 8388608,
        decode(sign(bitand(t.sys_evts, 8388607)), 1, 'OR SUSPEND ',
                                                     'SUSPEND ')),
'SYS',
'DATABASE        ',
NULL,
NULL,
'REFERENCING NEW AS '||t.refnewname||' OLD AS '||t.refoldname
  || decode(bitand(t.property,32),32,' PARENT AS ' || t.refprtname,NULL),
t.whenclause,decode(t.enabled, 0, 'DISABLED', 1, 'ENABLED', 'ERROR'),
t.definition,
decode(bitand(t.property, 2), 2, 'CALL',
                                 'PL/SQL     '),
t.action#
from sys.obj$ trigobj, sys.trigger$ t, sys.user$ trigusr
where (trigobj.obj#   = t.obj# and
       trigobj.owner# = trigusr.user# and
       bitand(t.property, 63)    >= 8 and bitand(t.property, 63) < 16)
union all
select trigusr.name, trigobj.name,
decode(t.type#, 0, 'BEFORE EVENT',
                2, 'AFTER EVENT',
                   'UNDEFINED'),
decode(bitand(t.sys_evts, 1), 1, 'STARTUP ') ||
decode(bitand(t.sys_evts, 2), 2,
       decode(sign(bitand(t.sys_evts, 1)), 1, 'OR SHUTDOWN ',
                                               'SHUTDOWN ')) ||
decode(bitand(t.sys_evts, 4), 4,
       decode(sign(bitand(t.sys_evts, 3)), 1, 'OR ERROR ',
                                              'ERROR ')) ||
decode(bitand(t.sys_evts, 8), 8,
       decode(sign(bitand(t.sys_evts, 7)), 1, 'OR LOGON ',
                                              'LOGON ')) ||
decode(bitand(t.sys_evts, 16), 16,
       decode(sign(bitand(t.sys_evts, 15)), 1, 'OR LOGOFF ',
                                               'LOGOFF ')) ||
decode(bitand(t.sys_evts, 262176), 32,
       decode(sign(bitand(t.sys_evts, 31)), 1, 'OR CREATE ',
                                               'CREATE ')) ||
decode(bitand(t.sys_evts, 262208), 64,
       decode(sign(bitand(t.sys_evts, 63)), 1, 'OR ALTER ',
                                               'ALTER ')) ||
decode(bitand(t.sys_evts, 262272), 128,
       decode(sign(bitand(t.sys_evts, 127)), 1, 'OR DROP ',
                                                'DROP ')) ||
decode (bitand(t.sys_evts, 262400), 256,
        decode(sign(bitand(t.sys_evts, 255)), 1, 'OR ANALYZE ',
                                                 'ANALYZE ')) ||
decode (bitand(t.sys_evts, 262656), 512,
        decode(sign(bitand(t.sys_evts, 511)), 1, 'OR COMMENT ',
                                                 'COMMENT ')) ||
decode (bitand(t.sys_evts, 263168), 1024,
        decode(sign(bitand(t.sys_evts, 1023)), 1, 'OR GRANT ',
                                                  'GRANT ')) ||
decode (bitand(t.sys_evts, 264192), 2048,
        decode(sign(bitand(t.sys_evts, 2047)), 1, 'OR REVOKE ',
                                                  'REVOKE ')) ||
decode (bitand(t.sys_evts, 266240), 4096,
        decode(sign(bitand(t.sys_evts, 4095)), 1, 'OR TRUNCATE ',
                                                  'TRUNCATE ')) ||
decode (bitand(t.sys_evts, 270336), 8192,
        decode(sign(bitand(t.sys_evts, 8191)), 1, 'OR RENAME ',
                                                  'RENAME ')) ||
decode (bitand(t.sys_evts, 278528), 16384,
        decode(sign(bitand(t.sys_evts, 16383)), 1, 'OR ASSOCIATE STATISTICS ',
                                                   'ASSOCIATE STATISTICS ')) ||
decode (bitand(t.sys_evts, 294912), 32768,
        decode(sign(bitand(t.sys_evts, 32767)), 1, 'OR AUDIT ',
                                                   'AUDIT ')) ||
decode (bitand(t.sys_evts, 327680), 65536,
        decode(sign(bitand(t.sys_evts, 65535)), 1,
               'OR DISASSOCIATE STATISTICS ', 'DISASSOCIATE STATISTICS ')) ||
decode (bitand(t.sys_evts, 393216), 131072,
        decode(sign(bitand(t.sys_evts, 131071)), 1, 'OR NOAUDIT ',
                                                    'NOAUDIT ')) ||
decode (bitand(t.sys_evts, 262144), 262144,
        decode(sign(bitand(t.sys_evts, 31)), 1, 'OR DDL ',
                                                   'DDL ')) ||
decode (bitand(t.sys_evts, 8388608), 8388608,
        decode(sign(bitand(t.sys_evts, 8388607)), 1, 'OR SUSPEND ',
                                                     'SUSPEND ')),
tabusr.name,
'SCHEMA',
NULL,
NULL,
'REFERENCING NEW AS '||t.refnewname||' OLD AS '||t.refoldname,
t.whenclause,decode(t.enabled, 0, 'DISABLED', 1, 'ENABLED', 'ERROR'),
t.definition,
decode(bitand(t.property, 2), 2, 'CALL',
                                 'PL/SQL     '),
t.action#
from sys.obj$ trigobj, sys.trigger$ t, sys.user$ tabusr, sys.user$ trigusr
where (trigobj.obj#   = t.obj# and
       trigobj.owner# = trigusr.user# and
       bitand(t.property, 63) >= 16 and bitand(t.property, 63) < 32 and
       tabusr.user# = t.baseobject)
union all
select trigusr.name, trigobj.name,
decode(t.type#, 0, 'BEFORE STATEMENT',
               1, 'BEFORE EACH ROW',
               2, 'AFTER STATEMENT',
               3, 'AFTER EACH ROW',
               4, 'INSTEAD OF',
               'UNDEFINED'),
decode(t.insert$*100 + t.update$*10 + t.delete$,
                 100, 'INSERT',
                 010, 'UPDATE',
                 001, 'DELETE',
                 110, 'INSERT OR UPDATE',
                 101, 'INSERT OR DELETE',
                 011, 'UPDATE OR DELETE',
                 111, 'INSERT OR UPDATE OR DELETE', 'ERROR'),
tabusr.name,
decode(bitand(t.property, 1), 1, 'VIEW',
                              0, 'TABLE',
                                 'UNDEFINED'),
tabobj.name, ntcol.name,
'REFERENCING NEW AS '||t.refnewname||' OLD AS '||t.refoldname ||
  ' PARENT AS ' || t.refprtname,
t.whenclause,decode(t.enabled, 0, 'DISABLED', 1, 'ENABLED', 'ERROR'),
t.definition,
decode(bitand(t.property, 2), 2, 'CALL',
                                 'PL/SQL     '),
t.action#
from sys.obj$ trigobj, sys.obj$ tabobj, sys.trigger$ t,
     sys.user$ tabusr, sys.user$ trigusr, sys.viewtrcol$ ntcol
where (trigobj.obj#   = t.obj# and
       tabobj.obj#    = t.baseobject and
       tabobj.owner#  = tabusr.user# and
       trigobj.owner# = trigusr.user# and
       t.nttrigcol    = ntcol.intcol# and
       t.nttrigatt    = ntcol.attribute# and
       t.baseobject   = ntcol.obj# and
       bitand(t.property, 63)     >= 32);

CREATE OR REPLACE FORCE VIEW "DBA_TRIGGER_COLS"("TRIGGER_OWNER",
select /*+ ORDERED NOCOST */ u.name, o.name, u2.name, o2.name,c.name,
   max(decode(tc.type#,0,'YES','NO')) COLUMN_LIST,
   decode(sum(decode(tc.type#, 5,  1, -- one occurrence of new in
                              6,  2, -- one occurrence of old in
                              9,  4, -- one occurrence of new out
                             10,  8, -- one occurrence of old out (impossible)
                             13,  5, -- one occurrence of new in out
                             14, 10, -- one occurrence of old in out (imp.)
                             20, 16, -- one occurrence of parent in
                             24, 32, -- one occurrence of parent out (imp)
                             28, 64, -- one occurrence of parent in out (imp)
                              null)
                ), -- result in the following combinations across occurrences
           1, 'NEW IN',
           2, 'OLD IN',
           3, 'NEW IN OLD IN',
           4, 'NEW OUT',
           5, 'NEW IN OUT',
           6, 'NEW OUT OLD IN',
           7, 'NEW IN OUT OLD IN',
          16, 'PARENT IN',
          'NONE')
from sys.trigger$ t, sys.obj$ o, sys.user$ u, sys.user$ u2,
     sys.col$ c, sys.obj$ o2, sys.triggercol$ tc
where t.obj# = tc.obj#                -- find corresponding trigger definition
  and o.obj# = t.obj#                --    and corresponding trigger name
  and c.obj# = t.baseobject         -- and corresponding row in COL$ of
  and c.intcol# = tc.intcol#        --    the referenced column
  and bitand(c.property,32768) != 32768   -- not unused columns
  and o2.obj# = t.baseobject        -- and name of the table containing the trigger
  and u2.user# = o2.owner#        -- and name of the user who owns the table
  and u.user# = o.owner#        -- and name of user who owns the trigger
  and bitand(c.property,1) <> 1  -- and the col is not an ADT column
  and (bitand(t.property,32) <> 32 -- and it is not a nested table col
       or
      bitand(tc.type#,16) = 16) -- or it is a PARENT type column
group by u.name, o.name, u2.name, o2.name, c.name
union all
select /*+ ORDERED NOCOST */ u.name, o.name, u2.name, o2.name,ac.name,
   max(decode(tc.type#,0,'YES','NO')) COLUMN_LIST,
   decode(sum(decode(tc.type#, 5,  1, -- one occurrence of new in
                              6,  2, -- one occurrence of old in
                              9,  4, -- one occurrence of new out
                             10,  8, -- one occurrence of old out (impossible)
                             13,  5, -- one occurrence of new in out
                             14, 10, -- one occurrence of old in out (imp.)
                             20, 16, -- one occurrence of parent in
                             24, 32, -- one occurrence of parent out (imp)
                             28, 64, -- one occurrence of parent in out (imp)
                              null)
                ), -- result in the following combinations across occurrences
           1, 'NEW IN',
           2, 'OLD IN',
           3, 'NEW IN OLD IN',
           4, 'NEW OUT',
           5, 'NEW IN OUT',
           6, 'NEW OUT OLD IN',
           7, 'NEW IN OUT OLD IN',
          16, 'PARENT IN',
          'NONE')
from sys.trigger$ t, sys.obj$ o, sys.user$ u, sys.user$ u2,
     sys.col$ c, sys.obj$ o2, sys.triggercol$ tc, sys.attrcol$ ac
where t.obj# = tc.obj#                -- find corresponding trigger definition
  and o.obj# = t.obj#                --    and corresponding trigger name
  and c.obj# = t.baseobject         -- and corresponding row in COL$ of
  and c.intcol# = tc.intcol#        --    the referenced column
  and bitand(c.property,32768) != 32768   -- not unused columns
  and o2.obj# = t.baseobject        -- and name of the table containing the trigger
  and u2.user# = o2.owner#        -- and name of the user who owns the table
  and u.user# = o.owner#        -- and name of user who owns the trigger
  and bitand(c.property,1) = 1  -- and it is an ADT attribute
  and ac.intcol# = c.intcol#    -- and the attribute name
  and (bitand(t.property,32) <> 32 -- and it is not a nested table col
       or
      bitand(tc.type#,16) = 16) -- or it is a PARENT type column
group by u.name, o.name, u2.name, o2.name, ac.name
union all
select /*+ ORDERED NOCOST */ u.name, o.name, u2.name, o2.name,attr.name,
   max(decode(tc.type#,0,'YES','NO')) COLUMN_LIST,
   decode(sum(decode(tc.type#, 5,  1, -- one occurrence of new in
                              6,  2, -- one occurrence of old in
                              9,  4, -- one occurrence of new out
                             10,  8, -- one occurrence of old out (impossible)
                             13,  5, -- one occurrence of new in out
                             14, 10, -- one occurrence of old in out (imp.)
                              null)
                ), -- result in the following combinations across occurrences
           1, 'NEW IN',
           2, 'OLD IN',
           3, 'NEW IN OLD IN',
           4, 'NEW OUT',
           5, 'NEW IN OUT',
           6, 'NEW OUT OLD IN',
           7, 'NEW IN OUT OLD IN',
          'NONE')
from sys.trigger$ t, sys.obj$ o, sys.user$ u, sys.user$ u2,
     sys.obj$ o2, sys.triggercol$ tc,
     sys.collection$ coll, sys.coltype$ ctyp, sys.attribute$ attr
where t.obj# = tc.obj#                -- find corresponding trigger definition
  and o.obj# = t.obj#                --    and corresponding trigger name
  and o2.obj# = t.baseobject        -- and name of the table containing the trigger
  and u2.user# = o2.owner#        -- and name of the user who owns the table
  and u.user# = o.owner#        -- and name of user who owns the trigger
  and bitand(t.property,32) = 32 -- and it is not a nested table col
  and bitand(tc.type#,16) <> 16  -- and it is not a PARENT type column
  and ctyp.obj# = t.baseobject   -- find corresponding column type definition
  and ctyp.intcol# = t.nttrigcol -- and get the column type for the nested table
  and ctyp.toid = coll.toid      -- get the collection toid
  and ctyp.version# = coll.version# -- get the collection version
  and attr.attribute# = tc.intcol#  -- get the attribute number
  and attr.toid  = coll.elem_toid  -- get the attribute toid
  and attr.version# = coll.version#  -- get the attribute version
group by u.name, o.name, u2.name, o2.name, attr.name
union all
select /*+ ORDERED NOCOST */ u.name, o.name, u2.name, o2.name,'COLUMN_VALUE',
   max(decode(tc.type#,0,'YES','NO')) COLUMN_LIST,
   decode(sum(decode(tc.type#, 5,  1, -- one occurrence of new in
                              6,  2, -- one occurrence of old in
                              9,  4, -- one occurrence of new out
                             10,  8, -- one occurrence of old out (impossible)
                             13,  5, -- one occurrence of new in out
                             14, 10, -- one occurrence of old in out (imp.)
                              null)
                ), -- result in the following combinations across occurrences
           1, 'NEW IN',
           2, 'OLD IN',
           3, 'NEW IN OLD IN',
           4, 'NEW OUT',
           5, 'NEW IN OUT',
           6, 'NEW OUT OLD IN',
           7, 'NEW IN OUT OLD IN',
          'NONE')
from sys.trigger$ t, sys.obj$ o, sys.user$ u, sys.user$ u2,
     sys.obj$ o2, sys.triggercol$ tc
where t.obj# = tc.obj#                -- find corresponding trigger definition
  and o.obj# = t.obj#                --    and corresponding trigger name
  and o2.obj# = t.baseobject        -- and name of the table containing the trigger
  and u2.user# = o2.owner#        -- and name of the user who owns the table
  and u.user# = o.owner#        -- and name of user who owns the trigger
  and bitand(t.property,32) = 32 -- and it is not a nested table col
  and bitand(tc.type#,16) <> 16  -- and it is not a PARENT type column
  and tc.intcol# = 0
group by u.name, o.name, u2.name, o2.name,'COLUMN_VALUE';

CREATE OR REPLACE FORCE VIEW "DBA_TSM_HISTORY"("SOURCE_SID",
SELECT
  source_sid,
  source_serial#,
  decode(state,
          0, 'NONE',
          1, 'SELECTED',
          2, 'COMMITED SELECT',
          3, 'READY FOR PREPARE',
          4, 'PREPARED',
          5, 'READY FOR SWITCH',
          6, 'SWITCHED',
          7, 'FAILED',
          'UNKNOWN'),
  cost,
  source,
  destination,
  connect_string,
  decode(failure_reason,
          0, 'None',
          1, 'Instance shutdown before migration',
          2, 'End of session before migration',
          3, 'Invalid OCI operation',
          4, 'OCI Server Attach',
          5, 'OCI logon',
          6, 'OCI logoff',
          7, 'OCI disconnect',
          8, 'Invalid client state',
          9, 'End of migration',
         10, 'Session migration',
         11, 'Prepare from client failed',
         12, 'Session became non-migratable',
          NULL, '',
          'Unknown'),
  destination_sid,
  destination_serial#,
  start_time,
  end_time
FROM tsm_hist$;

CREATE OR REPLACE FORCE VIEW "DBA_TS_QUOTAS"("TABLESPACE_NAME",
select ts.name, u.name,
       q.blocks * ts.blocksize,
       decode(q.maxblocks, -1, -1, q.maxblocks * ts.blocksize),
       q.blocks, q.maxblocks
from sys.tsq$ q, sys.ts$ ts, sys.user$ u
where q.ts# = ts.ts#
  and q.user# = u.user#
  and q.maxblocks != 0;

CREATE OR REPLACE FORCE VIEW "DBA_TUNE_MVIEW"("OWNER",
SELECT t.owner_name, t.name, a.id,
         decode(a.command, 3, 'IMPLEMENTATION', 4, 'IMPLEMENTATION',
                           18, 'UNDO', 23, 'IMPLEMENTATION',
                           24, 'UNDO', 25, 'IMPLEMENTATION',
                           26, 'UNDO', 27, 'IMPLEMENTATION',
                           'UNKNOWN'),
         decode(a.command,
                3,  'CREATE MATERIALIZED VIEW ' || a.attr1 ||
                    ' ' || a.attr6 || ' ' || a.attr3 || ' ' ||
                    a.attr4 || ' AS ' || a.attr5,
                4,  'CREATE MATERIALIZED VIEW LOG ON ' || a.attr1 ||
                    ' WITH ' || a.attr3 || ' ' || a.attr5 || ' ' ||
                    a.attr4,
                18, 'DROP MATERIALIZED VIEW ' || a.attr1 || ' ' || a.attr5,
                23, 'CREATE MATERIALIZED VIEW ' || a.attr1 ||
                    ' ' || a.attr6 || ' ' || a.attr3 || ' ' ||
                    a.attr4 || ' AS ' || a.attr5,
                24, 'DROP MATERIALIZED VIEW ' || a.attr1 || ' ' || a.attr5,
                25, 'DBMS_ADVANCED_REWRITE.BUILD_SAFE_REWRITE_EQUIVALENCE (''' ||
                    a.attr1 || ''',''' || a.attr5 || ''',''' || a.attr6 ||
                    ''',' || a.attr2 || ')',
                26, 'DBMS_ADVANCED_REWRITE.DROP_REWRITE_EQUIVALENCE(''' ||
                    a.attr1 || ''')' || a.attr5,
                27, 'ALTER MATERIALIZED VIEW LOG FORCE ON ' || a.attr1 ||
                    ' ADD ' || a.attr3 || ' ' || a.attr5 || ' ' ||
                    a.attr4,
                    a.attr5)
    FROM sys.wri$_adv_actions a, sys.wri$_adv_tasks t
    WHERE a.task_id = t.id;

CREATE OR REPLACE FORCE VIEW "DBA_TYPES"("OWNER",
select decode(bitand(t.properties, 64), 64, null, u.name), o.name, t.toid,
       decode(t.typecode, 108, 'OBJECT',
                          122, 'COLLECTION',
                          o.name),
       t.attributes, t.methods,
       decode(bitand(t.properties, 16), 16, 'YES', 0, 'NO'),
       decode(bitand(t.properties, 256), 256, 'YES', 0, 'NO'),
       decode(bitand(t.properties, 8), 8, 'NO', 'YES'),
       decode(bitand(t.properties, 65536), 65536, 'NO', 'YES'),
       su.name, so.name, t.local_attrs, t.local_methods, t.typeid
from sys.user$ u, sys.type$ t, sys.obj$ o, sys.obj$ so, sys.user$ su
where o.owner# = u.user#
  and o.oid$ = t.tvoid
  and o.subname IS NULL -- only the latest version
  and o.type# <> 10 -- must not be invalid
  and bitand(t.properties, 2048) = 0 -- not system-generated
  and t.supertoid = so.oid$ (+) and so.owner# = su.user# (+);

CREATE OR REPLACE FORCE VIEW "DBA_TYPE_ATTRS"("OWNER",
select decode(bitand(t.properties, 64), 64, null, u.name), o.name, a.name,
       decode(bitand(a.properties, 32768), 32768, 'REF',
              decode(bitand(a.properties, 16384), 16384, 'POINTER')),
       nvl2(a.synobj#, (select u.name from user$ u, obj$ o
            where o.owner#=u.user# and o.obj#=a.synobj#),
            decode(bitand(at.properties, 64), 64, null, au.name)),
       nvl2(a.synobj#, (select o.name from obj$ o where o.obj#=a.synobj#),
            decode(at.typecode,
                   52, decode(a.charsetform, 2, 'NVARCHAR2', ao.name),
                   53, decode(a.charsetform, 2, 'NCHAR', ao.name),
                   54, decode(a.charsetform, 2, 'NCHAR VARYING', ao.name),
                   61, decode(a.charsetform, 2, 'NCLOB', ao.name),
                   ao.name)),
       a.length, a.precision#, a.scale,
       decode(a.charsetform, 1, 'CHAR_CS',
                             2, 'NCHAR_CS',
                             3, NLS_CHARSET_NAME(a.charsetid),
                             4, 'ARG:'||a.charsetid),
       a.attribute#, decode(bitand(nvl(a.xflags,0), 1), 1, 'YES', 'NO')
from sys.user$ u, sys.obj$ o, sys.type$ t, sys.attribute$ a,
     sys.obj$ ao, sys.user$ au, sys.type$ at
where o.owner# = u.user#
  and o.oid$ = t.toid
  and o.subname IS NULL -- get the latest version only
  and o.type# <> 10 -- must not be invalid
  and bitand(t.properties, 2048) = 0 -- not system-generated
  and t.toid = a.toid
  and t.version# = a.version#
  and a.attr_toid = ao.oid$
  and ao.owner# = au.user#
  and a.attr_toid = at.tvoid
  and a.attr_version# = at.version#;

CREATE OR REPLACE FORCE VIEW "DBA_TYPE_METHODS"("OWNER",
select u.name, o.name, m.name, m.method#,
       decode(bitand(m.properties, 512), 512, 'MAP',
              decode(bitand(m.properties, 2048), 2048, 'ORDER', 'PUBLIC')),
       m.parameters#, m.results,
       decode(bitand(m.properties, 8), 8, 'NO', 'YES'),
       decode(bitand(m.properties, 65536), 65536, 'NO', 'YES'),
       decode(bitand(m.properties, 131072), 131072, 'YES', 'NO'),
       decode(bitand(nvl(m.xflags,0), 1), 1, 'YES', 'NO')
from sys.user$ u, sys.obj$ o, sys.method$ m
where o.owner# = u.user#
  and o.type# <> 10 -- must not be invalid
  and o.oid$ = m.toid
  and o.subname IS NULL -- get the latest version only;

CREATE OR REPLACE FORCE VIEW "DBA_TYPE_VERSIONS"("OWNER",
select u.name, o.name, t.version#,
       decode(t.typecode, 108, 'OBJECT',
                          122, 'COLLECTION',
                          o.name),
       decode(o.status, 0, 'N/A', 1, 'VALID', 'INVALID'),
       s.line, s.source,
       t.hashcode
from sys.obj$ o, sys.source$ s, sys.type$ t, user$ u
  where o.obj# = s.obj# and o.oid$ = t.tvoid and o.type# = 13
  and o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "DBA_UNDO_EXTENTS"("OWNER",
select /*+ ordered use_nl(e) use_nl(f) */
       'SYS', u.name, t.name,
       e.ktfbueextno, f.file#, e.ktfbuebno,
       e.ktfbueblks * t.BLOCKSIZE, e.ktfbueblks, e.ktfbuefno,
       nullif(e.ktfbuectm, e.ktfbuectm),
       nullif(e.ktfbuestt, e.ktfbuestt),
       decode(e.ktfbuesta, 1, 'ACTIVE', 2, 'EXPIRED', 3, 'UNEXPIRED',
              'UNDEFINED')
from undo$ u, ts$ t, sys.x$ktfbue e, sys.file$ f
where
e.ktfbuesegfno = u.file#
and e.ktfbuesegbno = u.block#
and e.ktfbuesegtsn = u.ts#
and u.spare1 = 1
and t.ts# = u.ts#
and e.ktfbuefno = f.relfile#
and u.ts# = f.ts#;

CREATE OR REPLACE FORCE VIEW "DBA_UNUSED_COL_TABS"("OWNER",
select u.name, o.name, count(*)
from sys.user$ u, sys.obj$ o, sys.col$ c
where c.obj# = o.obj#
      and bitand(c.property,32768) = 32768          -- is unused column
      and bitand(c.property, 1) != 1                -- not ADT attribute col
      and bitand(c.property, 1024) != 1024          -- not NTAB's setid col
      and u.user# = o.owner#
      group by u.name, o.name;

CREATE OR REPLACE FORCE VIEW "DBA_UPDATABLE_COLUMNS"("OWNER",
select u.name, o.name, c.name,
       decode(bitand(c.fixedstorage,2),
              2, decode(bitand(v.flags,8192), 8192, 'YES', 'NO'),
              decode(bitand(c.property,4096),4096,'NO','YES')),
       decode(bitand(c.fixedstorage,2),
              2, decode(bitand(v.flags,4096), 4096, 'YES', 'NO'),
              decode(bitand(c.property,2048),2048,'NO','YES')),
       decode(bitand(c.fixedstorage,2),
              2, decode(bitand(v.flags,16384), 16384, 'YES', 'NO'),
              decode(bitand(c.property,8192),8192,'NO','YES'))
from sys.obj$ o, sys.user$ u, sys.col$ c, sys.view$ v
where u.user# = o.owner#
  and c.obj#  = o.obj#
  and c.obj#  = v.obj#(+)
  and bitand(c.property, 32) = 0 /* not hidden column */;

CREATE OR REPLACE FORCE VIEW "DBA_USERS"("USERNAME",
select u.name, u.user#, u.password,
       m.status,
       decode(u.astatus, 4, u.ltime,
                         5, u.ltime,
                         6, u.ltime,
                         8, u.ltime,
                         9, u.ltime,
                         10, u.ltime, to_date(NULL)),
       decode(u.astatus,
              1, u.exptime,
              2, u.exptime,
              5, u.exptime,
              6, u.exptime,
              9, u.exptime,
              10, u.exptime,
              decode(u.ptime, '', to_date(NULL),
                decode(pr.limit#, 2147483647, to_date(NULL),
                 decode(pr.limit#, 0,
                   decode(dp.limit#, 2147483647, to_date(NULL), u.ptime +
                     dp.limit#/86400),
                   u.ptime + pr.limit#/86400)))),
       dts.name, tts.name, u.ctime, p.name,
       nvl(cgm.consumer_group, 'DEFAULT_CONSUMER_GROUP'),
       u.ext_username
       from sys.user$ u left outer join sys.resource_group_mapping$ cgm
            on (cgm.attribute = 'ORACLE_USER' and cgm.status = 'ACTIVE' and
                cgm.value = u.name),
            sys.ts$ dts, sys.ts$ tts, sys.profname$ p,
            sys.user_astatus_map m, sys.profile$ pr, sys.profile$ dp
       where u.datats# = dts.ts#
       and u.resource$ = p.profile#
       and u.tempts# = tts.ts#
       and u.astatus = m.status#
       and u.type# = 1
       and u.resource$ = pr.profile#
       and dp.profile# = 0
       and dp.type#=1
       and dp.resource#=1
       and pr.type# = 1
       and pr.resource# = 1;

CREATE OR REPLACE FORCE VIEW "DBA_USTATS"("OBJECT_OWNER",
select u.name, o.name, o.subname,
         decode (bitand(s.property, 3), 1, 'INDEX', 2, 'COLUMN'),
         decode (bitand(s.property, 12), 8, 'DIRECT', 4, 'IMPLICIT'),
         c.name, u1.name, o1.name, s.statistics
  from   sys.user$ u, sys.obj$ o, sys.col$ c, sys.ustats$ s,
         sys.user$ u1, sys.obj$ o1
  where  bitand(s.property, 3)=2 and s.obj#=o.obj# and o.owner#=u.user#
  and    s.intcol#=c.intcol# and s.statstype#=o1.obj#
  and    o1.owner#=u1.user# and c.obj#=s.obj#
union all    -- partition case
  select u.name, o.name, o.subname,
         decode (bitand(s.property, 3), 1, 'INDEX', 2, 'COLUMN'),
         decode (bitand(s.property, 12), 8, 'DIRECT', 4, 'IMPLICIT'),
         c.name, u1.name, o1.name, s.statistics
  from   sys.user$ u, sys.user$ u1, sys.obj$ o, sys.obj$ o1, sys.col$ c,
         sys.ustats$ s, sys.tabpart$ t, sys.obj$ o2
  where  bitand(s.property, 3)=2 and s.obj# = o.obj#
  and    s.obj# = t.obj# and t.bo# = o2.obj# and o2.owner# = u.user#
  and    s.intcol# = c.intcol# and s.statstype#=o1.obj# and o1.owner#=u1.user#
  and    t.bo#=c.obj#
union all
  select u.name, o.name, o.subname,
         decode (bitand(s.property, 3), 1, 'INDEX', 2, 'COLUMN'),
         decode (bitand(s.property, 12), 8, 'DIRECT', 4, 'IMPLICIT'),
          NULL, u1.name, o1.name, s.statistics
  from   sys.user$ u, sys.obj$ o, sys.ustats$ s,
         sys.user$ u1, sys.obj$ o1
  where  bitand(s.property, 3)=1 and s.obj#=o.obj# and o.owner#=u.user#
  and    s.statstype#=o1.obj# and o1.owner#=u1.user# and o.type#=1
union all -- index partition
  select u.name, o.name, o.subname,
         decode (bitand(s.property, 3), 1, 'INDEX', 2, 'COLUMN'),
         decode (bitand(s.property, 12), 8, 'DIRECT', 4, 'IMPLICIT'),
         NULL, u1.name, o1.name, s.statistics
  from   sys.user$ u, sys.user$ u1, sys.obj$ o, sys.obj$ o1,
         sys.ustats$ s, sys.indpart$ i, sys.obj$ o2
  where  bitand(s.property, 3)=1 and s.obj# = o.obj#
  and    s.obj# = i.obj# and i.bo# = o2.obj# and o2.owner# = u.user#
  and    s.statstype#=o1.obj# and o1.owner#=u1.user#;

CREATE OR REPLACE FORCE VIEW "DBA_VARRAYS"("OWNER",
select u.name, op.name, ac.name,
       nvl2(ct.synobj#, (select u.name from user$ u, obj$ o
            where o.owner#=u.user# and o.obj#=ct.synobj#), ut.name),
       nvl2(ct.synobj#, (select o.name from obj$ o
            where o.obj#=ct.synobj#), ot.name),
       NULL,
       lpad(decode(bitand(ct.flags, 64), 64, 'USER_SPECIFIED', 'DEFAULT'), 30),
       lpad(decode(bitand(ct.flags, 32), 32, 'LOCATOR', 'VALUE'), 20),
       lpad((case when bitand(ct.flags, 5120)=0 and bitand(t.properties, 8)= 8
       then 'Y' else 'N' end), 25)
from sys.obj$ op, sys.obj$ ot, sys.col$ c, sys.coltype$ ct, sys.user$ u,
  sys.user$ ut, sys.attrcol$ ac, sys.type$ t, sys.collection$ cl
where op.owner# = u.user#
  and c.obj# = op.obj#
  and c.obj# = ac.obj#
  and c.intcol# = ac.intcol#
  and op.obj# = ct.obj#
  and ct.toid = ot.oid$
  and ct.intcol#=c.intcol#
  and ot.owner# = ut.user#
  and ct.toid=cl.toid
  and cl.elem_toid=t.tvoid
  and bitand(ct.flags,8)=8
  and bitand(c.property, 128) != 128
  and bitand(c.property,32768) != 32768           /* not unused column */
union all
select u.name, op.name, ac.name,
       nvl2(ct.synobj#, (select u.name from user$ u, obj$ o
            where o.owner#=u.user# and o.obj#=ct.synobj#), ut.name),
       nvl2(ct.synobj#, (select o.name from obj$ o
            where o.obj#=ct.synobj#), ot.name),
       o.name,
       lpad(decode(bitand(ct.flags, 64), 64, 'USER_SPECIFIED', 'DEFAULT'), 30),
       lpad(decode(bitand(ct.flags, 32), 32, 'LOCATOR', 'VALUE'), 20),
       lpad((case when bitand(ct.flags, 5120)=0 and bitand(t.properties, 8)= 8
       then 'Y' else 'N' end), 25)
from sys.lob$ l, sys.obj$ o, sys.obj$ op, sys.obj$ ot, sys.col$ c,
  sys.coltype$ ct, sys.user$ u, sys.user$ ut, sys.attrcol$ ac, sys.type$ t,
  sys.collection$ cl
where o.owner# = u.user#
  and l.obj# = op.obj#
  and l.lobj# = o.obj#
  and c.obj# = op.obj#
  and l.intcol# = c.intcol#
  and c.obj# = ac.obj#
  and c.intcol# = ac.intcol#
  and op.obj# = ct.obj#
  and ct.toid = ot.oid$
  and ct.intcol#=l.intcol#
  and ot.owner# = ut.user#
  and ct.toid=cl.toid
  and cl.elem_toid=t.tvoid
  and bitand(ct.flags,8)=8
  and bitand(c.property, 128) = 128
  and bitand(c.property,32768) != 32768           /* not unused column */
union all
select u.name, op.name, c.name,
       nvl2(ct.synobj#, (select u.name from user$ u, obj$ o
            where o.owner#=u.user# and o.obj#=ct.synobj#), ut.name),
       nvl2(ct.synobj#, (select o.name from obj$ o
            where o.obj#=ct.synobj#), ot.name),
       NULL,
       lpad(decode(bitand(ct.flags, 64), 64, 'USER_SPECIFIED', 'DEFAULT'), 30),
       lpad(decode(bitand(ct.flags, 32), 32, 'LOCATOR', 'VALUE'), 20),
       lpad((case when bitand(ct.flags, 5120)=0 and bitand(t.properties, 8)= 8
       then 'Y' else 'N' end), 25)
from sys.obj$ op, sys.obj$ ot, sys.col$ c, sys.coltype$ ct, sys.user$ u,
  sys.user$ ut, sys.type$ t, sys.collection$ cl
where op.owner# = u.user#
  and c.obj# = op.obj#
  and bitand(c.property,1)=0
  and op.obj# = ct.obj#
  and ct.toid = ot.oid$
  and ct.intcol#=c.intcol#
  and ot.owner# = ut.user#
  and ct.toid=cl.toid
  and cl.elem_toid=t.tvoid
  and bitand(ct.flags,8)=8
  and bitand(c.property, 128) != 128
  and bitand(c.property,32768) != 32768           /* not unused column */
union all
select u.name, op.name, c.name,
       nvl2(ct.synobj#, (select u.name from user$ u, obj$ o
            where o.owner#=u.user# and o.obj#=ct.synobj#), ut.name),
       nvl2(ct.synobj#, (select o.name from obj$ o
            where o.obj#=ct.synobj#), ot.name),
       o.name,
       lpad(decode(bitand(ct.flags, 64), 64, 'USER_SPECIFIED', 'DEFAULT'), 30),
       lpad(decode(bitand(ct.flags, 32), 32, 'LOCATOR', 'VALUE'), 20),
       lpad((case when bitand(ct.flags, 5120)=0 and bitand(t.properties, 8)= 8
       then 'Y' else 'N' end), 25)
from sys.lob$ l, sys.obj$ o, sys.obj$ op, sys.obj$ ot, sys.col$ c,
  sys.coltype$ ct, sys.user$ u, sys.user$ ut, sys.type$ t, sys.collection$ cl
where o.owner# = u.user#
  and l.obj# = op.obj#
  and l.lobj# = o.obj#
  and c.obj# = op.obj#
  and l.intcol# = c.intcol#
  and bitand(c.property,1)=0
  and op.obj# = ct.obj#
  and ct.toid = ot.oid$
  and ct.intcol#=l.intcol#
  and ot.owner# = ut.user#
  and ct.toid=cl.toid
  and cl.elem_toid=t.tvoid
  and bitand(ct.flags,8)=8
  and bitand(c.property, 128) = 128
  and bitand(c.property,32768) != 32768           /* not unused column */;

CREATE OR REPLACE FORCE VIEW "DBA_VIEWS"("OWNER",
select u.name, o.name, v.textlength, v.text, t.typetextlength, t.typetext,
       t.oidtextlength, t.oidtext, t.typeowner, t.typename,
       decode(bitand(v.property, 134217728), 134217728,
              (select sv.name from superobj$ h, obj$ sv
              where h.subobj# = o.obj# and h.superobj# = sv.obj#), null)
from sys.obj$ o, sys.view$ v, sys.user$ u, sys.typed_view$ t
where o.obj# = v.obj#
  and o.obj# = t.obj#(+)
  and o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "DBA_WAITERS"("WAITING_SESSION",
select /*+ordered */ w.sid
      ,s.ksusenum
      ,decode(r.ksqrsidt,
                'MR', 'Media Recovery',
                'RT', 'Redo Thread',
                'UN', 'User Name',
                'TX', 'Transaction',
                'TM', 'DML',
                'UL', 'PL/SQL User Lock',
                'DX', 'Distributed Xaction',
                'CF', 'Control File',
                'IS', 'Instance State',
                'FS', 'File Set',
                'IR', 'Instance Recovery',
                'ST', 'Disk Space Transaction',
                'TS', 'Temp Segment',
                'IV', 'Library Cache Invalidation',
                'LS', 'Log Start or Switch',
                'RW', 'Row Wait',
                'SQ', 'Sequence Number',
                'TE', 'Extend Table',
                'TT', 'Temp Table',
                r.ksqrsidt)
      ,decode(l.lmode,
                0, 'None',           /* Mon Lock equivalent */
                1, 'Null',           /* N */
                2, 'Row-S (SS)',     /* L */
                3, 'Row-X (SX)',     /* R */
                4, 'Share',          /* S */
                5, 'S/Row-X (SSX)',  /* C */
                6, 'Exclusive',      /* X */
                l.lmode)
      ,decode(bitand(w.p1,65535),
                0, 'None',           /* Mon Lock equivalent */
                1, 'Null',           /* N */
                2, 'Row-S (SS)',     /* L */
                3, 'Row-X (SX)',     /* R */
                4, 'Share',          /* S */
                5, 'S/Row-X (SSX)',  /* C */
                6, 'Exclusive',      /* X */
                to_char(bitand(w.p1,65535)))
      ,r.ksqrsid1, r.ksqrsid2
  from v$session_wait w, x$ksqrs r, v$_lock l, x$ksuse s
 where w.wait_Time = 0
   and w.event like 'enq:%'
   and r.ksqrsid1 = w.p2
   and r.ksqrsid2 = w.p3
   and r.ksqrsidt = chr(bitand(p1,-16777216)/16777215)||
                   chr(bitand(p1,16711680)/65535)
   and l.block = 1
   and l.saddr = s.addr
   and l.raddr = r.addr
   and s.inst_id = userenv('Instance');

CREATE OR REPLACE FORCE VIEW "DBA_WARNING_SETTINGS"("OWNER",
SELECT u.name, o.name, o.obj#,
         DECODE(o.type#,
                 7, 'PROCEDURE',
                 8, 'FUNCTION',
                 9, 'PACKAGE',
                11, 'PACKAGE BODY',
                12, 'TRIGGER',
                13, 'TYPE',
                14, 'TYPE BODY',
                    'UNDEFINED'),
         DECODE(w.warning,
                -1, 'INFORMATIONAL',
                -2, 'PERFORMANCE',
                -3, 'SEVERE',
                -4, 'ALL',
                w.warning),
         DECODE(w.setting,
                0, 'DISABLE',
                1, 'ENABLE',
                2, 'ERROR',
                   'INVALID')
    FROM sys.obj$ o, sys.user$ u,
    TABLE(dbms_warning_internal.show_warning_settings(o.obj#)) w
    WHERE o.owner# = u.user#
    AND o.linkname is null
    AND o.type# IN (7, 8, 9, 11, 12, 13, 14)
    AND w.obj_no = o.obj#;

CREATE OR REPLACE FORCE VIEW "DBA_WORKSPACES"("WORKSPACE",
select asp.workspace, asp.parent_workspace, ssp.savepoint parent_savepoint,
       asp.owner, asp.createTime, asp.description,
       decode(asp.freeze_status,'LOCKED','FROZEN',
                              'UNLOCKED','UNFROZEN') freeze_status,
       decode(asp.oper_status, null, asp.freeze_mode,'INTERNAL') freeze_mode,
       decode(asp.freeze_mode, '1WRITER_SESSION', s.username, asp.freeze_writer) freeze_writer,
       decode(asp.freeze_mode, '1WRITER_SESSION', substr(asp.freeze_writer, 1, instr(asp.freeze_writer, ',')-1), null) sid,
       decode(asp.freeze_mode, '1WRITER_SESSION', substr(asp.freeze_writer, instr(asp.freeze_writer, ',')+1), null) serial#,
       decode(asp.session_duration, 0, asp.freeze_owner, s.username) freeze_owner,
       decode(asp.freeze_status, 'UNLOCKED', null, decode(asp.session_duration, 1, 'YES', 'NO')) session_duration,
       decode(asp.session_duration, 1,
                     decode((select 1 from dual
                             where s.sid=sys_context('lt_ctx', 'cid') and s.serial#=sys_context('lt_ctx', 'serial#')),
                           1, 'YES', 'NO'),
             null) current_session,
       decode(rst.workspace,null,'INACTIVE','ACTIVE') resolve_status,
       rst.resolve_user,
       mp_root mp_root_workspace
from   wmsys.wm$workspaces_table asp, wmsys.wm$workspace_savepoints_table ssp,
       wmsys.wm$resolve_workspaces_table  rst, V$session s
where  nvl(ssp.is_implicit,1) = 1 and
       asp.parent_version  = ssp.version (+) and
       asp.workspace = rst.workspace (+) and
       to_char(s.sid(+)) = substr(asp.freeze_owner, 1, instr(asp.freeze_owner, ',')-1)  and
       to_char(s.serial#(+)) = substr(asp.freeze_owner, instr(asp.freeze_owner, ',')+1)
WITH READ ONLY;

CREATE OR REPLACE FORCE VIEW "DBA_WORKSPACE_SESSIONS"("USERNAME",
select sut.username,
       sut.workspace,
       sut.sid,
       decode(t.ses_addr, null, 'INACTIVE','ACTIVE') status
from   sys.wm$workspace_sessions_view sut,
       sys.v$transaction t
where  sut.saddr = t.ses_addr (+)
WITH READ ONLY;

CREATE OR REPLACE FORCE VIEW "DBA_XML_SCHEMAS"("OWNER",
select s.xmldata.schema_owner, s.xmldata.schema_url,
          case when bitand(to_number(s.xmldata.flags,'xxxxxxxx'), 16) = 16
               then 'NO' else 'YES' end,
          value(s),
          xdb.xdb$Extname2Intname(s.xmldata.schema_url,s.xmldata.schema_owner),
          case when bitand(to_number(s.xmldata.flags,'xxxxxxxx'), 16) = 16
               then s.xmldata.schema_url
               else 'http://xmlns.oracle.com/xdb/schemas/' ||
                    s.xmldata.schema_owner || '/' ||
                    case when substr(s.xmldata.schema_url, 1, 7) = 'http://'
                         then substr(s.xmldata.schema_url, 8)
                         else s.xmldata.schema_url
                    end
          end
    from xdb.xdb$schema s;

CREATE OR REPLACE FORCE VIEW "DBA_XML_TABLES"("OWNER",
select u.name, o.name, null, null, null,
    decode(bitand(opq.flags,5),1,'OBJECT-RELATIONAL','CLOB')
 from sys.opqtype$ opq, sys.tab$ t, sys.user$ u, sys.obj$ o,
      sys.coltype$ ac, sys.col$ tc
 where o.owner# = u.user#
  and o.obj# = t.obj#
  and bitand(t.property, 1) = 1
  and t.obj# = tc.obj#
  and tc.name = 'SYS_NC_ROWINFO$'
  and tc.obj# = ac.obj#
  and tc.intcol# = ac.intcol#
  and ac.toid = '00000000000000000000000000020100'
  and tc.intcol# =  opq.intcol#
  and tc.obj# =  opq.obj#
  and bitand(opq.flags,2) = 0
 union all
 select u.name, o.name, schm.xmldata.schema_url, schm.xmldata.schema_owner,
        decode(xel.xmldata.property.name, null,
        xel.xmldata.property.propref_name.name, xel.xmldata.property.name),
        decode(bitand(opq.flags,5),1,'OBJECT-RELATIONAL','CLOB')
 from xdb.xdb$element xel, xdb.xdb$schema schm, sys.opqtype$ opq,
      sys.tab$ t, sys.user$ u, sys.obj$ o, sys.coltype$ ac, sys.col$ tc
where o.owner# = u.user#
  and o.obj# = t.obj#
  and bitand(t.property, 1) = 1
  and t.obj# = tc.obj#
  and tc.name = 'SYS_NC_ROWINFO$'
  and tc.obj# = ac.obj#
  and tc.intcol# = ac.intcol#
  and ac.toid = '00000000000000000000000000020100'
  and tc.intcol# =  opq.intcol#
  and tc.obj# =  opq.obj#
  and bitand(opq.flags,2) = 2
  and opq.schemaoid =  schm.sys_nc_oid$
  and ref(schm) =  xel.xmldata.property.parent_schema
  and opq.elemnum =  xel.xmldata.property.prop_number;

CREATE OR REPLACE FORCE VIEW "DBA_XML_TAB_COLS"("OWNER",
select u.name, o.name,
   decode(bitand(tc.property, 1), 1, attr.name, tc.name),
   null, null, null,
   decode(bitand(opq.flags,5),1,'OBJECT-RELATIONAL','CLOB')
from sys.opqtype$ opq, sys.tab$ t, sys.user$ u, sys.obj$ o,
     sys.coltype$ ac, sys.col$ tc, sys.attrcol$ attr
where o.owner# = u.user#
  and o.obj# = t.obj#
  and t.obj# = tc.obj#
  and tc.obj# = ac.obj#
  and tc.intcol# = ac.intcol#
  and tc.obj#    = attr.obj#(+)
  and tc.intcol# = attr.intcol#(+)
  and tc.name != 'SYS_NC_ROWINFO$'
  and ac.toid = '00000000000000000000000000020100'
  and tc.intcol# =  opq.intcol#
  and tc.obj# =  opq.obj#
  and bitand(opq.flags,2) = 0
 union all
  select u.name, o.name,
   decode(bitand(tc.property, 1), 1, attr.name, tc.name),
   schm.xmldata.schema_url, schm.xmldata.schema_owner,
decode(xel.xmldata.property.name, null,
        xel.xmldata.property.propref_name.name, xel.xmldata.property.name),
    decode(bitand(opq.flags,5),1,'OBJECT-RELATIONAL','CLOB')
from xdb.xdb$element xel, xdb.xdb$schema schm, sys.opqtype$ opq,
      sys.tab$ t, sys.user$ u, sys.obj$ o, sys.coltype$ ac, sys.col$ tc,
      sys.attrcol$ attr
where o.owner# = u.user#
  and o.obj# = t.obj#
  and t.obj# = tc.obj#
  and tc.obj# = ac.obj#
  and ac.toid = '00000000000000000000000000020100'
  and tc.intcol# = ac.intcol#
  and tc.obj#    = attr.obj#(+)
  and tc.intcol# = attr.intcol#(+)
  and tc.name != 'SYS_NC_ROWINFO$'
  and tc.intcol# =  opq.intcol#
  and tc.obj# =  opq.obj#
  and opq.schemaoid =  schm.sys_nc_oid$
  and bitand(opq.flags,2) = 2
  and ref(schm) =  xel.xmldata.property.parent_schema
  and opq.elemnum =  xel.xmldata.property.prop_number;

CREATE OR REPLACE FORCE VIEW "DBA_XML_VIEWS"("OWNER",
select u.name, o.name, null, null, null
 from sys.opqtype$ opq, sys.view$ v, sys.user$ u, sys.obj$ o,
      sys.coltype$ ac, sys.col$ tc
 where o.owner# = u.user#
  and o.obj# = v.obj#
  and bitand(v.property, 1) = 1
  and v.obj# = tc.obj#
  and tc.name = 'SYS_NC_ROWINFO$'
  and tc.obj# = ac.obj#
  and tc.intcol# = ac.intcol#
  and ac.toid = '00000000000000000000000000020100'
  and tc.intcol# =  opq.intcol#
  and tc.obj# =  opq.obj#
  and bitand(opq.flags,2) = 0
 union all
  select u.name, o.name, schm.xmldata.schema_url, schm.xmldata.schema_owner,
decode(xel.xmldata.property.name, null,
        xel.xmldata.property.propref_name.name, xel.xmldata.property.name)
from xdb.xdb$element xel, xdb.xdb$schema schm, sys.opqtype$ opq,
      sys.view$ v, sys.user$ u, sys.obj$ o, sys.coltype$ ac, sys.col$ tc
where o.owner# = u.user#
  and o.obj# = v.obj#
  and bitand(v.property, 1) = 1
  and v.obj# = tc.obj#
  and tc.name = 'SYS_NC_ROWINFO$'
  and tc.obj# = ac.obj#
  and tc.intcol# = ac.intcol#
  and ac.toid = '00000000000000000000000000020100'
  and tc.intcol# =  opq.intcol#
  and tc.obj# =  opq.obj#
  and bitand(opq.flags,2) = 2
  and opq.schemaoid =  schm.sys_nc_oid$
  and ref(schm) =  xel.xmldata.property.parent_schema
  and opq.elemnum =  xel.xmldata.property.prop_number;

CREATE OR REPLACE FORCE VIEW "DBA_XML_VIEW_COLS"("OWNER",
select u.name, o.name,
   decode(bitand(tc.property, 1), 1, attr.name, tc.name),
   null, null, null
from  sys.opqtype$ opq,
      sys.view$ v, sys.user$ u, sys.obj$ o, sys.coltype$ ac, sys.col$ tc,
      sys.attrcol$ attr
where o.owner# = u.user#
  and o.obj# = v.obj#
  and bitand(v.property, 1) = 1
  and v.obj# = tc.obj#
  and tc.obj# = ac.obj#
  and tc.intcol# = ac.intcol#
  and tc.obj#    = attr.obj#(+)
  and tc.intcol# = attr.intcol#(+)
  and ac.toid = '00000000000000000000000000020100'
  and tc.intcol# =  opq.intcol#
  and tc.obj# =  opq.obj#
  and bitand(opq.flags,2) = 0
union all
select u.name, o.name,
   decode(bitand(tc.property, 1), 1, attr.name, tc.name),
   schm.xmldata.schema_url, schm.xmldata.schema_owner,
decode(xel.xmldata.property.name, null,
        xel.xmldata.property.propref_name.name, xel.xmldata.property.name)
from xdb.xdb$element xel, xdb.xdb$schema schm, sys.opqtype$ opq,
      sys.view$ v, sys.user$ u, sys.obj$ o, sys.coltype$ ac, sys.col$ tc,
      sys.attrcol$ attr
where o.owner# = u.user#
  and o.obj# = v.obj#
  and bitand(v.property, 1) = 1
  and v.obj# = tc.obj#
  and tc.obj# = ac.obj#
  and tc.intcol# = ac.intcol#
  and tc.obj#    = attr.obj#(+)
  and tc.intcol# = attr.intcol#(+)
  and ac.toid = '00000000000000000000000000020100'
  and tc.intcol# =  opq.intcol#
  and tc.obj# =  opq.obj#
  and opq.schemaoid =  schm.sys_nc_oid$
  and ref(schm) =  xel.xmldata.property.parent_schema
  and opq.elemnum =  xel.xmldata.property.prop_number;

CREATE OR REPLACE FORCE VIEW "DBMSHSXP_SQL_PROFILE_ATTR"("PROFILE_NAME",
select sp.sp_name, sa.attr#, sa.attr_val
from  sqlprof$      sp,
      sqlprof$attr  sa
where sp.signature = sa.signature
and sp.category = sp.category;

CREATE OR REPLACE FORCE VIEW "DBMS_DBUPGRADE_USER_INITCAT"("USERNAME",
SELECT username, user_id from dbms_dbupgrade_usercat$ WHERE which = 0;

CREATE OR REPLACE FORCE VIEW "DBMS_UPG_CURRENT_STATUS"("STATUS",
SELECT status, source_schema, target_schema, message,
         to_char(st_time, 'mon yyyy: hh:mi:ss'),
         to_char(en_time, 'mon yyyy: hh:mi:ss')
  FROM dbms_upg_status$
  WHERE sequence# = (SELECT max(sequence#) FROM dbms_upg_status$);

CREATE OR REPLACE FORCE VIEW "DBMS_UPG_STATUS"("SEQ#",
SELECT sequence#, source_schema, target_schema, status, message,
         to_char(st_time, 'mon yyyy: hh:mi:ss'),
         to_char(en_time, 'mon yyyy: hh:mi:ss')
  FROM dbms_upg_status$;

CREATE OR REPLACE FORCE VIEW "DEFCALL"("CALLNO",
SELECT step_no callno,
       enq_tid deferred_tran_id,
       substrb(sys.dbms_defer_query_utl.key_to_schema_name(
		   recipient_key,
		   enq_tid,
		   step_no), 1, 30) schemaname,
       substrb(sys.dbms_defer_query_utl.key_to_package_name(
		   recipient_key,
		   enq_tid,
		   step_no), 1, 30) packagename,
       substrb(sys.dbms_defer_query_utl.procedure_name(
		   1, --dbms_defer_query_utl.loc_normal_call,
                   chain_no,
                   user_data,
                   recipient_key), 1, 30) procname,
       chain_no argcount
  FROM system.def$_aqcall
    WHERE substrb(sys.dbms_defer_query_utl.key_to_schema_name(
		   recipient_key,
		   enq_tid,
		   step_no), 1, 30) != '** NO DATA FOUND **'
       AND substrb(sys.dbms_defer_query_utl.key_to_package_name(
		   recipient_key,
		   enq_tid,
		   step_no), 1, 30) != '** NO DATA FOUND **'
UNION ALL
SELECT step_no callno,
       enq_tid deferred_tran_id,
       substrb(sys.dbms_defer_query_utl.schema_name(
                  2, --dbms_defer_query_utl.loc_error_call,
                  chain_no,
                  user_data), 1, 30) schemaname,
       substrb(sys.dbms_defer_query_utl.package_name(
                  2, --dbms_defer_query_utl.loc_error_call,
                  chain_no,
                  user_data), 1, 30) packagename,
       substrb(sys.dbms_defer_query_utl.procedure_name(
                  2, --dbms_defer_query_utl.loc_error_call,
                  chain_no,
                  user_data,
                  0), 1, 30) procname,
       chain_no argcount
  FROM system.def$_aqerror;

CREATE OR REPLACE FORCE VIEW "DEFCALLDEST"("CALLNO",
select C1.step_no callno, C.enq_tid deferred_tran_id,
         D.dblink
    from system.def$_aqcall C, system.def$_aqcall C1,
         system.def$_destination D
    where C.cscn IS NOT NULL
      and C1.enq_tid = c.enq_tid
      AND C.cscn >= D.last_delivered
      AND (C.cscn > D.last_delivered
            OR
            (C.cscn = D.last_delivered
             AND (C.enq_tid > D.last_enq_tid)))
      and (( C1.recipient_key = 0
            AND EXISTS (
              select NULL
                from system.def$_calldest CD
                where  CD.enq_tid=C1.enq_tid
                  AND  CD.step_no=C1.step_no
                  AND  CD.dblink = D.dblink
                  AND  CD.catchup = D.catchup))
          OR ( C1.recipient_key > 0
              AND EXISTS (
              SELECT NULL
                from  system.repcat$_repprop P
                WHERE  D.dblink = P.dblink
                  AND  D.catchup = P.extension_id
                  AND  P.how = 1
                  AND  P.recipient_key = C1.recipient_key
                  AND  ((P.delivery_order is NULL) OR
                        (P.delivery_order < C.cscn)))));

CREATE OR REPLACE FORCE VIEW "DEFDEFAULTDEST"("DBLINK") AS 
SELECT "DBLINK" from system.def$_defaultdest;

CREATE OR REPLACE FORCE VIEW "DEFERRCOUNT"("ERRCOUNT",
SELECT count(1) errcount, destination
    FROM deferror GROUP BY destination;

CREATE OR REPLACE FORCE VIEW "DEFERROR"("DEFERRED_TRAN_ID",
SELECT
   e.enq_tid deferred_tran_id,
   e.origin_tran_db,
   e.origin_enq_tid origin_tran_id,
   e.step_no callno,
   e.destination,
   e.enq_time start_time, e.error_number, e.error_msg, u.name receiver
    FROM system.def$_error e, sys.user$ u
    WHERE e.receiver = u.user# (+);

CREATE OR REPLACE FORCE VIEW "DEFLOB"("ID",
SELECT
     d.id,
     d.enq_tid,
     d.blob_col,
     d.clob_col,
     d.nclob_col
  FROM sys.def$_lob d;

CREATE OR REPLACE FORCE VIEW "DEFPROPAGATOR"("USERNAME",
SELECT
       p.username,
       p.userid,
       DECODE(u.name, NULL, 'INVALID', 'VALID'),
       p.created
     FROM system.def$_propagator p, sys.user$ u
     WHERE p.userid = u.user# (+);

CREATE OR REPLACE FORCE VIEW "DEFSCHEDULE"("DBLINK",
SELECT dblink, job, interval, next_date,
         last_date, disabled, last_txn_count, last_error_number,
         last_error_message, catchup,
         total_txn_count,
         avg_throughput,
         avg_latency,
         total_bytes_sent,
         total_bytes_received,
         total_round_trips,
         total_admin_count,
         total_error_count,
         total_sleep_time,
         disabled_internally_set
    FROM sys."_DEFSCHEDULE";

CREATE OR REPLACE FORCE VIEW "DEFTRAN"("DEFERRED_TRAN_ID",
SELECT
  enq_tid deferred_tran_id,
  cscn delivery_order,
  decode(recipient_key, 0, 'D', 'R') destination_list,
  enq_time start_time
  FROM system.def$_aqcall t
  WHERE cscn is NOT NULL
UNION ALL
SELECT enq_tid deferred_tran_id,
  cscn delivery_order,
  'D' destination_list,
  enq_time start_time
  FROM system.def$_aqerror t
  WHERE cscn is NOT NULL;

CREATE OR REPLACE FORCE VIEW "DEFTRANDEST"("DEFERRED_TRAN_ID",
select deferred_tran_id, delivery_order, dblink
    from "_DEFTRANDEST";

CREATE OR REPLACE FORCE VIEW "DICTIONARY"("TABLE_NAME",
select o.name, c.comment$
from sys.obj$ o, sys.com$ c
where o.obj# = c.obj#(+)
  and c.col# is null
  and o.owner# = 0
  and o.type# = 4
  and (o.name like 'USER%'
       or o.name like 'ALL%'
       or (o.name like 'DBA%'
           and exists
                   (select null
                    from sys.v$enabledprivs
                    where priv_number = -47 /* SELECT ANY TABLE */)
           )
      )
union all
select o.name, c.comment$
from sys.obj$ o, sys.com$ c
where o.obj# = c.obj#(+)
  and o.owner# = 0
  and o.name in ('AUDIT_ACTIONS', 'COLUMN_PRIVILEGES', 'DICTIONARY',
        'DICT_COLUMNS', 'DUAL', 'GLOBAL_NAME', 'INDEX_HISTOGRAM',
        'INDEX_STATS', 'RESOURCE_COST', 'ROLE_ROLE_PRIVS', 'ROLE_SYS_PRIVS',
        'ROLE_TAB_PRIVS', 'SESSION_PRIVS', 'SESSION_ROLES',
        'TABLE_PRIVILEGES','NLS_SESSION_PARAMETERS','NLS_INSTANCE_PARAMETERS',
        'NLS_DATABASE_PARAMETERS', 'DATABASE_COMPATIBLE_LEVEL',
        'DBMS_ALERT_INFO', 'DBMS_LOCK_ALLOCATED')
  and c.col# is null
union all
select so.name, 'Synonym for ' || sy.name
from sys.obj$ ro, sys.syn$ sy, sys.obj$ so
where so.type# = 5
  and ro.linkname is null
  and so.owner# = 1
  and so.obj# = sy.obj#
  and so.name <> sy.name
  and sy.owner = 'SYS'
  and sy.name = ro.name
  and ro.owner# = 0
  and ro.type# = 4
  and (ro.owner# = userenv('SCHEMAID')
       or ro.obj# in
           (select oa.obj#
            from sys.objauth$ oa
            where grantee# in (select kzsrorol from x$kzsro))
       or exists (select null from v$enabledprivs
                  where priv_number in (-45 /* LOCK ANY TABLE */,
                                        -47 /* SELECT ANY TABLE */,
                                        -48 /* INSERT ANY TABLE */,
                                        -49 /* UPDATE ANY TABLE */,
                                        -50 /* DELETE ANY TABLE */)
                  ));

CREATE OR REPLACE FORCE VIEW "DICT_COLUMNS"("TABLE_NAME",
select o.name, c.name, co.comment$
from sys.com$ co, sys.col$ c, sys.obj$ o
where o.owner# = 0
  and o.type# = 4
  and (o.name like 'USER%'
       or o.name like 'ALL%'
       or (o.name like 'DBA%'
           and exists
                   (select null
                    from sys.v$enabledprivs
                    where priv_number = -47 /* SELECT ANY TABLE */)
           )
      )
  and o.obj# = c.obj#
  and c.obj# = co.obj#(+)
  and c.col# = co.col#(+)
  and bitand(c.property, 32) = 0 /* not hidden column */
union all
select o.name, c.name, co.comment$
from sys.com$ co, sys.col$ c, sys.obj$ o
where o.owner# = 0
  and o.name in ('AUDIT_ACTIONS','DUAL','DICTIONARY', 'DICT_COLUMNS')
  and o.obj# = c.obj#
  and c.obj# = co.obj#(+)
  and c.col# = co.col#(+)
  and bitand(c.property, 32) = 0 /* not hidden column */
union all
select so.name, c.name, co.comment$
from sys.com$ co,sys.col$ c, sys.obj$ ro, sys.syn$ sy, sys.obj$ so
where so.type# = 5
  and so.owner# = 1
  and so.obj# = sy.obj#
  and so.name <> sy.name
  and sy.owner = 'SYS'
  and sy.name = ro.name
  and ro.owner# = 0
  and ro.type# = 4
  and ro.obj# = c.obj#
  and c.col# = co.col#(+)
  and bitand(c.property, 32) = 0 /* not hidden column */
  and c.obj# = co.obj#(+);

CREATE OR REPLACE FORCE VIEW "DISK_AND_FIXED_OBJECTS"("OBJ#",
select obj#, owner#, name, type#, remoteowner, linkname
from sys.obj$
union all
select kobjn_kqfp, 0, name_kqfp,
decode(type_kqfp, 1, 9, 2, 11, 3, 10, 0), NULL, NULL
from sys.x$kqfp
union all
select kqftaobj, 0, kqftanam, 2, NULL, NULL
from sys.x$kqfta
union all
select kqfviobj, 0, kqfvinam, 4, NULL, NULL
from sys.x$kqfvi;

CREATE OR REPLACE FORCE VIEW "ERROR_SIZE"("OBJ#",
select e.obj#, sum(e.textlength)
  from sys.error$ e
  group by e.obj#;

CREATE OR REPLACE FORCE VIEW "EXPCOMPRESSEDPART"("SPARE1",
SELECT s.spare1, t.obj#
        FROM   sys.tabpart$ t, sys.seg$ s
        WHERE  t.ts#    = s.ts#
        AND    t.file#  = s.file#
        AND    t.block# = s.block#
        AND    s.type#  = 5
        AND    (bitand(s.spare1,4096) = 4096 OR bitand(s.spare1,2048) = 2048);

CREATE OR REPLACE FORCE VIEW "EXPCOMPRESSEDSUB"("SPARE1",
SELECT s.spare1, t.obj#
        FROM   sys.tabsubpart$ t, sys.seg$ s
        WHERE  t.ts#    = s.ts#
        AND    t.file#  = s.file#
        AND    t.block# = s.block#
        AND    s.type#  = 5
        AND    (bitand(s.spare1,4096) = 4096 OR bitand(s.spare1,2048) = 2048);

CREATE OR REPLACE FORCE VIEW "EXPCOMPRESSEDTAB"("SPARE1",
SELECT s.spare1, t.obj#
        FROM   sys.tab$ t, sys.seg$ s
        WHERE  t.ts#    = s.ts#
        AND    t.file#  = s.file#
        AND    t.block# = s.block#
        AND    s.type#  = 5
        AND    (bitand(s.spare1,4096) = 4096 OR bitand(s.spare1,2048) = 2048);

CREATE OR REPLACE FORCE VIEW "EXPEXEMPT"("COUNT") AS 
SELECT  COUNT(*)
        FROM    sys.sysauth$
        WHERE   (privilege# =
                        (SELECT privilege
                         FROM   sys.system_privilege_map
                         WHERE  name = 'EXEMPT ACCESS POLICY'))
        AND     grantee# = UID   /* user directly has priv */
        OR      (grantee# = UID   /* user has role with priv */
                        AND privilege# > 0
                        AND privilege# IN
                                (SELECT u1.privilege#
                                 FROM sys.sysauth$ u1, sys.sysauth$ u2
                                 WHERE u1.grantee# = UID
                                 AND u1.privilege# = u2.grantee#
                                 AND u2.privilege# =
                                      (SELECT privilege
                                       FROM   sys.system_privilege_map
                                       WHERE  name = 'EXEMPT ACCESS POLICY')));

CREATE OR REPLACE FORCE VIEW "EXPTABSUBPART"("OBJNO",
SELECT
              tsp.obj#                                                 OBJNO,
              tsp.pobj#                                                POBJNO,
              row_number() OVER
                   (partition by tsp.pobj# order by tsp.subpart#) - 1  SUBPARTNO,
              bhiboundval                                              BHIBOUNDVAL,
              ts#                                                      TSNO
        FROM sys.tabsubpart$ tsp;

CREATE OR REPLACE FORCE VIEW "EXPTABSUBPARTDATA_VIEW"("SPBND",
SELECT
              sp.bhiboundval       SPBND,
              dsp.bhiboundval      DSPBND,
              p.obj#               PONO,
              sp.tsno              SPTS,
              dsp.ts#              DSPTS,
              p.defts#             PDEFTS,
              tpo.defts#           TDEFTS,
              u.datats#            UDEFTS
        FROM sys.tabcompart$ p, sys.partobj$ tpo, sys.exptabsubpart sp,
             sys.defsubpart$ dsp, sys.obj$ po, sys.obj$ spo, sys.user$ u
        WHERE
             p.bo# = tpo.obj# AND
             p.subpartcnt = MOD(TRUNC(tpo.spare2/65536), 65536) AND
             sp.pobjno = p.obj# AND
             po.obj# = p.obj# AND
             spo.obj# = sp.objno AND
             sp.subpartno = dsp.spart_position AND
             dsp.bo# = p.bo# AND
             u.user# = po.owner# and
             (spo.subname = (po.subname || '_' || dsp.spart_name) OR
                            (po.subname LIKE 'SYS_P%' AND
                             spo.subname LIKE 'SYS_SUBP%'));

CREATE OR REPLACE FORCE VIEW "EXPTABSUBPARTLOBFRAG"("PARENTOBJNO",
SELECT
              lf.parentobj#                                         PARENTOBJNO,
              lf.ts#                                                TSNO,
              lf.fragobj#                                           FRAGOBJNO,
              row_number() OVER
                 (partition by lf.parentobj# order by lf.frag#) - 1 FRAGNO,
              lf.tabfragobj#                                        TABFRAGOBJNO
        FROM sys.lobfrag$ lf;

CREATE OR REPLACE FORCE VIEW "EXPTABSUBPARTLOB_VIEW"("PONO",
SELECT
              tp.obj#            PONO,
              lp.defts#          LPDEFTS,
              lf.tsno            LFTS,
              lb.defts#          LCDEFTS,
              dsp.lob_spart_ts#  LSPDEFTS,
              tsp.ts#            SPTS
        FROM  sys.tabcompart$ tp, sys.lobcomppart$ lp, sys.partlob$ lb,
              sys.exptabsubpartlobfrag lf, sys.defsubpartlob$ dsp,
              sys.obj$ lspo, sys.obj$ tpo, sys.tabsubpart$ tsp
        WHERE
              lp.tabpartobj# = tp.obj# AND
              lp.lobj# = lb.lobj# and
              lf.parentobjno = lp.partobj# AND
              dsp.bo# = tp.bo# and
              dsp.intcol# = lb.intcol# AND
              lspo.obj# = lf.fragobjno AND
              tpo.obj# = tp.obj# AND
              (lspo.subname = tpo.subname || '_' || dsp.lob_spart_name OR
               (tpo.subname LIKE 'SYS_P%' AND lspo.subname LIKE 'SYS_LOB_SUBP%')) AND
              dsp.spart_position = lf.fragno AND
              tsp.obj# = lf.tabfragobjno
     UNION ALL
        SELECT tp.obj#           PONO,
               lp.defts#         LPDEFTS,
               lf.tsno           LFTS,
               lb.defts#         LCDEFTS,
                                 NULL,
               tsp.ts#           SPTS
        FROM sys.tabcompart$ tp, sys.lobcomppart$ lp, sys.partlob$ lb,
             sys.exptabsubpartlobfrag lf, sys.obj$ lspo, sys.obj$ tpo,
             sys.tabsubpart$ tsp
        WHERE lp.tabpartobj# = tp.obj# AND
              lp.lobj# = lb.lobj# AND
              lf.parentobjno = lp.partobj# AND
              lb.intcol# NOT IN
                (SELECT distinct dsp.intcol#
                  FROM sys.defsubpartlob$ dsp
                  WHERE dsp.bo# = tp.bo#) AND
              lspo.obj# = lf.fragobjno AND
              tpo.obj# = tp.obj# AND
              lspo.subname LIKE 'SYS_LOB_SUBP%' AND
              tsp.obj# = lf.tabfragobjno;

CREATE OR REPLACE FORCE VIEW "EXU10ADEFPSWITCHES"("NLSLENSEM",
SELECT  a.value, b.value, c.value, d.value
        FROM    sys.v$parameter a, sys.v$parameter b, sys.v$parameter c,
                sys.v$parameter d
        WHERE   a.name = 'nls_length_semantics' AND
                b.name = 'plsql_optimize_level' AND
                c.name = 'plsql_code_type'      AND
                d.name = 'plsql_warnings';

CREATE OR REPLACE FORCE VIEW "EXU10AOBJSWITCH"("OBJID",
SELECT  a.obj#, a.value, b.value, c.value, d.value, e.value
        FROM    sys.settings$ a, sys.settings$ b, sys.settings$ c,
                sys.settings$ d, sys.settings$ e, sys.obj$ o
        WHERE   o.obj#  = a.obj# AND
                a.obj#  = b.obj# AND
                b.obj#  = c.obj# AND
                c.obj#  = d.obj# AND
                d.obj#  = e.obj# AND
                a.param = 'nls_length_semantics'         AND
                b.param = 'plsql_optimize_level'         AND
                c.param = 'plsql_code_type'              AND
                d.param = 'plsql_debug'                  AND
                e.param = 'plsql_warnings'               AND
                (UID IN (o.owner#, 0) OR
                 EXISTS (
                    SELECT  role
                    FROM    sys.session_roles
                    WHERE   role = 'SELECT_CATALOG_ROLE'));

CREATE OR REPLACE FORCE VIEW "EXU10ASC"("TOBJID",
SELECT  c$.obj#, hh$.obj#, o$.owner#, c$.name, hh$.intcol#,
                hh$.distcnt, hh$.lowval, hh$.hival, hh$.density, hh$.null_cnt,
                hh$.avgcln, hh$.spare2, c$.property
        FROM    sys.hist_head$ hh$, sys.obj$ o$, sys.obj$ ot$, sys.col$ c$
        WHERE   hh$.obj# = o$.obj# AND
                c$.obj# = ot$.obj# AND
                o$.owner# = ot$.owner# AND
                hh$.intcol# = c$.intcol#;

CREATE OR REPLACE FORCE VIEW "EXU10ASCU"("TOBJID",
SELECT  "TOBJID",
        FROM    sys.exu10asc
        WHERE   townerid = UID;

CREATE OR REPLACE FORCE VIEW "EXU10CCL"("OWNERID",
SELECT  o.owner#, u.name, cc.con#,
                DECODE(BITAND(c.property, 1), 1, at.name, c.name),
                cc.pos#, c.intcol#, c.property,
                DECODE(BITAND(cc.spare1, 1), 1, 1, 0)
        FROM    sys.obj$ o, sys.col$ c, sys.ccol$ cc, sys.attrcol$ at,
                sys.user$ u
        WHERE   o.obj# = cc.obj# AND
                o.owner# = u.user# AND
                c.obj# = cc.obj# AND
                c.intcol# = cc.intcol# AND
                BITAND(c.property, 2097152) = 0 AND               /* Not REA */
                BITAND(c.property, 1024) = 0 AND                /* Not SETID */
                c.obj# = at.obj# (+) AND
                c.intcol# = at.intcol# (+) AND
                NOT EXISTS (
                    SELECT  owner, name
                    FROM    sys.noexp$ ne
                    WHERE   ne.owner = u.name AND
                            ne.name = o.name AND
                            ne.obj_type = 2)
 UNION /* Nested Tables - SETID column */
        SELECT  o.owner#, u.name, cc.con#,
                DECODE(BITAND(c.property, 1), 1, at.name, c.name),
                cc.pos#, c.intcol#, c.property,
                DECODE(BITAND(cc.spare1, 1), 1, 1, 0)
        FROM    sys.obj$ o, sys.col$ c, sys.ccol$ cc, sys.attrcol$ at,
                sys.user$ u, sys.col$ cn
        WHERE   o.obj# = cc.obj# AND
                o.owner# = u.user# AND
                cn.obj# = cc.obj# AND
                cn.intcol# = cc.intcol# AND
                BITAND(cn.property, 1024) = 1024 AND                /* SETID */
                c.obj# = cc.obj# AND
                c.col# = cn.col# AND
                c.intcol# = (cn.intcol# - 1) AND
                c.segcol# = 0 AND
                c.obj# = at.obj# (+) AND
                c.intcol# = at.intcol# (+) AND
                NOT EXISTS (
                    SELECT  owner, name
                    FROM    sys.noexp$ ne
                    WHERE   ne.owner = u.name AND
                            ne.name = o.name AND
                            ne.obj_type = 2)
 UNION /* REFs - REF attribute columns */
        SELECT  o.owner#, u.name, cc.con#,
                DECODE(BITAND(rc.property, 1), 1, at.name, rc.name),
                cc.pos#, rc.intcol#, rc.property,
                DECODE(BITAND(cc.spare1, 1), 1, 1, 0)
        FROM    sys.obj$ o, sys.col$ c, sys.ccol$ cc, sys.attrcol$ at,
                sys.user$ u, sys.coltype$ ct, sys.col$ rc
        WHERE   o.obj# = cc.obj# AND
                o.owner# = u.user# AND
                c.obj# = cc.obj# AND
                c.intcol# = cc.intcol# AND
                BITAND(c.property, 2097152) = 2097152 AND             /* REA */
                ct.obj# = cc.obj# AND
                ct.col# = cc.col# AND
                UTL_RAW.CAST_TO_BINARY_INTEGER(SUBSTRB(ct.intcol#s, 1,2), 3) =
                  cc.intcol# AND            /* first list col# = constr col# */
                rc.obj# = cc.obj# AND
                rc.intcol# = ct.intcol# AND
                rc.obj# = at.obj# (+) AND
                rc.intcol# = at.intcol# (+) AND
                NOT EXISTS (
                    SELECT  owner, name
                    FROM    sys.noexp$ ne
                    WHERE   ne.owner = u.name AND
                            ne.name = o.name AND
                            ne.obj_type = 2);

CREATE OR REPLACE FORCE VIEW "EXU10CCLO"("OWNERID",
SELECT  a.ownerid, a.cno, a.colname, a.colno, a.property, a.nolog
        FROM    sys.exu10ccl a, sys.con$ b , sys.cdef$ c
        WHERE   b.owner# = UID AND
                b.con# = c.con# AND
                c.rcon# = a.cno;

CREATE OR REPLACE FORCE VIEW "EXU10CCLU"("OWNERID",
SELECT  "OWNERID",
        FROM    sys.exu10ccl
        WHERE   UID = ownerid;

CREATE OR REPLACE FORCE VIEW "EXU10COE"("TOBJID",
SELECT  "TOBJID",
        FROM    sys.exu9coe
      UNION ALL
        SELECT  tobjid, towner, townerid, v$.tname, v$.name, v$.length,
                v$.precision, v$.scale, v$.type, v$.isnull, v$.conname,
                v$.colid, v$.intcolid, v$.segcolid, v$.comment$, default$,
                v$.dfltlen, v$.enabled, v$.defer, v$.flags, v$.colprop,
                o$.name, u$.name,
                DECODE (v$.name, 'SYS_NC_OID$', 1, 'NESTED_TABLE_ID', 2,
                        'SYS_NC_ROWINFO$', 3, 100),
                v$.charsetid, v$.charsetform, v$.fsprecision, v$.lfprecision,
                v$.charlen, NVL(ct$.flags, 0), NULL
        FROM    sys.exu8col_temp v$, sys.col$ c$, sys.coltype$ ct$,
                sys.obj$ o$, sys.user$ u$
        WHERE   c$.obj# = v$.tobjid AND
                c$.intcol# = v$.intcolid AND
                c$.intcol# = ct$.intcol# (+) AND
                (BITAND(v$.colprop, 32)      != 32 OR          /* not hidden */
                 BITAND(v$.colprop, 1048608) = 1048608 OR  /* snapsht hidden */
                 BITAND(v$.colprop, 4194304) = 4194304) AND    /* RLS Hidden */
                c$.obj# = ct$.obj# (+) AND
                NVL(ct$.toid, HEXTORAW('00')) = o$.oid$ (+) AND
                NVL(o$.owner#, -1) = u$.user# (+) AND
                NVL(o$.type#, -1) != 10 /* bug 882543: no non-existent types */;

CREATE OR REPLACE FORCE VIEW "EXU10COEU"("TOBJID",
SELECT  "TOBJID",
        FROM    sys.exu10coe
        WHERE   townerid = UID;

CREATE OR REPLACE FORCE VIEW "EXU10DEFPSWITCHES"("COMPFLGS",
SELECT  a.value, b.value, c.value
        FROM    sys.v$parameter a, sys.v$parameter b, sys.v$parameter c
        WHERE   a.name = 'plsql_compiler_flags' AND
                b.name = 'nls_length_semantics' AND
                c.name = 'plsql_optimize_level';

CREATE OR REPLACE FORCE VIEW "EXU10DOSO"("OBJ#",
SELECT  pi_obj.obj#, c_obj.name, c_obj.owner#,
                /* decode below needed for ConText IOTs - copied from */
                /* USER_TABLES in catalog.sql */
                decode(bitand(tab.property, 2151678048), 0, ts.name, null)
        FROM    sys.obj$ pi_obj, sys.obj$ c_obj, sys.user$ us2,
                sys.secobj$ secobj, sys.tab$ tab, sys.ts$ ts
        WHERE   pi_obj.obj# = secobj.obj# AND       /* has secondary objects */
                c_obj.obj# = secobj.secobj# AND /*object is secondary object */
                c_obj.owner# = us2.user#  AND /* secondary obj is same owner */
                c_obj.type# = 2 AND             /* Secondary Object is TABLE */
                BITAND(c_obj.flags, 128) != 128 AND
                secobj.secobj# = tab.obj# AND
                tab.ts# = ts.ts# AND
                (UID = 0 OR (UID = pi_obj.owner# AND UID = us2.user#) OR
                 EXISTS (
                    SELECT  role
                    FROM    sys.session_roles
                    WHERE   role = 'SELECT_CATALOG_ROLE'));

CREATE OR REPLACE FORCE VIEW "EXU10IND_BASE"("IOBJID",
SELECT  i$.obj#, i$.dataobj#, i$.name, ui$.name, i$.owner#, ts$.name,
                ind$.ts#, ind$.file#, ind$.block#, t$.name, t$.obj#, ut$.name,
                t$.owner#, NVL(tb$.property, 0), NVL(tb$.bobj#, 0),
                ind$.property, DECODE(t$.type#, 3, 1, 0), ind$.pctfree$,
                ind$.initrans, ind$.maxtrans, NVL(ind$.blevel, -1),
                DECODE(ind$.type#, 2, 1, 0),
                DECODE(BITAND(ind$.flags, 4), 4, 1, 0), ts$.dflogging,
                NVL(ind$.degree, 1), NVL(ind$.instances, 1), ind$.type#,
                NVL(ind$.rowcnt, -1), NVL(ind$.leafcnt, -1),
                NVL(ind$.distkey, -1), NVL(ind$.lblkkey, -1),
                NVL(ind$.dblkkey, -1), NVL(ind$.clufac, -1),
                NVL(ind$.spare2, 0), ind$.flags,
                DECODE(BITAND(i$.flags, 4), 4, 1, 0)
        FROM    sys.obj$ t$, sys.obj$ i$, sys.ind$ ind$, sys.user$ ui$,
                sys.user$ ut$, sys.ts$ ts$, sys.tab$ tb$
        WHERE   ind$.bo# = t$.obj# AND
                ind$.obj# = i$.obj# AND
                ind$.bo# = tb$.obj# (+) AND
                ts$.ts# = ind$.ts# AND
                i$.owner# = ui$.user# AND
                t$.owner# = ut$.user# AND
                BITAND(ind$.flags, 4096) = 0 AND          /* skip fake index */
                BITAND(ind$.property, 8208) != 8208 AND /* skip Fn Ind on MV */
                (UID = 0 OR (UID = i$.owner# AND UID = t$.owner#) OR
                 EXISTS (
                    SELECT  role
                    FROM    sys.session_roles
                    WHERE   role = 'SELECT_CATALOG_ROLE'));

CREATE OR REPLACE FORCE VIEW "EXU10MVL"("CTOBJ#",
SELECT  ct.obj#, ct.change_table_schema, ct.change_table_name, u.user#,
                ct.created, 7, DECODE(BITAND(ct.mvl_flag, 1), 1, 1, 0),
                DECODE(BITAND(ct.mvl_flag, 2), 2, 1, 0),
                DECODE(BITAND(ct.mvl_flag, 512), 512, 1, 0),
                DECODE(BITAND(ct.mvl_flag, 1024), 1024, 1, 0),
                ct.change_set_name, ct.source_schema_name,
                ct.source_table_name, ct.created_scn, ct.mvl_flag,
                ct.captured_values, ct.mvl_temp_log, ct.mvl_v7trigger,
                ct.last_altered, ct.lowest_scn, ct.mvl_oldest_rid,
                ct.mvl_oldest_pk, ct.mvl_oldest_oid, ct.mvl_oldest_new,
                ct.mvl_oldest_rid_time, ct.mvl_oldest_pk_time,
                ct.mvl_oldest_oid_time, ct.mvl_oldest_new_time,
                ct.mvl_backcompat_view, ct.mvl_physmvl, ct.highest_scn,
                ct.highest_timestamp, ct.mvl_oldest_seq, ct.mvl_oldest_seq_time
        FROM    sys.cdc_change_tables$ ct, sys.user$ u
        WHERE   ct.change_table_schema = u.name AND
                ct.mvl_flag IS NOT NULL AND
                BITAND(ct.mvl_flag, 128) = 128 AND
                (UID IN (0, u.user#) OR
                 EXISTS (
                    SELECT  role
                    FROM    sys.session_roles
                    WHERE   role = 'SELECT_CATALOG_ROLE'));

CREATE OR REPLACE FORCE VIEW "EXU10MVLU"("CTOBJ#",
SELECT  "CTOBJ#",
        FROM    sys.exu10mvl
        WHERE   log_ownerid = UID;

CREATE OR REPLACE FORCE VIEW "EXU10NTA"("CLIENT",
SELECT  u$.name, up$.name, pd$.flags,
                DECODE(pd$.flags,
                       2, 'WITH NO ROLES',
                       4, 'WITH ROLE',
                       8, 'WITH ROLE ALL EXCEPT', ' '),
                DECODE(pd$.credential_type#,
                       5, 'AUTHENTICATION REQUIRED', ' ')
        FROM    sys.user$ u$, sys.user$ up$, sys.proxy_info$ pd$
        WHERE   pd$.client# = u$.user# AND
                pd$.proxy# = up$.user#;

CREATE OR REPLACE FORCE VIEW "EXU10NTAROLE"("ROLEID",
SELECT  prd$.role#, ur$.name, uc$.name, up$.name
        FROM    sys.user$ ur$, sys.proxy_role_info$ prd$,
                sys.user$ uc$, sys.user$ up$
        WHERE   prd$.role#   = ur$.user# AND
                prd$.client# = uc$.user# AND
                prd$.proxy#  = up$.user#;

CREATE OR REPLACE FORCE VIEW "EXU10OBJSWITCH"("OBJID",
SELECT  a.obj#, a.value, b.value, c.value
        FROM    sys.settings$ a, sys.settings$ b, sys.settings$ c, sys.obj$ o
        WHERE   o.obj#  = a.obj# AND
                a.obj#  = b.obj# AND
                b.obj#  = c.obj# AND
                a.param = 'plsql_compiler_flags' AND
                b.param = 'nls_length_semantics' AND
                c.param = 'plsql_optimize_level' AND
                (UID IN (o.owner#, 0) OR
                 EXISTS (
                    SELECT  role
                    FROM    sys.session_roles
                    WHERE   role = 'SELECT_CATALOG_ROLE'));

CREATE OR REPLACE FORCE VIEW "EXU10SNAPL"("LOG_OWNER",
SELECT  m.mowner, u.user#, m.master, m.log, m.trig, NVL(m.flag, 0),
                m.youngest, m.oldest, m.oldest_pk, m.mtime,
                /* have a flag for each snapshot log types: rowid, primary key
                ** for compatibility purpose */
                DECODE(BITAND(NVL(m.flag, 0), 1), 1, 1, 0),
                DECODE(BITAND(NVL(m.flag, 0), 2), 2, 1, 0),
                DECODE(BITAND(NVL(m.flag, 0), 512), 512, 1, 0),
                DECODE(BITAND(NVL(m.flag, 0), 1024), 1024, 1, 0),
                DECODE(BITAND(NVL(m.flag, 0), 16), 16, 1, 0),
                7, m.temp_log, m.oldest_oid, m.oldest_new, m.oldest_seq
        FROM    sys.mlog$ m, sys.user$ u
        WHERE   m.mowner = u.name;

CREATE OR REPLACE FORCE VIEW "EXU10SNAPLC"("LOG_OWNER",
SELECT  s."LOG_OWNER",s."LOG_OWNERID",s."MASTER",s."LOG_TABLE",s."LOG_TRIGGER",s."FLAG",s."YOUNGEST",s."OLDEST",s."OLDEST_PK",s."MTIME",s."ROWID_SNAPL",s."PRIMKEY_SNAPL",s."OID_SNAPL",s."SEQ_SNAPL",s."INV_SNAPL",s."FILE_VER",s."TEMP_LOG",s."OLDEST_OID",s."OLDEST_NEW",s."OLDEST_SEQ"
        FROM    sys.exu10snapl s, sys.incexp i, sys.incvid v
        WHERE   s.master = i.name(+) AND
                s.log_ownerid = i.owner#(+) AND
                NVL(i.type#, 98) = 98 AND
                (NVL(i.ctime, TO_DATE('01-01-1900', 'DD-MM-YYYY')) < i.itime OR
                 NVL(i.expid, 9999) > v.expid);

CREATE OR REPLACE FORCE VIEW "EXU10SNAPLI"("LOG_OWNER",
SELECT  s."LOG_OWNER",s."LOG_OWNERID",s."MASTER",s."LOG_TABLE",s."LOG_TRIGGER",s."FLAG",s."YOUNGEST",s."OLDEST",s."OLDEST_PK",s."MTIME",s."ROWID_SNAPL",s."PRIMKEY_SNAPL",s."OID_SNAPL",s."SEQ_SNAPL",s."INV_SNAPL",s."FILE_VER",s."TEMP_LOG",s."OLDEST_OID",s."OLDEST_NEW",s."OLDEST_SEQ"
        FROM    sys.exu10snapl s, sys.incexp i, sys.incvid v
        WHERE   s.master = i.name(+) AND
                s.log_ownerid = i.owner#(+) AND
                /* snapshot log also creates a table with the same name */
                NVL(i.type#, 98) IN (2, 98) AND
                (s.mtime > i.itime OR NVL(i.expid, 9999) > v.expid);

CREATE OR REPLACE FORCE VIEW "EXU10SNAPLU"("LOG_OWNER",
SELECT  "LOG_OWNER",
        FROM    sys.exu10snapl
        WHERE   log_ownerid = UID;

CREATE OR REPLACE FORCE VIEW "EXU10TAB"("OBJID",
SELECT  "OBJID",
        FROM    sys.exu10tabs t$
        WHERE   t$.secondaryobj = 0;

CREATE OR REPLACE FORCE VIEW "EXU10TABS"("OBJID",
SELECT
                o$.obj#, o$.dataobj#, o$.name, u$.name, o$.owner#, ts$.name,
                t$.ts#, t$.file#, t$.block#, t$.audit$, c$.comment$,
                NVL(t$.bobj#, 0), o$.mtime,
                DECODE(BITAND(t$.flags, 1), 1, 1, 0), NVL(t$.tab#, 0),
                MOD(t$.pctfree$, 100), t$.pctused$, t$.initrans, t$.maxtrans,
                NVL(t$.degree, 1), NVL(t$.instances, 1),
                DECODE(BITAND(t$.flags, 8), 8, 1, 0),
                MOD(TRUNC(o$.flags / 2), 2), t$.property,
                DECODE(BITAND(t$.flags, 32), 32, 1, 0), ts$.dflogging, o$.oid$,
                t$.spare1, DECODE(BITAND(o$.flags, 16), 16, 1, 0),
                NVL(t$.rowcnt, -1), NVL(t$.blkcnt, -1), NVL(t$.avgrln, -1),
                t$.flags, t$.trigflag, o$.status,
                (SELECT COUNT(*)
                    FROM sys.opqtype$ opq$
                    WHERE opq$.obj# = o$.obj# AND
                          BITAND(opq$.flags, 32) = 32 )
        FROM    sys.tab$ t$, sys.obj$ o$, sys.ts$ ts$, sys.user$ u$,
                sys.com$ c$
        WHERE   t$.obj# = o$.obj# AND
                t$.ts# = ts$.ts# AND
                u$.user# = o$.owner# AND
                o$.obj# = c$.obj#(+) AND
                c$.col#(+) IS NULL AND
                BITAND(o$.flags,128) != 128 AND      /* Skip recycle bin */
                BITAND(t$.property, 64+512) = 0 AND /*skip IOT and ovflw segs*/
                BITAND(t$.flags, 536870912) = 0    /* skip IOT mapping table */
      UNION ALL                                         /* Index-only tables */
        SELECT  o$.obj#, o$.dataobj#, o$.name, u$.name, o$.owner#, ts$.name,
                i$.ts#, t$.file#, t$.block#, t$.audit$, c$.comment$,
                NVL(t$.bobj#, 0), o$.mtime,
                DECODE(BITAND(t$.flags, 1), 1, 1, 0),
                NVL(t$.tab#, 0), 0, 0, 0, 0, 1, 1,
                DECODE(BITAND(t$.flags, 8), 8, 1, 0),
                MOD(TRUNC(o$.flags / 2), 2), t$.property,
                DECODE(BITAND(t$.flags, 32), 32, 1, 0), ts$.dflogging, o$.oid$,
                t$.spare1, DECODE(BITAND(o$.flags, 16), 16, 1, 0),
                NVL(t$.rowcnt, -1), NVL(t$.blkcnt, -1), NVL(t$.avgrln, -1),
                t$.flags, t$.trigflag, o$.status,
                (SELECT COUNT(*)
                    FROM sys.opqtype$ opq$
                    WHERE opq$.obj# = o$.obj# AND
                          BITAND(opq$.flags, 32) = 32 )
        FROM    sys.tab$ t$, sys.obj$ o$, sys.ts$ ts$, sys.user$ u$,
                sys.com$ c$, sys.ind$ i$
        WHERE   t$.obj# = o$.obj# AND
                u$.user# = o$.owner# AND
                o$.obj# = c$.obj#(+) AND
                c$.col#(+) IS NULL AND
                BITAND(o$.flags,128) != 128 AND      /* Skip recycle bin */
                BITAND(t$.property, 64+512) = 64 AND /* IOT, but not overflow*/
                t$.pctused$ = i$.obj# AND/* For IOTs, pctused has index obj# */
                i$.ts# = ts$.ts#;

CREATE OR REPLACE FORCE VIEW "EXU10TABSU"("OBJID",
SELECT  "OBJID",
        FROM    sys.exu10tabs
        WHERE   ownerid = UID;

CREATE OR REPLACE FORCE VIEW "EXU10TABU"("OBJID",
SELECT  "OBJID",
        FROM    sys.exu10tab
        WHERE   ownerid = UID;

CREATE OR REPLACE FORCE VIEW "EXU816CTX"("CTXNAME",
SELECT  o$.name, c$.schema, c$.package, c$.flags
        FROM    sys.exu81obj o$, sys.context$ c$
        WHERE   o$.type# = 44 AND
                o$.obj# = c$.obj#;

CREATE OR REPLACE FORCE VIEW "EXU816MAXSQV"("VERSION#",
SELECT  sv.version#, sv.sql_version
        FROM    sys.sql_version$ sv
        WHERE   sv.version# = (
                    SELECT  MAX(sv2.version#)
                    FROM    sys.sql_version$ sv2);

CREATE OR REPLACE FORCE VIEW "EXU816SQV"("VERSION#",
SELECT  sv."VERSION#",sv."SQL_VERSION"
        FROM    sys.sql_version$ sv
        WHERE   sv.version# < (
                    SELECT  m.version#
                    FROM    sys.exu816maxsqv m);

CREATE OR REPLACE FORCE VIEW "EXU816TCTX"("COLS") AS 
SELECT  cols
        FROM    sys.tab$ t, sys.obj$ o
        WHERE   t.obj# = o.obj# AND
                o.name = 'CONTEXT$' AND
                o.type# = 2 AND
                o.owner# = 0;

CREATE OR REPLACE FORCE VIEW "EXU816TGR"("OWNERID",
SELECT  o.owner#, u.name, t.baseobject, t.definition, t.whenclause,
                t.action#, t.enabled, t.property, o.name,
                DECODE(BITAND(t.property, 24), 0, (
                    SELECT  o2.name
                    FROM    sys.exu81obj o2
                    WHERE   t.baseobject = o2.obj#), ''),
                DECODE(BITAND(t.property, 24), 0, (
                    SELECT  o2.type#
                    FROM    sys.exu81obj o2
                    WHERE   t.baseobject = o2.obj#), 0),
                NVL((
                    SELECT  tb.property
                    FROM    sys.tab$ tb
                    WHERE   t.baseobject = tb.obj#), 0),
                NVL((
                    SELECT  ut.name
                    FROM    sys.user$ ut, sys.exu81obj o2
                    WHERE   t.baseobject = o2.obj# AND
                            o2.owner# = ut.user#), ''),
                NVL((
                    SELECT  ut.user#
                    FROM    sys.user$ ut, sys.exu81obj o2
                    WHERE   t.baseobject = o2.obj# AND
                            o2.owner# = ut.user#), 0),
                t.sys_evts,
                (   SELECT  sv.sql_version
                    FROM    sys.exu816sqv sv
                    WHERE   o.spare1 = sv.version#),
                t.actionsize
        FROM    sys.exu81obj o, sys.trigger$ t, sys.user$ u
        WHERE   o.obj# = t.obj# AND
                u.user# = o.owner#;

CREATE OR REPLACE FORCE VIEW "EXU816TGRC"("OWNERID",
SELECT "OWNERID",
        FROM    sys.exu816tgr
        WHERE   (ownerid, basename) IN (
                    SELECT  ownerid, name
                    FROM    sys.exu81tabc)
      UNION ALL
        SELECT  "OWNERID",
        FROM    sys.exu816tgr
        WHERE   (ownerid, basename) IN (
                    SELECT  ownerid, name
                    FROM    sys.exu8vinfc);

CREATE OR REPLACE FORCE VIEW "EXU816TGRI"("OWNERID",
SELECT  "OWNERID",
        FROM    sys.exu816tgr
        WHERE   (ownerid, basename) IN (
                    SELECT  ownerid, name
                    FROM    sys.exu81tabi)
      UNION ALL
        SELECT  "OWNERID",
        FROM    sys.exu816tgr
        WHERE   (ownerid, basename) IN (
                    SELECT  ownerid, name
                    FROM    sys.exu8vinfi);

CREATE OR REPLACE FORCE VIEW "EXU816TGRIC"("OWNERID",
SELECT  "OWNERID",
        FROM    sys.exu816tgr
        WHERE   (ownerid, basename) IN (
                    SELECT  i.owner#, i.name
                    FROM    sys.incexp i, sys.incvid v
                    WHERE   i.expid > v.expid AND
                            i.type# IN (2, 4));

CREATE OR REPLACE FORCE VIEW "EXU816TGRU"("OWNERID",
SELECT  "OWNERID",
        FROM    sys.exu816tgr
        WHERE   UID = ownerid;

CREATE OR REPLACE FORCE VIEW "EXU81ACTIONOBJ"("NAME",
SELECT  oa.name, oa.objid, oa.owner, oa.ownerid, oa.property,
                oa.type#, oa.level#, oa.package, oa.pkg_schema
        FROM    sys.exu9actionobj oa
        WHERE   oa.class = 3;

CREATE OR REPLACE FORCE VIEW "EXU81ACTIONPKG"("PACKAGE",
SELECT  package, schema, class, level#
        FROM    sys.exppkgact$;

CREATE OR REPLACE FORCE VIEW "EXU81APPROLE"("ROLE",
SELECT  u$.name, r$.schema, r$.package
        FROM    sys.user$ u$, sys.approle$ r$
        WHERE   u$.user# = r$.role#;

CREATE OR REPLACE FORCE VIEW "EXU81ASSOC"("OBJOWNER",
SELECT  ou$.name, oo$.owner#, a$.property, oo$.name, NVL(c$.name, ''),
                NVL(su$.name, ''), NVL(so$.name, ''),
                NVL(a$.default_selectivity, 0), NVL(a$.default_cpu_cost, 0),
                NVL(a$.default_io_cost, 0), NVL(a$.default_net_cost, 0)
        FROM    sys.association$ a$, sys.exu81obj oo$, sys.user$ ou$,
                sys.col$ c$, sys.obj$ so$, sys.user$ su$
        WHERE   a$.obj# = oo$.obj# AND
                oo$.owner# = ou$.user# AND
                a$.intcol# = c$.intcol# (+) AND
                a$.obj# = c$.obj# (+) AND
                a$.statstype# = so$.obj# (+) AND
                so$.owner# = su$.user# (+) AND
                (UID IN (0, oo$.owner#) OR
                 EXISTS (
                    SELECT  role
                    FROM    sys.session_roles
                    WHERE   role = 'SELECT_CATALOG_ROLE'));

CREATE OR REPLACE FORCE VIEW "EXU81CSC"("RELEASE") AS 
SELECT  '8.1.0.0.0'
        FROM    DUAL;

CREATE OR REPLACE FORCE VIEW "EXU81CTX"("CTXNAME",
SELECT  o$.name, c$.schema, c$.package, o$.obj#
        FROM    sys.exu81obj o$, sys.context$ c$
        WHERE   o$.type# = 44 AND                                 /* context */
                o$.obj# = c$.obj#;

CREATE OR REPLACE FORCE VIEW "EXU81DOI"("IOBJID",
SELECT  "IOBJID",
        FROM    sys.exu9doi
        WHERE   diversion = 1;

CREATE OR REPLACE FORCE VIEW "EXU81DOIU"("IOBJID",
SELECT  "IOBJID",
        FROM    sys.exu81doi
        WHERE   iownerid = UID;

CREATE OR REPLACE FORCE VIEW "EXU81FIL"("FNAME",
SELECT  f.fname,
                NVL2(f.fsize, DECODE(f.fsize, -1, -1,
                    CEIL(f.fsize * ((
                    SELECT  t1$.blocksize
                    FROM    sys.ts$ t1$
                    WHERE   t1$.ts# = f.tsid) / (
                    SELECT  t0$.blocksize
                    FROM    sys.ts$ t0$
                    WHERE   t0$.ts# = 0)))), NULL),
                NVL2(f.maxextend, CEIL(f.maxextend * ((
                    SELECT  t1$.blocksize
                    FROM    sys.ts$ t1$
                    WHERE   t1$.ts# = f.tsid) / (
                    SELECT  t0$.blocksize
                    FROM    sys.ts$ t0$
                    WHERE   t0$.ts# = 0))), NULL),
                NVL2(f.inc, CEIL(f.inc * ((
                    SELECT  t1$.blocksize
                    FROM    sys.ts$ t1$
                    WHERE   t1$.ts# = f.tsid) / (
                    SELECT  t0$.blocksize
                    FROM    sys.ts$ t0$
                    WHERE t0$.ts# = 0))), NULL),
                f.tsid, f.bitmap
        FROM    sys.exu9fil f;

CREATE OR REPLACE FORCE VIEW "EXU81IND"("IOBJID",
SELECT  "IOBJID",
        FROM    sys.exu9ind
        WHERE   sysgenconst = 0 AND
                BITAND(property, 1) = 0 OR                     /* not unique */
                NOT EXISTS (
                    SELECT  *
                    FROM    sys.con$ c$, sys.cdef$ cd$
                    WHERE   c$.name = iname AND   /* same name as constraint */
                            c$.owner# = iownerid AND
                            c$.con# = cd$.con# AND
                            NVL(cd$.enabled, 0) = iobjid AND  /* cons enable */
                            ((BITAND(cd$.defer, 8) = 8)))       /* sys gen'd */;

CREATE OR REPLACE FORCE VIEW "EXU81INDC"("IOBJID",
SELECT  "IOBJID",
        FROM    sys.exu81ind
        WHERE   sysgenconst = 0 AND                /* not sys gen constraint */
                (bitmap = 1 OR                             /* select bitmap, */
                 BITAND(property, 16) = 16 OR                 /* functional, */
                 type = 9) AND                         /* and domain indexes */
                (iownerid, btname) IN ((
                    SELECT  ownerid, name
                    FROM    sys.exu81tabc)
                  UNION (
                    SELECT  r.ownerid, r.tname
                    FROM    sys.exu81tabc cc, sys.exu8ref r
                    WHERE   r.robjid = cc.objid))   /* table included in cum */;

CREATE OR REPLACE FORCE VIEW "EXU81INDI"("IOBJID",
SELECT  "IOBJID",
        FROM    sys.exu81ind
        WHERE   sysgenconst = 0 AND                /* not sys gen constraint */
                (bitmap = 1 OR                             /* select bitmap, */
                 BITAND(property, 16) = 16 OR                 /* functional, */
                 type = 9) AND                         /* and domain indexes */
                (iownerid, btname) IN ((
                    SELECT  ownerid, name
                    FROM    sys.exu81tabi)
                  UNION (
                    SELECT  r.ownerid, r.tname
                    FROM    sys.exu9tabi ii, sys.exu8ref r
                    WHERE   r.robjid = ii.objid))   /* table included in inc */;

CREATE OR REPLACE FORCE VIEW "EXU81INDIC"("IOBJID",
SELECT  "IOBJID",
        FROM    sys.exu9indic;

CREATE OR REPLACE FORCE VIEW "EXU81IND_BASE"("IOBJID",
SELECT  "IOBJID",
        FROM    sys.exu9ind_base
        WHERE   sysgenconst = 0;

CREATE OR REPLACE FORCE VIEW "EXU81ITY"("NAME",
SELECT  o.name, o.obj#, u.name, o.owner#
        FROM    sys.exu81obj o, sys.user$ u, sys.indtypes$ i
        WHERE   o.obj# = i.obj# AND
                o.owner# = u.user#;

CREATE OR REPLACE FORCE VIEW "EXU81ITYC"("NAME",
SELECT  it."NAME",it."OBJID",it."OWNER",it."OWNERID"
        FROM    sys.exu81ity it, sys.incexp i, sys.incvid v
        WHERE   it.name = i.name(+) AND
                it.ownerid = i.owner#(+) AND
                NVL(i.type#, 32) = 32 AND
                (NVL(i.ctime, TO_DATE('01-01-1900', 'DD-MM-YYYY')) < i.itime OR
                 v.expid < NVL(i.expid, 9999));

CREATE OR REPLACE FORCE VIEW "EXU81ITYI"("NAME",
SELECT  it."NAME",it."OBJID",it."OWNER",it."OWNERID"
        FROM    sys.exu81ity it, sys.incexp i, sys.incvid v
        WHERE   it.name = i.name(+) AND
                it.ownerid = i.owner#(+) AND
                NVL(i.type#, 32) = 32 AND
                v.expid < NVL(i.expid, 9999);

CREATE OR REPLACE FORCE VIEW "EXU81ITYU"("NAME",
SELECT  "NAME",
        FROM    sys.exu81ity
        WHERE   ownerid = UID;

CREATE OR REPLACE FORCE VIEW "EXU81IXCP"("OBJID",
SELECT  p.objid, p.dobjid, p.bobjid, p.ownerid, p.compname, p.partno,
                p.hiboundlen, p.hiboundval, p.prowcnt, p.pblkcnt, p.pavgrlen,
                p.tsname, p.pctfree$, p.pctused$, p.initrans, p.maxtrans,
                CEIL(p.iniexts * (p.blocksize / (
                    SELECT  t$.blocksize
                    FROM    sys.ts$ t$
                    WHERE   t$.ts# = 0))),
                CEIL(p.extsize * (p.blocksize / (
                    SELECT  t$.blocksize
                    FROM    sys.ts$ t$
                    WHERE   t$.ts# = 0))),
                p.minexts, p.maxexts, p.extpct, p.flists, p.freegrp, p.pcache,
                p.deflog, p.tsdeflog, p.blevel, p.leafcnt, p.distkey,
                p.lblkkey, p.dblkkey, p.clufac
        FROM    sys.exu9ixcp p;

CREATE OR REPLACE FORCE VIEW "EXU81IXCPU"("OBJID",
SELECT  "OBJID",
        FROM    sys.exu81ixcp
        WHERE   ownerid = UID;

CREATE OR REPLACE FORCE VIEW "EXU81IXSP"("OBJID",
SELECT  o.obj#, o.dataobj#, isp.pobj#, o.owner#, isp.subpart#,
                o.subname, ts.name, isp.file#, isp.block#, isp.ts#,
                NVL(isp.rowcnt, -1), -1, -1, NVL(isp.blevel, -1),
                NVL(isp.leafcnt, -1), NVL(isp.distkey, -1),
                NVL(isp.lblkkey, -1), NVL(isp.dblkkey, -1),
                NVL(isp.clufac, -1), isp.hiboundlen, isp.hiboundval
        FROM    sys.obj$ o, sys.indsubpart$ isp, sys.ts$ ts
        WHERE   o.type# = 35 AND
                isp.obj# = o.obj# AND
                ts.ts# = isp.ts#;

CREATE OR REPLACE FORCE VIEW "EXU81IXSPU"("OBJID",