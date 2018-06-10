--
-- QUERY PARA VERIFICAR OS OBJETOS LISTADOS DENTRO DE UMA PACKAGE, FUNCIONA IGUAL A UM COMANDO DESC
--
 select PROCEDURENAME from SYS.procedureinfo$ 
  where OBJ#= (select object_id from dba_objects 
                where owner       ='nome_usuario'
                  and object_name ='nome_objeto'
                  and object_type ='PACKAGE');

--

SELECT OBJECT_NAME, PROCEDURENAME 
  FROM DBA_OBJECTS, 
      (SELECT PROCEDURENAME, OBJ# from SYS.procedureinfo$ 
        where OBJ#= (select object_id from dba_objects 
                      where owner       = 'nome_usuario'
                        and object_name = 'nome_objeto'
                        and object_type = 'PACKAGE')) OBJETOS
WHERE OBJECT_ID   = OBJ#
  AND OWNER       = 'nome_usuario'
  AND object_name = 'nome_objeto'
  AND object_type = 'PACKAGE'