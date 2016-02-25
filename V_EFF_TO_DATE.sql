--------------------------------------------------------
--  DDL for Function V_EFF_TO_DATE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SCPOMGR"."V_EFF_TO_DATE" ( v_eff integer ) RETURN DATE IS
v_date date;
BEGIN
v_date:= to_date ('19700101', 'YYYYMMDD') + (  v_eff/1440);
   RETURN v_date;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END v_eff_to_date;
