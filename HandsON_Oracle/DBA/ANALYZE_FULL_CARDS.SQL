----------------------------------------------------------------------------
--
-- File: ANALYZE.SQL
--
-- Description: Analyze Tables/Indexes/Clusters Compute Statistcs
--
-- From: SQL*Plus
--
-- Author: 
--
-- History: 19/09/2000
-- 
----------------------------------------------------------------------------

SET ECHO 		OFF
SET PAGESIZE 		0
SET FEEDBACK 		OFF
SET HEADING 		OFF
SET SERVEROUTPUT	OFF
SET TERMOUT		OFF
SET PAUSE		OFF

SPOOL D:\1_cards_delete_stats_ind.sql

SELECT 'ANALYZE ' || segment_type || ' ' || owner || '.' ||
	 segment_name || ' DELETE STATISTICS;'
 FROM dba_segments
WHERE segment_type IN ('INDEX') AND OWNER IN ('PRODISSR','DBRP1001','PCTA_PRD','PRODACQR')
ORDER 
   BY owner, segment_type, segment_name;

spool off;

SPOOL D:\2_cards_delete_stats_tab.sql

SELECT 'ANALYZE ' || segment_type || ' ' || owner || '.' ||
	 segment_name || ' DELETE STATISTICS;'
 FROM dba_segments
WHERE segment_type IN ('TABLE') AND OWNER IN ('PRODISSR','DBRP1001','PCTA_PRD','PRODACQR')
ORDER 
   BY owner, segment_type, segment_name;

spool off;

SPOOL D:\3_cards_compute_stats_tab.sql

SELECT 'ANALYZE ' || segment_type || ' ' || owner || '.' ||
	 segment_name || ' COMPUTE STATISTICS;'
 FROM dba_segments
WHERE segment_type IN ('TABLE') AND OWNER IN ('PRODISSR','DBRP1001','PCTA_PRD','PRODACQR')
ORDER 
   BY owner, segment_type, segment_name;

spool off;

SPOOL D:\4_cards_compute_stats_ind.sql

SELECT 'ANALYZE ' || segment_type || ' ' || owner || '.' ||
	 segment_name || ' COMPUTE STATISTICS;'
 FROM dba_segments
WHERE segment_type IN ('INDEX') AND OWNER IN ('PRODISSR','DBRP1001','PCTA_PRD','PRODACQR')
ORDER 
   BY owner, segment_type, segment_name;

SPOOL OFF

SET FEEDBACK 		ON
SET SERVEROUTPUT	ON
SET TERMOUT		ON
SET PAGESIZE 		24

