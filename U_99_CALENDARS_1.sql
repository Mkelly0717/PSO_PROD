--------------------------------------------------------
--  DDL for Procedure U_99_CALENDARS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_99_CALENDARS" as

begin

insert into cal

select distinct res, ' ' descr, 6 type, ' ' master, 0 numfcstper, 0 rollingsw
from cal c,
    (select w.loc, r.res, 
        case when rep in (6, 7) then rep else 5 end qty
    from tmp_workdays w, loc l, res r
    where w.loc = l.loc
    and l.u_area = 'NA'
    and w.loc = r.loc
    and (substr(r.res, 1, 6) in ('INSCAP', 'REPCAP') or substr(r.res, 1, 11) in ('OUTHANDLING'))
    ) u
    
where u.res = c.cal(+)
and c.cal is null;

commit;

insert into caldata

select u.cal, u.altcal, u.eff, u.opt, u.repeat, u.avail, u.descr, u.perwgt, u.allocwgt, u.covdur
from caldata cd,

    (select u.res cal, ' ' altcal, 24196320 eff, 
        case when qty = 7 then 2 else 1 end opt, 0 repeat, 0 avail, 'PATTERN' descr, 0 perwgt, 0 allocwgt, 0 covdur
    from 

        (select w.loc, r.res, 
            case when rep in (6, 7) then rep else 5 end qty
        from tmp_workdays w, loc l, res r
        where w.loc = l.loc
        and l.u_area = 'NA'
        and w.loc = r.loc 
        and (substr(r.res, 1, 6) in ('INSCAP', 'REPCAP') or substr(r.res, 1, 11) in ('OUTHANDLING'))
        ) u

    union

    select u.res, ' ' altcal, cd.eff,  2 opt, 0 repeat, 0 avail, ' ' descr, 0 perwgt, 0 allocwgt, 0 covdur
    from 

        (select w.loc, r.res, 
            case when rep in (6, 7) then rep else 5 end qty
        from tmp_workdays w, loc l, res r
        where w.loc = l.loc
        and l.u_area = 'NA'
        and w.loc = r.loc 
        and (substr(r.res, 1, 6) in ('INSCAP', 'REPCAP') or substr(r.res, 1, 11) in ('OUTHANDLING'))
        ) u,

        (select 24197760 eff from dual union
        select 24199200 from dual union
        select 24200640 from dual union
        select 24202080 from dual union
        select 24203520 from dual
        ) cd

    union

    select u.res, ' ' altcal, 24204960 eff, 
        case when qty in (6, 7) then 2 else 1 end opt, 0 repeat, 0 avail, ' ' descr, 0 perwgt, 0 allocwgt, 0 covdur
    from 

        (select w.loc, r.res, 
            case when rep in (6, 7) then rep else 5 end qty
        from tmp_workdays w, loc l, res r
        where w.loc = l.loc
        and l.u_area = 'NA'
        and w.loc = r.loc 
        and (substr(r.res, 1, 6) in ('INSCAP', 'REPCAP') or substr(r.res, 1, 11) in ('OUTHANDLING'))
        ) u

    ) u

where u.cal = cd.cal(+)
and u.eff = cd.eff(+)
and cd.cal is null;

commit;

insert into caldata

select c.cal, ' ' altcal, u.eff, 1 opt, 0 repeat, 0 avail, 'HOLIDAY' descr, 0 perwgt, 0 allocwgt, 0 covdur
from cal c,  

    (select (to_date('05/30/2016', 'MM/DD/YYYY') - to_date('01/01/1970', 'MM/DD/YYYY'))*1440 eff from dual union
    select (to_date('07/04/2016', 'MM/DD/YYYY') - to_date('01/01/1970', 'MM/DD/YYYY'))*1440 eff from dual union
    select (to_date('09/05/2016', 'MM/DD/YYYY') - to_date('01/01/1970', 'MM/DD/YYYY'))*1440 eff from dual union
    select (to_date('11/24/2016', 'MM/DD/YYYY') - to_date('01/01/1970', 'MM/DD/YYYY'))*1440 eff from dual union
    select (to_date('12/26/2016', 'MM/DD/YYYY') - to_date('01/01/1970', 'MM/DD/YYYY'))*1440 eff from dual 
    ) u

where (substr(c.cal, 1, 6) in ('INSCAP', 'REPCAP') or substr(c.cal, 1, 11) in ('OUTHANDLING'));

commit;

end;
