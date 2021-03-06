Para verificar problemas de bloqueio em seu banco de dados, deve seguir os passos abaixo:

1. Para verificar qual a sess�o que esta realizando o bloqueio, execute o select abaixo:

select sid, serial#, username, command, lockwait, osuser from v$session where lockwait is not null

2. Identificado a sess�o podemos mata-la para que o bloqueio seja liberado, para isso substitua no script abaixo a sid e serial# coletados na consulta acima

alter system kill session 'sid, serial#';

Obs: Lembrando que para isso voc� dever� ter privil�gios

3. Encontrar qual o SQL esta causando o bloqueio

select sql_text from v$sqltext where (address,hash_value) in (select sql_address,sql_hash_value from v$session where lockwait is not null) order by address, hash_value, piece

4. Ok, aprendemos a identificar e a eliminar o a sess�o que estava realizando o bloqueio em nosso banco de dados e ainda a identificar a consulta/comando que estava executando o bloqueio. Agora vamos simular um caso real:

Primeiros vamos criar uma tabela e popular com alguns registros:

CREATE TABLE TbProduto (NmProduto VARCHAR(100) NOT NULL, VrPreco NUMERIC(10,2) NOT NULL);

INSERT INTO TbProduto (NmProduto, VrPreco) VALUES ('Tenis',100.50);

INSERT INTO TbProduto (NmProduto, VrPreco) VALUES ('Sapato',90.50);

INSERT INTO TbProduto (NmProduto, VrPreco) VALUES ('Chinelo',20.50);

COMMIT;

Agora em uma sess�o vamos realizar um aumento no valor dos produtos em R$0.50:

UPDATE TbProduto

   SET VrPreco = VrPreco + 0.50;

3 rows updated

N�o vamos commitar.

Abra uma outra sess�o e vamos realizar a mesma atualiza��o de valor, simulando uma situa��o em que 2 pessoas ao mesmo tempo tentou realizar o aumento do pre�o do produto.

UPDATE TbProduto

   SET VrPreco = VrPreco + 0.50;

Verificamos que nesse caso, n�o recebemos retorno de altera��o dos 3 produtos, pois essa sess�o esta esperando o commit da sess�o anterior para realizar essa atualiza��o, ou seja, nesse caso temos um DeadLock (onde 2 sess�os est�o tentando atualizar os mesmos dados)

N�o vamos commitar ainda.

Vamos abrir uma terceira sess�o, � agora que vai inciar nossa an�lise. Primeiro vamos verificar quais as sess�es que est�o gerando o bloqueio:

select sid, serial#, username, command, lockwait, osuser from v$session where lockwait is not null

SID	SERIAL#	USERNAME	COMMAND	LOCKWAIT	OSUSER
51	51	SYS	6	BE99CB98	nnh-PC\nnh
 

Vamos testar a consulta para identicar o comando que esta causando o bloqueio:

select sql_text from v$sqltext where (address,hash_value) in (select sql_address,sql_hash_value from v$session where lockwait is not null) order by address, hash_value, piece

SQL_TEXT
UPDATE TbProduto    SET VrPreco = VrPreco + 0.50
 

Agora vamos matar a sess�o que esta causando bloqueio;

alter system kill session '51,51';

System altered