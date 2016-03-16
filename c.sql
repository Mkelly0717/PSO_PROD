select loc, loc_type, u_equipment_type, postalcode, u_3digitzip, u_state, country, u_area
from loc
where loc in ('USHE','4000203264');


select source_pc, dest_pc, source_geo, dest_geo
     , distance, cost_pallet, transittime, u_equipment_type
from udt_cost_transit_na
where ( source_pc = '00962' and dest_pc='00681')
  or  ( source_geo = '009' and dest_geo='006' );


