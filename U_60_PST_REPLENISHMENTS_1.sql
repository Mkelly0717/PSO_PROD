--------------------------------------------------------
--  DDL for Procedure U_60_PST_REPLENISHMENTS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_60_PST_REPLENISHMENTS" as
v_ohpost date;
begin

select max(s.ohpost) into v_ohpost 
from sku s, loc l
where s.loc = l.loc
and l.u_area = 'NA';


delete from planarriv p
where exists (select * from loc l where  l.loc = p.dest and  l.u_area = 'NA');

commit;

-- Insert deliveries into planarriv  
/* MAK -- Make a copy of the sourcing metric table */
EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_SOURCINGMETRIC_NA'; --REPL(TMP_SOURCINGMETRIC)

insert into TMP_SOURCINGMETRIC_NA                       -- repl(tmp_sourcingmetric)
     (select distinct s.sourcing, s.item, s.dest, s.source, s.eff, s.value, s.dur, s.category, s.currencyuom, s.qtyuom, null u_z1banum
     from sim_sourcingmetric s, loc l
     where  s.dest = l.loc
     and l.u_area = 'NA'
     and s.simulation_name = 'AD'
--     and substr(s.sourcing, 5, 3) = 'DEL'
     and s.category in (417,418)
     and value > 0
     );
     
commit;


insert into planarriv (item, dest, source, sourcing,   transmode, firmplansw, needarrivdate,  schedarrivdate,     needshipdate,     --repl(planarriv)
    schedshipdate,     qty,  expdate, shrinkagefactor,   transname,   action,  actiondate, actionallowedsw, actionqty, reviseddate,        
    availtoshipdate, substqty,  ff_trigger_control, headerseqnum,  covdurscheddate,   departuredate,     deliverydate, orderplacedate,  supporderqty,  
    revisedexpdate,     nonignorableqty, seqnum, u_sales_document, u_ship_condition, u_custorderid, u_sap_defplant, u_sent)

select item, dest, source, sourcing,   transmode, 0 firmplansw,     arrivdate needarrivdate,     arrivdate schedarrivdate,     shipdate needshipdate,     
    shipdate schedshipdate, qty,  scpomgr.u_jan1970 expdate,      0 shrinkagefactor,     ' ' transname,     
    0 action,     scpomgr.u_jan1970 actiondate,     0 actionallowedsw,     0 actionqty,     scpomgr.u_jan1970 reviseddate,        
    shipdate availtoshipdate,     0 substqty,      '' ff_trigger_control,     0 headerseqnum,     scpomgr.u_jan1970 covdurscheddate,     
    shipdate departuredate,     arrivdate deliverydate,     scpomgr.u_jan1970 orderplacedate,     0 supporderqty,     
    scpomgr.u_jan1970 revisedexpdate,     0 nonignorableqty,         
    row_number()
              over (partition by item, dest order by item, dest ) as seqnum, u_sales_document, u_ship_condition, 
    orderid u_custorderid,  u_sap_defplant, u_sent
from 

