--------------------------------------------------------
--  DDL for Table MAK_SM_TABLE
--------------------------------------------------------

  CREATE TABLE "SCPOMGR"."MAK_SM_TABLE" 
   (	"RECNUM" NUMBER, 
	"ITEM" VARCHAR2(50 CHAR), 
	"DEST" VARCHAR2(50 CHAR), 
	"SOURCE" VARCHAR2(50 CHAR), 
	"EFF" DATE, 
	"SM_TOTQTY" NUMBER, 
	"REMAINDER" NUMBER, 
	"VL_QTY_USED" NUMBER, 
	"P1" NUMBER DEFAULT 0, 
	"CO_QTY_USED" NUMBER DEFAULT 0, 
	"DUR" NUMBER DEFAULT 0
   )
