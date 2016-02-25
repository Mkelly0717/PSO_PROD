--------------------------------------------------------
--  DDL for View UDV_ISSUE_QTY_BY_DAY
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_ISSUE_QTY_BY_DAY" ("SOURCING", "D0", "D1", "D2", "D3", "D4", "D5", "D6", "RANK") AS 
  WITH data AS
  (SELECT mak.sourcing,
    mak.eff,
    SUM(COUNT) COUNT,
    SUM(QTY) TOTQTY
  FROM udv_planarriv_sourcing_by_date mak
  GROUP BY mak.sourcing,
    mak.eff
  ORDER BY mak.sourcing ASC,
    mak.eff ASC
  ),
  ranked AS
  (SELECT sourcing ,
    lead (TOTQTY, 0, NULL ) over (partition BY sourcing order by sourcing, eff ASC) AS D0 ,
    lead (TOTQTY, 1, NULL ) over (partition BY sourcing order by sourcing, eff ASC) AS D1 ,
    lead (TOTQTY, 2, NULL ) over (partition BY sourcing order by sourcing, eff ASC) AS D2 ,
    lead (TOTQTY, 3, NULL ) over (partition BY sourcing order by sourcing, eff ASC) AS D3 ,
    lead (TOTQTY, 4, NULL ) over (partition BY sourcing order by sourcing, eff ASC) AS D4 ,
    lead (TOTQTY, 5, NULL ) over (partition BY sourcing order by sourcing, eff ASC) AS D5 ,
    lead (TOTQTY, 6, NULL ) over (partition BY sourcing order by sourcing, eff ASC) AS D6 ,
    row_number() over (partition BY sourcing order by sourcing, eff) rank
  FROM data
  )
SELECT "SOURCING","D0","D1","D2","D3","D4","D5","D6","RANK"
FROM ranked
WHERE rank=1
