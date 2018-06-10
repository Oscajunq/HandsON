conn TZFWNC@DBACEH

grant advisor to PRODISSR;
GRANT dba     TO PRODISSR;

SELECT *
FROM dba_advisor_usage
ORDER BY last_exec_time;

conn PRODISSR/SURCARD@DBACEH

SELECT task_name
FROM dba_advisor_tasks
WHERE owner = 'PRODISSR';

col startup_time format a30

SELECT snap_id, startup_time
FROM dba_hist_snapshot
ORDER BY 1,2;

set serveroutput on

-- This will fail: Watch the error 
DECLARE
 task_id   NUMBER;
 task_name VARCHAR2(30) := 'TAREFA QUERY';
 wkld_name VARCHAR2(30) := 'AREA TAREFA QUERY';
BEGIN
  dbms_advisor.create_task(dbms_advisor.sqlaccess_advisor, task_id, task_name);

  dbms_output.put_line(task_id);

  dbms_advisor.set_task_parameter('TAREFA QUERY', 'START_SNAPSHOT', 999);
  dbms_advisor.set_task_parameter('TAREFA QUERY', 'END_SNAPSHOT', 1013);
  dbms_advisor.set_task_parameter('TAREFA QUERY', 'INSTANCE', 1);
  dbms_advisor.create_sqlwkld(wkld_name, 'AREA TAREFA QUERY');
  dbms_advisor.add_sqlwkld_ref(task_name, wkld_name);
  dbms_advisor.add_sqlwkld_statement(wkld_name, 'MONTHLY', 'ROLLUP',100, 400, 5041, 103, 640445, 680000, 2, 1, SYSDATE,  1, 'PRODISSR', 'SELECT MAX (wm.documento) FROM PRODISSR.wfq_info_adicional wia, PRODISSR.wfq_mensajes wm WHERE wm.id_mensaje = wia.id_mensaje  AND (wm.cod_queue = 29 OR wm.cod_queue = 91) AND wia.id_transaccion = 0');
/****
  dbms_advisor.add_sqlwkld_statement('To Delete', 'WEEKLY', 'ROLLUP',100, 400, 5041, 103, 640445, 680000, 2, 1, SYSDATE,  1, 'PRODISSR', 'SELECT MAX (wm.documento) FROM PRODISSR.wfq_info_adicional wia, PRODISSR.wfq_mensajes wm WHERE wm.id_mensaje = wia.id_mensaje  AND (wm.cod_queue = 29 OR wm.cod_queue = 91) AND wia.id_transaccion = 0');
  dbms_advisor.update_sqlwkld_statement('To Delete', DBMS_ADVISOR.ADVISOR_ALL, ADVISOR_UNUSED, NULL, 3);
  dbms_advisor.delete_sqlwkld_statement('To Delete', DBMS_ADVISOR.ADVISOR_ALL);
****/ 
  dbms_advisor.execute_task('TAREFA QUERY');
END;
/  

-- grant the missing privilege

DECLARE
 task_id   NUMBER;
 task_name VARCHAR2(30) := 'TAREFA QUERY';
 wkld_name VARCHAR2(30) := 'AREA TAREFA QUERY';
BEGIN
  dbms_advisor.create_task(dbms_advisor.sqlaccess_advisor, task_id, task_name);

  dbms_output.put_line(task_id);

  dbms_advisor.set_task_parameter('TAREFA QUERY', 'START_SNAPSHOT', 999);
  dbms_advisor.set_task_parameter('TAREFA QUERY', 'END_SNAPSHOT', 1013);
  dbms_advisor.set_task_parameter('TAREFA QUERY', 'INSTANCE', 1);
  dbms_advisor.create_sqlwkld(wkld_name, 'AREA TAREFA QUERY');
  dbms_advisor.add_sqlwkld_ref(task_name, wkld_name);
  dbms_advisor.add_sqlwkld_statement(wkld_name, 'MONTHLY', 'ROLLUP', 100, 400, 5041, 103, 640445, 680000, 2, 1, SYSDATE, 1, 'PRODISSR', 'SELECT MAX (wm.documento) FROM PRODISSR.wfq_info_adicional wia, PRODISSR.wfq_mensajes wm WHERE wm.id_mensaje = wia.id_mensaje  AND (wm.cod_queue = 29 OR wm.cod_queue = 91) AND wia.id_transaccion = 0');

  dbms_advisor.execute_task('TAREFA QUERY');
