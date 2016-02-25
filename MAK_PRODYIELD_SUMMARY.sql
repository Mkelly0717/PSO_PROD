--------------------------------------------------------
--  DDL for View MAK_PRODYIELD_SUMMARY
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."MAK_PRODYIELD_SUMMARY" ("LOC", "ITEM", "PM", "OI", "YIELD_QTY", "MAXCAP", "LOC_TYPE", "DESCR", "STATE", "U_AREA") AS 
  select py1.loc loc
      ,py1.item item
      ,py1.productionmethod pm
      ,py1.outputitem oi
      ,py1.yieldqty yield_qty
      ,y.maxcap maxcap
      ,l.loc_type
      ,l.descr
      ,l.u_state state
      ,l.u_area
    from productionyield py1
      , loc l
      , item i
      , udt_yield_na y
    where py1.loc=l.loc --  and l.loc='US8Y'
        and l.u_area='NA'
        and l.enablesw=1
        and i.item=py1.item
        and i.enablesw=1
        and y.loc=py1.loc
        and y.item=py1.outputitem
        and y.productionmethod=py1.productionmethod
    order by py1.loc
      , py1.productionmethod
      , py1.item
