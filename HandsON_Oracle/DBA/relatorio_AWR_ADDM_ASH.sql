SELECT TASK_NAME FROM DBA_ADVISOR_TASKS WHERE TASK_ID = :B1 AND ADVISOR_NAME = 'ADDM' 

SELECT   snap_id,
         snap_level,
         to_char(begin_interval_time, 'yyyy/mm/dd hh24:mi:ss') begin_interval_time,
         to_char(end_interval_time, 'yyyy/mm/dd hh24:mi:ss') end_interval_time,
         to_char(flush_elapsed) flush_elapsed,
         to_char(startup_time, 'yyyy/mm/dd hh24:mi:ss') startup_time,
         error_count
FROM     DBA_HIST_SNAPSHOT
WHERE    dbid = 2960560672
AND      instance_number = 1
order by 1

DECLARE
   tname    VARCHAR2 (60);
   taskid   NUMBER;
BEGIN
   DBMS_ADVISOR.create_task ('ADDM', taskid, tname);
   DBMS_ADVISOR.set_task_parameter (tname, 'START_SNAPSHOT', 8461);
   DBMS_ADVISOR.set_task_parameter (tname, 'END_SNAPSHOT', 9671);
   DBMS_ADVISOR.set_task_parameter (tname, 'INSTANCE', 1);
   DBMS_ADVISOR.execute_task (tname);
   :out_task := tname;
END;

SELECT   DBMS_ADVISOR.get_task_report ('TASK_82321',
                                       'TEXT',
                                       'ALL',
                                       'ALL')
            report
  FROM   DBA_ADVISOR_TASKS t
 WHERE   t.task_name = 'TASK_82321'
         AND t.owner = SYS_CONTEXT ('USERENV', 'session_user')


SELECT   *
  FROM   table (DBMS_WORKLOAD_REPOSITORY.awr_report_html (2960560672,
                                                          1,
                                                          10056,
                                                          10066,
                                                          0))

SELECT   *
  FROM   table (DBMS_WORKLOAD_REPOSITORY.awr_report_text (2960560672,
                                                          1,
                                                          10056,
                                                          10066,
                                                          0))

SELECT   *
  FROM   table(DBMS_WORKLOAD_REPOSITORY.ASH_report_html (
                  2960560672,
                  1,
                  TO_DATE ('02/08/2011', 'MM/DD/YYYY'),
                  TO_DATE ('02/10/2011 23:59:59', 'MM/DD/YYYY HH24:MI:SS'),
                  0,
                  0,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL,
                  NULL
               ))