END;
/ 

SELECT task_name
FROM dba_advisor_tasks
WHERE owner = 'PRODISSR';

-- retrieve the advisor defaults 

SET SERVEROUTPUT ON

DECLARE
 tname    VARCHAR2(30);
 tid      NUMBER;
 wkldname VARCHAR2(30);
 wkid     NUMBER;
BEGIN
  dbms_advisor.get_access_advisor_defaults(tname,tid,wkldname,wkid);
  dbms_output.put_line(tname);
  dbms_output.put_line(TO_CHAR(tid));
  dbms_output.put_line(wkldname);
  dbms_output.put_line(TO_CHAR(wkid));
END;
/ 

-- write the recommendations to a file
SELECT *
FROM all_directories;

conn TZFWNC@DBACEH

GRANT read, write ON DIRECTORY TMP_DATA_PUMP TO PRODISSR;

conn PRODISSR/SURCARD@DBACEH

SET serveroutput ON

DECLARE
 buf CLOB;
BEGIN
  buf := dbms_advisor.get_task_script('TAREFA QUERY');
  dbms_output.put_line(buf);

  dbms_advisor.create_file(buf, 'TMP_DATA_PUMP', 'advisor_create_file.txt');
END;
/ 

-- retrieve the "NAME" attribute from the task 
DECLARE
 val VARCHAR2(100);
BEGIN
  dbms_advisor.get_rec_attributes('TAREFA QUERY', 1, 1, 'NAME', val);
  dbms_output.put_line(val);
END;
/  

SELECT object_name, object_type
FROM user_objects
WHERE object_type LIKE 'MAT%';

-- this is what makes it worth the wait
SELECT rec_id, type, rank, benefit, annotation_status
FROM user_advisor_recommendations;

exec dbms_advisor.implement_task('TAREFA QUERY', 1, FALSE);

SELECT object_name, object_type
FROM user_objects
WHERE object_type LIKE 'MAT%';

desc dba_advisor_tasks

SELECT task_name
FROM dba_advisor_tasks
ORDER BY 1;

exec dbms_advisor.delete_task('TAREFA QUERY'); 

conn tzfwnc@dbaceh

REVOKE advisor FROM PRODISSR;
REVOKE dba     FROM PRODISSR;
REVOKE read, write DIRECTORY FROM PRODISSR;











------------------------ ************************************************************************* ----------------

Osmar,

Segue o teste que fiz em homologação:

DECLARE
  l_sql_tune_task_id  VARCHAR2(100);
BEGIN
  l_sql_tune_task_id := DBMS_SQLTUNE.create_tuning_task (
                          begin_snap  => 8182,
                          end_snap    => 8195,
                          sql_id      => '16tx8yr5fx5md',
                          scope       => DBMS_SQLTUNE.scope_comprehensive,
                          time_limit  => 60,
                          task_name   => '16tx8yr5fx5md_AWR_tuning_task',
                          description => 'Tuning task for statement 16tx8yr5fx5md in AWR.');
  DBMS_OUTPUT.put_line('l_sql_tune_task_id: ' || l_sql_tune_task_id);
END;

EXEC DBMS_SQLTUNE.execute_tuning_task(task_name => '16tx8yr5fx5md_AWR_tuning_task');

SET LONG 10000;
SET PAGESIZE 1000
SET LINESIZE 200
SELECT DBMS_SQLTUNE.report_tuning_task('16tx8yr5fx5md_AWR_tuning_task') AS recommendations FROM dual;
SET PAGESIZE 24



