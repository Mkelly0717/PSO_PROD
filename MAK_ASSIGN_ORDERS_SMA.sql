--------------------------------------------------------
--  DDL for Procedure MAK_ASSIGN_ORDERS_SMA
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."MAK_ASSIGN_ORDERS_SMA" 
is
begin
  execute immediate 'truncate table scpomgr.mak_cust_table';
  execute immediate
  'insert into mak_cust_table   
( status, sm_record, co_item, loc, shipdate, schedshipdate, schedarrivdate
 ,co_orderid, co_qty, u_sales_document, u_ship_condition, u_dmdgroup_code
 ,vl_orderid, loadid, vll_dest, vll_source, vll_qty, vll_item
 ,u_overallsts, sourcing 
 )
(   select case when vll.u_overallsts is null 
                      and co.shipdate >= trunc(sysdate)then 0
                when vll.u_overallsts = ''A'' 
                      and co.shipdate >= trunc(sysdate)then 0
                when vll.u_overallsts = ''C'' 
                      and co.shipdate >= trunc(sysdate)then 9
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
            from sim_sourcingmetric sm, loc ls, loc ld
            where ls.loc = sm.source
              and ls.u_area = ''NA''
              and ld.loc = sm.dest
              and ld.u_area = ''NA''
              and sm.category = 418
              and sm.value > 0
              and sm.simulation_name=''AD''
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
  
update mak_sm_418_table mct
  set p1=2
where not exists ( select 1 
                     from udt_llamasoft_data ll 
                    where ll.item=mct.item 
                      and ll.dest=mct.dest);
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
         from mak_cust_table co
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
         from mak_cust_table co
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
           and smt.sourcing like '%DEL%'
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
           and smt.sourcing not like '%DEL%'
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
        select smt.recnum, smt.item, smt.source, smt.sourcing, smt.dest, smt.eff
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
         update mak_cust_table co
            set co.status      = p_status
              , co.sm_record= p_recnum
              , co.assigned_plant=p_source
              , co.dur = p_dur
              , co.sourcing = p_sourcing
          where CO.CO_ORDERID= P_ORDERID;
--          commit;
          
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
          where SMT.RECNUM = P_RECNUM;
--          commit;
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
         where SMT.RECNUM = P_RECNUM;
 --        commit;
     end updatesm_unused;


  begin
  
-----------------------------------------------------------------------------
  -- Begin Looping over the delivery orders first Status=2
-----------------------------------------------------------------------------

    for del_rec in cur_del_orders loop
        open cur_get_sm_lane ( del_rec.loc
                              ,del_rec.co_item
                              ,del_rec.vll_source
                              ,del_rec.shipdate);
        fetch cur_get_sm_lane into sm_lane_rec;

        if cur_get_sm_lane%found then
           if (      sm_lane_rec.remainder - del_rec.co_qty >= 0 
                or ( sm_lane_rec.remainder >= 0.8 * del_rec.co_qty) ) then
                sm_lane_rec.remainder := sm_lane_rec.remainder - del_rec.co_qty;
                sm_lane_rec.vl_qty_used := sm_lane_rec.vl_qty_used 
                                            + del_rec.co_qty;
 
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
    end LOOP; -- del_orders_loop
    commit;
 
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
                sm_plant_rec.co_qty_used :=  sm_plant_rec.co_qty_used 
                                              + ord_rec.co_qty;
       
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
    end LOOP; -- c_orders_loop
    commit;
 
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
        open cur_get_sm_lane ( del_rec.loc
                              ,del_rec.co_item
                              ,del_rec.vll_source
                              ,del_rec.shipdate
                             );
        fetch cur_get_sm_lane into sm_lane_rec;

        if cur_get_sm_lane%found then
                
          <<cl_loop>>
          for cl_rec in  cur_sm_unused( sm_lane_rec.item
                                       ,sm_lane_rec.source
                                       ,sm_lane_rec.eff
                                       ) loop      
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
                           ,P_SOURCE  => CL_REC.source
                           ,p_sourcing=> 'UNUSED_QTY'
                           ,p_dur     => sm_lane_rec.dur
                           ,p_orderid => del_rec.co_orderid
                );                            
                exit cl_loop;
            end if; -- remainder > 0
          end loop; -- <<cl_loop>>
        end if; -- cur_get_sm_lane%found
        close cur_get_sm_lane;
    end LOOP; -- cur_del_orders
    commit;
          
------------------------------------------------------------
-- Add More orders Status = 4
------------------------------------------------------------
    for ex_rec in cur_open_orders loop
        <<plant_loop_s4>>
        for plant_rec in cur_plant_list ( ex_rec.loc
                                         ,ex_rec.co_item
                                         ,ex_rec.shipdate
                                         ) loop
          
          for cl_rec in  cur_sm_unused( plant_rec.item
                                       ,plant_rec.source
                                       ,plant_rec.eff
                                       ) loop      
          
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
                            P_RECNUM  => CL_REC.RECNUM
                           ,P_SOURCE  => plant_rec.source
                           ,p_sourcing=> plant_rec.sourcing
                           ,p_dur     => plant_rec.dur
                           ,p_orderid => ex_rec.co_orderid
                );                                            
               exit plant_loop_s4;
             end if; -- remainder > 0
             
          end loop; -- <<cur_sm_unused>>
        end loop; --<<cur_plant_lanes>>
    end LOOP; -- cur_open_orders
    commit;
          
