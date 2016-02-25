--------------------------------------------------------
--  DDL for View MAK_COMPARE_PSO_TO_P1
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_COMPARE_PSO_TO_P1" ("STATUS", "CNT", "TOT_QTY") AS 
  SELECT 'Total' status,
    COUNT(1) cnt,
    SUM(qty) tot_qty
  FROM udt_planarriv_extract pe
  WHERE firmsw=1
  UNION
  SELECT 'Match' status,
    COUNT(1) cnt,
    SUM(qty) tot_qty
  FROM udt_planarriv_extract pe
  WHERE firmsw=1
  AND EXISTS
    (SELECT 1
    FROM udt_llamasoft_data llsft
    WHERE pe.source = llsft.source
    AND pe.dest     =llsft.dest
    AND pe.item     =llsft.item
    )
  AND EXISTS
    ( SELECT 1 FROM udt_llamasoft_data ll WHERE ll.dest=pe.dest
    )
  UNION
  SELECT 'NOT-Match' status,
    COUNT(1) cnt,
    SUM(qty) tot_qty
  FROM udt_planarriv_extract pe
  WHERE firmsw=1
  AND NOT EXISTS
    (SELECT 1
    FROM udt_llamasoft_data llsft
    WHERE pe.source = llsft.source
    AND pe.dest     =llsft.dest
    AND pe.item     =llsft.item
    )
  UNION
  SELECT 'CANT-Match' status,
    COUNT(1) cnt,
    SUM(qty) tot_qty
  FROM udt_planarriv_extract pe
  WHERE firmsw=1
  and not exists
    ( select 1 from udt_llamasoft_data ll where ll.dest=pe.dest and ll.item=pe.item
    )
