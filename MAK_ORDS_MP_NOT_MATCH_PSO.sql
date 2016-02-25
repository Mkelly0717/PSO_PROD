--------------------------------------------------------
--  DDL for View MAK_ORDS_MP_NOT_MATCH_PSO
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_ORDS_MP_NOT_MATCH_PSO" ("U_CUSTORDERID", "DEST", "ITEM", "NEEDARRIVDATE", "NEEDSHIPDATE", "PSO_QTY", "SCHEDARRIVDATE", "SCHEDSHIPDATE", "SOURCE", "SOURCING", "ORDERID", "MP_SOURCE", "MP_ARRIV_DT", "MP_SHIPDT") AS 
  SELECT pe.U_CUSTORDERID,
    pe.DEST,
    pe.ITEM,
    pe.NEEDARRIVDATE,
    pe.NEEDSHIPDATE,
    pe.QTY pso_qty,
    pe.SCHEDARRIVDATE,
    pe.SCHEDSHIPDATE,
    pe.SOURCE,
    pe.SOURCING ,
    mp.orderid,
    mp.source MP_SOURCE,
    mp.arrivddate MP_ARRIV_DT,
    mp.shipdate MP_SHIPDT
  FROM udt_planarriv_extract pe,
    mak_mp_arrivals mp
  WHERE pe.firmsw =1
  AND pe.item LIKE '%RU%'
  AND pe.u_custorderid = mp.orderid
  AND pe.source       <> mp.source
