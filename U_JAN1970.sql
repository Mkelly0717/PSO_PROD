--------------------------------------------------------
--  DDL for Function U_JAN1970
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SCPOMGR"."U_JAN1970" 
RETURN DATE 
IS def_date DATE;
BEGIN
  select to_date('01/01/1970', 'MM/DD/YYYY')
  INTO def_date
  from dual;
  RETURN (def_date);
END u_jan1970;
