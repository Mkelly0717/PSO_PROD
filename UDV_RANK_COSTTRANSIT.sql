--------------------------------------------------------
--  DDL for View UDV_RANK_COSTTRANSIT
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_RANK_COSTTRANSIT" ("DIRECTION", "DEST_PC", "SOURCE_PC", "COST_PALLET", "U_EQUIPMENT_TYPE", "TRANSITTIME", "RANK") AS 
  select direction
      ,dest_pc
      ,source_pc
      ,cost_pallet
      ,u_equipment_type
      ,transittime
      ,rank() over (partition by direction, u_equipment_type, dest_pc order by cost_pallet asc) rank
    from udt_cost_transit_na
    where trim(source_pc) is not null
    order by direction
      , u_equipment_type
      , dest_pc
      , rank
