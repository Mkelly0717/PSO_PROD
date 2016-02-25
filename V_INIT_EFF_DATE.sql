--------------------------------------------------------
--  DDL for Function V_INIT_EFF_DATE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SCPOMGR"."V_INIT_EFF_DATE" RETURN DATE IS
BEGIN
  RETURN TO_DATE('01/01/1970','MM/DD/YYYY') ;
END V_INIT_EFF_DATE;
