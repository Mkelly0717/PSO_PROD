--------------------------------------------------------
--  DDL for View MAK_HIST_OF_MILAGE_LOADS
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_HIST_OF_MILAGE_LOADS" ("RUNDATE", "SCHEDSHIPDATE", "PLANNDAY", "000-049", "050-099", "100-149", "150-199", "200-249", "250-299", "300-349", "350-399", "400-499", "450-499", "500+", "TOT_LOADS", "TOT_QTY", "AVG_DAILY_QTY", "TOTAL_MILAGE", "AVG_MILAGE", "STDDEV_MILAGE", "TOTAL_COST", "AVG_COST", "STDDEV_COST", "AVG_COST_PER_MILE", "AVG_COST_PER_LOAD", "AVG_COST_PER_PALLET") AS 
  with data as
  ( select trunc( sysdate ) rundate                                            , pe.co_orderid, pe.loadid, pe.co_qty qty
, pe.schedshipdate                                                          ,( pe.schedshipdate - trunc( sysdate ) )
  plannday                                                                  , ct.distance, ct.cost_pallet, decode( to_char(
  width_bucket( ct.distance, 0, 1000, 20 ) ), '1', 1, 0 ) "000-049"         , decode(
  to_char( width_bucket( ct.distance, 0, 1000, 20 ) ), '2', 1, 0 ) "050-099",
  decode( to_char( width_bucket( ct.distance, 0, 1000, 20 ) ), '3', 1, 0 )
  "100-149"                                                                  , decode( to_char( width_bucket( ct.distance, 0, 1000, 20 ) ), '4',
  1, 0 ) "150-199"                                                           , decode( to_char( width_bucket( ct.distance, 0, 1000, 20 ) )
  , '5', 1, 0 ) "200-249"                                                    , decode( to_char( width_bucket( ct.distance, 0, 1000,
  20 ) ), '6', 1, 0 ) "250-299"                                              , decode( to_char( width_bucket( ct.distance, 0,
  1000, 20 ) ), '7', 1, 0 ) "300-349"                                        , decode( to_char( width_bucket(
  ct.distance, 0, 1000, 20 ) ), '8', 1, 0 ) "350-399"                        , decode( to_char(
  width_bucket( ct.distance, 0, 1000, 20 ) ), '9', 1, 0 ) "400-449"          , decode(
  to_char( width_bucket( ct.distance, 0, 1000, 20 ) ), '10', 1, 0 ) "450-499",
  decode( to_char( width_bucket( ct.distance, 500, 100000, 1 ) ), '1', 1, 0 )
  "500+"
   from mak_cust_table pe, loc ls, loc ld, udt_cost_transit_na ct
  where PE.FIRMSW                                               = 1 
    and LS.LOC = pe.assigned_plant 
    and LD.LOC = pe.loc 
    and ls.u_area
                                                                = 'NA' and ld.u_area = 'NA' and ct.source_pc = ls.postalcode
  and CT.DEST_PC                                                = LD.POSTALCODE and CT.U_EQUIPMENT_TYPE = DECODE(
  LD.U_EQUIPMENT_TYPE, 'FB', 'FB', 'VN' ) and PE.SCHEDSHIPDATE <= TRUNC(
  sysdate ) + 5
 order by 1, 2 asc
  )
 select data.rundate                         , data.schedshipdate              , plannday, sum( data."000-049" )
  "000-049"                                  , sum( data. "050-099" ) "050-099", sum( data."100-149" )
  "100-149"                                  , sum( data. "150-199" ) "150-199", sum( data."200-249" )
  "200-249"                                  , sum( data. "250-299" ) "250-299", sum( data."300-349" )
  "300-349"                                  , sum( data. "350-399" ) "350-399", sum( data."400-449" )
  "400-499"                                  , sum( data. "450-499" ) "450-499", sum( data."500+" )
  "500+"                                     , count( 1 ) tot_loads            , sum( data.qty ) tot_qty
  , round( avg( data.qty ), 2 ) avg_daily_qty, round( sum( data.distance ), 2 )
  total_milage                               , round( avg( data.distance ), 2 )
  avg_milage                                 , round( stddev( data.distance ),
  2 ) stddev_milage                          , round( sum( data.cost_pallet ),
  2 ) total_cost                             , round( avg( data.cost_pallet ),
  2 ) avg_cost                               , round( stddev( data.cost_pallet
  ), 2 ) stddev_cost                         , round( sum( data.cost_pallet ) /
  sum( data.distance ), 2 ) avg_cost_per_mile, round( sum( data.cost_pallet ) /
  count( 1 ), 2 ) avg_cost_per_load          , round( sum( data.cost_pallet ) /
  sum( data.qty ), 2 ) avg_cost_per_pallet
   from data data
group by data.RUNDATE, data.PLANNDAY, data.SCHEDSHIPDATE
order by data.schedshipdate asc
