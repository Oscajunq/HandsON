--* File Name    : Column_Defaults.sql
--* Author       : DR Timothy S Hall
--* Description  : Displays the default values where present for the specified table.
--* Call Syntax  : @Column_Defaults (table-name)
--* Last Modified: 15/07/2000
SET LINESIZE 100
SET VERIFY OFF

SELECT a.column_name "Column",
       a.data_default "Default"
FROM   all_tab_columns a
WHERE  a.table_name = Upper('&1')
AND    a.data_default IS NOT NULL
/