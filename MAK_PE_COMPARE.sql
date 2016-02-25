--------------------------------------------------------
--  DDL for View MAK_PE_COMPARE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_PE_COMPARE" ("NEEDARRIVDATE", "CNT->", "CNT_M", "CNT_U", "CNT_NE", "CNT_DM", "CNT_DU", "CNT_DNE", "QTY->", "QTY_M", "QTY_U", "QTY_NE", "QTY_DM", "QTY_DU", "QTY_DN", "TOTALS->  ", "TOT_ORD_CNT", "TOT_DEL_CNT", "TOT_ORD_QTY", "TOT_DEL_QTY", "Percent->", "PERCENT_CNT", "PERCENT_QTY", "MET INFO=>", "CO_CNT", "PA_CNT", "CO_QTY", "PA_QTY", "DEL_CNT", "PD_CNT", "DEL_QTY", "PD_QTY", "%MET INFO=>", "%CO_MET", "%CO_QTY_MET", "%DEL_MET", "%DELQTY_MET") AS 
  with dates as
  ( select distinct trunc( eff ) shipdate
     from sim_sourcingmetric 
    where category = 418
    and simulation_name='AD'
 order by trunc( eff ) asc
  )                        , match as
  (select shipdate         , count( 1 ) cnt, sum( co_qty ) qty
     from mak_cust_table pe, udt_llamasoft_data ll
    where pe.status   in (1,4) and pe.co_item like '%RU%' and pe.loc = ll.dest(+) and
    pe.assigned_plant = ll.source(+) and pe.co_item = ll.item(+) and ll.item is
    not null
 group by shipdate
  )                        , unmatch as
  (select shipdate         , count( 1 ) cnt, sum( co_qty ) qty
     from mak_cust_table pe, udt_llamasoft_data ll
    where pe.status    in ( 1, 4) and pe.co_item like '%RU%' and pe.loc = ll.dest and
    pe.assigned_plant <> ll.source and pe.co_item = ll.item
 group by shipdate
  )                        , notexist as
  (select shipdate         , count( 1 ) cnt, sum( co_qty ) qty
     from mak_cust_table pe, udt_llamasoft_data ll
    where pe.status   in (1,4) and pe.co_item like '%RU%' and pe.loc = ll.dest(+) and
    pe.assigned_plant = ll.source(+) and pe.co_item = ll.item(+) and ll.item is
    null and not exists
    (select 1
       from udt_llamasoft_data ll2
      where ll2.dest = pe.loc and ll2.item = pe.co_item
    )
 group by shipdate
  )                        , del_match as
  (select shipdate         , count( 1 ) cnt, sum( co_qty ) qty
     from mak_cust_table pe, udt_llamasoft_data ll
    where pe.status   in ( 2, 3) and pe.co_item like '%RU%' and pe.loc = ll.dest(+) and
    pe.assigned_plant = ll.source(+) and pe.co_item = ll.item(+) and ll.item is
    not null
 group by shipdate
  )                        , del_unmatch as
  (select shipdate         , count( 1 ) cnt, sum( co_qty ) qty
     from mak_cust_table pe, udt_llamasoft_data ll
    where pe.status   in ( 2, 3) and pe.co_item like '%RU%' and pe.loc = ll.dest(+) and
    pe.assigned_plant = ll.source(+) and pe.co_item = ll.item(+) and ll.item is
    null and exists
    (select 1
       from udt_llamasoft_data ll2
      where ll2.dest = pe.loc and ll2.item = pe.co_item
    )
 group by shipdate
  )                        , del_notexist as
  (select shipdate         , count( 1 ) cnt, sum( co_qty ) qty
     from mak_cust_table pe, udt_llamasoft_data ll
    where pe.status   in (2,3) and pe.co_item like '%RU%' and pe.loc = ll.dest(+) and
    pe.assigned_plant = ll.source(+) and pe.co_item = ll.item(+) and ll.item is
    null and not exists
    (select 1
       from udt_llamasoft_data ll2
      where ll2.dest = pe.loc and ll2.item = pe.co_item
    )
 group by shipdate
  )                   , co_orders as
  (select shipdate    , count( 1 ) cnt, sum( qty ) tot_qty
     from custorder co, loc l
    where l.loc = co.loc and l.u_area = 'NA' and not exists
    ( select 1 from vehicleloadline vll where vll.orderid = co.orderid
    ) and co.item like '%RU%'
 group by shipdate
 order by shipdate asc
  )               , planned_orders as
  (select shipdate, count( 1 ) cnt, sum( co_qty ) tot_qty
     from mak_cust_table pe
    where pe.status in (1,4)
 group by shipdate
  )                   , del_orders as
  (select shipdate    , count( 1 ) cnt, sum( qty ) tot_qty
     from custorder co, loc l
    where exists
    ( select 1 from vehicleloadline vll where vll.orderid = co.orderid
    ) and co.item like '%RU%' and l.loc = co.loc and l.u_area = 'NA'
 group by shipdate
 order by shipdate asc
  )               , planned_del as
  (select shipdate, count( 1 ) cnt, sum( co_qty ) tot_qty
     from mak_cust_table pe
    where pe.status in (2,3)
 group by shipdate
  )
 select dates.shipdate needarrivdate, null "CNT->"            , nvl( m.cnt, 0 ) cnt_m, nvl(
  u.cnt, 0 ) cnt_u                  , nvl( ne.cnt, 0 ) cnt_ne , nvl( dm.cnt, 0 )
  cnt_dm                            , nvl( du.cnt, 0 ) cnt_du , nvl( dne.cnt, 0
  ) cnt_dne                         , null "QTY->"            , nvl( m.qty, 0 )
  qty_m                             , nvl( u.qty, 0 ) qty_u   , nvl( ne.qty, 0 )
  qty_ne                            , nvl( dm.qty, 0 ) qty_dm , nvl( du.qty, 0 )
  qty_du                            , nvl( dne.qty, 0 ) qty_dn, null
  "TOTALS->  "                      , nvl( m.cnt, 0 ) + nvl( u.cnt, 0 ) + nvl(
  ne.cnt, 0 ) tot_ord_cnt           , nvl( dm.cnt, 0 ) + nvl( du.cnt, 0 ) + nvl
  ( dne.cnt, 0 ) tot_del_cnt        , nvl( m.qty, 0 ) + nvl( u.qty, 0 ) + nvl(
  ne.qty, 0 ) tot_ord_qty           , nvl( dm.qty, 0 ) + nvl( du.qty, 0 ) + nvl
  ( dne.qty, 0 ) tot_del_qty        , null "Percent->", nvl( round( nullif((
  nvl( m.cnt, 0 ) + nvl( ne.cnt, 0 ) + nvl( dm.cnt, 0 ) + nvl( dne.cnt, 0 ) ),
  0 ) / nullif(( nvl( m.cnt, 0 ) + nvl( u.cnt, 0 ) + nvl( ne.cnt, 0 ) + nvl(
  dm.cnt, 0 ) + nvl( du.cnt, 0 ) + nvl( dne.cnt, 0 ) ), 0 ), 3 ) * 100, 0 )
  percent_cnt, nvl( round( nullif(( nvl( m.qty, 0 ) + nvl( ne.qty, 0 ) + nvl(
  dm.qty, 0 ) + nvl( dne.qty, 0 ) ), 0 ) / nullif(( nvl( m.qty, 0 ) + nvl(
  u.qty, 0 ) + nvl( ne.qty, 0 ) + nvl( dm.qty, 0 ) + nvl( du.qty, 0 ) + nvl(
  dne.qty, 0 ) ), 0 ), 3 ) * 100, 0 ) percent_qty          , null "MET INFO=>"          , nvl(
  co.cnt, 0 ) co_cnt                                       , nvl( pe.cnt, 0 ) pa_cnt    , nvl
  ( co.tot_qty, 0 ) co_qty                                 , nvl( pe.tot_qty, 0 ) pa_qty,
  nvl( do.cnt, 0 ) del_cnt                                 , nvl( pd.cnt, 0 ) pd_cnt    ,
  nvl( do.tot_qty, 0 ) del_qty                             , nvl( pd.tot_qty, 0 ) pd_qty,
  null "%MET INFO=>"                                       , nvl( round( nvl( pe.cnt, 0 )
  / nullif( nvl( co.cnt, 0 ), 0 ), 4 ) * 100, 0 ) "%CO_MET", nvl( round( nvl(
  pe.tot_qty, 0 ) / nullif( nvl( co.tot_qty, 0 ), 0 ), 4 ) * 100, 0 )
  "%CO_QTY_MET"            , nvl( round( nvl( pd.cnt, 0 ) / nullif( nvl( do.cnt, 0 ), 0 ),
  4 ) * 100, 0 ) "%DEL_MET", nvl( round( nvl( pd.tot_qty, 0 ) / nullif( nvl(
  do.tot_qty, 0 ), 0 ), 4 ) * 100, 0 ) "%DELQTY_MET"
   from match m , unmatch u       , notexist ne , del_match dm
, del_unmatch du, del_notexist dne, co_orders co, planned_orders pe
, del_orders do , planned_del pd  , dates dates
  where m.shipdate(+) = dates.shipdate and u.shipdate(+) = dates.shipdate and
  ne.shipdate(+)      = dates.shipdate and dm.shipdate(+) = dates.shipdate and
  du.shipdate(+)      = dates.shipdate and dne.shipdate(+) = dates.shipdate and
  co.shipdate         = dates.shipdate and pe.shipdate(+) = dates.shipdate and
  do.shipdate(+)      = dates.shipdate and pd.shipdate(+) = dates.shipdate
  --and round((nvl(m.cnt,0) + nvl(ne.cnt,0) + nvl(dm.cnt,0) + nvl(dne.cnt,0)))
  -- <> 0
order by dates.shipdate
