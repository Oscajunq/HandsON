CREATE OR REPLACE PACKAGE NativeDynamic AS
  TYPE t_RefCur IS REF CURSOR;
--
  FUNCTION Query(p_query IN VARCHAR2)
    RETURN t_RefCur;
--
END NativeDynamic;
/


CREATE OR REPLACE PACKAGE BODY NativeDynamic AS
  FUNCTION Query(p_query IN VARCHAR2)
    RETURN t_RefCur IS
    v_ReturnCursor t_RefCur;
    v_SQLStatement VARCHAR2(500);
  BEGIN
    v_SQLStatement := p_query;

    OPEN v_ReturnCursor FOR v_SQLStatement;
    RETURN v_ReturnCursor;
  END Query;
END NativeDynamic;
/

set serveroutput on 

DECLARE
  v_Student EMPLOYEES%ROWTYPE;
  v_StudentCur NativeDynamic.t_RefCur;
BEGIN
  v_StudentCur := NativeDynamic.query('select empid, empname from employees');

  DBMS_OUTPUT.PUT_LINE(
    'listando dados');
  LOOP
    FETCH v_StudentCur INTO v_Student;
    EXIT WHEN v_StudentCur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('  ' || v_Student.empid || ': ' ||
                         v_Student.empname);
  END LOOP;
  CLOSE v_StudentCur;
END;
/
