  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_P1_SM_LS" ("SOURCING", "ITEM", "DEST", "SRC", "SRC_5ZIP", "DEST_5ZIP", "SRC_3ZIP", "DEST_3ZIP", "ET", "QTY", "RANK", "P1", "COST", "VALUE") AS 
  WITH src_metric (sourcing, item, dest, src,src_5zip, dest_5zip, src_3zip, dest_3zip, et, qty, rank) AS
  (
  /* Sourcing Metric Piece */
  SELECT sm.sourcing sm_sourcing ,
    sm.item sm_item ,
    sm.dest sm_dest ,
    sm.source sm_src ,
    ls.postalcode src_5zip ,
    ld.postalcode dest_5zip ,
    ls.u_3digitzip src_3zip ,
    ld.u_3digitzip dest_3zip ,
    ld.u_equipment_type eqptype ,
    ROUND(SUM(value),0) qty ,
    dense_rank() over ( partition BY item, dest order by SUM(value)DESC ) AS rank
  FROM sim_sourcingmetric sm ,
    loc ls ,
    loc ld
  WHERE sm.category=418
  AND sm.dest      =ld.loc
  AND ld.loc_type  =3
  AND sm.source    =ls.loc
  and ls.u_area='NA'
  and ld.u_area='NA'
  and sm.simulation_name='AD'
  GROUP BY sm.sourcing ,
    sm.item ,
    sm.dest ,
    sm.source ,
    ls.postalcode ,
    ld.postalcode ,
    ld.u_3digitzip ,
    ls.u_3digitzip ,
    ld.u_equipment_type
  ORDER BY item ,
    dest ,
    rank ASC ,
    ld.postalcode
  )
SELECT sm.sourcing ,
  sm.item ,
  sm.dest ,
  sm.src ,
  sm.src_5zip ,
  sm.dest_5zip ,
  sm.src_3zip ,
  sm.dest_3zip ,
  sm.et ,
  sm.qty ,
  sm.rank ,
  ls.priority p1 ,
  ctier.cost ,
  ctier.value
FROM src_metric sm ,
  udt_llamasoft_data ls ,
  costtier ctier
WHERE sm.src   =ls.source(+)
AND sm.dest    =ls.dest(+)
AND sm.item    =ls.item(+)
AND sm.et      =ls.u_equipment_type(+)
AND ctier.cost = sm.sourcing
  || '_'
  || sm.src
  || '->'
  || sm.dest
  || '-202'
ORDER BY sm.item ,
  sm.dest ,
  sm.rank
