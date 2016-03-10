--------------------------------------------------------
--  DDL for Procedure U_22_PRD_INSPECT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_22_PRD_INSPECT" as

begin

/******************************************************************
** Part 0: create production methods, BOM's resources and         * 
**         constraints for inspection processes                   * 
******************************************************************/

delete productionmethod where productionmethod = 'INS' and item||loc in 

    (select item||loc
    from udt_yield_na y
    where productionmethod = 'INS' 
    and dnd = 0
    );
    
commit;

delete bom where bomnum = 1
and item||subord||loc in 

    (select b.item||b.subord||b.loc
    from bom b, item i,

        (select item, loc, bomnum from productionmethod
        ) p

    where b.bomnum = 1
    and b.subord = i.item
    and i.u_stock = 'A'
    and b.item = p.item(+)
    and b.loc = p.loc(+)
    and b.bomnum = p.bomnum(+)
    and p.item is null
    );
    
commit;

delete res where res||loc in

    (select r.res||r.loc
    from res r,

        (select res, loc from productionstep
        ) p

    where substr(r.res, 1, 3) = 'INS'
    and r.res = p.res(+)
    and r.loc = p.loc(+)
    and p.res is null
    );
    
commit;

/******************************************************************
** Part 1: Create Boms                                            * 
******************************************************************/
insert into igpmgr.intins_bom 
(  integration_jobid, item, loc, bomnum, subord, drawqty, eff, disc
  ,offset, mixfactor, yieldfactor, shrinkagefactor, drawtype, explodesw
  ,unitconvfactor, enablesw, ecn, supersedesw, ff_trigger_control
  ,qtyuom, qtyperassembly
)

select 'U_22_PRD_INSPECT_PART1'
       ,u.item, u.loc, u.bomnum, u.subord, u.drawqty
       ,TO_DATE('01/01/1970 00:00', 'MM/DD/YYYY HH24:MI') eff
       ,v_init_eff_date disc, 0 offset, 100 mixfactor
       ,100 yieldfactor, 0 shrinkagefactor, 2 drawtype, 0 explodesw
       ,0 unitconvfactor, 1 enablesw, ' ' ecn, 0 supersedesw
       ,'' ff_trigger_control, 18 qtyuom, 0 qtyperassembly
from bom b, sku s, sku ss, loc l, 

    (select loc, item, '4001AI' subord, 1 bomnum, 1 drawqty
    from udt_yield_na
    where productionmethod = 'INS'
    and qb = 'AR'
    and maxcap > 0
    and yield > 0

    union

    select y.loc, y.item, '4001AI' subord, 1 bomnum, 1 drawqty
    from udt_yield_na y, item i
    where y.item = i.item
    and i.u_stock = 'C'
    and y.productionmethod = 'INS'
    and y.maxcap > 0
    and y.yield > 0
    and y.matcode||y.loc not in (select distinct matcode||loc 
                                   from udt_yield_na 
                                  where qb = 'AR' 
                                    and productionmethod = 'INS' 
                                    and maxcap > 0 
                                    and yield > 0)  
 -- this 2nd part of union is for INS production method which has no B stock yield; only C stock
    ) u

where u.loc = l.loc 
and l.loc_type in (2, 4)
and u.item = s.item
and u.loc = s.loc
and u.subord = ss.item
and u.loc = ss.loc
and s.enablesw = 1
and ss.enablesw = 1
and u.item <> u.subord
and u.item = b.item(+)
and u.loc = b.loc(+)
AND U.SUBORD = B.SUBORD(+)
AND U.BOMNUM = B.BOMNUM(+)
AND EXISTS ( SELECT 1
               FROM UDT_PLANT_STATUS PS
              WHERE PS.LOC=L.LOC
                AND PS.RES='SORT'
                AND PS.STATUS=1
            )
and b.item is null;

commit;

