--
-- ver detalhamento da sessao utilizada pelo usuario
--
-- scripts criado em 10/01/2008
-- DBA: Osmar
--
-- eliminar forcadamente uma sessão inativa
--
ALTER SYSTEM DISCONNECT 'sid, serial' IMMEDIATE
--
--
SELECT username,SID, s.serial#, status
  FROM v$session s
 WHERE 
 --SID = '244'
 --      AND 
       (    (s.username IS NOT NULL)
            AND (NVL (s.osuser, 'x') <> 'SYSTEM')
            AND (s.TYPE <> 'BACKGROUND')
           );
--
SELECT username, status, program, count(*)
  FROM v$session s
 WHERE 
       (    (s.username IS NOT NULL)
            AND (NVL (s.osuser, 'x') <> 'SYSTEM')
            AND (s.TYPE <> 'BACKGROUND')
           )
group BY username,status,program           
--
--
-- mais detalhamento da sessao
--
SELECT sharable_mem, persistent_mem, runtime_mem, sorts, loaded_versions,
       open_versions, users_opening, executions, users_executing, loads,
       first_load_time, invalidations, parse_calls, disk_reads, buffer_gets,
       rows_processed, command_type, optimizer_mode, optimizer_cost,
       parsing_user_id, parsing_schema_id, kept_versions, address, hash_value,
       child_number, module, module_hash, action, action_hash,
       serializable_aborts, type_chk_heap, outline_category, is_obsolete,
       last_load_time, outline_sid, elapsed_time, cpu_time, plan_hash_value,
       fetches
  FROM v$sql
 WHERE (address, hash_value) = (SELECT sql_address, sql_hash_value
                                  FROM v$session
                                 WHERE SID = :SID);
--
--
--
-- VER TODAS AS SESSOES DE UM DETERMINADOR OWNER
--
SELECT ROUND (BITAND (s.ownerid, 65535)) parent_session_sid,
       ROUND (BITAND (s.ownerid, 16711680) / 65536) parent_session_instid,
       s.saddr, s.SID, s.serial#, s.audsid, s.paddr, s.user#, s.username,
       s.command, s.ownerid, s.taddr, s.lockwait, s.status, s.server,
       s.schema#, s.schemaname, s.osuser, s.process, s.machine, s.terminal,
       UPPER (s.program) program, s.TYPE, s.sql_address, s.sql_hash_value,
       s.sql_id, s.sql_child_number, s.prev_sql_addr, s.prev_hash_value,
       s.prev_sql_id, s.prev_child_number, s.plsql_entry_object_id,
       s.plsql_entry_subprogram_id, s.plsql_object_id, s.plsql_subprogram_id,
       s.module, s.module_hash, s.action, s.action_hash, s.client_info,
       s.fixed_table_sequence, s.row_wait_obj#, s.row_wait_file#,
       s.row_wait_block#, s.row_wait_row#, s.logon_time, s.last_call_et,
       s.pdml_enabled, s.failover_type, s.failover_method, s.failed_over,
       s.resource_consumer_group, s.pdml_status, s.pddl_status, s.pq_status,
       s.current_queue_duration, s.client_identifier,
       s.blocking_session_status, s.blocking_instance, s.blocking_session,
       s.seq#, s.event#, s.event, s.p1text, s.p1, s.p1raw, s.p2text, s.p2,
       s.p2raw, s.p3text, s.p3, s.p3raw, s.wait_class_id, s.wait_class#,
       s.wait_class, s.wait_time, s.seconds_in_wait, s.state, s.service_name,
       s.sql_trace, s.sql_trace_waits, s.sql_trace_binds
  FROM v$session s
 WHERE (s.username = 'HOMISSR2')
   AND (    (s.username IS NOT NULL)
        AND (NVL (s.osuser, 'x') <> 'SYSTEM')
        AND (s.TYPE <> 'BACKGROUND')
       )
