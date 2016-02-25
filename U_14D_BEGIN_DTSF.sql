--------------------------------------------------------
--  DDL for Function U_14D_BEGIN_DTSF
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SCPOMGR"."U_14D_BEGIN_DTSF" 
RETURN DATE 
IS begin_date DATE;
BEGIN
  select min(startdate) + 0
  INTO begin_date
  from dfutoskufcst ;
  RETURN (begin_date);
END u_14d_begin_dtsf;