/******************************************************************
** Part 2: Create Production Methods                              * 
******************************************************************/
insert into igpmgr.intins_prodmethod 
(  integration_jobid, item, loc, productionmethod, descr, eff, priority
  ,minqty, incqty, disc, leadtime, maxqty, offsettype, loadopt
  ,maxstartdur, maxfindur, splitordersw, bomnum, enablesw, minleadtime
  ,maxleadtime, yieldqty, splitfactor, nonewsupplydate, finishcal
  ,leadtimecal, workscope, lotsizesenabledsw
)

select 'U_22_PRD_INSPECT_PART2'
       ,b.item, b.loc, 'INS' productionmethod, ' ' descr
       ,v_init_eff_date eff, 1 priority, 0 minqty, 0 incqty
       ,v_init_eff_date disc, 0 leadtime, 0 maxqty, 1 offsettype
       ,1 loadopt, 0 maxstartdur, 0 maxfindur, 0 splitordersw
       ,nvl(b.bomnum, 0) bomnum, 1 enablesw, 0 minleadtime
       ,1440 * 365 * 100 maxleadtime, 0 yieldqty, 1 splitfactor
       ,v_init_eff_date nonewsupplydate, ' ' finishcal, ' ' leadtimecal
       ,' ' workscope, 0 lotsizesenabledsw
from sku s, bom b, loc l, item i, 

    (select item, loc, productionmethod, bomnum 
       from productionmethod 
      where productionmethod = 'INS'
    ) p
    
where s.loc = l.loc
and l.loc_type in ( 2, 4)
and l.u_area = 'NA'
and s.enablesw = 1 
and b.subord = i.item
and i.u_stock = 'A'
and b.bomnum = 1
and b.item = s.item
and b.loc = s.loc
and b.item = p.item(+)
and b.loc = p.loc(+)
and b.bomnum = p.bomnum(+)
and p.item is null;

commit;
/******************************************************************
** Part 3: Create Res Records                                     * 
******************************************************************/
insert into igpmgr.intins_res 
(  integration_jobid, res, loc, type, cal, cost, descr, avgskuchg
  ,avgfamilychg, avgskuchgcost, avgfamilychgcost, levelloadsw
  ,levelseqnum, criticalitem, checkmaxcap, unitpenalty, adjfactor
  ,source, enablesw, subtype, qtyuom, currencyuom, productionfamilychgoveropt
)

select 'U_22_PRD_INSPECT_PART3'
       ,u.res, u.loc, u.type, ' ' cal, 0 cost, ' ' descr, 0 avgskuchg
       ,0 avgfamilychg, 0 avgskuchgcost, 0 avgfamilychgcost, 0 levelloadsw
       ,1 levelseqnum, ' ' criticalitem, 1 checkmaxcap, 0 unitpenalty
       ,1 adjfactor, ' ' source, 1 enablesw, 1 subtype, u.qtyuom
       ,15 currencyuom, 0 productionfamilychgoveropt
from res r, loc l,

    (select distinct 'INSCAP'||'@'||s.loc res, s.loc, 4 type, 28 qtyuom
    from sku s, loc l, item i
    where s.loc = l.loc
    and l.loc_type in ( 2, 4)
    and l.u_area='NA'
    and l.enablesw = 1
    and s.enablesw = 1
    and s.item = i.item
    and i.u_stock <> 'A'
    
    union
    
    select distinct 'INSCST'
                  ||'@'
                  ||s.loc res
                  ,s.loc, 4 type, 18 qtyuom
    FROM SKU S, LOC L, ITEM I
    where s.loc = l.loc 
    and l.loc_type in ( 2, 4)
    and l.enablesw = 1
    and s.enablesw = 1
    and s.item = i.item
    and i.u_stock <> 'A'
    ) u
    
WHERE U.LOC = L.LOC
  and exists
