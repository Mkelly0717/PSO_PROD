--------------------------------------------------------
--  DDL for Function V_DEMAND_END_DATE
--------------------------------------------------------

  CREATE OR REPLACE FUNCTION "SCPOMGR"."V_DEMAND_END_DATE" 
        return date
    as
        v_number_days number:=7;
        cursor c_number_days
        is
            select numval1 
              from udt_default_parameters 
             where name='PLAN_HORIZON_DAYS';
    begin
        open c_number_days;
        fetch c_number_days into v_number_days ;
        if c_number_days%rowcount = 0 then
            v_number_days := 365;
        end if;
        return next_day(trunc(systimestamp at time zone 'GMT') + (v_number_days-14),'SUN');
    end v_demand_end_date;
