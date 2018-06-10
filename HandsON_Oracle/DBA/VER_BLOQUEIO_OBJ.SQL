--
-- ver detalhamento dos sql que estao sendo executado no momento
--
-- scripts criado em 10/01/2008
-- DBA: Osmar
--
--
SELECT lk.SID, se.username, se.osuser, se.machine,
       DECODE (lk.TYPE,
               'TX', 'Transaction',
               'TM', 'DML',
               'UL', 'PL/SQL User Lock',
               lk.TYPE
              ) lock_type,
       DECODE (lk.lmode,
               0, 'None',
               1, 'Null',
               2, 'Row-S (SS)',
               3, 'Row-X (SX)',
               4, 'Share',
               5, 'S/Row-X (SSX)',
               6, 'Exclusive',
               TO_CHAR (lk.lmode)
              ) mode_held,
       DECODE (lk.request,
               0, 'None',
               1, 'Null',
               2, 'Row-S (SS)',
               3, 'Row-X (SX)',
               4, 'Share',
               5, 'S/Row-X (SSX)',
               6, 'Exclusive',
               TO_CHAR (lk.request)
              ) mode_requested,
       TO_CHAR (lk.id1) lock_id1, TO_CHAR (lk.id2) lock_id2, ob.owner,
       ob.object_type, ob.object_name, lk.BLOCK, se.lockwait
  FROM v$lock lk, dba_objects ob, v$session se
 WHERE lk.TYPE IN ('TM', 'UL')
   AND lk.SID = se.SID
   AND lk.id1 = ob.object_id(+)
   AND (lk.SID = '255')
 --
 --
 --
 -- VER TODOS OS BLOQUEIOS
 --  
   SELECT lk.SID, se.username, se.osuser, se.machine,
       DECODE (lk.TYPE,
               'TX', 'Transaction',
               'TM', 'DML',
               'UL', 'PL/SQL User Lock',
               lk.TYPE
              ) lock_type,
       DECODE (lk.lmode,
               0, 'None',
               1, 'Null',
               2, 'Row-S (SS)',
               3, 'Row-X (SX)',
               4, 'Share',
               5, 'S/Row-X (SSX)',
               6, 'Exclusive',
               TO_CHAR (lk.lmode)
              ) mode_held,
       DECODE (lk.request,
               0, 'None',
               1, 'Null',
               2, 'Row-S (SS)',
               3, 'Row-X (SX)',
               4, 'Share',
               5, 'S/Row-X (SSX)',
               6, 'Exclusive',
               TO_CHAR (lk.request)
              ) mode_requested,
       TO_CHAR (lk.id1) lock_id1, TO_CHAR (lk.id2) lock_id2, ob.owner,
       ob.object_type, ob.object_name, lk.BLOCK, se.lockwait
  FROM v$lock lk, dba_objects ob, v$session se
 WHERE lk.TYPE IN ('TM', 'UL') AND lk.SID = se.SID AND lk.id1 = ob.object_id(+)