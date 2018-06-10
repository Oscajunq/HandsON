--* File Name    : Latches.sql
--* Author       : DR Timothy S Hall
--* Description  : Displays information about all current latches.
--* Requirements : Access to the V$ views.
--* Call Syntax  : @Latches
--* Last Modified: 15/07/2000
SET LINESIZE 500
SET PAGESIZE 1000
SET VERIFY OFF

SELECT a.name "Latch Name",
       a.gets "Gets (Wait)",
       a.misses "Misses (Wait)",
       a.sleeps "Sleeps (Wait)",
       a.immediate_gets "Gets (No Wait)",
       a.immediate_misses "Misses (Wait)"
FROM   v$latch a
ORDER BY 1;

SET PAGESIZE 14
SET VERIFY ON