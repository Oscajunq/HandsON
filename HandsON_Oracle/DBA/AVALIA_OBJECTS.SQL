--
-- SELECT PARA AVALIAR AS DEPENDENCIAS DE UMA PROCEDURE
--
SELECT a.object_type, a.object_name, b.owner, b.object_type, b.object_name,
       b.object_id, b.status
  FROM SYS.dba_objects a,
       SYS.dba_objects b,
       (SELECT     object_id, referenced_object_id
              FROM public_dependency
        START WITH object_id =
                      (SELECT object_id
                         FROM SYS.dba_objects
                        WHERE owner = 'PRODISSR'
                          AND object_name = 'PR_EDS_REL_E32'
                          AND object_type = 'PROCEDURE')
        CONNECT BY PRIOR referenced_object_id = object_id) c
 WHERE a.object_id = c.object_id
   AND b.object_id = c.referenced_object_id
   AND a.owner NOT IN ('SYS', 'SYSTEM')
   AND b.owner NOT IN ('SYS', 'SYSTEM')
   AND a.object_name <> 'DUAL'
   AND b.object_name <> 'DUAL'
   
--
-- SELECT PARA AVALIAR OS PROCURAR O OBJETO QUE CONTEM UMA DETERMINADA TABELA 
--
SELECT NAME, SUBSTR(TEXT,1,100) FROM USER_SOURCE WHERE UPPER(TEXT) LIKE '%TB_EDS_REL_E32%';