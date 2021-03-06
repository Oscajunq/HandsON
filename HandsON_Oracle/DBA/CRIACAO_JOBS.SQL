--
-- CRIANDO JOB NO BANCO DE DADOS PARA ATUALIZAR AOS DOMINGOS
-- ESTE JOB ESTA SENDO CRIADO PELO SQLPLUS EM UMA ESTACAO CLIENT EM ORACLE PORTUGUES
--
--
SET SERVEROUTPUT ON

ALTER SESSION SET NLS_DATE_FORMAT = 'MM/DD/YYYY HH24:MI:SS';

ALTER SESSION SET NLS_LANGUAGE='AMERICAN';

DECLARE
  X NUMBER;
BEGIN
  SYS.DBMS_JOB.SUBMIT
  ( job       => X 
   ,what      => 'SUPORTERJ.PR_EXP_CONTRATO_DIARIO;'
   ,next_date => to_date('07/26/2009 16:00:00','mm/dd/yyyy hh24:mi:ss')
   ,interval  => 'NEXT_DAY(TRUNC(SYSDATE), ''SUNDAY'')'
   ,no_parse  => FALSE
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Job Number is: ' || to_char(x));
COMMIT;
END;
/




UM BREVE DESCRITIVOS DE JOBS
------------------------------------------------------
***************************
***** dbms_job FORUM ******
***************************

Tenta assim o di�rio:

begin
  sys.dbms_job.submit(job = :job,
                      what = 'REP_REFRESH;',
                      interval = 'SYSDATE + 1/24');
  sys.dbms_job.broken(job = :job,
                      broken = true,
                      next_date = to_date('01-01-4000', 'dd-mm-yyyy'));
  commit;
end; 


- FAZ A ESTAT. TODOS OS DIAS 

declare
  x binary_integer;
begin
  dbms_job.submit(x,
                 'dbms_utility.analyze_schema(''XPTO'',''COMPUTE'');',
                 TRUNC(SYSDATE)+1,
                 'TRUNC(SYSDATE)+1');
  dbms_output.put_line(x);
end;

- Para o nao periodico � s� nao passar o terceiro parametro

******************************************************************
******************************************************************

SCHEDULANDO PROCESSOS NO ORACLE

O banco de dados Oracle possui um eficiente mecanismo para executar processos (batches/jobs) periodicamente, 
sem a necessidade de se utilizar a crontab do Unix ou o AT do Windows. 

Este processo utiliza-se do pacote DBMS_JOB, que possui algumas procedures que permitem agendar, modificar, executar, 
consultar, remover os processos (batches/jobs) dentro do banco de dados Oracle. 

Iniciando o processo 

Para utilizar o pacote DBMS_JOB, deve-se antes verificar alguns itens fundamentais. 

1.Se os par�metros abaixo est�o configurados no arquivo de configura��o do banco de dados (init.ora), caso eles n�o 
estejam configurados, segue abaixo uma sugest�o de configura��o: 

job_queue_processes = 2 
job_queue_interval = 60 

2.Tamb�m deve-se verificar se o pacote DBMS_JOB est� criado no banco de dados. Para cri�-lo deve-se executar o script 
�dbms_job.sql�, que encontra-se no $ORACLE_HOME/rdbms/admin (para o ambiente Unix ou Linux) e $ORACLE_HOME\RDBMS\admin 
(para o ambiente Windows). 

Para gerenciar os processos que est�o �schedulados� dentro do banco de dados existe uma view chamada DBA_JOBS. 

Abaixo segue a estrutura da view DBA_JOBS: 

Name Null? Type 
------------------------ -------- ------------------ 
JOB NOT NULL NUMBER 
LOG_USER NOT NULL VARCHAR2(30) 
PRIV_USER NOT NULL VARCHAR2(30) 
SCHEMA_USER NOT NULL VARCHAR2(30) 
LAST_DATE DATE 
LAST_SEC VARCHAR2(8) 
THIS_DATE DATE 
THIS_SEC VARCHAR2(8) 
NEXT_DATE NOT NULL DATE 
NEXT_SEC VARCHAR2(8) 
TOTAL_TIME NUMBER 
BROKEN VARCHAR2(1) 
INTERVAL NOT NULL VARCHAR2(200) 
FAILURES NUMBER 
WHAT VARCHAR2(4000) 
NLS_ENV VARCHAR2(4000) 
MISC_ENV RAW(32) 
INSTANCE NUMBER 

Para visualizar os jobs pode-se utilizar a query abaixo: 

SELECT JOB, 
SUBSTR(WHAT,1,35), 
NEXT_DATE, 
NEXT_SEC, 
BROKEN 
FROM DBA_JOBS; 


JOB SUBSTR(WHAT,1,35) NEXT_DATE NEXT_SEC B 
---------- ----------------------------------- --------- -------- - 
1 DBA.TESTE_001; 21-MAR-03 17:04:02 N 
2 DBA.TESTE_002; 21-MAR-03 17:28:13 N 
3 DBA.TESTE_003; 21-MAR-03 17:02:37 N 
4 DBA.TESTE_004; 26-MAR-03 08:00:00 N 

A seguir vamos descrever as funcionalidades das procedures que comp�em o pacote DBMS_JOB. 

As procedures e suas funcionalidades 

DBMS_JOB.SUBMIT => Esta procedure � utilizada para submeter um job na fila do banco de dados. 

Sintaxe: 
DBMS_JOB.SUBMIT ( JOB OUT BINARY_INTEGER, 
WHAT IN VARCHAR2, 
NEXT_DATE IN DATE DEFAULTSYSDATE, 
INTERVAL IN VARCHAR2 DEFAULT 'NULL', 
NO_PARSE IN BOOLEAN DEFAULT FALSE, 
INSTANCE IN BINARY_INTEGER DEFAULT ANY_INSTANCE, 
FORCE IN BOOLEAN DEFAULT FALSE); 

Job - Identifica o n�mero do job que ser� criado; 
what - Nome do c�digo PL/SQL que ser� executado; 
next_date - Pr�xima data em que o job ser� executado. O valor default � o SYSDATE; 
Interval - Fun��o que calcula o intervalo em que o job ser� executado. O valor default � NULO; 
no_parse - Se indicado como FALSE (valor default), o Oracle associa os �parses� da procedure ao job. Se indicado 
como TRUE, ent�o a procedure ter� seu �parse� durante a primeira execu��o do job; 
instance - Especifica qual a inst�ncia poder� executar o job; 
force - Se indicado como TRUE for�a a execu��o de um job. 

Exemplo: 
VARIABLE jobno NUMBER 
BEGIN 
DBMS_JOB.SUBMIT (:jobno,'DBA.TESTE001;',SYSDATE,'SYSDATE+(59/(24*60*60))'); 
COMMIT; 
END; 
/ 
PRINT jobno 

JOBNO 
---------- 
5 

No exemplo acima a procedure est� executando um job chamado TESTE001. O job de n�mero 5 ser� executado a 
cada 60 segundos. 

DBMS_JOB.REMOVE => Procedure que remove um job da fila de execu��o. 

Sintaxe: 

DBMS_JOB.REMOVE (job IN BINARY_INTEGER); 
Job - N�mero do job que ser� removido. 

Exemplo: 
EXECUTE DBMS_JOB.REMOVE(2); 


DBMS_JOB.CHANGE => Procedure que permite a altera��o de alguns par�metros de um job na fila de execu��o. 

Sintaxe: 

DBMS_JOB.CHANGE ( 
job IN BINARY_INTEGER, 
what IN VARCHAR2, 
next_date IN DATE, 
interval IN VARCHAR2, 
instance IN BINARY_INTEGER DEFAULT NULL, 
force IN BOOLEAN DEFAULT FALSE); 

job - Este par�metro identifica o n�mero do job que ser� alterado; 
what - Nome do c�digo PL/SQL que ser� executada; 
next_date - Pr�xima data em que o job ser� executado; 
interval - Fun��o que calcula o intervalo que o job ser� executado; 
instance - Especifica qual a inst�ncia poder� executar o job; 
force - Se indicado como TRUE for�a a execu��o de um job. 

Exemplo: 

EXECUTE DBMS_JOB.CHANGE(1,null,sysdate+3,null); 

Se a data do sistema for igual a 24/03/2003, ent�o o �sysdate+3� ser� 27/03/2003. 

DBMS_JOB.WHAT => Procedure que altera o c�digo de PL/SQL a ser chamado. 

Sintaxe: 
DBMS_JOB.WHAT( 
job IN BINARY_INTEGER, 
what IN VARCHAR2); 

job - N�mero do job que ser� alterado; 
what - O nome do c�digo PL/SQL que ser� executada. 

Exemplo: 
O exemplo mostra a altera��o do job 3. A procedure TESTE001 ser� substitu�da pela procedure TESTE003. 

execute DBMS_JOB.WHAT(3,'DBA.TESTE003;'); 


DBMS_JOB.NEXT_DATE =>Procedure que altera o job para a pr�xima data a ser executada. 

Sintaxe: 

DBMS_JOB.NEXT_DATE ( 
JOB IN BINARY_INTEGER, 
NEXT_DATE IN DATE); 

Job - Este par�metro identifica o n�mero do job que ser� alterado; 
next_date - A pr�xima data em que o job ser� executado. 

Exemplo: 
execute DBMS_JOB.NEXT_DATE(4,SYSDATE+3); 

Se a data do sistema for igual a 24/03/2003, ent�o o �sysdate+3� ser� 27/03/2003. 

DBMS_JOB.INTERVAL =>Procedure que altera o intervalo de execu��o de um job. 

Sintaxe: 
DBMS_JOB.INTERVAL ( 
job IN BINARY_INTEGER, 
interval IN VARCHAR2); 

job - Este par�metro identifica o n�mero do �job� que ser� alterado; 
interval - Fun��o que calcula o intervalo que o �job� ser� executado. 


Abaixo segue um resumo de intervalos do jobs: 

DESCRI��O INTERVALOS � PAR�METROS 
Execu��o di�ria �SYSDATE + 1� 
Execu��o hor�ria �SYSDATE + 1/24� 
Execu��o a cada 10 minutos �SYSDATE + 10/1440� 
Execu��o a cada 30 segundos �SYSDATE + 30/86400� 
Para remover ou n�o reexecutar NULL 
o JOB 
Execu��o di�ria �s 24:00 hs. �TRUNC(SYSDATE + 1)� 
Execu��o di�ria �s 20:00 hs. �TRUNC(SYSDATE + 1) +8/24� 
Execu��o as quarta-feiras �s 12:00 hs.  �NEXT_DAY(�TRUNC (SYSDATE), �TUESDAY�) + 12/24� 
Execu��o no primeiro dia do m�s as 24:00 hs. �TRUNC(LAST_DAY(SYSDATE) + 1)� 
Execu��o no �ltimo quadrimestre �s 11:00 hs. �TRUNC(ADD_MONTHS(SYSDATE + 2/24,3), �Q�) � 1/24� 
Execu��o todas as segundas, quartas e sextas-feiras as 9:00 hs. 
�TRUNC(LEAST(NEXT_DAY ( SYSDATE, �MONDAY�),  NEXT_DAY (SYSDATE, �WEDNESDAY�), NEXT_DAY (SYSDATE,�FRIDAY�))) + 9/24� 

DBMS_JOB.BROKEN =>Procedure usada para habilitar/desabilitar o �flag� de broken. Quando este flag � habilitado 
o job n�o � re-executado automaticamente. 

Sintaxe: 

DBMS_JOB.BROKEN ( 
Job in binary_integer, 
Broken in boolea, 
Next_date in date default sysdate); 

Job - Este par�metro identifica o n�mero do �job� que ser� alterado; 
broken - TRUE ou FALSE; 
next_date - Pr�xima data em que o �job� ser� executado. 

Exemplo: 
execute DBMS_JOB.BROKEN(4, TRUE); 

O job 4 ser� habilitado como broken e na pr�xima execu��o o job n�o ser� executado. 

DBMS_JOB.RUN =>Procedure que executa immediatamente um job. 

Sintaxe: 

DBMS_JOB.RUN ( 
job IN BINARY_INTEGER 
force IN BOOLEAN DEFAULT FALSE); 

job - N�mero do job que ser� executado; 
force - Se indicado como TRUE for�a a execu��o de um job. 

Exemplo: 
execute dbms_job.run(4); 


Resumo das procedures: 
DBMS_JOB.SUBMIT (No. Job,what,next_date,interval); 
DBMS_JOB.REMOVE (No. Job); 
DBMS_JOB.CHANGE (No. Job,what,next_date,interval); 
DBMS_JOB.WHAT (No. Job,'PL/SQL'); 
DBMS_JOB.NEXT_DATE (No. Job,Next_DATE); 
DBMS_JOB.INTERVAL (No. Job, interval); 
DBMS_JOB.BROKEN (No. Job, True/False, next_date); 
DBMS_JOB.RUN (No. Job); 

Este artigo descreveu como as procedures da package DBMS_JOB podem ajudar o usu�rio a criar, modificar, 
remover os jobs em sua aplica��o. 

