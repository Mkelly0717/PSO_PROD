--------------------------------------------------------
--  DDL for View UDV_SKUCONSTRAINT_WIDE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_SKUCONSTRAINT_WIDE" ("ITEM", "LOC", "CATEGORY", "DUR", "POLICY", "QTYUOM", "DAY1_QTY", "DAY2_QTY", "DAY3_QTY", "DAY4_QTY", "DAY5_QTY", "DAY6_QTY", "DAY7_QTY", "DAY8_QTY", "DAY9_QTY", "DAY10_QTY", "DAY11_QTY", "DAY12_QTY", "DAY13_QTY", "DAY14_QTY", "RANK") AS 
  WITH ranked_SKC AS
  (SELECT k.item,
    k.loc,
    k.category,
    k.dur,
    k.policy,
    k.qtyuom ,
    lead (ROUND(k.qty,2), 0,0 ) over (partition BY k.item, k.loc order by k.item, k.loc, k.eff)  AS DAY1_qty ,
    lead (ROUND(k.qty,2), 1,0 ) over (partition BY k.item, k.loc order by k.item, k.loc, k.eff)  AS DAY2_qty ,
    lead (ROUND(k.qty,2), 2,0 ) over (partition BY k.item, k.loc order by k.item, k.loc, k.eff)  AS DAY3_qty ,
    lead (ROUND(k.qty,2), 3,0 ) over (partition BY k.item, k.loc order by k.item, k.loc, k.eff)  AS DAY4_qty ,
    lead (ROUND(k.qty,2), 4,0 ) over (partition BY k.item, k.loc order by k.item, k.loc, k.eff)  AS DAY5_qty ,
    lead (ROUND(k.qty,2), 5,0 ) over (partition BY k.item, k.loc order by k.item, k.loc, k.eff)  AS DAY6_qty ,
    lead (ROUND(k.qty,2), 6,0 ) over (partition BY k.item, k.loc order by k.item, k.loc, k.eff)  AS DAY7_qty ,
    lead (ROUND(k.qty,2), 7,0 ) over (partition BY k.item, k.loc order by k.item, k.loc, k.eff)  AS DAY8_qty ,
    lead (ROUND(k.qty,2), 8,0 ) over (partition BY k.item, k.loc order by k.item, k.loc, k.eff)  AS DAY9_qty ,
    lead (ROUND(k.qty,2), 9,0 ) over (partition BY k.item, k.loc order by k.item, k.loc, k.eff)  AS DAY10_qty ,
    lead (ROUND(k.qty,2), 10,0 ) over (partition BY k.item, k.loc order by k.item, k.loc, k.eff) AS DAY11_qty ,
    lead (ROUND(k.qty,2), 11,0 ) over (partition BY k.item, k.loc order by k.item, k.loc, k.eff) AS DAY12_qty ,
    lead (ROUND(k.qty,2), 12,0 ) over (partition BY k.item, k.loc order by k.item, k.loc, k.eff) AS DAY13_qty ,
    lead (ROUND(k.qty,2), 13,0 ) over (partition BY k.item, k.loc order by k.item, k.loc, k.eff) AS DAY14_qty ,
    row_number() over (partition BY k.item, k.loc order by k.eff ASC)                            AS rank
  FROM udt_skuconstraint_temp k ,
    loc l
  WHERE k.category IN (1,6,10)
  AND l.loc         =k.loc
  AND l.u_area      ='NA'
  )
SELECT "ITEM",
  "LOC",
  "CATEGORY",
  "DUR",
  "POLICY",
  "QTYUOM",
  "DAY1_QTY",
  "DAY2_QTY",
  "DAY3_QTY",
  "DAY4_QTY",
  "DAY5_QTY",
  "DAY6_QTY",
  "DAY7_QTY",
  "DAY8_QTY",
  "DAY9_QTY",
  "DAY10_QTY",
  "DAY11_QTY",
  "DAY12_QTY",
  "DAY13_QTY",
  "DAY14_QTY",
  "RANK"
FROM ranked_skc
WHERE rank=1
order by 1,2,3
