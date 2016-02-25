--------------------------------------------------------
--  DDL for View MAK_72_APPROVEABLE_PA
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_72_APPROVEABLE_PA" ("ITEM", "DEST", "SOURCE", "SOURCING", "U_CUSTORDERID", "LOADID", "FCSTADJRULE", "COD", "OHPOST", "LT", "SCHEDSHIPDATE", "SCHEDARRIVDATE", "QTY", "CO_AVG_QTY", "CO_CNT", "CO_QTY", "CHK_QTY", "CHK_INT", "CHK_LT", "CHK") AS 
  select p.item
,p.dest
,p.source
,p.sourcing
,p.u_custorderid
,vll.loadid
,p.fcstadjrule
,p.cod
,p.ohpost
,p.lt
,p.schedshipdate
,p.schedarrivdate
,p.qty
,p.co_avg_qty
,p.co_cnt
,p.co_qty
,p.chk_qty
,p.chk_int
,p.chk_lt
,p.chk
from udv_72_approveable_pa p,
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
