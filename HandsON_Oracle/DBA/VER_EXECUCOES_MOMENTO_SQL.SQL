-- script para mostrar execucoes do momento                    
--
SELECT  s.sid                                                         
      , s.username                                                  
      , s.osuser                                                    
      , nvl(s.machine, ' ') machine                                 
      , nvl(s.program, ' ') program                                 
      , s.process F_Ground, p.spid B_Ground                         
      , X.sql_text                                                  
 FROM sys.gv_$session S, sys.gv_$process P, sys.gv_$sqlarea X                                            
WHERE 
   s.username like upper('SUPORTERJ')            
  AND s.paddr = p.addr                                          
  AND s.sql_address = x.address                                 
  AND s.sql_hash_value = x.hash_value                           
  ORDER BY S.sid;                                               
--  
                                         