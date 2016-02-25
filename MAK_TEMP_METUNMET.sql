--------------------------------------------------------
--  DDL for View MAK_TEMP_METUNMET
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_TEMP_METUNMET" ("ITEM", "LOC", "EFF", "TOTMET", "TOTUNMET", "PERCENTMET", "TOTCUSTQTY") AS 
  WITH metdemand AS
  (-- Met sim_skumetric Demand Qty By Item*Loc*eff
  SELECT skm.item ,
    skm.loc,
    skm.eff,
    ROUND(SUM(skm.value)) totmet
  FROM sim_skumetric skm,
    loc l
  WHERE skm.category  IN (405)
  AND l.loc            =skm.loc
  AND l.u_area         ='NA'
  AND ROUND(skm.value) > 0
  and skm.simulation_name='AD'
  GROUP BY skm.item ,
    skm.loc,
    skm.eff
  ORDER BY skm.item ,
    skm.loc,
    skm.eff
  ),
  unmetdemand AS
  (-- UNMet sim_skumetric Demand Qty By Item*Loc*eff
  SELECT skm.item ,
    skm.loc,
    skm.eff,
    ROUND(SUM(skm.value)) totunmet
  FROM sim_skumetric skm,
    loc l
  WHERE skm.category  IN (406)
  AND l.loc            =skm.loc
  AND l.u_area         ='NA'
  AND ROUND(skm.value) > 0
  and skm.simulation_name='AD'
  GROUP BY skm.item ,
    skm.loc,
    skm.eff
  ORDER BY skm.item ,
    skm.loc,
    skm.eff
  ),
  CustorderSUM AS
  (-- Custorder item*loc*Shipdate Qty
  SELECT co.item,
    co.loc,
    co.shipdate,
    SUM(co.qty) totcustqty
  FROM custorder co,
    loc l
  WHERE l.loc =co.loc
  AND l.u_area='NA'
  AND co.item LIKE '%RU%'
  GROUP BY co.item,
    co.loc,
    co.shipdate
  ORDER BY co.item,
    co.loc,
    co.shipdate ASC
  )
SELECT md.item,
  md.loc,
  md.eff,
  md.totmet,
  NVL(ud.totunmet,0) totunmet ,
  ROUND((md.totmet /( NVL(ud.totunmet,0) + md.totmet)*100),2) PercentMet ,
  cos.totcustqty
FROM unmetdemand ud,
  metdemand md,
  CustorderSUM cos
WHERE ud.item(+)                      =md.item
AND ud.loc(+)                         =md.loc
AND ud.eff(+)                         =md.eff
AND NVL(ud.totunmet(+),0) + md.totmet > 0
AND cos.item                          =md.item
AND cos.loc                           =md.loc
AND cos.shipdate                      =md.eff
