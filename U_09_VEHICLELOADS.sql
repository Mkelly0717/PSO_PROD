--------------------------------------------------------
--  DDL for Procedure U_09_VEHICLELOADS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."U_09_VEHICLELOADS" AS 
BEGIN


/******************************************************************
** Part 1: Backup the Vehicle Load table                          *
*******************************************************************/
execute immediate 'truncate table udt_vehicleload_orig';
insert into udt_vehicleload_orig
    ( lbsource          , arrivdate        , shipdate             , lsrulemetsw
    , loadsw            , statusdescr      , lbstatus             , grouporderid
    , transmode         , deststatus       , orderid              , tolerancecapmetsw
    , lanegroupid       , loadid           , vendorminmetsw       , lanegroupminmetsw
    , descr             , transmodeminmetsw, sourcestatus         , consolidatedloadseqnum
    , maxcapacitymetsw  , statusdesc       , maxcapacityexceededsw, updated
    , ff_trigger_control, orderoptseqnum   , approvalstatus       , exported
    )
    select 
      lbsource              , arrivdate        , shipdate          , lsrulemetsw
    , loadsw                , statusdescr      , lbstatus          , grouporderid
    , transmode             , deststatus       , orderid           , tolerancecapmetsw
    , lanegroupid           , loadid           , vendorminmetsw    , lanegroupminmetsw
    , descr                 , transmodeminmetsw, sourcestatus      ,
      consolidatedloadseqnum, maxcapacitymetsw , statusdesc        ,
      maxcapacityexceededsw , updated          , ff_trigger_control,
      orderoptseqnum        , approvalstatus   , exported
    from vehicleload;
commit;    
    
/******************************************************************
** Part 2: Backup the Vehicle Load Line table                     *
*******************************************************************/
execute immediate 'truncate table udt_vehicleloadline_orig';
   insert
     into udt_vehicleloadline_orig
    (
      cancelsw      , lbsource       , sourcing     , item
    , dest          , supplymethod   , actionqty    , schedarrivdate
    , grouporderid  , source         , schedshipdate, orderid
    , primaryitem   , drawqty        , qty          , supplyid
    , expdate       , loadlineid     , loadid       , action
    , actiondate    , actionallowedsw, mustgoqty    , revisedexpdate
    , primaryitemqty, ordernum       , reviseddate  , ff_trigger_control
    , supporderqty  , seqnum         , u_overallsts
    )
    select cancelsw          , lbsource       , sourcing     , item
    , dest              , supplymethod   , actionqty    , schedarrivdate
    , grouporderid      , source         , schedshipdate, orderid
    , primaryitem       , drawqty        , qty          , supplyid
    , expdate           , loadlineid     , loadid       , action
    , actiondate        , actionallowedsw, mustgoqty    , revisedexpdate
    , primaryitemqty    , ordernum       , reviseddate  ,
      ff_trigger_control, supporderqty   , seqnum       , u_overallsts
    from vehicleloadline;
commit;


/******************************************************************
** Part 3: Back up the Custorder table!
*******************************************************************/
execute immediate 'truncate table udt_custorder_orig';
   insert into udt_custorder_orig
    (
      maxlatedur        , arrivtransmode, headerextref    , loc
    , promisedqty       , arrivleadtime , cost            , ordertype
    , shipcompletesw    , resexp        , u_sales_document, u_ship_condition
    , shipsw            , margin        , reservation     , cust
    , overridefcsttypesw, atpexcludesw  , workscope       , lifecyclestatus
    , firmsw            , arrivtranszone, priorityseqnum  , shipdate
    , maxearlydur       , orderlineitem , substoperator   , supersedesw
    , promiseddate      , item          , project         , dfuloc
    , substlevel        , status        , u_z1banum       , u_item
    , orderid           , qty           , fcsttype        , calcpriority
    , priority          , dmdunit       , u_dmdgroup_code , fcstsw
    , dmdgroup          , revenue       , orderseqnum     , ff_trigger_control
    , unitprice         , lineitemextref, u_defplant
    )
    select maxlatedur    ,arrivtransmode,headerextref    ,loc
          ,promisedqty       ,arrivleadtime ,cost            ,ordertype
          ,shipcompletesw    ,resexp        ,u_sales_document,u_ship_condition
          ,shipsw            ,margin        ,reservation     ,cust
          ,overridefcsttypesw,atpexcludesw  ,workscope       ,lifecyclestatus
          ,firmsw            ,arrivtranszone,priorityseqnum  ,shipdate
          ,maxearlydur       ,orderlineitem ,substoperator   ,supersedesw
          ,promiseddate      ,item          ,project         ,dfuloc
          ,substlevel        ,status        ,u_z1banum       ,u_item
          ,orderid           ,qty           ,fcsttype        ,calcpriority
          ,priority          ,dmdunit       ,u_dmdgroup_code ,fcstsw
          ,dmdgroup          ,revenue       ,orderseqnum
          ,ff_trigger_control,unitprice     ,lineitemextref  ,u_defplant
  from custorder;
  commit;


