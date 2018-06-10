--* File Name    : Dict_Comments.sql
--* Author       : DR Timothy S Hall
--* Description  : Displays general information about the database.
--* Call Syntax  : @Dict_Comments (table-name)
--* Last Modified: 15/07/2000
PROMPT
SET VERIFY OFF
SET FEEDBACK OFF
SET LINESIZE 255
SET PAGESIZE 1000

SELECT a.table_name "Table",
       Substr(a.comments,1,200) "Comments"
FROM   dict a
WHERE  a.table_name = Upper('&&1');

SELECT a.column_name "Column",
       Substr(a.comments,1,200) "Comments"
FROM   dict_columns a
WHERE  a.table_name = Upper('&&1');

SET VERIFY ON
SET FEEDBACK ON
SET PAGESIZE 14
PROMPT
