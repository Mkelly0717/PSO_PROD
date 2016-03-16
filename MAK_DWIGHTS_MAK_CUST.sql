--------------------------------------------------------
--  DDL for View MAK_DWIGHTS_MAK_CUST
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_DWIGHTS_MAK_CUST" ("FIRMSW", "STATUS", "CO_ORDERID", "LOADID", "CO_ITEM", "SOURCE", "S_CITY", "S_STATE", "DEST", "D_CITY", "D_STATE", "SOURCE_PC", "DEST_PC", "SOURCE_GEO", "DEST_GEO", "NEEDARRIVDATE", "SCHEDARRIVDATE", "NEEDSHIPDATE", "SCHEDSHIPDATE", "QTY", "SOURCING", "RUN_DATE", "CO_QTY", "U_SALES_DOCUMENT", "U_SHIP_CONDITION", "PC_SOURCE", "PC_DEST", "DISTANCE", "COST", "VALUE", "INITIAL_COST", "P1") AS 
  select nvl(mct.firmsw,0) firmsw, mct.status, mct.co_orderid, mct.loadid
  , mct.co_item     , case
      when mct.assigned_plant is not null                    then mct.assigned_plant
      when mct.assigned_plant is null and loadid is null     then 'US9X'
      when mct.assigned_plant is null and loadid is not null then vll_source
      else 'US9X'
    end source                                         , ls.u_city as s_city      , ls.u_state as s_state  , mct.loc dest
  , ld.u_city as d_city                                , ld.u_state as d_state    , ls.postalcode source_pc,
    ld.postalcode dest_pc                              , ls.u_3digitzip source_geo, ld.u_3digitzip dest_geo,
    to_char( mct.shipdate, 'YYYY-MM-DD' ) needarrivdate, to_char(
    mct.schedarrivdate, 'YYYY-MM-DD' ) schedarrivdate  , to_char( mct.shipdate,
    'YYYY-MM-DD' ) needshipdate                        , to_char(
    mct.schedshipdate, 'YYYY-MM-DD' ) schedshipdate    , round( mct.co_qty, 0 )
    qty                                                , mct.sourcing         , to_char(
    trunc( sysdate ), 'YYYY-MM-DD' ) as run_date       , mct.co_qty as co_qty ,
    mct.u_sales_document                               , mct.u_ship_condition ,
    ls.postalcode pc_source                            , ld.postalcode pc_dest,
    v_distance( mct.assigned_plant, mct.loc ) distance , nvl( ctier.cost, null
    ) cost                                             , nvl( ctier.value, null
    ) value                                            , nvl( v_cost(
    mct.assigned_plant, mct.loc ), null ) initial_cost , p1
     from mak_cust_table mct                           , loc ld, loc ls,
    costtier ctier
    where mct.co_item like '%RU%' and ld.loc                      = mct.loc and ls.loc = nvl(
    mct.assigned_plant, nvl( vll_source, 'US9X' ) ) and ld.u_area = 'NA' and
    mct.co_orderid                                               is not null
    and ctier.cost(+)                                             =
    mct.sourcing || '_' || nvl( mct.assigned_plant, mct.vll_source ) || '->' ||
    MCT.LOC || '-202'
 order by mct.co_item, mct.loc, mct.schedshipdate, mct.assigned_plant
