--------------------------------------------------------
--  DDL for Procedure U_25_PRD_HEAT
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_25_PRD_HEAT" as

begin

/*************************************************************
** Part 1: Delete production methods for Heat treat
*************************************************************/

delete productionmethod where productionmethod = 'HTR' and item||loc in 

    (select item||loc
    from udt_yield_na y
    where productionmethod = 'HTR' 
    and dnd = 0
    );
    
commit;

/*************************************************************
** Part 2: Delete BOM's for A stock.
*************************************************************/

--delete bom where bomnum = 1
--and item||subord||loc in 
--
--    (select b.item||b.subord||b.loc
--    from bom b, item i,
--
--        (select item, loc, bomnum from productionmethod
--        ) p
--
--    where b.bomnum = 1
--    and b.subord = i.item
--    and i.u_stock <> 'A'
--    and b.item = p.item(+)
--    and b.loc = p.loc(+)
--    and b.bomnum = p.bomnum(+)
--    and p.item is null
--    );
--    
--commit;

/*************************************************************
** Part 3: Delete Repair resources
*************************************************************/

delete res where res||loc in

    (select r.res||r.loc
    from res r,

        (select res, loc from productionstep
        ) p

    where substr(r.res, 1, 3) = 'HTR'
    and r.res = p.res(+)
    and r.loc = p.loc(+)
    and p.res is null
    );
    
commit;

/*************************************************************
** Part 4: create BOM's for Heat treat
*************************************************************/

insert into bom 
(  item, loc, bomnum, subord, drawqty, eff
  ,disc, offset, mixfactor, yieldfactor, shrinkagefactor, drawtype
  ,explodesw, unitconvfactor, enablesw, ecn, supersedesw
  ,ff_trigger_control, qtyuom, qtyperassembly
)

select u.item, u.loc, u.bomnum, u.subord, u.drawqty
      ,TO_DATE('01/01/1970 00:00', 'MM/DD/YYYY HH24:MI') eff
      ,v_init_eff_date disc, 0 offset, 100 mixfactor, 100 yieldfactor
      ,0 shrinkagefactor, 2 drawtype, 0 explodesw, 0 unitconvfactor
      ,1 enablesw, ' ' ecn, 0 supersedesw, '' ff_trigger_control
      ,18 qtyuom, 0 qtyperassembly
from bom b, sku s, sku ss, 

    (select y.item, i.u_materialcode||sb.subord subord, y.loc, 1 bomnum, 1 drawqty
    from udt_yield_na y, item i,
        
        (select distinct u_qualitybatch,
            case when u_qualitybatch = 'RUCUSTPS' then 'RUCUST'
                 when u_qualitybatch = 'RUPLUSPS' then 'RUPLUS'
                 when u_qualitybatch = 'RUPREMPS' then 'RUPREMIUM' 
                 else '' 
            end subord
        from item
        where u_stock = 'C'
        --and substr(u_qualitybatch, 3, 2) = 'PS'
        ) sb
    
    where y.productionmethod = 'HTR'
    and y.item = i.item 
    and i.u_stock = 'C' 
    and i.u_qualitybatch = sb.u_qualitybatch
    ) u

where u.item = s.item
and u.loc = s.loc
and u.subord = ss.item
and u.loc = ss.loc
and s.enablesw = 1
and ss.enablesw = 1
AND U.ITEM <> U.SUBORD
AND EXISTS ( SELECT 1
               FROM UDT_PLANT_STATUS PS
              WHERE PS.LOC=U.LOC
                AND PS.RES='HEATTREAT'
                AND PS.STATUS=1
            )
and u.item = b.item(+)
and u.loc = b.loc(+)
and u.subord = b.subord(+)
and u.bomnum = b.bomnum(+)
and b.item is null;

commit;

/*************************************************************
** Part 5: Create Resource Records
*************************************************************/

insert into res 
( res, loc, type, cal, cost, descr, avgskuchg
 ,avgfamilychg, avgskuchgcost, avgfamilychgcost, levelloadsw
 ,levelseqnum, criticalitem, checkmaxcap, unitpenalty, adjfactor
 ,source, enablesw, subtype, qtyuom, currencyuom, productionfamilychgoveropt
)

select u.res, u.loc, u.type, ' ' cal, 0 cost, ' ' descr, 0 avgskuchg
       ,0 avgfamilychg, 0 avgskuchgcost, 0 avgfamilychgcost, 0 levelloadsw
       ,1 levelseqnum, ' ' criticalitem, 1 checkmaxcap, 0 unitpenalty
       ,1 adjfactor, ' ' source, 1 enablesw, 1 subtype, u.qtyuom
       ,15 currencyuom, 0 productionfamilychgoveropt
