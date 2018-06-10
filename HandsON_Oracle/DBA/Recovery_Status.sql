--* File Name    : Recovery_Status.sql
--* Author       : DR Timothy S Hall
--* Description  : Displays the recovery status of each datafile.
--* Requirements : Access to the V$ views.
--* Call Syntax  : @Recovery_Status
--* Last Modified: 15/07/2000
SET LINESIZE 500
SET PAGESIZE 500
SET FEEDBACK OFF

SELECT Substr(a.name,1,60) "Datafile",
       b.status "Status"
FROM   v$datafile a,
       v$backup b
WHERE  a.file# = b.file#;

SET PAGESIZE 14
SET FEEDBACK ON