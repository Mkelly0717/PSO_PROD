  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_MET_DEMAND_UNMET_DEMAND" ("SM_SOURCE", "SM_ITEM", "SM_NDESTS", "SM_QTY_SHIPPED", "SRC_NDESTS", "DEMAND_QTY") AS 
  with shipped ( sm_source, sm_item, sm_ndests, sm_qty_shipped) as
    (select source
      , item
      , count( unique dest ) ndests
      , round(sum(value)) qty_shipped
    from sim_sourcingmetric sm
      , loc l
      , loc l1
    where sm.category=418
        and sm.value > 0
        and sm.source=l.loc
        and l.loc_type in (1,2,4,5)
        and sm.dest=l1.loc
        and l1.loc_type=3
		and sm.simulation_name='AD'
    group by source
      , item
    order by source asc
      , item asc
    )
  , src (src_source, src_item, src_ndests ) as
    (select src.source
      , src.item
      , count( unique src.dest) src_ndests
    from shipped shipped
      , sourcing src
      , loc l
    where shipped.sm_source=src.source
        and shipped.sm_item=src.item
        and src.dest=l.loc
        and l.loc_type=3
    group by src.source
      , src.item
    order by source asc
      , item asc
    )
  , src_list (srcl_source, srcl_item, srcl_dest) as
    (select src.source
      , src.item
      , src.dest
    from shipped shipped
      , sourcing src
      , loc l
    where shipped.sm_source=src.source
        and shipped.sm_item=src.item
        and src.dest=l.loc
        and l.loc_type=3
    order by source asc
      , item asc
    )
  , demand_total (srcl_source, srcl_item, demand_qty) as
    (select srcl.srcl_source
      , srcl.srcl_item
      , trunc(sum(skc.qty)) demand_qty
    from src_list srcl
      , skuconstraint skc
    where skc.loc=srcl.srcl_dest
        and skc.category=1
    group by srcl.srcl_source
      , srcl.srcl_item
    )
select sm_source
  , sm_item
  , sm_ndests
  , sm_qty_shipped
  , src_ndests
  , demand_qty
from src src
  , shipped shp
  , demand_total dt
where src.src_source=shp.sm_source
    and src_item=sm_item
    and dt.srcl_source=src.src_source
    and dt.srcl_item = src.src_item
order by sm_source asc
  , sm_item asc
