--
-- scripts para acompanhar as conexoes de reports existentes e o percentual de uso da tablespace temporaria
--
SET LINESIZE 2000
SET PAGESIZE 5000

ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY HH24:MI:SS';

SELECT SYSDATE AS "HORARIO DA VERIFICACAO" FROM DUAL
/

PROMPT AVALIA O REPORTS EM USO NO MOMENTO

SELECT SUBSTR(PROGRAM,1,15),SUBSTR(USERNAME,1,10), SID,serial#, LOCKWAIT, LOGON_TIME, SYSDATE, SQL_HASH_VALUE,AUDSID, CLIENT_INFO, COMMAND, LAST_CALL_ET, 
       MACHINE, MODULE, OSUSER, PADDR, PROCESS,  SCHEMANAME, SERIAL#,
       SERVER,  STATUS, TERMINAL, TYPE, ACTION,  FAILOVER_METHOD,
       FAILED_OVER, FAILOVER_TYPE, PDML_ENABLED, PDDL_STATUS, PDML_STATUS,
       PQ_STATUS, RESOURCE_CONSUMER_GROUP, SQL_CHILD_NUMBER
  FROM GV$SESSION S
 WHERE         (    (S.USERNAME IS NOT NULL)
            AND (NVL (S.OSUSER, 'X') <> 'SYSTEM')
            AND (S.TYPE <> 'BACKGROUND')
           ) AND UPPER(PROGRAM) LIKE 'RE%'
/

--
-- AVALIA OS ESPACOS DE TABLESPACE, INCLUSIVE A TABLESPACE TEMPORARIA
--
PROMPT AVALIA OS ESPACOS DE TABLESPACE, INCLUSIVE A TABLESPACE TEMPORARIA

SET ECHO     OFF
SET LINESIZE 100

CLEAR BREAKS COLUMNS COMPUTES

TTITLE LEFT 'Tablespace Usage (Mb & %) Information' SKIP 2

COLUMN abytes FORMAT 999,999,999 HEADING 'Allocated'
COLUMN ubytes FORMAT 999,999,999 HEADING 'Used'
COLUMN fbytes FORMAT 999,999,999 HEADING 'Free'
COLUMN uperct FORMAT 999.99 	 HEADING '% Used'
COLUMN fperct FORMAT 999.99 	 HEADING '% Free'

COMPUTE SUM LABEL "Totals (Mb)" OF abytes ubytes fbytes ON REPORT

BREAK ON REPORT

SELECT * FROM (
SELECT a.tablespace_name Tablespaces, 
       a.tsize                                         abytes,
       a.tsize - b.tsize                               ubytes,
       ROUND(100 * ((a.tsize - b.tsize) / a.tsize), 2) uperct,
       b.tsize                                         fbytes,
       ROUND((100 * b.tsize) / a.tsize, 2) 	       fperct
FROM (SELECT tablespace_name, ROUND((SUM(bytes) / 1024) / 1024, 0) tsize
      FROM dba_data_files
      GROUP BY tablespace_name
      UNION
      SELECT tablespace_name, ROUND((SUM(bytes) / 1024) / 1024, 0) tsize
      FROM dba_temp_files
      GROUP BY tablespace_name) a, 
     (SELECT tablespace_name, ROUND((SUM(bytes) / 1024) / 1024, 0) tsize
      FROM dba_free_space
      GROUP BY tablespace_name
      UNION
      SELECT tablespace_name, ROUND((SUM(bytes_free) / 1024) / 1024, 0) tsize
      FROM v$temp_space_header 
      GROUP BY tablespace_name) b
WHERE a.tablespace_name = b.tablespace_name(+))
WHERE Tablespaces = 'TEMP'
--ORDER BY fperct DESC 
/

