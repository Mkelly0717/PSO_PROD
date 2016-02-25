--------------------------------------------------------
--  DDL for View MAK_TMP1TST
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_TMP1TST" ("ITEM", "DEST", "SOURCE") AS 
  SELECT DISTINCT lanes.item,
  lanes.dest,
  lanes.source 
FROM sourcing src,
  /*********************************************************************
  ** Getting All Lanes: item, dest, dest_pc, source, source_pc max_dist
  ** ,max_src, dist and  cost(999 if null)
  **********************************************************************/
(   SELECT direction ,
      u_equipment_type u_equipment_type ,
      SUBSTR(source_pc, 1, 5) source_pc ,
      source_geo source_geo ,
      SUBSTR(dest_pc, 1, 5) dest_pc ,
      dest_geo dest_geo ,
      source_co ,
      distance distance ,
      cost_pallet cost_pallet
    FROM udt_cost_transit_na
    ORDER BY direction,
      u_equipment_type,
      source_pc,
      dest_pc,
      source_geo,
      dest_geo
    ) lane_cost,
    ( SELECT DISTINCT llama.item item ,
      llama.dest dest,
      llama.source source,
      DECODE(ld.u_equipment_type,'FB','FB','VN') u_equipment_type,
      ls.postalcode source_pc,
      ld.postalcode dest_pc
    FROM skuconstraint sku ,
      udt_llamasoft_data llama,
      loc ls,
      loc ld
    WHERE sku.category IN (1,6)
    AND sku.loc         =llama.dest
    AND sku.item        =llama.item
    AND ld.loc          =sku.loc
    AND ld.loc_type     = 3
    AND ld.u_area       ='NA'
    AND sku.eff BETWEEN TRUNC(sysdate) AND TRUNC(sysdate) + 14
      --and sku.eff between u_14d_begin_skuconstraint and u_14d_end_skuconstraint
    AND sku.qty                > 0
    AND ls.loc                 =llama.source
    AND ls.loc_type           IN (1,2,4)
    AND trim(ld.postalcode )  IS NOT NULL
    AND trim(ld.u_3digitzip ) IS NOT NULL
    AND trim(ls.postalcode )  IS NOT NULL
    AND trim(ls.u_3digitzip ) IS NOT NULL
    ) lanes
where lane_cost.source_pc=lanes.source_pc
and   lane_cost.dest_pc=lanes.dest_pc
and   lane_cost.u_equipment_type=lanes.u_equipment_type
and src.source(+)=lanes.source
and src.dest(+)=lanes.dest
and src.item(+)=lanes.item
and src.item(+) is null
