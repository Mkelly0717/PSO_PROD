--------------------------------------------------------
--  DDL for View UDV_DEMAND_DETAIL_SUMMARY
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_DEMAND_DETAIL_SUMMARY" ("ITEMS", "TOTALDEMAND", "TOTALMET", "TOTAL_UNMET", "%Met", "%UnMet") AS 
  with demand_per_sku ( item, dest, totaldemand, totalmet ) as
    (select item
      , dest
      , max(totaldemand) totaldemand
      , sum(totalmet) totalmet
    from udt_demand_detail_report
    group by ( item, dest)
    )
select nvl(item,'Combined Items') items
  , round(sum(totaldemand)) as totaldemand
  , round(sum(totalmet))    as totalmet
  , round(sum(totaldemand)  - sum(totalmet)) total_unmet
  , round(sum(totalmet)     /sum(totaldemand),2) * 100 "%Met"
  , round((sum(totaldemand) - sum(totalmet))/sum(totaldemand),2) * 100 "%UnMet"
from demand_per_sku dps
group by rollup(item)
order by 2 desc
