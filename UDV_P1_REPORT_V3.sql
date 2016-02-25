  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_P1_REPORT_V3" ("RDATE", "SM_DEST", "SM_ITEM", "SM_RANK", "SM_VALUE", "CT_RANK", "CT_COST", "LS_PRIORITY", "SM_SRC", "CT_SOURCE_PC", "CT_DEST_PC", "SM_SOURCING", "CT_ET", "CT_DIR", "CT_TLT", "LS_TLT", "LS_EQPTYPE") AS 
  WITH src_metric (sourcing, item, dest, src, qty, rank) AS
  (
  /* Sourcing Metric Piece */
  SELECT sm.sourcing ,
    sm.item ,
    sm.dest ,
    sm.source ,
    ROUND(SUM(value),0) qty ,
    dense_rank() over ( partition BY item, dest order by SUM(value)DESC ) AS rank
  FROM sim_sourcingmetric sm ,
    loc l
  WHERE sm.category=418
  AND sm.dest      =l.loc
  AND sourcing NOT LIKE '%DEL%'
  AND l.loc_type=3
  AND l.u_area  ='NA'
  and sm.simulation_name='AD'
  GROUP BY sm.sourcing ,
    sm.item ,
    sm.dest ,
    sm.source
  ORDER BY dest ,
    item ,
    rank ASC
  ) ,
  cost_transit AS
  (
  /* Cost transit Piece */
  SELECT direction ,
    dest_pc ,
    source_pc ,
    cost_pallet ,
    u_equipment_type ,
    transittime ,
    dense_rank() over (partition BY direction, u_equipment_type, dest_pc order by cost_pallet ASC) rank
  FROM udt_cost_transit_na
  WHERE trim(source_pc) IS NOT NULL
  ORDER BY direction ,
    u_equipment_type ,
    dest_pc ,
    cost_pallet ASC
  ) ,
  llamasoft AS
  (SELECT item ,
    source ,
    source_pc ,
    dest ,
    dest_pc ,
    transleadtime ,
    priority ,
    u_equipment_type
  FROM udt_llamasoft_data
  )
SELECT sysdate rdate ,
  sm.dest sm_dest ,
  sm.item sm_item ,
  sm.rank sm_rank ,
  sm.qty sm_value ,
  ct.rank ct_rank ,
  ct.cost_pallet ct_cost ,
  CASE
    WHEN llama.source=sm.src
    THEN llama.priority
    ELSE NULL
  END ls_priority ,
  sm.src sm_src ,
  ct.source_pc ct_source_pc ,
  ct.dest_pc ct_dest_pc ,
  sm.sourcing sm_sourcing ,
  ct.u_equipment_type ct_et ,
  ct.direction ct_dir ,
  ct.transittime ct_tlt ,
  CASE
    WHEN llama.source=sm.src
    THEN llama.transleadtime
    ELSE NULL
  END ls_tlt ,
  CASE
    WHEN llama.source=sm.src
    THEN llama.u_equipment_type
    ELSE NULL
  END ls_eqptype
FROM cost_transit ct ,
  src_metric sm ,
  loc ls ,
  loc ld ,
  llamasoft llama
WHERE sm.dest          =ld.loc
AND sm.src             =ls.loc
AND ld.u_equipment_type=ct.u_equipment_type
AND ls.postalcode      = ct.source_pc
AND ld.postalcode      = ct.dest_pc
AND llama.item         =sm.item
AND llama.dest         =sm.dest
and exists ( select 1 from llamasoft llama2 where llama.item=sm.item and llama2.dest=sm.dest)
ORDER BY sysdate ASC ,
  sm_rank ASC
