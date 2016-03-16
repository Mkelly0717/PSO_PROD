--------------------------------------------------------
--  DDL for View U_42_SRC_COSTS_NA
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."U_42_SRC_COSTS_NA" ("ITEM", "MATCODE", "DEST", "DEST_DESCR", "DEST_CO", "DEST_PC", "DEST_GEO", "SOURCE", "LOC_TYPE", "SOURCE_DESCR", "SOURCE_CO", "SOURCE_PC", "SOURCE_GEO", "SOURCING", "DATA_SOURCE", "DISTANCE", "TRANSITTIME", "U_FREIGHT_FACTOR", "FREIGHT", "OH", "IH", "BUY", "TOTAL_COST") AS 
  select distinct c.item, c.matcode, c.dest, c.dest_descr
  , c.dest_co, c.dest_pc, c.dest_geo, c.source
  , c.loc_type, c.source_descr, c.source_co, c.source_pc
  , c.source_geo, c.sourcing, c.data_source, c.distance
  , c.transittime, c.u_freight_factor, c.freight, nvl( o.unit_cost, 0 ) oh
  , nvl( i.unit_cost, 0 ) ih, nvl( b.unit_cost, 0 ) buy, round((( c.freight *
    c.u_freight_factor ) + nvl( o.unit_cost, 0 ) + nvl( i.unit_cost, 0 ) + nvl(
    b.unit_cost, 0 ) ), 4 ) total_cost
     from
    ( select distinct c.item, c.matcode, c.dest, c.dest_descr
    , c.dest_co, c.dest_pc, c.dest_geo, c.source
    , c.loc_type, c.source_descr, c.source_co, c.source_pc
    , c.source_geo, c.sourcing, c.u_freight_factor, case
        when pc.cost_pallet  is not null then 'PC'
        when geo.cost_pallet is not null then 'GEO'
        else 'UNKN'
      end data_source, case
        when pc.cost_pallet  is not null then pc.cost_pallet
        when geo.cost_pallet is not null then geo.cost_pallet
        else 99
      end freight, case
        when pc.transittime  is not null then pc.transittime
        when geo.transittime is not null then geo.transittime
        else 0
      end transittime, case
        when pc.distance  is not null then pc.distance
        when geo.distance is not null then geo.distance
        else 99
      end distance
       from
      ( select distinct source_pc, dest_pc, source_co, dest_co
      , max( distance ) distance, max( cost_pallet ) cost_pallet, max(
        transittime ) transittime
         from udt_cost_transit_na
        where source_pc <> ' ' and dest_pc <> ' '
     group by source_pc, dest_pc, source_co, dest_co
      ) pc,( select distinct source_geo, dest_geo, source_co
      , dest_co, max( distance ) distance, max( cost_pallet ) cost_pallet, max(
        transittime ) transittime
         from udt_cost_transit_na
        where source_geo is not null and dest_geo is not null
     group by source_geo, dest_geo, source_co, dest_co
      ) geo,( select distinct c.item, i.u_materialcode matcode, c.dest
      , ld.descr dest_descr, ld.country dest_co, ld.postalcode dest_pc,
        ld.u_3digitzip dest_geo, c.source, ls.loc_type, ls.descr source_descr
      , ls.country source_co, ls.postalcode source_pc, ls.u_3digitzip
        source_geo, c.sourcing, i.u_freight_factor
         from sourcing c, loc ld, loc ls, item i
        where c.dest = ld.loc and c.source = ls.loc and c.item = i.item and
        ld.u_area    = 'NA'
      ) c
      where c.dest_pc = pc.dest_pc(+) and c.source_pc = pc.source_pc(+) and
      c.dest_geo      = geo.dest_geo(+) and c.source_geo = geo.source_geo(+)
    ) c,(select loc, matcode, process
    , unit_cost
       from udt_cost_unit_na
      where process = 'HO' and loc in
      ( select loc from loc where loc_type = 2
      )
    ) o,(select loc, matcode, process
    , unit_cost
       from udt_cost_unit_na
      where process = 'HI' and loc in
      ( select loc from loc where loc_type = 2
      )
    ) i,(select loc, matcode, process
    , unit_cost
       from udt_cost_unit_na
      where process = 'BUY' and loc in
      ( select loc from loc where loc_type = 1
      )
    ) b
    where c.source    = o.loc(+) and c.matcode = o.matcode(+) and c.dest = i.loc
    (+) and c.matcode = i.matcode(+) --and c.sourcing = 'BUY'
    and c.source      = b.loc(+) and c.matcode = b.matcode(+)
    --and transittime <> 99          --and c.loc_type = 1 --and c.matcode in ('
    -- 8', '16') --and c.source IN ('BE33', 'DE09');
