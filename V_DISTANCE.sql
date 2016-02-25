--------------------------------------------------------
--  DDL for Function V_DISTANCE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SCPOMGR"."V_DISTANCE" (in_source varchar2, in_dest varchar2)
        return number
    is
        v_distance number :=-1;
        v_errm     varchar2(64);
        v_code number;
    begin
        select  ct.distance
        into v_distance
        from loc ls, loc ld, udt_cost_transit_na ct
        where ls.loc=in_source
          and ld.loc=in_dest
          and ct.dest_pc=ld.postalcode 
          and ct.source_pc=ls.postalcode
          and ct.direction=' '
          and ct.u_equipment_type=decode(ld.u_equipment_type,'FB','FB','VN'); 
          
        if  v_distance = -1 then 
           select  ct.distance into v_distance
             from loc ls, loc ld, udt_cost_transit_na ct
            where ls.loc=in_source
              and ld.loc=in_dest
              and ct.dest_geo=ld.u_3digitzip 
              and ct.source_geo=ls.u_3digitzip
              and ct.direction=' '
              and ct.u_equipment_type=decode(ld.u_equipment_type,'FB','FB','VN');
        end if;  

        return nvl(v_distance,-2);

    exception
    when no_data_found then
         return sqlcode;
    when others then
         v_code :=  sqlcode;
         v_errm := substr(sqlerrm, 1 , 64);
         dbms_output.put_line('The error code is ' || v_code || '- ' || v_errm);
        return v_code;
    end v_distance;