RECOMMENDATIONS
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GENERAL INFORMATION SECTION
-------------------------------------------------------------------------------
Tuning Task Name                  : 16tx8yr5fx5md_AWR_tuning_task
Scope                             : COMPREHENSIVE
Time Limit(seconds)               : 60
Completion Status                 : COMPLETED
Started at                        : 07/14/2008 13:28:41
Completed at                      : 07/14/2008 13:29:23
Number of SQL Profile Findings    : 1

-------------------------------------------------------------------------------
Schema Name: PRODISSR
SQL ID     : 16tx8yr5fx5md
SQL Text   : select NVL((sum((MC.IMPORTE_ML* (:"SYS_B_0"-(MC.CODIGO_OPERACION*
              :"SYS_B_1"))))+sum(((MC.IMPORTE_MR*
             (:"SYS_B_2"-(MC.CODIGO_OPERACION* :"SYS_B_3")))*
             C.COTIZACION))),:"SYS_B_4")   into :b1  from MOVTOS_CUENTAS MC
             ,CIERRES CI ,VALPAR_EMI_PROD VP ,RUBROS R ,CUENTAS C where
             (((((((((((((((((C.EMISOR=:b2 and C.PRODUCTO=:b3) and
             C.TIPO_DE_DOCUMENTO=:b4) and C.DOCUMENTO=:b5) and
             C.EMISOR=MC.EMISOR) and C.SUCURSAL_EMISOR=MC.SUCURSAL_EMISOR)
             and C.PRODUCTO=MC.PRODUCTO) and C.NUMERO_CUENTA=MC.NUMERO_CUENTA)
              and MC.PERIODO_CIERRE>CI.ULTIMO_PERIODO_CERRADO) and
             MC.FECHA_VALOR between :b6 and :b7) and C.EMISOR=CI.EMISOR) and
             C.PRODUCTO=CI.PRODUCTO) and C.CIERRE=CI.CIERRE) and
             C.EMISOR=VP.EMISOR) and C.PRODUCTO=VP.PRODUCTO) and
             VP.NOMBRE_PARAMETRO=:"SYS_B_5") and
             (MC.ORIGEN_INTERNO<>:"SYS_B_6" and  not
             (MC.ORIGEN_INTERNO=:"SYS_B_7" and R.TIPO_DE_RUBRO=VP.VALOR)))
             and MC.RUBRO=R.RUBRO)

-------------------------------------------------------------------------------
FINDINGS SECTION (1 finding)
-------------------------------------------------------------------------------

1- SQL Profile Finding (see explain plans section below)
--------------------------------------------------------
  A potentially better execution plan was found for this statement.

  Recommendation (estimated benefit: 95.56%)
  ------------------------------------------
  - Consider accepting the recommended SQL profile.
    execute dbms_sqltune.accept_sql_profile(task_name =>
            '16tx8yr5fx5md_AWR_tuning_task', replace => TRUE);

-------------------------------------------------------------------------------
EXPLAIN PLANS SECTION
-------------------------------------------------------------------------------

1- Original With Adjusted Cost
------------------------------
Plan hash value: 1364289626

