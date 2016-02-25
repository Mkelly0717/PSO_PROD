--------------------------------------------------------
--  DDL for Table MAK_SOURCINGMETRIC
--------------------------------------------------------

  CREATE TABLE "SCPOMGR"."MAK_SOURCINGMETRIC" 
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
	"U_Z1BANUM" VARCHAR2(50 CHAR)
   )
