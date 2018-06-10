SQL Tuning Advisor
In order to access the SQL tuning advisor API a user must be granted the ADVISOR privilege:

CONN sys/password AS SYSDBA
GRANT ADVISOR TO scott;
CONN scott/tiger

The first step when using the SQL tuning advisor is to create a new tuning task using 
the CREATE_TUNING_TASK function. The statements to be analyzed can be retrieved from
 the Automatic Workload Repository (AWR), the cursor cache, an SQL tuning set or specified manually:

SET SERVEROUTPUT ON

-- Tuning task created for specific a statement from the AWR.
DECLARE
  l_sql_tune_task_id  VARCHAR2(100);
BEGIN
  l_sql_tune_task_id := DBMS_SQLTUNE.create_tuning_task (
                          begin_snap  => 764,
                          end_snap    => 938,
                          sql_id      => '19v5guvsgcd1v',
                          scope       => DBMS_SQLTUNE.scope_comprehensive,
                          time_limit  => 60,
                          task_name   => '19v5guvsgcd1v_AWR_tuning_task',
                          description => 'Tuning task for statement 19v5guvsgcd1v in AWR.');
  DBMS_OUTPUT.put_line('l_sql_tune_task_id: ' || l_sql_tune_task_id);
END;
/

-- Tuning task created for specific a statement from the cursor cache.
DECLARE
  l_sql_tune_task_id  VARCHAR2(100);
BEGIN
  l_sql_tune_task_id := DBMS_SQLTUNE.create_tuning_task (
                          sql_id      => '19v5guvsgcd1v',
                          scope       => DBMS_SQLTUNE.scope_comprehensive,
                          time_limit  => 60,
                          task_name   => '19v5guvsgcd1v_tuning_task',
                          description => 'Tuning task for statement 19v5guvsgcd1v.');
  DBMS_OUTPUT.put_line('l_sql_tune_task_id: ' || l_sql_tune_task_id);
END;
/

-- Tuning task created from an SQL tuning set.
DECLARE
  l_sql_tune_task_id  VARCHAR2(100);
BEGIN
  l_sql_tune_task_id := DBMS_SQLTUNE.create_tuning_task (
                          sqlset_name => 'test_sql_tuning_set',
                          scope       => DBMS_SQLTUNE.scope_comprehensive,
                          time_limit  => 60,
                          task_name   => 'sqlset_tuning_task',
                          description => 'Tuning task for an SQL tuning set.');
  DBMS_OUTPUT.put_line('l_sql_tune_task_id: ' || l_sql_tune_task_id);
END;
/

-- Tuning task created for a manually specified statement.
DECLARE
  l_sql               VARCHAR2(500);
  l_sql_tune_task_id  VARCHAR2(100);
BEGIN
  l_sql := 'SELECT e.*, d.* ' ||
           'FROM   emp e JOIN dept d ON e.deptno = d.deptno ' ||
           'WHERE  NVL(empno, ''0'') = :empno';

  l_sql_tune_task_id := DBMS_SQLTUNE.create_tuning_task (
                          sql_text    => l_sql,
                          bind_list   => sql_binds(anydata.ConvertNumber(100)),
                          user_name   => 'scott',
                          scope       => DBMS_SQLTUNE.scope_comprehensive,
                          time_limit  => 60,
                          task_name   => 'emp_dept_tuning_task',
                          description => 'Tuning task for an EMP to DEPT join query.');
  DBMS_OUTPUT.put_line('l_sql_tune_task_id: ' || l_sql_tune_task_id);
END;
/
If the TASK_NAME parameter is specified it's value is returned as the SQL tune task identifier. 
If ommitted a system generated name like "TASK_1478" is returned. If the SCOPE parameter is set to
 scope_limited the SQL profiling analysis is omitted. The TIME_LIMIT parameter simply restricts the
 time the optimizer can spend compiling the recommendations.

The following examples will reference the last tuning set as it has no external dependancies
 other than the SCOTT schema. The NVL in the SQL statement was put in to provoke a reaction from
  the optimizer. In addition we can delete the statistics from one of the tables to provoke it even more:

EXEC DBMS_STATS.delete_table_stats('SCOTT','EMP');
With the tuning task defined the next step is to execute it using the EXECUTE_TUNING_TASK procedure:

