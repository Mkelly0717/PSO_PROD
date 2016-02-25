--------------------------------------------------------
--  DDL for Table UDT_PLANT_CAPABILITIES
--------------------------------------------------------

  CREATE TABLE "SCPOMGR"."UDT_PLANT_CAPABILITIES" 
   (	"CAPABILITY" VARCHAR2(30 CHAR), 
	"STATUS" VARCHAR2(30 CHAR), 
	"DESCRIPTION" VARCHAR2(100)
   ) 

   COMMENT ON COLUMN "SCPOMGR"."UDT_PLANT_CAPABILITIES"."DESCRIPTION" IS 'Should be set to non nullable later.'
