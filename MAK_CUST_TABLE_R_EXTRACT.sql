--------------------------------------------------------
--  DDL for View MAK_CUST_TABLE_R_EXTRACT
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_CUST_TABLE_R_EXTRACT" ("STATUS", "SM_RECORD", "CO_ITEM", "LOC", "SHIPDATE", "NEEDSHIPDATE", "SCHEDSHIPDATE", "SCHEDARRIVDATE", "CO_ORDERID", "CO_QTY", "U_SALES_DOCUMENT", "U_SHIP_CONDITION", "U_DMDGROUP_CODE", "VL_ORDERID", "LOADID", "VLL_DEST", "VLL_SOURCE", "VLL_QTY", "VLL_ITEM", "ASSIGNED_PLANT", "U_OVERALLSTS", "P1", "FIRMSW", "SOURCING", "MINLEADTIME", "DUR") AS 
  select STATUS STATUS 
       , SM_RECORD SM_RECORD
       , CO_ITEM CO_ITEM
       , LOC LOC
       , TO_CHAR( SHIPDATE, 'YYYY-MM-DD' ) SHIPDATE
       , to_char( schedshipdate,'YYYY-MM-DD' ) needshipdate 
       , to_char( schedshipdate,'YYYY-MM-DD' ) schedshipdate 
       , to_char( schedarrivdate,'YYYY-MM-DD' ) schedarrivdate  
       , CO_ORDERID CO_ORDERID
       , co_qty   co_qty  
       , u_sales_document    u_sales_document    
       , u_ship_condition   u_ship_condition  
       , U_DMDGROUP_CODE U_DMDGROUP_CODE
       , vl_orderid vl_orderid                   , loadid loadid            , vll_dest
    vll_dest                                  , vll_source vll_source    , vll_qty
    vll_qty                                   , vll_item vll_item        ,
    assigned_plant assigned_plant             , u_overallsts u_overallsts, p1
    p1                                        , firmsw firmsw            ,
    sourcing sourcing                         , minleadtime minleadtime  , dur
    DUR
     from mak_cust_table
