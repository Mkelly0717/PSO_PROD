--------------------------------------------------------
--  DDL for View MAK_SM_CLEANUP_VIEW_OLD
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_SM_CLEANUP_VIEW_OLD" ("ITEM", "SOURCE", "EFF", "TOTAL", "REMAINDER", "SM_QTY_USED", "CO_QTY_USED") AS 
  select item, source, eff, sum(remainder) total, sum(remainder) remainder, 0 sm_qty_used, 0 co_qty_used
from mak_sm_table
where remainder > 0
group by item, source, eff
order by item, source, eff
