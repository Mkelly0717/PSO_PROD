--------------------------------------------------------
--  DDL for View UDV_PLANARRIV_EXTRACT
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_PLANARRIV_EXTRACT" ("RECNUM", "FIRMSW", "U_RATE_TYPE", "U_CUSTORDERID", "LOADID", "ITEM", "SOURCE", "DEST", "NEEDARRIVDATE", "SCHEDARRIVDATE", "NEEDSHIPDATE", "SCHEDSHIPDATE", "QTY", "SOURCING", "SOURCESTATUS", "DESTSTATUS") AS 
  SELECT rownum AS RECNUM,
    0 FIRMSW,
    ' ' U_RATE_TYPE,
    pa.u_custorderid,
    vll.loadid,
    pa.item,
    pa.source,
    pa.dest,
    pa.needarrivdate,
    pa.schedarrivdate,
    pa.needshipdate,
    pa.schedshipdate,
    ROUND(pa.qty,0) qty,
    pa.sourcing,
    vl.sourcestatus,
    vl.deststatus
  FROM planarriv pa,
    loc l,
    vehicleloadline vll ,
    vehicleload vl
  WHERE pa.item LIKE '%RU%'
  AND l.loc             =pa.dest
  AND l.U_area          ='NA'
  AND pa.u_custorderid IS NOT NULL
  AND vll.orderid(+)    =pa.u_custorderid
  AND vl.loadid(+)      =vll.loadid
  ORDER BY pa.item,
    pa.dest,
    pa.schedshipdate,
    pa.source
