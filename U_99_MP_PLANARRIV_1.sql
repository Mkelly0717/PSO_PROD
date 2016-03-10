--------------------------------------------------------
--  DDL for Procedure U_99_MP_PLANARRIV
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_99_MP_PLANARRIV" as

begin



execute immediate 'truncate table udt_mp_planarriv';

insert into udt_mp_planarriv

select *
from SCPOMGR.udt_mp_planarriv@SCPOMGR_CHPTSTDB.JDADELIVERS.COM;

commit;


execute immediate 'truncate table tmp_planarriv';

insert into tmp_planarriv 

select * 
from planarriv 
where dest in (select loc from loc where u_area = 'NA');

commit;

declare
  cursor cur_selected is
  
    select m.item, m.dest, m.source source_mp, m.source_pso, p.source source_pa, m.orderid, m.shipdate, m.schedshipdate, m.sourcing, m.qty, m.chk_ship, m.chk_source, m.chk_qty,
        case when m.chk_ship = 1 then m.shipdate else m.schedshipdate end schedshipdate_new,
        case when m.chk_source = 1 then m.source else m.source_pso end source_new,
        case when m.chk_qty = 1 then 540 else m.qty end qty_new
    from udv_mp_planarriv m, tmp_planarriv p, loc l
    where m.dest = l.loc
    and l.u_area = 'NA'
    and m.item = p.item
    and m.dest = p.dest
    and m.orderid = p.u_custorderid
    and m.chk_ship+m.chk_source+m.chk_qty > 0
    
for update of p.schedshipdate;

begin
  for cur_record in cur_selected loop
  
    update tmp_planarriv
    set schedshipdate = cur_record.schedshipdate_new
    where current of cur_selected;
    
    update tmp_planarriv
    set source = cur_record.source_new
    where current of cur_selected;
    
    update tmp_planarriv
    set qty = cur_record.qty_new
    where current of cur_selected;
    
  end loop;
  commit;
end;

end;
