--
-- PACOTE QUICK_TUNE DO ADVISOR SERVE PARA ANALISE DE QUERY SIMPLES DE ATE TRES ATRIBUTOS SIMPLES
--
--
-- ANALISANDO A ESTRUTURA DA TABELA DE TEMPLATES
--
desc dba_advisor_templates

--
-- VERIFICANDO A QUAIS AS DESCRICOES DAS TAREFAS QUE SERAO REALIZADAS PELO ADVISOR
--
set linesize 131
col task_name format a10
col description format a50

SELECT task_name, description
FROM dba_advisor_templates;


--
-- VERIFICANDO A EXISTENCIA DE SUGESTAO REGISTRADA PARA UMA DETERMINADA TAREFA (QUERY)
-- 
desc dba_advisor_journal

SELECT COUNT(*)
FROM dba_advisor_journal;

--
-- EXECUTANDO O PACOTE PARA PREENCHER AS SUGESTAO A SEREM APLICADAS PELO ADVISOR
--
DECLARE
 task_name VARCHAR2(30) := 'TAREFA QUERY';
BEGIN 
  dbms_advisor.quick_tune(dbms_advisor.sqlaccess_advisor, task_name,
  'SELECT MAX (wm.documento) FROM PRODISSR.wfq_info_adicional wia, PRODISSR.wfq_mensajes wm WHERE wm.id_mensaje = wia.id_mensaje AND (wm.cod_queue = 29 OR wm.cod_queue = 91) AND wia.id_transaccion = 0');
END;
/

--
-- VERIFICANDO A QUANTIDADE DE FASES DE ANALISE REGISTRADA PARA UMA DETERMINADA TAREFA (QUERY)
-- 
SELECT COUNT(*)
FROM dba_advisor_journal;

--
-- VERIFICANDO QUAIS AS FASES QUE FORAM REGISTRADA PARA UMA DETERMINADA TAREFA (QUERY)
-- 
desc dba_advisor_journal

col journal_entry format a65

SELECT task_name, journal_entry_type, journal_entry
FROM dba_advisor_journal
WHERE task_name = 'TAREFA QUERY';

--
-- VERIFICANDO SE EXISTEM RECOMENDACOES DO ADVISOR REGISTRADA PARA UMA DETERMINADA TAREFA (QUERY)
-- 
desc dba_advisor_recommendations

-- Grid Control recommends the actions be accepted 
SELECT type, rank, benefit, annotation_status
FROM dba_advisor_recommendations
WHERE task_name = 'TAREFA QUERY';

--
-- A PARTIR DO MOMENTO QUE ESTA REGISTRADO UMA RECOMENDACAO ACEITAVEL, VERIFICA QUAL É ESTA RECOMENDACAO
--
col command format a30
col attr1 format a20
col attr3 format a25
col attr4 format a20
col attr5 format a20
col attr6 format a20
col error_message format a15

desc dba_advisor_actions

-- VISUALIZAR AS ACOES DE RECOMENDACAO, TIPO CRIAR VIEWS MATERELIZADA, PASSAR ESTATISTICAS ETC....
SELECT command, attr1, attr3, attr4
FROM dba_advisor_actions
WHERE task_name = 'TAREFA QUERY';

set long 100000

-- VISUALIZAR UMA POSSIVEL QUERY DIFERENCIADA PARA ATENDER OU A QUINTA RECOMANDACAO SE EXISTIR COMBINADO COM AS DEMAIS
SELECT attr5
FROM dba_advisor_actions
WHERE task_name = 'TAREFA QUERY';

--
-- AVALIAR SE O ADVISOR COMPLETOU COM SUCESSO OS PROCESSOS DE ANALISE E SUGESTAO
desc dba_advisor_log

SELECT execution_start, execution_end, status, error_message
FROM dba_advisor_log
WHERE task_name = 'TAREFA QUERY';

--
-- AVALIAR QUAL O TIPO DE PACOTE E SE EXISTE O ATRIBUTO DE RECOMANDACAO A SER UTILIZADO PELO ADVISOR
--
desc dba_advisor_tasks

col description format a15
col adivsor_name format a15

SELECT description, advisor_name, created, status, recommendation_count,
source, how_created
FROM dba_advisor_tasks
WHERE task_name = 'TAREFA QUERY';

--
-- ELIMINAR A ANALISE DO ADVISOR
--
exec dbms_advisor.delete_task('TAREFA QUERY'); 




--
-- ABAIXO ESTA AS FORMAS POSSIVEIS DE TRABALHO DAS ACOES RECOMENDADAS
--

