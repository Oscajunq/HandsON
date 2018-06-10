CREATE OR REPLACE PROCEDURE lista_campo (p_colun_1 VARCHAR2, p_colun_2 VARCHAR2, P_DADOS_CURSOR OUT REFCURSOR) IS
--
TYPE DADOS_CURSOR IS REF CURSOR;
cvDADOS  DADOS_CURSOR;
--
lista_coluna1  varchar2(200);
lista_coluna2  varchar2(200);
cmd_sql        varchar2(200);
--
BEGIN
--
   cmd_sql := 'SELECT ';
   --
   if p_colun_1 is not null then 
      cmd_sql := cmd_sql || p_colun_1;
   end if;
   --
   if p_colun_2 is not null then 
      cmd_sql := cmd_sql || ',' || p_colun_2;
   end if;
   --
   cmd_sql := cmd_sql || ' FROM EMP';
   --
   dbms_output.put_line(cmd_sql);
   --
   OPEN cvDADOS FOR cmd_sql;
   --
   LOOP
      FETCH cvDADOS INTO lista_coluna1, lista_coluna2;     
      dbms_output.put_line(lista_coluna1 || ' ' || lista_coluna2);
      EXIT WHEN cvDADOS%NOTFOUND;
   END LOOP;
   --
   CLOSE cvDADOS;   
END lista_campo;
/





--
--
--
CREATE TABLE employees (
empid   NUMBER(5),
empname VARCHAR2(30));

INSERT INTO employees (empid, empname) VALUES (1 , 'Dan Morgan');
INSERT INTO employees (empid, empname) VALUES (2 , 'Jack Cline');
INSERT INTO employees (empid, empname) VALUES (3 , 'Caleb Small');
INSERT INTO employees (empid, empname) VALUES (4 , 'Caleb Small4 ');
INSERT INTO employees (empid, empname) VALUES (5 , 'Caleb Small5 ');
INSERT INTO employees (empid, empname) VALUES (6 , 'Caleb Small6 ');
INSERT INTO employees (empid, empname) VALUES (7 , 'Caleb Small7 ');
INSERT INTO employees (empid, empname) VALUES (8 , 'Caleb Small8 ');
INSERT INTO employees (empid, empname) VALUES (9 , 'Caleb Small9 ');
INSERT INTO employees (empid, empname) VALUES (10, 'Caleb Small10');
INSERT INTO employees (empid, empname) VALUES (11, 'Caleb Small11');
INSERT INTO employees (empid, empname) VALUES (12, 'Caleb Small12');
INSERT INTO employees (empid, empname) VALUES (13, 'Caleb Small13');
INSERT INTO employees (empid, empname) VALUES (14, 'Caleb Small14');
INSERT INTO employees (empid, empname) VALUES (15, 'Caleb Small15');
INSERT INTO employees (empid, empname) VALUES (16, 'Caleb Small16');
INSERT INTO employees (empid, empname) VALUES (17, 'Caleb Small17');
INSERT INTO employees (empid, empname) VALUES (18, 'Caleb Small18');
INSERT INTO employees (empid, empname) VALUES (19, 'Caleb Small19');
INSERT INTO employees (empid, empname) VALUES (20, 'Caleb Small20');
COMMIT;

CREATE OR REPLACE PROCEDURE pass_ref_cur(p_cursor SYS_REFCURSOR) IS

TYPE array_t IS TABLE OF VARCHAR2(4000)
INDEX BY BINARY_INTEGER;

rec_array array_t;

BEGIN
  FETCH p_cursor BULK COLLECT INTO rec_array LIMIT 10;

  FOR i IN rec_array.FIRST .. rec_array.LAST
  LOOP
    dbms_output.put_line(rec_array(i));
  END LOOP;
END pass_ref_cur;
/  

set serveroutput on

DECLARE
 rec_array SYS_REFCURSOR;
BEGIN
  OPEN rec_array FOR
  'SELECT  empid FROM employees order by empid';

  pass_ref_cur(rec_array);
  CLOSE rec_array;
END;
/ 


--
--
--
CREATE OR REPLACE PACKAGE strongly_typed IS

TYPE return_cur IS REF CURSOR RETURN all_tables%ROWTYPE;
PROCEDURE child(p_return_rec OUT return_cur);
PROCEDURE parent(p_NumRecs PLS_INTEGER);  

END strongly_typed;
/ 

CREATE OR REPLACE PACKAGE BODY strongly_typed IS PROCEDURE child(p_return_rec OUT return_cur) IS

BEGIN
  OPEN p_return_rec FOR 
  SELECT * FROM all_tables; 
END child;  
--==================================================  
PROCEDURE parent (p_NumRecs PLS_INTEGER) IS 
 p_retcur return_cur;
 at_rec   all_tables%ROWTYPE;
BEGIN
  child(p_retcur);

  --FOR i IN 1 .. p_NumRecs
  LOOP
    FETCH p_retcur
    INTO at_rec;

    dbms_output.put_line(at_rec.table_name || 
    ' - ' || at_rec.tablespace_name || 
    ' - ' || TO_CHAR(at_rec.initial_extent) || 
    ' - ' || TO_CHAR(at_rec.next_extent));
  END LOOP; 
END parent;  
END strongly_typed;
/ 