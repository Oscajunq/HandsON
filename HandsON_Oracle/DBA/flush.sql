Quando a area de buffer cache, log buffer e shared pool esta cheia ou,
precisamos dar uma "limpada" nestas areas para que o analise do performance seja feito, precisamos então executar o comando alter system flush.
Com a consulta abaixo você consegue enxergar quais sao os objetos atualmente no buffer cache.

SELECT o.owner,
o.object_type,
substr(o.object_name,1,10)
objname,
b.objd,
b.status,
count(b.objd)
FROM v$bh b, dba_objects o
WHERE b.objd = o.data_object_id
AND o.owner not in ('SYS','SYSTEM','SYSMAN')
GROUP BY o.owner,
o.object_type,
o.object_name,
b.objd,
b.status;

Se caso, alguns objetos persistem em ficar na memória, iremos entao fazer a limpeza dessa area:

SQL> alter system flush buffer_pool;

Com o bloco abaixo conseguimos verificar se o pool atingiu mais de 70% e então se caso necessario podemos acionar a limpeza..

CREATE OR REPLACE VIEW sys.sql_summary AS SELECT
username,
sharable_mem,
persistent_mem,
runtime_mem
FROM sys.v_$sqlarea a, dba_users b
WHERE a.parsing_user_id = b.user_id;

BEGIN

CURSOR get_share IS
SELECT SUM(sharable_mem)
FROM sys.sql_summary;

CURSOR get_var IS
SELECT value
FROM v$sga
WHERE name like 'Var%';

CURSOR get_time is
SELECT SYSDATE
FROM dual;

todays_date DATE;
mem_ratio NUMBER;
share_mem NUMBER;
variable_mem NUMBER;
cur INTEGER;
sql_com VARCHAR2(60);
row_proc NUMBER;

BEGIN

OPEN get_share;
OPEN get_var;

FETCH get_share INTO share_mem;
DBMS_OUTPUT.PUT_LINE('share_mem: '||to_char(share_mem));

FETCH get_var INTO variable_mem;
DBMS_OUTPUT.PUT_LINE('variable_mem: '||to_char(variable_mem));

mem_ratio:=share_mem/variable_mem;
DBMS_OUTPUT.PUT_LINE('mem_ratio: '||to_char(mem_ratio));

IF (mem_ratio>0.3) THEN
DBMS_OUTPUT.PUT_LINE ('Flushing Shared Pool ... Limpeza a vista');
cur:=DBMS_SQL.open_cursor;
sql_com:='ALTER SYSTEM FLUSH SHARED_POOL';
DBMS_SQL.PARSE(cur,sql_com,dbms_sql.v7);
row_proc:=DBMS_SQL.EXECUTE(cur);
DBMS_SQL.CLOSE_CURSOR(cur);
END IF;
END;
/