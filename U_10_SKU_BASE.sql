--------------------------------------------------------
--  DDL for Procedure U_10_SKU_BASE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_10_SKU_BASE" as
/* 
    1: Create Items.
    2: Create A Stock Sku's.
    3: Create B Stock Sku's.
    4: Create C Stock at Storage Locations.
    5: Create C Stock Sku's at Manufacturing Locations.
    6: Create C Stock Sku's at Type 2 and 4 plants locaitons.
    7: Create A and C stock Sku's for Customers with a FCST for AI or RU.
    8: Create all Items At TPM's (Type = 4) In Weekly CFWD switch is off.
    9: Create all Sku's at all Source/Dest where plant status file is 1.
   10: Truncate dfutoskufcst. Create dfutoskufcst for Non RUNEW Items.
   11: Create dfutoskufcst records for RUNEW where LOC:U_RUNEW_CUST = 1.
   12: Create dfutoskufcst records for Service Centers.
   13: Create Cal Records.
   14: Create CalData Records.
   15: Create SkuDemandParameter records.
   16: Create SkuDeployment records.
   17: Create SkuPlanningParam records.
   18: Create SkuSafteyStock records.
   19: Update Sku:OHPOST
*/

v_initial_date date;

begin

select v_init_eff_date into v_initial_date from dual;
/******************************************************************
** Part 1: Create Items                                           *

!! 10/7/2015 - JB - line 420 remove comment once UDC's are created  !!
 
******************************************************************/
insert into igpmgr.intins_item 
(integration_jobid, item, descr, uom, defaultuom, u_materialcode
    , u_qualitybatch, u_stock
)
SELECT 'U_10_SKU_BASE_PART1' 
    ,y.item, ' ' descr, ' ' uom, 18 defaultuom, substr(y.item, 1, 4) u_materialcode
    ,substr(y.item, 5, 55) u_qualitybatch, 
    case when substr(y.item, -2) = 'AR' then 'B'
            when substr(y.item, -2) = 'AI' then 'A' else 'C' end u_stock
from item i, 

(select distinct item from udt_yield_na
 where maxcap > 0
   and yield > 0
union
select '4001AI' item from dual 
) y

where y.item = i.item(+)
and i.item is null;

commit;


/******************************************************************
** Part 2: Create A stock items 4001AI 
**         at PLANT LOCATION TYPES location types 2, 4, and 5)
******************************************************************/
insert into igpmgr.intins_sku 
(integration_jobid, item, loc, oh, replentype, netchgsw, ohpost
    ,planlevel, sourcinggroup, qtyuom, currencyuom, storablesw
    ,enablesw,   timeuom,  ff_trigger_control, infcarryfwdsw
    ,minohcovrule, targetohcovrule, ltdgroup, infinitesupplysw
    , mpbatchnum, seqintenablesw, itemstoregrade, rpbatchnum
)
select 'U_10_SKU_BASE_PART2'
   ,loc_item.item, loc_item.loc, 0 oh, 5 replentype, 1 netchgsw, v_initial_date ohpost
   ,-1 planlevel, ' ' sourcinggroup, 18 qtyuom, 15 currencyuom
   ,1 storablesw, 1 enablesw, 35 timeuom, ''  ff_trigger_control
   ,0 infcarryfwdsw, 1 minohcovrule, 1 targetohcovrule, ' ' ltdgroup
   ,0 infinitesupplysw, 0 mpbatchnum, 0 seqintenablesw, -1 itemstoregrade
   , 0 rpbatchnum
from sku s,
( select l.loc, i.item
    from loc l, item i
   where l.loc_type in ( 2, 4, 5)
     and l.u_area='NA'
     and i.enablesw = 1
     and l.enablesw = 1
     and i.u_stock in ('A')
     and i.item = '4001AI'
) loc_item  
where s.item(+)=loc_item.item
  and s.loc(+) = loc_item.loc
  and s.item is null;

commit;

