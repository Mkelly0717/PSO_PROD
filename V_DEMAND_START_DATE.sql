--------------------------------------------------------
--  DDL for Function V_DEMAND_START_DATE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SCPOMGR"."V_DEMAND_START_DATE" return date as 
begin
  return next_day(trunc(systimestamp at time zone 'GMT') - 7,'SUN');
end v_demand_start_date;
