--------------------------------------------------------
--  DDL for Procedure U_33_SRC_DELIVERY
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_33_SRC_DELIVERY" as

v_ohpost date;

BEGIN

select max(s.ohpost) into v_ohpost 
from sku s, loc l
where s.loc = l.loc
and l.u_area = 'NA';

delete sourcing where substr(sourcing,5,3) = 'DEL'
    and dest in (select loc from loc where u_area = 'NA');
    
commit;

/*

declare
  cursor cur_selected is
  
        select vll.item, vll.dest, vll.source, vll.loadid, nvl(c.orderid, 0) orderid,   
            vl.shipdate, vl.arrivdate
        from vehicleload vl, vehicleloadline vll, loc l, custorder c
        where vll.loadid = vl.loadid
        and vll.dest = l.loc
        and l.u_area = 'NA' 
        and l.loc_type = 3 
        and vll.item = c.item(+)
        and vll.dest = c.loc(+)
        and vll.schedarrivdate = c.shipdate(+)
         
    for update of vll.schedshipdate;
begin
  for cur_record in cur_selected loop
  
    update vehicleloadline 
    set schedshipdate  = cur_record.shipdate
    where current of cur_selected;
    
    update vehicleloadline 
    set schedarrivdate  = cur_record.arrivdate
    where current of cur_selected;
    
    update vehicleloadline 
    set orderid  = cur_record.orderid
    where current of cur_selected;

  end loop;
  commit;
end;

declare
  cursor cur_selected is
  
        select vll.item, vll.dest, vll.source, vll.loadid, nvl(c.orderid, 0) orderid,   
            vl.shipdate, vl.arrivdate
        from vehicleload vl, vehicleloadline vll, loc l, custorder c
        where vll.loadid = vl.loadid
        and vll.source = l.loc
        and l.u_area = 'NA' 
        and l.loc_type = 3 
        and vll.item = c.item(+)
        and vll.source = c.loc(+)
        and vll.schedshipdate = c.shipdate(+)
         
    for update of vll.schedshipdate;
begin
  for cur_record in cur_selected loop
  
    update vehicleloadline 
    set schedshipdate  = cur_record.shipdate
    where current of cur_selected;
    
    update vehicleloadline 
    set schedarrivdate  = cur_record.arrivdate
    where current of cur_selected;
    
    update vehicleloadline 
    set orderid  = cur_record.orderid
    where current of cur_selected;

  end loop;
  commit;
end;

*/

insert into sourcing (item, dest, source, transmode, eff,     factor, arrivcal,     majorshipqty,     minorshipqty,     enabledyndepsw,     shrinkagefactor,     maxshipqty,     abbr,     sourcing,     disc,     
    maxleadtime,     minleadtime,     priority,     enablesw,     yieldfactor,     supplyleadtime,     costpercentage,     supplytransfercost,     nonewsupplydate,     shipcal,     
    ff_trigger_control,     pullforwarddur,     splitqty,     loaddur,     unloaddur,     reviewcal,     uselookaheadsw,     convenientshipqty,     convenientadjuppct,     convenientoverridethreshold,     
    roundingfactor,     ordergroup,     ordergroupmember,     lotsizesenabledsw,     convenientadjdownpct)

select distinct u.item, u.dest, u.source, 'TRUCK' transmode, scpomgr.u_jan1970 eff,     1 factor,    ' ' arrivcal,     0 majorshipqty,     0 minorshipqty,     1 enabledyndepsw,     0 shrinkagefactor,     0 maxshipqty,     
    ' ' abbr, 'ISS9DEL' sourcing,     scpomgr.u_jan1970 disc,     1440 * 365 * 100 maxleadtime,     u.minleadtime,     1 priority,     1 enablesw,     100 yieldfactor,     0 supplyleadtime,     
    100 costpercentage,     0 supplytransfercost,     scpomgr.u_jan1970 nonewsupplydate,     ' ' shipcal,    ''  ff_trigger_control,     0 pullforwarddur,     0 splitqty,     0 loaddur,     0 unloaddur,    
    ' ' reviewcal,     1 uselookaheadsw,     0 convenientshipqty,     0 convenientadjuppct,     0 convenientoverridethreshold,     0 roundingfactor,     ' ' ordergroup,     ' ' ordergroupmember,     0 lotsizesenabledsw,     
    0 convenientadjdownpct
from  
                    
    (select item, dest, source, max(minleadtime) minleadtime
    from
                
          (select vll.item, vll.dest, vll.source, 
            case when schedarrivdate-schedshipdate < 1 then 0 else (schedarrivdate-schedshipdate)*1440 end minleadtime
          from vehicleloadline vll, vehicleload vl, loc d
          where vll.loadid = vl.loadid
          and vll.dest <> vll.source
          and vll.dest = d.loc
          and vll.schedshipdate >= trunc(sysdate)
          and d.u_area = 'NA'
          and d.loc_type = 3
          and vl.sourcestatus = 1
          )
                  
    group by item, dest, source  

    ) u;
    
commit;

insert into sourcing (item, dest, source, transmode, eff,     factor, arrivcal,     majorshipqty,     minorshipqty,     enabledyndepsw,     shrinkagefactor,     maxshipqty,     abbr,     sourcing,     disc,     
    maxleadtime,     minleadtime,     priority,     enablesw,     yieldfactor,     supplyleadtime,     costpercentage,     supplytransfercost,     nonewsupplydate,     shipcal,     
    ff_trigger_control,     pullforwarddur,     splitqty,     loaddur,     unloaddur,     reviewcal,     uselookaheadsw,     convenientshipqty,     convenientadjuppct,     convenientoverridethreshold,     
    roundingfactor,     ordergroup,     ordergroupmember,     lotsizesenabledsw,     convenientadjdownpct)

