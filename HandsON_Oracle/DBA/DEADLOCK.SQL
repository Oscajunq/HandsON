Para verificar problemas de bloqueio em seu banco de dados, deve seguir os passos abaixo:

1. Para verificar qual a sessão que esta realizando o bloqueio, execute o select abaixo:

select sid, serial#, username, command, lockwait, osuser from v$session where lockwait is not null

2. Identificado a sessão podemos mata-la para que o bloqueio seja liberado, para isso substitua no script abaixo a sid e serial# coletados na consulta acima

alter system kill session 'sid, serial#';

Obs: Lembrando que para isso você deverá ter privilégios

3. Encontrar qual o SQL esta causando o bloqueio

select sql_text from v$sqltext where (address,hash_value) in (select sql_address,sql_hash_value from v$session where lockwait is not null) order by address, hash_value, piece

4. Ok, aprendemos a identificar e a eliminar o a sessão que estava realizando o bloqueio em nosso banco de dados e ainda a identificar a consulta/comando que estava executando o bloqueio. Agora vamos simular um caso real:

Primeiros vamos criar uma tabela e popular com alguns registros:

CREATE TABLE TbProduto (NmProduto VARCHAR(100) NOT NULL, VrPreco NUMERIC(10,2) NOT NULL);

INSERT INTO TbProduto (NmProduto, VrPreco) VALUES ('Tenis',100.50);

INSERT INTO TbProduto (NmProduto, VrPreco) VALUES ('Sapato',90.50);

INSERT INTO TbProduto (NmProduto, VrPreco) VALUES ('Chinelo',20.50);

COMMIT;

Agora em uma sessão vamos realizar um aumento no valor dos produtos em R$0.50:

UPDATE TbProduto

   SET VrPreco = VrPreco + 0.50;

3 rows updated

Não vamos commitar.

Abra uma outra sessão e vamos realizar a mesma atualização de valor, simulando uma situação em que 2 pessoas ao mesmo tempo tentou realizar o aumento do preço do produto.

UPDATE TbProduto

   SET VrPreco = VrPreco + 0.50;

Verificamos que nesse caso, não recebemos retorno de alteração dos 3 produtos, pois essa sessão esta esperando o commit da sessão anterior para realizar essa atualização, ou seja, nesse caso temos um DeadLock (onde 2 sessãos estão tentando atualizar os mesmos dados)

Não vamos commitar ainda.

Vamos abrir uma terceira sessão, é agora que vai inciar nossa análise. Primeiro vamos verificar quais as sessões que estão gerando o bloqueio:

select sid, serial#, username, command, lockwait, osuser from v$session where lockwait is not null

SID	SERIAL#	USERNAME	COMMAND	LOCKWAIT	OSUSER
51	51	SYS	6	BE99CB98	nnh-PC\nnh
 

Vamos testar a consulta para identicar o comando que esta causando o bloqueio:

select sql_text from v$sqltext where (address,hash_value) in (select sql_address,sql_hash_value from v$session where lockwait is not null) order by address, hash_value, piece

SQL_TEXT
UPDATE TbProduto    SET VrPreco = VrPreco + 0.50
 

Agora vamos matar a sessão que esta causando bloqueio;

alter system kill session '51,51';

System altered