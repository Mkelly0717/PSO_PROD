--------------------------------------------------------
--  DDL for View UDV_INTERR_VLL_REASONS
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_INTERR_VLL_REASONS" ("ERROR_STR", "N_RECORDS") AS 
  select  error_str, count(1) as N_Records
from  interr_vehicleloadln evll, loc l
where trunc(error_stamp) = trunc(error_stamp)
  and l.loc=evll.dest
  and l.u_area='NA'
group by error_str
order by count(1) desc
