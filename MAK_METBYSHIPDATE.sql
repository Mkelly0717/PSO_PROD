--------------------------------------------------------
--  DDL for View MAK_METBYSHIPDATE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_METBYSHIPDATE" ("MET_SHIPDATE", "UNMET_SHIPDATE", "TOTMETQTY", "TOTUNMETQTY", "PERCENTMET", "PERCENTUNMET") AS 
  WITH metcust AS
  (
  -- Qty Met Demand By Shipdate : I know that at least some of this is met
  -- because it is in the view.
  SELECT co.shipdate,
    SUM(qty) AS totmetqty
  FROM custorder co,
    loc l
  WHERE co.item LIKE '%RU%'
  AND l.loc   =co.loc
  AND l.u_area='NA'
  AND EXISTS
    (SELECT 1
    FROM mak_temp_metunmet m
    WHERE m.item=co.item
    AND m.loc   =co.loc
    AND m.eff   =co.shipdate
    )
  GROUP BY co.shipdate
  ORDER BY co.shipdate ASC
  ),
  unmetcust AS
  (
  --UnMet Qty Demand By Shipdate */
  SELECT co.shipdate,
    SUM(qty) totunmetqty
  FROM custorder co,
    loc l
  WHERE co.item LIKE '%RU%'
  AND l.loc   =co.loc
  AND l.u_area='NA'
  AND NOT EXISTS
    (SELECT 1
    FROM mak_temp_metunmet m
    WHERE m.item=co.item
    AND m.loc   =co.loc
    AND m.eff   =co.shipdate
    )
  GROUP BY co.shipdate
  ORDER BY co.shipdate ASC
  )
SELECT mc.shipdate met_Shipdate ,
  uc.shipdate Unmet_Shipdate ,
  mc.totmetqty ,
  uc.totunmetqty ,
  ROUND(mc.totmetqty  /(mc.totmetqty + uc.totunmetqty)*100,2) PercentMet ,
  ROUND(uc.totunmetqty/(mc.totmetqty + uc.totunmetqty)*100,2) PercentUnMet
FROM metcust mc,
  unmetcust uc
WHERE mc.shipdate(+)=uc.shipdate