from res r, 

    (select distinct 'HTRCAP'
                           ||'@'
--                           ||lpad(i.u_materialcode, 2, '0')
                           ||s.loc res
                      , s.loc, 4 type, 28 qtyuom
    from sku s, loc l, item i,
    
        (select distinct loc
        from udt_yield_na
        where productionmethod = 'HTR'
        ) q
    
    where s.loc = l.loc
    and l.loc_type = 2
    and l.enablesw = 1
    and s.enablesw = 1
    and s.item = i.item
    and s.loc = q.loc
    and i.u_stock <> 'A'
    
    union
    
    select distinct 'HTRCST'
                          ||'@'
--                          ||lpad(i.u_materialcode, 2, '0')
                          ||s.loc res
                     , s.loc, 4 type, 18 qtyuom
    from sku s, loc l, item i,
    
        (select distinct matcode, loc
        from udt_yield_na
        where productionmethod = 'HTR'
        ) q
    
    where s.loc = l.loc
    and l.loc_type = 2
    and l.enablesw = 1
    and s.enablesw = 1
    and s.item = i.item
    and i.u_materialcode = q.matcode 
    and s.loc = q.loc
    and i.u_stock <> 'A'
    ) u
    
where u.loc = r.loc(+)
AND U.RES = R.RES(+)
AND EXISTS ( SELECT 1
               FROM UDT_PLANT_STATUS PS
              WHERE PS.LOC=U.LOC
                AND PS.RES='HEATTREAT'
                AND PS.STATUS=1
            )
  and exists
(select 1
from udt_yield_na y
where y.loc=u.loc
    and y.yield > 0
    and y.maxcap>0
)
and r.res is null;

commit;

/*************************************************************
** Part 6: Create Production Methods
*************************************************************/

insert into productionmethod 
(  item, loc, productionmethod, descr
  ,eff, priority, minqty, incqty, disc, leadtime, maxqty
  ,offsettype, loadopt, maxstartdur, maxfindur, splitordersw
  ,bomnum, enablesw, minleadtime, maxleadtime, yieldqty
  ,splitfactor, nonewsupplydate, finishcal, leadtimecal
  ,workscope, lotsizesenabledsw
)

select b.item, b.loc, t.productionmethod, ' ' descr, v_init_eff_date eff
       ,1 priority, 0 minqty, 0 incqty, v_init_eff_date disc
       ,0 leadtime, 0 maxqty, 1 offsettype, 1 loadopt, 0 maxstartdur
       , 0 maxfindur, 0 splitordersw, nvl(b.bomnum, 0) bomnum
       ,1 enablesw, 0 minleadtime, 1440 * 365 * 100 maxleadtime
       ,0 yieldqty, 1 splitfactor
       ,v_init_eff_date nonewsupplydate, ' ' finishcal, ' ' leadtimecal
       ,' ' workscope, 0 lotsizesenabledsw
from sku s, bom b, loc l, item i, 
    (select item, loc, productionmethod 
       from productionmethod 
      where productionmethod = 'HTR'
    ) p,
    (select item, loc, productionmethod 
       from udt_yield_na 
      where productionmethod = 'HTR'
    ) t
where s.loc = l.loc
and l.loc_type = 2
and s.enablesw = 1 
and b.subord = i.item
and i.u_stock = 'C'
and b.bomnum = 1
and b.item = t.item
and b.loc = t.loc
and b.item = s.item
and b.loc = s.loc 
and b.item = p.item(+)
and b.loc = p.loc(+)
and exists ( select 1
               from udt_plant_status ps
              where ps.loc=B.loc
                and ps.res='HEATTREAT'
                and ps.status=1
            )
and p.item is null;

commit;

commit;

/*************************************************************
** Part 7: Create Production Step Records
*************************************************************/

insert into productionstep 
(  item, loc, productionmethod, stepnum
  ,nextsteptiming, fixedresreq, prodrate, proddur, prodoffset
  ,enablesw, spread, maxstartdur, eff, res, descr, loadoffsetdur
  ,prodcost, qtyuom, setup, inusebeforesw, prodfamily
)

select pm.item, pm.loc, pm.productionmethod
       , case when substr(r.res, 1, 6) = 'HTRCAP' then 1 
              else 2 
          end stepnum
       ,3 nextsteptiming, 0 fixedresreq, u.rate prodrate, 0 proddur
       ,0 prodoffset, 1 enablesw, 0 spread, 0 maxstartdur
       ,v_init_eff_date eff, r.res, ' ' descr, 0 loadoffsetdur, 0 prodcost
       ,case when substr(r.res, 1, 6) = 'HTRCAP' then 28
             else 18 
         end qtyuom
       , ' ' setup, 0 inusebeforesw, ' ' prodfamily 
