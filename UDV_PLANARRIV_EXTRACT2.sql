--------------------------------------------------------
--  DDL for View UDV_PLANARRIV_EXTRACT2
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_PLANARRIV_EXTRACT2" ("RECNUM", "FIRMSW", "U_RATE_TYPE", "U_CUSTORDERID", "LOADID", "ITEM", "SOURCE", "DEST", "NEEDARRIVDATE", "SCHEDARRIVDATE", "NEEDSHIPDATE", "SCHEDSHIPDATE", "QTY", "SOURCING", "SOURCESTATUS", "DESTSTATUS") AS 
  select rownum as recnum  , mct.firmsw firmsw                  , ' ' u_rate_type   , mct.co_orderid
  , vll.loadid              , mct.co_item               , mct.assigned_plant, mct.loc
  , mct.shipdate            , mct.schedarrivdate        , mct.shipdate      ,
    mct.schedshipdate       , round( mct.co_qty, 0 ) qty, mct.sourcing      ,
    vl.sourcestatus         , vl.deststatus
     from mak_cust_table mct, loc l, vehicleloadline vll, vehicleload vl
    where mct.co_item like '%RU%' and l.loc = mct.loc and l.u_area = 'NA' and
    mct.co_orderid                         is not null and vll.orderid(+) =
    mct.co_orderid and vl.loadid(+)         = vll.loadid
 order by mct.co_item, mct.loc, mct.schedshipdate, mct.assigned_plant
