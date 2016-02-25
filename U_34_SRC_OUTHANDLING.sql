--------------------------------------------------------
--  DDL for Procedure U_34_SRC_OUTHANDLING
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_34_SRC_OUTHANDLING" as

begin

delete sourcingrequirement
where substr(res, 1, 3) = 'OUT'
    and dest in (select loc from loc where u_area = 'NA');
    
commit;

delete res 
where substr(res, 1, 3) = 'OUT'
    and loc in (select loc from loc where u_area = 'NA');

commit;

insert into res (loc, type,     res,    cal,  cost,     descr,  avgskuchg,   avgfamilychg,  avgskuchgcost,  avgfamilychgcost,     levelloadsw,     
    levelseqnum,  criticalitem, checkmaxcap,  unitpenalty,  adjfactor,  source,  enablesw,  subtype,   qtyuom,   currencyuom,     productionfamilychgoveropt)

select distinct u.loc, 8 type,     u.res,     ' '  cal,     0 cost,     ' '  descr,     0 avgskuchg,     0 avgfamilychg,     0 avgskuchgcost,     0 avgfamilychgcost,     0 levelloadsw,     
    1 levelseqnum,     ' '  criticalitem,     1 checkmaxcap,     0 unitpenalty,     1 adjfactor,  ' ' source,     1 enablesw,     8 subtype,     18 qtyuom,     11 currencyuom,     0 productionfamilychgoveropt
from res r,
   
    (select distinct 'OUTHANDLING@'||source res, source loc
    from sourcing c, loc l
    where c.source = l.loc
    and l.u_area = 'NA'
    and l.loc_type in (2, 4)
    ) u
    
where u.res = r.res(+)
and r.res is null;

commit;

insert into sourcingrequirement (stepnum,     nextsteptiming,     rate,     leadtime,     offset,     enablesw,     sourcing,     eff,     res,     item,     dest,     source,     qtyuom)

select 2 stepnum,     3 nextsteptiming,     1 rate,     0 leadtime,     0 offset,     1 enablesw,     u.sourcing,     scpomgr.u_jan1970 eff,     u.res,     u.item,     u.dest,     u.source,     18 qtyuom
from sourcingrequirement r, 

    (select distinct 'OUTHANDLING@'||source res, c.item, c.dest, c.source, c.sourcing
    from sourcing c, loc l
    where c.source = l.loc
    and l.u_area = 'NA'
    and l.loc_type in (2, 4)
    ) u
    
where u.item = r.item(+)
and u.dest = r.dest(+)
and u.source = r.source(+)
and u.sourcing = r.sourcing(+)
and u.res = r.res(+)
and r.item is null;

commit;

insert into resconstraint (eff, policy, res, qty, dur, category, timeuom, qtyuom)

select /* +parallel(4) */  nvl(k.eff, c.eff) eff, 1 policy, c.res, 
    case when k.opt = 1 then 0 else 999999999 end qty, 1440*1 dur,  12 category, 0 timeuom, 18 qtyuom  
    from res rr,

        (select /* +parallel(4) */  distinct 'OUTHANDLING@'||c.loc res, c.loc, k.eff
        from productionmethod c, loc l,
        
            (select distinct eff from skuconstraint where category = 1
            ) k
        
        where c.loc = l.loc
        and l.u_area = 'NA' 
        and l.loc_type in (2, 4) 
        ) c,
        
        (select p.eff, p.res, p.dow, nvl(s.opt, p.opt) opt
        from

            (select f.eff, cd.res, f.dow, cd.opt
            from

                (select distinct eff, to_char(eff, 'D') dow from skuconstraint where category = 1
                ) f, 

                (select cd.cal res, c.type, to_date('01/01/1970', 'MM/DD/YYYY')+eff/1440 eff,  
                    to_char(to_date('01/01/1970', 'MM/DD/YYYY')+eff/1440, 'D') dow, cd.opt 
                from caldata cd, cal c,

                    (select min(eff) startdate, cal
                    from caldata
                    where descr = 'PATTERN'
                    group by cal
                    ) e
                    
                where cd.cal = c.cal
                and c.type = 6
                and cd.cal = e.cal
                and substr(cd.cal, 1, 11) in ('OUTHANDLING')
                and cd.eff between e.startdate and e.startdate+1440*13
                ) cd
                        
            where f.dow = cd.dow
            ) p, 

            (select cal res, to_date('01/01/1970', 'MM/DD/YYYY')+eff/1440 eff, opt
            from caldata
            where descr = 'HOLIDAY'
            ) s
        where p.res = s.res(+)
        and p.eff = s.eff(+)
        ) k
        
where c.eff = k.eff(+)
and c.res = k.res(+)
and c.res = rr.res(+)
and rr.res is not null;
        
commit;

insert into  respenalty (eff, rate, category, res, qtyuom, timeuom, currencyuom)

select distinct scpomgr.u_jan1970 eff, 9000 rate, 112 category, u.res, 18 qtyuom, 0 timeuom, 15 currencyuom
from respenalty r,
    
    (select distinct  r.res, 112 category
    from resconstraint r, loc l, res rr
    where substr(r.res,1,3) = 'OUT'
    and r.res = rr.res
    and rr.loc = l.loc
    and l.u_area = 'NA'
    ) u
    
where scpomgr.u_jan1970 = r.eff (+)
and u.category = r.category (+)
and u.res = r.res (+)
and r.res is null;
    
commit;

end;
