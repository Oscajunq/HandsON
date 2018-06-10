create or replace function fc_formata_status (pstatus in varchar2)
return varchar2 is

   lstatus      varchar2(1000);
   v_temquantos number := 0;
   v_ultimo     number := 0;
begin
   lstatus := '''';
  
   begin
       select count(1) into v_temquantos
        from (select regexp_substr(pstatus, '[^,]+',1, level) as st from dual
               connect by level <= length(regexp_replace(pstatus, '[^,]*'))+1);
   exception
      when no_data_found then 
          v_temquantos := 0;
   end;       
 
   for cur in (select regexp_substr(pstatus, '[^,]+',1, level) as st from dual
               connect by level <= length(regexp_replace(pstatus, '[^,]*'))+1)

      loop
          v_ultimo := v_ultimo + 1;
          
          if v_temquantos <> v_ultimo then
             lstatus := lstatus || cur.st  || '''' || ',' || '''';
          else
             lstatus := lstatus || cur.st;
          end if;
   end loop;

   lstatus := lstatus || '''';
   
   return (lstatus);

end fc_formata_status;
/