from productionmethod pm, productionstep ps, res r, item i, 

        (select item, loc, nvl(round(((maxcap/efficiency)/maxdaysperwk)/maxhrsperday, 0), 1) rate
        from udt_yield_na
        where productionmethod = 'HTR'
        ) u

where pm.item = i.item
and (r.res = 'HTRCST'
                   ||'@'
--                   ||lpad(i.u_materialcode, 2, '0')
                   ||pm.loc  
                or r.res = 'HTRCAP'
                   ||'@'
--                   ||lpad(i.u_materialcode, 2, '0')
                   ||pm.loc
     )
and r.loc = pm.loc
and r.enablesw = 1
and pm.enablesw = 1
and pm.item = u.item
and pm.loc = u.loc
and pm.productionmethod = 'HTR'
and pm.item = ps.item(+)
and pm.loc = ps.loc(+)
and pm.productionmethod = ps.productionmethod(+)
and exists ( select 1
               from udt_plant_status ps
              where ps.loc=pm.loc
                and ps.res='HEATTREAT'
                and ps.status=1
            )
and ps.item is null;

commit;

/*************************************************************
** Part 8: Create Production Yield Records
*************************************************************/


insert into productionyield 
(   item, loc, productionmethod, eff
  ,qtyuom, outputitem, yieldqty 
)

select p.item
  , p.loc
  , p.productionmethod
  , v_init_eff_date eff
  ,18 qtyuom
  , p.item outputitem
  , 1 yieldqty
from productionyield y
  , productionmethod p
where p.productionmethod='HTR'
    and exists
    (select 1
    from udt_plant_status ps
    where ps.loc=p.loc
        and ps.res='HEATTREAT'
        and ps.status=1
    )
    and p.item = y.item(+)
    and p.loc = y.loc(+)
    and p.productionmethod = y.productionmethod(+)
and y.item is null;
commit;


/*************************************************************
** Part 9: Create Cost records for Heat treat
*************************************************************/

insert into cost 
(  cost, enablesw, cumulativesw, groupedsw
  ,sharedsw, qtyuom, currencyuom, accumcal, maxqty, maxutilization
)

select distinct u.cost
  , 1 enablesw
  , 0 cumulativesw
  , 0 groupedsw
  ,0 sharedsw
  , 18 qtyuom
  , 15 currencyuom
  , ' ' accumcal
  ,0 maxqty
  , 0 maxutilization
from cost c
  , (select 'LOCAL:RES:'
        ||res
        ||'-202' cost
    from res
    where subtype = 1
        AND SUBSTR(RES, 1, 6) = 'HTRCST'
            and exists
    (select 1
    from udt_plant_status ps
    where ps.loc=loc
        and ps.res='HEATTREAT'
        AND PS.STATUS=1
    )
    ) u
WHERE U.COST = C.COST(+)
and c.cost is null;

commit;

/*************************************************************
** Part 10: Create Production CostTier Records for Heat treat
*************************************************************/

insert into costtier 
(  breakqty, category, value, eff, cost )

select distinct 0 breakqty, 303 category
                ,q.unit_cost value , v_init_eff_date eff, c.cost  
  
from cost c, costtier t, 

    (select c.cost, nvl(q.unit_cost, 999) unit_cost

    from cost c, udt_default_parameters inspect_heat,

        (select matcode, loc, process, unit_cost 
           from udt_cost_unit 
          where process = 'HTR'
        ) q,

        (select res, loc, 
            case when substr(res, 8, 1) = '0' then substr(res, 9, 1) 
                 else substr(res, 8, 2) 
             end matcode
         from res
         where substr(res, 1, 6) = 'HTRCST'
         ) r

    where substr(c.cost, 11, 6) = 'HTRCST'
    and r.res = substr(c.cost, 11, length(c.cost)-4-10)
    and r.loc = q.loc(+)
    and r.matcode = q.matcode(+)
    --and inspect_heat.name='HEATTREAT_COST'
    ) q

where c.cost = q.cost
and c.cost = t.cost(+)
and t.cost is null;


commit;

/*************************************************************
** Part 11: Create Production  ResCost Records for Heat treat
*************************************************************/

insert into rescost 
(  category, res, localcost, tieredcost )

select distinct 202 category, u.res, t.cost localcost, ' ' tieredcost
from rescost r, costtier t, 

    (select r.res, 'LOCAL:RES:'
                             ||r.res
                             ||'-202' cost
    from res r
    where r.subtype = 1) u

where t.cost = u.cost
and u.cost = r.localcost(+)
and r.localcost is null;

commit;

--must run u_29_prd_resconstraint or _wk

end;
