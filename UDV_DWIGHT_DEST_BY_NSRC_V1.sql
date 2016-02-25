  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_DWIGHT_DEST_BY_NSRC_V1" ("DEST", "ITEM", "NSOURCES", "QTY_RECIEVED") AS 
  select dest
      , item
      , count( unique source ) nsources
      , round(sum(value)) qty_recieved
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
    group by dest
      , item
    order by dest asc
      , item asc