-----------------------------------------------------------------------------
  -- Begin Collection Deliveries
-----------------------------------------------------------------------------

    for del_rec in cur_del_orders loop
        open cur_get_sm_lane ( del_rec.vll_dest
                              ,del_rec.co_item
                              ,del_rec.vll_source
                              ,del_rec.shipdate
                              );
        fetch cur_get_sm_lane into sm_lane_rec;

        if cur_get_sm_lane%found then
         
           if del_rec.co_item like '%AI%'  then
                sm_lane_rec.remainder := sm_lane_rec.remainder - del_rec.co_qty;
                sm_lane_rec.vl_qty_used :=  sm_lane_rec.vl_qty_used 
                                               + del_rec.co_qty;
 
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
    end LOOP; -- del_orders_loop 
    commit;

  -----------------------------------------------------------------------------
  -- Begin Collection processing for open orders Status =6
  -----------------------------------------------------------------------------
 
    for ord_rec in  cur_open_orders loop
      open cur_collection_lanes(ord_rec.loc, ord_rec.co_item, ord_rec.shipdate);
        
<<sm_coll_loop>> 
      loop
        fetch cur_collection_lanes into sm_collection_rec;
        exit sm_coll_loop when cur_collection_lanes%notfound; 
        
           if ord_rec.co_item like '%AI%'  then                
              sm_plant_rec.remainder := sm_plant_rec.remainder - ord_rec.co_qty;
              sm_plant_rec.co_qty_used :=  sm_plant_rec.co_qty_used 
                                              + ord_rec.co_qty;
                  
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
    end LOOP; -- c_orders_loop
    commit;
-------------------------------------------------------------------------
-------------------------------------------------------------------------
/* Update schedshipdate and sourcing and minleadtime for Open Orders */
 merge into mak_cust_table mct
using (
 select sms.recnum, sms.eff, sms.sourcing, ct.co_orderid, src.minleadtime
   from mak_sm_418_table sms
      , mak_cust_table ct
      , sourcing src
  where ct.status in (1)
    and sms.dest   = ct.loc
    and sms.source = ct.assigned_plant 
    and SMS.ITEM = CT.CO_ITEM
    and sms.eff=ct.shipdate
    and ct.sourcing = src.sourcing
    and ct.sourcing = sms.sourcing
    and sms.sm_totqty > 0
    and src.dest = ct.loc 
    and src.source = ct.assigned_plant 
    and src.item = ct.co_item 
) sm418
on ( mct.co_orderid=sm418.co_orderid)
when matched then
   update set MCT.SCHEDSHIPDATE = SM418.EFF - ROUND(SM418.MINLEADTIME/1440)
            , MCT.SCHEDARRIVDATE = SM418.EFF
            , MCT.SOURCING      = SM418.SOURCING
            , mct.minleadtime   = sm418.minleadtime;
commit;

/* Update schedshipdate and sourcing and minleadtime for Open Orders */
 merge into mak_cust_table mct
using (
 select distinct src.minleadtime, ct.shipdate, ct.co_orderid
   from mak_sm_418_table sms
      , mak_cust_table ct
      , sourcing src
  where ct.status in (4)
    and sms.dest   = ct.loc
    and sms.source = ct.assigned_plant 
    and SMS.ITEM = CT.CO_ITEM
--    and sms.eff=ct.shipdate
    and ct.sourcing = src.sourcing
    and ct.sourcing = sms.sourcing
    and sms.sm_totqty > 0
    and src.dest = ct.loc 
    and src.source = ct.assigned_plant 
    and src.item = ct.co_item 
) sm418
on ( mct.co_orderid=sm418.co_orderid)
when matched then
   update set MCT.SCHEDSHIPDATE = SM418.SHIPDATE - ROUND(SM418.MINLEADTIME/1440)
            , MCT.SCHEDARRIVDATE = SM418.shipdate
            , mct.minleadtime   = sm418.minleadtime;
commit;

/* Update sourcing and minleadtime for deliveries */
 merge into mak_cust_table mct
using (
 select sms.recnum, sms.eff, sms.sourcing, ct.co_orderid, src.minleadtime
   from mak_sm_418_table sms
      , mak_cust_table ct
      , sourcing src
  where ct.status in (2, 3)
    and sms.dest   = ct.loc
    and sms.source = ct.assigned_plant 
    and SMS.ITEM = CT.CO_ITEM
    and sms.eff=ct.shipdate
    and ct.sourcing = src.sourcing
    and ct.sourcing = sms.sourcing
    and sms.sm_totqty > 0
    and src.dest = ct.loc 
    and src.source = ct.assigned_plant 
    and src.item = ct.co_item 
) sm418
on ( mct.co_orderid=sm418.co_orderid)
when matched then
   update set MCT.SOURCING      = SM418.SOURCING
            , mct.minleadtime   = sm418.minleadtime;
