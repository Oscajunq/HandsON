title "Unused Indexes by Time Period"

 
col owner heading "Index Owner" format a30

col index_name heading "Index Name" format a30

set linesize 95 trimspool on pagesize 80


select * 
from
   (select 
      owner, 
      index_name 
   from 
      dba_indexes di
   where
      di.index_type != 'LOB'
   and
      owner not in ('SYS', 'SYSMAN', 'SYSTEM', 'MDSYS', 'WMSYS', 'TSMSYS', 'DBSNMP', 'OUTLN')
minus
select 
   index_owner owner, 
   index_name
from 
   dba_constraints dc
where
   index_owner not in ('SYS', 'SYSMAN', 'SYSTEM', 'MDSYS', 'WMSYS', 'TSMSYS', 'DBSNMP', 'OUTLN')
minus
select
   p.object_owner owner,
   p.object_name  index_name
from
   stats$snapshot       sn,
   stats$sql_plan       p,
   stats$sql_summary    st,
   stats$sql_plan_usage spu
where
     st.sql_id = spu.sql_id 
and  spu.plan_hash_value = p.plan_hash_value
and  st.hash_value = p.plan_hash_value
and  sn.snap_id = st.snap_id 
and  sn.dbid = st.dbid 
and  sn.instance_number = st.instance_number
and  sn.snap_id = spu.snap_id 
and  sn.dbid = spu.snap_id 
and  sn.instance_number = spu.instance_number
and  sn.snap_id between &begin_snap and &end_snap
and   p.object_type = 'INDEX'
)
where owner not in ('SYS', 'SYSMAN', 'SYSTEM', 'MDSYS', 'WMSYS', 'TSMSYS', 'DBSNMP', 'OUTLN')
order by 1, 2
/


