--------------------------------------------------------
--  DDL for Procedure U_91_PRESTORESKU
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_91_PRESTORESKU" AS 
BEGIN


/* Reset the IGP Error tables and the INTJOB table counts */
scpomgr.u_8d_igptables;

/* Update the Loc type based in Demand 
   AND Change loc.u_max_dist to 800 for US locations 
*/
scpomgr.U_09_LOCTYPES; --updates LOC:LOC_TYPE, JB 12/16/2015

/* Update the vehicle load sourcestatus to be determined by the 
   UDC U_overallsts on vehicleloadline table.
*/
UPDATE vehicleload vl
set vl.sourcestatus= nvl((SELECT
    CASE vll.u_overallsts
      when 'A' then 1
      WHEN 'C' then 3
      ELSE null
    END sourcestatus
  FROM vehicleloadline vll
  where vl.loadid=vll.loadid
  ),vl.sourcestatus)
  where vl.LOADID IN (select vll.loadid 
                   from SCPOMGR.vehicleloadline vll 
                   where vll.dest in (select l.loc from SCPOMGR.loc l where l.u_area = 'NA')); 

/* Update the Vehicleloadline.schedshipdate to the leadtime from udt_cost_transit_na */
merge into vehicleloadline vll0
using
( select vll.loadid , round(ct.transittime) transittime
   from vehicleloadline vll, loc ld, loc ls, udt_cost_transit_na ct
  where vll.item like '4%RU%'
  and ld.loc            = vll.dest
  and ld.u_area='NA'
  and ls.loc              = vll.source
  and ct.u_equipment_type = decode( ld.u_equipment_type, 'FB', 'FB', 'VN' )
  and ct.source_pc        = ls.postalcode
  and ct.dest_pc          = ld.postalcode
union
select vll.loadid, case when substr(ld.postalcode,1,3) = substr(ls.postalcode,1,3) then 0 else 1 end transittime
   from vehicleloadline vll, loc ld, loc ls
  where vll.item like '4%RU%'
  and   ld.loc            = vll.dest
  and ld.u_area='NA'
  and ls.loc              = vll.source
  and not exists 
     ( select 1 from udt_cost_transit_na ct
        where  ct.u_equipment_type = decode( ld.u_equipment_type, 'FB', 'FB', 'VN' )
          and ct.source_pc        = ls.postalcode
          and ct.dest_pc          = ld.postalcode
      )
) ta on (ta.loadid = vll0.loadid)
when matched then update 
    set vll0.schedshipdate = vll0.schedarrivdate - ta.transittime;
scpomgr.U_10_SKU_BASE;  -- create sku & dfutoskufcst
update sku set infcarryfwdsw = 0 ;
commit;
scpomgr.U_11_SKU_STORAGE;  -- create storage resources and cost

delete skuprojstatic
    where loc in (select loc from loc where u_area = 'NA');
    
commit;

/* Update the The Order qty to match the vehicleload qty */
--merge into custorder co
--using
--( SELECT vll.orderid, vll.qty
--  from vehicleloadline vll, loc l
--  where l.loc=vll.dest
--    and l.u_area='NA' 
--) vllq on (vllq.orderid = co.orderid)
--when matched then update 
--    set co.qty = vllq.qty;
--commit;    

/* Run this code to set the order qty to agree with the vehicle load qty.*/
UPDATE custorder co1
SET co1.qty=
  (SELECT max( vll.qty)
  from custorder co,
    vehicleloadline vll,
    loc l
  WHERE co1.orderid =co.orderid
  and vll.orderid =co.orderid
  and vll.qty    <> co.qty
  and l.loc=co.loc
  and l.u_area='NA'
  )
WHERE EXISTS
(SELECT 1
  from custorder co,
    vehicleloadline vll,
    loc l
  WHERE co1.orderid =co.orderid
  and vll.orderid =co.orderid
  and vll.qty    <> co.qty
--  and vll.u_overallsts='C'
  and l.loc=co.loc
  and l.u_area='NA'
);

commit;

/* Remove from vehicleloadline sourcestatus 3 records where the 
   custorder shipdate is before the onhandpost date 
   and the schedarrivdate is on or after the onhandpost
   date.
*/
--delete from vehicleload vl
--where vl.loadid in 
--(select vll.loadid
--from vehicleloadline vll, loc l, custorder co
--where l.loc=vll.dest
--  and l.u_area='NA'
--  and vll.item like '4055RU%'
--  and co.orderid=vll.orderid 
--  and vll.u_overallsts='C'
--  and vll.schedarrivdate > co.shipdate
--);
--delete from vehicleload vll
--where vll.loadid in 
--(select vll.loadid
--from vehicleloadline vll, loc l, custorder co
--where l.loc=vll.dest
--  and l.u_area='NA'
--  and vll.item like '4055RU%'
--  and co.orderid=vll.orderid 
--  and vll.u_overallsts='C'
--  and vll.schedarrivdate > co.shipdate
--);
--commit;

/*
01/25/2016 - JB - added below logic to set custorder order duration to 4 days and maxcustordersysdur to 10 days for SUN - WED.  In order to span weekends they are set to 6 and 8 days respectivley THU - SAT  
*/

declare
  cursor cur_selected is
  
        select p.item, p.loc, s.ohpost, to_char(s.ohpost, 'd') dow, p.fcstadjrule, p.custorderdur, p.maxcustordersysdur,
            case when to_char(s.ohpost, 'd') in (1, 2, 3) then 1440*4 else 1440*6 end custorderdur_new, 
            case when to_char(s.ohpost, 'd') in (1, 2, 3) then 1440*10 else 1440*8 end maxcustordersysdur_new
        from skudemandparam p, loc l, sku s
        where p.loc = l.loc
        and l.u_area = 'NA'
        and l.loc_type = 3
        and p.item = s.item
        and p.loc = s.loc
         
    for update of p.custorderdur;
begin
  for cur_record in cur_selected loop
  
    update skudemandparam 
    set custorderdur  = cur_record.custorderdur_new
    where current of cur_selected;
    
    update skudemandparam 
    set maxcustordersysdur  = cur_record.maxcustordersysdur_new
    where current of cur_selected;

  end loop;
  commit;
end;

--  ================  RUN STORE SKU PROJECTIONS

END;
