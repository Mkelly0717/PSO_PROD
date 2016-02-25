--------------------------------------------------------
--  DDL for Procedure U_61_PST_REPLENISHMENTS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_61_PST_REPLENISHMENTS" AS 
v_ohpost date;
BEGIN

select max(s.ohpost) into v_ohpost 
from sku s, loc l
where s.loc = l.loc
and l.u_area = 'NA';

delete SS where loc in (select loc from loc where u_area='NA'); 
commit;

insert into ss (loc, item, eff, qty) 

select u.loc, u.matcode||u.stock, scpomgr.u_jan1970 , u.calculated_stock  
from SCPOMGR.udt_stock_target_na u, sku s , loc l
where u.loc = s.loc
and u.matcode||u.stock = s.item
and s.loc = l.loc 
and l.u_area = 'NA';

commit;

-- Undo item change of collections at MER locations
-- do we neeed this at the beginning of e_60_pst_repelnishments?

--update custorder set  item =  substr(item,1,1)||'AI'   
--where orderid in (
--select o.orderid from custorder o , vehicleloadline v, loc l
--where o.orderid = v.orderid --and o.orderid = '3128922652000030'
--and o.item <> v.item 
--and o.loc = l.loc
--and l.u_area = 'NA');
--
--commit;

-- Populate planorder with item production

delete planorder where loc in (select loc from loc where u_area='NA'); 

insert into planorder (item, loc, scheddate,   qty,  needdate,  firmplansw, recschedrcptsopt,   productionmethod,  startdate,  expdate,  headerseqnum,  action,   actiondate,  actionallowedsw,  actionqty,   reviseddate,     
    substqty,  ff_trigger_control, covdurscheddate, editsw, revisedexpdate,  primaryseqnum,  coprodprimaryitem, coprodordertype, seqnum)

select item, loc, eff scheddate,     qty,     eff needdate,     1 firmplansw,     1 recschedrcptsopt,   productionmethod,     eff startdate,     scpomgr.u_jan1970 expdate,      
    0 headerseqnum,     0 action,     scpomgr.u_jan1970 actiondate,     0 actionallowedsw,     0 actionqty,     scpomgr.u_jan1970 reviseddate,     
    0 substqty,      '' ff_trigger_control,     eff covdurscheddate,     0 editsw,     scpomgr.u_jan1970 revisedexpdate,     0 primaryseqnum,     ' ' coprodprimaryitem,     0 coprodordertype, 
    row_number()
              over (partition by item, loc order by item, loc ) as seqnum     
from
    (select c.eff, y.outputitem item, c.loc, c.productionmethod, c.category, m.descr, c.value*y.yieldqty qty 
    FROM sim_productionmetric c, metriccategory m, loc l, productionyield y
    where c.category = m.category
    and c.loc = l.loc 
    and l.u_area = 'NA'
    and c.category = 417
    and c.value > 0
    and c.item = y.item
    and c.loc = y.loc
    and c.productionmethod = y.productionmethod
	abd c.simulation_name='AD'
    );
    
commit;

-- populate depdmdstatic with item consumption

delete depdmdstatic where loc in (select loc from loc where u_area='NA'); 

insert into igpmgr.intups_depdmdstatic (ITEM, LOC, DUR, QTY, FIRMSW, BOMNUM, PARENTEXPDATE, CALCPRIORITY, SCHEDDATE, SCHEDSTATUS, SCHEDQTY, 
PARENTSCHEDDATE, PARENTSEQNUM, SUPERSEDESW, STARTDATE, PARENT, PARENTORDERTYPE, SEQNUM, PARENTSTARTDATE, EXPDATE, 
EARLIESTNEEDDATE, PARENTORDERNUM)

select b.subord ITEM, c.loc LOC, DUR, c.value QTY, 0 FIRMSW, b.bomnum BOMNUM, scpomgr.u_jan1970 PARENTEXPDATE, 0 CALCPRIORITY, 
scpomgr.u_jan1970 SCHEDDATE, 0 SCHEDSTATUS, 0 SCHEDQTY, scpomgr.u_jan1970 PARENTSCHEDDATE, 0 PARENTSEQNUM, 0 SUPERSEDESW, 
c.eff STARTDATE, b.item PARENT, 2 PARENTORDERTYPE, 0 SEQNUM, scpomgr.u_jan1970 PARENTSTARTDATE, scpomgr.u_jan1970 EXPDATE, 
scpomgr.u_jan1970 EARLIESTNEEDDATE, 0 PARENTORDERNUM
FROM sim_productionmetric c, metriccategory m, loc l, bom b, productionmethod p
where c.category = m.category
and c.loc = l.loc  --and c.loc = 'GB1F' and c.eff = '12-JAN-16' and c.productionmethod = 'INS'
and l.u_area = 'NA'
and c.category = 417
and c.value > 0
and c.item = p.item
and c.loc = p.loc
and c.productionmethod = p.productionmethod
and p.item = b.item
and p.loc = b.loc
and p.bomnum = b.bomnum
and c.simulation_name='AD';

commit;

-- set planarriv qty to zero and store delivery quantity at subsqty
-- this might be better done in e_60 at planarriv row creation for deliveries

update planarriv set qty = substqty  -- reinitiate, temporary
where qty = 0 and substqty <> 0 and dest in (select loc from loc where u_area='NA');
commit;

--
--
update planarriv set substqty = qty, qty = 0 
where u_loadid is not null and u_loadid <> 0 and qty<>0 and dest in (select loc from loc where u_area='NA');
commit;

-- update deststatus & sourcestatus.  Should we do this in e_14_custorders? in the interface?

update vehicleload set deststatus = 3 
where loadid in 
  (select loadid from vehicleloadline v, loc l where v.dest = l.loc and l.u_area = 'NA' and v.schedarrivdate < v_ohpost);

commit;
--
update vehicleload set sourcestatus = 3
where loadid in 
  (select loadid from vehicleloadline v, loc l where v.dest = l.loc and l.u_area = 'NA' and v.schedshipdate < v_ohpost);

commit;

END;
