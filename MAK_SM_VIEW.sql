--------------------------------------------------------
--  DDL for View MAK_SM_VIEW
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_SM_VIEW" ("RECNUM", "SOURCING", "ITEM", "DEST", "SOURCE", "EFF", "SM_TOTQTY", "CUST_TOTQTY", "DIFF_SM_ALL", "ORDER_QTY", "VLL_QTY", "REMAINDER", "VLLQTY_PROCESSED", "COQTY_PROCESSED", "DUR", "CATEGORY", "QTYUOM", "LOC_TYPE_SRC", "LOC_TYPE_DEST") AS 
  select rownum recnum           , sm.sourcing                                 , sm.item item                  , sm.dest dest
  , sm.source source              , sm.eff eff                                  , round( sm.value, 2 ) sm_totqty,
    cust.tot_qty cust_totqty      , round( sm.value - cust.tot_qty ) diff_sm_all,
    cust.order_qty                , cust.vll_qty                                ,
    round( sm.value, 2 ) remainder, 0 vllqty_processed                          ,
    0 coqty_processed             , sm.dur dur                                  ,
    sm.category category          , sm.qtyuom qtyuom                            ,
    ls.loc_type loc_type_src      , ld.loc_type loc_type_dest
     from sim_sourcingmetric sm       , loc ls       , loc ld          ,(select allo.item
    , allo.loc                    , allo.shipdate, allo.qty tot_qty, nvl(
      oo.qty, 0 ) order_qty       , nvl( allo.qty - oo.qty, 0 ) vll_qty
       from
      (select co.item, co.loc, co.shipdate, sum( co.qty ) qty
         from custorder co, loc l
         where l.loc=co.loc
           and l.u_area='NA'
     group by co.item, co.loc, co.shipdate
      ) allo      ,(select co.item, co.loc, co.shipdate
      , sum( qty ) qty
         from custorder co, loc l
        where not exists
        ( select 1 from vehicleloadline vll where vll.orderid = co.orderid
        )
        and l.loc=co.loc
        and l.u_area='NA'
     group by co.item, co.loc, co.shipdate
      ) oo
      where allo.item = oo.item(+) and allo.loc = oo.loc(+) and allo.shipdate =
      oo.shipdate(+)
   order by allo.shipdate asc
    ) cust
    where sm.item like '%RU%' and ls.loc = sm.source and ls.u_area = 'NA' and
    ld.loc                               = sm.dest and ld.u_area = 'NA' and
    exists
    ( select 1 from custorder co, loc l where l.loc=co.loc and l.u_area='NA' and co.loc = sm.dest
    ) and sm.dest    = cust.loc and sm.item = cust.item and sm.eff = cust.shipdate
    and sm.category in( 418 )
    and sm.simulation_name='AD'
    --  AND sm.qtyuom    =18