/******************************************************************
** Part 3: Create B stock items 4001AR 
**         at PLANT LOCATION TYPES location types 2, 4, and 5)
*****************************************************************/
insert into igpmgr.intins_sku 
(integration_jobid, item, loc, oh, replentype, netchgsw, ohpost
    ,planlevel, sourcinggroup, qtyuom, currencyuom, storablesw
    ,enablesw,   timeuom,  ff_trigger_control, infcarryfwdsw
    ,minohcovrule, targetohcovrule, ltdgroup, infinitesupplysw
    , mpbatchnum, seqintenablesw, itemstoregrade, rpbatchnum
)
select 'U_10_SKU_BASE_PART3'
   ,loc_item.item, loc_item.loc, 0 oh, 5 replentype, 1 netchgsw, v_initial_date ohpost
   ,-1 planlevel, ' ' sourcinggroup, 18 qtyuom, 15 currencyuom
   ,1 storablesw, 1 enablesw, 35 timeuom, ''  ff_trigger_control
   ,0 infcarryfwdsw, 1 minohcovrule, 1 targetohcovrule, ' ' ltdgroup
   ,0 infinitesupplysw, 0 mpbatchnum, 0 seqintenablesw, -1 itemstoregrade
   , 0 rpbatchnum
from sku s,
( select l.loc, i.item
    from loc l, item i
   where l.loc_type in ( 2, 4, 5)
     and l.u_area='NA'
     and i.enablesw = 1
     and l.enablesw = 1
     and i.u_stock in ('B')
     and i.item = '4055AR'
) loc_item  
where s.item(+)=loc_item.item
  and s.loc(+) = loc_item.loc
  and s.item is null;
  
commit;


/******************************************************************
** Part 4: Create all RU SKUs (C Stock) at Storage Locations.
******************************************************************/
insert into igpmgr.intins_sku 
(integration_jobid, item, loc, oh, replentype, netchgsw, ohpost
    ,planlevel, sourcinggroup, qtyuom, currencyuom, storablesw
    ,enablesw, timeuom, ff_trigger_control, infcarryfwdsw, minohcovrule
    ,targetohcovrule, ltdgroup, infinitesupplysw, mpbatchnum
    ,seqintenablesw, itemstoregrade, rpbatchnum
)
select 'U_10_SKU_BASE_PART4'
   ,i.item, l.loc, 0 oh, 5 replentype, 1 netchgsw, v_initial_date ohpost
   ,-1 planlevel, ' ' sourcinggroup, 18 qtyuom, 15 currencyuom, 1 storablesw
   ,1 enablesw, 35 timeuom, ''  ff_trigger_control, 0 infcarryfwdsw
   ,1 minohcovrule, 1 targetohcovrule, ' ' ltdgroup, 0 infinitesupplysw
   , 0 mpbatchnum, 0 seqintenablesw, -1 itemstoregrade, 0 rpbatchnum
from loc l, item i
where l.loc_type = 5
  and l.u_area='NA'
  and i.u_stock='C'
  and i.enablesw = 1
  and l.enablesw = 1 
  and not exists ( select 1
                     from sku sku
                    where sku.loc=l.loc
                      and sku.item=i.item
                  );

commit;

/******************************************************************
** Part 5: Create SKU's for Manufacturing Locations(loc_type=1).
******************************************************************/
insert into igpmgr.intins_sku 
(integration_jobid, item, loc, oh, replentype, netchgsw, ohpost
    ,planlevel, sourcinggroup, qtyuom, currencyuom, storablesw
    ,enablesw, timeuom, ff_trigger_control, infcarryfwdsw
    ,minohcovrule, targetohcovrule, ltdgroup, infinitesupplysw
    ,mpbatchnum, seqintenablesw, itemstoregrade, rpbatchnum
)
select 'U_10_SKU_BASE_PART5'
  ,i.item , l.loc , 0 oh , 5 replentype , 1 netchgsw , v_initial_date ohpost
  ,-1 planlevel , ' ' sourcinggroup , 18 qtyuom , 15 currencyuom 
  ,1 storablesw , 1 enablesw , 35 timeuom , '' ff_trigger_control 
  ,0 infcarryfwdsw , 1 minohcovrule , 1 targetohcovrule , ' ' ltdgroup 
  ,0 infinitesupplysw , 0 mpbatchnum , 0 seqintenablesw , -1 itemstoregrade 
  ,0 rpbatchnum
from loc l
  , item i
where i.item in ( '4055RUNEW' 
                 ,'4055RUPLUS' 
                 ,'4055RUCUST' 
                 ,'4055RUPREMIUM' 
                )
    and l.loc_type = '1'
    and l.u_area='NA'
    and l.enablesw=1
    and i.enablesw=1
    and not exists
    ( select 1 from sku sku where sku.loc=l.loc and sku.item=i.item
    ); 

commit;



