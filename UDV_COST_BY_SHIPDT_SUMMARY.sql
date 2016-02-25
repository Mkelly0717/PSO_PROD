--------------------------------------------------------
--  DDL for View UDV_COST_BY_SHIPDT_SUMMARY
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_COST_BY_SHIPDT_SUMMARY" ("SCHEDSHIPDATE", "TOT_DELIVERIES", "TOTAL_DELIVERY_COST", "DELIVERY_COST_PER_LOAD", " ", "TOT_ORDERS", "TOTAL_ORDER_COST", "ORDER_COST_PER_LOAD", "  ", "DELIVERY_PALLET_QTY", "DELIVERY_PALLET_COST", "DELIVERY_COST_PER_PALLET", "   ", "ORDER_PALLET_QTY", "ORDER_PALLET_COST", "ORDER_COST_PER_PALLET") AS 
  with dates as
  (
    select distinct trunc( eff ) schedshipdate
       from sim_sourcingmetric
      where category = 418
      and simulation_name='AD'
   order by trunc( eff ) asc
  )
  , cost_per_load_deliveries as
(   select pe.schedshipdate, sum( ct.cost_pallet ) total_cost, count(1)
    total_loads           , round( sum( ct.cost_pallet ) / count(1), 2 )
    cost_per_order
     from udt_planarriv_extract pe, loc ls, loc ld, udt_cost_transit_na ct
    where pe.firmsw         = 2
    and ls.loc              = pe.source
    and ld.loc              = pe.dest
    and ls.u_area           = 'NA'
    and ld.u_area           = 'NA'
    and ct.source_pc        = ls.postalcode
    and ct.dest_pc          = ld.postalcode
    and ct.u_equipment_type = decode( ld.u_equipment_type, 'FB', 'FB', 'VN' )
    and pe.schedshipdate   <= trunc( sysdate ) + 3
 group by pe.schedshipdate
 order by 1 asc
 ), cost_per_load_open_orders as
(   select pe.schedshipdate, sum( ct.cost_pallet ) total_cost, count(1)
    total_loads           , round( sum( ct.cost_pallet ) / count(1), 2 )
    cost_per_order
     from udt_planarriv_extract pe, loc ls, loc ld, udt_cost_transit_na ct
    where pe.firmsw         = 1
    and ls.loc              = pe.source
    and ld.loc              = pe.dest
    and ls.u_area           = 'NA'
    and ld.u_area           = 'NA'
    and ct.source_pc        = ls.postalcode
    and ct.dest_pc          = ld.postalcode
    and ct.u_equipment_type = decode( ld.u_equipment_type, 'FB', 'FB', 'VN' )
    and pe.schedshipdate   <= trunc( sysdate ) + 3
 group by pe.schedshipdate
 order by 1 asc
), cost_per_pallet_deliveries as
(
   select pe.schedshipdate, sum( ct.cost_pallet ) total_cost, sum( pe.qty )
    total_qty             , round( sum( ct.cost_pallet ) / sum( pe.qty ), 2 )
    cost_per_pallet
     from udt_planarriv_extract pe, loc ls, loc ld, udt_cost_transit_na ct
    where pe.firmsw         = 2
    and ls.loc              = pe.source
    and ld.loc              = pe.dest
    and ls.u_area           = 'NA'
    and ld.u_area           = 'NA'
    and ct.source_pc        = ls.postalcode
    and ct.dest_pc          = ld.postalcode
    and ct.u_equipment_type = decode( ld.u_equipment_type, 'FB', 'FB', 'VN' )
    and pe.schedshipdate   <= trunc( sysdate ) + 3
 group by pe.schedshipdate
 order by 1 asc
), cost_per_pallet_orders as
(   select pe.schedshipdate, sum( ct.cost_pallet ) total_cost, sum( pe.qty )
    total_qty             , round( sum( ct.cost_pallet ) / sum( pe.qty ), 2 )
    cost_per_pallet
     from udt_planarriv_extract pe, loc ls, loc ld, udt_cost_transit_na ct
    where pe.firmsw         = 1
    and ls.loc              = pe.source
    and ld.loc              = pe.dest
    and ls.u_area           = 'NA'
    and ld.u_area           = 'NA'
    and ct.source_pc        = ls.postalcode
    and ct.dest_pc          = ld.postalcode
    and ct.u_equipment_type = decode( ld.u_equipment_type, 'FB', 'FB', 'VN' )
    and pe.schedshipdate   <= trunc( sysdate ) + 3
 group by pe.schedshipdate
 order by 1 asc
) select dates.schedshipdate

       , nvl(cpld.total_loads,0) tot_deliveries
       , nvl(cpld.total_cost,0) total_delivery_cost
       , nvl(cpld.cost_per_order,0) delivery_cost_per_load
       , null " "
       , nvl(cplo.total_loads,0) tot_orders
       , nvl(cplo.total_cost,0) total_order_cost
       , nvl(cplo.cost_per_order,0) order_cost_per_load
       , null "  "
       , nvl(cppd.total_qty,0) delivery_pallet_qty
       , nvl(cppd.total_cost,0) delivery_pallet_cost
       , nvl(cppd.cost_per_pallet,0) delivery_cost_per_pallet
       , null "   "
       , nvl(cppo.total_qty,0) order_pallet_qty
       , nvl(cppo.total_cost,0) order_pallet_cost
       , nvl(cppo.cost_per_pallet,0) order_cost_per_pallet
from  cost_per_load_deliveries  cpld
    , cost_per_load_open_orders cplo
    , cost_per_pallet_deliveries cppd
    , cost_per_pallet_orders cppo
    , dates dates
where dates.schedshipdate = cpld.schedshipdate(+)
  and dates.schedshipdate = cplo.schedshipdate(+)
  and dates.schedshipdate = cppd.schedshipdate(+)
  and dates.schedshipdate = cppo.schedshipdate(+)
