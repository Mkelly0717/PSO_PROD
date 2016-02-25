--------------------------------------------------------
--  DDL for Procedure U_15_SKU_DAILY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_15_SKU_DAILY" as

begin

--updated (for NA - 10/20/105)
-- must run store sku projections first 

delete skuconstraint where loc in (select loc from loc where u_area = 'NA');

commit;

--category 1 totdmd and category 6 mininflow / custorder

insert into skuconstraint (item, loc, eff, dur, category, policy, qtyuom, qty)

select item, loc, startdate eff, 1440*1 dur, category, 1 policy, 18 qtyuom, qty
    from 

        (select s.item, s.loc, 1 category, trunc(s.startdate) startdate, round(s.adjalloctotfcst, 1)+round(s.adjfcstcustorders, 1)  qty
        from skuprojstatic s, item i, loc l,
        
            (select distinct item, skuloc
            from dfutoskufcst
            where dmdgroup = 'ISS'
            ) f
        
        where s.item = i.item
        and i.u_stock = 'C'
        and s.loc = l.loc
        and l.u_area = 'NA' 
        and l.loc_type = 3
        and s.item = f.item
        and s.loc = f.skuloc
        and trunc(s.startdate) <=  (select min(startdate)+14 from skuprojstatic)

        union
        
        select s.item, s.loc, 6 category, trunc(s.startdate) startdate, round(s.adjfcstcustorders, 1)  qty
        from skuprojstatic s, item i, loc l
        where s.item = i.item
        and i.u_stock = 'C'
        and s.loc = l.loc
        and l.u_area = 'NA' 
        and l.loc_type = 3
        and trunc(s.startdate) <=  (select min(startdate)+14 from skuprojstatic)
        
        union
        
        select s.item, s.loc, 10 category, trunc(s.startdate) startdate, round(s.adjalloctotfcst, 1)+round(s.adjfcstcustorders, 1)  qty --category 1 or 10 ?? 12/15/2015
        from skuprojstatic s, item i, loc l,
        
            (select distinct item, skuloc
            from dfutoskufcst
            where dmdgroup = 'TPM'
            ) f
        
        where s.item = i.item
        and i.u_stock in ('A')
        and s.loc = l.loc
        and l.u_area = 'NA' 
        and l.loc_type = 4
        and s.item = f.item
        and s.loc = f.skuloc
        and trunc(s.startdate) <=  (select min(startdate)+14 from skuprojstatic)
        
        union
        
        --category 10 schedrcpts / collections 
        
        select s.item, s.loc, 10 category, trunc(s.startdate) startdate, round(s.adjalloctotfcst, 1)+round(s.adjfcstcustorders, 1)  qty
        from skuprojstatic s, item i, loc l,
        
            (select distinct item, skuloc
            from dfutoskufcst
            where dmdgroup = 'COL'
            ) f
        
        where s.item = i.item
        and i.u_stock = 'A'
        and s.loc = l.loc
        and l.u_area = 'NA' 
        and l.loc_type = 3
        and s.item = f.item
        and s.loc = f.skuloc
        and trunc(s.startdate) <=  (select min(startdate)+14 from skuprojstatic)
        );

commit;

--assign differing unmet demand penalties favoring orders over forecast, (need to favor CPU as well)  

delete skupenalty where loc in (select loc from loc where u_area = 'NA');

commit;

insert into skupenalty (eff, rate, category, item, loc, currencyuom, qtyuom)

select scpomgr.u_jan1970 eff, 
    case when u.category = 1 then 190 else 200 end rate,   
    case when u.category = 1 then 101 else 106 end category, u.item, u.loc, 15 currencyuom, 18 qtyuom
from 

    (select distinct item, loc, category from skuconstraint where category in ( 1, 6) and loc in (select loc from loc where u_area = 'NA')
    ) u;

commit;

--category 10 vl.sourcestatus = 3; in-transit deliveries

insert into skuconstraint (eff, item, loc, category, dur, policy, qtyuom, qty)

select distinct vll.schedarrivdate eff, vll.item, vll.dest, 10 category, 1440 dur, 1 policy, 18 qtyuom, round(sum(vll.qty), 1) qty
from vehicleloadline vll, vehicleload vl, loc l
where vl.loadid = vll.loadid
and vll.schedarrivdate >= trunc(sysdate)
and vll.dest = l.loc
and l.u_area = 'NA'  
and vl.sourcestatus = 3
and vl.deststatus = 1
group by vll.item, vll.dest, vll.schedarrivdate;

commit;

--execute immediate 'truncate table skuprojstatic';

--category 5 safety stock constraints

insert into skuconstraint ( item, loc, eff, dur, category , policy, qtyuom , qty)
    
select distinct item
  , loc
  , start_eff eff
  , 1440*1*14 dur
  , 5 category
  , 1 policy
  , 18 qtyuom
  , qty
from
    (select s.item
      , s.loc
      , i.u_materialcode
      , i.u_qualitybatch
      , i.u_stock
      , k.start_eff
      , t.calculated_stock qty
      from udt_stock_target_na t
      , sku s
      , loc l
      , item i
      , (select trunc(min(eff)) start_eff from skuconstraint
       ) k
    where t.matcode = i.u_materialcode
        and t.batch = i.u_qualitybatch
        and t.stock = i.u_stock-- and t.loc = 'US1M'
        and i.u_qualitybatch <> 'RUNEW'
        and t.loc = l.loc
        and l.u_area = 'NA'
        and l.loc_type in (2, 4, 5)
        and s.item = i.item
        and s.loc = t.loc
    ) u; 
    
commit;

insert into skupenalty (eff, rate, category, item, loc, currencyuom, qtyuom)

select distinct v_init_eff_date eff
  , 40 rate
  , 105 category
  , u.item
  , u.loc
  , 15 currencyuom
  , 18 qtyuom
from
    (select distinct item
      , loc
      , category
    from skuconstraint
    where category in ( 5)
    and loc in (select loc from loc where u_area = 'NA')
    ) u;
    
commit;

end;
