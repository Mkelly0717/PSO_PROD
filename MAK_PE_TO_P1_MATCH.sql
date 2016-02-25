--------------------------------------------------------
--  DDL for View MAK_PE_TO_P1_MATCH
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_PE_TO_P1_MATCH" ("NEEDARRIVDATE", "CNT_M", "CNT_U", "CNT_NE", "CNT_DM", "CNT_DU", "CNT_DNE", "QTY_M", "QTY_U", "QTY_NE", "QTY_DM", "QTY_DU", "QTY_DN", "TOT_ORD_CNT", "TOT_DEL_CNT", "TOT_ORD_QTY", "TOT_DEL_QTY", "PERCENT_CNT", "PERCENT_QTY") AS 
  with dates as
  ( select distinct trunc( eff ) shipdate
     from sim_sourcingmetric
    where category = 418
    and simulation_name='AD'
 order by trunc( eff ) asc
  )                        , match as
  (select shipdate         , count( 1 ) cnt, sum( co_qty ) qty
     from mak_cust_table pe, udt_llamasoft_data ll
    where pe.status                 in( 1, 4, 6 ) and pe.co_item like '%RU%' and pe.loc =
    ll.dest(+) and pe.assigned_plant = ll.source(+) and pe.co_item = ll.item(+)
    and ll.item                     is not null
 group by shipdate
  )                        , unmatch as
  (select shipdate         , count( 1 ) cnt, sum( co_qty ) qty
     from mak_cust_table pe, udt_llamasoft_data ll
    where pe.status               in( 1, 4, 6 ) and pe.co_item like '%RU%' and pe.loc =
    ll.dest and pe.assigned_plant <> ll.source and pe.co_item = ll.item
 group by shipdate
  )                        , notexist as
  (select shipdate         , count( 1 ) cnt, sum( co_qty ) qty
     from mak_cust_table pe, udt_llamasoft_data ll
    where pe.status                 in( 1, 4, 6 ) and pe.co_item like '%RU%' and pe.loc =
    ll.dest(+) and pe.assigned_plant = ll.source(+) and pe.co_item = ll.item(+)
    and ll.item                     is null and not exists
    (select 1
       from udt_llamasoft_data ll2
      where ll2.dest = pe.loc and ll2.item = pe.co_item
    )
 group by shipdate
  )                        , del_match as
  (select shipdate         , count( 1 ) cnt, sum( co_qty ) qty
     from mak_cust_table pe, udt_llamasoft_data ll
    where pe.status              in( 2, 3, 5 ) and pe.co_item like '%RU%' and pe.loc =
    ll.dest and pe.assigned_plant = ll.source and pe.co_item = ll.item
 group by shipdate
 order by pe.shipdate asc
  )                        , del_unmatch as
  (select shipdate         , count( 1 ) cnt, sum( co_qty ) qty
     from mak_cust_table pe, udt_llamasoft_data ll
    where pe.status               in( 2, 3, 5 ) and pe.co_item like '%RU%' and pe.loc =
    ll.dest and pe.assigned_plant <> ll.source and pe.co_item = ll.item and
    exists
    (select 1
       from udt_llamasoft_data ll2
      where ll2.dest = pe.loc and ll2.item = pe.co_item
    )
 group by shipdate
 order by pe.shipdate asc
  )               , del_notexist as
  (select shipdate, count( 1 ) cnt, sum( co_qty ) qty
     from mak_cust_table pe
    where pe.status in( 2, 3, 5 ) and pe.co_item like '%RU%' and not exists
    (select 1
       from udt_llamasoft_data ll2
      where ll2.dest = pe.loc and ll2.item = pe.co_item
    )
 group by shipdate
  )
 select dates.shipdate needarrivdate, nvl( m.cnt, 0 )
  cnt_m                                                      , nvl( u.cnt, 0 )
  cnt_u                                                      , nvl( ne.cnt, 0 )
  cnt_ne                                                     , nvl( dm.cnt, 0 )
  cnt_dm                                                     , nvl( du.cnt, 0 )
  cnt_du                                                     , nvl( dne.cnt, 0
  ) cnt_dne                                                  , nvl( m.qty, 0 )
  qty_m                                                      , nvl( u.qty, 0 )
  qty_u                                                      , nvl( ne.qty, 0 )
  qty_ne                                                     , nvl( dm.qty, 0 )
  qty_dm                                                     , nvl( du.qty, 0 )
  qty_du                                                     , nvl( dne.qty, 0
  ) qty_dn                                                   , nvl( m.cnt, 0 )
  + nvl( u.cnt, 0 ) + nvl( ne.cnt, 0 ) tot_ord_cnt           , nvl( dm.cnt, 0 )
  + nvl( du.cnt, 0 ) + nvl( dne.cnt, 0 ) tot_del_cnt         , nvl( m.qty, 0 )
  + nvl( u.qty, 0 ) + nvl( ne.qty, 0 ) tot_ord_qty           , nvl( dm.qty, 0 )
  + nvl( du.qty, 0 ) + nvl( dne.qty, 0 ) tot_del_qty         , nvl( round(
  nullif(( nvl( m.cnt, 0 ) + nvl( ne.cnt, 0 ) + nvl( dm.cnt, 0 ) + nvl( dne.cnt
  , 0 ) ), 0 ) / nullif(( nvl( m.cnt, 0 ) + nvl( u.cnt, 0 ) + nvl( ne.cnt, 0 )
  + nvl( dm.cnt, 0 ) + nvl( du.cnt, 0 ) + nvl( dne.cnt, 0 ) ), 0 ), 3 ) * 100,
  0 ) percent_cnt, nvl( round( nullif(( nvl( m.qty, 0 ) + nvl( ne.qty, 0 ) +
  nvl( dm.qty, 0 ) + nvl( dne.qty, 0 ) ), 0 ) / nullif(( nvl( m.qty, 0 ) + nvl(
  u.qty, 0 ) + nvl( ne.qty, 0 ) + nvl( dm.qty, 0 ) + nvl( du.qty, 0 ) + nvl(
  dne.qty, 0 ) ), 0 ), 3 ) * 100, 0 ) percent_qty
   from match m , unmatch u       , notexist ne, del_match dm
, del_unmatch du, del_notexist dne, dates dates
  where m.shipdate(+) = dates.shipdate and u.shipdate(+) = dates.shipdate and
  ne.shipdate(+)      = dates.shipdate and dm.shipdate(+) = dates.shipdate and
  du.shipdate(+)      = dates.shipdate and dne.shipdate(+) = dates.shipdate
  --and round((nvl(m.cnt,0) + nvl(ne.cnt,0) + nvl(dm.cnt,0) + nvl(dne.cnt,0)))
  -- <> 0
order by dates.shipdate
