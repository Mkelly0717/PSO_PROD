--------------------------------------------------------
--  DDL for Procedure MAK_ASSIGN_PLANARRIVALS2
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."MAK_ASSIGN_PLANARRIVALS2" 
is

begin

delete from planarriv p
where exists (select * from loc l where  l.loc = p.dest and  l.u_area = 'NA');

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
    row_number() over (partition by item, dest order by item, dest ) as seqnum
    , u_sales_document, u_ship_condition, orderid orderid,  u_sap_defplant , u_sent
from 
( /* All Orders and Delivers  from mak_cust_table*/
 select mct.co_item item, mct.loc dest, nvl(mct.assigned_plant,'US9X') source, nvl(mct.schedshipdate,mct.shipdate) shipdate
      , mct.shipdate arrivdate, mct.sourcing, 'TRUCK' transmode, mct.dur, 
      case when mct.sourcing = 'UNMET' then 0 else mct.co_qty end qty, mct.minleadtime
      , 0 mininflow
      , mct.co_orderid orderid,  mct.u_sales_document, mct.u_ship_condition, 'US9X' u_sap_defplant, 1 u_sent
  from mak_cust_table mct
  where mct.sourcing not like 'COL%'
  union
 select mct.co_item item, nvl(mct.assigned_plant,'US9X') dest, mct.loc source, nvl(mct.schedshipdate,mct.shipdate) shipdate
      , mct.shipdate arrivdate, mct.sourcing, 'TRUCK' transmode, mct.dur, 
      case when mct.sourcing = 'UNMET' then 0 else mct.co_qty end qty, mct.minleadtime
      , 0 mininflow
      , mct.co_orderid orderid,  mct.u_sales_document, mct.u_ship_condition, 'US9X' u_sap_defplant, 1 u_sent
  from mak_cust_table mct
  where mct.sourcing like 'COL%'
  union
 
  /* Add Intransits which were left out of mak_cust_table */
  select vll.item item, vll.dest dest, vll.source source, vll.schedshipdate shipdate
       , vll.schedarrivdate arrivdate, 'INSTRANSIT' sourcing, 'TRUCK' transmode, 0 dur, vll.qty qty, 0 minleadtime
       , 0 mininflow
       , to_char(vll.orderid) orderid,  co.u_sales_document, co.u_ship_condition, 'US9X' u_sap_defplant, 0 u_sent
   from vehicleloadline vll, custorder co, loc l
  where vll.u_overallsts='C'
    and vll.orderid=co.orderid
    and l.loc=co.loc
    and l.u_area='NA'
);
commit;

end;
