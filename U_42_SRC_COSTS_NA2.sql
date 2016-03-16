--------------------------------------------------------
--  DDL for View U_42_SRC_COSTS_NA2
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."U_42_SRC_COSTS_NA2" ("ITEM", "MATCODE", "DEST", "DEST_DESCR", "DEST_CO", "DEST_PC", "DEST_GEO", "SOURCE", "LOC_TYPE", "SOURCE_DESCR", "SOURCE_CO", "SOURCE_PC", "SOURCE_GEO", "SOURCING", "DATA_SOURCE", "DISTANCE", "TRANSITTIME", "U_FREIGHT_FACTOR", "FREIGHT", "BUY") AS 
  select distinct c.item, c.matcode, c.dest, c.dest_descr
  , c.dest_co, c.dest_pc, c.dest_geo, c.source
  , c.loc_type, c.source_descr, c.source_co, c.source_pc
  , c.source_geo, c.sourcing, c.data_source, c.distance
  , c.transittime, c.u_freight_factor, c.freight, nvl( b.unit_cost, 0 ) buy
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
        else 99999
      end freight, case
        when pc.transittime  is not null then pc.transittime
        when geo.transittime is not null then geo.transittime
        else 99999
      end transittime, case
        when pc.distance  is not null then pc.distance
        when geo.distance is not null then geo.distance
        else 99999
      end distance
       from
      ( select distinct source_pc, dest_pc, source_co, dest_co
      , distance distance, cost_pallet cost_pallet, transittime transittime,
        u_equipment_type
         from udt_cost_transit_na
        where direction = ' ' and source_pc <> ' ' and dest_pc <> ' '
      ) pc,( select distinct source_geo, dest_geo, source_co
      , dest_co, distance distance, cost_pallet cost_pallet, transittime
        transittime, u_equipment_type
         from udt_cost_transit_na
        where direction = ' ' and source_geo <> ' ' and dest_geo <> ' '
      ) geo,( select distinct c.item, i.u_materialcode matcode, c.dest
      , ld.descr dest_descr, ld.country dest_co, ld.postalcode dest_pc,
        ld.u_3digitzip dest_geo, c.source, ls.loc_type, ls.descr source_descr
      , ls.country source_co, ls.postalcode source_pc, ls.u_3digitzip
        source_geo, c.sourcing, i.u_freight_factor, ld.u_equipment_type, ls.u_state ls_state, ld.u_state ld_state
         from sourcing c, loc ld, loc ls, item i
        where c.dest = ld.loc and c.source = ls.loc and c.item = i.item and
        ld.u_area    = 'NA'
      ) c
      where c.dest_pc = pc.dest_pc(+) 
        and c.source_pc = pc.source_pc(+) 
        and c.dest_geo = geo.dest_geo(+) 
        and c.source_geo = geo.source_geo(+)
        and decode( c.u_equipment_type, 'FB', 'FB', 'VN' ) = pc.u_equipment_type(+) 
        and ( decode( c.u_equipment_type, 'FB', 'FB', 'VN' ) =    geo.u_equipment_type(+)
               and c.ls_state <> 'PR')
    ) c,(select loc, matcode, process
    , unit_cost
       from udt_cost_unit_na
      where process = 'BUY' and loc in
      ( select loc from loc where loc_type = 1
      )
    ) b
    where c.source = b.loc(+) and c.matcode = b.matcode(+)
