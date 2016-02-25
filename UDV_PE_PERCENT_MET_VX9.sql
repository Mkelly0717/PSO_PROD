--------------------------------------------------------
--  DDL for View UDV_PE_PERCENT_MET_VX9
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_PE_PERCENT_MET_VX9" ("SHIPDATE", "CO_CNT", "PA_CNT", "CO_QTY", "PA_QTY", "DEL_CNT", "PD_CNT", "DEL_QTY", "PD_QTY", "%CO_MET", "%CO_QTY_MET", "%DEL_MET", "%DELQTY_MET") AS 
  with co_orders as
  (select shipdate    , count( 1 ) cnt, sum( qty ) tot_qty
     from custorder co, loc l
    where not exists
    ( select 1 from vehicleloadline vll where vll.orderid = co.orderid
    ) and co.item like '%RU%' and l.loc = co.loc and l.u_area = 'NA'
 group by shipdate
 order by shipdate asc
  )                    , planned_orders as
  (select schedarrivdate, count( 1 ) cnt, sum( qty ) tot_qty
     from udt_planarriv_extract pe
    where pe.firmsw = 1
 group by schedarrivdate
  )                   , del_orders as
  (select shipdate    , count( 1 ) cnt, sum( qty ) tot_qty
     from custorder co, loc l
    where exists
    ( select 1 from vehicleloadline vll where vll.orderid = co.orderid
    ) and co.item like '%RU%' and l.loc = co.loc and l.u_area = 'NA'
 group by shipdate
 order by shipdate asc
  )                    , planned_del as
  (select schedarrivdate, count( 1 ) cnt, sum( qty ) tot_qty
     from udt_planarriv_extract pe
    where pe.firmsw = 2
 group by schedarrivdate
  )
 select co.shipdate shipdate                                   , nvl( co.cnt, 0 ) co_cnt    , nvl( pe.cnt, 0 ) pa_cnt,
  nvl( co.tot_qty, 0 ) co_qty                                  , nvl( pe.tot_qty, 0 ) pa_qty, do.cnt del_cnt         ,
  nvl( pd.cnt, 0 ) pd_cnt                                      , do.tot_qty del_qty         , nvl( pd.tot_qty, 0
  ) pd_qty                                                     , nvl( round( nvl( pe.cnt, 0 ) / nullif( nvl(
  co.cnt, 0 ) + nvl( pe.cnt, 0 ), 0 ), 4 ) * 100, 0 ) "%CO_MET", nvl( round(
  nvl( pe.tot_qty, 0 ) / nullif( nvl( co.tot_qty, 0 ) + nvl( pe.tot_qty, 0 ), 0
  ), 4 ) * 100, 0 ) "%CO_QTY_MET"                               , nvl( round( nvl( pd.cnt, 0 ) / nullif( nvl(
  do.cnt, 0 ) + nvl( pd.cnt, 0 ), 0 ), 4 ) * 100, 0 ) "%DEL_MET", nvl( round(
  nvl( pd.tot_qty, 0 ) / nullif( nvl( do.tot_qty, 0 ) + nvl( pd.tot_qty, 0 ), 0
  ), 4 ) * 100, 0 ) "%DELQTY_MET"
   from co_orders co, planned_orders pe, del_orders do, planned_del pd
  where co.shipdate = pe.schedarrivdate(+) and co.shipdate = do.shipdate(+) and
  co.shipdate       = pd.schedarrivdate(+) and co.shipdate >= trunc( sysdate )
order by co.shipdate asc