/******************************************************************
** Part 6: Create RU (C Stock) SKUS at type 2 and 4 service centers
**         where udt_yield_na maxcap and yield are > 0 
**         and udt_plant_status is 1 for sort or repair
**         or heat treat respectively.
******************************************************************/
insert into igpmgr.intins_sku 
(integration_jobid, item, loc, oh, replentype, netchgsw, ohpost
    ,planlevel, sourcinggroup, qtyuom, currencyuom, storablesw
    ,enablesw, timeuom, ff_trigger_control, infcarryfwdsw, minohcovrule
    ,targetohcovrule, ltdgroup, infinitesupplysw, mpbatchnum
    ,seqintenablesw, itemstoregrade, rpbatchnum
)
select distinct 'U_10_SKU_BASE_PART6'
   ,i.item, l.loc, 0 oh, 5 replentype, 1 netchgsw, v_initial_date ohpost
   ,-1 planlevel, ' ' sourcinggroup, 18 qtyuom, 15 currencyuom, 1 storablesw
   ,1 enablesw, 35 timeuom, ''  ff_trigger_control, 0 infcarryfwdsw
   ,1 minohcovrule, 1 targetohcovrule, ' ' ltdgroup, 0 infinitesupplysw
   , 0 mpbatchnum, 0 seqintenablesw, -1 itemstoregrade, 0 rpbatchnum
from loc l, item i, udt_yield_na yield
where l.loc_type in (2, 4)
  and l.u_area='NA'
  and i.u_stock='C'
  and i.enablesw = 1
  and l.enablesw = 1 
  and not exists ( select 1
                     from sku sku
                    where sku.loc=l.loc
                      and sku.item=i.item
                  )
  and yield.loc=l.loc
  and yield.item=i.item
  and yield.maxcap > 0
  and yield.yield > 0
  and exists ( select 1
                 from udt_plant_status ps
                where ps.loc=yield.loc
                  and ps.status=1
                  and (   (yield.productionmethod='INS' and ps.res='SORT')
                       or 
                          (yield.productionmethod='REP' and ps.res='REPAIR'
                           )
                       or
                          (yield.productionmethod='HTR' and ps.res='HEATTREAT')
                      )
              );

commit;


/******************************************************************
** Part 7: Create A and C stock SKUS for Cusomers loc_type 3 
**         which have a forecast for AI and/or RU within the 
**         FCST period.
**         ==> Infinit Carry Switch to 0  for WEEEKLY VERSION
******************************************************************/
insert into igpmgr.intins_sku 
( integration_jobid, item, loc, oh, replentype, netchgsw, ohpost
    ,planlevel, sourcinggroup, qtyuom, currencyuom, storablesw
    ,enablesw, timeuom, ff_trigger_control, infcarryfwdsw, minohcovrule
    ,targetohcovrule, ltdgroup, infinitesupplysw, mpbatchnum, seqintenablesw
    ,itemstoregrade, rpbatchnum
)
select 'U_10_SKU_BASE_PART7'
    , u.item, u.loc, 0 oh, 5 replentype, 1 netchgsw, v_initial_date ohpost
    ,-1 planlevel, ' ' sourcinggroup, 18 qtyuom, 15 currencyuom, 1 storablesw
    ,1 enablesw, 35 timeuom, ''  ff_trigger_control, u.infcarryfwdsw
    ,1 minohcovrule, 1 targetohcovrule, ' ' ltdgroup, 0 infinitesupplysw
    ,0 mpbatchnum, 0 seqintenablesw, -1 itemstoregrade, 0 rpbatchnum
from 

    (select f.item, f.loc, f.infcarryfwdsw
    from sku s, 

        (select  distinct f.dmdunit item, f.loc, 
            0 infcarryfwdsw
--           case when i.u_stock = 'C' then 1 else 0 end infcarryfwdsw
        from fcst f, loc l, item i, dfuview v
        where f.startdate 
                 between v_demand_start_date and next_day(v_demand_end_date,'SAT')
        and l.u_area = 'NA'
        and l.loc_type = 3 
        and l.enablesw = 1 
        and i.u_stock in ('A', 'C')
        and i.enablesw = 1
        and f.dmdunit = i.item 
        and f.dmdgroup in ('ISS', 'COL')
        and f.loc = l.loc  
        and f.qty > 0
        and f.dmdunit = v.dmdunit
        and f.dmdgroup = v.dmdgroup
        and f.loc = v.loc
        and v.u_dfulevel = 0
        ) f
        
    where f.item = s.item(+)
    and f.loc = s.loc(+)
    and s.item is null
) u;
commit;


