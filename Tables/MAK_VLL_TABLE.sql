--------------------------------------------------------
--  DDL for Table MAK_VLL_TABLE
--------------------------------------------------------

  CREATE TABLE "SCPOMGR"."MAK_VLL_TABLE" 
   (	"STATUS" NUMBER, 
	"SM_RECORD" NUMBER, 
	"LOADID" VARCHAR2(50 CHAR), 
	"DEST" VARCHAR2(50 CHAR), 
	"SOURCE" VARCHAR2(50 CHAR), 
	"ITEM" VARCHAR2(50 CHAR), 
	"SCHEDSHIPDATE" DATE, 
	"SCHEDARRIVDATE" DATE, 
	"QTY" FLOAT(126), 
	"ORDERID" NUMBER(*,0), 
	"EFF_SR" DATE, 
	"SFF_AR" DATE, 
	"SRCNG_SR" VARCHAR2(50 CHAR), 
	"SRCNG_AR" VARCHAR2(50 CHAR)
   )
