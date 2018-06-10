/* Formatted on 2007/08/23 11:23 (Formatter Plus v4.8.8) */
SELECT   *
    FROM (SELECT o.NAME object_name, DECODE (o.status, 1, 'V', 'I') status,
                 o.mtime last_ddl_time, o.obj# object_id, o.ctime created,
                 NVL (pi.AUTHID, 'DEFINER') AUTHID,
                 NVL (i.debuginfo, 'F') debuginfo
            FROM SYS.obj$ o,
                 SYS.user$ u,
                 (SELECT obj#,
                         DECODE (BITAND (properties, 1024),
                                 1024, 'CURRENT_USER',
                                 'DEFINER'
                                ) AUTHID
                    FROM SYS.procedureinfo$
                   WHERE procedure# = 1 AND overload# = 0) pi,
                 (SELECT DISTINCT obj#, 'T' debuginfo
                             FROM SYS.idl_char$
                            WHERE part = 1) i
           WHERE o.type# = 7
             AND o.owner# = u.user#
             AND o.linkname IS NULL
             AND o.obj# = pi.obj#(+)
             AND i.obj#(+) = o.obj#
             AND u.NAME = 'NOME_DO_USUARIO') p
ORDER BY 1

SELECT a.object_type, a.object_name, b.owner, b.object_type, b.object_name,
       b.object_id, b.status
  FROM SYS.dba_objects a,
       SYS.dba_objects b,
       (SELECT     object_id, referenced_object_id
              FROM public_dependency
        START WITH object_id =
                      (SELECT object_id
                         FROM SYS.dba_objects
                        WHERE owner = 'DESENVOL'
                          AND object_name = 'PABREAM1'
                          AND object_type = 'PROCEDURE')
        CONNECT BY PRIOR referenced_object_id = object_id) c
 WHERE a.object_id = c.object_id
   AND b.object_id = c.referenced_object_id
   AND a.owner NOT IN ('SYS', 'SYSTEM')
   AND b.owner NOT IN ('SYS', 'SYSTEM')
   AND a.object_name <> 'DUAL'
   AND b.object_name <> 'DUAL'
   
--
--VER LISTA DE OBJETOS DEPENDENTES
--
   
SELECT owner, object_type, object_name, object_id, status
  FROM SYS.dba_objects
 WHERE object_id IN (
          SELECT     object_id
                FROM public_dependency
          CONNECT BY PRIOR object_id = referenced_object_id
          START WITH referenced_object_id =
                        (SELECT object_id
                           FROM SYS.dba_objects
                          WHERE owner = 'SUPORTERJ1'
                            AND object_name = 'BCSUL_T_WEB_CONTRATO'
                            AND object_type = 'TABLE'))   