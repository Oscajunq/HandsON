---------------------------------------------------------------------------------------------------------------------------                                                                                                    
Interpretação de um Plano de execução
---------------------------------------------------------------------------------------------------------------------------
Em um primeiro momento, um plano de execução pode parecer difícil de ler e entender. Esta documento mostrará como é fácil 
ler e explicar um Plano de execução. Quando um plano de execução é exibido, você poderá perceber que algumas linhas estão 
mais recuados do que outras. As linhas que estão à direita são executadas mais cedo do que da esquerda. Por isso, para ver 
a ação do otimizador levaremos em conta primeiro as declaraçoes que estão mais distante pela direita. 
O exemplo mostrado abaixo foi extraido as informações do examinador AUTOTRACE, mas poderia ter sido construída
por outro examinador de plano de execução.                                                                    
                                                
Execution Plan
-----------------------------------------------------------------------------------------------------------------
   0      SELECT STATEMENT Optimizer=ALL_ROWS (Cost=2 Card=1 Bytes=29)
   1    0   TABLE ACCESS (BY INDEX ROWID) OF 'DB_OBJECT' (Cost=2 Card=1 Bytes=29)
   2    1     INDEX (RANGE SCAN) OF 'DB_OBJ_IDX' (NON-UNIQUE) (Cost=1 Card=1)
                                                                      
                                                                      
A linha que está mais à direita é a linha número 2, o INDEX RANGE SCAN. O índice DB_OBJ_IDX foi usado neste scan. 
Esse índice não é exclusivo. O custo calculado pelo CBO para esta operação foi de 1.                              

A primeira coluna desta saída é um número de linha. Os números de linha não são o fim das operações. Tal como acima 
demonstrado, a linha 2 é na verdade a primeira operação realizada. A segunda coluna é o pai a esta linha. 
Para linha número 2, o pai é linha número 1. Repare que linha número 0 não tem pai.

Agora, conhecemos então que esta consulta utilizou um índice, e qual foi utilizado. O INDEX RANGE SCAN facilitou a 
próxima operação. A próxima operação (o pai da linha número 2), linha 1, um TABLE ACESS. 
O acesso do proximo passo, foi utilizar o rowid do índice reproduzido na linha 2. A tabela DB_OBJECT é acessada. 
O otimizador determinou que o custo desta operação é de 2. Note-se que um custo de 10, não significa necessariamente 
que os resultados serão mostrados na metade do tempo de um custo de 20. Em vez disso, uma operação com o custo de 10 
simplesmente afirma que os resultados devem ser devolvidos mais rápido do que uma operação com o custo de 20, 
sem menção de forma muito mais rápido.

