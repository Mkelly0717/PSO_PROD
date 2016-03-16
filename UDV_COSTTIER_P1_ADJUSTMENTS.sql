--------------------------------------------------------
--  DDL for View UDV_COSTTIER_P1_ADJUSTMENTS
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_COSTTIER_P1_ADJUSTMENTS" ("COST", "VALUE", "NEW_VALUE") AS 
  select cost                 , value value                 , value - value * p1lcm.numval1 new_value
     from mak_costtier_table ct, udt_default_parameters p1lcm,(select distinct source,
      dest
       from udt_llamasoft_data ld
      where ld.hasdemand = 1 and ld.haslane = 1 and ld.costtransitrank <> 1
    ) llama
    where p1lcm.name = 'P1LCM' and ct.source = llama.source and ct.dest =
    llama.dest
