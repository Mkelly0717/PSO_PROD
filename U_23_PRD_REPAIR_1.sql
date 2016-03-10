--------------------------------------------------------
--  DDL for Procedure U_23_PRD_REPAIR
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_23_PRD_REPAIR" as

begin

/*************************************************************
** Part 1: Delete production methods for Repair
*************************************************************/

delete productionmethod where productionmethod = 'REP' and item||loc in 

    (select item||loc
    from udt_yield_na y
    where productionmethod = 'REP' 
    and dnd = 0
    );
    
commit;

/*************************************************************
** Part 2: Delete BOM's for A stock.
*************************************************************/

delete bom where bomnum = 1
and item||subord||loc in 

    (select b.item||b.subord||b.loc
    from bom b, item i,

        (select item, loc, bomnum from productionmethod
        ) p

    where b.bomnum = 1
    and b.subord = i.item
    and i.u_stock <> 'A'
    and b.item = p.item(+)
    and b.loc = p.loc(+)
    and b.bomnum = p.bomnum(+)
    and p.item is null
    );
    
commit;

/*************************************************************
** Part 3: Delete Repair resources
*************************************************************/

delete res where res||loc in

    (select r.res||r.loc
    from res r,

        (select res, loc from productionstep
        ) p

    where substr(r.res, 1, 3) = 'REP'
    and r.res = p.res(+)
    and r.loc = p.loc(+)
    and p.res is null
    );

commit;

/*************************************************************
** Part 4: create BOM's for Repair Processes
*************************************************************/

insert into igpmgr.intins_bom 
(integration_jobid, item, loc, bomnum, subord, drawqty, eff
  ,disc, offset, mixfactor, yieldfactor, shrinkagefactor
  ,drawtype, explodesw, unitconvfactor, enablesw
  ,ecn, supersedesw, ff_trigger_control, qtyuom, qtyperassembly
)

select 'U_23_PRD_REPAIR_PART4' 
     ,u.item, u.loc, u.bomnum, u.subord, u.drawqty
     ,TO_DATE('01/01/197000:00','MM/DD/YYYYHH24:MI') eff
     ,v_init_eff_date disc, 0 offset
     ,100 mixfactor, 100 yieldfactor, 0 shrinkagefactor, 2 drawtype
     ,0 explodesw, 0 unitconvfactor, 1 enablesw, ' ' ecn, 0 supersedesw
     ,''ff_trigger_control, 18 qtyuom, 0 qtyperassembly
from bom b, sku s, sku ss, 

    (select y.item, i.u_materialcode||'AR' subord, y.loc, 1 bomnum, 1 drawqty
    from udt_yield_na y, item i, udt_plant_status ps
    where y.productionmethod = 'REP'
    and y.item = i.item 
    and i.u_stock = 'C' 
    and y.maxcap > 0
    and y.yield > 0
    and y.loc=ps.loc
    and ps.res='REPAIR'
    and ps.status=1
    ) u

where u.item = s.item
and u.loc = s.loc
and u.subord = ss.item
and u.loc = ss.loc
and s.enablesw = 1
and ss.enablesw = 1
and u.item <> u.subord
and u.item = b.item(+)
and u.loc = b.loc(+)
and u.subord = b.subord(+)
and u.bomnum = b.bomnum(+)      
and b.item is null;

commit;

/*************************************************************
** Part 5: Create Resource Records
*************************************************************/

insert into igpmgr.intins_res 
(integration_jobid, res, loc, type, cal, cost, descr, avgskuchg
   ,avgfamilychg, avgskuchgcost, avgfamilychgcost, levelloadsw
   ,levelseqnum, criticalitem, checkmaxcap, unitpenalty, adjfactor
   ,source, enablesw, subtype, qtyuom, currencyuom
   , productionfamilychgoveropt
)
select 'U_23_PRD_REPAIR_PART5'
       ,u.res, u.loc, u.type, ' ' cal, 0 cost, ' ' descr
       ,0 avgskuchg, 0 avgfamilychg, 0 avgskuchgcost
       ,0 avgfamilychgcost, 0 levelloadsw, 1 levelseqnum
       ,' ' criticalitem, 1 checkmaxcap, 0 unitpenalty
       ,1 adjfactor, ' ' source, 1 enablesw, 1 subtype
       ,u.qtyuom, 15 currencyuom, 0 productionfamilychgoveropt