(
   /* Shipments for sourcing metric records with matching transportation dates and Z1AA(Issue) orders */
 select t.item, t.dest, t.source, vll.schedshipdate shipdate, vll.schedarrivdate arrivdate, t.sourcing, 'TRUCK' transmode, 
  t.dur, o.qty qty, c.minleadtime,  0 mininflow, o.orderid, o.u_sales_document, o.u_ship_condition,
  o.u_defplant u_sap_defplant, 1 u_sent
  from TMP_SOURCINGMETRIC_NA t, metriccategory m, sourcing c , custorder o, vehicleloadline vll
  where t.category = m.category 
  and substr(t.sourcing, 1, 7) in ('ISS9DEL')
  and t.item = c.item
  and t.dest = c.dest
  and t.source = c.source
  and t.sourcing = c.sourcing 
  and t.value > 0  
  and o.u_sales_document in ('Z1AA')
  and o.item = t.item 
  and o.loc = t.dest
  and vll.u_overallsts <> 'C'
  and ((vll.schedarrivdate = t.eff and t.category = '418')
      or (vll.schedshipdate = t.eff and t.category = '417'))
  and to_number(o.orderid) = vll.orderid 
  and vll.source = c.source
  and vll.schedshipdate >= v_ohpost
       
  union -- Pull in CPU Which do not have a matching Vehicle Load (delivery)
  
  select t.item, t.dest, t.source, t.eff shipdate, t.eff+(c.minleadtime/1440) arrivdate, t.sourcing, 'TRUCK' transmode, 
  t.dur, o.qty qty, c.minleadtime,  0 mininflow, o.orderid, o.u_sales_document, o.u_ship_condition,
  o.u_defplant u_sap_defplant, 0 u_sent
  from TMP_SOURCINGMETRIC_NA t, metriccategory m, sourcing c , custorder o, vehicleloadline vll    
  where t.category = m.category 
  and t.category in (418)
--  and substr(t.sourcing, 1, 7) in ('ISS9DEL')
  and t.item = c.item
  and t.dest = c.dest
  and t.source = c.source
  and t.sourcing = c.sourcing 
  and t.value > 0  
  and o.u_sales_document in ('Z1AA')
  and o. u_ship_condition = 'Z1'
  and o.item = t.item 
  and o.loc = t.dest 
  and o.shipdate = t.eff
  and o.shipdate >= v_ohpost
--  and o.u_defplant = c.source
  and to_number(o.orderid) = vll.orderid (+)
  and vll.orderid is null

  union -- Same as Block 1 except for collections */
    
  select t.item, t.dest, t.source, vll.schedshipdate shipdate, vll.schedarrivdate arrivdate, t.sourcing, 'TRUCK' transmode, 
  t.dur, o.qty qty, c.minleadtime,  0 mininflow, o.orderid, o.u_sales_document, o.u_ship_condition,
  o.u_defplant u_sap_defplant, 1 u_sent
  from TMP_SOURCINGMETRIC_NA t, metriccategory m, sourcing c , custorder o, vehicleloadline vll     
  where t.category = m.category 
  --and t.category in (417)
  and substr(t.sourcing, 1, 7) = 'COL9DEL' 
  and t.item = c.item
  and t.dest = c.dest
  and t.source = c.source
  and t.sourcing = c.sourcing 
  and t.value > 0  
  and o.u_sales_document in ('Z1BA')
  and o.item = t.item 
  and o.loc = t.source --and ((o.loc = '0100393353' and o.shipdate = '17-JUL-15' and o.item = '3RUSTANDRD') 
  and o.shipdate = t.eff
  and ((vll.schedarrivdate = t.eff and t.category = '418')
      or (vll.schedshipdate = t.eff and t.category = '417'))
  and to_number(o.orderid) = vll.orderid
  and vll.dest = c.dest
  and vll.schedshipdate >= v_ohpost
  
  union -- (CPU returns without matching vehicle loads )
  
  select t.item, t.dest, t.source, t.eff shipdate, t.eff+(c.minleadtime/1440) arrivdate, t.sourcing, 'TRUCK' transmode, 
  t.dur, o.qty qty, c.minleadtime,  0 mininflow, o.orderid, o.u_sales_document, o.u_ship_condition,
  o.u_defplant u_sap_defplant, 0 u_sent
  from TMP_SOURCINGMETRIC_NA t, metriccategory m, sourcing c , custorder o, vehicleloadline vll     
  where t.category = m.category 
  and t.category in (417)
  and substr(t.sourcing, 1, 7) = 'COL9DEL' 
  and o. u_ship_condition = 'Z1'
  and t.item = c.item
  and t.dest = c.dest
  and t.source = c.source
  and t.sourcing = c.sourcing 
  and t.value > 0  
  and o.u_sales_document in ('Z1BA')
  and o.item = t.item 
  and o.loc = t.source 
--  and o.u_defplant  = c.dest
  and o.shipdate = t.eff
  and o.shipdate >= v_ohpost
  and to_number(o.orderid) = vll.orderid (+)
  and vll.orderid is null
  
  union  -- intransit deliveries
  
  select vll.item, vll.dest, vll.source, vll.schedshipdate shipdate, vll.schedarrivdate arrivdate, 'INTRANSIT' sourcing, 'TRUCK' transmode, 
  0 dur, vll.qty ,  0 minleadtime,  0 mininflow, o.orderid, o.u_sales_document, o.u_ship_condition,
  o.u_defplant u_sap_defplant, 1 u_sent

  from vehicleloadline vll, custorder o, loc l, vehicleload vl
  where to_number(o.orderid) = vll.orderid 
  and vl.loadid=vll.loadid
  and vll.u_overallsts='C'
  and vll.schedarrivdate >= v_ohpost
  and o.u_sales_document not in ('Z1BACA')
  and o.loc = l.loc
  and l.u_area = 'NA'
  
  union  -- non-optimized materials with delivery (US IGNORE THESE? )
  
  select vll.item, vll.dest, vll.source, vll.schedshipdate shipdate, vll.schedarrivdate arrivdate, 'NONOPT' sourcing, 'TRUCK' transmode, 
  0 dur, vll.qty ,  0 minleadtime,  0 mininflow, o.orderid, o.u_sales_document, o.u_ship_condition,
  o.u_defplant u_sap_defplant, 1 u_sent

  from vehicleloadline vll, custorder o, item i, loc l
  where to_number(o.orderid) = vll.orderid (+)
  and o.u_sales_document not in ('Z1BACA')
  and o.item = i.item
  and i.u_stock = 'N'
  and vll.orderid is not null
  and vll.schedshipdate >= v_ohpost 
  and o.loc = l.loc
  and l.u_area = 'NA'
     
  union  -- non-optimized materials without delivery
  
  select o.item, case when o.u_sales_document = 'Z1BA' then o.u_defplant else o.loc end dest, 
  case when o.u_sales_document = 'Z1BA' then o.loc else o.u_defplant end source,
  o.shipdate shipdate, o.shipdate arrivdate, 'NONOPT' sourcing, 'TRUCK' transmode, 
  0 dur, o.qty ,  0 minleadtime,  0 mininflow, o.orderid, o.u_sales_document, o.u_ship_condition,
  o.u_defplant u_sap_defplant, 1 u_sent
  
  from vehicleloadline vll, custorder o, item i, loc l
  where to_number(o.orderid) = vll.orderid (+)
  and o.u_sales_document not in ('Z1BACA')
  and o.item = i.item
  and i.u_stock = 'N'
  and vll.orderid is  null
  and o.shipdate >= v_ohpost
  and o.loc = l.loc
  and l.u_area = 'NA'
  );

commit;
-- Insert custorder into planarriv

scpomgr.U_60_pst_replenishment_co;

-- if sourcingmetric value greater than sum of planarriv value then add a new record in planarriv with the difference

insert into planarriv (item, dest, source, sourcing,   transmode, firmplansw, needarrivdate,  schedarrivdate,     needshipdate,     
    schedshipdate,     qty,  expdate, shrinkagefactor,   transname,   action,  actiondate, actionallowedsw, actionqty, reviseddate,        
    availtoshipdate, substqty,  ff_trigger_control, headerseqnum,  covdurscheddate,   departuredate,     deliverydate, orderplacedate,  supporderqty,     
    revisedexpdate,     nonignorableqty, seqnum, u_sales_document, u_ship_condition, u_sap_defplant,  u_sent)

select item, dest, source, sourcing, 'TRUCK'  transmode, 0 firmplansw,     schedshipdate needarrivdate,     schedshipdate  schedarrivdate,     schedshipdate needshipdate,     
    schedshipdate schedshipdate,     value-qty qty,     scpomgr.u_jan1970 expdate,      0 shrinkagefactor,     ' ' transname,     
    0 action,     scpomgr.u_jan1970 actiondate,     0 actionallowedsw,     0 actionqty,     scpomgr.u_jan1970 reviseddate,        
    schedshipdate availtoshipdate,     0 substqty,      '' ff_trigger_control,     0 headerseqnum,     scpomgr.u_jan1970 covdurscheddate,     
    schedshipdate departuredate,     schedshipdate  deliverydate,     scpomgr.u_jan1970 orderplacedate,     0 supporderqty,     
    scpomgr.u_jan1970 revisedexpdate,     0 nonignorableqty,  
    row_number()
              over (partition by item, dest order by item, dest )+ lastseqnum as seqnum,
    ' ' u_sales_document, ' ' u_ship_condition, ' ' u_sap_defplant, 0 u_sent
 
from 
  (select t.item, t.dest, t.source, t.sourcing, t.eff schedarrivdate, t.eff schedshipdate, 
  case when s.lastseqnum is null then 0 else s.lastseqnum end lastseqnum,
  case when p.qty is null then 0 else p.qty end qty, t.value
  from 
    (select item, dest, max(seqnum) lastseqnum
      from planarriv
      group by item, dest
    ) s,
  
    (select u_sales_document, item, dest, source, schedshipdate , schedarrivdate, sum(qty) qty, sourcing
    from planarriv 
    --where u_sales_document in ('Z1AA','Z1CA')
    group by u_sales_document, item, dest, source, schedshipdate, schedarrivdate, sourcing
    ) p, 

    (select t.item, t.dest, t.source, t.eff , sum(t.value) value , sourcing
    from sim_sourcingmetric t , loc l
    where t.category = 417 
    and t.value <> 0
    and substr(sourcing, 5, 3) <> 'DEL'
    and t.dest = l.loc
    and l.u_area = 'NA'
    and t.simulation_name = 'AD'
    group by t.item, t.dest, t.source, t.eff, sourcing
    ) t

where t.item = p.item (+) 
and t.dest = p.dest (+)
and t.source = p.source (+)
and t.eff = p.schedarrivdate (+)
and t.sourcing = p.sourcing (+)
and t.item = s.item (+)
and t.dest = s.dest (+)
and (p.qty is null or p.qty < t.value));
         
commit;

--- unmet customer orders (dont have a sourcingmetric record)

insert into planarriv (item, dest, source, sourcing,   transmode, firmplansw, needarrivdate,  schedarrivdate,     needshipdate,     
    schedshipdate,     qty,  expdate, shrinkagefactor,   transname,   action,  actiondate, actionallowedsw, actionqty, reviseddate,        
    availtoshipdate, substqty,  ff_trigger_control, headerseqnum,  covdurscheddate,   departuredate,     deliverydate, orderplacedate,  supporderqty,     
    revisedexpdate,     nonignorableqty, seqnum, u_sales_document, u_ship_condition, u_custorderid, u_sap_defplant,  u_sent)

select item, dest, source, sourcing,   transmode, 0 firmplansw,     shipdate needarrivdate,     shipdate schedarrivdate,     shipdate needshipdate,     
    shipdate schedshipdate,     qty,     scpomgr.u_jan1970 expdate,      0 shrinkagefactor,     ' ' transname,     
    0 action,     scpomgr.u_jan1970 actiondate,     0 actionallowedsw,     0 actionqty,     scpomgr.u_jan1970 reviseddate,        
    shipdate availtoshipdate,     0 substqty,      '' ff_trigger_control,     0 headerseqnum,     scpomgr.u_jan1970 covdurscheddate,     
    shipdate departuredate,     shipdate deliverydate,     scpomgr.u_jan1970 orderplacedate,     0 supporderqty,     
    scpomgr.u_jan1970 revisedexpdate,     0 nonignorableqty,         
    row_number()  over (partition by item, dest order by item, dest )+lastseqnum as seqnum,  
    u_sales_document, u_ship_condition, orderid u_custorderid, ' ' u_sap_defplant, 0 u_sent
from 

  
  (SELECT O.ITEM, O.QTY, O.ORDERID, O.SHIPDATE,  'UNMET' SOURCING, 'TRUCK' TRANSMODE, 
  case when  o.u_sales_document = 'Z1BA' then 'US9X' else o.loc end dest,
  case when  o.u_sales_document = 'Z1BA' then o.loc else 'US9X' end source,
  case when  o.u_sales_document = 'Z1BA' then 0 else case when ps.item is null then 0 else ps.seqnum end end lastseqnum, 
  o.u_sales_document, o.u_ship_condition
  from custorder o, item i, loc l,
    
    (select distinct u_custorderid orderid
    from planarriv 
    
    union
    
    select distinct u_z1banum orderid
    from planarriv
    where u_z1banum is not null
    and u_z1banum <> 0
    ) p,
  
    (select item, dest, max(seqnum) seqnum 
    from planarriv
    group by item, dest 
    )ps
  
  where o.u_sales_document in ('Z1AA','Z1CA','Z1BA') 
  and o.item = i.item
  and i.u_stock in ('A','C') 
  and o.shipdate >= v_ohpost
  and o.loc = l.loc
  and l.u_area = 'NA'  
  and o.orderid = p.orderid (+)
  and o.item = ps.item (+)
  and o.loc = ps.dest (+)
  and p.orderid is null);

commit;

--  Fill in planarriv udc's

declare
  cursor cur_selected is
      
    select p.loc, p.item, p.dmdgroup, d.u_defplant, p.qty * i.u_freight_factor u_teu, p.u_custorderid,
    case when g.loc is null then 0 else 1 end u_gidlimit
    from dfuview d, item i, scpomgr.udt_gidlimits g, loc l,
        (select case when u_sales_document = 'Z1BA' then case when u_ship_condition = 'Z1' then 'RET' else 'COL' end
                when u_sales_document = 'Z1AA' then case when u_ship_condition = 'Z1' then 'CPU' else 'ISS' end
                when u_sales_document = 'Z1CA' then case when u_ship_condition = 'Z1' then 'EMES' else 'EMER' end
                end  dmdgroup, item, qty, u_custorderid,
        case when u_sales_document = 'Z1BA' then source else dest end loc
        from planarriv
        ) p

    where p.item = i.item
    and p.loc = l.loc
    and l.u_area = 'NA'
    and p.loc = g.loc (+)
    and p.item = d.dmdunit (+)
    and p.loc = d.loc (+)
    and p.dmdgroup = d.dmdgroup (+)
  
  for update of p.item;
  
begin
  for cur_record in cur_selected loop
  
    update planarriv
    set u_dp_defplant = cur_record.u_defplant, u_gidlimit = cur_record.u_gidlimit, u_teu = cur_record.u_teu,
        u_ordernum = substr(cur_record.u_custorderid,1 ,10) , u_orderitem = substr(cur_record.u_custorderid, 11 ,6)
    where current of cur_selected;
    
  end loop;
  commit;
end;
-- Commented out to here */
commit;

end;