--
--
-- VER O LONG OPS DA SESSAO ATIVA
--
SELECT   SID,
         DECODE (totalwork,
                 0, 0,
                 ROUND (100 * sofar / totalwork, 2)
                ) "Percent",
         MESSAGE "Message", start_time, elapsed_seconds, time_remaining
    FROM v$session_longops
   WHERE (SID = 149 AND serial# = 32850)
ORDER BY SID

------------------------------------------------------------------------------------------------ 
--- verificando a sessao que esta rodando em relacao ao PID no unix
---          
---

[brsassmm085]# top
   PID USERNAME LWP PRI NICE  SIZE   RES STATE    TIME    CPU COMMAND
 23695 oracle     2  50    0 1693M 1651M cpu      5:23 97.65% oracle
  4650 oracle     1  50    0 1704M 1661M cpu      0:03 56.43% oracle
 12993 oracle     2  31    0 1691M 1649M sleep    2:01 18.91% oracle
  7099 oracle     1 100  -20 1697M 1620M sleep   38:53  1.33% oracle
  7103 oracle     1 100  -20 1697M 1612M sleep   35:20  1.24% oracle
 29301 oracle     2  59    0 1688M 1645M sleep    3:42  0.80% oracle
 26903 oracle     2  59    0 1688M 1631M sleep    2:07  0.49% oracle
  3153 oracle     1  59    0 2536K 2136K cpu      0:00  0.42% top
  7119 oracle     1  59    0 1688M 1628M sleep    6:22  0.35% oracle
  3711 oracle    15  59   -5  200M  157M sleep    5:36  0.27% ocssd.bin
  7095 oracle     2  59    0 1692M 1607M sleep    4:18  0.22% oracle
  2373 root       1  11    0 1384K 1000K sleep    3:45  0.21% init.cssd
  2879 root       1 111  -20  165M  132M sleep    3:23  0.18% lkmgr
  3102 root      10  59    0   11M 7832K sleep    5:59  0.16% caiUxOs
  7097 oracle     1  59    0 1698M 1604M sleep    3:34  0.14% oracle

SELECT
lpad(A.username,8) "User",
lpad(A.osuser,8) "OSUser",
lpad(A.sid, 5) "SID",
TO_CHAR(A.serial#, '999999999') "SERIAL#",
A.status,
TO_CHAR(B.spid, '999999999') "OS PID",
TO_CHAR(A.logon_time, 'DD/MM/YYYY HH24:MI:SS') "LOGON" ,
A.program,
A.machine,
S_IO.physical_reads,
( select SQL_TEXT from v$sqlarea C where (C.address,C.HASH_VALUE)=(select D.PREV_SQL_addr,D.PREV_HASH_VALUE from v$session D where D.sid=A.sid) ) as "SQL"
FROM v$session A, v$process B, v$sess_io S_IO
   WHERE A.type = 'USER'
    AND LENGTH(LTRIM(RTRIM(A.username))) > 0
    AND B.addr = A.paddr
    AND A.sid  = S_IO.sid
           AND B.SPID = &spid
   ORDER BY A.username, A.logon_time DESC;

Enter value for spid: 23695
old  18:            AND B.SPID = &spid
new  18:            AND B.SPID = 23695


User       OSUser     SID   SERIAL#    STATUS OS PID     LOGON                Program                   MACHINE         PHYSICAL_READS SQL
---------- ---------- ----- ---------- ------ ---------- -------------------- ------------------------- --------------- -------------- ----------------------------------------
ISSR_PRD                215       2425 ACTIVE      23695 03/06/2008 10:11:07                            BRSASSMM083               2991 select produto, sum(qtd_paginas) qtd_pag
                                                                                                                                       inas, count(1) total_contas, to_char(sum
                                                                                                                                       (valor_fatura),'9999999999990d00') valor
                                                                                                                                       _fatura from vw_eds_rel_e133_arq  Where
                                                                                                                                        COD_EMISSOR= '1001' and  trim(COD_ARQUI
                                                                                                                                       VO) = '810' group by produto




SELECT
lpad(A.username,8) "User",
lpad(A.osuser,8) "OSUser",
lpad(A.sid, 5) "SID",
TO_CHAR(A.serial#, '999999999') "SERIAL#",
A.status,
TO_CHAR(B.spid, '999999999') "OS PID",
TO_CHAR(A.logon_time, 'DD/MM/YYYY HH24:MI:SS') "LOGON" ,
A.program,
A.machine,
( select SQL_TEXT from v$sqlarea C where (C.address,C.HASH_VALUE)=(select D.PREV_SQL_addr,D.PREV_HASH_VALUE from v$session D where D.sid=A.sid) ) as "SQL"
FROM v$session A, v$process B
   WHERE 
    B.addr = A.paddr
    AND A.STATUS ='KILLED'
    
   ORDER BY A.username, A.logon_time DESC;
   
   

Eliminando sessões Inativas no bd Oracle
========================================

Muitas vezes é necessário a eliminação "forçada" de sessões inativas num bd Oracle (normalmente porque o operador encerrou o seu trabalho mas 
não desconectou, deixando erradamente a tale do aplicativo aberta, ainda conectada.

Pensando em conexão dedicada e banco 9i ou superior, que são o caso mais comum, essa eliminação seria feita num job que periodicamente, seja 
via comandos ALTER SYSTEM DISCONNECT 'sid, serial' IMMEDIATE; , ou até mais diretamente eliminando-se o processo shadow dessa conexão diretamente 
no servidor. 

Há porém um ponto a considerar, qual seja : no bd Oracle quando vc elimina uma sessão ela NÃO é removida até que expire OU que o usuário tente 
fazer um novo acesso ao banco, quando aí sim receberá uma mensagem "vc foi desconectado" e só então efetivamente será desconectado e a respectiva 
sessão eliminada - se quisermos que a sessão seja removida antes mesmo que o usuário tente fazer novo acesso ao banco, poderíamos utilizar um PROFILE, 
cfrme : 

system@BDDEV:SQL>show parameters resource_limit

NAME TYPE VALUE
------------------------------------ -----------
------------------------------
resource_limit boolean TRUE

system@BDDEV:SQL>create profile prof_idle_2_minutos limit idle_time 120;

Perfil criado.


system@BDDEV:SQL>alter user scott profile prof_idle_2_minutos;

Usuário alterado.

==> aí conecto no usuário SCOTT. Veja que enquanto a sessão não está fazendo
NADA mas está conectada o idle_time não atua :

scott@BDDEV:SQL>select sysdate from dual;

SYSDATE
-------------------
04/07/2006 09:47:41

... não estou fazendo nada , espero uns minutos e volto à sessão, tento fazer
outro acesso ao banco, vai ok :

scott@BDDEV:SQL>/

SYSDATE
-------------------
04/07/2006 09:50:18

==> agora vem o teste: vou fazer uma QUERY "grande" e demorada (*** NÃO *** é
DML, pois no caso de DMLs há que se remover locks, fazer rollback, isso é MESMO
demorado) :

scott@BDDEV:SQL>select * from all_tab_columns;
... executando ...

==> aí consulto a situação na v$session, está lá, está ativa, normal :

..... SID SERIAL# ... STATUS SERVER ...
---- ------- -------- --------- 
20 34889 ACTIVE DEDICATED 

system@BDDEV:SQL>alter system disconnect session '20, 34889' immediate;

==> imediatamente a sessão foi marcada como KILLED

system@BDDEV:SQL>select * from v$session where username='SCOTT';

..... SID SERIAL# ... STATUS SERVER ...
..... ---- ------- ... -------- --------- 
..... 20 34889 ... KILLED PSEUDO 

==> espero um pouco pra dar o tempo de inatividade...

system@BDDEV:SQL>/

não há linhas selecionadas

==> e senm ter feito nada, na sessão que "morreu" eu obtenho :

SYS EXU8NXPU NAME 
SYS EXU9TABU DOBJID 
ERROR:
ORA-00028: your session has been killed

e realmente a sessão foi eliminada, se tentar um acesso ao banco :

scott@BDDEV:SQL>select 1 from dual;
select 1 from dual
*
ERRO na linha 1:
ORA-01012: not logged on

   