from res r, 

    (select distinct 'REPCAP'||'@'||s.loc res, s.loc, 4 type, 28 qtyuom
    from sku s, loc l, item i,
    
        (select distinct y.loc
        from udt_yield_na y, udt_plant_status ps
        where y.productionmethod = 'REP'
        and y.maxcap > 0
        and y.yield > 0
        and y.loc=ps.loc
        and ps.res='REPAIR'
        and ps.status=1
        ) q
    
    where s.loc = l.loc
    and l.loc_type in ( 2, 4)
    and l.enablesw = 1
    and s.enablesw = 1
    and s.item = i.item
    and s.loc = q.loc
    and i.u_stock <> 'A'
    
    union
    
    select distinct 'REPCST'||'@'||s.loc res, s.loc, 4 type, 18 qtyuom
    from sku s, loc l, item i,
    
        (select distinct y.matcode, y.loc
           from udt_yield_na y, udt_plant_status ps
          where y.productionmethod = 'REP'
            and y.maxcap > 0
            and y.yield > 0   
            and y.loc=ps.loc
            and ps.res='REPAIR'
            and ps.status=1
        ) q
    
    where s.loc = l.loc
    and l.loc_type in ( 2, 4)
    and l.u_area = 'NA'
    and l.enablesw = 1
    and s.enablesw = 1
    and s.item = i.item
    and s.loc = q.loc
    and i.u_stock <> 'A'
    and q.matcode <> '16' -- matcode 16 is not REP but WAS
    ) u
    
where u.loc = r.loc(+)
and u.res = r.res(+)
--  and exists
--(select 1
--from udt_plant_status ps
--where ps.loc=u.loc
--    and ps.res='SORT'
--    and ps.status=1
--)
--  and exists
--(select 1
--from udt_yield_na y
--where y.loc=u.loc
--    and y.yield > 0
--    and y.maxcap>0
--)
and r.res is null;

commit;

/*************************************************************
** Part 6: Create Production Methods
*************************************************************/

insert into igpmgr.intins_prodmethod 
(  integration_jobid, item, loc, productionmethod, descr, eff
  ,priority, minqty, incqty, disc, leadtime, maxqty, offsettype
  ,loadopt, maxstartdur, maxfindur, splitordersw, bomnum, enablesw
  ,minleadtime, maxleadtime, yieldqty, splitfactor, nonewsupplydate
  ,finishcal, leadtimecal, workscope, lotsizesenabledsw
)
select 'U_23_PRD_REPAIR_PART6'
       , b.item, b.loc, t.productionmethod, ' ' descr, v_init_eff_date eff
       ,1 priority, 0 minqty, 0 incqty, v_init_eff_date disc, 0 leadtime
       ,0 maxqty, 1 offsettype, 1 loadopt, 0 maxstartdur, 0 maxfindur
       ,0 splitordersw, nvl(b.bomnum, 0) bomnum, 1 enablesw, 0 minleadtime
       ,1440 * 365 * 100 maxleadtime, 0 yieldqty, 1 splitfactor
       ,v_init_eff_date nonewsupplydate, ' ' finishcal, ' ' leadtimecal
       ,' ' workscope, 0 lotsizesenabledsw
from sku s, bom b, loc l, item i, udt_plant_status ps,
    (select item, loc, productionmethod 
       from productionmethod 
      where productionmethod = 'REP'
    ) p,
    (select item, loc, 'REP' productionmethod, yield 
       from udt_yield_na 
      where productionmethod = 'REP' and maxcap > 0 and yield > 0
    ) t
where s.loc = l.loc
and l.loc_type in ( 2, 4)
and l.u_area = 'NA'
and ps.loc=l.loc
and ps.res='REPAIR'
and ps.status=1
and s.enablesw = 1 
and b.subord = i.item
and i.u_stock = 'B'
and b.bomnum = 1
and b.item = t.item
and b.loc = t.loc
and b.item = s.item
and b.loc = s.loc 
and b.item = p.item(+)
and b.loc = p.loc(+)
and p.item is null;

commit;

/*************************************************************
** Part 7: Create Production Step Records
*************************************************************/

insert into igpmgr.intins_productionstep 
(  integration_jobid, item, loc, productionmethod, stepnum, nextsteptiming
   ,fixedresreq, prodrate, proddur, prodoffset, enablesw, spread, maxstartdur
   ,eff, res, descr, loadoffsetdur, prodcost, qtyuom, setup, inusebeforesw
   ,prodfamily
)
select 'U_23_PRD_REPAIR_PART7'
       ,pm.item, pm.loc, pm.productionmethod
       , case 
           when substr(r.res, 1, 6) = 'REPCAP' then 1 
           else 2 
        end stepnum
       ,3 nextsteptiming, 0 fixedresreq, u.rate prodrate, 0 proddur
       ,0 prodoffset, 1 enablesw, 0 spread, 0 maxstartdur
       ,v_init_eff_date eff, r.res, ' ' descr, 0 loadoffsetdur ,0 prodcost
       , case 
           when substr(r.res, 1, 6) = 'REPCAP' then 28 
           else 18 
         end qtyuom
       ,' ' setup, 0 inusebeforesw, ' ' prodfamily 
