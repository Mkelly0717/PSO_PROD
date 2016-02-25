  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_HIST_OF_MILAGE_PERCENT_DEV" ("RUNDATE", "SCHEDSHIPDATE", "SCHEDARRIVDATE", "PLANNDAY", "000-049", "050-099", "100-149", "150-199", "200-249", "250-299", "300-349", "350-399", "400-499", "450-499", "500+", "TOT_LOADS", "TOT_QTY", "AVG_DAILY_QTY", "TOTAL_MILAGE", "AVG_MILAGE", "STDDEV_MILAGE", "TOTAL_COST", "AVG_COST", "STDDEV_COST", "AVG_COST_PER_MILE", "AVG_COST_PER_LOAD", "VG_COST_PER_PALLET") AS 
  with dates as
  ( select distinct trunc( eff ) schedshipdate
     from sim_sourcingmetric sm
    where category = 418 and sm.eff between trunc( sysdate ) and trunc( sysdate
    ) + 3
	and sm.simulation_name='AD'
 order by trunc( eff ) asc
  )                               , data as
  (select trunc( sysdate ) rundate, pe.u_custorderid , pe.loadid, pe.qty
  , pe.schedshipdate              , pe.schedarrivdate,( pe.schedshipdate -
    trunc( sysdate ) ) plannday   , ct.distance      , ct.cost_pallet, decode(
    to_char( width_bucket( ct.distance, 0, 1000, 20 ) ), '1', pe.qty, 0 )
    "000-049"                                                             , decode( to_char( width_bucket( ct.distance, 0, 1000, 20 ) ), '2'
    , pe.qty, 0 ) "050-099"                                               , decode( to_char( width_bucket( ct.distance, 0,
    1000, 20 ) ), '3', pe.qty, 0 ) "100-149"                              , decode( to_char( width_bucket(
    ct.distance, 0, 1000, 20 ) ), '4', pe.qty, 0 ) "150-199"              , decode( to_char(
    width_bucket( ct.distance, 0, 1000, 20 ) ), '5', pe.qty, 0 ) "200-249",
    decode( to_char( width_bucket( ct.distance, 0, 1000, 20 ) ), '6', pe.qty, 0
    ) "250-299"                                                            , decode( to_char( width_bucket( ct.distance, 0, 1000, 20 ) ),
    '7', pe.qty, 0 ) "300-349"                                             , decode( to_char( width_bucket( ct.distance, 0,
    1000, 20 ) ), '8', pe.qty, 0 ) "350-399"                               , decode( to_char( width_bucket(
    ct.distance, 0, 1000, 20 ) ), '9', pe.qty, 0 ) "400-449"               , decode( to_char(
    width_bucket( ct.distance, 0, 1000, 20 ) ), '10', pe.qty, 0 ) "450-499",
    decode( to_char( width_bucket( ct.distance, 500, 100000, 1 ) ), '1', pe.qty
    , 0 ) "500+"
     from udt_planarriv_extract pe, loc ls, loc ld, udt_cost_transit_na ct
    where pe.firmsw                                                       = 1 and ls.loc = pe.source and ld.loc = pe.dest and
    ls.u_area                                                             = 'NA' and ld.u_area = 'NA' and ct.source_pc =
    ls.postalcode and ct.dest_pc                                          = ld.postalcode and ct.u_equipment_type =
    decode( ld.u_equipment_type, 'FB', 'FB', 'VN' ) and pe.schedshipdate <=
    trunc( sysdate ) + 3
 order by 1, 2 asc
  )
 select nvl( data.rundate, trunc( sysdate ) ) rundate, dates.schedshipdate, data.schedarrivdate,  nvl
  ( plannday, dates.schedshipdate - nvl( data.rundate, trunc( sysdate ) ) )
  plannday                                                   , nvl( round( 100 * sum( data."000-049" ) / sum( data.qty ), 4 ), 0 )
  "000-049"                                                  , nvl( round( 100 * sum( data."050-099" ) / sum( data.qty ), 4 ), 0
  ) "050-099"                                                , nvl( round( 100 * sum( data."100-149" ) / sum( data.qty ), 4 ),
  0 ) "100-149"                                              , nvl( round( 100 * sum( data. "150-199" ) / sum( data.qty ), 4
  ), 0 ) "150-199"                                           , nvl( round( 100 * sum( data."200-249" ) / sum( data.qty ),
  4 ), 0 ) "200-249"                                         , nvl( round( 100 * sum( data."250-299" ) / sum( data.qty )
  , 4 ), 0 ) "250-299"                                       , nvl( round( 100 * sum( data."300-349" ) / sum( data.qty
  ), 4 ), 0 ) "300-349"                                      , nvl( round( 100 * sum( data."350-399" ) / sum(
  data.qty ), 4 ), 0 ) "350-399"                             , nvl( round( 100 * sum( data."400-449" ) / sum
  ( data.qty ), 4 ), 0 ) "400-499"                           , nvl( round( 100 * sum( data."450-499" ) /
  sum( data.qty ), 4 ), 0 ) "450-499"                        , nvl( round( 100 * sum( data."500+" ) /
  sum( data.qty ), 4 ), 0 ) "500+"                           , nvl( count( 1 ), 0 ) tot_loads, nvl( sum
  ( data.qty ), 0 ) tot_qty                                  , nvl( round( avg( data.qty ), 2 ), 0 )
  avg_daily_qty                                              , nvl( round( sum( data.distance ), 2 ), 0
  ) total_milage                                             , nvl( round( avg( data.distance ), 2 ), 0
  ) avg_milage                                               , nvl( round( stddev( data.distance ), 2 )
  , 0 ) stddev_milage                                        , nvl( round( sum( data.cost_pallet ), 2 )
  , 0 ) total_cost                                           , nvl( round( avg( data.cost_pallet ), 2 )
  , 0 ) avg_cost                                             , nvl( round( stddev( data.cost_pallet ),
  2 ), 0 ) stddev_cost                                       , nvl( round( sum( data.cost_pallet ) /
  sum( data.distance ), 2 ), 0 ) avg_cost_per_mile           , nvl( round( sum(
  data.cost_pallet ) / count( 1 ), 2 ), 0 ) avg_cost_per_load, nvl( round( sum(
  data.cost_pallet ) / sum( data.qty ), 2 ), 0 ) vg_cost_per_pallet
   from data data, dates dates
  where dates.schedshipdate = data.schedshipdate (+)
group by data.rundate, data.plannday, dates.schedshipdate, data.schedarrivdate
order by dates.schedshipdate asc
