--------------------------------------------------------
--  DDL for View MAK_HIST_OF_MILAGE_PERCENT
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_HIST_OF_MILAGE_PERCENT" ("RUNDATE", "NEEDARRIVDATE", "PLANNDAY", "000-049", "050-099", "100-149", "150-199", "200-249", "250-299", "300-349", "350-399", "400-499", "450-499", "500+", "TOT_LOADS", "TOT_QTY", "AVG_DAILY_QTY", "TOTAL_MILAGE", "AVG_MILAGE", "STDDEV_MILAGE", "TOTAL_COST", "AVG_COST", "STDDEV_COST", "AVG_COST_PER_MILE", "AVG_COST_PER_LOAD", "AVG_COST_PER_PALLET") AS 
  with dates as
  ( select distinct trunc( eff ) needarrivdate
     from sim_sourcingmetric sm
    where category                = 418 and sm.eff between trunc( sysdate ) and trunc( sysdate
    ) + 14 and sm.simulation_name = 'AD'
 order by trunc( eff ) asc
  )                               , data as
  (select trunc( sysdate ) rundate, pe.co_orderid    , pe.loadid, pe.co_qty
  , pe.shipdate needarrivdate     , pe.schedarrivdate,( pe.shipdate - trunc(
    sysdate ) ) plannday          , ct.distance      , ct.cost_pallet, decode(
    to_char( width_bucket( ct.distance, 0, 1000, 20 ) ), '1', pe.co_qty, 0 )
    "000-049"                                                  , decode( to_char( width_bucket( ct.distance, 0, 1000, 20 ) ), '2'
    , pe.co_qty, 0 ) "050-099"                                 , decode( to_char( width_bucket( ct.distance, 0,
    1000, 20 ) ), '3', pe.co_qty, 0 ) "100-149"                , decode( to_char( width_bucket(
    ct.distance, 0, 1000, 20 ) ), '4', pe.co_qty, 0 ) "150-199", decode(
    to_char( width_bucket( ct.distance, 0, 1000, 20 ) ), '5', pe.co_qty, 0 )
    "200-249"                                                  , decode( to_char( width_bucket( ct.distance, 0, 1000, 20 ) ), '6'
    , pe.co_qty, 0 ) "250-299"                                 , decode( to_char( width_bucket( ct.distance, 0,
    1000, 20 ) ), '7', pe.co_qty, 0 ) "300-349"                , decode( to_char( width_bucket(
    ct.distance, 0, 1000, 20 ) ), '8', pe.co_qty, 0 ) "350-399", decode(
    to_char( width_bucket( ct.distance, 0, 1000, 20 ) ), '9', pe.co_qty, 0 )
    "400-449"                     , decode( to_char( width_bucket( ct.distance, 0, 1000, 20 ) ),
    '10', pe.co_qty, 0 ) "450-499", decode( to_char( width_bucket( ct.distance,
    500, 100000, 1 ) ), '1', pe.co_qty, 0 ) "500+"
     from mak_cust_table pe, loc ls, loc ld, udt_cost_transit_na ct
    where pe.firmsw                                                  = 1 and ls.loc = pe.assigned_plant and ld.loc = pe.loc and
    ls.u_area                                                        = 'NA' and ld.u_area = 'NA' and ct.source_pc =
    ls.postalcode and ct.dest_pc                                     = ld.postalcode and ct.u_equipment_type =
    decode( ld.u_equipment_type, 'FB', 'FB', 'VN' ) and pe.shipdate <= trunc(
    sysdate ) + 14
 order by 1, 2 asc
  )
 select nvl( data.rundate, trunc( sysdate ) ) rundate, dates.needarrivdate, nvl
  ( plannday, dates.needarrivdate - nvl( data.rundate, trunc( sysdate ) ) )
  plannday                                                                   , nvl( round( 100 * sum( data."000-049" ) / sum( data.co_qty ), 4 ),
  0 ) "000-049"                                                              , nvl( round( 100 * sum( data."050-099" ) / sum( data.co_qty ),
  4 ), 0 ) "050-099"                                                         , nvl( round( 100 * sum( data."100-149" ) / sum(
  data.co_qty ), 4 ), 0 ) "100-149"                                          , nvl( round( 100 * sum( data. "150-199" ) /
  sum( data.co_qty ), 4 ), 0 ) "150-199"                                     , nvl( round( 100 * sum( data."200-249"
  ) / sum( data.co_qty ), 4 ), 0 ) "200-249"                                 , nvl( round( 100 * sum( data.
  "250-299" ) / sum( data.co_qty ), 4 ), 0 ) "250-299"                       , nvl( round( 100 * sum(
  data."300-349" ) / sum( data.co_qty ), 4 ), 0 ) "300-349"                  , nvl( round( 100 *
  sum( data."350-399" ) / sum( data.co_qty ), 4 ), 0 ) "350-399"             , nvl( round(
  100 * sum( data."400-449" ) / sum( data.co_qty ), 4 ), 0 ) "400-499"       , nvl(
  round( 100 * sum( data."450-499" ) / sum( data.co_qty ), 4 ), 0 ) "450-499",
  nvl( round( 100 * sum( data."500+" ) / sum( data.co_qty ), 4 ), 0 ) "500+" ,
  count( 1 ) tot_loads                                                       ,
  nvl( sum( data.co_qty ), 0 ) tot_qty                                       ,
  nvl( round( avg( data.co_qty ), 2 ), 0 ) avg_daily_qty                     ,
  nvl( round( sum( data.distance ), 2 ), 0 ) total_milage                    ,
  nvl( round( avg( data.distance ), 2 ), 0 ) avg_milage                      ,
  nvl( round( stddev( data.distance ), 2 ), 0 ) stddev_milage                ,
  nvl( round( sum( data.cost_pallet ), 2 ), 0 ) total_cost                   ,
  nvl( round( avg( data.cost_pallet ), 2 ), 0 ) avg_cost                     ,
  nvl( round( stddev( data.cost_pallet ), 2 ), 0 ) stddev_cost               ,
  nvl( round( sum( data.cost_pallet ) / sum( data.distance ), 2 ), 0 )
  avg_cost_per_mile, nvl( round( sum( data.cost_pallet ) / count( 1 ), 2 ), 0 )
  avg_cost_per_load, nvl( round( sum( data.cost_pallet ) / sum( data.co_qty ),
  2 ), 0 ) avg_cost_per_pallet
   from data data, dates dates
  where dates.needarrivdate = data.needarrivdate (+)
group by data.RUNDATE, data.PLANNDAY, DATES.NEEDARRIVDATE
order by dates.needarrivdate asc
