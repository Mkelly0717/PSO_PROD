--------------------------------------------------------
--  DDL for View UDV_SKUCONSTR_NO_3ZIP_SUMMARY
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_SKUCONSTR_NO_3ZIP_SUMMARY" ("3DigitZip", "U_EQUIPMENT_TYPE", "NUMBERGLIDS") AS 
  select "3DigitZip"
      , u_equipment_type
      , count(1) numberglids
    from udv_skuconstr_no_3zip_costtrn
    group by "3DigitZip"
      , u_equipment_type
