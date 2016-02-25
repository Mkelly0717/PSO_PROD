--------------------------------------------------------
--  DDL for Function IS_3DIGIT_LANE_EXISTS
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SCPOMGR"."IS_3DIGIT_LANE_EXISTS" (
            in_loc varchar2)
        return number
    is
        v_number number :=0;
    begin
        select count(1)
        into v_number
        from loc l
        where l.loc=in_loc
            and exists
            (select 1
            from udt_cost_transit_na ct
            where ct.dest_geo=l.u_3digitzip
                and ct.direction=' '
                and ct.u_equipment_type=l.u_equipment_type
                and ct.cost_pallet is not null
                and ct.distance is not null
                and ct.distance <= l.u_max_dist
            );
        if ( v_number > 0 ) then
            v_number := 1;
        else
            v_number := 0;
        end if;
        return v_number;
    exception
    when others then
        return 0;
    end is_3digit_lane_exists;
