--
-- avaliar uma estimativa de crescimento dos dados.
--
SELECT   t.owner, t.table_name, t.num_rows, t.avg_row_len, t.pct_free,
         t.ini_trans, t.tablespace_name, c.ddl_row_length, c.haslobs,
         c.hastypes
    FROM (SELECT   c.owner, c.table_name,
                   CEIL
                      (SUM (DECODE (c.data_type,
                                    'DATE', 7 + 1,
                                    'RAW', c.data_length
                                     + DECODE (SIGN (c.data_length - 250),
                                               1, 3,
                                               1
                                              ),
                                    'NUMBER', NVL (c.data_precision,
                                                   data_length
                                                  ) + 1,
                                    'FLOAT', NVL (c.data_precision,
                                                  data_length
                                                 ) + 1,
                                    'UROWID', 10 + 1,
                                    'ROWID', 10 + 1,
                                    'CHAR', c.char_length
                                     + DECODE (SIGN (c.char_length - 250),
                                               1, 3,
                                               1
                                              ),
                                    'VARCHAR', c.char_length
                                     + DECODE (SIGN (c.char_length - 250),
                                               1, 3,
                                               1
                                              ),
                                    'VARCHAR2', c.char_length
                                     + DECODE (SIGN (c.char_length - 250),
                                               1, 3,
                                               1
                                              ),
                                    'NCHAR', c.char_length
                                     + DECODE (SIGN (c.char_length - 250),
                                               1, 3,
                                               1
                                              ),
                                    'NVARCHAR', c.char_length
                                     + DECODE (SIGN (c.char_length - 250),
                                               1, 3,
                                               1
                                              ),
                                    'NVARCHAR2', c.char_length
                                     + DECODE (SIGN (c.char_length - 250),
                                               1, 3,
                                               1
                                              ),
                                    NVL (data_length, 0) + 1
                                   )
                           )
                      ) ddl_row_length,
                   SUM (DECODE (c.data_type,
                                'BFILE', 1,
                                'CLOB', 1,
                                'BLOB', 1,
                                'NCLOB', 1,
                                'XMLTYPE', 1,
                                'LONG', 1,
                                'LONG RAW', 1,
                                0
                               )
                       ) haslobs,
                   SUM (DECODE (c.data_type_owner, NULL, 0, 1)) hastypes
              FROM dba_tab_columns c
          GROUP BY c.owner, c.table_name) c,
         dba_tables t
   WHERE t.owner = c.owner
     AND c.table_name = t.table_name
     AND NOT (    ((t.pct_free IS NOT NULL) AND (t.pct_free = 0))
              AND ((t.pct_used IS NOT NULL) AND (t.pct_used = 0))
              AND t.cluster_name IS NULL
              AND t.iot_type IS NULL
             )
     AND t.owner = 'DSUPORTERJ'
ORDER BY 1, 2