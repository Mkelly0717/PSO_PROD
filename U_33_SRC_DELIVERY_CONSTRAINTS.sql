--------------------------------------------------------
--  DDL for Procedure U_33_SRC_DELIVERY_CONSTRAINTS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_33_SRC_DELIVERY_CONSTRAINTS" as


v_delivery_issues_pen number;
v_delivery_ai_collections_pen number;
v_delivery_aw_collections_pen number;
begin

    
  select numval1 into v_delivery_issues_pen
    from udt_default_parameters dfp
    where dfp.name='DELIVERY_ISSUES_PENALTY' ;
    
  select numval1 into v_delivery_ai_collections_pen
    from udt_default_parameters dfp
    where dfp.name='DELIVERY_AI_COLLECTIONS_PENALTY' ;

  select numval1 into v_delivery_aw_collections_pen
    from udt_default_parameters dfp
    where dfp.name='DELIVERY_AW_COLLECTIONS_PENALTY' ;
    
delete res 
    where substr(res, 1, 3) = 'DEL'
    and loc in (select loc from loc where u_area = 'NA');

commit;

insert into res (loc, type,     res,    cal,  cost,     descr,  avgskuchg,   avgfamilychg,  avgskuchgcost,  avgfamilychgcost,     levelloadsw,     
    levelseqnum,  criticalitem, checkmaxcap,  unitpenalty,  adjfactor,  source,  enablesw,  subtype,   qtyuom,   currencyuom,     productionfamilychgoveropt)

select distinct u.loc, 5 type,     u.res,     ' '  cal,     0 cost,     ' '  descr,     0 avgskuchg,     0 avgfamilychg,     0 avgskuchgcost,     0 avgfamilychgcost,     0 levelloadsw,     
    1 levelseqnum,     ' '  criticalitem,     1 checkmaxcap,     0 unitpenalty,     1 adjfactor,  u.source,     1 enablesw,     8 subtype,     18 qtyuom,     15 currencyuom,     0 productionfamilychgoveropt
from res r,
   
    (select distinct s.sourcing, s.source, s.dest, s.item,  'DEL:'||s.item||'@'||s.source||'->'||s.dest res,
        case when substr(s.sourcing,1,3) =  'COL' then s.source else s.dest end loc
    from sourcing s, vehicleloadline vll, vehicleload vl, loc l
    where vl.loadid = vll.loadid
    and substr(s.sourcing,5,3) =  'DEL'
    and vll.source = s.source  
    and vll.dest = s.dest  
    and vll.item = s.item
    and vll.schedshipdate >= trunc(sysdate)
    and s.dest = l.loc
    and l.u_area = 'NA'
    and vl.sourcestatus = 1
    ) u
    
where u.res = r.res(+)
and r.res is null;

commit;

insert into sourcingrequirement (stepnum,     nextsteptiming,     rate,     leadtime,     offset,     enablesw,     sourcing,     eff,     res,     item,     dest,     source,     qtyuom)

select 3 stepnum,     3 nextsteptiming,     1 rate,     0 leadtime,     0 offset,     1 enablesw,     u.sourcing,     scpomgr.u_jan1970 eff,     u.res,     u.item,     u.dest,     u.source,     18 qtyuom
from sourcingrequirement r, 

    (select distinct s.sourcing, s.source, s.dest, s.item,  'DEL:'||s.item||'@'||s.source||'->'||s.dest res,
    case when substr(s.sourcing,1,3) =  'COL' then s.source else s.dest end loc
    from sourcing s, vehicleloadline vll, vehicleload vl, loc l
    where vl.loadid = vll.loadid
    and substr(s.sourcing,5,3) =  'DEL'
    and vll.source = s.source  
    and vll.dest = s.dest  
    and vll.item = s.item
    and vll.schedshipdate >= trunc(sysdate)
    and s.dest = l.loc
    and l.u_area = 'NA'
    and vl.sourcestatus = 1
    ) u
    
where u.item = r.item(+)
and u.dest = r.dest(+)
and u.source = r.source(+)
and u.sourcing = r.sourcing(+)
and u.res = r.res(+)
and r.item is null;

commit;

insert into resconstraint (eff, policy, res, qty, dur, category, timeuom, qtyuom)

