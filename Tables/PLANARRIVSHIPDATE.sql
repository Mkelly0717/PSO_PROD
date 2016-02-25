--------------------------------------------------------
--  DDL for Trigger PLANARRIVSHIPDATE
--------------------------------------------------------

  CREATE OR REPLACE TRIGGER "SCPOMGR"."PLANARRIVSHIPDATE" 
before update of source on scpomgr.planarriv
for each row
declare
  v_transittime number;
begin
    
  v_transittime := 2;  
  
  select 
  case when pctransittime is not null then pctransittime 
     when geotransittime is not null then geotransittime
     when cotransittime is not null then cotransittime
     else 0
  end transitime  into v_transittime 
  from 
    (select s.loc, nvl(min(u.transittime),0) pctransittime
    from scpomgr.udt_cost_transit u, loc s, loc d
    where salesgroup = 'PA'
    and source_pc = s.postalcode
    and dest_pc = d.postalcode
    and source_geo = s.u_geocode
    and dest_geo = d.u_geocode
    and source_co = s.country
    and dest_co = d.country
    and direction in ('Z1AA','ALL') 
    and s.loc = :new.source 
    and d.loc = :new.dest 
    group by s.loc,source_pc, dest_pc, source_co, dest_co) pc,

    (select s.loc, nvl(min(u.transittime),0) geotransittime
    from scpomgr.udt_cost_transit u, loc s, loc d
    where salesgroup = 'PA'
    and source_pc = ' '
    and dest_pc = ' '
    and source_geo = s.u_geocode
    and dest_geo = d.u_geocode
    and source_co = s.country
    and dest_co = d.country
    and direction in ('Z1AA','ALL') 
    and s.loc = :new.source
    and d.loc = :new.dest 
    group by s.loc,source_geo, dest_geo, source_co, dest_co) geo,

    (select s.loc, nvl(min(u.transittime),0) cotransittime
    from scpomgr.udt_cost_transit u, loc s, loc d
    where salesgroup = 'PA'
    and source_pc = ' '
    and dest_pc = ' '
    and source_geo is null
    and dest_geo is null
    and source_co = s.country
    and dest_co = d.country
    and direction in ('Z1AA','ALL') 
    and s.loc = :new.source
    and d.loc = :new.dest 
    group by s.loc, source_geo, dest_geo, source_co, dest_co) co,

    (select :new.source loc, 0 transittime from dual) d

  where d.loc = pc.loc (+)
  and  d.loc = geo.loc (+)
  and  d.loc = co.loc (+);
  
  
  if :new.source <> :old.source and :new.schedshipdate = :old.schedshipdate then
    :new.schedshipdate := :old.schedarrivdate - v_transittime;
  end if;
end;

ALTER TRIGGER "SCPOMGR"."PLANARRIVSHIPDATE" ENABLE
