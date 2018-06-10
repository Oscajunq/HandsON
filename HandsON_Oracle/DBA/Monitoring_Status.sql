--* File Name    : Monitoring_Status.sql
--* Author       : DR Timothy S Hall
--* Description  : Shows the monitoring status for the specified tables.
--* Call Syntax  : @Monitoring_Status (schema) (table-name or all)
--* Last Modified: 21/03/2003
SET VERIFY OFF

SELECT table_name, monitoring 
FROM   dba_tables
WHERE  owner = UPPER('&1')
AND    table_name = DECODE(UPPER('&2'), 'ALL', table_name, UPPER('&2'));
