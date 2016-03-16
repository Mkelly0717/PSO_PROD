--------------------------------------------------------
--  DDL for Procedure MAK_TEST
--------------------------------------------------------
set define off;

  CREATE OR REPLACE PROCEDURE "SCPOMGR"."MAK_TEST" as


v_delivery_issues_pen number;
v_delivery_ai_collections_pen number;
v_delivery_aw_collections_pen number;

v_percent_qty_threshold number;

begin
     
  select numval1 into v_delivery_issues_pen
    from udt_default_parameters dfp
    where dfp.name='DELIVERY_ISSUES_PENALTY' ;
    
  select numval1 into v_delivery_ai_collections_pen
    from udt_default_parameters dfp
    where dfp.name='DELIVERY_AI_COLLECTIONS_PENALTY' ;
    
  select numval1 into v_delivery_aw_collections_pen
    FROM UDT_DEFAULT_PARAMETERS DFP
    where dfp.name='DELIVERY_AW_COLLECTIONS_PENALTY' ;
    
  select numval1 into v_percent_qty_threshold
    from udt_default_parameters dfp
    where dfp.name='PEGGING_QTY_THRESHOLD' ;
    
    
dbms_output.put_line(  'V_DELIVERY_ISSUES_PEN         := ' || v_delivery_issues_pen );
dbms_output.put_line(  'V_DELIVERY_AI_COLLECTIONS_PEN := ' || v_delivery_ai_collections_pen );
dbms_output.put_line(  'V_DELIVERY_AW_COLLECTIONS_PEN := ' || v_delivery_aw_collections_pen);
dbms_output.put_line(  'V_PERCENT_QTY_THRESHOLD := ' || v_percent_qty_threshold);

declare
  cursor cur_selected is
    select c.item, c.dest, c.source, c.sourcing, t.transittime,
    case when t.transittime < 1 then 0 else round(t.transittime, 0)*1440 end transittime_new
    from sourcing c, u_42_src_costs_na2 t
    where c.item = t.item
    and c.dest = t.dest
    and c.source = t.source 
for update of c.minleadtime;

begin
  for cur_record in cur_selected loop
if cur_record.transittime_new > 100000 then
       dbms_output.put_line(  'item := ' || cur_record.item);
       dbms_output.put_line(  'source := ' || cur_record.source);
       dbms_output.put_line(  'dest := ' || cur_record.dest);
       dbms_output.put_line(  'sourcing := ' || cur_record.sourcing);
       dbms_output.put_line(  'transittime := ' || cur_record.transittime);
       dbms_output.put_line(  'transittime_new := ' || cur_record.transittime_new);
end if;
  
    update sourcing
    set minleadtime = cur_record.transittime_new
    where current of cur_selected;
    
  end loop;
--  commit;
end;

--execute immediate 'truncate table udt_vehicleload_orig';
--insert into udt_vehicleload_orig
--    ( lbsource          , arrivdate        , shipdate             , lsrulemetsw
--    , loadsw            , statusdescr      , lbstatus             , grouporderid
--    , transmode         , deststatus       , orderid              , tolerancecapmetsw
--    , lanegroupid       , loadid           , vendorminmetsw       , lanegroupminmetsw
--    , descr             , transmodeminmetsw, sourcestatus         , consolidatedloadseqnum
--    , maxcapacitymetsw  , statusdesc       , maxcapacityexceededsw, updated
--    , ff_trigger_control, orderoptseqnum   , approvalstatus       , exported
--    )
--    select 
--      lbsource              , arrivdate        , shipdate          , lsrulemetsw
--    , loadsw                , statusdescr      , lbstatus          , grouporderid
--    , transmode             , deststatus       , orderid           , tolerancecapmetsw
--    , lanegroupid           , loadid           , vendorminmetsw    , lanegroupminmetsw
--    , descr                 , transmodeminmetsw, sourcestatus      ,
--      consolidatedloadseqnum, maxcapacitymetsw , statusdesc        ,
--      maxcapacityexceededsw , updated          , ff_trigger_control,
--      orderoptseqnum        , approvalstatus   , exported
--    from vehicleload;
--    
--    
--
--execute immediate 'truncate table udt_vehicleloadline_orig';
--   insert
--     into udt_vehicleloadline_orig
--    (
--      cancelsw      , lbsource       , sourcing     , item
--    , dest          , supplymethod   , actionqty    , schedarrivdate
--    , grouporderid  , source         , schedshipdate, orderid
--    , primaryitem   , drawqty        , qty          , supplyid
--    , expdate       , loadlineid     , loadid       , action
--    , actiondate    , actionallowedsw, mustgoqty    , revisedexpdate
--    , primaryitemqty, ordernum       , reviseddate  , ff_trigger_control
--    , supporderqty  , seqnum         , u_overallsts
--    )
--    select cancelsw          , lbsource       , sourcing     , item
--    , dest              , supplymethod   , actionqty    , schedarrivdate
--    , grouporderid      , source         , schedshipdate, orderid
--    , primaryitem       , drawqty        , qty          , supplyid
--    , expdate           , loadlineid     , loadid       , action
--    , actiondate        , actionallowedsw, mustgoqty    , revisedexpdate
--    , primaryitemqty    , ordernum       , reviseddate  ,
--      ff_trigger_control, supporderqty   , seqnum       , u_overallsts
--    from vehicleloadline;
--
--
--execute immediate 'truncate table udt_custorder_orig';
--   insert into udt_custorder_orig
--    (
--      maxlatedur        , arrivtransmode, headerextref    , loc
--    , promisedqty       , arrivleadtime , cost            , ordertype
--    , shipcompletesw    , resexp        , u_sales_document, u_ship_condition
--    , shipsw            , margin        , reservation     , cust
--    , overridefcsttypesw, atpexcludesw  , workscope       , lifecyclestatus
--    , firmsw            , arrivtranszone, priorityseqnum  , shipdate
--    , maxearlydur       , orderlineitem , substoperator   , supersedesw
--    , promiseddate      , item          , project         , dfuloc
--    , substlevel        , status        , u_z1banum       , u_item
--    , orderid           , qty           , fcsttype        , calcpriority
--    , priority          , dmdunit       , u_dmdgroup_code , fcstsw
--    , dmdgroup          , revenue       , orderseqnum     , ff_trigger_control
--    , unitprice         , lineitemextref, u_defplant
--    )
--    select maxlatedur    ,arrivtransmode,headerextref    ,loc
--          ,promisedqty       ,arrivleadtime ,cost            ,ordertype
--          ,shipcompletesw    ,resexp        ,u_sales_document,u_ship_condition
--          ,shipsw            ,margin        ,reservation     ,cust
--          ,overridefcsttypesw,atpexcludesw  ,workscope       ,lifecyclestatus
--          ,firmsw            ,arrivtranszone,priorityseqnum  ,shipdate
--          ,maxearlydur       ,orderlineitem ,substoperator   ,supersedesw
--          ,promiseddate      ,item          ,project         ,dfuloc
--          ,substlevel        ,status        ,u_z1banum       ,u_item
--          ,orderid           ,qty           ,fcsttype        ,calcpriority
--          ,priority          ,dmdunit       ,u_dmdgroup_code ,fcstsw
--          ,dmdgroup          ,revenue       ,orderseqnum
--          ,ff_trigger_control,unitprice     ,lineitemextref  ,u_defplant
--  from custorder;
--  
--  commit;
end;
