--------------------------------------------------------
--  DDL for View MAK_SM_TABLE_R_EXTRACT
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_SM_TABLE_R_EXTRACT" ("RECNUM", "ITEM", "DEST", "SOURCE", "SCHEDARRIVDATE", "SM_TOTQTY", "REMAINDER", "VL_QTY_USED", "P1", "CO_QTY_USED", "DUR") AS 
  select recnum, item, dest, source, to_char(eff,'YYYY-MM-DD') schedarrivdate, sm_totqty, remainder, vl_qty_used, p1, co_qty_used, dur 
from mak_sm_table
