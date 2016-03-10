--------------------------------------------------------
--  DDL for Procedure U_29_PRD_RESCONSTRAINT_DY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_29_PRD_RESCONSTRAINT_DY" as


begin

/******************************************************************
** Part 1: Create resource constraints for INS and REP in daily  * 
**         periods skuconstraint must be populated first          * 
**         and assign maximum capacity constraint                 *
******************************************************************/
delete resconstraint
where res in 
 
    (select distinct k.res
    from  resconstraint k, res r, loc l
    where substr(k.res, 1, 6) in ('INSCAP', 'REPCAP')
    and k.res = r.res
    and r.loc = l.loc
    and l.u_area = 'NA'  
    );

commit;

insert into resconstraint ( eff, policy, qty, dur, category, res, qtyuom, timeuom )

select u.eff, 1 policy, u.qty*1*1 qty, 1440*1*1 dur, u.category, u.res, 28 qtyuom, 0 timeuom  --need to factor not by 5 days per week
from resconstraint c,

    (select nvl(o.eff, pm.eff) eff, o.opt, pm.res, pm.loc, 
        case when nvl(o.opt, 2) = 1 then 0 else pm.qty end qty, pm.category
    from

        (select k.eff, r.res, r.loc, nvl(u.maxcaphrs, 8) qty, 12 category
            from res r, 
                 
            (select distinct eff from skuconstraint where category = 1
            ) k,
                
                (select distinct productionmethod, loc, max(maxhrsperday) maxcaphrs
                from udt_yield_na
                where productionmethod in ('INS', 'REP')  
                group by productionmethod, loc
                ) u
                    
        where r.subtype = 1
        and substr(r.res, 1, 6) in ('INSCAP', 'REPCAP') 
        and substr(r.res, 1, 3) = u.productionmethod
        and r.loc = u.loc 
        ) pm, 

        (select p.eff, p.res, p.dow, nvl(s.opt, p.opt) opt
        from

            (select f.eff, cd.res, f.dow, cd.opt
            from

                (select distinct eff, to_char(eff, 'D') dow from skuconstraint where category = 1
                ) f, 

                (select cd.cal res, c.type, to_date('01/01/1970', 'MM/DD/YYYY')+eff/1440 eff,  
                    to_char(to_date('01/01/1970', 'MM/DD/YYYY')+EFF/1440, 'D') dow, cd.opt 
                from caldata cd, cal c,

                    (select min(eff) startdate, cal
                    from caldata
                    where descr = 'PATTERN'
                    group by cal
                    ) e
                    
                where cd.cal = c.cal
                and c.type = 6
                and cd.cal = e.cal
                and substr(cd.cal, 1, 6) in ('INSCAP', 'REPCAP')
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
        ) o

    where pm.res = o.res(+)
    and pm.eff = o.eff(+)
    ) u

where u.res = c.res(+)
and u.eff = c.eff(+)
and u.category = c.category(+)
and c.res is null
order by u.res, u.eff;

commit;

/******************************************************************
** Part 2: Create Resource Penalty                               *
** These rate value is updated in PART 5.                        *
******************************************************************/

delete respenalty
where res in 

    (select distinct k.res
    from  resconstraint k, res r, loc l
    where substr(k.res, 1, 6) in ('INSCAP', 'REPCAP')
    and k.res = r.res
    and r.loc = l.loc
    and l.u_area = 'NA'  
    );

commit;

insert into respenalty 
( eff, rate, category, res, currencyuom, qtyuom, timeuom )

select  v_init_eff_date eff, 900 rate, 112 category, res, 15 currencyuom, 28 qtyuom, 0 timeuom
from res
where res in 

    (select distinct k.res
    from  resconstraint k, res r, loc l
    where substr(k.res, 1, 6) in ('INSCAP', 'REPCAP')
    and k.res = r.res
    and r.loc = l.loc
    and l.u_area = 'NA'  
    );

commit;


/******************************************************************
** Part 3: Assign minimum capacity constraint                     * 
******************************************************************/
insert into resconstraint ( eff, policy, qty, dur, category, res, qtyuom, timeuom )

select u.eff, 1 policy, u.qty*1*1 qty, 1440*1*1 dur, u.category
       ,u.res, 28 qtyuom, 0 timeuom
from resconstraint c,

    (select nvl(o.eff, pm.eff) eff, o.opt, pm.res, pm.loc, 
        case when nvl(o.opt, 2) = 1 then 0 else pm.qty end qty, pm.category
    from

        (select k.eff, r.res, r.loc, nvl(u.mincaphrs, 0) qty, 11 category
            from res r, 
                 
            (select distinct eff from skuconstraint where category = 1
            ) k,
                
                (select distinct productionmethod, loc, max(minhrsperday) mincaphrs
                from udt_yield_na
                where productionmethod in ('INS', 'REP')  
                group by productionmethod, loc
                ) u
                    
        where r.subtype = 1
        and substr(r.res, 1, 6) in ('INSCAP', 'REPCAP') 
        and substr(r.res, 1, 3) = u.productionmethod
        and r.loc = u.loc 
        ) pm, 

        (select p.eff, p.res, p.dow, nvl(s.opt, p.opt) opt
        from

            (select f.eff, cd.res, f.dow, cd.opt
            from

                (select distinct eff, to_char(eff, 'D') dow from skuconstraint where category = 1
                ) f, 

                (select cd.cal res, c.type, to_date('01/01/1970', 'MM/DD/YYYY')+eff/1440 eff,  
                    to_char(to_date('01/01/1970', 'MM/DD/YYYY')+EFF/1440, 'D') dow, cd.opt 
                from caldata cd, cal c,

                    (select min(eff) startdate, cal
                    from caldata
                    where descr = 'PATTERN'
                    group by cal
                    ) e
                    
                where cd.cal = c.cal
                and c.type = 6
                and cd.cal = e.cal
                and substr(cd.cal, 1, 6) in ('INSCAP', 'REPCAP')
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
        ) o

    where pm.res = o.res(+)
    and pm.eff = o.eff(+)
    ) u
    
where u.res = c.res(+)
and u.eff = c.eff(+)
and u.category = c.category(+)
and c.res is null
order by u.res, u.eff;

commit;

/******************************************************************
** Part 4: Create Resource Penalty                                * 
** These rate value is updated in PART 5.                         *
******************************************************************/
insert into respenalty 
( eff, rate, category, res, currencyuom, qtyuom, timeuom )

select  v_init_eff_date eff, 900 rate, 111 category, res, 15 currencyuom
        ,28 qtyuom, 0 timeuom
from res
where res in 

    (select distinct k.res
    from  resconstraint k, res r, loc l
    where substr(k.res, 1, 6) in ('INSCAP', 'REPCAP')
    and k.res = r.res
    and r.loc = l.loc
    and l.u_area = 'NA'  
    );

commit;

/******************************************************************
** Part 5: Update RESPENALTY for INSCAP and REPCAP.
******************************************************************/
merge into respenalty resp
using (
    select y.loc, ps.res, round(sum((dp.numval1* maxcap)/80))  rate
      from udt_yield_na y, productionstep ps, udt_default_parameters dp
     where y.productionmethod in ('INS','REP')
       and maxcap > 0
       and yield > 0
       and ps.loc=y.loc
       and ps.item=y.item
       and ps.productionmethod=y.productionmethod
       and ps.qtyuom=28
       and dp.name='PENALTY_INSCAP_FACTOR'
    group by y.loc, ps.res
) yield
on ( resp.res=yield.res )
when matched then
   update set resp.rate=yield.rate
     where resp.category in (111,112);
commit;

end;
