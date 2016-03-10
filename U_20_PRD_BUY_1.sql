--------------------------------------------------------
--  DDL for Procedure U_20_PRD_BUY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_20_PRD_BUY" as

begin

/******************************************************************
** Part 0: Delete records from Res, ProductionMethod, and Bom     * 
******************************************************************/

delete res where res like 'BUY%';

commit;

delete productionmethod where productionmethod = 'BUY' and item||loc in 

    (select item||loc
    from udt_yield_na y
    where productionmethod = 'BUY' 
    and dnd = 0
    );
    
commit;

delete bom where subord like '%RUNEW';

commit;

/******************************************************************
** Part 1: Insert records into Res table                          *
******************************************************************/
insert into igpmgr.intins_res 
(  integration_jobid, res, loc, type, cal, cost, descr, avgskuchg
  ,avgfamilychg, avgskuchgcost, avgfamilychgcost, levelloadsw
  ,levelseqnum, criticalitem, checkmaxcap, unitpenalty, adjfactor
  ,source, enablesw, subtype, qtyuom, currencyuom
  ,productionfamilychgoveropt
)

select 'U_20_PRD_BUY_PART1' 
       ,u.res, u.loc, u.type, ' ' cal, 0 cost, ' ' descr, 0 avgskuchg
       ,0 avgfamilychg, 0 avgskuchgcost, 0 avgfamilychgcost, 0 levelloadsw
       ,1 levelseqnum, ' ' criticalitem, 1 checkmaxcap, 0 unitpenalty
       ,1 adjfactor, ' ' source, 1 enablesw, u.subtype, 28 qtyuom
       ,15 currencyuom, 0 productionfamilychgoveropt
from res r, 

    (select distinct s.loc, 'BUY'||i.u_qualitybatch||'@'||s.loc res, 4 type, 1 subtype
    from sku s, loc l, item i, udt_cost_unit_na u
    where s.loc = l.loc
    and l.loc_type = 1
    and l.u_area = 'NA'
    and s.item = i.item
    and s.loc = u.loc
    and i.u_materialcode= u.matcode
    and i.u_qualitybatch = 'RUNEW'
    and l.loc <> ' '
    ) u
    
where u.loc = r.loc(+)
and u.res = r.res(+)
and r.res is null;

commit;

/******************************************************************
** Part 2: Insert records into Production Method                  *
******************************************************************/
insert into igpmgr.intins_prodmethod 
(  integration_jobid, item, loc, productionmethod
  ,descr, eff, priority, minqty, incqty, disc, leadtime, maxqty
  ,offsettype, loadopt, maxstartdur, maxfindur, splitordersw, bomnum
  ,enablesw, minleadtime, maxleadtime, yieldqty, splitfactor
  ,nonewsupplydate, finishcal, leadtimecal, workscope, lotsizesenabledsw
)

select 'U_20_PRD_BUY_PART2'
       ,u.item, u.loc, u.productionmethod, ' ' descr, v_init_eff_date eff
       ,1 priority, 0 minqty, 0 incqty,  v_init_eff_date disc, 0 leadtime
       ,0 maxqty, 1 offsettype, 1 loadopt, 0 maxstartdur, 0 maxfindur
       ,0 splitordersw, 0 bomnum, 1 enablesw, 0 minleadtime
       ,1440 * 365 * 100 maxleadtime, 0 yieldqty, 1 splitfactor
       ,v_init_eff_date nonewsupplydate, ' ' finishcal, ' ' leadtimecal
       ,' ' workscope, 0 lotsizesenabledsw
from productionmethod p, 

    (select s.item, s.loc, 'BUY' productionmethod
    from sku s, loc l, item i, udt_cost_unit_na u
    where s.loc = l.loc
    and l.loc_type = 1
    and l.u_area = 'NA'
    and s.enablesw = 1
    and s.item = i.item
    and s.loc = u.loc
    and i.u_materialcode= u.matcode
    and i.u_qualitybatch = 'RUNEW'
    and l.loc <> ' '
    ) u

where u.item = p.item(+)
and u.loc = p.loc(+) 
and u.productionmethod = p.productionmethod(+)
and p.item is null;

commit;

/******************************************************************
** Part 3: Insert records into Production Step                    *
******************************************************************/
insert into igpmgr.intins_productionstep  
(  integration_jobid, item, loc, productionmethod, stepnum, nextsteptiming
  ,fixedresreq, prodrate, proddur, prodoffset, enablesw, spread, maxstartdur
  ,eff, res, descr, loadoffsetdur, prodcost, qtyuom, setup, inusebeforesw
  ,prodfamily
)

select 'U_20_PRD_BUY_PART3'
       ,pm.item, pm.loc, pm.productionmethod, 1 stepnum, 3 nextsteptiming
       ,0 fixedresreq, 1 prodrate, 0 proddur, 0 prodoffset, 1 enablesw
       ,0 spread, 0 maxstartdur, v_init_eff_date eff, r.res, ' ' descr
       ,0 loadoffsetdur, 0 prodcost, 28 qtyuom, ' ' setup, 0 inusebeforesw
       ,' ' prodfamily 
