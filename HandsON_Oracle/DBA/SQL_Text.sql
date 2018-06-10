--* File Name    : SQL_Text.sql
--* Author       : DR Timothy S Hall
--* Description  : Displays the SQL statement held at the specified address.
--* Comments     : The address can be found using v$session or Top_SQL.sql.
--* Requirements : Access to the V$ views.
--* Call Syntax  : @SQL_Text (address)
--* Last Modified: 15/07/2000
SET LINESIZE 500
SET PAGESIZE 1000
SET FEEDBACK OFF
SET VERIFY OFF

SELECT a.sql_text "SQL Text"
FROM   v$sqltext a
WHERE  a.address = Upper('&&1')
ORDER BY a.piece;

PROMPT
SET PAGESIZE 14
SET FEEDBACK ON