/******************************************************************
** Part 8: Create all items with a fcst 
**               at tpm locations ( loc_type=4)
**         ==> Infinit Carry Switch to 0  for WEEEKLY VERSION
******************************************************************/
insert into igpmgr.intins_sku 
( integration_jobid, item, loc, oh, replentype, netchgsw, ohpost
    ,planlevel, sourcinggroup, qtyuom, currencyuom, storablesw
    ,enablesw, timeuom, ff_trigger_control, infcarryfwdsw, minohcovrule
    ,targetohcovrule, ltdgroup, infinitesupplysw, mpbatchnum, seqintenablesw
    ,itemstoregrade, rpbatchnum
)
select 'U_10_SKU_BASE_PART8'
    , u.item, u.loc, 0 oh, 5 replentype, 1 netchgsw, v_initial_date ohpost
    ,-1 planlevel, ' ' sourcinggroup, 18 qtyuom, 15 currencyuom, 1 storablesw
    ,1 enablesw, 35 timeuom, ''  ff_trigger_control, u.infcarryfwdsw
    ,1 minohcovrule, 1 targetohcovrule, ' ' ltdgroup, 0 infinitesupplysw
    ,0 mpbatchnum, 0 seqintenablesw, -1 itemstoregrade, 0 rpbatchnum
from 

    (select f.item, f.loc, f.infcarryfwdsw
    from sku s, 

        (select  distinct f.dmdunit item, f.loc, 
            0 infcarryfwdsw
--           case when i.u_stock = 'C' then 1 else 0 end infcarryfwdsw
        from fcst f, loc l, item i, dfuview v
        where f.startdate 
                between v_demand_start_date and next_day(v_demand_end_date,'SAT')
        and l.u_area = 'NA'
        and l.loc_type in (2,4)
        and l.enablesw = 1 
        and i.u_stock in ('A', 'B', 'C')
        and i.enablesw = 1
        and f.dmdunit = i.item 
        and f.loc = l.loc  
        and f.qty > 0
        and f.dmdunit = v.dmdunit
        and f.dmdgroup like ('%TPM%')
        and f.dmdgroup = v.dmdgroup
        and f.loc = v.loc
        and v.u_dfulevel = 1
        ) f
        
    where f.item = s.item(+)
    and f.loc = s.loc(+)
    and s.item is null
) u;

commit;

/******************************************************************
** Part 9: Create all SKU's at location with ARSOURCE/ARDEST (C stock)
**         and/or having RUSOURCE/RUDEST for that Stock type (B stock)
******************************************************************/
insert into igpmgr.intins_sku 
( integration_jobid, item, loc, oh, replentype, netchgsw, ohpost
    ,planlevel, sourcinggroup, qtyuom, currencyuom, storablesw
    ,enablesw, timeuom, ff_trigger_control, infcarryfwdsw, minohcovrule
    ,targetohcovrule, ltdgroup, infinitesupplysw, mpbatchnum, seqintenablesw
    ,itemstoregrade, rpbatchnum
)
select 'U_10_SKU_BASE_PART9'
    , i.item, l.loc, 0 oh, 5 replentype, 1 netchgsw, v_initial_date ohpost
    ,-1 planlevel, ' ' sourcinggroup, 18 qtyuom, 15 currencyuom, 1 storablesw
    ,1 enablesw, 35 timeuom, ''  ff_trigger_control, 0 infcarryfwdsw
    ,1 minohcovrule, 1 targetohcovrule, ' ' ltdgroup, 0 infinitesupplysw
    ,0 mpbatchnum, 0 seqintenablesw, -1 itemstoregrade, 0 rpbatchnum
from udt_plant_status ps, loc l, item i
where ps.status=1
  and l.loc=ps.loc
  and l.u_area='NA'
  and l.loc_type in (2,4,5)
  and l.enablesw=1
  and i.u_stock = 'C'
  and i.enablesw=1
  and ps.u_stock = 'C' 
  and i.u_stock='C'
  and i.u_materialcode = '4055'
  and (  ps.res like ('%RUSOURCE') or ps.res like ('%RUDEST') )
  and not exists ( select 1
                     from sku sku
                    where sku.loc=l.loc
                      and sku.item=i.item
                 );
commit;

/******************************************************************
** Part 10: truncate and re-create dfutoskufcst 
******************************************************************/
delete dfutoskufcst
where skuloc in
    (select loc from loc where u_area = 'NA');
    
commit;

insert into igpmgr.intups_dfutoskufcst 
( integration_jobid, dmdunit, item, dmdgroup, dfuloc, skuloc
    ,startdate, dur, type, supersedesw, ff_trigger_control, totfcst
)
select distinct 'U_10_SKU_BASE_PART10'
        ,f.dmdunit, f.item, f.dmdgroup, f.dfuloc, f.skuloc, f.startdate
        ,f.dur, f.type, f.supersedesw, f.ff_trigger_control, f.totfcst