O plano de execução mostra que o número de Bytes retornado é 29. Também mostra o cardinalidade (Card), de 1 para estas
operações. A cardinalidade no plano de resultados explica que é a estimativa do CBO em relação ao número de linhas 
acessadas por esta operação. Idealmente, o CBO (otimizador baseado em custo) irá utilizar o plano de execução 
com o passo mais baixo da cardinalidade.`

O pai da operação da linha número 1 é linha número 0. Para qualquer instrução SQL SELECT, esta linha será o selecionador de 
dados da operação. Nesta operação, as colunas que não serão mostrados são filtradas. Repare que esta linha indica 
também que o otimizador modalidade utilizada é ALL_ROWS.

Muito simplesmente, o indice DB_OBJ_IDX  foi usado para acessar as linhas de dados da tabela DB_OBJECT.



Execution Plan
----------------------------------------------------------
   0     SELECT STATEMENT Optimizer=ALL_ROWS (Cost=1 Card=12 Bytes=444)
   1    0   TABLE ACCESS* (FULL) OF 'EMP' (Cost=1 Card=12 Bytes=444)
   
Neste exemplo, a tabela EMP foi realizada uma varreruda FULL. Dois dos métodos mais comuns de acesso a dados em uma 
tabela é a utilização de um índice, e a realização de um FULL SCAN (ler todas as linhas da tabela).


O exemplo a seguir é um pouco mais complexo e envolve uma operação de juntar duas tabelas. Desta vez, a melhor saída 
é utilizar o pacote DBMS_XPLAN oferecido pela Oracle. Isto é feito para mostrar que, apesar de uma saída ser ligeiramente 
diferente do que os planos de execução anteriores, a informação essencialmente apresentada é ainda o mesmo.

SQL> select * from table(dbms_xplan.display);
PLAN_TABLE_OUTPUT
----------------------------------------------------------------------------
| Id  | Operation                    |  Name       | Rows  | Bytes | Cost  |
----------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |             |    31 |   837 |    24 |
|*  1 |  HASH JOIN                   |             |    31 |   837 |    24 |
|*  2 |   TABLE ACCESS BY INDEX ROWID| EMP         |     1 |     5 |    21 |
|*  3 |    INDEX RANGE SCAN          | IX_EMP_01   |     1 |       |     1 |
|   4 |   TABLE ACCESS FULL          | DEPT        |   409 |  8998 |     2 |
----------------------------------------------------------------------------

Aqui está um plano de execução mais complexo. A saída de informações do pacote DBMS_XPLAN não mostra o funcionamento 
de números com os seus pais como o anteriormente, mas ainda é possível fazer sentido da execução deste plano. 
Comece por localizar a operação mais à direita. Esta operação ocorre na linha 3, um INDEX RANGE SCAN sobre o indice 
IX_EMP_01. A cardinalidade (Linhas), bytes e os custos de funcionamento são mostrados. O pai para esta operação é a 
linha diretamente acima dele, neste caso presente é a linha 2. Usando o índice IX_EMP_01, para acessar a tabela EMP 
(mostrado na linha 2).

Neste ponto, é tentador para avançar diretamente para o pai da linha 2. No entanto, nota na linha 4, existe uma 
operação que esta alienada na mesma posicao que a linha 2. Ambos a linha 4 e a linha 2 deve concluir antes de 
poder proceder para o pai destas linhas. Assim, após a tabela EMP ser acessada usando o índice, ira fazer um acesso 
de FULL SCAN (linha 4) sobre a tabela DEPT. Uma vez que ambas as tabelas foram acessadas, iremos proceder ao pai destas
operações, que é a linha 1. Na linha 1, uma operação HASH JOIN sera realizada. As tabelas EMP e DEPT são unidas usando
o algoritmo Hash Join. Finalmente, os resultados da operação são passados ao SELECT STATEMENT da operação para exibir o
dados.


Portanto, agora o quê fazer? 

Dê uma olhada em dois exemplos abaixo para ver como um plano de execução podera ajudá-lo. No primeiro exemplo, 
existe uma consulta que está processando a resposta dos dados muito lentamente. Os usuários estão reclamando sobre o 
desempenho dessa consulta. Ligue AUTOTRACE e o TIMING para ver quanto tempo demora para executar a consulta.

SQL> set autotrace on explain;
SQL> set timing on
SQL> select count(*) from all_objs
  2  where object_id = 36484;
  
  COUNT(*)
----------
        16
        
Elapsed: 00:00:32.54

Execution Plan
----------------------------------------------------------
   0      SELECT STATEMENT Optimizer=ALL_ROWS
   1    0   SORT (AGGREGATE)
   2    1     TABLE ACCESS (FULL) OF 'ALL_OBJS'

Esta consulta esta demorando aproximadamente meio minuto para executar. Seria melhor para reduzir a menos de um segundo. 
Olhando para o plano de execução, veremos que foi realizada uma varredura completa sobre a tabela neste plano de execução
Os dados revelam que um índice poderia beneficiar esta consulta. Crie um índice, e em seguida, execute novamente a consulta.

SQL> create index all_objs_idx on all_objs(object_id);
Index created.

SQL> select count(*) from all_objs
  2  where object_id = 36484;
  
  COUNT(*)
----------
        16
        
Elapsed: 00:00:00.54

Execution Plan
------------------------------------------------------------------------------
   0      SELECT STATEMENT Optimizer=ALL_ROWS
   1    0   SORT (AGGREGATE)
   2    1     INDEX (RANGE SCAN) OF 'ALL_OBJS_IDX' (NON-UNIQUE)
   
A pesquisa agora roda muito mais rápido (cerca de meio segundo). Essa consulta foi bem otimizada.



O próximo exemplo mostra uma forma diferente de realizar a analise sobre o plano de execução. 
Comece por assegurar que existe um índice sobre a tabela.

SQL> select index_name,column_name from user_ind_columns
  2  where table_name='EMP';
  
INDEX_NAME                     COLUMN_NAME
------------------------------ --------------------
EMP_PK                         EMPNO


A tabela EMP contém um índice na coluna EMPNO. É de conhecimento que também este índice é único, pois é a chave primária. 
Vamos agora executar uma consulta contra esta tabela.


SQL> set autotrace traceonly explain

SQL> select * from emp where empno=7895;

Execution Plan
----------------------------------------------------------------------------------
   0      SELECT STATEMENT Optimizer=ALL_ROWS (Cost=1 Card=1 Bytes=37)
   1    0   TABLE ACCESS* (FULL) OF 'EMP' (Cost=1 Card=1 Bytes=37)

Repare que, embora "WHERE EMPNO = 7895" está no comando SQL, uma varredura completa é executada sobre a tabela. 
O índice não é usado! Se o otimizador estiver em modo REGRA (em Oracle 9i e anteriores), o índice teria sido 
definitivamente utilizado. Quando utilizado o otimizador baseado em regra, um índice é favorecido em uma varredura completa
da tabela. Mas neste caso estamos utilizando o otimizador baseado em custo ( o modo do otimizador esta definido para 
ALL_ROWS). O CBO é armado com base no bloco de estatísticas das linhas da tabela EMP. A tabela EMP não é muito grande.
Lendo um bloco de índice, teria acrescentado ao custo de satisfazer a consulta. O CBO é inteligente o suficiente 
para saber que um índice, mesmo que ele existe, teria sido mais caro para utilização plena do que um FULL TABLE SCAN.

Este exemplo mostra dois pontos importantes. Em primeiro lugar, embora pensamos que conhecemos como uma consulta 
será executada, só por olhar para o plano de execução saberemos o que é certo. Dois, o CBO pode fazer melhor do que as 
decisões do RBO, desde que tenha bons dados de estatisticas para fazer essas decisões.


Operações do otimizador
-----------------------------------------------------------------------------------------------------------------------
Depois de olhar para alguns exemplos que Explique o Plano de execução você tera uma primeira ideia das diferentes 
operações que o Otimizador irá utilizar durante o acesso e processamento das querys SQL.
A tabela seguinte irá fornecer mais informações sobre os tipos de operações que o otimizador usará em processar 
um comando SQL.


bitmap index                      Um indice bitmap sera usado para recuperar rapidamente as linhas
bitmap merge                      Múltiplos bitmaps foram fundidos em conjunto para produzir um bitmap das linhas de dados
bitmap OR                         Dois bitmaps foram logicamente OR-ed juntos para produzir um bitmap
bitmap AND                        Dois bitmaps foram logicamente AND-ed juntos para produzir um bitmap
connect BY                        linhas acessada em ordem hierárquica, devido à cláusula CONNECT BY
filter                            Um rowset foi providenciado e as linhas não participaram no resultado final, foram filtradas
hash join                         O metodo Hash Join foi utilizado para juntar duas tabelas
index unique scan                 Um único índice foi usado para obter rowids para encontrar uma linha de dados
index range scan                  Um índice foi scaneado, em ordem crescente, para recuperar uma ou mais rowids para encontrar os dados
index range scan descending       Um índice foi scaneado, em ordem decrescente, para recuperar uma ou mais rowids para encontrar os dados
index skip scan                   Disponível em Oracle 9i e 10g, utiliza um índice, mas não com o líder das colunas, para recuperar rowids.
intersection                      Dois conjuntos resultado foram fundidas, removendo as linhas duplicadas, visto devido à presença da cláusula INTERSECTION
merge join                        O metodo Sort Merge Join foi utilizado para juntar duas tabelas. Normalmente, esta operação é considerada com uma espécie reclassificacao da operação.
minus                             Um conjunto de resultado foi utilizado para remover as linhas de um outro resultado conjunto, devido a presença da cláusula MINUS.
nested loops                      O metodo Nested Loops Join foi utilizado para juntar duas tabelas.
partition single                  Uma partição foi acessada, pre-executada por outras partições de consideração
partition iterator                Multiplas partições foram acessadas, pre-executada por outras partições de consideração
partition all                     Todas as partições foram acessadas
remote                            A consulta remota foi enviada para apoiar a operação distribuída. A outra coluna do plano tabela mostrará a consulta enviada para o sistema remoto.
sort aggregate                    Uma operação de sort foi realizada sobre os dados como o resultado de uma função agregada
sort unique                       Uma operação de sort foi realizada sobre os dados para eliminar as linhas duplicadas
sort group BY                     Uma operação de sort foi realizada como o resultado de uma clausula group BY
sort join                         Uma operaçao de sort foi realizada e utilizada no metodo sort merge join. Esta operação é vista como uma boa forma de junçao de dados
sort order BY                     Uma operação de sort foi realizada como o resultado de uma clausula ORDER BY
table access full                 Uma varredura completa da tabela foi realizada. Isto significa que todas as linhas de todas as marca dagua dos blocos foram acessados.
union                             Dois conjuntos de resultado foram fundidos, sem remover linhas duplicadas, visto devido à presença da cláusula UNION
VIEW                              A consulta subjacente da visão está sendo usado para processar os registros de dados.



--
--
--
-- EXPLICACAO DO PLANO DE EXECUCAO
-- PRIMEIRO DEFINIR UM NOME PARA A QUERY, NO STATEMENT_ID 
--
EXPLAIN PLAN SET STATEMENT_ID = 'QUERY1' FOR QUERY
--
-- DEPOIS DE PEDIR A EXPLICACAO DO PLANO, PODE SER USAR QUALQUER QUERY ABAIXO
--
--
-- QUERY 1 - EXPLICACAO COMPLETA DO PROCESSO
--
SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY()); 

ou

SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY(NULL, 'QUERY1','TYPICAL'));
--
--
-- QUERY 2 - EXPLICACAO BASICA DO PROCESSO
--
SELECT PLAN_TABLE_OUTPUT FROM TABLE(DBMS_XPLAN.DISPLAY(NULL,'query1','BASIC'))
--
--
-- QUERY 3 - AVALIAR OS DADOS DIRETO NA TABELA ABAIXO.
--
--	
COLUMN PLAN             FORMAT A80        HEADING "Execution Plan"
COLUMN OBJECT_NAME      FORMAT A30        HEADING "Object"
COLUMN OBJECT_TYPE      FORMAT A30        HEADING "Type"
COLUMN BYTES            FORMAT 9999999999 HEADING "Bytes"
COLUMN COST             FORMAT 9999999    HEADING "Cost"
COLUMN PARTITION_START  FORMAT 9999999    HEADING "PStart"
COLUMN PARTITION_STOP   FORMAT 9999999    HEADING "PEnd"
SET PAGESIZE 1000
SET LINESIZE 1000
--SET VERIFY OFF
SELECT CARDINALITY "ROWS",
       pt.id,
       LPAD(' ', 2 * (level - 1)) ||
       Decode (level,1,NULL,level-1 || '.' || pt.position || ' ') ||
       Initcap(pt.operation) ||
       Decode(pt.options,NULL,'',' (' || Initcap(pt.options) || ')') plan,
       pt.object_name,
       pt.object_type,
       pt.bytes,
       pt.cost,
       SUBSTR(pt.partition_start,1,10),
       SUBSTR(pt.partition_stop,1,10),
       pt.cpu_cost,
       pt.io_cost
FROM   plan_table pt  
START WITH pt.id = 0
  AND pt.statement_id = 'query1'
CONNECT BY PRIOR pt.id = pt.parent_id
  AND pt.statement_id = 'query1';
SET VERIFY ON
--
--
--
--
--
-- PARA AVALIAR A QUERY QUE FOI EXECUTADA
--
-- EXECUTA A QUERY COM ALGUM COMENTARIO PARA FACILITAR A PESQUISA POSTERIORMENTE
--
SELECT /* TOTO */ ename, dname FROM dept d join emp e USING (deptno);
--
--
-- APOS A EXECUCAO, PESQUISAR O NUMERO DA QUERY GERADA
--
SELECT sql_id, child_number FROM v$sql WHERE sql_text LIKE '%TOTO%';

SQL_ID         CHILD_NUMBER
----------     -----------------------------
gwp663cqh5qbf   0

--
-- APOS A PESQUISA DO NUMERO DA QUERY, EXECUTAR O COMANDO ABAIXO PASSANDO ESTE NUMERO DA QUERY
--
SELECT * FROM table(DBMS_XPLAN.DISPLAY_CURSOR(('gwp663cqh5qbf',0));
--
--
Plan hash value: 3693697075, SQL ID: gwp663cqh5qbf, child number: 0
--------------------------------------------------------
SELECT /* TOTO */ ename, dname 
FROM dept d JOIN emp e USING (deptno);

----------------------------------------------------------------------------
| Id  | Operation           | Name | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------
|   0 | SELECT STATEMENT    |      |       |       |     7 (100)|          |
|   1 |  SORT GROUP BY      |      |     4 |    64 |     7  (43)| 00:00:01 |
|*  2 |   HASH JOIN         |      |    14 |   224 |     6  (34)| 00:00:01 |
|   3 |    TABLE ACCESS FULL| DEPT |     4 |    44 |     3  (34)| 00:00:01 |
|   4 |    TABLE ACCESS FULL| EMP  |    14 |    70 |     3  (34)| 00:00:01 |
----------------------------------------------------------------------------

Predicate Information (identified by operation id):
---------------------------------------------------
   2 - access("E"."DEPTNO"="D"."DEPTNO")
--
--
--
-- OUTRA FORMA DE AVALIAR O PLANO DE EXECUCAO DA QUERY , É CONSULTAR OS DADOS DA V$SQL_PLAN A PATIR DA VERSAO ORACLE 9i
--
--
-- EXECUTAR UMA QUERY ESPECIFICA :
--
SELECT * FROM PRODISSR.PERSONAS
--
-- PROCURAR O ADDRESS DESTA QUERY EXECUTADA
--
SELECT * FROM V$SQLAREA WHERE SQL_TEXT LIKE '%PRODISSR.PERSONAS%'
--
--
-- SELECIONAR OS DADOS DA QUERY ABAIXO PARA AVALIAR O PLANO
--
SELECT DECODE(ID,0,'',
     LPAD(' ',2*(LEVEL-1))||LEVEL||'.'||POSITION)||' '||OPERATION||
     DECODE(ID,0,'',' OPTION: ')||OPTIONS||
     DECODE(ID,0,'',' OBJECT NAME: ')||DECODE(ID,0,'',NVL(OBJECT_NAME, 'NONE'))||
     DECODE(ID,0,'',' OBJECT NUMBER: ')||DECODE(ID,0,'',NVL(TO_CHAR(OBJECT#), 'NONE' ))|| 
     DECODE(ID,0,'COST = '||POSITION) 
     SQL_QUERY_PLAN 
     FROM V$SQL_PLAN
     CONNECT BY PRIOR ID = PARENT_ID
     AND ADDRESS = UPPER('000000038EE6A030')
     START WITH ID =0 AND ADDRESS = UPPER('000000038EE6A030');
--
--
--
-- IDENTIFICACOES DE CADA COLUNA DO PLANO DE EXPLICACAO "PLAN_TABLE"
--
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|STATEMENT_ID     |VARCHAR2(30)  |Parametro opcional para identificacao da query no plano de execução                      |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|PLAN_ID          |NUMBER        |Identificador exclusivo de um plano do banco de dados.                                   |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|TIMESTAMP        |DATE          |Data e hora em que a declaração foi gerada pelo EXPLAIN PLAN.                            |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|REMARKS          |VARCHAR2(80)  |Qualquer comentário (até 80 bytes) que você deseja associar a cada etapa do plano        |
|                 |              |explicado.                                                                               |
|                 |              |Esta coluna é utilizada para indicar se um esboço ou perfil de SQL que foi utilizado     |
|                 |              |para a consulta.                                                                         |
|                 |              |Se precisar adicionar ou alterar uma observação sobre qualquer linha do PLAN_TABLE       |
|                 |              |apenas atualiza                                                                          |
|                 |              |este campo com o comando UPDATE na tabela PLAN_TABLE.                                    |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|OPERATION        |VARCHAR2(30)  |Nome da operação interna realizada para cada etapa ( ver tabela de operacoes/opções )    |
|                 |              |Na primeira linha é gerada uma declaração, contendo um dos seguintes valores:            |
|                 |              |DELETE STATEMENT,                                                                        |
|                 |              |INSERT STATEMENT,                                                                        |
|                 |              |SELECT STATEMENT,                                                                        |
|                 |              |UPDATE STATEMENT                                                                         |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|OPTIONS          |VARCHAR2(225) |Variação da coluna de operacoes ( operation ) ( ver tabela de operacoes/opções )         |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|OBJECT_NODE      |VARCHAR2(128) |Nome do banco de dados usado para ligar uma referência do objeto                         |
|                 |              |(uma tabela nome ou visão).                                                              |
|                 |              |Por local de consultas usando um paralelo execução, esta coluna descreve a ordem em que  |
|                 |              |as operações de saída é consumido.                                                       |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|OBJECT_OWNER     |VARCHAR2(30)  |Nome do usuário que é dono do esquema que contém a tabela ou índice.                     |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|OBJECT_NAME      |VARCHAR2(30)  |Nome do indice ou tabela.                                                                |
|-----------------|--------------|-----------------------------------------------------------------------------------------| 
|OBJECT_ALIAS     |VARCHAR2(65)  |Alias unico de uma tabela ou lista de um comando SQL. Para índices, que é o objeto alias |
|                 |              |Da tabela subjacente.                                                                    |    
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|OBJECT_INSTANCE  | NUMERIC      |Número correspondente à posição ordinal do objeto como aparece na declaração original.   |
|                 |              |A numeração procede da esquerda para a direita, exterior ao interior com respeito a      |
|                 |              |declaração do texto original.                                                            |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|OBJECT_TYPE      | VARCHAR2(30) |identificadoor que fornece informações descritivas sobre o objeto, por exemplo,          |
|                 |              |NON-UNIQUE para índices.                                                                 |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|OPTIMIZER        | VARCHAR2(255)|Atual Modo do otimizador.                                                                |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|SEARCH_COLUMNS   | NUMERIC      |Esta coluna nao esta sendo mais utilizada                                                |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|ID               | NUMERIC      |Um número atribuído a cada passo no plano de execução.                                   |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|PARENT_ID        | NUMERIC      |O ID da próxima passo de execução que opera sobre a saída do ID principal                |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|DEPTH            | NUMERIC      |valor para montar a identaçao do relatorio do plano de execucao a ser exibido como       |
|                 |              |fileira da arvore.                                                                       |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|POSITION         | NUMERIC      |Numero da representacao da identacao que sera utilizado para indicar a posicao da        |
|                 |              |dependencia da linha anterior  ex: 1.1                                                   |
|                 |              |                                   1.2                                                   |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|COST             |NUMERIC       |Custo da operação estimado pelo otimizador da consulta. Este custo não é determinado     |
|                 |              |pelas operaçoes de acesso a tabela, o valor dessa coluna não tem qualquer unidade de     |
|                 |              |medição, é meramente um valor ponderado utilizado para comparar os custos de um plano de |
|                 |              |execução contra outros.                                                                  |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|CARDINALITY      |NUMERIC       |Estimativa de numeros de linhas que serão acessados determinadas pelo otimizador de      |
|                 |              |consultas                                                                                |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|BYTES            |NUMERIC       |Estimativa de numeros de bytes  que serão acessados determinadas pelo otimizador de      |
|                 |              |consultas                                                                                |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|OTHER_TAG        |VARCHAR2(255) |Descreve o conteúdo da coluna OUTROS. Os valores são os seguintes:                       |
|                 |              |SERIAL                        (blank) - Execução serial. Atualmente, o SQL não é         |
|                 |              |                                        carregado nesta coluna OUTRAS.                   |
|                 |              |SERIAL_FROM_REMOTE            (S -> R)- Execução serial em um site remoto                |
|                 |              |PARALLEL_FROM_SERIAL          (S -> P)- Execução serial. O passo de saida é particionado |
|                 |              |                                        ou tramsmite a execução paralela de servidortes  |                                
|                 |              |PARALLEL_TO_SERIAL            (P -> S)- Execução paralela. O passo de saida é devolvido  |
|                 |              |                                        ao cordenador do processo de consulta serial (QC)|
|                 |              |PARALLEL_TO_PARALLEL          (P -> P)- Execução paralela. O passo de saida é reparticio-|
|                 |              |                                        nado na segunda serie de execução paralela de    |
|                 |              |                                        servidores                                       | 
|                 |              |PARALLEL_COMBINED_WITH_PARENT (PWP)   - Execução paralela. O passo de saida vai para o   |
|                 |              |                                        proxima etapa do mesmo processo paralelo         |
|                 |              |PARALLEL_COMBINED_WITH_CHILD  (PWC)   - Execução paralela. O passo de Entrada vem de     |
|                 |              |                                        antes mesmo do processo paralelo.                |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|PARTITION_START  | VARCHAR2(255)| Partição inicial de um conjunto de partições iniciada. N indica que o início partição   |
|                 |              | foi identificada pelo compilador SQL, e o numero da partição é dado pelo n.             |
|                 |              | KEY indica que o partição inicial será identificada em valores fundamentais em tempo de |
|                 |              |      execução de particionamento valores fundamentais.                                  |
|                 |              | ROW REMOVE_LOCATION Indica que o início partição (mesmo que a partição esteja parada),  |
|                 |              |     será computado em tempo de execução a partir da localização de cada registro a ser  |
|                 |              |     recuperado. O registro localização é obtida por um usuário ou a partir de um índice |
|                 |              |     global.                                                                             |
|                 |              |INVALID indica que o intervalo da partição acessada está vazia.                          |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|PARTITION_STOP   |VARCHAR2(255) |Partição final de um conjunto de partições acessada. N indica que a partição parada  foi |
|                 |              |identificada pelo compilador SQL, e o numero da partição é dado pelo n.                  |                              
|                 |              | KEY indica que o partição inicial será identificada em valores fundamentais em tempo de |
|                 |              |      execução de particionamento valores fundamentais.                                  |
|                 |              | ROW REMOVE_LOCATION Indica que o início partição (mesmo que a partição esteja parada),  |
|                 |              |     será computado em tempo de execução a partir da localização de cada registro a ser  |
|                 |              |     recuperado. O registro localização é obtida por um usuário ou a partir de um índice |
|                 |              |     global.                                                                             |
|                 |              |INVALID indica que o intervalo da partição acessada está vazia.                          |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|PARTITION_ID     |NUMERIC       |Campo no qual esta computado o par de valores das colunas PARTITION_START e              |
|                 |              |PARTITION_STOP                                                                           |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|OTHER            |LONG          |Outras informações que são específicas para a execução dos passos que um usuário pode    |
|                 |              |achar útil. Ver a coluna OTHER_TAG.                                                      |
|DISTRIBUTION     |VARCHAR2(30)  |Metodo usado para distribuir as linhas produzidas pela uma query                         |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|CPU_COST         |NUMERIC       |Custo da operação, estimada pela abordagem do otimizador de consulta. O valor dessa      |
|                 |              |coluna é proporcional ao número de ciclos de máquina necessários para a operação. Para   |
|                 |              |declarações que baseiam-se da abordagem de regra, o valor desta coluna sera nula.        |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|IO_COST          |NUMERIC       |Custo da operação, estimada pela abordagem do otimizador de consulta. O valor dessa      |
|                 |              |coluna é proporcional ao número de blocos de dados lidos pela operação. Para declarações |
|                 |              |que baseiam-se da abordagem de regra, o valor desta coluna sera nula.                    |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|TEMP_SPACE       |NUMERIC       |Espaco temporario em bytes, usada pela operação e estimado pelo otimizador de consulta.  |
|                 |              |Para declarações que baseiam-se da abordagem de regra ou para operações qua não utilizam |
|                 |              |qualquer espaco temporario, o valor desta coluna sera nula                               |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|ACCESS_PREDICATES|VARCHAR2(4000)|Predicados utilizados para localizar linhas num acesso estruturado. Por exemplo, inicio  |
|                 |              |ou final de uma faixa de índice scaneados.                                               |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|FILTER_PREDICATES|VARCHAR2(4000)|Predicados utilizados para filtrar as linhas antes de produzir elas.                     |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|PROJECTION       |VARCHAR2(4000)|Expressões produzido pela operação.                                                      |
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|TIME             |NUMBER(20,2)  |Tempos ocorridos em segundos pela operação, estimado pelo otimizador de consulta. Para   |
|                 |              |declarações que baseiam-se da abordagem de regra, o valor desta coluna sera nula.        |         
|-----------------|--------------|-----------------------------------------------------------------------------------------|
|QBLOCK_NAME      |VARCHAR2(30)  |Nome do bloco de consulta, tanto gerados pelo sistema ou definidas pelo usuario com a    |
|                 |              |instrução QB_NAME.                                                                       |
|-----------------|--------------|-----------------------------------------------------------------------------------------|                              
                              
                              
                              
                              
     



-- TABELA DE OPERACOES ( OPERATION )  
--                                    
            
                              
                              
                              
DISTRIBUTION Text Interpretation 
PARTITION (ROWID) Maps rows to query servers based on the partitioning of a table or index using the rowid of the row to UPDATE/DELETE. 
PARTITION (KEY)   Maps rows to query servers based on the partitioning of a table or index using a set of columns. Used for partial partition-wise join, PARALLEL INSERT, CREATE TABLE AS SELECT of a partitioned table, and CREATE PARTITIONED GLOBAL INDEX. 
HASH              Maps rows to query servers using a hash function on the join key. Used for PARALLEL JOIN or PARALLEL GROUP BY. 
RANGE             Maps rows to query servers using ranges of the sort key. Used when the statement contains an ORDER BY clause. 
ROUND-ROBIN       Randomly maps rows to query servers. 
BROADCAST         Broadcasts the rows of the entire table to each query server. Used for a parallel join when one table is very small compared to the other. 
QC (ORDER)        The query coordinator (QC) consumes the input in order, from the first to the last query server. Used when the statement contains an ORDER BY clause. 
QC (RANDOM)       The query coordinator (QC) consumes the input randomly. Used when the statement does not have an ORDER BY clause. 
                              
                              
                              
                              
                              
                              
                              
 
Operation                    Option                     Description                              
                                                                                                                                                                                                                                    
AND-EQUAL                    .                          Operation accepting multiple sets of rowids, returning the intersection of the sets, eliminating duplicates. Used for the single-column indexes access path.
BITMAP                       CONVERSION                 TO ROWIDS converts bitmap representations to actual rowids that can be used to access the table.FROM ROWIDS converts the rowids to a bitmap representation.COUNT returns the number of rowids if the actual values are not needed.
BITMAP                       INDEX                      SINGLE VALUE looks up the bitmap for a single key value in the index.RANGE SCAN retrieves bitmaps for a key value range.FULL SCAN performs a full scan of a bitmap index if there is no start or stop key.
BITMAP                       MERGE                      Merges several bitmaps resulting from a range scan into one bitmap.                 
BITMAP                       MINUS                      Subtracts bits of one bitmap from another. Row source is used for negated predicates. Can be used only if there are nonnegated predicates yielding a bitmap from which the subtraction can take place. An example appears in "Viewing Bitmap Indexes with EXPLAIN PLAN"                 
BITMAP                       OR                         Computes the bitwise OR of two bitmaps.                 
BITMAP                       AND                        Computes the bitwise AND of two bitmaps.                 
BITMAP                       KEY ITERATION              Takes each row from a table row source and finds the corresponding bitmap from a bitmap index. This set of bitmaps are then merged into one bitmap in a following BITMAP MERGE operation.                 
CONNECT BY                   .                          Retrieves rows in hierarchical order for a query containing a CONNECT BY clause                 
CONCATENATION                .                          Operation accepting multiple sets of rows returning the union-all of the sets.                 
COUNT                        .                          Operation counting the number of rows selected from a table.                 
COUNT                        STOPKEY                    Count operation where the number of rows returned is limited by the ROWNUM expression in the WHERE clause.                 
DOMAIN INDEX                 .                          Retrieval of one or more rowids from a domain index. The options column contain information supplied by a user-defined domain index cost function, if any.                 
FILTER                       .                          Operation accepting a set of rows, eliminates some of them, and returns the rest.                 
FIRST ROW                    .                          Retrieval of only the first row selected by a query.                 
FOR UPDATE                   .                          Operation retrieving and locking the rows selected by a query containing a FOR UPDATE clause                 
HASH                         GROUP BY                   Operation hashing a set of rows into groups for a query with a GROUP BY clause.                 
 
HASH JOIN                    .                          Operation joining two sets of rows and returning the result. This join method is useful for joining large data sets of data (DSS, Batch). The join condition is an efficient way of accessing the second table.Query optimizer uses the smaller of the two tables/data sources to build a hash table on the join key in memory. Then it scans the larger table, probing the hash table to find the joined rows.                 
(These are join operations.) 
 
HASH JOIN                    ANTI                       Hash (left) antijoin
HASH JOIN                    SEMI                       Hash (left) semijoin
HASH JOIN                    RIGHT ANTI                 Hash right antijoin
HASH JOIN                    RIGHT SEMI                 Hash right semijoin
HASH JOIN                    OUTER                      Hash (left) outer join
HASH JOIN                    RIGHT OUTER                Hash right outer join
INDEX                        UNIQUE SCAN                Retrieval of a single rowid from an index.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
(These are access methods.) 
 
INDEX                        RANGE SCAN                 Retrieval of one or more rowids from an index. Indexed values are scanned in ascending order.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
INDEX                        RANGE SCAN DESCENDING      Retrieval of one or more rowids from an index. Indexed values are scanned in descending order.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
INDEX                        FULL SCAN                  Retrieval of all rowids from an index when there is no start or stop key. Indexed values are scanned in ascending order.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
INDEX                        FULL SCAN DESCENDING       Retrieval of all rowids from an index when there is no start or stop key. Indexed values are scanned in descending order.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
INDEX                        FAST FULL SCAN             Retrieval of all rowids (and column values) using multiblock reads. No sorting order can be defined. Compares to a full table scan on only the indexed columns. Only available with the cost based optimizer.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
INDEX                        SKIP SCAN                  Retrieval of rowids from a concatenated index without using the leading column(s) in the index. Introduced in Oracle9i. Only available with the cost based optimizer.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
INLIST ITERATOR              .                          Iterates over the next operation in the plan for each value in the IN-list predicate.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
INTERSECTION                 .                          Operation accepting two sets of rows and returning the intersection of the sets, eliminating duplicates.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
MERGE JOIN                   .                          Operation accepting two sets of rows, each sorted by a specific value, combining each row from one set with the matching rows from the other, and returning the result.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
(These are join operations.) 
 
MERGE JOIN                   OUTER                      Merge join operation to perform an outer join statement.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
MERGE JOIN                   ANTI                       Merge antijoin.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
MERGE JOIN                   SEMI                       Merge semijoin.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
MERGE JOIN                   CARTESIAN                  Can result from 1 or more of the tables not having any join conditions to any other tables in the statement. Can occur even with a join and it may not be flagged as CARTESIAN in the plan.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
CONNECT BY                   .                          Retrieval of rows in hierarchical order for a query containing a CONNECT BY clause.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
MAT_VIEW REWITE ACCESS       FULL                       Retrieval of all rows from a materialized view.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
(These are access methods.) 
 
MAT_VIEW REWITE ACCESS       SAMPLE                     Retrieval of sampled rows from a materialized view.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
MAT_VIEW REWITE ACCESS       CLUSTER                    Retrieval of rows from a materialized view based on a value of an indexed cluster key.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
MAT_VIEW REWITE ACCESS       HASH                       Retrieval of rows from materialized view based on hash cluster key value.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
MAT_VIEW REWITE ACCESS       BY ROWID RANGE             Retrieval of rows from a materialized view based on a rowid range.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
MAT_VIEW REWITE ACCESS       SAMPLE BY ROWID RANGE      Retrieval of sampled rows from a materialized view based on a rowid range.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
MAT_VIEW REWITE ACCESS       BY USER ROWID              If the materialized view rows are located using user-supplied rowids.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               
MAT_VIEW REWITE ACCESS       BY INDEX ROWID             If the materialized view is nonpartitioned and rows are located using index(es).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
MAT_VIEW REWITE ACCESS       BY GLOBAL INDEX ROWID      If the materialized view is partitioned and rows are located using only global indexes.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
MAT_VIEW REWITE ACCESS       BY LOCAL INDEX ROWID       If the materialized view is partitioned and rows are located using one or more local indexes and possibly some global indexes. Partition Boundaries:The partition boundaries might have been computed by:A previous PARTITION step, in which case the PARTITION_START and PARTITION_STOP column values replicate the values present in the PARTITION step, and the PARTITION_ID contains the ID of the PARTITION step. Possible values for PARTITION_START and PARTITION_STOP are NUMBER(n), KEY, INVALID.The MAT_VIEW REWRITE ACCESS or INDEX step itself, in which case the PARTITION_ID contains the ID of the step. Possible values for PARTITION_START and PARTITION_STOP are NUMBER(n), KEY, ROW REMOVE_LOCATION (MAT_VIEW REWRITE ACCESS only), and INVALID.                 
MINUS                        .                          Operation accepting two sets of rows and returning rows appearing in the first set but not in the second, eliminating duplicates.                                                                                                                                                                                                                                                                                                                                                                                        
NESTED LOOPS                 .                          Operation accepting two sets of rows, an outer set and an inner set. Oracle compares each row of the outer set with each row of the inner set, returning rows that satisfy a condition. This join method is useful for joining small subsets of data (OLTP). The join condition is an efficient way of accessing the second table.                                                                                                                                                                                       
(These are join operations.) 
 
NESTED LOOPS                 OUTER                      Nested loops operation to perform an outer join statement.                                                                                                                                                                                                                                                                                                                                                                                                                                                               
PARTITION                    .                          Iterates over the next operation in the plan for each partition in the range given by the PARTITION_START and PARTITION_STOP columns. PARTITION describes partition boundaries applicable to a single partitioned object (table or index) or to a set of equi-partitioned objects (a partitioned table and its local indexes). The partition boundaries are provided by the values of PARTITION_START and PARTITION_STOP of the PARTITION. Refer to Table 19-1 for valid values of partition start/stop.                 
PARTITION                    SINGLE                     Access one partition.                                                                                                                                                                                                                                                                                     
PARTITION                    ITERATOR                   Access many partitions (a subset).                                                                                                                                                                                                                                                                     
PARTITION                    ALL                        Access all partitions.                                                                                                                                                                                                                                                                                 
PARTITION                    INLIST                     Similar to iterator, but based on an IN-list predicate.                                                                                                                                                                                                                                                
PARTITION                    INVALID                    Indicates that the partition set to be accessed is empty.                                                                                                                                                                                                                                              
PX ITERATOR                  BLOCK, CHUNK               Implements the division of an object into block or chunk ranges among a set of parallel slaves                                                                                                                                                                                                         
PX COORDINATOR               .                          Implements the Query Coordinator which controls, schedules, and executes the parallel plan below it using parallel query slaves. It also represents a serialization point, as the end of the part of the plan executed in parallel and always has a PX SEND QC operation below it.                     
PX PARTITION                 .                          Same semantics as the regular PARTITION operation except that it appears in a parallel plan                                                                                                                                                                                                            
PX RECEIVE                   .                          Shows the consumer/receiver slave node reading repartitioned data from a send/producer (QC or slave) executing on a PX SEND node. This information was formerly displayed into the DISTRIBUTION column. See Table 19-2.                                                                               
PX SEND                      QC (RANDOM), HASH, RANGE   Implements the distribution method taking place between two parallel set of slaves. Shows the boundary between two slave sets and how data is repartitioned on the send/producer side (QC or side. This information was formerly displayed into the DISTRIBUTION column. See Table 19-2.              
REMOTE                       .                          Retrieval of data from a remote database.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
SEQUENCE                     .                          Operation involving accessing values of a sequence.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
SORT                         AGGREGATE                  Retrieval of a single row that is the result of applying a group function to a group of selected rows.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
SORT                         UNIQUE                     Operation sorting a set of rows to eliminate duplicates.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       
SORT                         GROUP BY                   Operation sorting a set of rows into groups for a query with a GROUP BY clause.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
SORT                         JOIN                       Operation sorting a set of rows before a merge-join.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
SORT                         ORDER BY                   Operation sorting a set of rows for a query with an ORDER BY clause.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
TABLE ACCESS                 FULL                       Retrieval of all rows from a table.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
(These are access methods.) 
 
TABLE ACCESS                 SAMPLE                     Retrieval of sampled rows from a table.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
TABLE ACCESS                 CLUSTER                    Retrieval of rows from a table based on a value of an indexed cluster key.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
TABLE ACCESS                 HASH                       Retrieval of rows from table based on hash cluster key value.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
TABLE ACCESS                 BY ROWID RANGE             Retrieval of rows from a table based on a rowid range.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
TABLE ACCESS                 SAMPLE BY ROWID RANGE      Retrieval of sampled rows from a table based on a rowid range.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
TABLE ACCESS                 BY USER ROWID              If the table rows are located using user-supplied rowids.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
TABLE ACCESS                 BY INDEX ROWID             If the table is nonpartitioned and rows are located using index(es).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
TABLE ACCESS                 BY GLOBAL INDEX ROWID      If the table is partitioned and rows are located using only global indexes.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
TABLE ACCESS                 BY LOCAL INDEX ROWID       If the table is partitioned and rows are located using one or more local indexes and possibly some global indexes. Partition Boundaries:The partition boundaries might have been computed by:A previous PARTITION step, in which case the PARTITION_START and PARTITION_STOP column values replicate the values present in the PARTITION step, and the PARTITION_ID contains the ID of the PARTITION step. Possible values for PARTITION_START and PARTITION_STOP are NUMBER(n), KEY, INVALID.The TABLE ACCESS or INDEX step itself, in which case the PARTITION_ID contains the ID of the step. Possible values for PARTITION_START and PARTITION_STOP are NUMBER(n), KEY, ROW REMOVE_LOCATION (TABLE ACCESS only), and INVALID.              
UNION                        .                          Operation accepting two sets of rows and returns the union of the sets, eliminating duplicates.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
VIEW                         .                          Operation performing a view's query and then returning the resulting rows to another operation.
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
                                                                                                    
