CREATE TABLE cliente_work AS SELECT * FROM CLIENTE WHERE 1=2;

---------------------------------------------------------------------
-- Test if table can be redefined...
---------------------------------------------------------------------
EXEC DBMS_REDEFINITION.CAN_REDEF_TABLE('RP2000_EDS_R7_10', 'CLIENTE', 2);

---------------------------------------------------------------------
-- Start table redefinition...
---------------------------------------------------------------------
EXEC DBMS_REDEFINITION.START_REDEF_TABLE('RP2000_EDS_R7_10', 'CLIENTE', 'cliente_work', NULL, 2);

--------------------------------------------------------------------
-- Add ALL constraints, indexes, triggers, grants, etc...
---------------------------------------------------------------------
ALTER TABLE CLIENTE ADD PRIMARY KEY (CODORG,CODCLI);

---------------------------------------------------------------------
-- Finish the redefinition process (this will swap the two tables)...
---------------------------------------------------------------------
EXEC DBMS_REDEFINITION.FINISH_REDEF_TABLE('RP2000_EDS_R7_10', 'CLIENTE', 'cliente_work');

---------------------------------------------------------------------
-- Drop the interim working table...
---------------------------------------------------------------------
DROP TABLE cliente_work;
