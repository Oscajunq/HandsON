--* File Name    : Top_SQL.sql
--* Author       : DR Timothy S Hall
--* Description  : Displays a list of SQL statements that are using the most resources.
--* Comments     : The address column can be use as a parameter with SQL_Text.sql to display the full statement.
--* Requirements : Access to the V$ views.
--* Call Syntax  : @Top_SQL (number)
--* Last Modified: 15/07/2000
SET LINESIZE 500
SET PAGESIZE 1000
SET FEEDBACK OFF
SET VERIFY OFF
SET SERVEROUTPUT ON
PROMPT

DECLARE

  CURSOR c_sql IS
    SELECT Substr(a.sql_text,1,50) sql_text,
           Trunc(a.disk_reads/Decode(a.executions,0,1,a.executions)) reads_per_execution, 
           a.buffer_gets, 
           a.disk_reads, 
           a.executions, 
           a.sorts,
           a.address
    FROM   v$sqlarea a
    ORDER BY 2 DESC;
    
BEGIN

  Dbms_Output.Enable(1000000);
  
  Dbms_Output.Put_Line(Rpad('SQL Text',50,' ') ||
                       Lpad('Reads/Execution',16,' ') ||
                       Lpad('Buffer Gets',12,' ') ||
                       Lpad('Disk Reads',12,' ') ||
                       Lpad('Executions',12,' ') ||
                       Lpad('Sorts',12,' ') ||
                       Lpad('Address',10,' '));
  Dbms_Output.Put_Line(Rpad('-',50,'-') || ' ' ||
                       Lpad('-',15,'-') || ' ' ||
                       Lpad('-',11,'-') || ' ' ||
                       Lpad('-',11,'-') || ' ' ||
                       Lpad('-',11,'-') || ' ' ||
                       Lpad('-',11,'-') || ' ' ||
                       Lpad('-',9,'-'));
  
  << top_sql >>
  FOR cur_rec IN c_sql LOOP
    Dbms_Output.Put_Line(Rpad(cur_rec.sql_text,50,' ') ||
                         Lpad(cur_rec.reads_per_execution,16,' ') ||
                         Lpad(cur_rec.buffer_gets,12,' ') ||
                         Lpad(cur_rec.disk_reads,12,' ') ||
                         Lpad(cur_rec.executions,12,' ') ||
                         Lpad(cur_rec.sorts,12,' ') ||
                         Lpad(cur_rec.address,10,' '));
    
    IF c_sql%ROWCOUNT = &&1 THEN
      EXIT top_sql;
    END IF;
  END LOOP;
  
END;
/  

PROMPT
SET PAGESIZE 14
SET FEEDBACK ON