/******************************************************************
** Part 4: Delete Custorders where the vehiclle load is in the past.
*******************************************************************/
merge into custorder co
using
( select vll.orderid orderid
            from vehicleloadline vll, loc l
           where vll.dest=l.loc
             and l.u_area='NA'
             and u_overallsts='C'
             and vll.schedarrivdate < trunc(sysdate)
) vllq 
on (vllq.orderid = co.orderid)
when matched then 
     update set status=1
     delete where 1=1;

/******************************************************************
** Part 5: Delete vehicleloads where the vehicle load is in the past.
*******************************************************************/
merge into vehicleload vl
using
( select vll.loadid loadid
            from vehicleloadline vll, loc l
           where vll.dest=l.loc
             and l.u_area='NA'
             and u_overallsts='C'
             and vll.schedarrivdate < trunc(sysdate)
) vllq 
on (vllq.loadid = vl.loadid)
when matched then 
     update set updated=1
     delete where 1=1;
     
/******************************************************************
** Part 6: Update the vehicle load sourcestatus to be determined 
**         by the UDC U_overallsts on vehicleloadline table.
*******************************************************************/
    
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

/******************************************************************
** Part 7: Update the Vehicleloadline.schedshipdate to account 
**         for the leadtime from udt_cost_transit_na. (Returns)
*******************************************************************/
merge into vehicleloadline vll0
using
(select vll.loadid 
     , case when v_transitleadtime(vll.source, vll.dest)< 1 then 0
            else round(v_transitleadtime(vll.source, vll.dest))*1440
     end transittime
   from vehicleloadline vll, loc ld, custorder co
  where co.orderid=vll.orderid
   and ld.loc = vll.dest
   and ld.u_area='NA'
   and co.u_ship_condition = 'Z1'
   and co.u_sales_document <> 'Z1D1'
   and v_transitleadtime(vll.source, vll.dest) <> 99999
) ta on (ta.loadid = vll0.loadid)
when matched then update 
    set vll0.schedshipdate = vll0.schedarrivdate - ta.transittime;
commit;


/******************************************************************
** Part 8: Update the Vehicleloadline.schedshipdate to account
**         for leadtime from udt_cost_transit_na. (Issues)
*******************************************************************/
merge into vehicleloadline vll0
using
(select vll.loadid 
     , case when v_transitleadtime(vll.source, vll.dest)< 1 then 0
            else round(v_transitleadtime(vll.source, vll.dest))*1440
     end transittime
  from vehicleloadline vll, loc ld, custorder co
 where ld.loc            = vll.dest
   and ld.u_area='NA'
   and co.orderid=vll.orderid
   and co.u_ship_condition = 'Z2'
   and co.u_sales_document <> 'Z1D1'
   and v_transitleadtime(vll.source, vll.dest) <> 99999
) ta on (ta.loadid = vll0.loadid)
when matched then update 
    set vll0.schedarrivdate = vll0.schedshipdate + ta.transittime;
commit;
    
/******************************************************************
** Part 9: Update the arrivdate on the vehicleload table for 
**         consistency
*******************************************************************/
merge into vehicleload vl0
using
(select vll.loadid, vll.schedshipdate, vll.schedarrivdate 
   from vehicleloadline vll
) ta on (ta.loadid = vl0.loadid)
when matched then update 
    set vl0.arrivdate = ta.schedarrivdate;
    
    
/******************************************************************
** Part 10: Update the The Order qty to match the vehicleload qty.
*******************************************************************/
merge into custorder co
using
( SELECT vll.orderid, vll.qty
  from vehicleloadline vll, loc l
  where l.loc=vll.dest
    and l.u_area='NA' 
) vllq on (vllq.orderid = co.orderid)
when matched then update 
    set co.qty = vllq.qty;
commit;    

/******************************************************************
** Part 11: Update the Custorder Date for Issue to 
**         the schedarrivdate. Since I already updated the vll table
**         I can get teh new date from there. (Issues)
*******************************************************************/
merge into custorder co
using
( SELECT vll.orderid, vll.schedarrivdate
  from vehicleloadline vll, loc l
  where l.loc=vll.dest
    and l.u_area='NA' 
    and vll.item like '4%RU%'
) vllq on (vllq.orderid = co.orderid)
when matched then update 
    set co.shipdate = vllq.schedarrivdate;

END;



--====================================================================
-- Old replaced code. Check against new code then remove from here!!--
--====================================================================

--/* Run this code to set the order qty to agree with the vehicle load qty.*/
--UPDATE custorder co1
--SET co1.qty=
--  (SELECT max( vll.qty)
--  from custorder co,
--    vehicleloadline vll,
--    loc l
--  WHERE co1.orderid =co.orderid
--  and vll.orderid =co.orderid
--  and vll.qty    <> co.qty
--  and l.loc=co.loc
--  and l.u_area='NA'
--  )
--WHERE EXISTS
--(SELECT 1
--  from custorder co,
--    vehicleloadline vll,
--    loc l
--  WHERE co1.orderid =co.orderid
--  and vll.orderid =co.orderid
--  and vll.qty    <> co.qty
----  and vll.u_overallsts='C'
--  and l.loc=co.loc
--  and l.u_area='NA'
--);
--
--commit;

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
