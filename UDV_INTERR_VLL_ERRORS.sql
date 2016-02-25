--------------------------------------------------------
--  DDL for View UDV_INTERR_VLL_ERRORS
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_INTERR_VLL_ERRORS" ("U_AREA", "ITEM", "ERROR_STR", "COUNT") AS 
  select l.u_area, iev.item, iev.error_str, count(1) count
from interr_vehicleloadln iev, loc l
where l.loc=iev.dest
group by l.u_area, iev.item, iev.error_str
order by l.u_area, iev.item
