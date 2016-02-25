--------------------------------------------------------
--  DDL for Table UDT_SOURCINGRESMETRIC_DY
--------------------------------------------------------

  CREATE TABLE "SCPOMGR"."UDT_SOURCINGRESMETRIC_DY" 
   (	"SOURCING" VARCHAR2(50 CHAR), 
	"ITEM" VARCHAR2(50 CHAR), 
	"DEST" VARCHAR2(50 CHAR), 
	"SOURCE" VARCHAR2(50 CHAR), 
	"RES" VARCHAR2(101 CHAR), 
	"EFF" DATE, 
	"CATEGORY" NUMBER(*,0), 
	"VALUE" FLOAT(126), 
	"DUR" NUMBER(*,0), 
	"CURRENCYUOM" NUMBER(*,0), 
	"QTYUOM" NUMBER(*,0), 
	"SIMULATION_NAME" VARCHAR2(50 CHAR)
   )