from sku s, item i, loc l, 

    (select distinct f.dmdunit, f.dmdunit item, f.dmdgroup, f.loc dfuloc, f.loc skuloc, startdate, dur, 1 type, 0 supersedesw, ''  ff_trigger_control, sum(qty) totfcst
    from fcst f, dfuview v
    where f.startdate between v_demand_start_date 
                          and next_day(v_demand_end_date,'SAT')
    and f.dmdgroup in ('ISS', 'COL')
    and f.dmdunit = v.dmdunit
    and f.dmdgroup = v.dmdgroup
    and f.loc = v.loc
    and v.u_dfulevel = 0
    and f.dmdunit <> '4055RUNEW'
     group by f.dmdunit, f.dmdgroup, f.loc,  f.startdate, dur, 1, 0
    ) f
        
where f.item = s.item
and f.skuloc = s.loc
and f.item = i.item
and i.u_stock in ('A', 'C')
and i.enablesw=1
and f.skuloc = l.loc
and l.loc_type = 3
and l.u_area = 'NA'
and l.enablesw=1;

commit;


/******************************************************************
** Part 11: create forecast records for RUNEW only where permitted
**         ,LOC:U_RUNEW_CUST = 1 truncate and re-create dfutoskufcst 
******************************************************************/
insert into igpmgr.intins_dfutoskufcst 
( integration_jobid, dmdunit, item, dmdgroup, dfuloc, skuloc, startdate
    ,dur, type , supersedesw, ff_trigger_control, totfcst
)
 
select distinct 'U_10_SKU_BASE_PART11'
    ,f.dmdunit, f.item, f.dmdgroup, f.dfuloc, f.skuloc, f.startdate
    ,f.dur, f.type, f.supersedesw, f.ff_trigger_control, f.totfcst
from sku s, item i,  

    (select distinct f.dmdunit, f.dmdunit item, f.dmdgroup, f.loc dfuloc, f.loc skuloc, startdate, dur, 1 type, 0 supersedesw, ''  ff_trigger_control, sum(qty) totfcst
    from fcst f, dfuview v, loc l
    where f.startdate between v_demand_start_date and next_day(v_demand_end_date,'SAT')
    and f.dmdgroup in ('ISS')
    and f.dmdunit = v.dmdunit
    and f.dmdgroup = v.dmdgroup
    and f.loc = v.loc
    and v.u_dfulevel = 0
    and f.loc = l.loc
    and l.u_runew_cust = 1  
    and f.dmdunit = '4055RUNEW'
    and l.loc_type = 3
    and l.u_area = 'NA'
    group by f.dmdunit, f.dmdgroup, f.loc,  f.startdate, dur, 1, 0
    ) f
        
where f.item = s.item
and f.skuloc = s.loc
and f.item = i.item
and i.u_stock in ('C');

commit;

/******************************************************************
** Part 12: create forecast records at LOC_TYPE 2 locations for 
**         supply of TPM; A, B and C stock are all supply 
**        (CAT10 SKU constraints) 
******************************************************************/
insert into igpmgr.intins_dfutoskufcst 
( integration_jobid, dmdunit, item, dmdgroup, dfuloc, skuloc
    ,startdate, dur, type, supersedesw, ff_trigger_control, totfcst
)
select distinct 'U_10_SKU_BASE_PART12'
    ,f.dmdunit, f.item, f.dmdgroup, f.dfuloc, f.skuloc, f.startdate
    ,f.dur, f.type, f.supersedesw, f.ff_trigger_control, f.totfcst
from sku s, item i, loc l, 

    (select distinct f.dmdunit
       , f.loc
       , case f.dmdunit
           when 'PALLET' then '4001AI'
           else '4001AI'
         end item, f.dmdgroup, f.loc dfuloc
              ,f.loc skuloc , startdate, dur, 1 type, 0 supersedesw
              ,''  ff_trigger_control, sum(qty) totfcst
    from fcst f, dfuview v, loc l
    where f.startdate between v_demand_start_date and next_day(v_demand_end_date,'SAT')
    and f.dmdgroup in ('TPM')
    and f.dmdunit = v.dmdunit
    and f.dmdgroup = v.dmdgroup
    and f.loc = v.loc
    and v.u_dfulevel = 1
    and l.loc=f.loc
    and l.loc_type = 4
    and l.u_area='NA'
    and l.enablesw=1
    group by f.dmdunit, f.dmdgroup, f.loc,  f.startdate, dur, 1, 0
    order by dmdunit, skuloc, startdate
    ) f
        
