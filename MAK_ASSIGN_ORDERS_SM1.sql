--------------------------------------------------------
--  DDL for Procedure MAK_ASSIGN_ORDERS_SM1
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."MAK_ASSIGN_ORDERS_SM1" 
is
begin
  execute immediate 'truncate table scpomgr.mak_cust_table_test';
  execute immediate
  'insert into mak_cust_table_test    
( status, sm_record, co_item, loc, shipdate, schedshipdate, schedarrivdate, co_orderid, co_qty, u_sales_document
 ,u_ship_condition, u_dmdgroup_code, vl_orderid, loadid, vll_dest, vll_source
 ,vll_qty, vll_item,  u_overallsts, sourcing )
(   select case when vll.u_overallsts is null and co.shipdate >= trunc(sysdate)then 0
                when vll.u_overallsts = ''A'' and co.shipdate >= trunc(sysdate)then 0
                when vll.u_overallsts = ''C'' and co.shipdate >= trunc(sysdate)then 9
                when co.shipdate < trunc(sysdate) then 10
                else 0
           end status
         , 0 sm_record
         , co.item co_item
         , co.loc
         , co.shipdate
         , vll.schedshipdate
         , vll.schedarrivdate
         , co.orderid co_orderid
         , co.qty co_qty
         , co.u_sales_document
         , co.u_ship_condition
         , co.u_dmdgroup_code
         , vll.orderid vl_orderid
         , vll.loadid
         , vll.dest vll_dest
         , vll.source vll_source
         , vll.qty vll_qty
         , vll.item vll_item
         , vll.u_overallsts
         , case when vll.u_overallsts = ''C'' then ''INTRANSIT''
                else '' ''
          end sourcing
     from custorder co , vehicleloadline vll,  loc l
    where co.orderid    = vll.orderid(+) 
      and l.loc = co.loc 
      and l.u_area = ''NA'' 
--      and co.item like ''%RU%''
 --     and co.shipdate >= trunc(sysdate)
--      and ( vll.u_overallsts is null or vll.u_overallsts=''A'')
)';
commit;  

execute immediate 'truncate table scpomgr.mak_sm_418_table';  
execute immediate 'insert into mak_sm_418_table
  (  recnum  , item  , dest  , source, sourcing , eff  , sm_totqty  , remainder
   , vl_qty_used  , co_qty_used, p1, dur
  )
  ( select rownum recnum
       , smv.item
       , smv.dest
       , smv.source
       , smv.sourcing
       , smv.eff
       , smv.sm_totqty
       , smv.sm_totqty remainder
       , 0 vl_qty_used
       , 0 co_qty_used
       , 0
       , smv.dur
    from (
          select sm.item
               , sm.dest
               , sm.source
               , sm.sourcing
               , sm.dur
               , sm.eff
               , round( sum( sm.value ), 2 ) sm_totqty
            from sourcingmetric sm, loc ls, loc ld
            where ls.loc = sm.source
              and ls.u_area = ''NA''
              and ld.loc = sm.dest
              and ld.u_area = ''NA''
              and sm.category = 418
              and sm.value > 0
          group by sm.item, sm.dest, sm.source, sm.sourcing, sm.dur, sm.eff
          order by item, dest, sm.dur, sm.eff asc, sourcing asc   
        )smv
  )' ;
  commit;
  
------------------------------------------------------
-- Set teh P1 value in the table. Will use to sort.
------------------------------------------------------
merge into mak_sm_418_table smt
using (
    select item, source, dest
      from udt_llamasoft_data 
) ll
on ( smt.item=ll.item and smt.source=ll.source and smt.dest=ll.dest)
when matched then
   update set smt.p1=1;
