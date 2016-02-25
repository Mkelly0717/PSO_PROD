--------------------------------------------------------
--  DDL for View UDV_SKUCONSTR_NO_3ZIP_COSTTRN
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_SKUCONSTR_NO_3ZIP_COSTTRN" ("ITEM", "LOC", "TOTALDEMAND", "3DigitZip", "U_EQUIPMENT_TYPE") AS 
  with total_demand ( item, loc, totaldemand) as
    (select skc.item
      ,skc.loc
      ,round(sum(skc.qty),1) as totaldemand
    from skuconstraint skc
    where skc.category=1
        and skc.qty > 0
    group by skc.item
      , skc.loc
    )
select td.item
  ,td.loc
  ,td.totaldemand
  ,l.u_3digitzip "3DigitZip"
  ,l.u_equipment_type
from total_demand td
  , loc l
  , udt_cost_transit_na ct
where td.loc=l.loc
    and l.u_3digitzip=ct.dest_geo(+)
    and ct.dest_geo is null
