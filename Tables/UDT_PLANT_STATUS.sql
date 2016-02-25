--------------------------------------------------------
--  DDL for Table UDT_PLANT_STATUS
--------------------------------------------------------

  CREATE TABLE "SCPOMGR"."UDT_PLANT_STATUS" 
   (	"LOC" VARCHAR2(30 CHAR), 
	"U_MATERIALCODE" VARCHAR2(30 CHAR), 
	"U_STOCK" VARCHAR2(30 CHAR), 
	"RES" VARCHAR2(30 CHAR), 
	"STATUS" VARCHAR2(30 CHAR), 
	"U_EQUIPMENT_TYPE" VARCHAR2(50) DEFAULT ' '
   )