where f.item = s.item
and f.skuloc = s.loc
and f.item = i.item
and i.u_stock = 'A'
and i.enablesw=1
and f.skuloc = l.loc
and l.loc_type = 4
and l.u_area = 'NA'
and l.enablesw=1;
commit;

/******************************************************************
** Part 13: Create Cal Records
******************************************************************/
insert into igpmgr.intins_cal 
( 
   integration_jobid, cal, descr, type, master, numfcstper, rollingsw
)

select 'U_10_SKU_BASE_PART13'
        ,s.loc||'_'||s.item cal, 'Allocation Calendar' descr
        ,7 type, ' ' master, 0 numfcstper, 0 rollingsw 
from sku s,

    (select cal, substr(cal, 1, instr(cal, '_')-1) loc, substr(cal, instr(cal, '_')+1, 55) item
    from cal
    where type =  7
    and cal <> ' '
    and instr(cal, '_') <> 0) c

where s.item = c.item(+)
and s.loc = c.loc(+)
and c.item is null;

commit;

/******************************************************************
** Part 14: Create Caldata Records
******************************************************************/
insert into igpmgr.intins_caldata
(
  integration_jobid, cal, altcal, eff, opt, repeat, avail, descr
   ,perwgt, allocwgt, covdur
)
select 'U_10_SKU_BASE_PART14'
       ,c.cal, ' ' altcal, v_date_to_eff(v_demand_start_date) eff
       , 6 opt, 0 repeat, 0 avail
       ,'Allocation Calendar' descr, 0 perwgt, 1/7 allocwgt, 0 covdur 
from cal c, caldata cd, sku s
where substr(c.cal, 1, instr(c.cal, '_')-1) = s.loc
and substr(c.cal, instr(c.cal, '_')+1, 55) = s.item
and c.type = 7 
and c.cal = cd.cal(+)
and cd.cal is null;

commit;

/******************************************************************
** Part 15: Create the SKU demand paramters 
******************************************************************/
insert into igpmgr.intins_skudemandparam 
( 
   integration_jobid, item, loc, custorderdur, dmdtodate, fcstadjrule
     ,maxcustordersysdur, proratesw, prorationdur, dmdredid, ccpsw
     ,custorderpriority, fcstmeetearlydur, fcstpriority, fcstmeetlatedur
     ,alloccal, inddmdunitcost, inddmdunitmargin, unitcarcost
     ,ff_trigger_control, fcstconsumptionrule, fcstprimconsdur
     ,fcstsecconsdur, proratebytypesw, alloccalgroup, mastercal, weeklyavghist
)
select 'U_10_SKU_BASE_PART15'
       ,s.item, s.loc, 
    case when l.loc_type = 3 then 1440*4 else 1440*365 end custorderdur, 0 dmdtodate,     
    case when l.loc_type = 3 then 6 
         when l.loc_type = 4 and s.item like '%AI%'  then 1
         else 2 end fcstadjrule, 
    case when l.loc_type = 3 then 1440*10 else 0 end maxcustordersysdur, 0 proratesw
      ,0 prorationdur, ' ' dmdredid, 0 ccpsw, -1 custorderpriority, 0 fcstmeetearlydur
      ,-1 fcstpriority , 0 fcstmeetlatedur, s.loc||'_'||s.item alloccal
      ,0 inddmdunitcost, 0 inddmdunitmargin, 0 unitcarcost, ''  ff_trigger_control
      ,0 fcstconsumptionrule, 0 fcstprimconsdur, 0 fcstsecconsdur
      ,0 proratebytypesw, s.loc||'_'||s.item alloccalgroup, ' ' mastercal, 0 weeklyavghist
from skudemandparam p, sku s, loc l
where s.enablesw = 1
and s.loc = l.loc
and l.u_area = 'NA'
and s.item = p.item(+)
and s.loc = p.loc(+)
and p.item is null;

