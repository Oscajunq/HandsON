Banco, temos um problema! 

J� ouviu falar naquele ditato que diz que s�o as pequenas coisas que acabam com um relacionamento duradouro? 
Com Banco de Dados tamb�m � assim, geralmente pequenas coisas, contudo, muitas pequenas coisas s�o capazes de 
tornar qualquer banco de dados bem configurado numa verdadeira carro�a. 

O assunto que vou falar agora � bastante batido contudo bastante ignorado pela maioria das pessoas, Binding de 
Vari�veis. Provavelmente voc� j� tenha ouvido falar que o seu uso � importante contudo sabe o quanto isso realmente 
representa de performance ao seu sistema? 

Deixe-me fazer um exemplo, dee uma olhada nos 2 exemplos abaixo: 

Exemplo 1 

Procedure teste; 
  Var qry:Tquery; 
Begin  
  Try 
    Qry:=Tquery.create(application); 
     Qry.sql.add(�select * from cliente where codigo=100�); 
     Qry.Open; 
  Finally 
    FreeAndNil(qry); 
  End; 
End; 

Exemplo 2 

Procedure teste; 
  Var qry:Tquery; 
Begin  
  Try 
    Qry:=Tquery.create(application); 
     Qry.sql.add(�select * from cliente where codigo=:codigo�); 
     Qry.ParamByName(�codigo�).asstring:=�100�; 
     Qry.Open; 
  Finally 
    FreeAndNil(qry); 
  End; 
End; 

Agora me responda, qual das formas apresentadas acima para passagem de par�metro voc� est� usando no seu 
dia-a-dia? Espero que voc� esteja usando a segunda forma, sen�o.... 

Vamos abrir um par�ntese para podermos compreender melhor onde quero chegar. 

Uma das regras de otimiza��o adotada pelos bancos de dados � tentar reaproveitar algo que j� esteja feito. 

Vejamos uma coisa. 

Quando voc� envia para o banco de dados a seguinte consulta. 
�select * from cliente�, o que o banco de dados faz? Bem, existem basicamente tr�s etapas por traz do retorno dos dados. 
1a. Parser 
2a. Execu��o 
3�. Fetch dos dados 

Bem, a etapa que nos interessa � a primeira. Quando o otimizador recebe uma consulta como aquela, a primeira
 coisa que ele faz � ver se j� houve uma consulta como aquela feita, caso n�o haja, o otimizador compila a 
 consulta criando um plano de execu��o para ela e armazena o sql da consulta numa �rea de mem�ria espec�fica 
 para armazenamento de comandos sql�s. L� eles permanecem por um certo per�odo de tempo sendo descartados 
 atrav�s de algum algoritmo tipo LRU. O que isso quer dizer? Quer dizer que se logo depois voc� mandar uma 
 consulta exatamente igual ele j� tem o plano dela armazenada na mem�ria, ou seja, n�o h� necessidade de compilar 
 a consulta novamente, basta ver que h� um plano de execu��o ligado a uma consulta sql exatamente igual a esta e 
 vincular a nova enviada. Percebem, com isso voc� ganha tempo, muito tempo. 
Bem, disse a pouco que a consulta tem que ser igual, ou seja, mandar ela como: 
�select * from Cliente� far� o otimizador considerar que temos uma nova consulta e que deve passar por todas as etapas. 
Perceberam? Uma �nica letra diferente vai tornar sua consulta �nica e o otimizador precisar� tratar ela individualmente. 

Bem, espero que com isso percebam que escrever consultas sempre que poss�vel da mesma forma � um h�bito saud�vel e 
inteligente se voc� pretende obter performance m�xima. 

E com rela��o a vari�veis de liga��o? Onde entra isso? 
Bem, se voc� for esperto j� deve ter percebido que usar Binding pode salvar sua aplica��o. 

Vamos � um exemplo f�cil de entender. Imagine que voc� tenha desenvolvido um sistema de Tele-Vendas, onde 
dezenas de atendentes com voz sedutora atender� seus clientes prontamente a cada liga��o a fim de vender seus 
produtos. Imagine que ela tenha em sua frente uma tela de cadastro de itens com os 50.000 itens vendidos pela
 sua empresa. Imagine que a cada instante ela v� at� a rotina de busca e fa�a a seguinte procura. 
�ache os produtos com descri��o igual � e voc� tenha tratado erroneamente no programa da seguinte forma 
qry.sql.add(�select * from produto where descri��o=�+Edit1.text); 
Ou seja, voc� nem de perto est� usando Binding, est� acrescentando o par�metro direto ao sql da consulta e mandando
 processar. Bem, pense assim, se s�o 10 tele-vendedoras fazendo consulta o dia todo, cada uma delas mandando consultas 
 desta forma, se cada uma delas consultar 300 itens durante o dia, teremos um total de 3.000 consultas ao banco de dados
  correto? Agora imagine que todas elas tenham consultado produtos diferentes, como voc� n�o usou Binding de vari�veis 
  voc� simplesmente acabou de criar 3.000 entradas na �rea de armazenamento de sql, gerou 3.000 planos e simplesmente 
  fez o banco perder um tempo enorme fazendo tanta repeti��o. Se voc� tivesse usando Binding voc� teria gerado apenas 
  1 entrada. Legal n�? 1 entrada contra 3.000, vale ou n�o apena tomar um pouco mais de cuidado? Perceba que 
  �select * from produto where c�digo=100� � diferente de �select * from produto where c�digo=200� enquanto que
   �select * from produto where c�digo=:codigo� pode tratar as duas situa��es gerando apenas uma compila��o e um 
   �nico plano. 