select distinct u.eff, 1 policy, u.res, u.qty qty, 1440*1 dur, u.category, 0 timeuom, 18 qtyuom
from resconstraint t,
  
  (select sourcing, source, dest, item, eff, sum(qty) qty, res, loc, category
  from
   
    (select s.sourcing, s.source, s.dest, s.item, vll.schedshipdate eff, sum(vll.qty) qty, 'DEL:'||s.item||'@'||s.source||'->'||s.dest res,
    case when substr(s.sourcing,1,7) = 'COL9DEL' then s.source else s.dest end loc, cc.category
    from sourcing s, vehicleloadline vll, vehicleload vl, loc l, 
    
        (select 11 category from dual union select 12 category from dual) cc 
    
    where vl.loadid = vll.loadid
    and substr(s.sourcing,1,7) in  ('ISS9DEL','COL9DEL','MER9DEL','STO9DEL')
    and vll.source = s.source  
    and vll.dest = s.dest  --and vll.dest in ('0100785031', 'ES1J')
    and vll.item = s.item
    and vll.schedshipdate >= trunc(sysdate)
    and s.dest = l.loc
    and l.u_area = 'NA'
    and vl.sourcestatus = 1
    group by s.sourcing, s.source, s.dest, s.item, vll.schedshipdate, cc.category
    )
    
  group by sourcing, source, dest, item, eff, res, loc, category
  ) u
   
where u.res = t.res(+)
and u.eff = t.eff(+)
and u.category = t.category(+)
and t.res is null;  

commit;

-- next day set max qty = 0 if no new delivery

insert into resconstraint (eff, policy, res, qty, dur, category, timeuom, qtyuom)

select r1.eff + 1 eff, 1 policy, r1.res, 0 qty,  
case when r2.eff is null then 52*7*1440 else (r2.eff - r1.eff - 1) * 1440 end dur, 12 category, 0 timeuom, 18 qtyuom
from 

  (select eff, pos, res
  from
    (select r.res, row_number() over (partition by r.res order by r.eff) as pos, r.eff
    from resconstraint r, loc l
    where substr(r.res,1,3) = 'DEL'
    and r.category = 12
    and r.qty <> 0
    and substr(res,instr(res, '->')+2) = l.loc
    and l.u_area = 'NA'
    )
  order by res,eff
  ) r1,

  (select eff, pos, res
  from
    (select r.res, row_number() over (partition by r.res order by r.eff) as pos, r.eff
    from resconstraint r, loc l
    where substr(r.res,1,3) = 'DEL'
    and r.category = 12
    and r.qty <> 0
    and substr(res,instr(res, '->')+2) = l.loc
    and l.u_area = 'NA'
    )
  order by res,eff
  ) r2
  
where r1.pos + 1 = r2.pos (+) 
and r1.res = r2.res (+)
and (r2.eff - r1.eff > 1 or r2.eff is null);

commit;

--doesn't permit shipments before vll.schedshipdate

insert into resconstraint (eff, policy, res, qty, dur, category, timeuom, qtyuom)

select trunc(sysdate) eff, 1 policy, res, 0 qty, (endeff - trunc(sysdate)) * 1440 dur, 12 category, 0 timeuom, 18 qtyuom 
from

    (select r.res, row_number() over (partition by r.res order by r.eff) as pos, r.eff endeff
    from resconstraint r, loc l
    where substr(r.res,1,3) = 'DEL'
    and r.category = 12
    and r.qty <> 0
    and substr(res,instr(res, '->')+2) = l.loc
    and l.u_area = 'NA'
    )
    
where pos = 1
and endeff <> trunc(sysdate) --and res = 'DEL:4001AI@3000021068->USKZ'
order by res,endeff;

commit;

insert into  igpmgr.intups_respenalty (eff, rate, category, res, qtyuom, timeuom, currencyuom)

select distinct scpomgr.u_jan1970 eff, case when u.res like '%RU%' then v_delivery_issues_pen
                                            when u.res like '%AI%' then v_delivery_ai_collections_pen
                                            when u.res like '%AW%' then v_delivery_aw_collections_pen
                                            else 10
                                        end rate
                , u.category, u.res, 18 qtyuom, 0 timeuom, 15 currencyuom
from respenalty r,
    
    (select distinct  r.res, cc.category
    from resconstraint r, loc l,
    
        (select 111 category from dual union select 112 category from dual) cc
        
    where substr(r.res,1,3) = 'DEL'
    and substr(res,instr(res, '->')+2) = l.loc
    and l.u_area = 'NA'
    ) u
    
where scpomgr.u_jan1970 = r.eff (+)
AND U.CATEGORY = R.CATEGORY (+)
AND U.RES = R.RES (+);
    
commit;

/*
for sourcestatus = 3, in-transit, create category 10 schedrcpts constraints at destination
  -- this is done in u_15_sku_daily
*/


end;
