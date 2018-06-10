SET LINESIZE 2000
SET PAGESIZE 5000

ALTER SESSION SET NLS_DATE_FORMAT = 'DD/MM/YYYY HH24:MI:SS';
--
-- AVALIA SESSAO ATIVA DE DADOS
--
PROMPT  AVALIA SESSAO ATIVA DE DADOS EM RELACAO AOS PROGRAMS BATCH

SELECT SUBSTR(PROGRAM,1,15),SUBSTR(USERNAME,1,10), SID,serial#, LOCKWAIT, LOGON_TIME, SYSDATE, SQL_HASH_VALUE,AUDSID, CLIENT_INFO, COMMAND, LAST_CALL_ET, 
       MACHINE, MODULE, OSUSER, PADDR, PROCESS,  SCHEMANAME, SERIAL#,
       SERVER,  STATUS, TERMINAL, TYPE, ACTION,  FAILOVER_METHOD,
       FAILED_OVER, FAILOVER_TYPE, PDML_ENABLED, PDDL_STATUS, PDML_STATUS,
       PQ_STATUS, RESOURCE_CONSUMER_GROUP, SQL_CHILD_NUMBER
  FROM GV$SESSION S
 WHERE         (    (S.USERNAME IS NOT NULL)
            AND (NVL (S.OSUSER, 'X') <> 'SYSTEM')
            AND (S.TYPE <> 'BACKGROUND')
           ) AND UPPER(PROGRAM) LIKE 'ME%' OR  UPPER(PROGRAM) LIKE 'RE%'