(select 1
from udt_plant_status ps
where ps.loc=l.loc
    and ps.res='SORT'
    and ps.status=1
)
--  and exists
--(select 1
--from udt_yield_na y
--where y.loc=l.loc
--    and y.yield > 0
--    and y.maxcap>0
--)
and l.u_area = 'NA'
and u.loc = r.loc(+)
and u.res = r.res(+)
and r.res is null;

commit;
/******************************************************************
** Part 4: Create 2 production steps and resources;               * 
**         1 for capacity and 2 for cost                          * 
******************************************************************/
insert into igpmgr.intins_productionstep 
(  integration_jobid, item, loc, productionmethod, stepnum, nextsteptiming
  ,fixedresreq, prodrate, proddur, prodoffset, enablesw, spread, maxstartdur
  ,eff, res, descr, loadoffsetdur, prodcost, qtyuom, setup, inusebeforesw
  ,prodfamily
)

select 'U_22_PRD_INSPECT_PART4'
       ,pm.item, pm.loc, pm.productionmethod
       ,case when substr(r.res, 1, 6) = 'INSCAP' then 1 
             else 2 
         end stepnum, 3 nextsteptiming, 0 fixedresreq
       ,case when u.rate = 0 then 1 
             else u.rate 
        end prodrate
        ,0 proddur, 0 prodoffset, 1 enablesw, 0 spread, 0 maxstartdur
        ,v_init_eff_date eff, r.res, ' ' descr, 0 loadoffsetdur , 0 prodcost
        , case when substr(r.res, 1, 6) = 'INSCAP' then 28 
               else 18 
           end qtyuom
        ,' ' setup, 0 inusebeforesw, ' ' prodfamily 
from productionmethod pm, productionstep ps, res r, loc l, item i, 

        (select item, loc, round(((maxcap/efficiency)/maxdaysperwk)/maxhrsperday, 0) rate
        from udt_yield_na
        where productionmethod = 'INS'
        and maxcap > 0
        and yield > 0
        ) u

where pm.loc = l.loc
and l.loc_type in (2, 4)
and (r.res = 'INSCST'
             ||'@'
             ||pm.loc  or r.res = 'INSCAP'
             ||'@'
             ||pm.loc
    )
AND R.LOC = PM.LOC
  and exists
(select 1
from udt_plant_status ps
where ps.loc=l.loc
    and ps.res='SORT'
    and ps.status=1
)
and r.enablesw = 1
and pm.enablesw = 1
and pm.item = u.item
and pm.loc = u.loc
and pm.item = i.item
and pm.productionmethod = 'INS'
and pm.item = ps.item(+)
AND PM.LOC = PS.LOC(+)
and pm.productionmethod = ps.productionmethod(+)
and ps.item is null;

commit;
/******************************************************************
** Part 5: Create Production Yield Records                        * 
******************************************************************/
insert into igpmgr.intins_prodyield 
(  integration_jobid, item, loc, productionmethod, eff
  ,qtyuom , outputitem, yieldqty
)

select 'U_22_PRD_INSPECT_PART5'
       ,p.item, p.loc, p.productionmethod, v_init_eff_date eff, 18 qtyuom
       ,p.outputitem, p.yield yieldqty 
from productionyield y, sku so, loc l, 

    (select distinct pm.item, u.item outputitem, pm.loc, pm.productionmethod, u.yield
    from bom b, productionmethod pm, item i,

        (select b.item, b.loc, p.yield, p.matcode
        from bom b, udt_yield_na p
        where b.item = p.item
        and b.loc = p.loc
        and b.bomnum = 1
        and p.productionmethod = 'INS'
        and p.maxcap > 0
        and p.yield > 0
        
        union
        
        select y.item, y.loc, y.yield, y.matcode
        FROM udt_yield_na Y, ITEM I
        where y.item = i.item
        and y.productionmethod = 'INS'
        and i.u_stock in ('B', 'C')
        and y.maxcap > 0
        and y.yield > 0
        and y.item||y.loc not in (select item ||loc 
                                    from bom 
                                   WHERE BOMNUM = 1)
        ) u

    where b.item = i.item
    and i.u_materialcode = u.matcode 
    and b.loc = u.loc
    and b.bomnum = 1
    and b.item = pm.item
    and b.loc = pm.loc
    and pm.productionmethod = 'INS'
     )p

