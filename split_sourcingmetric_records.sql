with custords as
( select co.item , co.loc, co.shipdate, min(co.qty) min_qty, max(co.qty) max_qty, count(1) Norders
from custorder co, loc l
where l.loc=co.loc
and l.u_area='NA'
and co.item='4055RUPLUS'
and co.shipdate <= trunc(sysdate) + 5
group by co.item , co.loc, co.shipdate
),
ranked as (
select sm.sourcing, sm.item, sm.dest, sm.eff --, co.orderid , co.qty order_qty
      , lead( source,0,null) over( partition by sm.item, sm.dest, sm.eff
                      order by sm.item, sm.dest, sm.eff, value desc ) as plant_0
      , lead( round(sm.value),0,null) over( partition by sm.item, sm.dest, sm.eff
                      order by sm.item, sm.dest, sm.eff, value desc ) as value_0
      , lead( source,1,null) over( partition by sm.item, sm.dest, sm.eff
                      order by sm.item, sm.dest, sm.eff, value desc ) as plant_1
      , lead( round(sm.value),1,null) over( partition by sm.item, sm.dest, sm.eff
                      order by sm.item, sm.dest, sm.eff, value desc ) as value_1
      , lead( source,2,null) over( partition by sm.item, sm.dest, sm.eff
                      order by sm.item, sm.dest, sm.eff, value desc ) as plant_2
      , lead( round(sm.value),2,null) over( partition by sm.item, sm.dest, sm.eff
                      order by sm.item, sm.dest, sm.eff, value desc ) as value_2
      , lead( source,3,null) over( partition by sm.item, sm.dest, sm.eff
                      order by sm.item, sm.dest, sm.eff, value desc ) as plant_3
      , lead( round(sm.value),3,null) over( partition by sm.item, sm.dest, sm.eff
                      order by sm.item, sm.dest, sm.eff, value desc ) as value_3
      , lead( source,4,null) over( partition by sm.item, sm.dest, sm.eff
                      order by sm.item, sm.dest, sm.eff, value desc ) as plant_4
      , lead( round(sm.value),4,null) over( partition by sm.item, sm.dest, sm.eff
                      order by sm.item, sm.dest, sm.eff, value desc ) as value_4
      , lead( source,5,null) over( partition by sm.item, sm.dest, sm.eff
                      order by sm.item, sm.dest, sm.eff, value desc ) as plant_5
      , lead( round(sm.value),5,null) over( partition by sm.item, sm.dest, sm.eff
                      order by sm.item, sm.dest, sm.eff, value desc ) as value_5
      , rank() over ( partition by sm.item, sm.dest, sm.eff
                      order by sm.item, sm.dest, sm.eff, value desc ) as rank

from sim_sourcingmetric sm, loc l
where sm.simulation_name='AD'
and category=418
and sm.value > 0
and l.loc=sm.dest
and l.u_area='NA'                                and sm.item='4055RUPLUS'
and sm.eff <= trunc(sysdate) + 5
order by item, dest, eff, value desc
)
select r.*, co.min_qty, co.max_qty, co.norders
from ranked r, custords co
where r.rank=1
and r.plant_1 is not null
and co.item=r.item
and co.loc=r.dest
and co.shipdate=r.eff
and co.norders=1
