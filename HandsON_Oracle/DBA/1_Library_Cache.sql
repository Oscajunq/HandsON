--* File Name    : Library_Cache.sql
--* Author       : DR Timothy S Hall
--* Description  : Displays library cache statistics.
--* Requirements : Access to the V$ views.
--* Call Syntax  : @Library_Cache
--* Last Modified: 15/07/2000
SET LINESIZE 500
SET PAGESIZE 1000
SET VERIFY OFF

SELECT a.namespace "Name Space",
       a.gets "Get Requests",
       a.gethits "Get Hits",
       Round(a.gethitratio,2) "Get Ratio",
       a.pins "Pin Requests",
       a.pinhits "Pin Hits",
       Round(a.pinhitratio,2) "Pin Ratio",
       a.reloads "Reloads",
       a.invalidations "Invalidations"
FROM   v$librarycache a
ORDER BY 1;

SET PAGESIZE 14
SET VERIFY ON