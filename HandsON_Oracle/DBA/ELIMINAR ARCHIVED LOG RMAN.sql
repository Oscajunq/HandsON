limpando archived log oracle

	Listar onde os archived log estão

		sqlplus / as sysdba

		select space_limit/1024/1024 "Limit MB", space_used/1024/1024 "Used MB",
			space_reclaimable/1024/1024 "Reclaimable MB"
			from v$recovery_file_dest; 


	conetcar no rman

		rman target /

		
	lista os archived pendentes de backup

		CROSSCHECK ARCHIVELOG ALL;


	Elimina os archived log até um dia antes

		DELETE ARCHIVELOG ALL;
		
		DELETE ARCHIVELOG UNTIL TIME 'sysdate -1';


	



