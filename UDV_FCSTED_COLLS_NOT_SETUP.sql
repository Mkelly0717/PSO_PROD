--------------------------------------------------------
--  DDL for View UDV_FCSTED_COLLS_NOT_SETUP
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_FCSTED_COLLS_NOT_SETUP" ("LOC", "ITEM", "TOTAL_QTY", "CATEGORY", "DAY1_QTY", "DAY2_QTY", "DAY3_QTY", "DAY4_QTY", "DAY5_QTY", "DAY6_QTY", "DAY7_QTY", "DAY8_QTY", "DAY9_QTY", "DAY10_QTY", "DAY11_QTY", "DAY12_QTY", "DAY13_QTY", "DAY14_QTY") AS 
  SELECT skc.loc, skc.item, skc.qty total_qty, skcw.category
      ,skcw.day1_qty
      ,skcw.day2_qty      
      ,skcw.day3_qty      
      ,skcw.day4_qty
      ,skcw.day5_qty      
      ,skcw.day6_qty
      ,skcw.day7_qty      
      ,skcw.day8_qty
      ,skcw.day9_qty      
      ,skcw.day10_qty      
      ,skcw.day11_qty
      ,skcw.day12_qty      
      ,skcw.day13_qty
      ,skcw.day14_qty      
FROM
  (SELECT DISTINCT k.loc loc ,
    k.item item ,
    SUM (k.qty) qty
  FROM skuconstraint k ,
    loc l
  WHERE k.category = '10'
  AND k.qty        > 0
  AND l.loc        =k.loc
  AND l.u_area     ='NA'
  AND NOT EXISTS (
    (SELECT '1' FROM udt_fixed_coll t WHERE k.loc=t.loc
    )
  UNION
    (SELECT '1'
    FROM udt_default_zip z ,
      loc l1
    WHERE l1.loc      =k.loc
    AND l1.postalcode = z.postalcode
    ) )
  GROUP BY k.loc,
    k.item
  HAVING SUM(k.qty) >0
  ORDER BY 2 DESC
  ) skc ,
  udv_skuconstraint_wide skcw
WHERE skcw.loc=skc.loc
AND skcw.item=skc.item
AND skcw.category=10