commit;
/******************************************************************
** Part 16: SKU deployment paramters
******************************************************************/
insert into igpmgr.intins_skudeployparam 
(
  integration_jobid, item, loc, allocstratid, constrrecshipsw
  ,locpriority, minallocdur, pushopt, recshippushopt, recshipsupplyrule
  ,rsallocrule, stockavaildur, dyndepldur, incstkoutcost, initstkoutcost
  ,shortagessfactor, surplusrestockcost, surplusssfactor, shortagedur
  ,unitstocklowcost, unitstockoutcost, enablesubsw, meetprisssw
  ,usesubstsssw, recshipcal, ff_trigger_control, deploydetaillevel
  ,holdbackqty, maxbucketdur, skupriority, secrsallocrule
  ,recshipdur, sourcessrule
)
select 'U_10_SKU_BASE_PART16'
       ,s.item, s.loc, ' ' allocstratid, 0 constrrecshipsw, 1 locpriority
       ,0 minallocdur, 0 pushopt, 1 recshippushopt, 1 recshipsupplyrule
       ,1 rsallocrule, 0 stockavaildur, 0 dyndepldur, 0 incstkoutcost
       ,0 initstkoutcost, 1 shortagessfactor, 0 surplusrestockcost
       ,0 surplusssfactor, 0 shortagedur, 0 unitstocklowcost
       ,0 unitstockoutcost, 0 enablesubsw, 0 meetprisssw, 0 usesubstsssw
       ,' ' recshipcal, ''  ff_trigger_control, 1 deploydetaillevel, 0 holdbackqty
       ,0 maxbucketdur, 0 skupriority, 1 secrsallocrule, 0 recshipdur, 3 sourcessrule
from skudeploymentparam p, sku s
where s.enablesw = 1
and s.item = p.item(+)
and s.loc = p.loc(+)
and p.item is null;

commit;
/******************************************************************
** Part 17: SKU planning Param
******************************************************************/
insert into igpmgr.intins_skuplannparam 
(
    integration_jobid, item, loc, atpdur, depdmdopt, externalskusw
    ,firstreplendate, lastfrzstart, lastplanstart, plandur, planleadtime
    ,planleadtimerule, planshipfrzdur, restrictdur, allocbatchsw
    ,cmpfirmdur, custservicelevel, maxchangefactor, mfgleadtime
    ,recschedrcptsdur, cpppriority, cpplocksw, criticalmaterialsw
    ,aggexcesssupplyrule, aggundersupplyrule, bufferleadtime, maxoh
    ,maxcovdur, drpcovdur, drpfrzdur, drprule, drptimefencedate
    ,drptimefencedur, incdrpqty, mindrpqty, mpscovdur, mfgfrzdur
    ,mpsrule, mpstimefencedate, mpstimefencedur, incmpsqty, minmpsqty
    ,shrinkagefactor, expdate, atprule, prodcal, prodstartdate
    ,prodstopdate, orderingcost, holdingcost, eoq, ff_trigger_control
    ,workingcal, lookaheaddur, orderpointrule, orderskudetailsw
    ,supsdmindmdcovdur,  orderpointminrule, orderpointminqty
    ,orderpointmindur, orderuptolevelmaxrule, orderuptolevelmaxqty
    ,orderuptolevelmaxdur, aggskurule, fwdbuymaxdur, costuom
    ,cumleadtimedur, cumleadtimeadjdur, cumleadtimerule, roundingfactor
    ,limitplanarrivpublishsw, limitplanarrivpublishdur, maxohrule
)

select 'U_10_SKU_BASE_PART17'
    ,s.item, s.loc, 0 atpdur, 3 depdmdopt, 0 externalskusw
    ,v_initial_date firstreplendate, v_initial_date lastfrzstart
    ,v_initial_date lastplanstart, 524160 plandur, 0 planleadtime
    ,2 planleadtimerule, 0 planshipfrzdur, 0 restrictdur, 0 allocbatchsw
    ,0 cmpfirmdur, 0.9 custservicelevel, 1 maxchangefactor, 0 mfgleadtime
    ,0 recschedrcptsdur, 1 cpppriority, 0 cpplocksw, 1 criticalmaterialsw
    ,2 aggexcesssupplyrule, 1 aggundersupplyrule, 0 bufferleadtime
    ,999999999 maxoh, 1048320 maxcovdur, 10080 drpcovdur, 0 drpfrzdur
    ,1 drprule, v_initial_date drptimefencedate, 0 drptimefencedur
    ,1 incdrpqty, 0 mindrpqty, 10080 mpscovdur, 0 mfgfrzdur, 1 mpsrule
    ,v_initial_date mpstimefencedate, 0 mpstimefencedur, 1 incmpsqty
    ,0 minmpsqty, 0 shrinkagefactor, v_initial_date expdate, 1 atprule
    ,' ' prodcal, v_initial_date prodstartdate
    ,v_initial_date prodstopdate, 1 orderingcost, 1 holdingcost
    ,1 eoq, ''  ff_trigger_control, ' ' workingcal, 0 lookaheaddur
    ,2 orderpointrule, 0 orderskudetailsw, 1048320 supsdmindmdcovdur
    ,1 orderpointminrule, 0 orderpointminqty, 0 orderpointmindur
    ,1 orderuptolevelmaxrule, 0 orderuptolevelmaxqty
    ,0 orderuptolevelmaxdur, 0 aggskurule, 0 fwdbuymaxdur, 0 costuom
    ,0 cumleadtimedur, 0 cumleadtimeadjdur, 1 cumleadtimerule
    ,0 roundingfactor, 0 limitplanarrivpublishsw
    ,0 limitplanarrivpublishdur, 1 maxohrule
