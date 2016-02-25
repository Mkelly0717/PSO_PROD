--------------------------------------------------------
--  DDL for View UDV_LANE_QTY_CALCULATION
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_LANE_QTY_CALCULATION" ("SOURCE", "LOC", "ITEM", "EFF", "RES", "PERCEN", "QTY", "LANE_QTY") AS 
  SELECT r.source,
    r.loc,
    skc.item,
    skc.eff,
    r.res,
    fc.percen,
    skc.qty,
    fc.percen * skc.qty lane_qty
  FROM res r,
    udt_fixed_coll fc,
    skuconstraint skc,
    item i
  WHERE res LIKE 'COLL0FIXED%->%'
  AND TYPE         = 5
  AND r.source     = fc.loc
  AND r.loc        = fc.plant
  AND fc.percen    < 1
  AND skc.loc      = r.source
  AND skc.category = 10
  AND i.item       = skc.item
  AND i.u_stock    = 'A'
  AND i.enablesw   = 1
  ORDER BY r.source,
    r.loc,
    skc.eff