select distinct u.item, u.dest, u.source, 'TRUCK' transmode, scpomgr.u_jan1970 eff,     1 factor,    ' ' arrivcal,     0 majorshipqty,     0 minorshipqty,     1 enabledyndepsw,     0 shrinkagefactor,     0 maxshipqty,     
    ' ' abbr, 'COL9DEL' sourcing,     scpomgr.u_jan1970 disc,     1440 * 365 * 100 maxleadtime,     u.minleadtime,     1 priority,     1 enablesw,     100 yieldfactor,     0 supplyleadtime,     
    100 costpercentage,     0 supplytransfercost,     scpomgr.u_jan1970 nonewsupplydate,     ' ' shipcal,    ''  ff_trigger_control,     0 pullforwarddur,     0 splitqty,     0 loaddur,     0 unloaddur,    
    ' ' reviewcal,     1 uselookaheadsw,     0 convenientshipqty,     0 convenientadjuppct,     0 convenientoverridethreshold,     0 roundingfactor,     ' ' ordergroup,     ' ' ordergroupmember,     0 lotsizesenabledsw,     
    0 convenientadjdownpct
from  
                    
    (select item, dest, source, max(minleadtime) minleadtime
    from
                
          (select vll.item, vll.dest, vll.source, 
            case when schedarrivdate-schedshipdate < 1 then 0 else (schedarrivdate-schedshipdate)*1440 end minleadtime
          from vehicleloadline vll, vehicleload vl, loc s
          where vll.loadid = vl.loadid
          and vll.dest <> vll.source
          and vll.source = s.loc
          and vll.schedshipdate >= trunc(sysdate)
          and s.u_area = 'NA'
          and s.loc_type = 3 
          and vl.sourcestatus = 1
          )
                  
    group by item, dest, source  

    ) u;

commit;

insert into sourcingdraw 
( sourcing, eff, item, dest, source, drawqty, qtyuom)
select c.sourcing, v_init_eff_date eff, c.item, c.dest, c.source
       ,1 drawqty, 18 qtyuom 
from sourcing c, sourcingdraw d
where c.item = d.item(+)
and c.dest = d.dest(+)
and c.source = d.source(+)
and c.sourcing = d.sourcing(+)
and d.item is null;

commit;

/*******************************************************************************
** Part 11: Add Sourcing Yield Records
*******************************************************************************/
insert into sourcingyield 
( sourcing, eff, item, dest, source, yieldqty, qtyuom)
select c.sourcing, v_init_eff_date eff, c.item, c.dest, c.source
       ,1 yieldqty, 18 qtyuom 
from sourcing c, sourcingyield d
where c.item = d.item(+)
and c.dest = d.dest(+)
and c.source = d.source(+)
and c.sourcing = d.sourcing(+)
and d.item is null;

commit;


/*******************************************************************************
** Part 12: Add in the Deliveries for Stock Transfers
*******************************************************************************/

--insert into igpmgr.intups_sourcing (item, dest, source, transmode, eff,     factor, arrivcal,     majorshipqty,     minorshipqty,     enabledyndepsw,     shrinkagefactor,     maxshipqty,     abbr,     sourcing,     disc,     
--    maxleadtime,     minleadtime,     priority,     enablesw,     yieldfactor,     supplyleadtime,     costpercentage,     supplytransfercost,     nonewsupplydate,     shipcal,     
--    ff_trigger_control,     pullforwarddur,     splitqty,     loaddur,     unloaddur,     reviewcal,     uselookaheadsw,     convenientshipqty,     convenientadjuppct,     convenientoverridethreshold,     
--    roundingfactor,     ordergroup,     ordergroupmember,     lotsizesenabledsw,     convenientadjdownpct)
--
--
--select distinct u.item, u.dest, u.source, 'TRUCK' transmode, scpomgr.u_jan1970 eff,     1 factor,    ' ' arrivcal,     0 majorshipqty,     0 minorshipqty,     1 enabledyndepsw,     0 shrinkagefactor,     0 maxshipqty,     
--    ' ' abbr, 'STX9DEL' sourcing,     scpomgr.u_jan1970 disc,     1440 * 365 * 100 maxleadtime,     u.minleadtime,     1 priority,     1 enablesw,     100 yieldfactor,     0 supplyleadtime,     
--    100 costpercentage,     0 supplytransfercost,     scpomgr.u_jan1970 nonewsupplydate,     ' ' shipcal,    ''  ff_trigger_control,     0 pullforwarddur,     0 splitqty,     0 loaddur,     0 unloaddur,    
--    ' ' reviewcal,     1 uselookaheadsw,     0 convenientshipqty,     0 convenientadjuppct,     0 convenientoverridethreshold,     0 roundingfactor,     ' ' ordergroup,     ' ' ordergroupmember,     0 lotsizesenabledsw,     
--    0 convenientadjdownpct
--from                     
--    (
--    
--    
--    select item, dest, source, max(minleadtime) minleadtime
--    from
--                
--          (select vll.item, vll.dest, vll.source, 
--            case when schedarrivdate-schedshipdate < 1 then 0 else (schedarrivdate-schedshipdate)*1440 end minleadtime
--          from vehicleloadline vll, vehicleload vl, loc d, loc s
--          where vll.loadid = vl.loadid
--          and vll.dest <> vll.source
--          and vll.dest = d.loc
--          and vll.source=s.loc
--          and vll.schedshipdate >= trunc(sysdate)
--          and d.u_area = 'NA'
--          and s.u_area='NA'
--          and d.loc_type in ('2','4')
--          and s.loc_type in ('2','4')
--          and vl.sourcestatus = 1
--          )
--                  
--    group by item, dest, source  
--
--    ) u;
--    
--    commit;


end;