set autotrace on
--
-- QUERY ORIGINAL
--
SELECT MAX (wm.documento) FROM PRODISSR.wfq_info_adicional wia, PRODISSR.wfq_mensajes wm 
 WHERE wm.id_mensaje = wia.id_mensaje AND (wm.cod_queue = 29 OR wm.cod_queue = 91) AND wia.id_transaccion = 0

SELECT STATEMENT     |       |   1 |    9 | 177 (20)
SORT AGGREGATE       |       |   1 |    9 | 
PARTITION RANGE ALL  |       | 229K| 2018K| 177 (20)
TABLE ACCESS FULL    | SALES | 229K| 2018K| 177 (20)
----------------------------------------------------
Statistics
----------------------------------------------------
1 recursive calls
0 db block gets
1718 consistent gets
1647 physical reads
0 redo size
438 bytes sent via SQL*Net to client
385 bytes received via SQL*Net from client
2 SQL*Net roundtrips to/from client
0 sorts (memory)
0 sorts (disk)
1 rows processed

--
-- IMPLEMENTADO AS RECOMANDACOES DO ADVISOR
--
-- 
CREATE MATERIALIZED VIEW LOG   "PRODISSR"."WFQ_INFO ROWID, SEQUENCE            INCLUDING NEW VALUE
                               _ADICIONAL"                                    S

CREATE MATERIALIZED VIEW LOG   "PRODISSR"."WFQ_MENS ROWID, SEQUENCE            INCLUDING NEW VALUE
                               AJES"                                          S

CREATE MATERIALIZED VIEW       "TZFWNC"."MV$$_49420 REFRESH FAST WITH ROWID   ENABLE QUERY REWRITE
                               000"

GATHER TABLE STATISTICS        "TZFWNC"."MV$$_49420 -1
                               000"


CREATE MATERIALIZED VIEW PRODISSR.LOG_ADCIONAL ON WFQ_INFO_ADICIONAL WITH ROWID, SEQUENCE
("ID_MENSAJE","ID_TRANSACCION") INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW PRODISSR.LOG_MENSAJES ON "PRODISSR"."WFQ_MENSAJES" WITH ROWID, SEQUENCE
("ID_MENSAJE","COD_QUEUE","DOCUMENTO") INCLUDING NEW VALUES;

CREATE MATERIALIZED VIEW PRODISSR.demomv
BUILD IMMEDIATE
REFRESH FAST WITH ROWID
ENABLE QUERY REWRITE AS
SELECT PRODISSR.WFQ_MENSAJES.COD_QUEUE C1, 
       PRODISSR.WFQ_INFO_ADICIONAL.ID_TRANSACCION C2, 
       MAX("PRODISSR"."WFQ_MENSAJES"."DOCUMENTO") M1, COUNT(*) M2 
  FROM PRODISSR.WFQ_INFO_ADICIONAL, 
       PRODISSR.WFQ_MENSAJES 
 WHERE PRODISSR.WFQ_INFO_ADICIONAL.ID_MENSAJE = PRODISSR.WFQ_MENSAJES.ID_MENSAJE 
   AND (PRODISSR.WFQ_INFO_ADICIONAL.ID_TRANSACCION = 0) 
   AND (PRODISSR.WFQ_MENSAJES.COD_QUEUE IN (91, 29)) 
GROUP BY PRODISSR.WFQ_MENSAJES.COD_QUEUE, PRODISSR.WFQ_INFO_ADICIONAL.ID_TRANSACCION

-- gather table statistics
exec dbms_stats.gather_table_stats('PRODISSR', 'DEMOMV', NULL, dbms_stats.auto_sample_size, CASCADE=>TRUE);

SELECT MAX (wm.documento) FROM PRODISSR.wfq_info_adicional wia, PRODISSR.wfq_mensajes wm 
 WHERE wm.id_mensaje = wia.id_mensaje AND (wm.cod_queue = 29 OR wm.cod_queue = 91) AND wia.id_transaccion = 0

SELECT STATEMENT            |        | 1 | 16 | 2 (0)
SORT AGGREGATE              |        | 1 | 16 |      
MAT_VIEW REWRITE ACCESS FULL| DEMOMV | 1 | 16 | 2 (0)
-----------------------------------------------------
Statistics
-----------------------------------------------------
1 recursive calls
0 db block gets
2 consistent gets
0 physical reads
0 redo size
438 bytes sent via SQL*Net to client
385 bytes received via SQL*Net from client
2 SQL*Net roundtrips to/from client
0 sorts (memory)
0 sorts (disk)
1 rows processed 