EXEC DBMS_SQLTUNE.execute_tuning_task(task_name => 'emp_dept_tuning_task');
During the execution phase you may wish to pause and restart the task, cancel it or reset the
 task to allow it to be re-executed:

-- Interrupt and resume a tuning task.
EXEC DBMS_SQLTUNE.interrupt_tuning_task (task_name => 'emp_dept_tuning_task');
EXEC DBMS_SQLTUNE.resume_tuning_task (task_name => 'emp_dept_tuning_task');

-- Cancel a tuning task.
EXEC DBMS_SQLTUNE.cancel_tuning_task (task_name => 'emp_dept_tuning_task');

-- Reset a tuning task allowing it to be re-executed.
EXEC DBMS_SQLTUNE.reset_tuning_task (task_name => 'emp_dept_tuning_task');
The status of the tuning task can be monitored using the DBA_ADVISOR_LOG view:

SELECT task_name, status FROM dba_advisor_log WHERE owner = 'SCOTT';

TASK_NAME                      STATUS
------------------------------ -----------
emp_dept_tuning_task           COMPLETED

1 row selected.
Once the tuning task has executed successfully the recommendations can be displayed using the REPORT_TUNING_TASK function:

SET LONG 10000;
SET PAGESIZE 1000
SET LINESIZE 200
SELECT DBMS_SQLTUNE.report_tuning_task('emp_dept_tuning_task') AS recommendations FROM dual;
SET PAGESIZE 24
In this case the output looks like this:

RECOMMENDATIONS
--------------------------------------------------------------------------------
GENERAL INFORMATION SECTION
-------------------------------------------------------------------------------
Tuning Task Name   : emp_dept_tuning_task
Scope              : COMPREHENSIVE
Time Limit(seconds): 60
Completion Status  : COMPLETED
Started at         : 05/06/2004 09:29:13
Completed at       : 05/06/2004 09:29:15

-------------------------------------------------------------------------------
SQL ID  : 0wrmfv2yvswx1
SQL Text: SELECT e.*, d.* FROM   emp e JOIN dept d ON e.deptno = d.deptno
          WHERE  NVL(empno, '0') = :empno

-------------------------------------------------------------------------------
FINDINGS SECTION (2 findings)
-------------------------------------------------------------------------------

1- Statistics Finding
---------------------
  Table "SCOTT"."EMP" and its indices were not analyzed.

  Recommendation
  --------------
    Consider collecting optimizer statistics for this table and its indices.
    execute dbms_stats.gather_table_stats(ownname => 'SCOTT', tabname =>
            'EMP', estimate_percent => DBMS_STATS.AUTO_SAMPLE_SIZE,
            method_opt => 'FOR ALL COLUMNS SIZE AUTO', cascade => TRUE)

  Rationale
  ---------
    The optimizer requires up-to-date statistics for the table and its indices
    in order to select a good execution plan.

2- Restructure SQL finding (see plan 1 in explain plans section)
----------------------------------------------------------------
  The predicate NVL("E"."EMPNO",0)=:B1 used at line ID 2 of the execution plan
  contains an expression on indexed column "EMPNO". This expression prevents
  the optimizer from selecting indices on table "SCOTT"."EMP".

  Recommendation
  --------------
    Rewrite the predicate into an equivalent form to take advantage of
    indices. Alternatively, create a function-based index on the expression.

  Rationale
  ---------
    The optimizer is unable to use an index if the predicate is an inequality
    condition or if there is an expression or an implicit data type conversion
    on the indexed column.

-------------------------------------------------------------------------------
EXPLAIN PLANS SECTION
-------------------------------------------------------------------------------

1- Original
-----------
Plan hash value: 1863486531

----------------------------------------------------------------------------------------
| Id  | Operation                    | Name    | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT             |         |     1 |   107 |     4   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                |         |     1 |   107 |     4   (0)| 00:00:01 |
|   2 |   TABLE ACCESS FULL          | EMP     |     1 |    87 |     3   (0)| 00:00:01 |
|   3 |   TABLE ACCESS BY INDEX ROWID| DEPT    |     1 |    20 |     1   (0)| 00:00:01 |
|   4 |    INDEX UNIQUE SCAN         | PK_DEPT |     1 |       |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------------------

Note
-----
   - dynamic sampling used for this statement

-------------------------------------------------------------------------------


