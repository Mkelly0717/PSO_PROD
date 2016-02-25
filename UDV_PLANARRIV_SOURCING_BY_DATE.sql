  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_PLANARRIV_SOURCING_BY_DATE" ("EFF", "SOURCING", "COUNT", "QTY") AS 
  with DATES as
  ( SELECT DISTINCT eff FROM sim_sourcingmetric sm
    where sm.simulation_name='AD'  ORDER BY eff ASC
  )
SELECT dates.eff ,
  NVL(pa.sourcing,'INTRANSIT') sourcing ,
  CASE
    WHEN pa.sourcing IS NULL
    THEN 0
    ELSE COUNT(1)
  END COUNT ,
  NVL(SUM(qty),0) AS QTY
FROM dates dates,
  udt_planarriv_extract pa
WHERE dates.eff         > sysdate - 3
AND pa.sourcing(+)      = 'INTRANSIT'
AND pa.schedshipdate(+) = dates.eff
AND pa.item(+) LIKE '%RU%'
GROUP BY dates.eff,
  pa.sourcing(+)
UNION
SELECT dates.eff ,
  NVL(pa.sourcing,'ISS1EXCL') sourcing ,
  CASE
    WHEN pa.sourcing IS NULL
    THEN 0
    ELSE COUNT(1)
  END COUNT ,
  NVL(SUM(qty),0) AS QTY
FROM dates dates,
  udt_planarriv_extract pa
WHERE dates.eff         > sysdate - 3
AND pa.sourcing(+)      = 'ISS1EXCL'
AND pa.schedshipdate(+) = dates.eff
AND pa.item(+) LIKE '%RU%'
GROUP BY dates.eff,
  pa.sourcing(+)
UNION
SELECT dates.eff ,
  NVL(pa.sourcing,'ISS2MAXDISTSRC-3ZIP') sourcing ,
  CASE
    WHEN pa.sourcing IS NULL
    THEN 0
    ELSE COUNT(1)
  END COUNT ,
  NVL(SUM(qty),0) AS QTY
FROM dates dates,
  udt_planarriv_extract pa
WHERE dates.eff         > sysdate - 3
AND pa.sourcing(+)      = 'ISS2MAXDISTSRC-3ZIP'
AND pa.schedshipdate(+) = dates.eff
AND pa.item(+) LIKE '%RU%'
GROUP BY dates.eff,
  pa.sourcing(+)
UNION
SELECT dates.eff ,
  NVL(pa.sourcing,'ISS2MAXDISTSRC-5ZIP') sourcing ,
  CASE
    WHEN pa.sourcing IS NULL
    THEN 0
    ELSE COUNT(1)
  END COUNT ,
  NVL(SUM(qty),0) AS QTY
FROM dates dates,
  udt_planarriv_extract pa
WHERE dates.eff         > sysdate - 3
AND pa.sourcing(+)      = 'ISS2MAXDISTSRC-5ZIP'
AND pa.schedshipdate(+) = dates.eff
AND pa.item(+) LIKE '%RU%'
GROUP BY dates.eff,
  pa.sourcing(+)
UNION
SELECT dates.eff ,
  NVL(pa.sourcing,'ISS5MFG') sourcing ,
  CASE
    WHEN pa.sourcing IS NULL
    THEN 0
    ELSE COUNT(1)
  END COUNT ,
  NVL(SUM(qty),0) AS QTY
FROM dates dates,
  udt_planarriv_extract pa
WHERE dates.eff         > sysdate - 3
AND pa.sourcing(+)      = 'ISS5MFG'
AND pa.schedshipdate(+) = dates.eff
AND pa.item(+) LIKE '%RU%'
GROUP BY dates.eff,
  pa.sourcing(+)
UNION
SELECT dates.eff ,
  NVL(pa.sourcing,'ISS9DEL') sourcing ,
  CASE
    WHEN pa.sourcing IS NULL
    THEN 0
    ELSE COUNT(1)
  END COUNT ,
  NVL(SUM(qty),0) AS QTY
FROM dates dates,
  udt_planarriv_extract pa
WHERE dates.eff         > sysdate - 3
AND pa.sourcing(+)      = 'ISS9DEL'
AND pa.schedshipdate(+) = dates.eff
AND pa.item(+) LIKE '%RU%'
GROUP BY dates.eff,
  pa.sourcing(+)
UNION
SELECT dates.eff ,
  NVL(pa.sourcing,'UNMET') sourcing ,
  CASE
    WHEN pa.sourcing IS NULL
    THEN 0
    ELSE COUNT(1)
  END COUNT ,
  NVL(SUM(qty),0) AS QTY
FROM dates dates,
  udt_planarriv_extract pa
WHERE dates.eff         > sysdate - 3
AND pa.sourcing(+)      = 'UNMET'
AND pa.schedshipdate(+) = dates.eff
AND pa.item(+) LIKE '%RU%'
GROUP BY dates.eff,
  pa.sourcing(+)
ORDER BY 2 ASC,
  1 ASC
