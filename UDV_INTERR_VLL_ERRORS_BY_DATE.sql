--------------------------------------------------------
--  DDL for View UDV_INTERR_VLL_ERRORS_BY_DATE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_INTERR_VLL_ERRORS_BY_DATE" ("U_AREA", "SCHEDARRIVDATE", "ITEM", "ERROR_STR", "COUNT") AS 
  select l.u_area, schedarrivdate, iev.item, iev.error_str , count(1) Count
from interr_vehicleloadln iev, loc l
where l.loc=iev.dest
group by l.u_area, schedarrivdate, iev.item, iev.error_str
union
select l.u_area, schedarrivdate, iev.item, iev.error_str, count(1) Count
from interr_vehicleloadln iev, loc l
where l.loc=iev.source
group by l.u_area, schedarrivdate, iev.item, iev.error_str
order by u_area, schedarrivdate