1 row selected.
Once the tuning session is over the tuning task can be dropped using the DROP_TUNING_TASK procedure:

BEGIN
  DBMS_SQLTUNE.drop_tuning_task (task_name => '19v5guvsgcd1v_AWR_tuning_task');
  DBMS_SQLTUNE.drop_tuning_task (task_name => '19v5guvsgcd1v_tuning_task');
  DBMS_SQLTUNE.drop_tuning_task (task_name => 'sqlset_tuning_task');
  DBMS_SQLTUNE.drop_tuning_task (task_name => 'emp_dept_tuning_task');
END;
/
Managing SQL Profiles
To manage SQL profiles a user needs the following privileges:

CONN sys/password AS SYSDBA
GRANT CREATE ANY SQL PROFILE TO scott;
GRANT DROP ANY SQL PROFILE TO scott;
GRANT ALTER ANY SQL PROFILE TO scott;
CONN scott/tiger
If the recommendations of the SQL tuning advisor include a suggested profile you can choose to 
accept it using the ACCEPT_SQL_PROFILE procedure:

SET SERVEROUTPUT ON
DECLARE
  l_sql_tune_task_id  VARCHAR2(20);
BEGIN
  l_sql_tune_task_id := DBMS_SQLTUNE.accept_sql_profile (
                          task_name => 'emp_dept_tuning_task',
                          name      => 'emp_dept_profile');
  DBMS_OUTPUT.put_line('l_sql_tune_task_id: ' || l_sql_tune_task_id);
END;
/
The NAME parameter is used to specify a name for the profile. If it is not specified a system generated name will be used.

The STATUS, NAME, DESCRIPTION, and CATEGORY attributes of an SQL profile can be altered using the 
ALTER_SQL_PROFILE procedure:

BEGIN
  DBMS_SQLTUNE.alter_sql_profile (
    name            => 'emp_dept_profile',
    attribute_name  => 'STATUS',
    value           => 'DISABLED');
END;
/
Existing SQL profiles can be dropped using the DROP_SQL_PROFILE procedure:

BEGIN
  DBMS_SQLTUNE.drop_sql_profile (
    name   => 'emp_dept_profile',
    ignore => TRUE);
END;
/
The IGNORE parameter prevents errors being reported if the specified profile does not exist.

SQL Tuning Sets
An SQL tuning set is a group of statements along with their execution context. These can be created automatically
 via Enterprise Manager or manually provided you have the necessary privileges:

CONN sys/password AS SYSDBA
GRANT ADMINISTER ANY SQL TUNING SET TO scott;
CONN scott/tiger
An SQL tuning set is created using the CREATE_SQLSET procedure:

BEGIN
  DBMS_SQLTUNE.create_sqlset (
    sqlset_name  => 'test_sql_tuning_set',
    description  => 'A test SQL tuning set.');
END;
/
Statements are added to the set using the LOAD_SQLSET procedure which accepts a REF 
CURSOR of statements retrieved using one of the following pipelined functions:

SELECT_WORKLOAD_REPOSITORY - Retrieves statements from the Automatic Workload Repository (AWR). 
SELECT_CURSOR_CACHE - Retrieves statements from the cursor cache. 
SELECT_SQLSET - Retrieves statements from another SQL tuning set. 
The following are examples of their usage:

-- Load the SQL set from the Automatic Workload Repository (AWR).
DECLARE
  l_cursor  DBMS_SQLTUNE.sqlset_cursor;
BEGIN
  OPEN l_cursor FOR
    SELECT VALUE(p)
    FROM   TABLE (DBMS_SQLTUNE.select_workload_repository (
                    765,  -- begin_snap
                    766,  -- end_snap
                    NULL, -- basic_filter
                    NULL, -- object_filter
                    NULL, -- ranking_measure1
                    NULL, -- ranking_measure2
                    NULL, -- ranking_measure3
                    NULL, -- result_percentage
                    10)   -- result_limit
                  ) p;

  DBMS_SQLTUNE.load_sqlset (
    sqlset_name     => 'test_sql_tuning_set',
    populate_cursor => l_cursor);
END;
/

-- Load the SQL set from the cursor cache.
DECLARE
  l_cursor  DBMS_SQLTUNE.sqlset_cursor;
