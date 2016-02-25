--------------------------------------------------------
--  DDL for View UDV_SKUCONSTR_NO_3DIGIT_COLL
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_SKUCONSTR_NO_3DIGIT_COLL" ("ITEM", "LOC", "TOTALCOLLECTION", "3DigitZip", "U_EQUIPMENT_TYPE") AS 
  WITH total_collection ( item, loc, totalcollection) AS
  (SELECT skc.item ,
    skc.loc ,
    round(sum(skc.qty),1) as totalcollection
  FROM skuconstraint skc, loc l
  WHERE skc.category=10
  and skc.qty       > 0
  and l.loc=skc.loc
  and l.u_area='NA'
  GROUP BY skc.item ,
    skc.loc
  )
SELECT tc.item ,
  tc.loc ,
  tc.totalcollection ,
  l.u_3digitzip "3DigitZip" ,
  l.u_equipment_type
FROM total_collection tc ,
  loc l ,
  udt_cost_transit_na ct
WHERE tc.loc       =l.loc
and l.u_3digitzip  =ct.source_geo(+)
AND ct.source_geo IS NULL
