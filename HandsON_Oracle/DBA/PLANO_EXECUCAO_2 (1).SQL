HR@10G:SQL>set lines 132
HR@10G:SQL>select * from table(dbms_xplan.display('PLAN_TABLE', 'TESTE01'));

PLAN_TABLE_OUTPUT
------------------------------------------------------------------------------------------
Plan hash value: 3851899397

------------------------------------------------------------------------------------------
| Id  | Operation                    | Name      | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |           |   107 |  5885 |     4   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                |           |   107 |  5885 |     4   (0)| 00:00:01 |
|   2 |   TABLE ACCESS FULL          | EMPLOYEES |   107 |  2996 |     3   (0)| 00:00:01 |
|   3 |   TABLE ACCESS BY INDEX ROWID| JOBS      |     1 |    27 |     1   (0)| 00:00:01 |
|*  4 |    INDEX UNIQUE SCAN         | JOB_ID_PK |     1 |       |     0   (0)| 00:00:01 |
------------------------------------------------------------------------------------------

PLAN_TABLE_OUTPUT
------------------------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------

   4 - access("E"."JOB_ID"="J"."JOB_ID")

Como deve ser lido um plano de acesso: a identação é determinante, e a idéia é que os passos identados mais à direita 
"alimentam" os passos acima deles. No exemplo acima, a linha 1 | NESTED LOOP está logo abaixo da instrução, portanto 
ela é quem vai passar o resultado final ao comando. Logo abaixo temos no mesmo nível de identação a 
linha 2 | TABLE ACCESS FULL, acessando o objeto EMPLOYEES, 107  linhas por vez, e a 
linha 3 | TABLE ACCESS BY INDEX ROWID, acessando o objeto JOBS, lendo 1 linha a cada vez, e sendo que esse acesso 
não é uma operação atômica (há linhas mais identadas abaixo dele), a linha 4 mostra que é feito via busca no índice 
JOB_ID_PK. Quando dois passos estão no mesmo alinhamento como é o caso do 2 e do 3, são acessados pelo "topo" para baixo. 
Ou seja, o trecho deve ser interpretado assim: o FULL TABLE SCAN na tabela EMPLOYEES acessará muitas linhas, 
para cada linha que for acessada será feito um busca via INDEX ROWID na tabela JOBS procurando a chave que foi 
lida via SCAN, um match será ou não encontrado, os que forem encontrados entrarão no resultset do NESTED LOOP, que por 
sua vez alimentará o SQL.

 A representação em pseudocódigo identado deste plano ficaria assim:

a.	INÍCIO
b.	LOOP
c.	Leia uma linha da tabela EMPLOYEES, saia do LOOP se não encontrar
d.	Busque na tabela JOBS o valor-chave encontrado em c...
e.	Usando o índice JOB_ID_PK
f.	Fim do loop
G.	Retorne as linhas encontradas




HR@10G:SQL>select * from table(dbms_xplan.display('PLAN_TABLE', 'TESTE01', 'ALL'));

PLAN_TABLE_OUTPUT
------------------------------------------------------------------------------------------
Plan hash value: 3851899397

------------------------------------------------------------------------------------------
| Id  | Operation                    | Name      | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |           |   107 |  5885 |     4   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                |           |   107 |  5885 |     4   (0)| 00:00:01 |
|   2 |   TABLE ACCESS FULL          | EMPLOYEES |   107 |  2996 |     3   (0)| 00:00:01 |
|   3 |   TABLE ACCESS BY INDEX ROWID| JOBS      |     1 |    27 |     1   (0)| 00:00:01 |
|*  4 |    INDEX UNIQUE SCAN         | JOB_ID_PK |     1 |       |     0   (0)| 00:00:01 |
------------------------------------------------------------------------------------------

PLAN_TABLE_OUTPUT
------------------------------------------------------------------------------------------

Query Block Name / Object Alias (identified by operation id):
-------------------------------------------------------------

   1 - SEL$1
   2 - SEL$1 / E@SEL$1
   3 - SEL$1 / J@SEL$1
   4 - SEL$1 / J@SEL$1

Predicate Information (identified by operation id):
---------------------------------------------------

PLAN_TABLE_OUTPUT
------------------------------------------------------------------------------------------

   4 - access("E"."JOB_ID"="J"."JOB_ID")

Column Projection Information (identified by operation id):
-----------------------------------------------------------

   1 - (#keys=0) "E"."EMPLOYEE_ID"[NUMBER,22], "E"."FIRST_NAME"[VARCHAR2,20],
       "E"."LAST_NAME"[VARCHAR2,25], "J"."JOB_TITLE"[VARCHAR2,35]
   2 - "E"."EMPLOYEE_ID"[NUMBER,22], "E"."FIRST_NAME"[VARCHAR2,20],
       "E"."LAST_NAME"[VARCHAR2,25], "E"."JOB_ID"[VARCHAR2,10]
   3 - "J"."JOB_TITLE"[VARCHAR2,35]

PLAN_TABLE_OUTPUT
------------------------------------------------------------------------------------------
   4 - "J".ROWID[ROWID,10]

