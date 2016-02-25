--------------------------------------------------------
--  DDL for Function V_DATE_TO_EFF
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SCPOMGR"."V_DATE_TO_EFF" ( IN_DATE DATE ) 
       RETURN NUMBER IS
EFF NUMBER;
BEGIN
   EFF := (trunc(IN_DATE) - to_date('19700101','YYYYMMDD'))*1440;
   RETURN EFF;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
     WHEN OTHERS THEN
       -- Consider logging the error and then re-raise
       RAISE;
END V_DATE_TO_EFF;
