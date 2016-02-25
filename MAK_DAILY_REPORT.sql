--------------------------------------------------------
--  DDL for View MAK_DAILY_REPORT
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_DAILY_REPORT" ("RUNDATE", "PLANNDAY", "NEEDARRIVDATE", "PERCENT_P1_MATCH_QTY", "AVG_COST", "AVG_MILAGE", "PERCENT_ORDERS_MET", "000-049", "050-099", "100-149", "150-199", "200-249", "250-299", "300-349", "350-399", "400-499", "450-499", "500+", "TOT_LOADS", "TOT_QTY") AS 
  with dates as
  ( select distinct trunc( eff ) needarrivdate
     from sim_sourcingmetric sm
    where category = 418 and sm.eff between trunc( sysdate ) and trunc( sysdate
    ) + 13
    and sm.simulation_name='AD'
 order by trunc( eff ) asc
  )                       , p1_match as
  ( select needarrivdate  , percent_qty from mak_pe_to_p1_match
  )                       , miles as
  (select hm.needarrivdate, hm.avg_cost, hm.avg_milage, rundate
  , plannday              , "000-049"  , "050-099"    , "100-149"
  , "150-199"             , "200-249"  , "250-299"    , "300-349"
  , "350-399"             , "400-499"  , "450-499"    , "500+"
  , tot_loads             , tot_qty
     from mak_hist_of_milage_percent hm
  )                     , orders_met as
  ( select needarrivdate, "%CO_MET" "%CO_MET" from mak_pe_compare
  )
 select to_char( rundate, 'YYYY-MM-DD' ) rundate   , plannday                , to_char(
  dates.needarrivdate, 'YYYY-MM-DD' ) needarrivdate, p1.percent_qty Percent_P1_Match_Qty,
  miles.avg_cost                                   , miles.avg_milage        ,
  om."%CO_MET" Percent_Orders_Met                  , "000-049"               ,
  "050-099"                                        , "100-149"               ,
  "150-199"                                        , "200-249"               ,
  "250-299"                                        , "300-349"               ,
  "350-399"                                        , "400-499"               ,
  "450-499"                                        , "500+"                  ,
  tot_loads                                        , tot_qty
   from dates dates                                , p1_match p1, miles miles,
  orders_met om
  where dates.needarrivdate                   = miles.needarrivdate(+) and dates.needarrivdate =
  p1.needarrivdate(+) and dates.needarrivdate = om.needarrivdate(+)
order by plannday asc
