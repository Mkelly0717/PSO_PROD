--------------------------------------------------------
--  DDL for Procedure E_60_PST_REPLENISHMENT_CO
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."E_60_PST_REPLENISHMENT_CO" AS 
v_qty number;
BEGIN

-- ISSUES

EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_SOURCINGMETRIC';

-- Insert into tmp_sourcinmetric Z1AA and Z1CA orders

insert into tmp_sourcingmetric
     --(select distinct s.*, 0 u_z1banum
     (select distinct s.sourcing, s.item, s.dest, s.source, s.eff, s.value, s.dur, s.category, s.currencyuom, s.qtyuom, 0 u_z1banum
     --from sourcingmetric s, custorder o, vehicleloadline vll, loc l
     from sim_sourcingmetric s, custorder o, vehicleloadline vll, loc l
     where substr(s.sourcing, 1, 7) not in ('ISS9DEL','MER9DEL')
     and s.category = 418
     and s.item= o.item
     and s.dest = o.loc
     and s.eff = o.shipdate    ---  ?? + s.dur/1440
     and o.u_sales_document in ('Z1AA','Z1CA')
     and o.u_ship_condition = 'Z2'
     and to_number(o.orderid) = vll.orderid (+)
     and vll.orderid is null
     --and s.dest  = '0100558491' --and s.item = '3RUPCSTRD' --and s.eff = '15-JUL-15'
     and value > 0
     and o.loc = l.loc
     --and l.u_area = 'EU'
     and s.simulation_name = 'ED'
     );
     
commit;
/*
insert into tmp_sourcingmetric
     (select s.sourcing, s.item, s.dest, s.source, s.eff, 
     case when col.qty> s.value then s.value else col.qty end value, s.dur, s.category, s.currencyuom, s.qtyuom, col.orderid u_z1banum
     from sourcingmetric s,  custorder o, vehicleloadline vll, custorder col, vehicleloadline vllcol
     where substr(s.sourcing, 1, 7) <> 'MER9DEL'
     and s.category = 417
     and s.item= o.item
     and s.dest = o.loc
     and s.eff = o.shipdate 
     and o.u_sales_document = 'Z1CA'
     and to_number(o.orderid) = vll.orderid (+)
     and vll.orderid is null
     and s.item= col.item
     and s.source = col.loc
     and s.eff = col.shipdate  
     and col.u_sales_document = 'Z1BA'
     and to_number(col.orderid) = vllcol.orderid (+)
     and vllcol.orderid is null
     and s.value > 0
     );
     
commit;

insert into tmp_sourcingmetric
     (select distinct s.sourcing, s.item, s.dest, s.source, s.eff, 
     case when t.value is null then s.value else s.value-t.value end value, s.dur, s.category, s.currencyuom, s.qtyuom, 0 u_z1banum
     from sourcingmetric s, custorder o, vehicleloadline vll, scpomgr.tmp_sourcingmetric t
     where substr(s.sourcing, 1, 7) <> 'MER9DEL'
     and s.category = 417
     and s.item= o.item
     and s.dest = o.loc
     and s.eff = o.shipdate 
     and o.u_sales_document = 'Z1CA'
     and to_number(o.orderid) = vll.orderid (+)
     and vll.orderid is null
     --and s.dest  = '0100558491' --and s.item = '3RUPCSTRD' --and s.eff = '15-JUL-15'
     and s.value > 0
     and s.sourcing = t.sourcing (+)
     and s.item = t.item(+)
     and s.dest = t.dest (+)
     and s.source = t.source (+)
     and s.eff = t.eff (+)
     );
  
commit;    

delete tmp_sourcingmetric where value = 0;

commit;
*/


-- Assign u_z1banum to tmp_sourcingmetric

declare
  cursor cur_selected is
          
         select distinct o.qty , o.loc source, o.u_defplant dest , o.item, o.shipdate eff, o.u_sales_document, o.u_ship_condition, o.orderid
         from custorder o, vehicleloadline vll, tmp_sourcingmetric t
         where to_number(o.orderid) = vll.orderid (+)
         and vll.orderid is null  
         and o.u_sales_document = ('Z1BA') --and o.loc  = '0100417090' and o.item = '1AI'
         and o.u_ship_condition = 'Z2'
         and o.loc = t.source
         and o.item = t.item
         and o.shipdate = t.eff;
         
begin
  for cur_record in cur_selected loop
      
     v_qty := cur_record.qty;     
     
     declare
      cursor cur_selected_tmp is
      -- ??? dur cannot be harcoded
        select min(value) value, sourcing, item, source, dest, eff, 1440 dur, 418 category, 0 currencyuom,  0 qtyuom, max(u_z1banum) u_z1banum
        from 
          (select min(value) value, sourcing, item, source, dest, eff, 1440 dur, 418 category, 0 currencyuom,  0 qtyuom, u_z1banum
          from tmp_sourcingmetric
          where value >= cur_record.qty
          and item = cur_record.item
          and source = cur_record.source
          and eff = cur_record.eff
          and u_z1banum = 0
          group by sourcing, item, source, dest, eff, u_z1banum
        
          union
        
          select max(value) value, sourcing, item, source, dest, eff, 1440 dur, 418 category, 0 currencyuom,  0 qtyuom, u_z1banum
          from tmp_sourcingmetric
          where item = cur_record.item
          and source = cur_record.source
          and eff = cur_record.eff
          and u_z1banum = 0
          group by sourcing, item, source, dest, eff, u_z1banum
          )
        
        group by sourcing, item, source, dest, eff
        order by value desc;
     
     begin
      for cur_record_tmp in cur_selected_tmp loop
          
          --DBMS_OUTPUT.PUT_LINE(cur_record.orderid);
          --DBMS_OUTPUT.PUT_LINE(cur_record.source);
          --DBMS_OUTPUT.PUT_LINE(cur_record_tmp.value);
          
          update tmp_sourcingmetric set value = value - v_qty
          where sourcing = cur_record_tmp.sourcing
          and item = cur_record_tmp.item 
          and source = cur_record_tmp.source
          and dest = cur_record_tmp.dest
          and eff =cur_record_tmp.eff
          and u_z1banum = cur_record_tmp.u_z1banum;
     
          commit;
     
          insert into tmp_sourcingmetric    
          (sourcing, item, dest, source, eff, value, dur, category, currencyuom, qtyuom, u_z1banum)
          values (cur_record_tmp.sourcing, cur_record_tmp.item, cur_record_tmp.dest, cur_record_tmp.source, cur_record_tmp.eff, 
          case when v_qty > cur_record_tmp.value  then cur_record_tmp.value else v_qty end,
          cur_record_tmp.dur, cur_record_tmp.category, cur_record_tmp.currencyuom, cur_record_tmp.qtyuom, cur_record.orderid);
          
          commit;
 
          delete tmp_sourcingmetric where value <= 0;
     
          commit;
       
          v_qty := v_qty - (case when v_qty > cur_record_tmp.value  then cur_record_tmp.value else v_qty end);
           
          exit when v_qty <= 0;
      
      end loop;
      commit;
    end;

  end loop;
  commit;
end;


-- Match Z1AA orders & tmp_sourcingmetric rows

declare
  cursor cur_selected is
          ---  ??? no renombrar shipdate como eff
         select o.qty , o.loc dest, o.u_defplant source , o.item, o.shipdate eff, o.u_sales_document, o.u_ship_condition, o.orderid
         from custorder o, vehicleloadline vll, loc l
         where to_number(o.orderid) = vll.orderid (+)
         and vll.orderid is null   --and o.loc in ('0100955458','5000517161') -- orderid ='3200876974000010'
         and o.u_sales_document in ('Z1AA','Z1CA')
         and o.u_ship_condition = 'Z2'
         and o.loc = l.loc
         and l.u_area = 'EU'
         --and o.loc  = '0100558491' and o.u_defplant = 'ES1J' and o.item = '3RUPCSTRD' --and o.shipdate = '15-JUL-15'
         order by o.qty desc;
         
begin
  for cur_record in cur_selected loop
     
     v_qty := cur_record.qty;     
     
     declare
      cursor cur_selected_tmp is
      -- ??? duration hardcoded and eff + duraton/1440
        select value, sourcing, item, source, dest, eff, 1440 dur, 418 category, 0 currencyuom,  0 qtyuom, u_z1banum
        from 
          (select value, sourcing, item, source, dest, eff, 1440 dur, 418 category, 0 currencyuom,  0 qtyuom,  u_z1banum
          from
            (select value, sourcing, item, source, dest, eff, 1440 dur, 418 category, 0 currencyuom,  0 qtyuom, u_z1banum
            from 
              (select min(value) value, sourcing, item, source, dest, eff, 1440 dur, 418 category, 0 currencyuom,  0 qtyuom, u_z1banum
              from tmp_sourcingmetric
              where value >= cur_record.qty
              and item = cur_record.item
              and dest = cur_record.dest
              and eff = cur_record.eff
              group by sourcing, item, source, dest, eff, u_z1banum
              order by value asc
              )
            where rownum = 1  
        
            union
          
            --select value, sourcing, item, source, dest, eff, 1440 dur, 418 category, 0 currencyuom,  0 qtyuom, u_z1banum
            --from 
            --  (
              select max(value) value, sourcing, item, source, dest, eff, 1440 dur, 418 category, 0 currencyuom,  0 qtyuom, u_z1banum
              from tmp_sourcingmetric
              where value < cur_record.qty
              and item = cur_record.item
              and dest = cur_record.dest 
              and eff = cur_record.eff
              group by sourcing, item, source, dest, eff, u_z1banum
            --  order by value desc
            --  )
            --where rownum = 1
            )
          order by value desc
          )
        --where rownum = 1
        ;

     
     begin
      for cur_record_tmp in cur_selected_tmp loop
      
          
          --DBMS_OUTPUT.PUT_LINE(cur_record.orderid);
          --DBMS_OUTPUT.PUT_LINE(cur_record.source);
          --DBMS_OUTPUT.PUT_LINE(cur_record_tmp.value);
      
          update tmp_sourcingmetric set value = value - v_qty
          where sourcing = cur_record_tmp.sourcing
          and item = cur_record_tmp.item 
          and source = cur_record_tmp.source
          and dest = cur_record_tmp.dest
          and eff =cur_record_tmp.eff          --- eff + duration/1440
          and u_z1banum = cur_record_tmp.u_z1banum;
     
          commit;
     
          -- insert into planarriv
          insert into planarriv (item, dest, source, sourcing,   transmode, firmplansw, needarrivdate,  schedarrivdate,     needshipdate,     
          schedshipdate, qty,  expdate, shrinkagefactor,   transname,   action,  actiondate, actionallowedsw, actionqty, reviseddate,        
          availtoshipdate, substqty,  ff_trigger_control, headerseqnum,  covdurscheddate,   departuredate,     deliverydate, orderplacedate,  
          supporderqty,     revisedexpdate,   nonignorableqty, seqnum, u_sales_document, u_ship_condition, u_custorderid, u_z1banum, u_sap_defplant,  u_sent)
          
          select t.item, t.dest, t.source, t.sourcing,   'TRUCK' transmode, 0 firmplansw, t.eff needarrivdate, t.eff schedarrivdate, t.eff-(c.minleadtime/1440) needshipdate,     
          t.eff-(c.minleadtime/1440) schedshipdate,  case when v_qty > cur_record_tmp.value  then cur_record_tmp.value else v_qty end qty, 
          scpomgr.u_jan1970 expdate,      0 shrinkagefactor,     ' ' transname,     
          0 action,     scpomgr.u_jan1970 actiondate,     0 actionallowedsw,     0 actionqty,     scpomgr.u_jan1970 reviseddate,        
          t.eff availtoshipdate,     0 substqty,      '' ff_trigger_control,     0 headerseqnum,     scpomgr.u_jan1970 covdurscheddate,     
          t.eff departuredate,  t.eff deliverydate,     scpomgr.u_jan1970 orderplacedate,     0 supporderqty,     
          scpomgr.u_jan1970 revisedexpdate,     0 nonignorableqty,         
          case when p.item is null then 1 else lastseqnum+rownum  end seqnum, cur_record.u_sales_document, cur_record.u_ship_condition, 
          cur_record.orderid u_custorderid, cur_record_tmp.u_z1banum u_z1banum, cur_record.source u_sap_defplant, 0 u_sent
          from tmp_sourcingmetric t, sourcing c,              --- ??? quitar sourcing join and use eff & duration
          
              (select item, dest, max(seqnum) lastseqnum
              from planarriv
              group by item, dest
              ) p
              
          where t.sourcing = cur_record_tmp.sourcing
          and t.item = cur_record_tmp.item 
          and t.source = cur_record_tmp.source
          and t.dest = cur_record_tmp.dest
          and t.eff = cur_record_tmp.eff
          and t.u_z1banum = cur_record_tmp.u_z1banum
          and t.sourcing = c.sourcing
          and t.item = c.item
          and t.source = c.source
          and t.dest = c.dest
          and t.item = p.item (+)
          and t.dest = p.dest (+);
     
          
          commit;
          
          v_qty := v_qty - (case when v_qty > cur_record_tmp.value  then cur_record_tmp.value else v_qty end); 
          
          --insert into tmp_sourcingmetric (sourcing, item, DEST, SOURCE, EFF, VALUE , DUR, CATEGORY  , CURRENCYUOM ,  QTYUOM )
          --  select sourcing, item, DEST, SOURCE, EFF, VALUE , DUR, CATEGORY  , CURRENCYUOM ,  QTYUOM 
          --  from tmp_sourcingmetric
          --  where sourcing = cur_record_tmp.sourcing
          --  and item = cur_record_tmp.item 
          --  and source = cur_record_tmp.source
          --  and dest = cur_record_tmp.dest
          --  and eff =cur_record_tmp.eff;
             
          --commit;     
     
          delete tmp_sourcingmetric where value <= 0;
     
          commit;
          
          exit when v_qty <= 0;
     
      end loop;
      commit;
    end;

  end loop;
  commit;
end;

-- COLLECTIONS

EXECUTE IMMEDIATE 'TRUNCATE TABLE TMP_SOURCINGMETRIC';

insert into tmp_sourcingmetric
     --(select distinct s.*, 0 u_z1banum
     (select distinct s.sourcing, s.item, s.dest, s.source, s.eff, s.value, s.dur, s.category, s.currencyuom, s.qtyuom, 0 u_z1banum
     --from sourcingmetric s, custorder o, vehicleloadline vll, planarriv p, loc l
     from sim_sourcingmetric s, custorder o, vehicleloadline vll, planarriv p, loc l
     where substr(s.sourcing, 1, 7) not in ('COL9DEL','MER9DEL')
     and s.category = 417
     and s.item= o.item
     and s.source = o.loc
     and s.eff = o.shipdate
     and o.u_sales_document in ('Z1BA')
     and o.u_ship_condition = 'Z2'
     and o.loc = l.loc
     --and l.u_area = 'EU'
     and s.simulation_name = 'ED'
     and to_number(o.orderid) = vll.orderid (+)
     and vll.orderid is null
     --and s.dest  = '0100558491' --and s.item = '3RUPCSTRD' --and s.eff = '15-JUL-15'
     and value > 0
     and o.orderid = p.u_z1banum (+)
     and p.u_z1banum is null
     --and s.dest = p.dest(+)  -- 13-Nov-15
     --and s.eff = p.schedarrivdate(+)   
     --and p.dest is null
     );
     
commit;

declare
  cursor cur_selected is
          
         select o.qty , o.loc source, o.u_defplant dest , o.item, o.shipdate eff, o.u_sales_document, o.u_ship_condition, o.orderid
         from custorder o, vehicleloadline vll, planarriv p, loc l
         where to_number(o.orderid) = vll.orderid (+)
         and vll.orderid is null
         and o.u_sales_document = 'Z1BA'
         and o.u_ship_condition = 'Z2'
         and o.orderid = p.u_z1banum(+)
         and p.u_z1banum is null
         and o.loc = l.loc
         and l.u_area = 'EU'
         --and o.loc  = '0100558491' and o.u_defplant = 'ES1J' and o.item = '3RUPCSTRD' --and o.shipdate = '15-JUL-15'
         order by o.qty desc;
         
begin
  for cur_record in cur_selected loop
     
     v_qty := cur_record.qty; 
          
     declare
      cursor cur_selected_tmp is
        select value, sourcing, item, source, dest, eff, 1440 dur, 417 category, 0 currencyuom, 0 qtyuom
        from 
          (select value, sourcing, item, source, dest, eff, 1440 dur, 417 category, 0 currencyuom, 0 qtyuom
          from 
            (select value, sourcing, item, source, dest, eff, 1440 dur, 418 category, 0 currencyuom,  0 qtyuom
            from
          
              (select min(value) value, sourcing, item, source, dest, eff, 1440 dur, 417 category, 0 currencyuom, 0 qtyuom
              from tmp_sourcingmetric
              where value >= cur_record.qty
              and item = cur_record.item
              and source = cur_record.source
              and eff = cur_record.eff
              group by sourcing, item, source, dest, eff
              order by value asc
              )
            where rownum = 1
          
            union
          
          --  select value, sourcing, item, source, dest, eff, 1440 dur, 418 category, 0 currencyuom,  0 qtyuom
          --  from
        
          --    (
              select max(value) value, sourcing, item, source, dest, eff, 1440 dur, 417 category, 0 currencyuom, 0 qtyuom
              from tmp_sourcingmetric
              where value < cur_record.qty
              and item = cur_record.item
              and source = cur_record.source
              and eff = cur_record.eff
              group by sourcing, item, source, dest, eff
        --      order by value desc
        --      )
        --    where rownum = 1  
            )
          order by value desc
          )
        --where rownum = 1
        ;
     
     begin
      for cur_record_tmp in cur_selected_tmp loop
      
          update tmp_sourcingmetric set value = value - v_qty
          where sourcing = cur_record_tmp.sourcing
          and item = cur_record_tmp.item 
          and source = cur_record_tmp.source
          and dest = cur_record_tmp.dest
          and eff =cur_record_tmp.eff;
     
          commit;
     
          -- insert into planarriv
          insert into planarriv (item, dest, source, sourcing,   transmode, firmplansw, needarrivdate,  schedarrivdate,     needshipdate,     
          schedshipdate, qty,  expdate, shrinkagefactor,   transname,   action,  actiondate, actionallowedsw, actionqty, reviseddate,        
          availtoshipdate, substqty,  ff_trigger_control, headerseqnum,  covdurscheddate,   departuredate,     deliverydate, orderplacedate,  supporderqty,     
          revisedexpdate,     nonignorableqty, seqnum, u_sales_document, u_ship_condition, u_custorderid, u_sap_defplant, u_sent)
          
          select t.item, t.dest, t.source, t.sourcing,   'TRUCK' transmode, 0 firmplansw, t.eff+(c.minleadtime/1440) needarrivdate, t.eff+(c.minleadtime/1440) schedarrivdate, t.eff needshipdate,     
          t.eff schedshipdate,  case when cur_record.qty > cur_record_tmp.value  then cur_record_tmp.value else cur_record.qty end qty, 
          scpomgr.u_jan1970 expdate,      0 shrinkagefactor,     ' ' transname,     
          0 action,     scpomgr.u_jan1970 actiondate,     0 actionallowedsw,     0 actionqty,     scpomgr.u_jan1970 reviseddate,        
          t.eff availtoshipdate,     0 substqty,      '' ff_trigger_control,     0 headerseqnum,     scpomgr.u_jan1970 covdurscheddate,     
          t.eff departuredate,  t.eff deliverydate,     scpomgr.u_jan1970 orderplacedate,     0 supporderqty,     
          scpomgr.u_jan1970 revisedexpdate,     0 nonignorableqty,         
          case when p.item is null then 1 else lastseqnum+1 end seqnum, cur_record.u_sales_document, cur_record.u_ship_condition, 
          cur_record.orderid u_custorderid, cur_record.dest, 0 u_sent
          from tmp_sourcingmetric t, sourcing c,
          
              (select item, dest, max(seqnum) lastseqnum
              from planarriv
              group by item, dest
              ) p
              
          where t.sourcing = cur_record_tmp.sourcing 
          and t.item = cur_record_tmp.item 
          and t.source = cur_record_tmp.source
          and t.dest = cur_record_tmp.dest
          and t.eff = cur_record_tmp.eff
          and t.sourcing = c.sourcing
          and t.item = c.item
          and t.source = c.source
          and t.dest = c.dest
          and t.item = p.item (+)
          and t.dest = p.dest (+);
     
          
          commit;
          
          --insert into tmp_sourcingmetric (sourcing, item, DEST, SOURCE, EFF, VALUE , DUR, CATEGORY  , CURRENCYUOM ,  QTYUOM )
          --  select sourcing, item, DEST, SOURCE, EFF, VALUE , DUR, CATEGORY  , CURRENCYUOM ,  QTYUOM 
          --  from tmp_sourcingmetric
          --  where sourcing = cur_record_tmp.sourcing
          --  and item = cur_record_tmp.item 
          --  and source = cur_record_tmp.source
          --  and dest = cur_record_tmp.dest
          --  and eff =cur_record_tmp.eff;
             
          --commit;      
     
          delete tmp_sourcingmetric where value <= 0;
     
          commit;
          
          v_qty := v_qty - (case when v_qty > cur_record_tmp.value  then cur_record_tmp.value else v_qty end);
           
          exit when v_qty <= 0;
      
      end loop;
      commit;
    end;

  end loop;
  commit;
end;

END ;
