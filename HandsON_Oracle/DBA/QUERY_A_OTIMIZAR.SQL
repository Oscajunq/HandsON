/* Formatted on 2008/05/14 18:34 (Formatter Plus v4.8.8) */
DECLARE
   ret_val   VARCHAR2 (4000);
   sqltext   CLOB;
   suggestion CLOB;
   script     CLOB;
BEGIN
   sqltext := 'SELECT MAX (wm.documento) FROM PRODISSR.wfq_info_adicional wia, PRODISSR.wfq_mensajes wm WHERE wm.id_mensaje = wia.id_mensaje  AND (wm.cod_queue = 29 OR wm.cod_queue = 91) AND wia.id_transaccion = 0';
   ret_val :=
      DBMS_SQLTUNE.create_tuning_task (sqltext,
                                       NULL,
                                       'TZFWNC',
                                       'COMPREHENSIVE',
                                       1800,
                                       'W2TZFWNC0132439582.7738288792',
                                       'TOAD created SQL Tuning Advisor Task'
                                      );
   DBMS_SQLTUNE.execute_tuning_task ('W2TZFWNC0132439582.7738288792');
   
   suggestion :=
   DBMS_SQLTUNE.report_tuning_task ('W2TZFWNC0132439582.7738288792',
                                       'TEXT',
                                       'TYPICAL'
                                      );
   
   DBMS_OUTPUT.PUT_LINE('SUGESTAO: ' || suggestion);
   
   script :=
   DBMS_SQLTUNE.script_tuning_task
                                 (task_name      => 'W2TZFWNC0132439582.7738288792');
   
   
   DBMS_OUTPUT.PUT_LINE('script:  ' || script);
   
   DBMS_SQLTUNE.drop_tuning_task ('W2TZFWNC0132439582.7738288792');
END;