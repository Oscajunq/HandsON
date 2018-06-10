-- script listando WAITs, os waits por locks são no evento ENQUEUE
SET PAGES 999
SET LINESIZE 2000
column sid format 999
column seq# format 99999
column event format a29 heading "Wait Event" trunc
column state format a15 heading "Wait State" trunc
column secs format 9999999 heading "Waited so|far (sec)"
column wt format 9999999 heading "Waited|Seconds"
column P1TEXT format a38
column P2TEXT format a38
column P3TEXT format a38
prompt
prompt Sessões esperando por sql*net message estão aguardando
prompt por resposta do usuário.
prompt Sessões com wait_time <> 0 => consomem CPU
prompt
prompt Atenção à Coluna State, se ela for :
prompt Waiting => ignore Waited Secs, Waited So Far=tempo até agora
prompt Wait.Short Time => menos q um tick de CPU, ignorar
prompt Wait. Know Time => Waited Secs=tempo total esperado, ignore Wait So Far 
prompt
prompt Colunas que podem ser Especificadas como Condição, na Ordem:
prompt
prompt => SID/SEQ#, WAIT_TIME , EVENT, SECONDS_IN_WAIT, STATE,BLOCK_GETS,
prompt CONSISTENT_GETS, PHYSICAL_READS, BLOCK_CHANGES,CONSISTENT_CHANGES,
prompt PNNNTEXT, PNNN
prompt
accept v_cond_wait DEFAULT 'a.event is not null' prompt "Condições Aplicar (opcional):"
accept sid_list DEFAULT a.sid prompt "Lista de SIDs (opcional):"
accept v_orderby DEFAULT 'a.sid, a.wait_time, a.event'
prompt "Order by:"
SELECT a.sid, a.seq#, a.wait_time wt , a.event, a.seconds_in_wait secs, a.state,
b.block_gets, b.consistent_gets, b.physical_reads,
b.block_changes, b.consistent_changes,
a.P1TEXT, a.P1,
a.P2TEXT, a.P2,
a.P3TEXT, a.P3
FROM gv$session_wait a, gv$sess_io b
WHERE a.sid = b.sid
AND a.sid in (&sid_list)
AND &v_cond_wait
ORDER BY &v_orderby;
-- final do script