commit;
  

  ------------------------------------------------------------------------------
  -- Declare the cursors
  -----------------------------------------------------------------------------
  declare

       
     cursor cur_del_orders is
        select co_orderid
             , co_item
             , co.loc
             , co.shipdate
             , co_qty
             , vll_source
             , vll_dest
         from mak_cust_table_test co
        where co.vl_orderid   is not null
          and co.status       = 0
          and co.sm_record    = 0
     order by co.shipdate asc, co.loc asc;
     
     cursor cur_open_orders is
        select co_orderid
             , co_item
             , co.loc
             , co.shipdate
             , co_qty
         from mak_cust_table_test co
        where co.vl_orderid   is null
          and co.status       = 0
          and co.sm_record    = 0
        order by co.shipdate asc, co.loc asc;

      

     cursor cur_get_sm_lane( in_loc      varchar2
                            ,in_item     varchar2
                            ,in_source   varchar2
                            ,in_shipdate date
                           ) 
        is
        select smt.recnum, smt.item, smt.dest, smt.source, smt.sourcing, smt.eff
             , smt.remainder, smt.vl_qty_used, smt.co_qty_used, smt.dur
             from mak_sm_418_table smt
         where smt.dest   = in_loc
           and smt.item   = in_item
           and smt.source = in_source
           and smt.eff    = in_shipdate;
      sm_lane_rec cur_get_sm_lane%rowtype;
            
      cursor cur_plant_lanes( in_loc      varchar2
                            , in_item     varchar2
                            , in_shipdate date) 
        is
        select smt.recnum, smt.item, smt.source, smt.sourcing, smt.dest, smt.eff
             , smt.remainder, smt.vl_qty_used, smt.co_qty_used, smt.dur
          from mak_sm_418_table smt
         where smt.dest  = in_loc
           and smt.item  = in_item
           and smt.eff   = in_shipdate
          order by p1 desc;
      sm_plant_rec cur_plant_lanes%rowtype;
       
       cursor cur_sm_unused ( in_item   varchar2
                             ,in_source varchar2
                             ,in_eff    date
                            )
       is 
         select recnum, item, source, eff, remainder, vl_qty_used, co_qty_used
          from mak_sm_unused_table
         where item  = in_item
           and source= in_source
           and eff   = in_eff;

          
      cursor cur_plant_list( in_loc      varchar2
                            ,in_item     varchar2
                            ,in_shipdate date
                           ) 
      is
        select smt.recnum, smt.item, smt.source, smt.dest, smt.eff
             , smt.remainder, smt.vl_qty_used, smt.co_qty_used, smt.dur
          from mak_sm_418_table smt
         where smt.dest = in_loc
           and smt.item = in_item
           and smt.eff  <=  in_shipdate
          order by p1 desc;
            
     cursor cur_get_sm_list( in_loc    varchar2
                            ,in_item   varchar2
                            ,in_source varchar2
                            ,in_shipdate date
                           )
        is
        select smt.recnum, smt.item, smt.dest, smt.source, smt.eff
             , smt.remainder, smt.vl_qty_used, smt.co_qty_used, smt.dur
             from mak_sm_418_table smt
         where smt.dest = in_loc
           and smt.item   = in_item
           and smt.source = in_source
           and smt.eff   <=  in_shipdate;
           
      cursor cur_collection_lanes( in_source      varchar2
                                 , in_item     varchar2
                                 , in_shipdate date) 
        is
        select smt.recnum, smt.item, smt.source,smt.sourcing, smt.dest, smt.eff
             , smt.remainder, smt.vl_qty_used, smt.co_qty_used, smt.dur
          from mak_sm_418_table smt
         where smt.source  = in_source
           and smt.item  = in_item
           and smt.eff   = in_shipdate
          order by p1 desc;
      sm_collection_rec cur_collection_lanes%rowtype;
--------------------------------------------------
-- Procedure Section
--------------------------------------------------
      
     procedure updatecust( p_status  in number
                          ,p_recnum  in number
                          ,p_source  in varchar2
                          ,p_sourcing in varchar2
                          ,p_orderid in varchar2
                          ,p_dur     in number) is
       begin
         update mak_cust_table_test co
            set co.status      = p_status
              , co.sm_record= p_recnum
              , co.assigned_plant=p_source
              , co.dur = p_dur
              , co.sourcing = p_sourcing
          where co.co_orderid= p_orderid;
          commit;
          
      end updatecust;

     procedure updatesm( p_remainder in number
                        ,p_co_qty    in number
                        ,p_vl_qty    in number
                        ,p_recnum    in number) is
       begin
         update mak_sm_418_table smt
            set smt.remainder    = p_remainder
              , smt.co_qty_used  = p_co_qty
              , smt.vl_qty_used  = p_vl_qty
          where smt.recnum = p_recnum;
          commit;
     end updatesm;

     procedure updatesm_unused( p_remainder in number
                               ,p_co_qty    in number
                               ,p_vl_qty    in number
                               ,p_recnum    in number) is
       begin
         update mak_sm_unused_table smt
           set smt.remainder    = p_remainder
             , smt.co_qty_used  = p_co_qty
             , smt.vl_qty_used  = p_vl_qty
         where smt.recnum = p_recnum;
         commit;
     end updatesm_unused;

     procedure updatesm_vll_extra(p_remainder in number,p_co_qty in number, p_vl_qty in number, p_recnum number) is
       begin
                
         update mak_sm_extr_vll_table smt
           set smt.remainder    = p_remainder
             , smt.co_qty_used  = p_co_qty
             , smt.vl_qty_used  = p_vl_qty
         where smt.recnum = p_recnum;
         commit;
     end updatesm_vll_extra;

  begin
  