from skuplanningparam p, sku s
where s.enablesw = 1
and s.item = p.item(+)
and s.loc = p.loc(+)
and p.item is null;

commit;
/******************************************************************
** Part 18: SKU safteystock parameters
******************************************************************/

insert into igpmgr.intins_skussparam 
(
    integration_jobid, item, loc, avgleadtime, avgnumlines, leadtimesd
    ,maxss, minss, mfgleadtimerule, mselag, mseper, netfcstmsesmconst
    ,numreplenyr, statssadjopt, sscov, ssrule, statsscsl, ssmeetearlydur
    ,sspriority, tohrule, sstemplate, dmddisttype, cslmetric
    ,calcstatssrule, avgdmdcal, avgdmdlookbwddur, avgdmdlookfwddur
    ,calcmserule, dmdcal, dmdpostdate, fcstdur, ff_trigger_control
    ,statsscovlimitdur, supersedesssw, msemaskopt, msemaskminval
    ,msemaskmaxval, dmdcorrelationfactor, accumdur, mseabstolerancelimit
    ,dmdalloccal, sspresentationopt, maxsscovskipdur, maxssfactor
    ,msemodelopt, sscovusebaseonlysw, arrivalpostdate, shipdatadur
    ,shiplag, orderlag, orderpostdate, orderdatadur, allowearlyarrivsw
    ,allowearlyordersw, csltemplate
)
select 'U_10_SKU_BASE_PART18'
    ,s.item, s.loc, 0 avgleadtime, 0 avgnumlines, 0 leadtimesd
    ,999999999 maxss, 0 minss, 1 mfgleadtimerule, 0 mselag, 0 mseper
    ,0 netfcstmsesmconst, 12 numreplenyr, 1 statssadjopt, 0 sscov
    ,1 ssrule, 0 statsscsl, 0 ssmeetearlydur, -1 sspriority, 3 tohrule
    ,' ' sstemplate, 1 dmddisttype, 2 cslmetric, 1 calcstatssrule
    ,' ' avgdmdcal, 0 avgdmdlookbwddur, 525600 avgdmdlookfwddur
    ,1 calcmserule, ' ' dmdcal, v_initial_date dmdpostdate
    ,10080 fcstdur, ''  ff_trigger_control, 0 statsscovlimitdur
    ,1 supersedesssw, 0 msemaskopt, 0 msemaskminval, 100 msemaskmaxval
    ,1 dmdcorrelationfactor, 1440 accumdur, 0 mseabstolerancelimit
    ,' ' dmdalloccal, 1 sspresentationopt, 0 maxsscovskipdur
    ,0 maxssfactor, 1 msemodelopt, 0 sscovusebaseonlysw
    ,v_initial_date arrivalpostdate, 0 shipdatadur, 0 shiplag
    ,0 orderlag, v_initial_date orderpostdate, 0 orderdatadur
    ,1 allowearlyarrivsw, 1 allowearlyordersw, '' csltemplate
from skusafetystockparam p, sku s
where s.enablesw = 1
and s.item = p.item(+)
and s.loc = p.loc(+)
and p.item is null;

commit;

/******************************************************************
** Part 19: Update OnHand Post
******************************************************************/
update sku set ohpost = (select trunc(sysdate) from dual)
    where loc in (select loc from loc where u_area = 'NA');

commit;


/******************************************************************
** Part 20: Zero Out SKU OH at PLants in table MAK_TPM_PLANTS_WITH_0_QTY
**  THE TABLE SHOULD BE RENAMED IF ACCEPTABLE!!!!!!!
******************************************************************/

insert into intups_sku
(loc, item, oh)
select sku.loc, sku.item, 0
from sku sku, mak_tpm_plants_with_0_qty p0
where sku.loc=p0.loc
  and sku.oh > 0;
commit;

end;
