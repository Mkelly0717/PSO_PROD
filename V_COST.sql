--------------------------------------------------------
--  DDL for Function V_COST
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SCPOMGR"."V_COST" (in_source varchar2, in_dest varchar2)
        return number
    is
        v_cost number :=-1;
        v_errm varchar2(64);
        v_code number;
    BEGIN
    
      begin
        SELECT CT.COST_PALLET INTO V_COST
          FROM LOC LS, LOC LD, UDT_COST_TRANSIT_NA CT
         where ls.loc=in_source
           AND LD.LOC=IN_DEST
           AND CT.DEST_PC=LD.POSTALCODE 
           AND CT.SOURCE_PC=LS.POSTALCODE
           AND CT.DIRECTION=' '
           and ct.u_equipment_type=decode(ld.u_equipment_type,'FB','FB','VN'); 
          RETURN V_COST;
         EXCEPTION WHEN NO_DATA_FOUND THEN GOTO THREE_ZIP;
       END;
       
         /* Come here if not data was found for the 5 digit zip */
          <<three_zip>>
          begin
             SELECT  CT.COST_PALLET INTO V_COST
               FROM LOC LS, LOC LD, UDT_COST_TRANSIT_NA CT
              WHERE LS.LOC=IN_SOURCE
                AND LD.LOC=IN_DEST
                AND CT.DEST_GEO=LD.U_3DIGITZIP 
                AND CT.SOURCE_GEO=LS.U_3DIGITZIP
                AND CT.DIRECTION=' '
                and ct.u_equipment_type=decode(ld.u_equipment_type,'FB','FB','VN')
          and ( (ls.u_state not in ('PR','HI') and ls.u_state not in ('PR','HI'))
                 or
                 (    (ls.u_state = 'PR' and ld.u_state <> 'PR')
                  and (ld.u_state = 'HI' and ld.u_state <> 'HI')
                  )
              ); 
               RETURN V_COST;
           EXCEPTION
          when no_data_found then
               RETURN 99999;
          WHEN OTHERS THEN
           v_code :=  sqlcode;
           V_ERRM := SUBSTR(SQLERRM, 1 , 64);
           DBMS_OUTPUT.PUT_LINE('The error code is ' || V_CODE || '- ' || V_ERRM);
          RETURN V_CODE;
          end;

    exception
    WHEN NO_DATA_FOUND THEN
         return sqlcode;
    when others then
         v_code :=  99999;
         v_errm := substr(sqlerrm, 1 , 64);
         dbms_output.put_line('The error code is ' || v_code || '- ' || v_errm);
        return v_code;
    end v_cost;
