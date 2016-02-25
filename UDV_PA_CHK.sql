--------------------------------------------------------
--  DDL for View UDV_PA_CHK
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_PA_CHK" ("U_AREA", "CNT") AS 
  select distinct u_area, count(*) cnt
from planarriv p, loc l
where p.dest = l.loc
group by u_area