/
--
-- AVALIAR QUAIS AS PROCEDURES, TRIGGERS E FUNCOES QUE ESTAO EM EXECUCAO NO MOMENTO
--
--
--PROMPT AVALIAR QUAIS AS PROCEDURES, TRIGGERS E FUNCOES QUE ESTAO EM EXECUCAO NO MOMENTO
--
--
--SELECT SUBSTR(GV$SESSION.PROGRAM,1,15),SUBSTR(GV$SESSION.USERNAME,1,10),
--       GV$SESSION.SID,
--       NVL(SERIAL#,0)                              "SERIAL",
--       LOGON_TIME, SYSDATE,
--       SUBSTR(OBJECT,1,15),
--       STATUS,
--       SCHEMANAME,
--       GV$SESSION.TYPE,
--       GV$ACCESS.TYPE,
--       MACHINE,
--       TO_CHAR(LOGON_TIME,'DD/MM/YYYY HH24:MI:SS') "LOGON_TIME"
--  FROM GV$SESSION,
--       GV$ACCESS 
--WHERE GV$SESSION.SID=GV$ACCESS.SID
--  AND STATUS = 'ACTIVE' 
--  AND GV$ACCESS.TYPE IN ('PROCEDURE','TRIGGER', 'FUNCTION');
   
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
    FROM v$session_longops
   WHERE (SID = 246 AND serial# = 49229)
ORDER BY SID   
/

--
-- A PARTIR DA SESSAO LOCALIZADA, AVALIAR O SQL RODANDO NO MOMENTO
--
--PROMPT  A PARTIR DA SESSAO LOCALIZADA, AVALIAR O SQL RODANDO NO MOMENTO
----
--SELECT   SUBSTR(sql_text,1,64),address,hash_value     
--    FROM gv$sqltext_with_newlines
--   WHERE address =
--            (SELECT DECODE (RAWTOHEX (sql_address),
--                            '00', prev_sql_addr,
--                            sql_address
--                           )
--               FROM gv$session
--              WHERE username = 'PRODISSR' AND SID = '246' AND SERIAL# = '49229')
--ORDER BY piece
----
--/
--
-- QUANTAS VEZES OCORREU A EXECUCAO DA QUERY
--   
PROMPT QUANTAS VEZES OCORREU A EXECUCAO DA QUERY

SELECT distinct a.SID,                                     
              b.CLASS,                            
       b.NAME, a.VALUE                            
  FROM gv$sesstat a, gv$statname b                
 WHERE (a.statistic# = b.statistic#) AND SID = 246
and name like '%execut%'  
/
                        

--
-- QUERY PARA AVALIAR SE EXISTE ESPERA PELO ORACLE
--
--PROMPT QUERY PARA AVALIAR SE EXISTE ESPERA PELO ORACLE
--
--SELECT ROWNUM, event, total_waits, total_timeouts, time_waited, average_wait,
--       max_wait, time_waited_micro
--  FROM gv$session_event
-- WHERE SID = 246
--/


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

TTITLE OFF

CLEAR BREAKS COLUMNS COMPUTES


--
-- PROCURAR EXISTENCIAS DE LOCKS
--
--PROMPT PROCURAR EXISTENCIAS DE LOCKS

--@C:\OSMAR\DBA\VER_UTIL_LOCK.sql 

--
-- AVALIAR O POSICIONAMENTO DA AREA DE UNDO
--  
--PROMPT AVALIAR O POSICIONAMENTO DA AREA DE UNDO
--
--SELECT   r.segment_name, r.tablespace_name, s.SID, s.serial#, s.username,
--         s.machine, t.status, t.cr_get, /*consistent gets*/ t.phy_io, /*physical io*/
--         t.used_ublk, /*Undo blocks used*/ t.noundo, /*Is a noundo transaction*/
--         SUBSTR (s.program, 1, 78) "COMMAND", s.username "DB User",
--         t.start_time, s.sql_address "Address", s.sql_hash_value "Sql Hash"
--    FROM SYS.v_$session s, SYS.v_$transaction t, SYS.dba_rollback_segs r
--   WHERE t.addr = s.taddr AND t.xidusn = r.segment_id
--ORDER BY t.start_time
--/


----
---- EXIBE AS 10 MAIORES QUERYS EXECUTADAS
----
--SET SERVEROUTPUT ON
--
--PROMPT EXIBE AS 10 MAIORES QUERYS EXECUTADAS
--
--DECLARE
--
--  CURSOR c_sql IS
--    SELECT Substr(a.sql_text,1,180) sql_text,
--           Trunc(a.disk_reads/Decode(a.executions,0,1,a.executions)) reads_per_execution, 
--           a.buffer_gets, 
--           a.disk_reads, 
--           a.executions, 
--           a.sorts,
--           a.address
--    FROM   v$sqlarea a
--    ORDER BY 2 DESC;
--    
--BEGIN
--
--  Dbms_Output.Enable(1800000);
--  
--  Dbms_Output.Put_Line(Rpad('SQL Text',180,' ') ||
--                       Lpad('Reads/Execution',16,' ') ||
--                       Lpad('Buffer Gets',12,' ') ||
--                       Lpad('Disk Reads',12,' ') ||
--                       Lpad('Executions',12,' ') ||
--                       Lpad('Sorts',12,' ') ||
--                       Lpad('Address',10,' '));
--  Dbms_Output.Put_Line(Rpad('-',180,'-') || ' ' ||
--                       Lpad('-',15,'-') || ' ' ||
--                       Lpad('-',11,'-') || ' ' ||
--                       Lpad('-',11,'-') || ' ' ||
--                       Lpad('-',11,'-') || ' ' ||
--                       Lpad('-',11,'-') || ' ' ||
--                       Lpad('-',9,'-'));
--  
--  << top_sql >>
--  FOR cur_rec IN c_sql LOOP
--    Dbms_Output.Put_Line(Rpad(cur_rec.sql_text,180,' ') ||
--                         Lpad(cur_rec.reads_per_execution,16,' ') ||
--                         Lpad(cur_rec.buffer_gets,12,' ') ||
--                         Lpad(cur_rec.disk_reads,12,' ') ||
--                         Lpad(cur_rec.executions,12,' ') ||
--                         Lpad(cur_rec.sorts,12,' ') ||
--                         Lpad(cur_rec.address,10,' '));
--    
--    IF c_sql%ROWCOUNT = 10 THEN
--      EXIT top_sql;
--    END IF;
--  END LOOP;
--  
--END;
--/  
