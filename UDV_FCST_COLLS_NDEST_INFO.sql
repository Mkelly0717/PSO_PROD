--------------------------------------------------------
--  DDL for View UDV_FCST_COLLS_NDEST_INFO
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_FCST_COLLS_NDEST_INFO" ("ITEM", "LOC", "TOTALDEMAND", "TOTALDEST") AS 
  with total_collection ( item, loc, totaldemand) as
    (select skc.item
      ,skc.loc
      ,round(sum(skc.qty),1) as totaldemand
    from skuconstraint skc
    where skc.category=10
        and skc.qty > 0
    group by skc.item
      , skc.loc
    )
  , total_dest (item, loc, totaldest) as
    (select skc1.item
      , skc1.loc
      , nvl(count(1),0)
    from sourcing src
      , total_collection skc1
    where skc1.item=src.item(+)
        and skc1.loc=src.source(+)
        and src.item is not null
    group by skc1.item
      , skc1.loc
    union
    select skc1.item
      , skc1.loc
      ,0
    from sourcing src
      , total_collection skc1
    where skc1.item=src.item(+)
        and skc1.loc=src.source(+)
        and src.item is null
    )
select tc.item
  , tc.loc
  , tc.totaldemand
  , ts.totaldest
from total_collection tc
  , total_dest ts
where tc.item=ts.item
    and tc.loc=ts.loc
