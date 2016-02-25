--------------------------------------------------------
--  DDL for View UDV_DUPS_TO_KEEP
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_DUPS_TO_KEEP" ("ITEM", "DEST", "U_CUSTORDERID", "MIN_QTY", "MAX_QTY", "MINPMAX") AS 
  WITH dups AS
  (SELECT u_custorderid,
    COUNT(1)
  FROM udv_planarriv_extract
  GROUP BY u_custorderid
  HAVING COUNT(1) > 1
  )
SELECT p.item,
  p.dest,
  p.u_custorderid,
  ROUND(MIN(qty),2) min_qty, 
  ROUND(MAX(qty),2) max_qty,
  (ROUND(MIN(qty),2) + ROUND(MAX(qty),2)) AS minpmax
FROM planarriv p,
  dups d
WHERE p.u_custorderid = d.u_custorderid
GROUP BY p.item,
  p.dest,
  p.u_custorderid
HAVING MAX(qty) >= 400
ORDER BY p.u_custorderid ASC
