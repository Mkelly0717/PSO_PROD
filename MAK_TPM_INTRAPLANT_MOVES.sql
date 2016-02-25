--------------------------------------------------------
--  DDL for View MAK_TPM_INTRAPLANT_MOVES
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_TPM_INTRAPLANT_MOVES" ("SOURCING", "ITEM", "SOURCE", "DEST", "SUM_QTY") AS 
  SELECT sourcing,
    item,
    source,
    dest,
    ROUND(SUM(value),0) SUM_QTY
  FROM sim_sourcingmetric sm
  WHERE EXISTS
    (SELECT 1
    FROM udt_tpm_plant_pairs pp
    WHERE pp.source=sm.source
    AND pp.dest    =sm.dest
    )
    AND category=418
    and sm.simulation_name='AD'
  GROUP BY sourcing,
    item,
    source,
    dest
