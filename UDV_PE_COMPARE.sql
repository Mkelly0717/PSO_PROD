  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_PE_COMPARE" ("NEEDARRIVDATE", "CNT->", "CNT_M", "CNT_U", "CNT_NE", "CNT_DM", "CNT_DU", "CNT_DNE", "QTY->", "QTY_M", "QTY_U", "QTY_NE", "QTY_DM", "QTY_DU", "QTY_DN", "TOTALS->  ", "TOT_ORD_CNT", "TOT_DEL_CNT", "TOT_ORD_QTY", "TOT_DEL_QTY", "Percent->", "PERCENT_CNT", "PERCENT_QTY", "MET INFO=>", "CO_CNT", "PA_CNT", "CO_QTY", "PA_QTY", "DEL_CNT", "PD_CNT", "DEL_QTY", "PD_QTY", "%MET INFO=>", "%CO_MET", "%CO_QTY_MET", "%DEL_MET", "%DELQTY_MET") AS 
  with dates as
  ( select distinct TRUNC( EFF ) NEEDARRIVDATE
     from sim_sourcingmetric sm
    where category = 418
	and sm.simulation_name='AD'
 order by trunc( eff ) asc
  )                               , match as
  (select needarrivdate           , count( 1 ) cnt, sum( qty ) qty
     from udt_planarriv_extract pe, udt_llamasoft_data ll
    where pe.firmsw = 1 and pe.item like '%RU%' and pe.dest = ll.dest(+) and
    pe.source       = ll.source(+) and pe.item = ll.item(+) and ll.item is not
    null
 group by needarrivdate
  )                               , unmatch as
  (select needarrivdate           , count( 1 ) cnt, sum( qty ) qty
     from udt_planarriv_extract pe, udt_llamasoft_data ll
    where pe.firmsw = 1 and pe.item like '%RU%' and pe.dest = ll.dest and
    pe.source      <> ll.source and pe.item = ll.item
 group by needarrivdate
  )                               , notexist as
  (select needarrivdate           , count( 1 ) cnt, sum( qty ) qty
     from udt_planarriv_extract pe, udt_llamasoft_data ll
    where pe.firmsw = 1 and pe.item like '%RU%' and pe.dest = ll.dest(+) and
    pe.source       = ll.source(+) and pe.item = ll.item(+) and ll.item is null
    and not exists
    (select 1
       from udt_llamasoft_data ll2
      where ll2.dest = pe.dest and ll2.item = pe.item
    )
 group by needarrivdate
  )                               , del_match as
  (select needarrivdate           , count( 1 ) cnt, sum( qty ) qty
     from udt_planarriv_extract pe, udt_llamasoft_data ll
    where pe.firmsw = 2 and pe.item like '%RU%' and pe.dest = ll.dest(+) and
    pe.source       = ll.source(+) and pe.item = ll.item(+) and ll.item is not
    null
 group by needarrivdate
  )                               , del_unmatch as
  (select needarrivdate           , count( 1 ) cnt, sum( qty ) qty
     from udt_planarriv_extract pe, udt_llamasoft_data ll
    where pe.firmsw = 2 and pe.item like '%RU%' and pe.dest = ll.dest(+) and
    pe.source       = ll.source(+) and pe.item = ll.item(+) and ll.item is null
    and exists
    (select 1
       from udt_llamasoft_data ll2
      where ll2.dest = pe.dest and ll2.item = pe.item
    )
 group by needarrivdate
  )                               , del_notexist as
  (select needarrivdate           , count( 1 ) cnt, sum( qty ) qty
     from udt_planarriv_extract pe, udt_llamasoft_data ll
    where pe.firmsw = 2 and pe.item like '%RU%' and pe.dest = ll.dest(+) and
    pe.source       = ll.source(+) and pe.item = ll.item(+) and ll.item is null
    and not exists
    (select 1
       from udt_llamasoft_data ll2
      where ll2.dest = pe.dest and ll2.item = pe.item
    )
 group by needarrivdate
  )                   , co_orders as
  (select shipdate    , count( 1 ) cnt, sum( qty ) tot_qty
     from custorder co, loc l
    where l.loc = co.loc and l.u_area = 'NA' and not exists
    ( select 1 from vehicleloadline vll where vll.orderid = co.orderid
    ) and co.item like '%RU%'
 group by shipdate
 order by shipdate asc
  )                    , planned_orders as
  (select needarrivdate, count( 1 ) cnt, sum( qty ) tot_qty
     from udt_planarriv_extract pe
    where pe.firmsw = 1
 group by needarrivdate
  )                   , del_orders as
  (select shipdate    , count( 1 ) cnt, sum( qty ) tot_qty
     from custorder co, loc l
    where exists
    ( select 1 from vehicleloadline vll where vll.orderid = co.orderid
    ) and co.item like '%RU%' and l.loc = co.loc and l.u_area = 'NA'
 group by shipdate
 order by shipdate asc
  )                    , planned_del as
  (select needarrivdate, count( 1 ) cnt, sum( qty ) tot_qty
     from udt_planarriv_extract pe
    where pe.firmsw = 2
 group by needarrivdate
  )
 select dates.needarrivdate                , null "CNT->"             , nvl( m.cnt, 0 ) cnt_m  , nvl( u.cnt, 0
  ) cnt_u                                  , nvl( ne.cnt, 0 ) cnt_ne  , nvl( dm.cnt, 0 ) cnt_dm,
  nvl( du.cnt, 0 ) cnt_du                  , nvl( dne.cnt, 0 ) cnt_dne, null "QTY->"           ,
  nvl( m.qty, 0 ) qty_m                    , nvl( u.qty, 0 ) qty_u    , nvl( ne.qty, 0 ) qty_ne
  , nvl( dm.qty, 0 ) qty_dm                , nvl( du.qty, 0 ) qty_du  , nvl( dne.qty, 0 )
  qty_dn                                   , null "TOTALS->  "        , nvl( m.cnt, 0 ) + nvl(
  u.cnt, 0 ) + nvl( ne.cnt, 0 ) tot_ord_cnt, nvl( dm.cnt, 0 ) + nvl( du.cnt, 0
  ) + nvl( dne.cnt, 0 ) tot_del_cnt        , nvl( m.qty, 0 ) + nvl( u.qty, 0 )
  + nvl( ne.qty, 0 ) tot_ord_qty           , nvl( dm.qty, 0 ) + nvl( du.qty, 0
  ) + nvl( dne.qty, 0 ) tot_del_qty        , null "Percent->", nvl( round(
  nullif(( nvl( m.cnt, 0 ) + nvl( ne.cnt, 0 ) + nvl( dm.cnt, 0 ) + nvl( dne.cnt
  , 0 ) ), 0 ) / nullif(( nvl( m.cnt, 0 ) + nvl( u.cnt, 0 ) + nvl( ne.cnt, 0 )
  + nvl( dm.cnt, 0 ) + nvl( du.cnt, 0 ) + nvl( dne.cnt, 0 ) ), 0 ), 3 ) * 100,
  0 ) percent_cnt, nvl( round( nullif(( nvl( m.qty, 0 ) + nvl( ne.qty, 0 ) +
  nvl( dm.qty, 0 ) + nvl( dne.qty, 0 ) ), 0 ) / nullif(( nvl( m.qty, 0 ) + nvl(
  u.qty, 0 ) + nvl( ne.qty, 0 ) + nvl( dm.qty, 0 ) + nvl( du.qty, 0 ) + nvl(
  dne.qty, 0 ) ), 0 ), 3 ) * 100, 0 ) percent_qty          , null "MET INFO=>"          , nvl(
  co.cnt, 0 ) co_cnt                                       , nvl( pe.cnt, 0 ) pa_cnt    , nvl
  ( co.tot_qty, 0 ) co_qty                                 , nvl( pe.tot_qty, 0 ) pa_qty,
  nvl( do.cnt, 0 ) del_cnt                                 , nvl( pd.cnt, 0 ) pd_cnt    ,
  nvl( do.tot_qty, 0 ) del_qty                             , nvl( pd.tot_qty, 0 ) pd_qty,
  null "%MET INFO=>"                                       , nvl( round( nvl( pe.cnt, 0 )
  / nullif( nvl( co.cnt, 0 ), 0 ), 4 ) * 100, 0 ) "%CO_MET", nvl( round( nvl(
  pe.tot_qty, 0 ) / nullif( nvl( co.tot_qty, 0 ), 0 ), 4 ) * 100, 0 )
  "%CO_QTY_MET"                              , nvl( round( nvl( pd.cnt, 0 ) / nullif( nvl( do.cnt, 0 ), 0 ), 4 ) * 100, 0 ) "%DEL_MET", nvl( round( nvl( pd.tot_qty, 0 )
  / nullif( nvl( do.tot_qty, 0 ), 0 ), 4 ) * 100, 0 ) "%DELQTY_MET"
   from match m , unmatch u       , notexist ne , del_match dm
, del_unmatch du, del_notexist dne, co_orders co, planned_orders pe
, del_orders do , planned_del pd  , dates dates
  where m.needarrivdate(+)                    = dates.needarrivdate and u.needarrivdate(+) =
  dates.needarrivdate and ne.needarrivdate(+) = dates.needarrivdate and
  dm.needarrivdate(+)                         = dates.needarrivdate and
  du.needarrivdate(+)                         = dates.needarrivdate and
  dne.needarrivdate(+)                        = dates.needarrivdate and
  co.shipdate(+)                              = dates.needarrivdate and
  pe.needarrivdate(+)                         = dates.needarrivdate and
  do.shipdate(+)                              = dates.needarrivdate and
  pd.needarrivdate(+)                         = dates.needarrivdate
  --and round((nvl(m.cnt,0) + nvl(ne.cnt,0) + nvl(dm.cnt,0) + nvl(dne.cnt,0)))
  -- <> 0
order by dates.needarrivdate
