--------------------------------------------------------
--  DDL for Procedure U_91_PRESTORESKU
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_91_PRESTORESKU" AS 
BEGIN


/******************************************************************
** Part 1: Reset the IGP Error tables and the INTJOB table counts *
*******************************************************************/
scpomgr.u_8d_igptables;

/******************************************************************
** Part 2: Update the Loc type based in Demand AND Change         * 
**         loc.u_max_dist to 800 for US locations                 *
**         --updates LOC:LOC_TYPE, JB 12/16/2015                  *
*******************************************************************/
scpomgr.U_09_LOCTYPES;


/******************************************************************
** Part 3: Update the Vehicle Load and Custorder table records    *
*******************************************************************/
scpomgr.U_09_vehicleloads;

   
/******************************************************************
** Part 4: Run U_10_SKU_BASE to Create the New Sku 
**         and DFUTOSKUFCST RECORDS
*******************************************************************/
scpomgr.U_10_SKU_BASE;


/******************************************************************
** Part 5: Update the infcarryfwdsw to 0
*******************************************************************/
update sku set infcarryfwdsw = 0 ;
commit;


/******************************************************************
** Part 6: Run the U_11_STORAGE to create 
**          the Storage Resources and Costs
*******************************************************************/
scpomgr.U_11_SKU_STORAGE;  -- create storage resources and cost


/******************************************************************
** Part 7: Delete the US skuprojstatic records.
*******************************************************************/
delete skuprojstatic
    where loc in (select loc from loc where u_area = 'NA');
commit;


/******************************************************************
** Part 8: 01/25/2016 - JB - added below logic to set custorder 
**          order duration to 4 days and maxcustordersysdur to 10 
**          days for SUN - WED.  In order to span weekends they 
**          are set to 6 and 8 days respectivley THU - SAT   
*******************************************************************/

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