WHERE P.LOC = L.LOC 
AND EXISTS ( SELECT 1
               FROM UDT_PLANT_STATUS PS
              WHERE PS.LOC=L.LOC
                AND PS.RES='SORT'
                AND PS.STATUS=1
            )
and l.loc_type in ( 2, 4)
and l.u_area = 'NA'
and so.item = p.outputitem
and so.loc = p.loc
and p.item = y.item(+)
AND P.LOC = Y.LOC(+)
and p.productionmethod = y.productionmethod(+)
and y.item is null;

commit;
/******************************************************************
** Part 6: Create Cost Records                                    * 
******************************************************************/
insert into igpmgr.intins_cost 
(  integration_jobid, cost, enablesw, cumulativesw, groupedsw, sharedsw
  ,qtyuom, currencyuom, accumcal, maxqty, maxutilization
)

select distinct 'U_22_PRD_INSPECT_PART6'
     ,'LOCAL:RES:'
       ||u.res
       ||'-202' cost
    ,1 enablesw, 0 cumulativesw, 0 groupedsw, 0 sharedsw, 18 qtyuom
    ,15 currencyuom, ' ' accumcal, 0 maxqty, 0 maxutilization
from cost c, 

    (select r.res, 'LOCAL:RES:'
                   ||r.res
                   ||'-202' cost
    from res r
    where r.subtype = 1
    and substr(r.res, 1, 6) = 'INSCST'
    ) u
    
where u.cost = c.cost(+)
and c.cost is null;

commit;
/******************************************************************
** Part 7: Create CostTier Records                                * 
******************************************************************/
insert into igpmgr.intins_costtier 
(  integration_jobid, breakqty, category, value, eff, cost )

select distinct 'U_22_PRD_INSPECT_PART7'
         ,0 breakqty, 303 category, q.unit_cost value
         ,v_init_eff_date eff, c.cost  
  
from cost c, costtier t, 

    (SELECT S.ITEM, S.MATCODE, S.LOC, S.PRODUCTIONMETHOD, S.STEPNUM
           ,S.RES, S.COST, NVL(U.UNIT_COST, INSPECT_COST.NUMVAL1) UNIT_COST
    from udt_default_parameters inspect_cost,

        (select s.item, i.u_materialcode matcode, s.loc, s.productionmethod
               ,s.stepnum, s.res, 'LOCAL:RES:INSCST@'
                                   ||s.loc
                                   ||'-202' cost
        from productionstep s, item i
        where s.productionmethod = 'INS'
        and s.stepnum = 2
        and s.item = i.item
        ) s,

        (select loc, matcode, process productionmethod, unit_cost
        from udt_cost_unit_na
        where process = 'INS'
        ) u
        
    where s.matcode = u.matcode(+)
    and s.loc = u.loc(+)
    AND S.PRODUCTIONMETHOD = U.PRODUCTIONMETHOD(+)
    and inspect_cost.name='INSPECTION_COST'
    ) q

where c.cost = q.cost
and c.cost = t.cost(+)
and t.cost is null;

commit;
/******************************************************************
** Part 8: Create ResCost Records                                 * 
******************************************************************/
insert into igpmgr.intins_rescost 
(  integration_jobid, category, res, localcost, tieredcost )

select distinct 'U_22_PRD_INSPECT_PART1'
                ,202 category, u.res, t.cost localcost, ' ' tieredcost
from rescost r, costtier t, 

    (select r.res, 'LOCAL:RES:'||r.res||'-202' cost
    from res r
    where r.subtype = 1
    ) u

where t.cost = u.cost
and u.cost = r.localcost(+)
and r.localcost is null;

commit;

--must run u_29_prd_resconstraint or _wk

end;
