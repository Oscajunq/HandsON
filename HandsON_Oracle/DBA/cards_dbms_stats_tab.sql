SQL> 
SQL> SELECT CHR(10) FROM DUAL;
                                                                                
SQL> 
SQL> SELECT 'execute dbms_stats.gather_schema_stats(ownname => '''  || OWNER || '''' ||
  2         ', estimate_percent => null , method_opt =>'||''''||
  3         'FOR ALL COLUMNS SIZE AUTO'||''''||', cascade=>true); '
  4   FROM (SELECT DISTINCT OWNER FROM DBA_TABLES
  5  WHERE OWNER = ('HOMISSR')
  6  AND TEMPORARY='N' GROUP BY OWNER HAVING COUNT(*) > 1)
  7  /
execute dbms_stats.gather_schema_stats(ownname => 'HOMISSR', estimate_percent =>
 null , method_opt =>'FOR ALL COLUMNS SIZE AUTO', cascade=>true);               
                                                                                
SQL> 
SQL> 
SQL> SPOOL OFF
