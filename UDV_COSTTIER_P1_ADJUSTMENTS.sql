--------------------------------------------------------
--  DDL for View UDV_COSTTIER_P1_ADJUSTMENTS
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_COSTTIER_P1_ADJUSTMENTS" ("COST", "VALUE", "NEW_VALUE") AS 
  SELECT cost,
    value value,
    value - value * p1lcm.numval1 new_value
  FROM mak_costtier_table ct,
    udt_default_parameters p1lcm,
    (SELECT source,
      dest
    FROM udt_llamasoft_data ld
    WHERE ld.hasdemand      =1
    AND ld.haslane          =1
    AND ld.costtransitrank <> 1
    ) llama
  where p1lcm.name='P1LCM'
  and ct.source=llama.source
  and ct.dest=llama.dest