-----------------------------------------------------------------------------
  -- Begin Looping over the delivery orders first Status=2
-----------------------------------------------------------------------------

    for del_rec in cur_del_orders loop
        open cur_get_sm_lane ( del_rec.loc, del_rec.co_item, del_rec.vll_source, del_rec.shipdate);
        fetch cur_get_sm_lane into sm_lane_rec;
--        dbms_output.put_line('A: '|| del_rec.loc|| '-' || del_rec.co_item|| '-' || del_rec.vll_source|| '-' ||  del_rec.shipdate );
--        dbms_output.put_line('B: ' || sm_lane_rec.dest||'-'||sm_lane_rec.item||'-'||sm_lane_rec.eff||'-'||sm_lane_rec.remainder);
        if cur_get_sm_lane%found then
           if (      sm_lane_rec.remainder - del_rec.co_qty >= 0 
                or ( sm_lane_rec.remainder >= 0.8 * del_rec.co_qty) ) then
                sm_lane_rec.remainder := sm_lane_rec.remainder - del_rec.co_qty;
                sm_lane_rec.vl_qty_used :=  sm_lane_rec.vl_qty_used + del_rec.co_qty;
 
                updatesm( p_remainder => sm_lane_rec.remainder 
                         ,p_co_qty    => sm_lane_rec.co_qty_used
                         ,p_vl_qty    => sm_lane_rec.vl_qty_used
                         ,p_recnum    => sm_lane_rec.recnum
                );
                updatecust( p_status  => 2,
                            p_recnum  =>  sm_lane_rec.recnum
                           ,p_source  =>  sm_lane_rec.source
                           ,p_sourcing => sm_lane_rec.sourcing
                           ,p_dur     =>  sm_lane_rec.dur
                           ,p_orderid =>  del_rec.co_orderid
                );           
                
           end if;
        end if;
        close cur_get_sm_lane;
    end loop; -- del_orders_loop
 
  -----------------------------------------------------------------------------
  -- Begin Orders Status =1
  -----------------------------------------------------------------------------
 
    for ord_rec in  cur_open_orders loop
      open cur_plant_lanes(ord_rec.loc, ord_rec.co_item, ord_rec.shipdate);
        
<<sm_plant_loop>> 
      loop
        fetch cur_plant_lanes into sm_plant_rec;
        exit sm_plant_loop when cur_plant_lanes%notfound; 

          if  (     sm_plant_rec.remainder - ord_rec.co_qty >= 0 
                or (sm_plant_rec.remainder >= 0.8 * ord_rec.co_qty)) then
                sm_plant_rec.remainder := sm_plant_rec.remainder - ord_rec.co_qty;
                sm_plant_rec.co_qty_used :=  sm_plant_rec.co_qty_used + ord_rec.co_qty;
--       dbms_output.put_line('A: '||  ord_rec.loc|| '-' || ord_rec.co_item|| '-' || ord_rec.shipdate || '-' || ord_rec.co_qty );
--       dbms_output.put_line('B: ' || sm_plant_rec.recnum||'-'|| sm_plant_rec.dest||'-'||sm_plant_rec.item||'-'||sm_plant_rec.eff||'-'||sm_plant_rec.remainder);         
                updatesm( p_remainder => sm_plant_rec.remainder 
                         ,p_co_qty    => sm_plant_rec.co_qty_used
                         ,p_vl_qty    => sm_plant_rec.vl_qty_used
                         ,p_recnum    => sm_plant_rec.recnum
                );
                updatecust( p_status  => 1,
                            p_recnum  => sm_plant_rec.recnum
                           ,p_source  => sm_plant_rec.source
                           ,p_sourcing  => sm_plant_rec.sourcing
                           ,p_dur     => sm_plant_rec.dur
                           ,p_orderid => ord_rec.co_orderid
                );                            
                exit sm_plant_loop; -- Found a match so continue with next order
          end if;
      end loop; -- sm_plants_loop
      close cur_plant_lanes;
    end loop; -- c_orders_loop
 
