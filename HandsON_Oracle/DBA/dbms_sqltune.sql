--
-- primeiro definir variaveis no sqlplus
--
variable stmt_task VARCHAR2(64)

variable sts_task  VARCHAR2(64)
--
--
-- criar a query
--
EXEC :stmt_task := DBMS_SQLTUNE.CREATE_TUNING_TASK( -
  sql_text => 'SELECT MAX (wm.documento) FROM PRODISSR.wfq_info_adicional wia, PRODISSR.wfq_mensajes wm WHERE wm.id_mensaje = wia.id_mensaje  AND (wm.cod_queue = 29 OR wm.cod_queue = 91) AND wia.id_transaccion = 0');  
--
--
-- executar a query criada, para criar o relatorio de tunnig para ver qual a analise sugerida
--
EXEC DBMS_SQLTUNE.EXECUTE_TUNING_TASK(:stmt_task);
--
-- extrair o relatorio da query executada
--
--
     SET LONG 20000
     --
     -- lista complata de todas as informacoes, inclusive do plano de execucao
     --
     SELECT DBMS_SQLTUNE.REPORT_TUNING_TASK(:stmt_task) from dual;
     -- 
     -- lista apenas o resumo do relatorio
     --
     SELECT DBMS_SQLTUNE.REPORT_TUNING_TASK(:stmt_task, 'TEXT', 'TYPICAL', 'SUMMARY')
     FROM DUAL;
     --
     --
     -- lista apenas as principais alternativas a serem aplicadas
     --
     SELECT DBMS_SQLTUNE.REPORT_TUNING_TASK(:stmt_task, 'TEXT', 'TYPICAL', 'FINDINGS', 5) from dual;
     --
     --

--
-- exibir qual o codigo da tarefa criada
--
print stmt_task
--
-- CRIANDO UM PROFILE PARA A QUERY OTIMIZADA, DESDE QUE O OTIMIZADOR PEDIU PARA CRIAR
--
execute dbms_sqltune.accept_sql_profile(task_name => 'TASK_18865', name =>'wfq_message_profile',replace => TRUE);

--
--
-- ELIMINANDO O PROFILE DA QUERY OTIMIZADA
--
BEGIN
  dbms_sqltune.drop_sql_profile('wfq_message_profile', TRUE);
END;
/ 



--
-- para listar as tarefas criadas pelo sqltune
--
SELECT task_id, task_name, created, advisor_name, status
FROM dba_advisor_tasks
WHERE task_name LIKE 'TASK%';


--
-- listar os profiles criados das otimizacoes das querys
--
 SELECT * FROM  DBA_SQL_PROFILES;
--
 
 
 
      SELECT DBMS_SQLTUNE.REPORT_TUNING_TASK(:stmt_task) from dual;
      
      
      SELECT DBMS_SQLTUNE.SCRIPT_TUNING_TASK(:stmt_task) from dual;
      
--
-- QUERY PARA AVALIAR SE EXISTE PROBLEMA NA OTIMIZACAO
--      
select      a.execution_end,      b.type,      b.impact,     
            d.rank,     d.type,    
             'Message           : '||b.message MESSAGE,     'Command to correct: '||c.command COMMAND,     
             'Action Message    : '||c.message ACTION_MESSAGE 
from      dba_advisor_tasks a,     
          dba_advisor_findings b,     
          dba_advisor_actions c,      
          dba_advisor_recommendations d  
where     a.task_name = 'TASK_18734' 
  and     a.status='COMPLETED'    
  AND     a.task_id=b.task_id     
  and     a.task_id=c.task_id 
  and     a.task_id=d.task_id 
  and     b.finding_id=d.finding_id     
  and     a.task_id=c.task_id 
  and     d.rec_id=c.rec_id     
  
ORDER by b.impact, d.rank;