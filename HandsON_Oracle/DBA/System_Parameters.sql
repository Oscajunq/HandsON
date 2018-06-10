--* File Name    : System_Parameters.sql
--* Author       : DR Timothy S Hall
--* Description  : Displays a list of all the system parameters.
--* Requirements : Access to the v$ views.
--* Call Syntax  : @System_Parameters
--* Last Modified: 15/07/2000
PROMPT
SET LINESIZE 500
SET PAGESIZE 30
SET PAUSE ON

COLUMN "Name"  FORMAT A30
COLUMN "Value" FORMAT A200

SELECT Upper(a.name) "Name",
       Substr(a.value,1,200) "Value"
FROM   v$system_parameter a
ORDER BY 1;

SET PAUSE OFF
PROMPT
