BREAK ON Name Skip 2
--* File Name    : Search_Source.sql
--* Author       : DR Timothy S Hall
--* Description  : Displays a list of all code-objects that contain the specified word.
--* Requirements : Access to the ALL views.
--* Call Syntax  : @Search_Source (text) (schema-name)
--* Last Modified: 15/07/2000
SET PAGESIZE 0
SET LINESIZE 500
SET VERIFY OFF

SPOOL Search_Source.txt

SELECT a.name "Name",
       a.line "Line",
       Substr(a.text,1,200) "Text"
FROM   all_source a
WHERE  Instr(Upper(a.text),Upper('&&1')) != 0
AND    a.owner = Upper('&&2')
ORDER BY 1,2;

SPOOL OFF
SET PAGESIZE 14
SET VERIFY ON
