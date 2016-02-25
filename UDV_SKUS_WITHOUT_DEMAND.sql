--------------------------------------------------------
--  DDL for View UDV_SKUS_WITHOUT_DEMAND
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_SKUS_WITHOUT_DEMAND" ("LOC", "ITEM", "LOC_TYPE") AS 
  select distinct sku.loc
      , sku.item
      , l.loc_type
    from sku sku
      , loc l
    where sku.loc=l.loc
        and not exists
        (select 1
        from skuconstraint sc
        where sku.loc=sc.loc
            and sku.item= sc.item
            and category=1
            and qty > 0
        )
    order by sku.loc asc
      , sku.item asc
