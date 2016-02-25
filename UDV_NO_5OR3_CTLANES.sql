--------------------------------------------------------
--  DDL for View UDV_NO_5OR3_CTLANES
--------------------------------------------------------

  CREATE OR REPLACE VIEW "SCPOMGR"."UDV_NO_5OR3_CTLANES" ("ITEM", "LOC", "U_EQUIPMENT_TYPE", "TOTALDEMAND", "POSTALCODE", "3Zip") AS 
  select n5z.item
      ,n5z.loc
      ,n5z.u_equipment_type
      ,n5z.totaldemand
      ,n5z.postalcode
      ,substr(n5z.postalcode,1,3) as "3Zip"
    from udv_skuconstr_no_5zip_costtrn n5z
    where exists
        (select 1
        from udv_skuconstr_no_3zip_costtrn n3z
        where n3z.loc =n5z.loc
            and n3z.item =n5z.item
            and n3z.u_equipment_type=n5z.u_equipment_type
        )
