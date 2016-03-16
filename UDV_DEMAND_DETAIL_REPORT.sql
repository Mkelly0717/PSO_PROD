--------------------------------------------------------
--  DDL for View UDV_DEMAND_DETAIL_REPORT
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_DEMAND_DETAIL_REPORT" ("ITEM", "DEST", "TOTALDEMAND", "TOTALMET", "%MetOnLane", "SOURCING") AS 
  with total_demand as
    (select skc.item
      ,skc.loc
      ,round(sum(skc.qty),1) as totaldemand
    from skuconstraint skc
    where skc.category=1
        and skc.qty > 0
        and skc.eff between v_demand_start_date and v_demand_end_date
    group by skc.item
      , skc.loc
    )
  , total_met as
    (select sm.sourcing
      ,sm.item
      ,sm.dest
      ,round(sum(value),0) qty
    from sim_sourcingmetric sm
      , loc l
    where sm.category=418
        and sm.dest=l.loc
        and l.loc_type=3
        and sm.eff between v_demand_start_date and v_demand_end_date
		and sm.simulation_name='AD'
    group by sm.sourcing
      ,sm.item
      ,sm.dest
    order by sourcing
      , item
      , dest
    )
select td.item                                 as item
  ,td.loc                                      as dest
  ,td.totaldemand                              as totaldemand
  , nvl(tm.qty,0)                              as totalmet
  ,round((nvl(tm.qty,0)/td.totaldemand)*100,2) as "%MetOnLane"
  ,nvl(tm.sourcing,'NONE')                     as sourcing
from total_demand td
  , total_met tm
  , loc lc
where td.loc=tm.dest(+)
    and td.item=tm.item(+)
    and lc.loc=td.loc
    and lc.u_area='NA'
