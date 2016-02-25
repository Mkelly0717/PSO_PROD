--------------------------------------------------------
--  DDL for View MAK_CUST_TABLE_R_EXTRACT
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_CUST_TABLE_R_EXTRACT" ("STATUS", "SM_RECORD", "CO_ITEM", "LOC", "SHIPDATE", "SCHEDSHIPDATE", "SCHEDARRIVDATE", "CO_ORDERID", "CO_QTY", "U_SALES_DOCUMENT", "U_SHIP_CONDITION", "U_DMDGROUP_CODE", "VL_ORDERID", "LOADID", "VLL_DEST", "VLL_SOURCE", "VLL_QTY", "VLL_ITEM", "ASSIGNED_PLANT", "U_OVERALLSTS", "P1", "FIRMSW", "SM417_RECNUM", "SM417_EFF", "SOURCING", "MINLEADTIME", "DUR") AS 
  select status status                       , sm_record sm_record, co_item co_item, loc loc
, to_char( shipdate, 'YYYY-MM-DD' ) shipdate, to_char( schedshipdate,
  'YYYY-MM-DD' ) schedshipdate              , to_char( schedarrivdate,
  'YYYY-MM-DD' ) schedarrivdate             , co_orderid co_orderid, co_qty
  co_qty                                    , u_sales_document u_sales_document
  , u_ship_condition u_ship_condition       , u_dmdgroup_code u_dmdgroup_code,
  vl_orderid vl_orderid                     , loadid loadid                  ,
  vll_dest vll_dest                         , vll_source vll_source          ,
  vll_qty vll_qty                           , vll_item vll_item              ,
  assigned_plant assigned_plant             , u_overallsts u_overallsts      ,
  p1 p1                                     , firmsw firmsw                  ,
  sm417_recnum sm417_recnum                 , sm417_eff sm417_eff            ,
  sourcing sourcing                         , minleadtime minleadtime        ,
  dur dur
   from mak_cust_table
