--* File Name    : Login.sql
--* Author       : DR Timothy S Hall
--* Description  : Set the SQL Prompt to the current Username:Service.
--* Requirements : Access to the V$ views.
--* Call Syntax  : @Login
--* Last Modified: 15/07/2000
SET FEEDBACK OFF
SET TERMOUT OFF

VARIABLE v_database  VARCHAR2(10)

BEGIN
  SELECT Lower(name)
  INTO   :v_database
  FROM   v$database;
END;
/

SPOOL temp.sql


SELECT 'SET SQLPROMPT "' || Lower(User) || ':' || :v_database || '> "'
FROM   dual;
SPOOL OFF

@temp

EXECUTE Lib_Common.Set_User(Lower(User),'en');

SET TERMOUT ON
SET FEEDBACK ON
SET LINESIZE 100

