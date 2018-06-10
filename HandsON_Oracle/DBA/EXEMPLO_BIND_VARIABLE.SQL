Banco, temos um problema! 

Já ouviu falar naquele ditato que diz que são as pequenas coisas que acabam com um relacionamento duradouro? 
Com Banco de Dados também é assim, geralmente pequenas coisas, contudo, muitas pequenas coisas são capazes de 
tornar qualquer banco de dados bem configurado numa verdadeira carroça. 

O assunto que vou falar agora é bastante batido contudo bastante ignorado pela maioria das pessoas, Binding de 
Variáveis. Provavelmente você já tenha ouvido falar que o seu uso é importante contudo sabe o quanto isso realmente 
representa de performance ao seu sistema? 

Deixe-me fazer um exemplo, dee uma olhada nos 2 exemplos abaixo: 

Exemplo 1 

Procedure teste; 
  Var qry:Tquery; 
Begin  
  Try 
    Qry:=Tquery.create(application); 
     Qry.sql.add(‘select * from cliente where codigo=100’); 
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
     Qry.sql.add(‘select * from cliente where codigo=:codigo’); 
     Qry.ParamByName(‘codigo’).asstring:=’100’; 
     Qry.Open; 
  Finally 
    FreeAndNil(qry); 
  End; 
End; 

Agora me responda, qual das formas apresentadas acima para passagem de parâmetro você está usando no seu 
dia-a-dia? Espero que você esteja usando a segunda forma, senão.... 

Vamos abrir um parêntese para podermos compreender melhor onde quero chegar. 

Uma das regras de otimização adotada pelos bancos de dados é tentar reaproveitar algo que já esteja feito. 

Vejamos uma coisa. 

Quando você envia para o banco de dados a seguinte consulta. 
“select * from cliente”, o que o banco de dados faz? Bem, existem basicamente três etapas por traz do retorno dos dados. 
1a. Parser 
2a. Execução 
3ª. Fetch dos dados 

Bem, a etapa que nos interessa é a primeira. Quando o otimizador recebe uma consulta como aquela, a primeira
 coisa que ele faz é ver se já houve uma consulta como aquela feita, caso não haja, o otimizador compila a 
 consulta criando um plano de execução para ela e armazena o sql da consulta numa área de memória específica 
 para armazenamento de comandos sql’s. Lá eles permanecem por um certo período de tempo sendo descartados 
 através de algum algoritmo tipo LRU. O que isso quer dizer? Quer dizer que se logo depois você mandar uma 
 consulta exatamente igual ele já tem o plano dela armazenada na memória, ou seja, não há necessidade de compilar 
 a consulta novamente, basta ver que há um plano de execução ligado a uma consulta sql exatamente igual a esta e 
 vincular a nova enviada. Percebem, com isso você ganha tempo, muito tempo. 
Bem, disse a pouco que a consulta tem que ser igual, ou seja, mandar ela como: 
“select * from Cliente” fará o otimizador considerar que temos uma nova consulta e que deve passar por todas as etapas. 
Perceberam? Uma única letra diferente vai tornar sua consulta única e o otimizador precisará tratar ela individualmente. 

Bem, espero que com isso percebam que escrever consultas sempre que possível da mesma forma é um hábito saudável e 
inteligente se você pretende obter performance máxima. 

E com relação a variáveis de ligação? Onde entra isso? 
Bem, se você for esperto já deve ter percebido que usar Binding pode salvar sua aplicação. 

Vamos á um exemplo fácil de entender. Imagine que você tenha desenvolvido um sistema de Tele-Vendas, onde 
dezenas de atendentes com voz sedutora atenderá seus clientes prontamente a cada ligação a fim de vender seus 
produtos. Imagine que ela tenha em sua frente uma tela de cadastro de itens com os 50.000 itens vendidos pela
 sua empresa. Imagine que a cada instante ela vá até a rotina de busca e faça a seguinte procura. 
“ache os produtos com descrição igual á” e você tenha tratado erroneamente no programa da seguinte forma 
qry.sql.add(‘select * from produto where descrição=’+Edit1.text); 
Ou seja, você nem de perto está usando Binding, está acrescentando o parâmetro direto ao sql da consulta e mandando
 processar. Bem, pense assim, se são 10 tele-vendedoras fazendo consulta o dia todo, cada uma delas mandando consultas 
 desta forma, se cada uma delas consultar 300 itens durante o dia, teremos um total de 3.000 consultas ao banco de dados
  correto? Agora imagine que todas elas tenham consultado produtos diferentes, como você não usou Binding de variáveis 
  você simplesmente acabou de criar 3.000 entradas na área de armazenamento de sql, gerou 3.000 planos e simplesmente 
  fez o banco perder um tempo enorme fazendo tanta repetição. Se você tivesse usando Binding você teria gerado apenas 
  1 entrada. Legal né? 1 entrada contra 3.000, vale ou não apena tomar um pouco mais de cuidado? Perceba que 
  “select * from produto where código=100” é diferente de “select * from produto where código=200” enquanto que
   “select * from produto where código=:codigo” pode tratar as duas situações gerando apenas uma compilação e um 
   único plano. 

Muitas pessoas fazem uso de montagem de sql acrescentando direto ao corpo do código as variáveis por achar que isso 
é mais cômodo e não trará malefício. Bem, realmente é muito mais fácil contudo acabamos de ver que as implicações 
são enormes. 

Vou mostrar abaixo um exemplo que mostra o quão mais rápido uma aplicação usando Binding de variável é com relação 
à outra que não faz uso de tal recurso. Para tal usarei o Oracle como ferramenta de teste, caso você tenha em casa 
pode testar no sqlplus. 

O comando abaixo serve para nos assegurar que realmente quando estamos iniciando este 
teste nossa memória compartilhada esteja limpa. 

alter system flush shared_pool; 

A linha abaixo server para indicar ao sqlplus que ele deve nos dar em tela o retorno do processamento. 

set serveroutput on; 

Aqui começa o código fazendo uso de montagem do sql e não da passagem de parâmetro. Ambos os códigos são 
idênticos, o que muda é que este primeiro não faz uso de Biding enquanto o outro faz. Em suma ambos contam 
até 1000 e ao término mostra em tela o tempo gasto de processamento. 

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

Procedimento PL/SQL concluído com sucesso. 

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


Procedimento PL/SQL concluído com sucesso. 

Decorrido: 00:00:02.30 

Espantado com a comparação? Espantando o quanto o uso de Binding de variáveis pode tornar sua aplicação mais 
rápida e não sobrecarregar a memória do Oracle? 




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