from productionmethod pm
    ,productionstep ps
    ,res r
    ,item i
    ,udt_plant_status pstatus,

        (select item, loc, round(((maxcap/efficiency)/maxdaysperwk)/maxhrsperday, 0) rate
        from udt_yield_na
        where productionmethod = 'REP'
        and maxcap > 0
        and yield > 0) u

where pm.item = i.item
and (r.res = 'REPCST'||'@'||pm.loc  or r.res = 'REPCAP'||'@'||pm.loc)
and r.loc = pm.loc
and r.loc=pstatus.loc
and pstatus.res='REPAIR'
and pstatus.status=1
and r.enablesw = 1
and pm.enablesw = 1
and pm.item = u.item
and pm.loc = u.loc
and pm.item = ps.item(+)
and pm.loc = ps.loc(+)
and pm.productionmethod = ps.productionmethod(+)
and ps.item is null;

commit;

/*************************************************************
** Part 8: Create Production Yield Records
*************************************************************/

insert into igpmgr.intins_prodyield 
(integration_jobid, item, loc, productionmethod, eff, qtyuom, outputitem, yieldqty)
select 'U_23_PRD_REPAIR_PART8'
       ,p.item, p.loc, p.productionmethod, v_init_eff_date eff
       ,18 qtyuom, p.item outputitem, 1 yieldqty 
from productionyield y, productionmethod p
where p.item = y.item(+)
and p.loc = y.loc(+)
and p.productionmethod = y.productionmethod(+)
and y.item is null;

commit;

/*************************************************************
** Part 9: Create Cost records for Repair
*************************************************************/

insert into igpmgr.intins_cost 
( integration_jobid, cost, enablesw, cumulativesw, groupedsw
  , sharedsw, qtyuom, currencyuom, accumcal, maxqty
  , maxutilization
)
select distinct 'U_23_PRD_REPAIR_PART9'
    ,u.cost, 1 enablesw, 0 cumulativesw, 0 groupedsw, 0 sharedsw
    ,18 qtyuom, 15 currencyuom, ' '   accumcal, 0 maxqty, 0 maxutilization
from cost c, 

    (select 'LOCAL:RES:'||res||'-202' cost
    from res
    where subtype = 1
    and substr(res, 1, 6) = 'REPCST') u
    
where u.cost = c.cost(+)
and c.cost is null;

commit;

/*************************************************************
** Part 10: Create Production CostTier Records for Repair
*************************************************************/

insert into igpmgr.intins_costtier (integration_jobid, breakqty, category, value, eff, cost)

select distinct 'U_23_PRD_REPAIR_PART10'
  , 0 breakqty
  , 303 category
  , q.unit_cost value
  , v_init_eff_date eff
  , c.cost
from cost c
  , costtier t
  , (select s.item
      , s.matcode
      , s.loc
      , s.productionmethod
      , s.stepnum
      , s.res
      , s.cost
      , nvl(u.unit_cost, repair_cost.numval1) unit_cost
    from udt_default_parameters repair_cost
      , (select s.item
          , i.u_materialcode matcode
          , s.loc
          , s.productionmethod
          , s.stepnum
          , s.res
          , 'LOCAL:RES:REPCST@'
            ||s.loc
            ||'-202' cost
        from productionstep s
          , item i
        where s.productionmethod = 'REP'
            and s.stepnum = 2
            and s.item = i.item
        ) s
      , (select loc
          , matcode
          , process productionmethod
          , unit_cost
        from udt_cost_unit
        where process = 'REP'
        ) u
    where s.matcode = u.matcode(+)
        and s.loc = u.loc(+)
        and s.productionmethod = u.productionmethod(+)
        and repair_cost.name='REPAIR_COST'
    ) q
where c.cost = q.cost
    and c.cost = t.cost(+)
and t.cost is null;

commit;

/*************************************************************
** Part 11: Create Production  ResCost Records for Repair
*************************************************************/

insert into igpmgr.intins_rescost 
  (integration_jobid, category, res, localcost, tieredcost)
select distinct  'U_23_PRD_REPAIR_PART11'
                 ,202 category, u.res, t.cost localcost, ' ' tieredcost
from rescost r, costtier t, 

    (select r.res, 'LOCAL:RES:'||r.res||'-202' cost
    from res r
    where r.subtype = 1) u

where t.cost = u.cost
and u.cost = r.localcost(+)
and r.localcost is null;

commit;

--must run u_29_prd_resconstraint or _wk

end;
