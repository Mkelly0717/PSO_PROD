--------------------------------------------------------
--  DDL for Function U_14D_END_SKUCONSTRAINT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SCPOMGR"."U_14D_END_SKUCONSTRAINT" 
RETURN DATE 
IS end_date DATE;
BEGIN
  select min(eff) + 14
  INTO end_date
  from skuconstraint
  where category in (1, 10)
  and eff > to_date('01/01/1970', 'MM/DD/YYYY') ;
  RETURN (end_date);
END u_14d_end_skuconstraint;
