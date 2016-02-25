--------------------------------------------------------
--  DDL for Function U_14D_END_DTSF
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SCPOMGR"."U_14D_END_DTSF" 
RETURN DATE 
IS end_date DATE;
BEGIN
  select min(startdate) + 14
  INTO end_date
  from dfutoskufcst ;
  RETURN (end_date);
END u_14d_end_dtsf;
