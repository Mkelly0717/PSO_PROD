--------------------------------------------------------
--  DDL for Table UDT_EQUIPMENT_CONVERSION
--------------------------------------------------------

  CREATE TABLE "SCPOMGR"."UDT_EQUIPMENT_CONVERSION" 
   (	"COMPANYID" VARCHAR2(50) DEFAULT ' ', 
	"U_AREA" VARCHAR2(50) DEFAULT ' ', 
	"EQUIPMENT_NATIVE" VARCHAR2(50) DEFAULT ' ', 
	"U_EQUIPMENT_TYPE" VARCHAR2(20) DEFAULT ' '
   ) 

   COMMENT ON COLUMN "SCPOMGR"."UDT_EQUIPMENT_CONVERSION"."U_AREA" IS 'This matches the value in the U_AREA table'
   COMMENT ON COLUMN "SCPOMGR"."UDT_EQUIPMENT_CONVERSION"."EQUIPMENT_NATIVE" IS 'This is the Actual Rquipment type as it comes from Seibel.'
   COMMENT ON COLUMN "SCPOMGR"."UDT_EQUIPMENT_CONVERSION"."U_EQUIPMENT_TYPE" IS 'This is the Value of general equipment type. I.E. FB or VN. Loc.U_Equipment_Type will be updated with this value and it will be used when accesing the UDT_COST_TRANSIT table.'
