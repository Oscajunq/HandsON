--* File Name    : Latch_Hit_Ratios.sql
--* Author       : DR Timothy S Hall
--* Description  : Displays current latch hit ratios.
--* Requirements : Access to the V$ views.
--* Call Syntax  : @Latch_Hit_Ratios
--* Last Modified: 15/07/2000
SET LINESIZE 500
SET PAGESIZE 1000
COLUMN "Latch Hit Ratio %" FORMAT 990.00
 
SELECT a.name "Latch Name",
       a.gets "Gets (Wait)",
       a.misses "Misses (Wait)",
       (1 - (misses / gets)) * 100 "Latch Hit Ratio %"
FROM   v$latch a
WHERE  a.gets   != 0
UNION
SELECT a.name "Latch Name",
       a.gets "Gets (Wait)",
       a.misses "Misses (Wait)",
       100 "Latch Hit Ratio"
FROM   v$latch a
WHERE  a.gets   = 0
ORDER BY 1;

SET PAGESIZE 14
