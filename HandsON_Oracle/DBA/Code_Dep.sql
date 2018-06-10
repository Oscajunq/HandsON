--* File Name    : Code_Dep.sql
--* Author       : DR Timothy S Hall
--* Description  : Displays all dependencies of specified object.
--* Call Syntax  : @Code_Dep (object-name) (schema-name)
--* Last Modified: 15/07/2000
SET VERIFY OFF
SET FEEDBACK OFF
SET LINESIZE 255
SET PAGESIZE 1000
BREAK ON type SKIP 1
PROMPT

SELECT a.referenced_type "Type",
       Substr(a.referenced_owner,1,10) "Ref Owner",
       a.referenced_name "Ref Name",
       Substr(a.referenced_link_name,1,20) "Ref Link Name"
FROM   all_dependencies a
WHERE  a.name  = Upper('&1')
AND    a.owner = Upper('&2')
ORDER BY 1,2,3;

SET VERIFY ON
SET FEEDBACK ON
SET PAGESIZE 22
PROMPT