-----------------------------------------------------------------------------
-- Begin Collecting Pieces left at plant
-----------------------------------------------------------------------------
execute immediate 'truncate table scpomgr.mak_sm_unused_table';  
execute immediate 'insert into mak_sm_unused_table
  ( recnum, item, source, eff, total, remainder, vl_qty_used, co_qty_used )
  (select -1 * rownum recnum, item, source, eff, total
    , remainder, 0 vl_qty_used, 0 co_qty_used
   from (
         select item
              , source
              , eff,sum( remainder ) total
              , sum( remainder ) remainder
              , 0 sm_qty_used
              , 0 co_qty_used
           from mak_sm_418_table
          where remainder > 0
          group by item, source, eff
          order by item, source, eff
        )
  )';
commit;

------------------------------------------------------------
-- Add More Deliveries Status=3
------------------------------------------------------------
    for del_rec in cur_del_orders loop
        open cur_get_sm_lane ( del_rec.loc, del_rec.co_item, del_rec.vll_source, del_rec.shipdate);
        fetch cur_get_sm_lane into sm_lane_rec;

        if cur_get_sm_lane%found then
                
          <<cl_loop>>
          for cl_rec in  cur_sm_unused( sm_lane_rec.item, sm_lane_rec.source, sm_lane_rec.eff) loop      
            if  (     cl_rec.remainder - del_rec.co_qty >= 0 
                 or ( cl_rec.remainder >= 0.8 * del_rec.co_qty)) then
                 
                cl_rec.remainder   := cl_rec.remainder   - del_rec.co_qty;
                cl_rec.vl_qty_used := cl_rec.vl_qty_used + del_rec.co_qty;
                  
                updatesm_unused( p_remainder => cl_rec.remainder 
                                ,p_co_qty    => cl_rec.co_qty_used
                                ,p_vl_qty    => cl_rec.vl_qty_used
                                ,p_recnum    => cl_rec.recnum
                );
                updatecust( p_status  => 3,
                            p_recnum  => cl_rec.recnum
                           ,p_source  => cl_rec.source
                           ,p_sourcing=> sm_lane_rec.sourcing
                           ,p_dur     => sm_lane_rec.dur
                           ,p_orderid => del_rec.co_orderid
                );                            
                exit cl_loop;
            end if; -- remainder > 0
          end loop; -- <<cl_loop>>
        end if; -- cur_get_sm_lane%found
        close cur_get_sm_lane;
    end loop; -- cur_del_orders
          
------------------------------------------------------------
-- Add More orders Status = 4
------------------------------------------------------------
    for ex_rec in cur_open_orders loop
        <<plant_loop_s4>>
        for plant_rec in cur_plant_list ( ex_rec.loc, ex_rec.co_item, ex_rec.shipdate) loop
          
          for cl_rec in  cur_sm_unused( plant_rec.item, plant_rec.source, plant_rec.eff) loop      
          
             if (    cl_rec.remainder - ex_rec.co_qty >= 0 
                or ( cl_rec.remainder >= 0.8 * ex_rec.co_qty ) )then

                cl_rec.remainder   := cl_rec.remainder   - ex_rec.co_qty;
                cl_rec.co_qty_used := cl_rec.co_qty_used + ex_rec.co_qty;
                updatesm_unused( p_remainder => cl_rec.remainder 
                                ,p_co_qty    => cl_rec.co_qty_used
                                ,p_vl_qty    => cl_rec.vl_qty_used
                                ,p_recnum    => cl_rec.recnum
                );
                updatecust( p_status  => 4,
                            p_recnum  => cl_rec.recnum
                           ,p_source  => cl_rec.source
                           ,p_sourcing=> sm_lane_rec.sourcing
                           ,p_dur     => plant_rec.dur
                           ,p_orderid => ex_rec.co_orderid
                );                                            
               exit plant_loop_s4;
             end if; -- remainder > 0
             
          end loop; -- <<cur_sm_unused>>
        end loop; --<<cur_plant_lanes>>
    end loop; -- cur_open_orders
          
