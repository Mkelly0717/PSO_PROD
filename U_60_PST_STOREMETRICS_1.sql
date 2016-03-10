--------------------------------------------------------
--  DDL for Procedure U_60_PST_STOREMETRICS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_60_PST_STOREMETRICS" as

begin

EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

delete /*+ parallel (a,8) */ udt_skumetric_dy a 
where a.simulation_name = 'AD';
commit;

insert into udt_skumetric_dy (eff, category, item, loc, dur, value, currencyuom, qtyuom, simulation_name)
    select eff, category, item, loc, dur, value, currencyuom, qtyuom, simulation_name
    from sim_skumetric
    where simulation_name = 'AD';
commit;

delete /*+ parallel (a,8) */ udt_sourcingmetric_dy a 
where a.simulation_name = 'AD';
commit;

insert into udt_sourcingmetric_dy (sourcing, item, dest, source, eff, category, value, dur, currencyuom, qtyuom, simulation_name)
    select sourcing, item, dest, source, eff, category, value, dur, currencyuom, qtyuom, simulation_name
    from sim_sourcingmetric
    where simulation_name = 'AD';

commit;

delete /*+ parallel (a,8) */ udt_productionmetric_dy a 
where a.simulation_name = 'AD';

commit;

insert into udt_productionmetric_dy (productionmethod, item, loc, eff, category, value, dur, outputitem, currencyuom, qtyuom, simulation_name)
    select productionmethod, item, loc, eff, category, value, dur, outputitem, currencyuom, qtyuom, simulation_name
    from sim_productionmetric
    where simulation_name = 'AD';
commit;

--about five minutes; must run this before running u_60_pst_validation

delete /*+ parallel (a,8) */ udt_resmetric_dy a 
where a.simulation_name = 'AD';
commit;

insert into udt_resmetric_dy (eff, category, res, value, dur, currencyuom, timeuom, qtyuom, setup, simulation_name) 
    select eff, category, res, value, dur, currencyuom, timeuom, qtyuom, setup, simulation_name
    from sim_resmetric
    where simulation_name = 'AD';

commit;

delete /*+ parallel (a,8) */ udt_productionresmetric_dy a 
where a.simulation_name = 'AD';
commit;

insert into  udt_productionresmetric_dy  (category, productionmethod, item, loc, res, eff, value, dur, currencyuom, qtyuom, simulation_name)
    select category, productionmethod, item, loc, res, eff, value, dur, currencyuom, qtyuom, simulation_name  
    from sim_productionresmetric
    where simulation_name = 'AD';
commit;

delete /*+ parallel (a,8) */ udt_sourcingresmetric_dy a 
where simulation_name = 'AD';
commit;

insert into udt_sourcingresmetric_dy  (sourcing, item, dest, source, res, eff, category, value, dur, currencyuom, qtyuom, simulation_name)
    select sourcing, item, dest, source, res, eff, category, value, dur, currencyuom, qtyuom, simulation_name
    from sim_sourcingresmetric
    where simulation_name = 'AD';

commit;

EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';

end;
