--------------------------------------------------------
--  DDL for View UDV_SKUCONSTR_NO_PC_SUMMARY
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_SKUCONSTR_NO_PC_SUMMARY" ("POSTALCODE", "U_EQUIPMENT_TYPE", "NUMBERGLIDS") AS 
  select postalcode
      , u_equipment_type
      , count(1) numberglids
    from udv_skuconstr_no_5zip_costtrn
    group by postalcode
      , u_equipment_type