------------------------------------------------------------------------
------------------------------------------------------------------------
  execute immediate 'truncate table mak_sm_417_table';
  execute immediate 'insert into mak_sm_417_table
  (  recnum  , item  , dest  , source , sourcing , eff  , sm_totqty  , remainder
   , vl_qty_used  , co_qty_used, p1
  )
  ( select rownum recnum
       , smv.item
       , smv.dest
       , smv.source
       , smv.sourcing
       , smv.eff
       , smv.sm_totqty
       , smv.sm_totqty remainder
       , 0 vl_qty_used
       , 0 co_qty_used, 0
    from (
          select sm.item
               , sm.dest
               , sm.source
               , sm.sourcing
               , sm.eff
               , round( sum( sm.value ), 2 ) sm_totqty
            from sourcingmetric sm, loc ls, loc ld
            where ls.loc = sm.source
              and ls.u_area = ''NA''
              and ld.loc = sm.dest
              and ld.u_area = ''NA''
              and sm.category = 417
              and sm.value > 0
          group by sm.item, sm.dest, sm.source, sm.sourcing, sm.eff
          order by item, dest, sm.eff asc   
        )smv
  )';
  
   
--  
-----------------------------------------------------------------------------
  -- Begin Collection Deliveries
-----------------------------------------------------------------------------

    for del_rec in cur_del_orders loop
        open cur_get_sm_lane ( del_rec.vll_dest, del_rec.co_item, del_rec.vll_source , del_rec.shipdate);
        fetch cur_get_sm_lane into sm_lane_rec;
--       dbms_output.put_line('A: '||  del_rec.loc|| '-' || del_rec.co_item|| '-' || del_rec.shipdate || '-' || del_rec.co_qty );

        if cur_get_sm_lane%found then
--       dbms_output.put_line('B: ' || sm_lane_rec.recnum||'-'|| sm_lane_rec.dest||'-'||sm_lane_rec.item||'-'||sm_lane_rec.eff||'-'||sm_lane_rec.remainder);          
           if del_rec.co_item like '%AI%'  then
                sm_lane_rec.remainder := sm_lane_rec.remainder - del_rec.co_qty;
                sm_lane_rec.vl_qty_used :=  sm_lane_rec.vl_qty_used + del_rec.co_qty;
 
--        dbms_output.put_line('C: ' || sm_lane_rec.recnum||'-'|| sm_lane_rec.dest||'-'||sm_lane_rec.item||'-'||sm_lane_rec.eff||'-'||sm_lane_rec.remainder);      
                updatesm( p_remainder => sm_lane_rec.remainder 
                         ,p_co_qty    => sm_lane_rec.co_qty_used
                         ,p_vl_qty    => sm_lane_rec.vl_qty_used
                         ,p_recnum    => sm_lane_rec.recnum
                );
                updatecust( p_status  => 5,
                            p_recnum  => sm_lane_rec.recnum
                           ,p_source  => sm_lane_rec.dest
                           ,p_sourcing=> sm_lane_rec.sourcing
                           ,p_dur     => sm_lane_rec.dur
                           ,p_orderid =>  del_rec.co_orderid
                );           
                
           end if;
        end if;
        close cur_get_sm_lane;
    end loop; -- del_orders_loop    

  -----------------------------------------------------------------------------
  -- Begin Collection processing for open orders Status =6
  -----------------------------------------------------------------------------
 
    for ord_rec in  cur_open_orders loop
      open cur_collection_lanes(ord_rec.loc, ord_rec.co_item, ord_rec.shipdate);
        
<<sm_coll_loop>> 
      loop
        fetch cur_collection_lanes into sm_collection_rec;
        exit sm_coll_loop when cur_collection_lanes%notfound; 
        
--          if  (     sm_collection_rec.remainder - ord_rec.co_qty >= 0 
--                or (sm_collection_rec.remainder >= 0.8 * ord_rec.co_qty)) then
           if ord_rec.co_item like '%AI%'  then                
                sm_plant_rec.remainder := sm_plant_rec.remainder - ord_rec.co_qty;
                sm_plant_rec.co_qty_used :=  sm_plant_rec.co_qty_used + ord_rec.co_qty;
                  
                updatesm( p_remainder => sm_collection_rec.remainder 
                         ,p_co_qty    => sm_collection_rec.co_qty_used
                         ,p_vl_qty    => sm_collection_rec.vl_qty_used
                         ,p_recnum    => sm_collection_rec.recnum
                );
                updatecust( p_status  => 6,
                            p_recnum  => sm_collection_rec.recnum
                           ,p_source  => sm_collection_rec.dest
                           ,p_sourcing  => sm_collection_rec.sourcing
                           ,p_dur     => sm_collection_rec.dur
                           ,p_orderid => ord_rec.co_orderid
                );                            
                exit sm_coll_loop; -- Found a match so continue with next order
          end if;
      end loop; -- sm_plants_loop
      close cur_collection_lanes;
    end loop; -- c_orders_loop
