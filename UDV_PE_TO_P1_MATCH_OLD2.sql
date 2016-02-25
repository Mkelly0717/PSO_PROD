--------------------------------------------------------
--  DDL for View UDV_PE_TO_P1_MATCH_OLD2
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_PE_TO_P1_MATCH_OLD2" ("SCHEDSHIPDATE", "CNT_M", "CNT_U", "CNT_NE", "CNT_DM", "CNT_DU", "CNT_DNE", "QTY_M", "QTY_U", "QTY_NE", "QTY_DM", "QTY_DU", "QTY_DN", "TOT_ORD_CNT", "TOT_DEL_CNT", "TOT_ORD_QTY", "TOT_DEL_QTY", "PERCENT_CNT", "PERCENT_QTY") AS 
  with dates as
  ( select distinct TRUNC( EFF ) SCHEDSHIPDATE
     from sim_sourcingmetric sm
    where category = 418
	and sm.simulation_name='AD'
 order by trunc( eff ) asc
  ), match as
  (select schedshipdate, count( 1 ) cnt, sum( qty ) qty
     from udt_planarriv_extract pe, udt_llamasoft_data ll
    where pe.firmsw = 1 and pe.item like '%RU%' and pe.dest = ll.dest(+) and
    pe.source       = ll.source(+) and pe.item = ll.item(+) and ll.item is not
    null
 group by schedshipdate
  ), unmatch as
  (
  select schedshipdate, count( 1 ) cnt, sum( qty ) qty
   from udt_planarriv_extract pe, udt_llamasoft_data ll
  where pe.firmsw = 1 
    and pe.item like '%RU%' 
    and pe.dest = ll.dest 
    and pe.source<> ll.source 
    and pe.item = ll.item
 group by schedshipdate
  ), notexist as
  (select schedshipdate, count( 1 ) cnt, sum( qty ) qty
     from udt_planarriv_extract pe, udt_llamasoft_data ll
    where pe.firmsw = 1 and pe.item like '%RU%' and pe.dest = ll.dest(+) and
    pe.source       = ll.source(+) and pe.item = ll.item(+) and ll.item is null
    and not exists
    (select 1
       from udt_llamasoft_data ll2
      where ll2.dest = pe.dest and ll2.item = pe.item
    )
 group by schedshipdate
  ), del_match as
  (select schedshipdate, count( 1 ) cnt, sum( qty ) qty
     from udt_planarriv_extract pe, udt_llamasoft_data ll
    where pe.firmsw = 2 and pe.item like '%RU%' and pe.dest = ll.dest(+) and
    pe.source       = ll.source(+) and pe.item = ll.item(+) and ll.item is not
    null
 group by schedshipdate
  ), del_unmatch as
  (select schedshipdate, count( 1 ) cnt, sum( qty ) qty
     from udt_planarriv_extract pe, udt_llamasoft_data ll
    where pe.firmsw = 2 and pe.item like '%RU%' and pe.dest = ll.dest(+) and
    pe.source       = ll.source(+) and pe.item = ll.item(+) and ll.item is null
    and exists
    (select 1
       from udt_llamasoft_data ll2
      where ll2.dest = pe.dest and ll2.item = pe.item
    )
 group by schedshipdate
  ), del_notexist as
  (select schedshipdate, count( 1 ) cnt, sum( qty ) qty
     from udt_planarriv_extract pe, udt_llamasoft_data ll
    where pe.firmsw = 2 and pe.item like '%RU%' and pe.dest = ll.dest(+) and
    pe.source       = ll.source(+) and pe.item = ll.item(+) and ll.item is null
    and not exists
    (select 1
       from udt_llamasoft_data ll2
      where ll2.dest = pe.dest and ll2.item = pe.item
    )
 group by schedshipdate
  )
 select dates.schedshipdate, nvl( m.cnt, 0 ) cnt_m, nvl( u.cnt, 0 ) cnt_u, nvl(
  ne.cnt, 0 ) cnt_ne, nvl( dm.cnt, 0 ) cnt_dm, nvl( du.cnt, 0 ) cnt_du, nvl(
  dne.cnt, 0 ) cnt_dne, nvl( m.qty, 0 ) qty_m, nvl( u.qty, 0 ) qty_u, nvl(
  ne.qty, 0 ) qty_ne, nvl( dm.qty, 0 ) qty_dm, nvl( du.qty, 0 ) qty_du, nvl(
  dne.qty, 0 ) qty_dn, nvl( m.cnt, 0 ) + nvl( u.cnt, 0 ) + nvl( ne.cnt, 0 )
  tot_ord_cnt, nvl( dm.cnt, 0 ) + nvl( du.cnt, 0 ) + nvl( dne.cnt, 0 )
  tot_del_cnt, nvl( m.qty, 0 ) + nvl( u.qty, 0 ) + nvl( ne.qty, 0 ) tot_ord_qty
  , nvl( dm.qty, 0 ) + nvl( du.qty, 0 ) + nvl( dne.qty, 0 ) tot_del_qty, nvl(
  round( nullif(( nvl( m.cnt, 0 ) + nvl( ne.cnt, 0 ) + nvl( dm.cnt, 0 ) + nvl(
  dne.cnt, 0 ) ), 0 ) / nullif(( nvl( m.cnt, 0 ) + nvl( u.cnt, 0 ) + nvl(
  ne.cnt, 0 ) + nvl( dm.cnt, 0 ) + nvl( du.cnt, 0 ) + nvl( dne.cnt, 0 ) ), 0 ),
  3 ) * 100, 0 ) percent_cnt, nvl( round( nullif(( nvl( m.qty, 0 ) + nvl(
  ne.qty, 0 ) + nvl( dm.qty, 0 ) + nvl( dne.qty, 0 ) ), 0 ) / nullif(( nvl(
  m.qty, 0 ) + nvl( u.qty, 0 ) + nvl( ne.qty, 0 ) + nvl( dm.qty, 0 ) + nvl(
  du.qty, 0 ) + nvl( dne.qty, 0 ) ), 0 ), 3 ) * 100, 0 ) percent_qty
   from match m, unmatch u, notexist ne, del_match dm, del_unmatch du,
  del_notexist dne, dates dates
  where m.schedshipdate(+)                    = dates.schedshipdate and u.schedshipdate(+) =
  dates.schedshipdate and ne.schedshipdate(+) = dates.schedshipdate and
  dm.schedshipdate(+)                         = dates.schedshipdate and
  du.schedshipdate(+)                         = dates.schedshipdate and
  dne.schedshipdate(+)                        = dates.schedshipdate
  --and round((nvl(m.cnt,0) + nvl(ne.cnt,0) + nvl(dm.cnt,0) + nvl(dne.cnt,0)))
  -- <> 0
order by dates.schedshipdate
