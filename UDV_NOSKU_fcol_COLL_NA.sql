--------------------------------------------------------
--  DDL for View UDV_NOSKU_fcol_COLL_NA
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_NOSKU_fcol_COLL_NA" ("PLANT", "ITEM") AS 
  select distinct fcol.plant
      , i.item
    from udt_fixed_coll fcol
      , item i
      , loc l
    where i.u_stock = 'A'
        and i.item like '4%AI'
        and l.loc=fcol.plant
        and l.loc_type='2'
        and not exists
        ( select 1 from sku sku where sku.loc=fcol.plant and sku.item = i.item
        )
    order by fcol.plant asc
      , i.item asc
