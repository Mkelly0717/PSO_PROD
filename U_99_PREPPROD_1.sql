--------------------------------------------------------
--  DDL for Procedure U_99_PREPPROD
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_99_PREPPROD" as

begin

--SCPOMGR.udt_default_zip@SCPOMGR_CHPTSTDB.JDADELIVERS.COM

--update vll schedshipdate and schedarrivdate to correspond to vl

declare
  cursor cur_selected is
  
        select vll.item, vll.dest, vll.source, vll.loadid,   
            vl.shipdate, vl.arrivdate, vll.schedshipdate, vll.schedarrivdate, vll.qty 
        from vehicleload vl, vehicleloadline vll, loc l
        where vll.loadid = vl.loadid
        and vll.dest = l.loc
        and l.u_area = 'NA'
         
    for update of vll.schedshipdate;
begin
  for cur_record in cur_selected loop
  
    update vehicleloadline 
    set schedshipdate  = cur_record.shipdate
    where current of cur_selected;
    
    update vehicleloadline 
    set schedarrivdate  = cur_record.arrivdate
    where current of cur_selected;

  end loop;
  commit;
end;

execute immediate 'truncate table tmp_sku';

--if you already loaded data comment - out above truncate statements (and one below for customer orders)

--convert .txt file into .csv using excel
--import into tmp_sku using plsql devloper

update sku set oh = 0 
    where loc in (select loc from loc where u_area = 'NA');
    
commit;

declare
  cursor cur_selected is
  
    select t.item, t.loc, d.u_jda_identifier
    from tmp_sku t, udt_translate_dmdunit d
    where t.item = d.u_sap_identifier
         
    for update of t.item;
begin
  for cur_record in cur_selected loop
  
    update tmp_sku
    set item  = cur_record.u_jda_identifier
    where current of cur_selected;

  end loop;
  commit;
end;

declare
  cursor cur_selected is
  
    select s.item, s.loc, t.oh
    from sku s, tmp_sku t, loc l
    where s.item = t.item
    and s.loc = t.loc
    and s.loc = l.loc
    and l.u_area = 'NA'
         
    for update of s.oh;
begin
  for cur_record in cur_selected loop
  
    update sku
    set oh  = cur_record.oh
    where current of cur_selected;

  end loop;
  commit;
end;

execute immediate 'truncate table tmp_custorder';

--convert .txt file into .csv using excel
--import into tmp_custorder using plsql devloper

declare
  cursor cur_selected is
  
        select c.item, u.u_jda_identifier, c.loc,  orderid, orderseqnum, y.idx+row_number()
                                over (partition by 1 order by item, loc, orderid asc) as orderseqnum_new
        from tmp_custorder c, udt_translate_dmdunit u,
            (select max(orderseqnum) idx from custorder) y
        where c.item = u.u_sap_identifier
 
    for update of c.orderseqnum;
begin
  for cur_record in cur_selected loop
  
    update tmp_custorder
    set orderseqnum  = cur_record.orderseqnum_new
    where current of cur_selected;
    
    update tmp_custorder
    set item  = cur_record.u_jda_identifier
    where current of cur_selected;
    
    update tmp_custorder
    set status  = 1
    where current of cur_selected;
    
  end loop;
  commit;
end;

delete custorder where loc in 
    (select loc from loc where u_area = 'NA');
    
commit;

--delete orders that violate primary key; more than one record for item, loc, shipdate, orderid

delete tmp_custorder where orderid in 

    (select distinct orderid from 

        (select c.fcstsw, c.item, c.loc, c.orderid, c.orderseqnum, c.qty, c.shipdate, c.status, c.u_defplant, c.u_z1banum, c.u_sales_document, c.u_ship_condition, c.u_dmdgroup_code
        from tmp_custorder c, sku s, custorder cc
        where c.loc in (select loc from loc where u_area = 'NA')
        and c.loc = s.loc
        and c.item = s.item
        and c.item = cc.item(+)
        and c.loc = cc.loc(+)
        and c.shipdate = cc.shipdate(+) 
        and c.orderseqnum = cc.orderseqnum(+)
        and cc.item is null
        )

    group by item, loc, shipdate, orderid
    having count(*) > 1
    );

commit;

insert into custorder (fcstsw, item, loc, orderid, orderseqnum, qty, shipdate, status, u_defplant, u_z1banum, u_sales_document, u_ship_condition, u_dmdgroup_code) 

select c.fcstsw, c.item, c.loc, c.orderid, c.orderseqnum, c.qty, c.shipdate, c.status, c.u_defplant, c.u_z1banum, c.u_sales_document, c.u_ship_condition, c.u_dmdgroup_code
from tmp_custorder c, sku s, custorder cc
where c.loc in (select loc from loc where u_area = 'NA')
and c.loc = s.loc
and c.item = s.item
and c.item = cc.item(+)
and c.loc = cc.loc(+)
and c.shipdate = cc.shipdate(+) 
and c.orderseqnum = cc.orderseqnum(+)
and cc.item is null;

commit;

update loc set loc_type = 1
--select loc, loc_type from loc
where loc in

    (select loc
    from udt_yield_na
    where productionmethod = 'BUY'
    );

commit;

update loc set u_runew_cust = 1
--select loc, u_runew_cust from loc 
where loc in

    ('4000114391', 
    '4000114386', 
    '4000120457', 
    '4000134538', 
    '4000297209', 
    '4000130635', 
    '4000193128', 
    '4000210936', 
    '4000263999', 
    '4000280054', 
    '4000144882', 
    '4000114384', 
    '4000217009', 
    '4000156881', 
    '4000173647', 
    '4000142938', 
    '4000167740', 
    '6100747589', 
    '4000099903', 
    '6100102784', 
    '6100102757', 
    '4000164069', 
    '6100789980', 
    '4000131782', 
    '6100102613', 
    '4000247220', 
    '4000054822', 
    '4000086438', 
    '4000223529', 
    '4000275106', 
    '6100126054', 
    '6100146577', 
    '6100373713', 
    '4000196427', 
    '6100273769', 
    '6100723471', 
    '6101072671', 
    '4000182481', 
    '6101006271', 
    '4000063112', 
    '3000147629', 
    '4000112833', 
    '4000275014', 
    '4000183524', 
    '4000262862', 
    '6100248752', 
    '6101004709', 
    '6100151294', 
    '4000146525', 
    '6100102551', 
    '4000122487', 
    '6100632541', 
    '6101044569', 
    '6101044578', 
    '4000090078', 
    '6101015270', 
    '4000059106', 
    '6100115066', 
    '6100635646'
    );

commit;

delete SKU
where loc in 
    (select loc from loc where u_area = 'NA'
    )
    
and item in 

    (select item
    from item
    where u_materialcode not in ('4001', '4055')
    );

commit;

delete skuprojstatic
    where loc in (select loc from loc where u_area = 'NA');
    
commit;

end;
