--------------------------------------------------------
--  DDL for View MAK_TST_MULTI_VLL_LEADTS
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_TST_MULTI_VLL_LEADTS" ("DEST", "SOURCE", "ITEM", "CNT") AS 
  with pairs as (
select dest, source, item, schedarrivdate-schedshipdate diff, count(1) cnt
from vehicleloadline vll, loc l
where l.loc=vll.dest
  and l.u_area='NA'
  and vll.item like '4%RU%'
  and length(dest)=10
group by dest, source, item, schedarrivdate-schedshipdate
)
select dest, source, item, count(1) cnt
from pairs
group by dest, source, item
having count(1) > 1
