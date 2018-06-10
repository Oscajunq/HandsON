--
-- AVALIAR ESPACOS DA TABLESPACES
--
SELECT   a.tablespace_name, ROUND (a.bytes_alloc / 1024 / 1024, 2) megs_alloc,
         ROUND (NVL (b.bytes_free, 0) / 1024 / 1024, 2) megs_free,
         ROUND ((a.bytes_alloc - NVL (b.bytes_free, 0)) / 1024 / 1024,
                2
               ) megs_used,
         ROUND ((NVL (b.bytes_free, 0) / a.bytes_alloc) * 100, 2) pct_free,
           100
         - ROUND ((NVL (b.bytes_free, 0) / a.bytes_alloc) * 100, 2) pct_used,
         ROUND (maxbytes / 1048576, 2) MAX
    FROM (SELECT   f.tablespace_name, SUM (f.BYTES) bytes_alloc,
                   SUM (DECODE (f.autoextensible,
                                'YES', f.maxbytes,
                                'NO', f.BYTES
                               )
                       ) maxbytes
              FROM dba_data_files f
          GROUP BY tablespace_name) a,
         (SELECT   f.tablespace_name, SUM (f.BYTES) bytes_free
              FROM dba_free_space f
          GROUP BY tablespace_name) b
   WHERE a.tablespace_name = b.tablespace_name(+)
UNION ALL
SELECT   h.tablespace_name,
         ROUND (SUM (h.bytes_free + h.bytes_used) / 1048576, 2) megs_alloc,
         ROUND (  SUM ((h.bytes_free + h.bytes_used) - NVL (p.bytes_used, 0))
                / 1048576,
                2
               ) megs_free,
         ROUND (SUM (NVL (p.bytes_used, 0)) / 1048576, 2) megs_used,
         ROUND (  (  SUM (  (h.bytes_free + h.bytes_used)
                          - NVL (p.bytes_used, 0)
                         )
                   / SUM (h.bytes_used + h.bytes_free)
                  )
                * 100,
                2
               ) pct_free,
           100
         - ROUND (  (  SUM (  (h.bytes_free + h.bytes_used)
                            - NVL (p.bytes_used, 0)
                           )
                     / SUM (h.bytes_used + h.bytes_free)
                    )
                  * 100,
                  2
                 ) pct_used,
         ROUND (f.maxbytes / 1048576, 2) MAX
    FROM SYS.v_$temp_space_header h,
         SYS.v_$temp_extent_pool p,
         dba_temp_files f
   WHERE p.file_id(+) = h.file_id
     AND p.tablespace_name(+) = h.tablespace_name
     AND f.file_id = h.file_id
     AND f.tablespace_name = h.tablespace_name
GROUP BY h.tablespace_name, f.maxbytes
ORDER BY 1

--
--
-- AVALIAR AS DATAFILES DAS TABLESPACES
--
SELECT   t.tablespace_name "Tablespace", 'Datafile' "File Type",
         t.status "Status",
         ROUND ((d.max_bytes - NVL (f.sum_bytes, 0)) / 1024 / 1024,
                2
               ) "Used MB",
         ROUND (NVL (f.sum_bytes, 0) / 1024 / 1024, 2) "Free MB",
         t.initial_extent "Initial Extent", t.next_extent "Next Extent",
         t.min_extents "Min Extents", t.max_extents "Max Extents",
         t.pct_increase "Pct Increase",
         SUBSTR (d.file_name, 1, 80) "Datafile name"
    FROM (SELECT   tablespace_name, file_id, SUM (BYTES) sum_bytes
              FROM dba_free_space
          GROUP BY tablespace_name, file_id) f,
         (SELECT   tablespace_name, file_name, file_id, MAX (BYTES) max_bytes
              FROM dba_data_files
          GROUP BY tablespace_name, file_name, file_id) d,
         dba_tablespaces t
   WHERE t.tablespace_name = d.tablespace_name
     AND f.tablespace_name(+) = d.tablespace_name
     AND f.file_id(+) = d.file_id
GROUP BY t.tablespace_name,
         d.file_name,
         t.initial_extent,
         t.next_extent,
         t.min_extents,
         t.max_extents,
         t.pct_increase,
         t.status,
         d.max_bytes,
         f.sum_bytes
UNION ALL
SELECT   h.tablespace_name, 'Tempfile', t.status,
         ROUND (SUM (NVL (p.bytes_used, 0)) / 1048576, 2),
         ROUND (  SUM ((h.bytes_free + h.bytes_used) - NVL (p.bytes_used, 0))
                / 1048576,
                2
               ),
         -1,                                                 -- initial extent
            -1,                                              -- initial extent
               -1,                                              -- min extents
                  -1,                                           -- max extents
                     -1,                                       -- pct increase
                        t.file_name
    FROM SYS.v_$temp_space_header h,
         SYS.v_$temp_extent_pool p,
         SYS.dba_temp_files t
   WHERE p.file_id(+) = h.file_id
     AND p.tablespace_name(+) = h.tablespace_name
     AND h.file_id = t.file_id
     AND h.tablespace_name = t.tablespace_name
GROUP BY h.tablespace_name, t.status, t.file_name
ORDER BY 1, 4 DESC
--
--
-- VER OS OBJETOS DENTRO DESTA TABLESPACE
--
SELECT DECODE (partition_name,
               NULL, segment_name,
               segment_name || ':' || partition_name
              ) objectname,
       segment_type object_type, ROUND (BYTES / 1024 / 1024, 2) mb,
       initial_extent initial_ex, next_extent next_ex, extents, BYTES ttlsize,
       owner, max_extents
  FROM dba_segments
 WHERE tablespace_name = :tname