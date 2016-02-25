--------------------------------------------------------
--  DDL for View UDV_IGPERROR_HIST
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_IGPERROR_HIST" ("RUN_DATE", "BOM", "CAL", "CALDATA", "COST", "COSTTIER", "CUSTORDER", "LOC", "PRODMETHOD", "PRODUCTIONSTEP", "PRODYIELD", "RES", "RESCONSTRAINT", "RESCOST", "RESPENALTY", "SKU", "SKUDEMANDPARAM", "SKUDEPLOYPARAM", "SKUSSPARAM", "SKUPLANNPARAM", "SKUPENALTY", "SOURCING", "sourcingmetric", "STORAGEREQ", "VEHICLELOADLINE") AS 
  select to_char(run_date,'MM-DD-YY HH:MI:SS') as run_date
      , bom
      , cal
      , caldata
      , cost
      , costtier
      , custorder
      , loc
      , prodmethod
      , productionstep
      , prodyield
      , res
      , resconstraint
      , rescost
      , respenalty
      , sku
      , skudemandparam
      , skudeployparam
      , skussparam
      , skuplannparam
      , skupenalty
      , sourcing
      , sourcingmetric
      , storagereq
      , vehicleloadline
    from udt_igperror_hist
    order by run_date desc
