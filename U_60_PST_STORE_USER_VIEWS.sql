--------------------------------------------------------
--  DDL for Procedure U_60_PST_STORE_USER_VIEWS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_60_PST_STORE_USER_VIEWS" as

begin

/* Update the Demand Detail Report Table */
execute immediate 'truncate table udt_demand_detail_report';
insert into udt_demand_detail_report
select * from udv_demand_detail_report;
commit;

/* Update the udt_skuconstraint_temp table as consequently udv_skuconstraint_wide */
execute immediate 'truncate table udt_skuconstraint_temp';
insert into udt_skuconstraint_temp
( eff, loc, item, category,  dur, policy, qtyuom, qty )
(
select dates.eff eff, skc.loc, skc.item, skc.category, skc.dur, skc.policy, skc.qtyuom, 0
from 
(select distinct eff.eff
from skuconstraint eff
where eff.eff > sysdate -1
  and category in (1,6,10)
 )dates ,
 ( select distinct k.loc, k.item, k.category, k.policy, k.qtyuom, k.dur
 from skuconstraint k, loc l
 where k.category  in (1,6,10)
 and l.loc=k.loc 
 and l.u_area='NA'
 ) skc
);

commit;

update udt_skuconstraint_temp tmp
set qty = ( select skc.qty
            from skuconstraint skc
            where skc.loc=tmp.loc
              and skc.item=tmp.item
              and skc.eff = tmp.eff
              and skc.category=tmp.category
              and skc.qtyuom=tmp.qtyuom
          )
where exists ( select skc.qty
            from skuconstraint skc
            where skc.loc=tmp.loc
              and skc.item=tmp.item
              and skc.eff = tmp.eff
              and skc.category=tmp.category
              and skc.qtyuom=tmp.qtyuom
          );
commit;






execute immediate 'truncate table udt_fcsted_colls_not_setup';
insert into udt_fcsted_colls_not_setup
select * from udv_fcsted_colls_not_setup;
commit;

end;
