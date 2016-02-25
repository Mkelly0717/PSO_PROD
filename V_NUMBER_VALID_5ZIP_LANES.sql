--------------------------------------------------------
--  DDL for Function V_NUMBER_VALID_5ZIP_LANES
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SCPOMGR"."V_NUMBER_VALID_5ZIP_LANES" (
            in_loc varchar2)
        return number
    is
        v_number number :=0;
    begin
        select count(1)
        into v_number
        from loc l, UDT_COST_TRANSIT_NA ct
        where l.loc=in_loc
          and ct.dest_pc=l.postalcode
          and ct.direction=' '
          and ct.u_equipment_type=l.u_equipment_type
          and ct.cost_pallet is not null
          and ct.distance is not null
          and ct.distance <= l.U_max_dist;
        if ( v_number > 0 ) then
            v_number := 1;
        else
            v_number := 0;
        end if;
        return v_number;
    exception
    when others then
        return 0;
    end v_number_valid_5zip_lanes;
