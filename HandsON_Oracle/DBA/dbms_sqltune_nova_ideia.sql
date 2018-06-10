--
-- primeiro definir variaveis no sqlplus
--
variable stmt_task VARCHAR2(64)

variable sts_task  VARCHAR2(64)
--
--
-- criar a query
--
DECLARE
  stmt_task    VARCHAR2(30);
BEGIN
  dbms_sqltune.create_sqlset('PRODISSR Set', 'Testar QUERY1', 'PRODISSR);
  --
  stmt_task := DBMS_SQLTUNE.CREATE_TUNING_TASK(sqlset_name=>'PRODISSR Set',
                                                 sql_text => 'SELECT    /* SQL_VERIFONE */ C.EMISOR EMISOR, 
                                                                        SUM(DECODE(R.TYPE_TO_INFORM,4,I.AMOUNT * (1 - (2 * I.OPERATION_CODE)), 0)) AS PROYECTADO
                                                               FROM     prodissr.CUENTAS C,
                                                                        prodissr.INTERESTS_BY_ACCOUNT I,
                                                                        (SELECT   I.ISSUER,
                                                                                  I.ISSUER_BRANCH,
                                                                                  I.PRODUCT,
                                                                                  I.ACCOUNT_NUMBER,
                                                                                  I.PERIOD,
                                                                                  I.ITEM,
                                                                                  I.CURRENCY_TYPE,
                                                                                  R.INTEREST_TYPE
                                                                         FROM     prodissr.INTERESTS_BY_ACCOUNT I,
                                                                                  prodissr.INTERESTS_ITEMS_TO_INFORM R
                                                                         WHERE    I.ISSUER = 1001
                                                                                  AND I.PROCESS_DATE = 20080310
                                                                                  AND I.ISSUER = R.ISSUER
                                                                                  AND I.PRODUCT = R.PRODUCT
                                                                                  AND I.ITEM = R.ITEM
                                                                                  AND I.CURRENCY_TYPE = R.CURRENCY_TYPE
                                                                                  AND R.INTEREST_TYPE NOT IN ('''J''','A','B','C','D','E')
                                                                                  AND R.TYPE_TO_INFORM IN (4,3)
                                                                         GROUP BY I.ISSUER,
                                                                                  I.ISSUER_BRANCH,
                                                                                  I.PRODUCT,
                                                                                  I.ACCOUNT_NUMBER,
                                                                                  I.PERIOD,
                                                                                  I.ITEM,
                                                                                  I.CURRENCY_TYPE,
                                                                                  R.INTEREST_TYPE) AUX,
                                                                        PRODISSR.INTERESTS_ITEMS_TO_INFORM R,
                                                                        PRODISSR.CALENDARIO_CIERRES CC
                                                               WHERE    I.ISSUER = AUX.ISSUER
                                                                        AND I.ISSUER_BRANCH = AUX.ISSUER_BRANCH
                                                                        AND I.PRODUCT = AUX.PRODUCT
                                                                        AND I.ACCOUNT_NUMBER = AUX.ACCOUNT_NUMBER
                                                                        AND I.CURRENCY_TYPE = AUX.CURRENCY_TYPE
                                                                        AND I.PERIOD = AUX.PERIOD
                                                                        AND I.PROCESS_DATE <= 20080310
                                                                        AND I.ISSUER = R.ISSUER
                                                                        AND I.PRODUCT = R.PRODUCT
                                                                        AND I.ITEM = R.ITEM
                                                                        AND R.INTEREST_TYPE <> 'J'
                                                                        AND R.TYPE_TO_INFORM IN (4,2,3)
                                                                        AND R.INTEREST_TYPE = AUX.INTEREST_TYPE
                                                                        AND C.EMISOR = I.ISSUER
                                                                        AND C.SUCURSAL_EMISOR = I.ISSUER_BRANCH
                                                                        AND C.PRODUCTO = I.PRODUCT
                                                                        AND C.NUMERO_CUENTA = I.ACCOUNT_NUMBER
                                                                        AND CC.EMISOR = C.EMISOR
                                                                        AND CC.PRODUCTO = C.PRODUCTO
                                                                        AND CC.CIERRE = C.CIERRE
                                                                        AND CC.PERIODO = AUX.PERIOD
                                                                   GROUP BY C.EMISOR');                                                                     
    DBMS_SQLTUNE.EXECUTE_TUNING_TASK(stmt_task);
    --
    dbms_output.put_line(ret_val);
END;
/
    
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