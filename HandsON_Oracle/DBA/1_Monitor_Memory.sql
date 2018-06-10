--* File Name    : Monitor_Memory.sql
--* Author       : DR Timothy S Hall
--* Description  : Displays memory allocations for the current database sessions.
--* Requirements : Access to the V$ views.
--* Call Syntax  : @Monitor_Memory
--* Last Modified: 15/07/2000
SELECT NVL(a.username,'{Background Task}') "Username",
       a.program "Program",
       Trunc(b.value/1024) "Memory (Kb)"
FROM   v$session a,
       v$sesstat b,
       v$statname c
WHERE  a.sid = b.sid
AND    b.statistic# = c.statistic#
AND    c.name = 'session pga memory'
AND    a.program IS NOT NULL
ORDER BY b.value DESC;