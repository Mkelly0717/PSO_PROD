--------------------------------------------------------
--  DDL for View UDV_INTERR_CUSTORDER_ERRORS
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_INTERR_CUSTORDER_ERRORS" ("U_AREA", "ITEM", "ERROR_STR", "COUNT") AS 
  select l.u_area, iec.item, error_str, count(1) count
from interr_custorder iec, loc l
where l.loc=iec.loc
group by l.u_area, iec.item, error_str
order by l.u_area, iec.item
