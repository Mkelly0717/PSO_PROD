--------------------------------------------------------
--  DDL for Table UDT_SOURCINGMETRIC_RB
--------------------------------------------------------

  CREATE TABLE "SCPOMGR"."UDT_SOURCINGMETRIC_RB" 
   (	"SOURCING" VARCHAR2(50 CHAR), 
	"ITEM" VARCHAR2(50 CHAR), 
	"DEST" VARCHAR2(50 CHAR), 
	"SOURCE" VARCHAR2(50 CHAR), 
	"EFF" DATE, 
	"VALUE" FLOAT(126), 
	"DUR" NUMBER(38,0), 
	"CATEGORY" NUMBER(38,0), 
	"CURRENCYUOM" NUMBER(38,0), 
	"QTYUOM" NUMBER(38,0)
   )