---------------------------------------------------------------------------------------------------------------------
| Id  | Operation                          | Name                   | Rows  | Bytes |TempSpc| Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                   |                        |     1 |   120 |       |   588   (2)| 00:00:08 |
|   1 |  SORT AGGREGATE                    |                        |     1 |   120 |       |            |          |
|*  2 |   FILTER                           |                        |       |       |       |            |          |
|   3 |    NESTED LOOPS                    |                        |     1 |   120 |       |   588   (2)| 00:00:08 |
|   4 |     NESTED LOOPS                   |                        |     1 |   115 |       |   587   (2)| 00:00:08 |
|   5 |      MERGE JOIN                    |                        |     1 |    82 |       |   586   (2)| 00:00:08 |
|   6 |       SORT JOIN                    |                        |    15 |   765 |       |     5  (20)| 00:00:01 |
|   7 |        NESTED LOOPS                |                        |    15 |   765 |       |     4   (0)| 00:00:01 |
|   8 |         TABLE ACCESS BY INDEX ROWID| VALPAR_EMI_PROD        |     1 |    40 |       |     2   (0)| 00:00:01 |
|*  9 |          INDEX UNIQUE SCAN         | PK_VALPAR_ISS_PROD     |     1 |       |       |     1   (0)| 00:00:01 |
|  10 |         TABLE ACCESS BY INDEX ROWID| CIERRES                |    15 |   165 |       |     2   (0)| 00:00:01 |
|* 11 |          INDEX RANGE SCAN          | PK_CIERRES             |     5 |       |       |     1   (0)| 00:00:01 |
|* 12 |       SORT JOIN                    |                        | 65242 |  1975K|  7688K|   581   (2)| 00:00:07 |
|* 13 |        TABLE ACCESS BY INDEX ROWID | MOVTOS_CUENTAS         | 65242 |  1975K|       |    18   (0)| 00:00:01 |
|* 14 |         INDEX SKIP SCAN            | MOVTOS_CUENTAS_IDX_001 |    14 |       |       |     9   (0)| 00:00:01 |
|* 15 |      TABLE ACCESS BY INDEX ROWID   | CUENTAS                |     1 |    33 |       |     1   (0)| 00:00:01 |
|* 16 |       INDEX UNIQUE SCAN            | PK_CUENTAS             |     1 |       |       |     0   (0)| 00:00:01 |
|* 17 |     TABLE ACCESS BY INDEX ROWID    | RUBROS                 |     1 |     5 |       |     1   (0)| 00:00:01 |
|* 18 |      INDEX UNIQUE SCAN             | PK_RUBROS              |     1 |       |       |     0   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   2 - filter(:B6<=:B7)
   9 - access("VP"."EMISOR"=:B2 AND "VP"."PRODUCTO"=:B3 AND "VP"."NOMBRE_PARAMETRO"=:SYS_B_5)
  11 - access("CI"."EMISOR"=:B2 AND "CI"."PRODUCTO"=:B3)
  12 - access("MC"."PERIODO_CIERRE">"CI"."ULTIMO_PERIODO_CERRADO")
       filter("MC"."PERIODO_CIERRE">"CI"."ULTIMO_PERIODO_CERRADO")
  13 - filter("MC"."ORIGEN_INTERNO"<>:SYS_B_6)
  14 - access("MC"."FECHA_VALOR">=:B6 AND "MC"."EMISOR"=:B2 AND "MC"."PRODUCTO"=:B3 AND
              "MC"."FECHA_VALOR"<=:B7)
       filter("MC"."PRODUCTO"=:B3 AND "MC"."EMISOR"=:B2)
  15 - filter("C"."DOCUMENTO"=:B5 AND "C"."TIPO_DE_DOCUMENTO"=:B4 AND "C"."CIERRE"="CI"."CIERRE")
  16 - access("C"."EMISOR"=:B2 AND "C"."SUCURSAL_EMISOR"="MC"."SUCURSAL_EMISOR" AND "C"."PRODUCTO"=:B3 AND
              "C"."NUMERO_CUENTA"="MC"."NUMERO_CUENTA")
  17 - filter("MC"."ORIGEN_INTERNO"<>:SYS_B_7 OR "R"."TIPO_DE_RUBRO"<>"VP"."VALOR")
  18 - access("MC"."RUBRO"="R"."RUBRO")

2- Using SQL Profile
--------------------
Plan hash value: 1639136978