Muitas pessoas fazem uso de montagem de sql acrescentando direto ao corpo do c�digo as vari�veis por achar que isso 
� mais c�modo e n�o trar� malef�cio. Bem, realmente � muito mais f�cil contudo acabamos de ver que as implica��es 
s�o enormes. 

Vou mostrar abaixo um exemplo que mostra o qu�o mais r�pido uma aplica��o usando Binding de vari�vel � com rela��o 
� outra que n�o faz uso de tal recurso. Para tal usarei o Oracle como ferramenta de teste, caso voc� tenha em casa 
pode testar no sqlplus. 

O comando abaixo serve para nos assegurar que realmente quando estamos iniciando este 
teste nossa mem�ria compartilhada esteja limpa. 

alter system flush shared_pool; 

A linha abaixo server para indicar ao sqlplus que ele deve nos dar em tela o retorno do processamento. 

set serveroutput on; 

Aqui come�a o c�digo fazendo uso de montagem do sql e n�o da passagem de par�metro. Ambos os c�digos s�o 
id�nticos, o que muda � que este primeiro n�o faz uso de Biding enquanto o outro faz. Em suma ambos contam 
at� 1000 e ao t�rmino mostra em tela o tempo gasto de processamento. 

declare 
  type rc is ref cursor; 
  l_rc rc; 
  l_dummy all_objects.object_name%type; 
  l_start number default dbms_utility.get_time; 
 begin 
   for i in 1..1000 
     loop 
       open l_rc for 
        'select object_name from all_objects where object_id='||i; 
        fetch l_rc into l_dummy; 
        close l_rc;    
     end loop;  
        dbms_output.put_line(round((dbms_utility.get_time-l_start)/100,2)||' segundos...'); 
 end; 
/ 

Procedimento PL/SQL conclu�do com sucesso. 

Decorrido: 00:00:33.10 

--------------------------------------------------------------------------- 
declare 
  type rc is ref cursor; 
  l_rc rc; 
  l_dummy all_objects.object_name%type; 
  l_start number default dbms_utility.get_time; 
 begin 
   for i in 1..1000 
     loop 
       open l_rc for 
        'select object_name from all_objects where object_id=:x' 
        using i; 
        fetch l_rc into l_dummy; 
        close l_rc;    
     end loop;  
        dbms_output.put_line(round((dbms_utility.get_time-l_start)/100,2)||' segundos...'); 
 end; 
/ 


Procedimento PL/SQL conclu�do com sucesso. 

Decorrido: 00:00:02.30 

Espantado com a compara��o? Espantando o quanto o uso de Binding de vari�veis pode tornar sua aplica��o mais 
r�pida e n�o sobrecarregar a mem�ria do Oracle? 




teste de querys para apurar bind variable

select sql_text, parse_calls, executions,PARSING_SCHEMA_NAME  from v$sqlarea
where parse_calls > 100 
  and executions < 2*parse_calls 
  and parsing_schema_name != 'SYS'
order by executions ;

select sql_text, parse_calls, executions,PARSING_SCHEMA_NAME  from v$sqlarea
where parsing_schema_name = 'PRODISSR'
  and sql_text like '%FRAUDE%'
order by executions ;

SELECT pa.SID, pa.VALUE "Hard Parses", ex.VALUE "Execute Count", tt.Value "Total Parses"
FROM V$SESSTAT pa, V$SESSTAT ex, V$SESSTAT tt
WHERE pa.SID = ex.SID (+)
  AND pa.SID = tt.SID (+)
  AND pa.STATISTIC# = 
   ( SELECT STATISTIC# FROM V$STATNAME
      WHERE NAME = 'parse count (hard)')
AND ex.STATISTIC#=(
  SELECT STATISTIC#
  FROM V$STATNAME
  WHERE NAME = 'execute count')
AND tt.STATISTIC# = 
   ( SELECT STATISTIC# FROM V$STATNAME
      WHERE NAME = 'parse count (total)')
and pa.sid in (299, 284)




SELECT pa.SID, pa.VALUE "Hard Parses"
FROM V$SESSTAT pa




 select substr(sql_text,1,50), parse_calls, executions,PARSING_SCHEMA_NAME  from v$sqlarea
 where parse_calls > 100
   and executions < 2*parse_calls
   and parsing_schema_name in ('HOMISSR','PRODISSR','HOMISSR2','DBRP1001')
 order by executions