--------------------------------------------------------
--  DDL for View UDV_NUM_SM_SRCS_BY_SKU_SIPPDT
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_NUM_SM_SRCS_BY_SKU_SIPPDT" ("ITEM", "DEST", "EFF", "NUMSOURCES", "TOTQTY") AS 
  select sm.item, sm.dest, sm.eff, count(sm.source) NumSources, Round(sum(sm.value)) TotQty
from sim_sourcingmetric sm, loc l
where sm.category=418
  and l.loc=sm.dest
  and l.u_area='NA'
  and sm.item like '%RU%'
  and sm.value > 0
  and sm.simulation_name='AD'
group by sm.item, sm.dest, sm.eff
having count(sm.source) > 1
order by sm.item, sm.dest, sm.eff asc
