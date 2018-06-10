--* File Name    : Table_Indexes.sql
--* Author       : DR Timothy S Hall
--* Description  : Displays index-column information for the specified table.
--* Requirements : Access to the DBA views.
--* Call Syntax  : @Table_Indexes (table-name) (schema-name)
--* Last Modified: 15/07/2000
SET LINESIZE 500
SET PAGESIZE 1000
SET VERIFY OFF

COLUMN index_name      FORMAT A30
COLUMN column_name     FORMAT A30
COLUMN column_position FORMAT 99999

SELECT a.index_name,
       a.column_name,
       a.column_position
FROM   all_ind_columns a,
       all_indexes b
WHERE  b.table_name = Upper('&&1')
AND    b.owner      = Upper('&&2')
AND    b.index_name = a.index_name
AND    b.owner      = a.index_owner
ORDER BY 1,3;

SET PAGESIZE 18
SET VERIFY ON