commit;

--
--/* Now dow the collecitons  for deliveries*/
 merge into mak_cust_table mct
using (
 select sms.recnum, sms.eff, sms.sourcing, ct.co_orderid, src.minleadtime
   from mak_sm_418_table sms
      , mak_cust_table ct
      , sourcing src
  where ct.status in (5)
    and sms.dest   = ct.assigned_plant
    and sms.source = ct.loc
    and SMS.ITEM = CT.CO_ITEM
    and sms.eff=ct.shipdate
    and ct.sourcing = src.sourcing
    and ct.sourcing = sms.sourcing
    and sms.sm_totqty > 0
    and src.dest = ct.assigned_plant 
    and src.source = ct.loc 
    and src.item = ct.co_item 
) sm418
on ( mct.co_orderid=sm418.co_orderid)
when matched then
   update set mct.schedshipdate    = sm418.eff
            , mct.sourcing     = sm418.sourcing
            , mct.minleadtime  = sm418.minleadtime;
commit;

--/* Now dow the collecitons  for deliveries*/
 merge into mak_cust_table mct
using (
 select sms.recnum, sms.eff, sms.sourcing, ct.co_orderid, src.minleadtime
   from mak_sm_418_table sms
      , mak_cust_table ct
      , SOURCING SRC
  where ct.status =6
    and sms.dest   = ct.assigned_plant
    and sms.source = ct.loc
    and SMS.ITEM = CT.CO_ITEM
    and sms.eff=ct.shipdate
    and ct.sourcing = src.sourcing
    and ct.sourcing = sms.sourcing
    and sms.sm_totqty > 0
    and src.dest = ct.assigned_plant 
    and src.source = ct.loc 
    and src.item = ct.co_item 
) sm418
on ( mct.co_orderid=sm418.co_orderid)
when matched then
   update set mct.schedshipdate    = sm418.eff
            , MCT.SOURCING     = SM418.SOURCING
            , MCT.SCHEDARRIVDATE = SM418.eff
            , MCT.MINLEADTIME  = SM418.MINLEADTIME;
commit;


merge into mak_cust_table mct
using (
    select item, source, dest
      from udt_llamasoft_data 
) LL
on ( mct.co_item=ll.item and mct.assigned_plant=ll.source and mct.loc=ll.dest)
when matched then
   update set MCT.P1=1;
commit;

update mak_cust_table mct
  set p1=2
where not exists ( select 1 
                     from udt_llamasoft_data ll 
                    where ll.item=mct.co_item 
                      and ll.dest=mct.loc);
commit;

---------------------------------------------------------------------------
---------------------------------------------------------------------------
        update mak_cust_table co
            set co.firmsw = 1
          where co.status in (1,4)
            and co.u_sales_document='Z1AA'
            and co.u_ship_condition='Z2'
            and TRIM(CO.SOURCING) is not null
            and CO.SHIPDATE <= TRUNC(sysdate) + 5;
            
          commit;


       update mak_cust_table co
            set co.sourcing = 'UNPLANNED'
              , co.minleadtime=0
              , co.assigned_plant = case when vll_source is not null then vll_source 
                                         else 'US9X' 
                                    end
          where co.status =9;
          commit;

        update mak_cust_table co
            set co.sourcing = 'UNMET'
              , co.minleadtime=0
          where co.status = 0;
          commit;

        update mak_cust_table co
            set co.sourcing='UNPLANNED'
              , co.assigned_plant = vll_source
              , co.minleadtime=0
          where co.status = 10;
          commit;

/* Assign the Rate type 
===> Need to re-write I am missing ISS1EXCL and ISS9DEL LANES
*/          
   merge into mak_cust_table peo
using
( select co_orderid, U_RATE_TYPE
  from ( select PE.co_orderid, CT.U_RATE_TYPE
  from mak_cust_table pe, loc ld, loc ls,
       UDT_SOURCING_DEFINITIONS SD   , UDT_COST_TRANSIT_NA CT
 where LD.LOC            = PE.loc
   and ls.loc            = pe.assigned_plant
   and ct.u_equipment_type = decode( ld.u_equipment_type, 'FB', 'FB', 'VN')
   and pe.sourcing    = sd.sourcing
   and( 
       ( sd.zip_type in( '5', 'NA' ) and ct.source_pc   = ls.postalcode and ct.dest_pc = ld.postalcode )
       or( SD.ZIP_TYPE    = '3' and CT.SOURCE_GEO  = LS.U_3DIGITZIP and CT.DEST_GEO    = LD.U_3DIGITZIP )
   ))
) ta on (ta.co_orderid = peo.co_orderid)
when matched then update 
    set peo.u_rate_type = ta.u_rate_type;
    
commit;
     


   end;   -- end of procedure mak_assign_orders
end; -- end of begin
