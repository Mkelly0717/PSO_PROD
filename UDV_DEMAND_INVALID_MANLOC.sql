--------------------------------------------------------
--  DDL for View UDV_DEMAND_INVALID_MANLOC
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_DEMAND_INVALID_MANLOC" ("LOC", "ITEM", "QTY", "MANDATORY_LOC") AS 
  with demand as
    (select loc
      , item
      , sum(qty) qty
    from skuconstraint skc
    where category=1
    group by loc
      , item
    having sum(qty) > 0
    )
select distinct dmd.loc
  , dmd.item
  , dmd.qty
  , gl.mandatory_loc
from demand dmd
  , udt_gidlimits_na gl
where dmd.loc=gl.loc
    and gl.item=dmd.item
    and gl.mandatory_loc is not null
    and ( not exists
    ( select 1 from sourcing src where src.dest=dmd.loc and src.item=dmd.item
    )
    or not exists
    (select 1
    from loc l
    where l.loc=gl.mandatory_loc
        and l.loc_type in (1,2,4,5)
    ) )
order by dmd.loc asc
  , dmd.item asc
