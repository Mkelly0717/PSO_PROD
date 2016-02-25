--------------------------------------------------------
--  DDL for Table UDT_SKUCONSTRAINT_TEMP
--------------------------------------------------------

  CREATE TABLE "SCPOMGR"."UDT_SKUCONSTRAINT_TEMP" 
   (	"EFF" DATE, 
	"POLICY" NUMBER(*,0), 
	"QTY" FLOAT(126), 
	"DUR" NUMBER(*,0), 
	"CATEGORY" NUMBER(*,0), 
	"ITEM" VARCHAR2(50 CHAR), 
	"LOC" VARCHAR2(50 CHAR), 
	"QTYUOM" NUMBER(*,0)
   ) 

   COMMENT ON TABLE "SCPOMGR"."UDT_SKUCONSTRAINT_TEMP"  IS 'This table is used to fill in missing dates for reporting purposes. It uses a catesioan join by distinct days and then updates the quantities for th ematching days.'
