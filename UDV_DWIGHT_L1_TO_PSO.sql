--------------------------------------------------------
--  DDL for View UDV_DWIGHT_L1_TO_PSO
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_DWIGHT_L1_TO_PSO" ("DEST", "PSO_SOURCE", "LS_SOURCE", "COST_PALLET", "DISTANCE", "MATCHES") AS 
  select pe.dest, pe.source pso_source, ls.source ls_source, ct.cost_pallet, ct.distance, 
case when pe.source=ls.source then 'M'
     when pe.source<>ls.source then '-'
     else null
end matches
from udt_planarriv_extract pe , udt_llamasoft_data ls, loc ls, loc ld, udt_sourcing_definitions sd , udt_cost_transit_na ct
where pe.sourcing <> 'UNMET'
and pe.loadid is null
and ls.dest(+)=pe.dest
and ls.loc=pe.source
and ld.loc=pe.dest
and pe.sourcing=sd.sourcing
and ct.u_equipment_type = ld.u_equipment_type
and (( sd.zip_type='3' and ls.u_3digitzip= ct.source_geo and ld.u_3digitzip=ct.dest_geo) 
        or
     ( sd.zip_type in ('NA','5') and ls.postalcode= ct.source_pc and ld.postalcode=ct.dest_pc)
    )
