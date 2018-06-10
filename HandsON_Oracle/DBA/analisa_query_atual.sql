--* File Name    : Open_Cursors.sql
--* Author       : DR Timothy S Hall
--* Description  : Displays a list of all cursors currently open.
--* Requirements : Access to the V$ views.
--* Call Syntax  : @Open_Cursors
--* Last Modified: 15/07/2000
SELECT a.HASH_VALUE,
       a.user_name,
       a.sid,
       b.sql_text
FROM   v$open_cursor a, v$sqlarea b
WHERE a.sid=219
AND a.ADDRESS        =b.ADDRESS
AND a.HASH_VALUE     =b.HASH_VALUE
ORDER BY 1,2
/


SELECT SQL_TEXT
  FROM V$SESSION,
       V$ACCESS,
       V$SQLTEXT 
WHERE V$SESSION.SID=V$ACCESS.SID
  AND STATUS              = 'ACTIVE' 
  AND SQL_HASH_VALUE      =  HASH_VALUE
  AND HASH_VALUE          = 1094730891
ORDER BY PIECE  
