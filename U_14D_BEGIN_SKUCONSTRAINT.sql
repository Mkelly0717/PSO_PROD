--------------------------------------------------------
--  DDL for Function U_14D_BEGIN_SKUCONSTRAINT
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SCPOMGR"."U_14D_BEGIN_SKUCONSTRAINT" 
RETURN DATE 
IS begin_date DATE;
BEGIN
  select min(eff) + 0
  INTO begin_date
  from skuconstraint
  where category in (1, 10)
  and eff > to_date('01/01/1970', 'MM/DD/YYYY') ;
  RETURN (begin_date);
END u_14d_begin_skuconstraint;
