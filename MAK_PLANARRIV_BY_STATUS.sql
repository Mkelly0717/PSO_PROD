--------------------------------------------------------
--  DDL for View MAK_PLANARRIV_BY_STATUS
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_PLANARRIV_BY_STATUS" ("STATUS", "NRECS") AS 
  SELECT 'UNMET-ORDERS' STATUS,
    COUNT(1) NRECS
  FROM UDT_PLANARRIV_EXTRACT pad
  WHERE sourcing='UNMET'
  AND loadid   IS NULL
  UNION
  SELECT 'UNMET-DEL' STATUS,
    COUNT(1) NRECS
  FROM UDT_PLANARRIV_EXTRACT pad
  WHERE sourcing='UNMET'
  AND loadid   IS NOT NULL
  UNION
  SELECT 'MET' STATUS,
    COUNT(1) NRECS
  FROM UDT_PLANARRIV_EXTRACT pad
  WHERE sourcing NOT LIKE '%DEL%'
  AND sourcing <> 'UNMET'
  AND FIRMSW=1
  UNION
  SELECT 'MET-NOTFIRM' STATUS,
    COUNT(1) NRECS
  FROM UDT_PLANARRIV_EXTRACT pad
  WHERE sourcing NOT LIKE '%DEL%'
  AND sourcing <> 'UNMET'
  AND FIRMSW=0
  UNION
  SELECT 'Delivery' STATUS,
    COUNT(1) NRECS
  FROM UDT_PLANARRIV_EXTRACT pad
  WHERE pad.loadid IS NOT NULL
  AND sourcing LIKE '%DEL%'
