--------------------------------------------------------
--  DDL for View UDV_ISSUES_BY_DAY
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_ISSUES_BY_DAY" ("SOURCING", "D0", "D1", "D2", "D3", "D4", "D5", "D6") AS 
  WITH data AS
  (SELECT mak.sourcing,
    mak.eff,
    SUM(count) COUNT
  FROM udv_planarriv_sourcing_by_date mak
  GROUP BY mak.sourcing,
    mak.eff
  ORDER BY mak.sourcing ASC,
    mak.eff ASC
  ),
  ranked AS
  (SELECT sourcing ,
    lead (COUNT, 0, NULL ) over (partition BY sourcing order by sourcing, eff ASC) AS D0 ,
    lead (COUNT, 1, NULL ) over (partition BY sourcing order by sourcing, eff ASC) AS D1 ,
    lead (COUNT, 2, NULL ) over (partition BY sourcing order by sourcing, eff ASC) AS D2 ,
    lead (COUNT, 3, NULL ) over (partition BY sourcing order by sourcing, eff ASC) AS D3 ,
    lead (COUNT, 4, NULL ) over (partition BY sourcing order by sourcing, eff ASC) AS D4 ,
    lead (COUNT, 5, NULL ) over (partition BY sourcing order by sourcing, eff ASC) AS D5 ,
    lead (COUNT, 6, NULL ) over (partition BY sourcing order by sourcing, eff ASC) AS D6 ,
    row_number() over (partition BY sourcing order by sourcing, eff) rank
  FROM data
  )
SELECT "SOURCING",
  "D0",
  "D1",
  "D2",
  "D3",
  "D4",
  "D5",
  "D6"
FROM ranked
WHERE rank=1
