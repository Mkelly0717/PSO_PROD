--------------------------------------------------------
--  DDL for View UDV_PLANNED_ORDERS_BY_ITEM
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_PLANNED_ORDERS_BY_ITEM" ("ITEM", "NUM_PA", "TOTAL_QTY") AS 
  select item , count(1) Num_PA, sum(qty)total_qty
from MAK_60_PLANNARRIV_NA pa, loc l
where l.loc=pa.dest
  and l.u_area='NA'
  and pa.u_custorderid is not null
  and pa.loadid is null
group by item
