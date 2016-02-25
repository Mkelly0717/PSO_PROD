--------------------------------------------------------
--  DDL for View MAK_60_PLANNARRIV_NA
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_60_PLANNARRIV_NA" ("ITEM", "DEST", "DESCR", "CITY", "STATE", "POSTALCODE", "U_CUSTORDERID", "LOADID", "SOURCE", "DESCR_SOURCE", "CITY_SOURCE", "STATE_SOURCE", "PC_SOURCE", "SOURCING", "RPA", "TRANSIT_TIME", "SCHEDSHIPDATE", "SCHEDARRIVDATE", "QTY") AS 
  SELECT p.item,
    p.dest,
    ld.descr,
    ld.u_city city,
    ld.u_state state,
    ld.postalcode ,
    p.u_custorderid,
    vll.loadid,
    p.source,
    ls.descr descr_source,
    ls.u_city city_source,
    ls.u_state state_source,
    ls.postalcode pc_source,
    c.sourcing,
    r.rpa2 rpa,
    c.minleadtime/1440 transit_time,
    p.schedshipdate,
    p.schedarrivdate,
    ROUND(p.qty, 0) qty
  FROM planarriv p,
    loc ld,
    loc ls,
    tmp_rpa r,
    item i,
    sourcing c ,
    vehicleloadline vll
  WHERE p.source    = ls.loc
  AND p.dest        = ld.loc --and p.item = '4055RUPLUS' and p.dest = '3000147629'
  AND ld.u_area     = 'NA'   -- and vll.orderid = '3019132435000010'
  AND p.source      = r.loc(+)
  AND p.item        = i.item
  AND i.u_stock     = 'C'
  AND p.item        = c.item
  AND p.dest        = c.dest
  AND p.source      = c.source
  AND p.sourcing    = c.sourcing
  AND vll.orderid(+)=p.u_custorderid
  ORDER BY p.dest,
    p.item,
    p.schedarrivdate
