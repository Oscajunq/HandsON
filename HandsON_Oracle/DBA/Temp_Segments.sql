--* File Name    : Temp_Segments.sql
--* Author       : DR Timothy S Hall
--* Description  : Displays a list of all temporary segments.
--* Requirements : Access to the DBA views.
--* Call Syntax  : @Temp_Segments
--* Last Modified: 15/07/2000
SET LINESIZE 500

SELECT owner,
       Trunc(Sum(bytes)/1024) Kb
FROM   dba_segments 
WHERE  segment_type = 'TEMPORARY'
GROUP BY owner;