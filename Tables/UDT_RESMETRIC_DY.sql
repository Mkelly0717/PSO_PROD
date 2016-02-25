--------------------------------------------------------
--  DDL for Table UDT_RESMETRIC_DY
--------------------------------------------------------

  CREATE TABLE "SCPOMGR"."UDT_RESMETRIC_DY" 
   (	"EFF" DATE, 
	"VALUE" FLOAT(126), 
	"DUR" NUMBER(*,0), 
	"CATEGORY" NUMBER(*,0), 
	"RES" VARCHAR2(101 CHAR), 
	"CURRENCYUOM" NUMBER(*,0), 
	"TIMEUOM" NUMBER(*,0), 
	"QTYUOM" NUMBER(*,0), 
	"SETUP" VARCHAR2(50 CHAR), 
	"SIMULATION_NAME" VARCHAR2(50 CHAR)
   )
