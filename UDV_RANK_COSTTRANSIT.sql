--------------------------------------------------------
--  DDL for View UDV_RANK_COSTTRANSIT
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_RANK_COSTTRANSIT" ("DIRECTION", "DEST_PC", "SOURCE_PC", "COST_PALLET", "U_EQUIPMENT_TYPE", "TRANSITTIME", "RANK") AS 
  SELECT DIRECTION , DEST_PC    , SOURCE_PC, COST_PALLET
  , u_equipment_type, transittime, dense_rank( ) over( partition by direction,
    u_equipment_type, dest_pc order by cost_pallet asc ) rank
     from udt_cost_transit_na
    WHERE TRIM( SOURCE_PC ) IS NOT NULL
 order by direction, u_equipment_type, dest_pc, rank
