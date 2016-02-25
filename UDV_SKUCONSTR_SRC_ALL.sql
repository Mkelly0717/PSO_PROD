--------------------------------------------------------
--  DDL for View UDV_SKUCONSTR_SRC_ALL
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_SKUCONSTR_SRC_ALL" ("ITEM", "LOC", "TOTALDEMAND", "TOTALSRC", "LOC_TYPE", "POSTALCODE", "U_3DIGITZIP", "COUNTRY", "U_AREA", "U_MAX_SRC", "U_MAX_DIST", "ENABLESW") AS 
  WITH total_demand ( item, loc, totaldemand) AS
  (SELECT skc.item ,
    skc.loc ,
    ROUND(SUM(skc.qty),1) AS totaldemand
  FROM skuconstraint skc
  WHERE skc.category in (1,6)
  AND skc.qty       > 0
  GROUP BY skc.item ,
    skc.loc
  ) ,
  total_src (item, loc, totalsrc) AS
  (SELECT skc1.item ,
    skc1.loc ,
    NVL(COUNT(1),0)
  FROM sourcing src ,
    total_demand skc1
  WHERE skc1.item=src.item(+)
  AND skc1.loc   =src.dest(+)
  AND src.item  IS NOT NULL
  GROUP BY skc1.item ,
    skc1.loc
  UNION
  SELECT skc1.item ,
    skc1.loc ,
    0
  FROM sourcing src ,
    total_demand skc1
  WHERE skc1.item=src.item(+)
  AND skc1.loc   =src.dest(+)
  AND src.item  IS NULL
  )
SELECT td.item ,
  td.loc ,
  td.totaldemand ,
  ts.totalsrc ,
  l.loc_type ,
  l.postalcode ,
  l.u_3digitzip ,
  l.country ,
  l.u_area ,
  l.u_max_src ,
  l.u_max_dist ,
  l.enablesw
FROM total_demand td ,
  total_src ts ,
  loc l
WHERE td.item=ts.item
AND td.loc   =ts.loc
AND l.loc    =td.loc