from productionmethod pm, productionstep ps, res r, loc l, item i
where r.loc = pm.loc
and 'BUY'||i.u_qualitybatch||'@'||pm.loc = r.res
and pm.loc = l.loc
and l.loc_type = 1
and r.enablesw = 1
and pm.enablesw = 1 
and pm.item = i.item
and pm.productionmethod = 'BUY' 
and pm.item = ps.item(+)
and pm.loc = ps.loc(+)
and pm.productionmethod = ps.productionmethod(+)
and ps.item is null;

commit;


/******************************************************************
** Part 4: now need to create production methods, unconstrained   *
**        ,no cost, to consume RUNEW into RUSTD....               *
**        Insert records into Production Step                     *
******************************************************************/
insert into igpmgr.intins_bom 
(  integration_jobid, item, loc, bomnum, subord, drawqty, eff, disc
  ,offset, mixfactor, yieldfactor, shrinkagefactor, drawtype, explodesw
  ,unitconvfactor, enablesw, ecn, supersedesw, ff_trigger_control
  ,qtyuom, qtyperassembly
)

select 'U_20_PRD_BUY_PART4'
       ,u.item, u.loc, u.bomnum, u.subord, u.drawqty, v_init_eff_date eff
       ,scpomgr.u_jan1970 disc, 0 offset, 100 mixfactor, 100 yieldfactor
       ,0 shrinkagefactor, 2 drawtype, 0 explodesw, 0 unitconvfactor
       ,1 enablesw, ' ' ecn, 0 supersedesw, '' ff_trigger_control
       ,18 qtyuom, 0 qtyperassembly
from bom b, sku s, sku ss, 

    (select s.item, i.u_materialcode||'RUNEW' subord, s.loc, 1 bomnum, 1 drawqty
    from sku s, loc l, item i, udt_cost_unit_na u
    where s.loc = l.loc
    and l.loc_type = 1
    and l.u_area = 'NA'
    and s.item = i.item
    and s.loc = u.loc
    and i.u_materialcode= u.matcode
    and i.u_qualitybatch <> 'RUNEW'
    and i.u_stock = 'C'
    and l.loc <> ' '
    ) u

where u.item = s.item
and u.loc = s.loc
and u.subord = ss.item
and u.loc = ss.loc
and s.enablesw = 1
and ss.enablesw = 1
and u.item = b.item(+)
and u.loc = b.loc(+)
and u.subord = b.subord(+)
and u.bomnum = b.bomnum(+)
and b.item is null;

commit;

/******************************************************************
** Part 5: Insert records into production method                  *
******************************************************************/

insert into igpmgr.intins_prodmethod 
(  integration_jobid, item, loc, productionmethod, descr, eff, priority
  ,minqty, incqty, disc, leadtime, maxqty, offsettype, loadopt, maxstartdur
  ,maxfindur, splitordersw, bomnum, enablesw, minleadtime, maxleadtime
  ,yieldqty, splitfactor, nonewsupplydate, finishcal, leadtimecal
  ,workscope, lotsizesenabledsw
)

select 'U_20_PRD_BUY_PART5'
       ,t.item, t.loc, t.productionmethod, ' ' descr, v_init_eff_date eff
       ,1 priority, 0 minqty, 0 incqty, scpomgr.u_jan1970 disc, 0 leadtime
       ,0 maxqty, 1 offsettype, 1 loadopt, 0 maxstartdur, 0 maxfindur
       ,0 splitordersw, t.bomnum, 1 enablesw, 0 minleadtime
       ,1440 * 365 * 100 maxleadtime, 0 yieldqty, 1 splitfactor
       ,v_init_eff_date nonewsupplydate, ' ' finishcal, ' ' leadtimecal
       ,' ' workscope, 0 lotsizesenabledsw
from productionmethod p, 

    (select b.item, b.loc, 'BUY' productionmethod, b.bomnum
    from bom b, loc l, item i, udt_cost_unit_na u
    where b.loc = l.loc
    and l.loc_type = 1
    and l.u_area = 'NA'
    and b.subord = i.item
    and b.loc = u.loc
    and i.u_materialcode= u.matcode
    and i.u_qualitybatch = 'RUNEW'
    and l.loc <> ' '
    ) t

where  t.item = p.item(+)
and t.loc = p.loc(+)
and t.bomnum = p.bomnum(+)
and t.productionmethod = p.productionmethod(+)
and p.item is null;

commit;


/******************************************************************
** Part 6: Load records into Production Yield                     *
******************************************************************/
insert into igpmgr.intins_prodyield 
(  integration_jobid, item, loc, productionmethod, eff
  ,qtyuom, outputitem, yieldqty
)

select 'U_20_PRD_BUY_PART6'
       ,p.item, p.loc, p.productionmethod, v_init_eff_date eff
       , 18 qtyuom, p.item outputitem, 1 yieldqty 
 from productionyield y, productionmethod p, loc l
where p.loc = l.loc
and l.u_area = 'NA'
and p.item = y.item(+)
and p.loc = y.loc(+)
and p.productionmethod = y.productionmethod(+)
and y.item is null;

commit;

end;
