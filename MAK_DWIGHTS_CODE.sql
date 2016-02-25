--------------------------------------------------------
--  DDL for View MAK_DWIGHTS_CODE
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_DWIGHTS_CODE" ("U_CUSTORDERID", "LOADID", "ITEM", "SOURCE", "S_CITY", "S_STATE", "DEST", "D_CITY", "D_STATE", "SOURCE_PC", "DEST_PC", "NEEDARRIVDATE", "SCHEDARRIVDATE", "NEEDSHIPDATE", "SCHEDSHIPDATE", "QTY", "SOURCING", "SOURCESTATUS", "DESTSTATUS", "FIRMSW", "RUN_DATE", "CO_QTY", "U_SALES_DOCUMENT", "U_SHIP_CONDITION", "PC_SOURCE", "PC_DEST", "DISTANCE", "COST", "VALUE", "INITIAL_COST") AS 
  select pa.u_custorderid, pa.loadid                   , pa.item               , pa.source
  , ls.u_city as s_city   , ls.u_state as s_state       , pa.dest               , ld.u_city as d_city
  , ld.u_state as d_state ,    ls.postalcode source_pc,
    ld.postalcode dest_pc, pa.needarrivdate            , pa.schedarrivdate     ,
    pa.needshipdate       , pa.schedshipdate            , round( pa.qty, 0 ) qty,
    pa.sourcing           , pa.sourcestatus             , pa.deststatus         ,
    pa.firmsw             , trunc( sysdate ) as run_date, co.qty as co_qty      ,
    co.u_sales_document   , co.u_ship_condition         , ls.postalcode
    pc_source             , ld.postalcode pc_dest       , v_distance( pa.source
    , pa.dest ) distance  , ctier.cost                  , ctier.value, v_cost(
    pa.source, pa.dest ) initial_cost
     from udt_planarriv_extract pa, loc ld, loc ls, custorder co
  , costtier ctier
    where pa.item like '%RU%' and ld.loc = pa.dest and ls.loc = pa.source and
    ld.u_area                            = 'NA' and pa.u_custorderid is not
    null and co.orderid(+)               = pa.u_custorderid and ctier.cost(+) =
    pa.sourcing || '_' || pa.source || '->' || pa.dest || '-202'
 order by pa.item, pa.dest, pa.schedshipdate, pa.source