prompt AVALIA O PERCENTUAL DE USO DA TABLESPACE NO MOMENTO
--
SELECT 1 AS INST_ID,D.TABLESPACE_NAME, NVL (a.BYTES / 1024 / 1024, 0) size_mb,
NVL (t.BYTES / 1024 / 1024, 0) used_mb,
ROUND (NVL (t.BYTES / a.BYTES * 100, 0), 2) AS percentual_em_uso
  FROM SYS.dba_tablespaces d,
      (SELECT tablespace_name, SUM (BYTES) BYTES
         FROM dba_temp_files
            GROUP BY tablespace_name) a,
               (SELECT INST_ID,
                       ss.tablespace_name,
                  SUM ((ss.used_blocks * ts.BLOCKSIZE)) BYTES
                  FROM gv$sort_segment ss, SYS.ts$ ts
                  WHERE inst_id = 1
                    and ss.tablespace_name = ts.NAME
                  GROUP BY INST_ID        ,
                           ss.tablespace_name) t
                  WHERE d.tablespace_name = a.tablespace_name(+)
                  AND d.tablespace_name = t.tablespace_name(+)
                  AND d.extent_management LIKE 'LOCAL'
                  AND d.CONTENTS LIKE 'TEMPORARY'
UNION ALL
SELECT 2 AS INST_ID,D.TABLESPACE_NAME, NVL (a.BYTES / 1024 / 1024, 0) size_mb,
NVL (t.BYTES / 1024 / 1024, 0) used_mb,
ROUND (NVL (t.BYTES / a.BYTES * 100, 0), 2) AS percentual_em_uso
  FROM SYS.dba_tablespaces d,
      (SELECT tablespace_name, SUM (BYTES) BYTES
         FROM dba_temp_files
            GROUP BY tablespace_name) a,
               (SELECT INST_ID,
                       ss.tablespace_name,
                  SUM ((ss.used_blocks * ts.BLOCKSIZE)) BYTES
                  FROM gv$sort_segment ss, SYS.ts$ ts
                  WHERE inst_id = 2
                    and ss.tablespace_name = ts.NAME
                  GROUP BY INST_ID        ,
                           ss.tablespace_name) t
                  WHERE d.tablespace_name = a.tablespace_name(+)
                  AND d.tablespace_name = t.tablespace_name(+)
                  AND d.extent_management LIKE 'LOCAL'
                  AND d.CONTENTS LIKE 'TEMPORARY'
/

SET LINESIZE 2000
SET PAGESIZE 5000

--
-- AVALIAR QUANTO TEMPO A QUERY IRAR DEMORAR O RETORNO
--   
PROMPT  AVALIAR QUANTO TEMPO A QUERY IRAR DEMORAR O RETORNO

SELECT   SID,
         DECODE (totalwork,
                 0, 0,
                 ROUND (100 * sofar / totalwork, 2)
                ) "Percent",
        substr(MESSAGE,1,60) "Message", start_time, elapsed_seconds, time_remaining
    FROM gv$session_longops
   WHERE (SID = 293 AND serial# = 16646)
ORDER BY SID   
/

SET LINESIZE 145
SET PAGESIZE 9999
SET VERIFY   off

COLUMN tablespace_name       FORMAT a15               HEAD 'Tablespace Name'
COLUMN username              FORMAT a15               HEAD 'Username'
COLUMN sid                   FORMAT 9999              HEAD 'SID'
COLUMN serial_id             FORMAT 99999999          HEAD 'Serial#'
COLUMN contents              FORMAT a9                HEAD 'Contents'
COLUMN extents               FORMAT 999,999           HEAD 'Extents'
COLUMN blocks                FORMAT 999,999           HEAD 'Blocks'
COLUMN bytes                 FORMAT 999,999,999       HEAD 'Bytes'
COLUMN segtype               FORMAT a12               HEAD 'Segment Type'

BREAK ON tablespace_name ON report
COMPUTE SUM OF extents   ON report
COMPUTE SUM OF blocks    ON report
COMPUTE SUM OF bytes     ON report


SELECT
    a.inst_id,
    b.tablespace          tablespace_name
  , a.username            username
  , a.sid                 sid
  , a.serial#             serial_id
  , b.contents            contents
  , b.segtype             segtype
  , b.extents             extents
  , b.blocks              blocks
  , (b.blocks * c.value)  bytes
FROM
    gv$session     a
  , gv$sort_usage  b
  , (select value from v$parameter
     where name = 'db_block_size') c
WHERE
      a.saddr = b.session_addr
/
