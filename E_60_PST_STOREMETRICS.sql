--------------------------------------------------------
--  DDL for Procedure E_60_PST_STOREMETRICS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."E_60_PST_STOREMETRICS" as

begin

EXECUTE IMMEDIATE 'ALTER SESSION ENABLE PARALLEL DML';

delete /*+ parallel (a,8) */ udt_skumetric_dy a 
where a.simulation_name = 'ED';
commit;

insert into udt_skumetric_dy (eff, category, item, loc, dur, value, currencyuom, qtyuom, simulation_name)
    select eff, category, item, loc, dur, value, currencyuom, qtyuom, simulation_name
    from sim_skumetric
    where simulation_name = 'ED';
commit;
--

/*
execute immediate 'truncate table udt_skumetric_dy';

insert into udt_skumetric_dy

select *  
from skumetric;

commit;
*/

--
delete /*+ parallel (a,8) */ udt_sourcingmetric_dy a 
where a.simulation_name = 'ED';
commit;

insert into udt_sourcingmetric_dy (sourcing, item, dest, source, eff, category, value, dur, currencyuom, qtyuom, simulation_name)
    select sourcing, item, dest, source, eff, category, value, dur, currencyuom, qtyuom, simulation_name
    from sim_sourcingmetric
    where simulation_name = 'ED';

commit;
--

/*
execute immediate 'truncate table udt_sourcingmetric_dy';

insert into udt_sourcingmetric_dy

select *  
from sourcingmetric;

commit;

*/

--
delete /*+ parallel (a,8) */ udt_productionmetric_dy a 
where a.simulation_name = 'ED';

commit;

insert into udt_productionmetric_dy (productionmethod, item, loc, eff, category, value, dur, outputitem, currencyuom, qtyuom, simulation_name)
    select productionmethod, item, loc, eff, category, value, dur, outputitem, currencyuom, qtyuom, simulation_name
    from sim_productionmetric
    where simulation_name = 'ED';
commit;
--
/*
execute immediate 'truncate table udt_productionmetric_dy';

insert into udt_productionmetric_dy

select *  
from productionmetric;

commit;
*/

EXECUTE IMMEDIATE 'ALTER SESSION DISABLE PARALLEL DML';

end;
