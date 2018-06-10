--
-- ver detalhamento dos sql que estao sendo executado no momento
--
-- scripts criado em 10/01/2008
-- DBA: Osmar
--
--
select sql_fulltext from v$sql 
where addres     = '00000001E114DAE8'
  AND hash_value = '2674323898'
  
  
SELECT   sql_text,address,hash_value     
    FROM v$sqltext_with_newlines
   WHERE address =
            (SELECT DECODE (RAWTOHEX (sql_address),
                            '00', prev_sql_addr,
                            sql_address
                           )
               FROM v$session
              WHERE username = 'SUPORTERJ' AND SID = '936')
ORDER BY piece
--
--
--
-- avaliar quanto tempo a query irar demorar o retorno
--
SELECT   SID,
         DECODE (totalwork,
                 0, 0,
                 ROUND (100 * sofar / totalwork, 2)
                ) "Percent",
         MESSAGE "Message", start_time, elapsed_seconds, time_remaining
    FROM v$session_longops
   WHERE (SID = 220 AND serial# = 14032)
ORDER BY SID;
--
--
-- VER TODAS AS QUERYS QUE FORAM ACESSADAS
--