------------------------------------------------------------------------------------------------------------
| Id  | Operation                         | Name                   | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT                  |                        |     1 |   120 |    26   (4)| 00:00:01 |
|   1 |  SORT AGGREGATE                   |                        |     1 |   120 |            |          |
|*  2 |   FILTER                          |                        |       |       |            |          |
|   3 |    NESTED LOOPS                   |                        |     1 |   120 |    26   (4)| 00:00:01 |
|   4 |     NESTED LOOPS                  |                        |     1 |   109 |    25   (4)| 00:00:01 |
|*  5 |      HASH JOIN                    |                        |     1 |    76 |    24   (5)| 00:00:01 |
|   6 |       NESTED LOOPS                |                        |     1 |    45 |     5   (0)| 00:00:01 |
|   7 |        TABLE ACCESS BY INDEX ROWID| VALPAR_EMI_PROD        |     1 |    40 |     2   (0)| 00:00:01 |
|*  8 |         INDEX UNIQUE SCAN         | PK_VALPAR_ISS_PROD     |     1 |       |     1   (0)| 00:00:01 |
|   9 |        TABLE ACCESS FULL          | RUBROS                 |   407 |  2035 |     3   (0)| 00:00:01 |
|* 10 |       TABLE ACCESS BY INDEX ROWID | MOVTOS_CUENTAS         | 65242 |  1975K|    18   (0)| 00:00:01 |
|* 11 |        INDEX SKIP SCAN            | MOVTOS_CUENTAS_IDX_001 |    14 |       |     9   (0)| 00:00:01 |
|* 12 |      TABLE ACCESS BY INDEX ROWID  | CUENTAS                |     1 |    33 |     1   (0)| 00:00:01 |
|* 13 |       INDEX UNIQUE SCAN           | PK_CUENTAS             |     1 |       |     0   (0)| 00:00:01 |
|* 14 |     TABLE ACCESS BY INDEX ROWID   | CIERRES                |     1 |    11 |     1   (0)| 00:00:01 |
|* 15 |      INDEX UNIQUE SCAN            | PK_CIERRES             |     1 |       |     0   (0)| 00:00:01 |
------------------------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   2 - filter(:B6<=:B7)
   5 - access("MC"."RUBRO"="R"."RUBRO")
       filter("MC"."ORIGEN_INTERNO"<>:SYS_B_7 OR "R"."TIPO_DE_RUBRO"<>"VP"."VALOR")
   8 - access("VP"."EMISOR"=:B2 AND "VP"."PRODUCTO"=:B3 AND "VP"."NOMBRE_PARAMETRO"=:SYS_B_5)
  10 - filter("MC"."ORIGEN_INTERNO"<>:SYS_B_6)
  11 - access("MC"."FECHA_VALOR">=:B6 AND "MC"."EMISOR"=:B2 AND "MC"."PRODUCTO"=:B3 AND
              "MC"."FECHA_VALOR"<=:B7)
       filter("MC"."PRODUCTO"=:B3 AND "MC"."EMISOR"=:B2)
  12 - filter("C"."DOCUMENTO"=:B5 AND "C"."TIPO_DE_DOCUMENTO"=:B4)
  13 - access("C"."EMISOR"=:B2 AND "C"."SUCURSAL_EMISOR"="MC"."SUCURSAL_EMISOR" AND
              "C"."PRODUCTO"=:B3 AND "C"."NUMERO_CUENTA"="MC"."NUMERO_CUENTA")
  14 - filter("MC"."PERIODO_CIERRE">"CI"."ULTIMO_PERIODO_CERRADO")
  15 - access("CI"."EMISOR"=:B2 AND "CI"."PRODUCTO"=:B3 AND "C"."CIERRE"="CI"."CIERRE")

-------------------------------------------------------------------------------


SQL>


Mônica Mariano 
DBA Services 
EDS Brasil - LA South HUB Data Center  
ABC Plaza 55-11-3215-3211 
mailto:monica.mariano@eds.com 



_____________________________________________ 
From: 	Junqueira, Osmar  
Sent:	Monday, July 14, 2008 1:06 PM
To:	Mariano, Monica
Subject:	Sql advisor

 << File: dbms_sqltune_2_ingles.sql >> 

Osmar Cavanha Junqueira
EDS - Application - BSC - Ways of Payment - Cards Utility - ACE
+55-11 4399-7851

