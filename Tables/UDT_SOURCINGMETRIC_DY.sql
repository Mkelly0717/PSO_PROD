--------------------------------------------------------
--  DDL for Table UDT_SOURCINGMETRIC_DY
--------------------------------------------------------

  CREATE TABLE "SCPOMGR"."UDT_SOURCINGMETRIC_DY" 
   (	"SOURCING" VARCHAR2(50 CHAR), 
	"ITEM" VARCHAR2(50 CHAR), 
	"DEST" VARCHAR2(50 CHAR), 
	"SOURCE" VARCHAR2(50 CHAR), 
	"EFF" DATE, 
	"VALUE" FLOAT(126), 
	"DUR" NUMBER(*,0), 
	"CATEGORY" NUMBER(*,0), 
	"CURRENCYUOM" NUMBER(*,0), 
	"QTYUOM" NUMBER(*,0), 
	"SIMULATION_NAME" VARCHAR2(50 CHAR)
   )
