--* File Name    : Explain.sql
--* Author       : DR Timothy S Hall
--* Description  : Displays a tree-style execution plan of the specified statement after it had=s been explained.
--* Requirements : Access to the plan table.
--* Call Syntax  : @Explain (statement-id)
--* Last Modified: 15/07/2000
COLUMN PLAN             FORMAT A50        HEADING "Execution Plan"
COLUMN OBJECT_NAME      FORMAT A30        HEADING "Object"
COLUMN OBJECT_TYPE      FORMAT A10        HEADING "Type"
COLUMN BYTES            FORMAT 9999999999 HEADING "Bytes"
COLUMN COST             FORMAT 9999999    HEADING "Cost"
COLUMN PARTITION_START  FORMAT 9999999    HEADING "PStart"
COLUMN PARTITION_STOP   FORMAT 9999999    HEADING "PEnd"
SET PAGESIZE 1000
SET LINESIZE 1000
SET VERIFY OFF
SELECT LPAD(' ', 2 * (level - 1)) ||
       Decode (level,1,NULL,level-1 || '.' || pt.position || ' ') ||
       Initcap(pt.operation) ||
       Decode(pt.options,NULL,'',' (' || Initcap(pt.options) || ')') plan,
       pt.object_name,
       pt.object_type,
       pt.bytes,
       pt.cost,
       pt.partition_start,
       pt.partition_stop
FROM   plan_table pt
START WITH pt.id = 0
  AND pt.statement_id = '&1'
CONNECT BY PRIOR pt.id = pt.parent_id
  AND pt.statement_id = '&1';
SET VERIFY ON