-------------------------------------------------------------------------
-------------------------------------------------------------------------
 merge into mak_cust_table_test mct
using (
 select sms.recnum, sms.eff, sms.sourcing, ct.co_orderid, src.minleadtime
   from mak_sm_418_table sms
      , mak_cust_table_test ct
      , sourcing src
  where ct.status in (1, 2, 3, 4)
    and sms.dest   = ct.loc
    and sms.source = ct.assigned_plant 
    and sms.item = ct.co_item
    and ct.sourcing = src.sourcing
    and ct.sourcing = sms.sourcing
    and sms.sm_totqty > 0
    and src.dest = ct.loc 
    and src.source = ct.assigned_plant 
    and src.item = ct.co_item 
) sm418
on ( mct.co_orderid=sm418.co_orderid)
when matched then
   update set mct.sm417_recnum = sm418.recnum
            , mct.sm417_eff    = sm418.eff
            , mct.sourcing     = sm418.sourcing
            , mct.minleadtime  = sm418.minleadtime;
commit;


--
--/* Now dow the collecitons  for deliveries*/
 merge into mak_cust_table_test mct
using (
 select sms.recnum, sms.eff, sms.sourcing, ct.co_orderid, src.minleadtime
   from mak_sm_418_table sms
      , mak_cust_table_test ct
      , sourcing src
  where ct.status in (5, 6)
    and sms.dest   = ct.assigned_plant
    and sms.source = ct.loc
    and sms.item = ct.co_item
    and ct.sourcing = src.sourcing
    and ct.sourcing = sms.sourcing
    and sms.sm_totqty > 0
    and src.dest = ct.assigned_plant 
    and src.source = ct.loc 
    and src.item = ct.co_item 
) sm418
on ( mct.co_orderid=sm418.co_orderid)
when matched then
   update set mct.sm417_recnum = sm418.recnum
            , mct.sm417_eff    = sm418.eff
            , mct.sourcing     = sm418.sourcing
            , mct.minleadtime  = sm418.minleadtime;
commit;
---------------------------------------------------------------------------
---------------------------------------------------------------------------
--        update mak_cust_table_test co
--            set co.firmsw = 1
--          where co.status in (1,4)
--            and co.u_sales_document='Z1AA'
--            and co.u_ship_condition='Z2'
--            and trim(co.sourcing) is not null;
--          commit;
--
--
--
       update mak_cust_table_test co
            set co.sourcing = 'UNPLANNED'
              , co.minleadtime=0
              , co.assigned_plant = case when vll_source is not null then vll_source 
                                         else 'US9X' 
                                    end
          where co.status =9;
          commit;

        update mak_cust_table_test co
            set co.sourcing = 'UNMET'
              , co.minleadtime=0
          where co.status = 0;
          commit;

        update mak_cust_table_test co
            set co.sourcing='UNPLANNED'
              , co.assigned_plant = vll_source
              , co.minleadtime=0
          where co.status = 10;
          commit;
          
        


   end;   -- end of procedure mak_assign_orders
end; -- end of begin


 --dbms_output.put_line('A: '|| ex_rec.co_orderid || ' ' || ex_rec.loc || '-' || ex_rec.co_item || '-' || ex_rec.shipdate );    
 --dbms_output.put_line('B:' || plant_rec.item||'-'||plant_rec.source || '-' || plant_rec.eff   );
 --dbms_output.put_line('C: '|| vll_extra_rec.remainder ||'-' || ex_rec.co_qty  ); 
 --dbms_output.put_line('D: '|| vll_extra_rec.remainder ||'-' || vll_extra_rec.co_qty_used||'-'||vll_extra_rec.vl_qty_used||'-  '||vll_extra_rec.recnum );
--  dbms_output.put_line(del_rec.co_orderid ||'-' || sm_plant_rec.source||'-'||sm_plant_rec.recnum );
--  dbms_output.put_line(sm_lane_rec.dest||'-'||sm_lane_rec.item||'-'||sm_lane_rec.eff||'-'||sm_lane_rec.remainder);
