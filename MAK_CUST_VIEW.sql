--------------------------------------------------------
--  DDL for View MAK_CUST_VIEW
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_CUST_VIEW" ("STATUS", "SM_RECORD", "CO_ITEM", "LOC", "SHIPDATE", "CO_ORDERID", "CO_QTY", "U_SALES_DOCUMENT", "U_SHIP_CONDITION", "U_DMDGROUP_CODE", "VL_ORDERID", "LOADID", "VLL_DEST", "VLL_SOURCE", "VLL_QTY", "VLL_ITEM", "SOURCESTATUS", "DESTSTATUS", "U_OVERALLSTS") AS 
  select 0 status     , 0 sm_record          , co.item co_item       , co.loc
  , co.shipdate        , co.orderid co_orderid, co.qty co_qty         , co.u_sales_document
  , co.u_ship_condition, co.u_dmdgroup_code   , vll.orderid vl_orderid,
    vll.loadid         , vll.dest vll_dest    , vll.source vll_source , vll.qty
    vll_qty            , vll.item vll_item    , vl.sourcestatus       ,
    vl.deststatus      , vll.u_overallsts
     from custorder co , vehicleloadline vll, vehicleload vl, loc l
    where co.orderid    = vll.orderid(+) and vll.loadid = vl.loadid(+) and l.loc =
    co.loc and l.u_area = 'NA'
    and co.item like '%RU%'