BEGIN
  OPEN l_cursor FOR
    SELECT VALUE(p)
    FROM   TABLE (DBMS_SQLTUNE.select_cursor_cache (
                    NULL, -- basic_filter
                    NULL, -- object_filter
                    NULL, -- ranking_measure1
                    NULL, -- ranking_measure2
                    NULL, -- ranking_measure3
                    NULL, -- result_percentage
                    1)    -- result_limit
                  ) p;

  DBMS_SQLTUNE.load_sqlset (
    sqlset_name     => 'test_sql_tuning_set',
    populate_cursor => l_cursor);
END;
/

-- Create a new set and load it from the existing one.
DECLARE
  l_cursor  DBMS_SQLTUNE.sqlset_cursor;
BEGIN
  DBMS_SQLTUNE.create_sqlset(
    sqlset_name  => 'test_sql_tuning_set_2',
    description  => 'Another test SQL tuning set.');

  OPEN l_cursor FOR
    SELECT VALUE(p)
    FROM   TABLE (DBMS_SQLTUNE.select_sqlset (
                    'test_sql_tuning_set', -- sqlset_name
                    NULL,                  -- basic_filter
                    NULL,                  -- object_filter
                    NULL,                  -- ranking_measure1
                    NULL,                  -- ranking_measure2
                    NULL,                  -- ranking_measure3
                    NULL,                  -- result_percentage
                    NULL)                  -- result_limit
                  ) p;

  DBMS_SQLTUNE.load_sqlset (
    sqlset_name     => 'test_sql_tuning_set_2',
    populate_cursor => l_cursor);
END;
/
The contents of an SQL tuning set can be displayed using the SELECT_SQLSET function:

SELECT *
FROM   TABLE(DBMS_SQLTUNE.select_sqlset ('test_sql_tuning_set'));
References can be added to a set to indicate its usage by a client using the ADD_SQLSET_REFERENCE function.
 The resulting reference ID can be used to remove it using the REMOVE_SQLSET_REFERENCE procedure:

DECLARE
  l_ref_id  NUMBER;
BEGIN
  -- Add a reference to a set.
  l_ref_id := DBMS_SQLTUNE.add_sqlset_reference (
    sqlset_name => 'test_sql_tuning_set',
    reference   => 'Used for manual tuning by SQL*Plus.');

  -- Delete the reference.
  DBMS_SQLTUNE.remove_sqlset_reference (
    sqlset_name  => 'test_sql_tuning_set',
    reference_id => l_ref_id);
END;
/
The UPDATE_SQLSET procedure is used to update specific string (MODULE and ACTION) and number
 (PRIORITY and PARSING_SCHEMA_ID) attributes of specific statements within a set:

BEGIN
  DBMS_SQLTUNE.update_sqlset (
    sqlset_name     => 'test_sql_tuning_set',
    sql_id          => '19v5guvsgcd1v',
    attribute_name  => 'ACTION',
    attribute_value => 'INSERT');
END;
/
The contents of a set can be trimmed down or deleted completely using the DELETE_SQLSET procedure:

BEGIN
  -- Delete statements with less than 50 executions.
  DBMS_SQLTUNE.delete_sqlset (
    sqlset_name  => 'test_sql_tuning_set',
    basic_filter => 'executions < 50');

  -- Delete all statements.
  DBMS_SQLTUNE.delete_sqlset (
    sqlset_name  => 'test_sql_tuning_set');
END;
/
Tuning sets can be dropped using the DROP_SQLSET procedure:

BEGIN
  DBMS_SQLTUNE.drop_sqlset (sqlset_name => 'test_sql_tuning_set');
  DBMS_SQLTUNE.drop_sqlset (sqlset_name => 'test_sql_tuning_set_2');
END;
/
Useful Views
Useful views related to automatic SQL tuning include:

DBA_ADVISOR_TASKS 
DBA_ADVISOR_FINDINGS 
DBA_ADVISOR_RECOMMENDATIONS 
DBA_ADVISOR_RATIONALE 
DBA_SQLTUNE_STATISTICS 
DBA_SQLTUNE_BINDS 
DBA_SQLTUNE_PLANS 
DBA_SQLSET 
DBA_SQLSET_BINDS 
DBA_SQLSET_STATEMENTS 
DBA_SQLSET_REFERENCES 
DBA_SQL_PROFILES 
V$SQL 
V$SQLAREA 
V$ACTIVE_SESSION_HISTORY 
