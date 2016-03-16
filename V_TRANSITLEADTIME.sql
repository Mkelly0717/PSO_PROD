--------------------------------------------------------
--  DDL for Function V_TRANSITLEADTIME
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SCPOMGR"."V_TRANSITLEADTIME" (in_source varchar2, in_dest varchar2)
        return number
    is
        v_leadtime number :=-1;
        v_errm     varchar2(64);
        v_code number;
    BEGIN
      begin
        select  nvl(ct.transittime,0)
        into v_leadtime
        from loc ls, loc ld, udt_cost_transit_na ct
        where ls.loc=in_source
          and ld.loc=in_dest
          and ct.dest_pc=ld.postalcode 
          and ct.source_pc=ls.postalcode
          and ct.direction=' '
          and ct.u_equipment_type=decode(ld.u_equipment_type,'FB','FB','VN');
          return v_leadtime;
           exception when no_data_found then goto three_zip;
      end;
      
      /* Come here if not data was found for the 5 digit zip */
      <<THREE_ZIP>>
      begin        
       select  nvl(ct.transittime,0) into v_leadtime
         from loc ls, loc ld, udt_cost_transit_na ct
        where ls.loc=in_source
          and ld.loc=in_dest
          and ct.dest_geo=ld.u_3digitzip 
          and ct.source_geo=ls.u_3digitzip
          and ct.direction=' '
          and ct.u_equipment_type=decode(ld.u_equipment_type,'FB','FB','VN')
          and not ls.u_state = 'PR' 
          and not ld.u_state = 'PR'
          and not (ls.u_state <> 'HI' and ld.u_state ='HI') 
          and not (ls.u_state = 'HI' and ld.u_state <>'HI');
          RETURN v_leadtime;

          EXCEPTION
          when no_data_found then
               RETURN 99999;
          WHEN OTHERS THEN
           v_code :=  sqlcode;
           V_ERRM := SUBSTR(SQLERRM, 1 , 64);
           DBMS_OUTPUT.PUT_LINE('The error code is ' || V_CODE || '- ' || V_ERRM);
          RETURN v_leadtime;
        end;      
        
    exception
    when no_data_found then
         return 99999;
    when others then
         v_code :=  99999;
         v_errm := substr(sqlerrm, 1 , 64);
         dbms_output.put_line('The error code is ' || v_code || '- ' || v_errm);
        return v_code;
end v_transitleadtime;
