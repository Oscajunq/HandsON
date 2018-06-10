--
-- AVALIAR SEGMENTOS DE ROLLBACK E UNDO EM USO
--
SELECT   r.segment_name, r.tablespace_name, s.SID, s.serial#, s.username,
         s.machine, t.status, t.cr_get, /*consistent gets*/ t.phy_io, /*physical io*/
         t.used_ublk, /*Undo blocks used*/ t.noundo, /*Is a noundo transaction*/
         SUBSTR (s.program, 1, 78) "COMMAND", s.username "DB User",
         t.start_time, s.sql_address "Address", s.sql_hash_value "Sql Hash"
    FROM SYS.v_$session s, SYS.v_$transaction t, SYS.dba_rollback_segs r
   WHERE t.addr = s.taddr AND t.xidusn = r.segment_id
ORDER BY t.start_time
--
-- VER EXPECIFICAMENTE O USO DO ROLLBACK DA SESSAO ATIVA
--
SELECT   r.segment_name, r.tablespace_name, t.status, t.cr_get, t.phy_io,
         t.used_ublk, t.noundo, t.start_time
    FROM SYS.v_$transaction t, dba_rollback_segs r
   WHERE (t.xidusn = r.segment_id) AND ((t.addr = '000000039DEAEFD0'))
ORDER BY t.start_time