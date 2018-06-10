--* File Name    : Health.sql
--* Author       : DR Timothy S Hall
--* Description  : Lots of information about the database so you can asses the general health of the system.
--* Requirements : Access to the V$ & DBA views and several other monitoring scripts.
--* Call Syntax  : @Health (username/password@service)
--* Last Modified: 15/07/2000
SET LINESIZE 2000
SPOOL c:\dba\Health_Checks.txt

--conn &1
@c:\dba\db_info
@c:\dba\sessions
@c:\dba\ts_full
@c:\dba\max_extents

SPOOL OFF